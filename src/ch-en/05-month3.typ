#import "../lib-en.typ": *

= Month 3. Memory that doesn't deflate

By week twelve: PostgreSQL, a real create-read-update-delete set, Flyway migrations, tests. No microservices, and if someone whispers "let's add Kafka" — that's a siren from the next station over, don't listen. Stuck on Hibernate for three days? Welcome to the profession. You stay here. You don't skip "ahead."

Until now the tasks lived in an `ArrayList`. Restart Spring — the list is empty, like the corridor after night watch. The file from month 1 already knew how to survive the close button. A database is the same gesture, only with a language that can search without reading everything from the start, and with an iron rule: two people must not wreck the same row at the same time so the station splits in two.

#rhythm[
  *Mon–Thu:* 40 min Lisp (files, nested lists, toy "transactions") + 120 min Java (psql, JPA, tests). \
  *Friday:* finish the red Hibernate. No new Spring starters. \
  *Saturday:* your CRUD all the way: schema in the README, curl for four gestures, a dozen tests. \
  *Sunday:* sabotage — a tiny "database" in a file. After that, Postgres will seem polite.
]

#rule[
  Hands in `psql` first. Then Java. Anyone who slaps `@Entity` on a table that only exists in their head will spend three days reading `Caused by` and blaming the universe. The universe is innocent. The column is missing.
]

#lesson(9, [Hands in the database first, then Java])

=== Lisp: saving to a file is already immortality

The process died — the memory died. The file lives. In Lisp it looks almost indecently simple: print a value so you can read the same value back.

```lisp
(defun save-tasks (path tasks)
  (with-open-file (out path :direction :output :if-exists :supersede)
    (print tasks out)))

(defun load-tasks (path)
  (with-open-file (in path :direction :input :if-does-not-exist nil)
    (if in (read in) nil)))
```

`print`/`read` — Lisp talking to itself in text. This is not Postgres. This is the same gesture: state survives the close button.

Type it in the REPL, don't copy with your eyes:

```lisp
(defparameter *board*
  '((1 . "fix the airlock")
    (2 . "check the antenna")
    (3 . "do not open airlock 3")))

(save-tasks "module-tasks.lisp-data" *board*)
```

Quit SBCL. Open it again. Memory is empty. The file is not:

```lisp
(load-tasks "module-tasks.lisp-data")
; ((1 . "fix the airlock") (2 . "check the antenna") (3 . "do not open airlock 3"))
```

#repl-note[
  `with-open-file` opens a stream and *closes* it, even if you hit an error in the middle. Same gesture as Java `try-with-resources`. A file you forgot to close later refuses to open on the station "for no reason."
]

Look at the file with your eyes — an ordinary text editor, not witchcraft. Parentheses and quotes. If you append garbage by hand, `read` will take offense. Honest offense: "I expected a Lisp value and got mush."

Compare with the Java file from month 1: there you decided how to lay down a line. Here Lisp already knows how to serialize lists. Postgres knows how to serialize *tables* and answer questions like "every unfinished task belonging to this person." A file answers that only if you write the loop yourself. The database answers in one sentence in its weird language.

=== SQL, that weird language about tables

SQL is not Java. Not Lisp. It's a language about "show me the rows that look like this." You write *what* you want, not *how* to walk an array. Postgres decides whether to walk the whole table with its eyes or peek at a cheat sheet (indexes — next month, don't rush).

Install Postgres *locally* first. Not "in the cloud on the free tier." The station gets repaired by hand.

#os[
  *Mac:* `brew install postgresql@16`. Brew will tell you how to start the service (`brew services start postgresql@16` or `pg_ctl`). Client: `psql postgres`. \
  *WSL (Ubuntu):* `sudo apt install -y postgresql postgresql-contrib`, then `sudo service postgresql start`. Create a user and a database via `sudo -u postgres psql`. \
  *Windows without WSL:* installer from https://www.postgresql.org/download/windows/ — pgAdmin checkbox to taste, *write the password on paper*, actually write it. Then either pgAdmin or `psql` from the menu. \
  Superuser password — not `1234` and not empty, even on localhost. Habit. In a month the same finger will reach for `application.yml`.
]

Database `taskdb`. In `psql`:

```sql
CREATE DATABASE taskdb;
```

Postgres answers `CREATE DATABASE`. That is not an error and not a question. That is "done." Then switch into it:

```
\c taskdb
```

The prompt becomes `taskdb=#`. If it is still `postgres=#`, you are still in the housekeeping database and you are about to create a table in the wrong place. Then Java will look for `tasks` in `taskdb`, not find it, and you will argue with emptiness for half an hour.

=== A session you have to type with your fingers

Don't read. Type. If you pasted the whole thing — type it again, at least `INSERT` and `SELECT`.

```sql
CREATE TABLE tasks (
    id         BIGSERIAL PRIMARY KEY,
    title      TEXT NOT NULL,
    done       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Answer: `CREATE TABLE`. Look at what you got:

```
\dt
```

```
         List of relations
 Schema | Name  | Type  |  Owner
--------+-------+-------+----------
 public | tasks | table | you
```

`\d tasks` — the table's blueprint: columns, types, default, primary key. That's the compartment map. Without the map you will later guess inside Hibernate.

Now three tasks — the sacred four gestures start with "put":

```sql
INSERT INTO tasks (title) VALUES ('fix the airlock');
INSERT INTO tasks (title) VALUES ('check the antenna');
INSERT INTO tasks (title) VALUES ('do not open airlock 3');
```

Each time: `INSERT 0 1`. The one is how many rows arrived. The zero in the middle is leftover politeness about OIDs, ignore it.

```sql
SELECT id, title, done FROM tasks;
```

```
 id |        title              | done
----+---------------------------+------
  1 | fix the airlock           | f
  2 | check the antenna         | f
  3 | do not open airlock 3     | f
(3 rows)
```

`f` is false. Postgres does not draw checkmarks. `id` grew by itself: `BIGSERIAL` is a counter. You didn't pass it. Don't pass it until you understand why.

Mark the first one done:

```sql
UPDATE tasks SET done = TRUE WHERE id = 1;
```

`UPDATE 1` — one row. If you wrote `WHERE id = 99`, you get `UPDATE 0`. Silence. Not an error. Nobody was found. In Java you will later be surprised that you "updated" and the database is silent.

```sql
SELECT id, title, done FROM tasks WHERE id = 1;
```

```
 id |     title        | done
----+------------------+------
  1 | fix the airlock  | t
```

Delete:

```sql
DELETE FROM tasks WHERE id = 1;
SELECT id, title FROM tasks;
```

```
 id |        title
----+----------------------
  2 | check the antenna
  3 | do not open airlock 3
(2 rows)
```

Row 1 is gone. Gaps in ids are normal. A primary key is not "the number in the report to the captain." It's a tag. You tossed the crate with tag 1 — the next ones are still 4, 5, 6. Don't try to "squeeze them up." The station hates it when you restick tags after the fact.

#slow[
  Four gestures, remember them in your body. `INSERT` — put. `SELECT` — look. `UPDATE` — change *what's already there*. `DELETE` — throw away. HTTP from last month — the same four, only over the network: POST, GET, PUT/PATCH, DELETE. CRUD is not a sacred word from a job post. It's these four gestures with a table. If you can do them in `psql`, Java is a translator, not a magician.
]

Try to break it. That matters more than a pretty `SELECT`.

```sql
INSERT INTO tasks (title) VALUES (NULL);
```

Postgres will complain something like:

```
ERROR:  null value in column "title" of relation "tasks"
violates not-null constraint
```

`NOT NULL` — "don't put empty," even if Java forgot to check. The database is the last airlock. The doorman at the entrance (the service) is polite. The airlock is steel.

```sql
INSERT INTO tasks (id, title) VALUES (2, 'duplicate tag');
```

If id=2 is still alive:

```
ERROR:  duplicate key value violates unique constraint "tasks_pkey"
```

A primary key is a tag that must not repeat. Two tasks with one id — like two compartments with the same plaque on the door. The fire crew will dock at the wrong hatch.

=== A survival pocket in psql

This is not "learn every slash command." This is five things without which you are blind:

- `\c name` — switch into a database
- `\dt` — which tables
- `\d tasks` — the table blueprint
- `\q` — leave
- Up arrow — previous command, like in the terminal

The semicolon at the end of SQL is *required*. Forget it — psql waits and stares at you with the prompt `taskdb-#` (minus instead of equals). Add `;` and Enter. Everyone has sat there. Even the people who later write about "native SQL."

Strings in SQL — single quotes `'fix the airlock'`. Double quotes `"title"` are names, and in Postgres they also freeze the case. For now live in lowercase without quotes: `title`, `tasks`, `done`. Java will later fight `"Title"` vs `title`, and that's a separate circus.

=== From Java: no magic yet, plain JDBC

When the query is alive in `psql`, you can call it from Java. Starter `spring-boot-starter-jdbc` plus the Postgres driver. In `pom.xml` (Spring Boot 3.x, Java 21):

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

`application.yml` — the station address, not the secret of the universe:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/taskdb
    username: postgres
    password: the-one-on-the-paper
```

A localhost password in the README is fine. A "same as prod" password in git — no, not even as a joke. Not even "temporarily." Git remembers longer than you do.

`JdbcTemplate` is a thin translator: here's SQL, here's how to turn a row into an object.

```java
@Repository
public class TaskJdbcRepository {
    private final JdbcTemplate jdbc;

    public TaskJdbcRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Task> findAll() {
        return jdbc.query(
            "SELECT id, title, done FROM tasks ORDER BY id",
            (rs, rowNum) -> new Task(
                rs.getLong("id"),
                rs.getString("title"),
                rs.getBoolean("done")
            )
        );
    }
}
```

`rs` is the current result row. `rowNum` is the ordinal, often unused, but that's the signature. One `findAll` with a `SELECT`. Controller like last month: `GET /tasks` calls the repository, does not keep a list in a class field.

When this query is alive — next lesson, JPA, that flying annotation. Today the point is to see: Java does not "store in the database." Java *asks* the database in text. The same text you just typed in `psql`.

#os[
  In `application.yml` the url is `localhost` on a Mac, in WSL, and on Windows — if Postgres is listening locally. If Java is in WSL and Postgres was installed with a *native* Windows MSI, `localhost` sometimes sulks: either both in WSL, or both on Windows. Don't mix without a reason. The station hates two captains. \
  Default port `5432`. If the installer offered another — write it down. `Connection refused` almost always means: the service isn't running, or the port is wrong, or you're knocking on the wrong machine.
]

=== When it complains, don't read from the bottom first — and not from the top either

Typical mush at Spring startup:

```
org.postgresql.util.PSQLException: FATAL: password authentication failed
```

Wrong password. Not "recreate the project." Not "probably Hibernate." The password.

```
org.postgresql.util.PSQLException: FATAL: database "taskdb" does not exist
```

You didn't create the database, or you created it in a different Postgres (Windows MSI vs WSL — two servers, two emptinesses).

```
Connection to localhost:5432 refused
```

Service isn't running. Mac: brew services. WSL: `sudo service postgresql start`. Windows: Services, or the elephant icon.

```
ERROR: relation "tasks" does not exist
```

No table. Are you in the right database? `\c taskdb`, `\dt`. People often create the table in `postgres` while Java looks at `taskdb`.

#warn[
  Don't set `ddl-auto: create` "so it does it itself." Today your hand in `psql` makes tables. Tomorrow — Flyway. Hibernate that doodles the schema at midnight is a mechanic who tightens bolts with no log. In the morning nobody knows which bolts.
]

#exercise("9.L1", "Lisp")[
  Save an alist of tasks to a file and open a *new* SBCL session, load it. Immortality in five minutes. If what loaded is what you saved — you already understand databases better than half the guides with `@Entity` on page one.
]

#exercise("9.J1", "Java")[
  In `psql` (or pgAdmin) create the table and three tasks. Copy the `SELECT` into the README. Honest output, not "yeah I did it." Three rows, a header, `(3 rows)` — that's the thing.
]

#exercise("9.J2", "Java")[
  `GET /tasks` from the database via `JdbcTemplate`. A localhost password in the README is fine. A "same as prod" password in git — no, not even as a joke.
]

#exercise("9.J3", "Java")[
  Break it on purpose: wrong password in the yml, start, *one* exception line — into the README. Then put it back. Then a database that doesn't exist. Then a table that doesn't exist. Three different errors, three different meanings. This is not sadism. This is an accident map.
]

#github[Commit `week9: psql and jdbc`. In the commit — the SQL that creates the table, not only Java. Schema is code too.]

#lesson(10, [JPA: the table pretends to be an object])

Yesterday Java asked the database in text. Today an object pretends to be a row. That's convenient until it lies. It lies prettily: "but I have the field," and the column isn't there.

```java
@Entity
@Table(name = "tasks")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private boolean done;

    protected Task() {}

    public Task(String title) {
        this.title = title;
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public boolean isDone() { return done; }
    public void setTitle(String title) { this.title = title; }
    public void setDone(boolean done) { this.done = done; }
}
```

You need an empty constructor — JPA is weird and calls it from underground, then fills in the fields. `protected` — so you don't write `new Task()` with no title out of habit. Getters/setters — yes, wordy, we're in Java. `record` as an entity — not yet: JPA wants to mutate fields on a live object, and a record is a freeze.

`GenerationType.IDENTITY` — "Postgres will hand out the id, we have `BIGSERIAL`." Not `AUTO` "whatever." Not `SEQUENCE` until you yourself understand why a separate sequence. The station holds on IDENTITY, and it holds fine.

=== An empty interface that lies about being empty

```java
public interface TaskRepository extends JpaRepository<Task, Long> {}
```

An empty interface, and Spring writes the implementation. It looks like fraud. Inside — not fraud, code generation, but it feels the same.

`JpaRepository<Task, Long>` means: entity `Task`, primary key `Long`. The methods are already there: `save`, `findById`, `findAll`, `deleteById`. Names like `findByTitle`, `findByDone` Spring will also assemble from the method name. Don't assemble ten `findBy`s yet. One CRUD.

Service:

```java
@Service
public class TaskService {
    private final TaskRepository tasks;

    public TaskService(TaskRepository tasks) {
        this.tasks = tasks;
    }

    public Task create(String title) {
        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException("title required");
        }
        return tasks.save(new Task(title.strip()));
    }

    public List<Task> findAll() {
        return tasks.findAll();
    }
}
```

Controller like month 2, only the list lives not in a service field but in Postgres. Restart Spring — the tasks are still there. That's why we brought in the elephant at all.

=== Flyway: schema from files, not from midnight guesses

File `src/main/resources/db/migration/V1__tasks.sql`:

```sql
CREATE TABLE tasks (
    id         BIGSERIAL PRIMARY KEY,
    title      TEXT NOT NULL,
    done       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Two underscores after the version. `V1__tasks.sql` — yes. `V1_tasks.sql` — Flyway won't eat it and will take offense mysteriously. The filename is a contract.

In `application.yml`:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
  flyway:
    enabled: true
```

`validate` — "check the annotations against the live schema, doodle nothing." Mismatch — we don't start. That's good. A red start beats a quiet ghost column.

#rule[
  The schema lives in SQL migrations. Annotations describe what *already exists*. If you changed a field — write `V2__...sql`, don't hope Hibernate will guess and everyone around will thank you.
]

Starter: `spring-boot-starter-data-jpa` plus Flyway (`flyway-core` and for Postgres — `flyway-database-postgresql` in recent versions). Check the version in *your* Spring Boot docs, not in a 2019 article.

Drop the database, create an empty one, start the app. Flyway runs V1, a row appears in `flyway_schema_history`. That's the airlock log: which migrations already happened. Don't hand-edit a V1 that already flew to another machine. Only a new version. Otherwise your friend's history diverges, and you'll both be right, and both red.

=== Three days of red Hibernate: read the first `Caused by`

A Spring stack is like a station announcement: first "attention," then ten clarifications, and only at the bottom "the hatch is open." Reading the whole thing from the top is a path to despair. Look for the *first* `Caused by`.

Here's a typical horror session. App start, half a screen of red.

```
org.springframework.beans.factory.BeanCreationException:
Error creating bean with name 'entityManagerFactory' defined in class path resource
[org/springframework/boot/autoconfigure/orm/jpa/HibernateJpaConfiguration.class]:
Failed to initialize dependency 'flywayInitializer' (or similar)
...
Caused by: org.hibernate.tool.schema.spi.SchemaManagementException:
Schema-validation: missing column [created_at] in table [tasks]
```

#slow[
  The first line says: "the bean didn't get created." That's weather. The real news is `Caused by`. Here: table `tasks` has no column `created_at`. Either you forgot a migration, or the entity has a field and the SQL doesn't, or the other way around. Treatment: `\d tasks` in psql, compare with the class, add a `V2` or fix V1 *if nobody else has used this V1 yet*. Not "recreate the project." The project is innocent. The column is missing.
]

Another hit:

```
Caused by: org.hibernate.InstantiationException:
No default constructor for entity:  : com.example.taskmanager.Task
```

No empty constructor. JPA can't call `new Task()` from underground. Add `protected Task() {}`. Don't make it `public` if you don't want a coworker creating nameless tasks.

Another:

```
Caused by: org.springframework.beans.factory.BeanCreationException:
Error creating bean with name 'taskController'
...
Caused by: ... No default constructor for ... TaskService
```

This isn't Hibernate anymore, it's Spring: a service with no constructor that takes the repository, and no empty one. One constructor with dependencies — fine, Spring will take it. Two — it gets confused. Don't breed them.

Another, the beloved circus with names:

```
Caused by: org.hibernate.tool.schema.spi.SchemaManagementException:
Schema-validation: missing column [done] in table [tasks]
```

In SQL you called it `is_done`, in Java — `done`. Or the other way around. Or Postgres stored `"done"` with quotes, and Hibernate looks for `done`. `\d tasks` is the truth. Annotation `@Column(name = "done")` — if you want it explicit.

#warn[
  Three days of red Hibernate — read the *first* `Caused by`. Almost always "no column" or "no constructor." Not "recreate the project." Recreating the project is like stepping into space without a suit because the airlock beeped.
]

=== A project contains tasks, JSON must not eat its own tail

The "project contains tasks" relation:

```java
@Entity
@Table(name = "projects")
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @OneToMany(mappedBy = "project")
    private List<Task> tasks = new ArrayList<>();
}

@Entity
@Table(name = "tasks")
public class Task {
    // ...
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id")
    private Project project;
}
```

Migration V2 (since V1 already did tasks without a project — don't rewrite V1, append):

```sql
CREATE TABLE projects (
    id   BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

ALTER TABLE tasks
    ADD COLUMN project_id BIGINT REFERENCES projects (id);
```

Don't return a cycle in JSON "project → tasks → project → …". Jackson will walk the getters like a robot vacuum in a mirrored compartment. The browser hangs, you'll blame the universe.

Return a DTO with no back-reference:

```java
public record TaskView(Long id, String title, boolean done) {}
public record ProjectView(Long id, String name, List<TaskView> tasks) {}
```

The service builds `ProjectView` by hand. The controller does not return the entity. An entity is a bathrobe at home. JSON is what you can show a guest.

#repl-note[
  `mappedBy = "project"` means: "buddy, the relation column lives on the Task side, don't draw a second one." Without it Hibernate sometimes invents an extra bridge table, and in `\dt` you see `projects_tasks` like an uninvited relative.
]

`FetchType.LAZY` — "don't drag the tasks until someone asks." Kind, for a while. The while is called N+1, that's the next lesson. Today it's enough not to set `EAGER` "just in case." Just in case always means everything at once, even when you wanted the project name.

=== Repair the station when "but it worked yesterday"

- The app started, no tables: Flyway is off, or it puts files somewhere other than `db/migration`.
- Flyway writes `checksum mismatch`: you edited a V1 that already ran. Put the file back, make a V3. Or on *localhost* you can drop the database and run from scratch — you cannot do that in prod, remember this sentence.
- `failed to connect`: password, port, WSL vs Windows again.
- You saved an entity, psql is empty: you're looking at the wrong database / the wrong `public` schema. Or the transaction rolled back — that's tomorrow.

#exercise("10.L1", "Lisp")[
  Projects as nested lists. `tasks-of` by project id. A station map, not an Excel sheet. For example `'((1 . (airlock antenna)) (2 . (coffee)))`.
]

#exercise("10.J1", "Java")[
  Entity, repository, CRUD over HTTP, Flyway V1. So after you drop the database the world rises from SQL, not from memory. Check: drop `taskdb`, create an empty one, `spring-boot:run`, tables are there.
]

#exercise("10.J2", "Java")[
  `Project` and `GET /projects/{id}/tasks`. JSON with no infinite nesting. The station is not recursive. Well, almost.
]

#exercise("10.J3", "Java")[
  Diverge the schema on purpose: add a field to the entity, don't write a migration, `ddl-auto: validate`. Start is red. First `Caused by` — in the README as one quote. Then write V2 and fix it. This lesson is about reading errors, not about "so it's green."
]

#lesson(11, [All or nothing, and the smell of extra queries])

=== An airlock and money: why a "deal" at all

The station has two airlock hatches. Open both at once — the air leaves, you leave too. The rule: either both are closed, or one is open and the other holds. There is no in-between "I'm right in the middle" for air.

Money is the same airlock. Debit 100 from Alex's account, credit 100 to Borya. If after the debit the lights flickered and the credit never happened — 100 vanished. Not "temporarily in transit." Vanished. The captain will be unhappy, and that's putting it mildly.

```
start of deal
  Alex:  500 → 400
  Borya: 100 → 200
end of deal  → both changes visible
```

If it crashed between the two UPDATEs:

```
start of deal
  Alex: 500 → 400
  BOOM
rollback → Alex is 500 again, Borya 100, as if nothing happened
```

#slow[
  A transaction is not "fast." A transaction is *all or nothing*. Either both hatches are in the right position, or the station pretends you never touched the lever. `@Transactional` on a service method tells Spring: every SQL inside is one deal. An exception (unchecked, an ordinary RuntimeException) — rollback. You reached the end of the method — commit, `COMMIT`. Until there is a commit, another session in psql may not see those changes. That isn't a bug. That's the airlock not closed yet.
]

In psql you can poke it with your hands. Session 1:

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE name = 'alex';
-- no COMMIT yet
```

Session 2, another psql window:

```sql
SELECT name, balance FROM accounts WHERE name = 'alex';
```

Until the first one said `COMMIT`, the second often sees the old value (depends on isolation; for the textbook: "not visible until the airlock closed"). In the first: `COMMIT;` — and after a new `SELECT` the second already has 400. Or in the first `ROLLBACK;` — and it never happened.

Same for tasks: create a project and the first task. If the task title is empty — the project must not stay in the database either. Otherwise `\dt` hosts an orphan project, and you swear "but the method failed." It failed. But without a deal it managed to commit the first half.

=== `@Transactional`: on public, not on secret

```java
@Service
public class ProjectService {
    private final ProjectRepository projects;
    private final TaskRepository tasks;

    public ProjectService(ProjectRepository projects, TaskRepository tasks) {
        this.projects = projects;
        this.tasks = tasks;
    }

    @Transactional
    public Project createWithFirstTask(String projectName, String taskTitle) {
        Project p = projects.save(new Project(projectName));
        if (taskTitle == null || taskTitle.isBlank()) {
            throw new IllegalArgumentException("title required");
        }
        tasks.save(new Task(taskTitle.strip(), p));
        return p;
    }

    @Transactional
    public void completeAll(Long projectId) {
        List<Task> found = tasks.findByProjectId(projectId);
        found.forEach(t -> t.setDone(true));
    }
}
```

In `completeAll` there is no explicit `save`. JPA's dirty trick: an object you fetched inside a transaction will ride out as an UPDATE at commit. That's called dirty checking, "peek at what got smudged." Convenient. And scary when you weren't expecting an UPDATE and it left anyway.

Don't hang it on `private`: Spring looks through a proxy and doesn't see private. Magic with a hole.

#slow[
  Spring slips a *wrapper* in place of your service. Call from outside: the wrapper opens a transaction, calls your method, closes. A call to `this.createWithFirstTask(...)` from a neighboring method of the same class — bypasses the wrapper, you go straight. No transaction. Like knocking on your own airlock from the inside: wrong door. So `@Transactional` lives on a *public* method that gets called from outside — from a controller, from a test. Not on `private void helper()`.
]

Check with your eyes. A test or curl: create a project with an empty task title. In psql:

```sql
SELECT * FROM projects;
SELECT * FROM tasks;
```

Both empty — the deal worked. Project exists, no tasks — you just invented an orphan. Look for: a checked exception that didn't roll back; or `private`; or two methods with no shared transaction; or the controller already caught the exception *after* the first `save` left without `@Transactional`.

#warn[
  Don't catch `Exception` inside a transactional method and swallow it. Swallowed — Spring thinks everything is fine, does COMMIT. The fire is logged as "successful watch."
]

=== N+1: fifty projects, fifty-one queries, burnt duct tape

You turned on `spring.jpa.show-sql=true` (and better also `logging.level.org.hibernate.SQL: DEBUG`). You did `GET /projects`. In the log:

```
Hibernate:
    select p1_0.id, p1_0.name from projects p1_0
Hibernate:
    select t1_0.id, t1_0.done, t1_0.project_id, t1_0.title
    from tasks t1_0 where t1_0.project_id=?
Hibernate:
    select t1_0.id, t1_0.done, t1_0.project_id, t1_0.title
    from tasks t1_0 where t1_0.project_id=?
Hibernate:
    select t1_0.id, t1_0.done, t1_0.project_id, t1_0.title
    from tasks t1_0 where t1_0.project_id=?
```

And so on. One `select` of projects. Then *for each* project — its own `select` of tasks, because the task list is lazy: Jackson (or your loop) poked `getTasks()`, Hibernate went to the database. 50 projects — 51 queries. That's N+1. It smells like burnt duct tape.

#slow[
  Why "plus one": N children + one query for the parents. Not "the database is slow." You asked it fifty-one times instead of one JOIN. On three rows you won't notice. On three thousand the captain will notice, the user will notice, and your laptop will start howling like a pump.
]

The cure comes later, but today at least learn the smell and *once* see the medicine:

```java
@Query("select p from Project p left join fetch p.tasks where p.id = :id")
Optional<Project> findWithTasks(@Param("id") Long id);
```

`JOIN FETCH` — "bring the tasks in the same query." In the log after that you often get *one* `select ... from projects ... left join tasks`. Not always pretty SQL. But one.

Don't treat everything with `EAGER`. EAGER is "always drag." Then `findAll` of projects for a dropdown will haul tons of tasks nobody asked for. Treat the specific query that smells.

A JOIN in psql, so you can see what Hibernate wants:

```sql
SELECT p.id, p.name, t.id, t.title
FROM projects p
LEFT JOIN tasks t ON t.project_id = p.id
ORDER BY p.id, t.id;
```

One table on the left, tasks on the right, empty tasks — `NULL` in the right-hand columns. That's the same JOIN FETCH, only by hand. If this SELECT makes sense — the annotation is no longer a prayer.

Count the queries: one `GET`, eyes on the log, tally marks in the README margins. If there are as many queries as compartments — there it is, N+1, say hello.

=== Isolation — a word in the interview, not a button this week

They may ask "what is isolation." Short honest answer: how much a deal sees other people's unclosed airlocks. By default Postgres is `READ COMMITTED` — you see only what's committed. `SERIALIZABLE` is stricter and more expensive. Don't turn on serializable "for safety" on a textbook CRUD. Safety today is `@Transactional` on the method where two changes must live or die together.

#exercise("11.L1", "Lisp")[
  A list of operations. If `'fail` is among them — apply none. A toy "transaction": either the airlock closed, or you never touched it. No half-open hatch.
]

#exercise("11.J1", "Java")[
  One method: project + first task. Empty task title — the project must not stay in the database either. Check with your eyes in `psql`. Don't trust only a test that looks at the same EntityManager: look with another eye, from another window.
]

#exercise("11.J2", "Java")[
  SQL log, one `GET` of the list, query count in the README. If there are as many queries as compartments — there it is, N+1, say hello.
]

#exercise("11.J3", "Java")[
  The same `GET`, but through a method with `JOIN FETCH` (or a DTO query with no lazy collection). Count `select` in the log again. Two numbers side by side in the README: before and after. If "after" isn't smaller — you bolted fetch to the wrong place, or Jackson still pokes another relation.
]

#lesson(12, [Tests that hit a real database])

A unit test of a service with a mocked repository checks that you called `save`. It does not check that Postgres swallowed the row, that Flyway ran, that `NOT NULL` is alive. By the end of the month you need tests that *knock*. Otherwise you have a green bar and a dead database — like a green light on an open hatch.

=== The ideal — Postgres in a box for the duration of the test

Testcontainers: Docker brings up a real Postgres, the test runs migrations, then the box dies. On a Mac and on Windows (Docker Desktop + WSL2) this works. Dependency `spring-boot-testcontainers` plus the Testcontainers `postgresql` module — look at your Boot's BOM.

```java
@SpringBootTest
@Testcontainers
class TaskServiceIT {

    @Container
    static PostgreSQLContainer<?> postgres =
        new PostgreSQLContainer<>("postgres:16-alpine");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry r) {
        r.add("spring.datasource.url", postgres::getJdbcUrl);
        r.add("spring.datasource.username", postgres::getUsername);
        r.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired TaskService service;

    @Test
    void createThenFind() {
        Task t = service.create("airlock");
        assertTrue(service.findById(t.getId()).isPresent());
        assertEquals("airlock", service.findById(t.getId()).get().getTitle());
    }
}
```

This isn't "Docker magic." This is an honest elephant, only temporary. If the test is green here, there's a good chance it won't lie on your `localhost:5432` either.

#os[
  Docker Desktop on a Mac: usually just works. On Windows — install with the WSL2 backend, not Hyper-V "because the checkbox." In WSL `docker ps` should see the same containers. If IDEA is on Windows and Docker is only in Ubuntu — two captains again. \
  No Docker and still scared: a `test` profile and H2. In the README *honestly*: "prod is Postgres, tests are a shortcut." A lie in the README surfaces in an interview faster than you can say "actually." H2 is not Postgres. `TIMESTAMPTZ`, arrays, a pile of functions — a different dialect. For a junior in month 3 — an acceptable crutch, if it's signed.
]

=== Four gestures — four tests, not "well I poked it with my eyes"

```java
@Test
void unknownIdIsEmpty() {
    assertTrue(service.findById(9_999_999L).isEmpty());
}

@Test
void updateChangesTitle() {
    Task t = service.create("old");
    service.rename(t.getId(), "new");
    assertEquals("new", service.findById(t.getId()).get().getTitle());
}

@Test
void deleteThenGone() {
    Task t = service.create("temporary");
    service.delete(t.getId());
    assertTrue(service.findById(t.getId()).isEmpty());
}
```

Red/green, not "well I poked it with my eyes." Eyes lie when you want to sleep. `assertTrue(true)` is a crime against the station: a test that cannot fail.

For HTTP — `@SpringBootTest(webEnvironment = RANDOM_PORT)` and `TestRestTemplate` or `MockMvc`. At least create, and get of an unknown. Four hundred on an empty title, not five hundred.

The transactional test from lesson 11 belongs here too: empty title — `assertEquals(0, projectRepository.count())`. Then still glance at psql once in your life, so you believe count isn't lying.

=== This week's README is a ship's log, not poetry

How to bring up Postgres on a Mac *and* in WSL/Windows. Which url in the yml. How to run migrations (they run themselves on start — write that). How to test: `./mvnw test` / `mvnw.cmd test`. Five curls: health if you have it, POST, GET of the list, GET of one, DELETE. Example JSON. If Docker is required for Testcontainers — one line "without Docker the integration tests won't stand up."

Someone else's machine (or your second OS) is the criterion. "It works in my IDEA" is not a completed watch.

=== What should be on deck by the end of week 12

A living CRUD. Schema in SQL, not in your head. Entities not sticking out as a cycle in JSON. At least one `@Transactional` scenario that rolls back. An SQL log you saw with your own eyes. A dozen tests, and not all of them mocks. A commit. That is a "monolith." One program. Not a zoo.

Don't put Kafka in this commit, not even "to read." You can read in a browser, not in `pom.xml`.

#exercise("12.L1", "Lisp")[
  A toy "integration test" without JUnit: save tasks, start a *new* SBCL, load, check `equal` against what you expected. If not equal — `(error "station lost the log")`. Same feeling as a green IT: a second process, not the same memory.
]

#exercise("12.J1", "Java")[
  create; get of an unknown; update title; delete. Red/green, not "well I poked it with my eyes."
]

#exercise("12.J2", "Java")[
  README: how to bring up Postgres on a Mac *and* in WSL/Windows, migrations, tests, curl.
]

#github[Commit `week12: crud postgres`. Don't put Kafka in this commit, not even "to read."]

#sunday[
  Your own tiny "database": you append to a file, in memory a map of id → place in the file. `insert` writes at the end. `select` by id jumps. Then compare with Postgres and respect it a little: you just sketched a piece of what people get paid for, and they even get vacation.
]

#sicp[
  State that survives a process is an old question: what is data if the program turned off. A file, a table, a log. If it itches "can a database be a list of pairs" — it can, you already made an alist. Postgres is a list of pairs that learned to answer questions and not lose its tail in a draft.
]
