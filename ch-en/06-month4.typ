#import "../lib-en.typ": *

= Month 4. What they ask in the room with a whiteboard

We take the monolith to "you can show this to a human." Users, passwords (not in the clear, we aren't barbarians), indexes, pages of twenty. In parallel — collections and the simple puzzles without which an interview turns into a lottery. Lisp: you may start a tiny language of your own. That's legal and even desirable.

By the end of week sixteen you don't "know Spring Security." You can explain *out loud* why a password doesn't sit as text, why `?userId=` in the URL is a hole the size of an airlock, why a `HashMap` lost a key, and why a counter from two threads lies. Whiteboards love that. Kafka on a whiteboard without that is a whistle with no air.

#rhythm[
  *Mon–Thu:* 40 min Lisp (registry, hash-table, stack, purity) + 120 min Java (auth, index, collections, races). \
  *Friday:* finish Security until "someone else's id doesn't read." \
  *Saturday:* pagination, EXPLAIN, three interview puzzles. \
  *Sunday:* a voice recorder, eight questions. Shame to listen — a good sign: the ears are still alive.
]

#rule[
  Entry here is with a living CRUD and Postgres. No database — go back to month 3. Passwords on empty memory are theater: you restarted, and every user died with the scenery.
]

#lesson(13, [Who are you, and why the password isn't "1234"])

=== A dump fairy tale they tell too late

Imagine: someone leaked the `users` table. Not "hacked prod in a movie." Leaked. A backup on a stick, logs, an intern with `SELECT *`, a copy "to look at." What's in the file?

If it's this:

```
 id | email              | password
----+--------------------+----------
  1 | alex@module.space  | 1234
  2 | borya@module.space | qwerty
```

Congratulations. The villain doesn't have "hashes." They have *passwords*. Alex uses `1234` on email too, and on that weird antenna forum. Borya uses `qwerty` everywhere. One dump — keys to half the lives of people who trusted you. An airlock code taped to the outside at least you can see. A password as text in the database is tape you stuck there yourself and forgot.

A hash is a one-way meat grinder. You cannot unmake sausage. The database stores sausage. On login you run the password through the grinder again and compare sausage to sausage. Even you, station captain, should not be able to "remind the password." Only reset it.

```
password "comet" → BCrypt → $2a$10$...long mush...
```

In the dump: mush. A rainbow of precomputed "1234" → md5 doesn't help if there's *salt*: a chunk of randomness, different per user, mixed into the hash. BCrypt puts the salt inside the string `$2a$10$...` itself. So two people with password `1234` get a *different* hash. Pretty and mean.

#slow[
  "Why not encrypt the password instead of hashing?" A cipher is two-way: have the key — you can get the text back. So the key sits somewhere, and whoever took the database *and* the key reads passwords again. A hash doesn't open with a key. It opens only with a new "try this password — match?" That's why `matches`, not `decrypt`.
]

Don't write your own hash via `String.hashCode()` or MD5 "for the textbook in prod." The textbook is Lisp `sxhash` below, and we'll say right away it's a dummy. In Java — BCrypt.

```java
@Bean
PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

Registration — `encode`. Login — `matches`. Never log a password, not even "for a minute," not even in DEBUG, not even a textbook one. The habit is contagious. In six months you'll turn DEBUG on in prod and ship passwords to Grafana. The station doesn't forgive that, and neither does security.

=== A table of people, not "just a field on tasks"

Flyway `V3__users.sql` (pick your number if V2 is already indexes or projects):

```sql
CREATE TABLE users (
    id            BIGSERIAL PRIMARY KEY,
    email         TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL
);

ALTER TABLE tasks
    ADD COLUMN user_id BIGINT REFERENCES users (id);
```

Email unique: two Alexes with one address — a mess of whose airlock is whose. `UNIQUE` will catch it even if the service forgot to check.

```java
@Entity
@Table(name = "users")
public class UserAccount {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String email;
    private String passwordHash;
    // empty constructor, getters...
}
```

Don't name the class `User` right away: Spring Security already has `User`. A name collision is a separate circus at three in the morning.

Registration:

```java
public void register(String email, String rawPassword) {
    if (users.existsByEmail(email)) {
        throw new IllegalArgumentException("email taken");
    }
    String hash = encoder.encode(rawPassword);
    users.save(new UserAccount(email, hash));
}
```

Login: found by email, `encoder.matches(raw, account.getPasswordHash())`. No match — 401, the same wording for "no such user" and "wrong password." Otherwise they probe which emails are live from the answer.

Then either JWT or a session cookie. *One*. Not both, you're not a buffet.

- Session: the server remembers "this browser is Alex," a random number in a cookie. Simple. Scaling later hurts more; today you have one server.
- JWT: the server hands out a signed ticket. The client carries the ticket in the `Authorization: Bearer ...` header. The server stores no session, it checks the signature. Ticket stolen — they walk around as Alex until it expires.

#warn[
  The first "JWT in 15 minutes" guide from 2018 may already be dead. Check the docs for *your* Spring Boot version. Old spells sometimes open the wrong door. `WebSecurityConfigurerAdapter` is a museum. Look for `SecurityFilterChain` and `http.authorizeHttpRequests`.
]

A minimal skeleton on Boot 3 / Java 21 — don't copy with your eyes closed, learn three holes: `POST /auth/register`, `POST /auth/login`, everything `/tasks/**` only with a ticket. The rest 401.

The chain skeleton looks roughly like this. This is not holy text: check the docs for *your* Boot.

```java
@Bean
SecurityFilterChain api(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf.disable())
        .sessionManagement(s ->
            s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/auth/**").permitAll()
            .anyRequest().authenticated());
    // later: JWT filter before UsernamePasswordAuthenticationFilter
    return http.build();
}
```

`csrf.disable()` on a textbook JWT API is fine, because CSRF is about a browser cookie, and we have a ticket in a header. Don't kill it that way on sessions with a cookie. `STATELESS` — the server doesn't put an HTTP session; every request carries the ticket again.

=== A login session you have to see with your eyes

```
curl -s -X POST localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"alex@module.space","password":"comet"}'
```

A response like `201` or a body `{"id":1}`. In psql:

```sql
SELECT id, email, password_hash FROM users;
```

```
 id | email              | password_hash
----+--------------------+----------------------
  1 | alex@module.space  | $2a$10$N9qo8uLOickgx2ZMRZoMye...
```

Not `comet`. If you see a clear password — you forgot `encode`. Stop. Don't commit.

```
curl -s -X POST localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"alex@module.space","password":"comet"}'
```

A body like `{"token":"eyJhbGciOiJIUzI1NiJ9."}` — three chunks through dots. The middle chunk is the payload; you can Base64 it and see `sub` / email. The *signature* is the third chunk. Without the server secret you cannot forge a ticket "I am admin." The secret — in yml or the environment, not in git.

```
curl -s localhost:8080/tasks \
  -H "Authorization: Bearer paste-the-token"
```

No header — 401. With a ticket — Alex's list, empty or not. Nobody else's tasks, even if they're in the database. Check with a second user.

=== Why not `?userId=1`

Here's a hole a junior carries into prod more often than a leftover `console.log`:

```
GET /tasks?userId=7
```

The service trusts the parameter. A neighbor substitutes `?userId=1` and reads the list titled "don't tell anyone." On the station that's like writing the airlock code on the hatch and being surprised the wrong people came in.

Right: `Task` has a user field. The service takes the current one from context, *not from the URL*.

```java
public List<Task> myTasks(Authentication auth) {
    Long me = currentUserId(auth);
    return tasks.findByUserId(me);
}
```

An id in the path `GET /tasks/42` is the id of a *task*, not the owner. You get the owner from the ticket. Found task 42, owner isn't you — 403 or 404. Pick one and stay loyal.

#slow[
  404 "no such thing" to a stranger is a polite lie: you don't confirm the task exists. 403 "I know it's there, I won't give it" is more honest for your own admin UIs, chattier for strangers. Textbook monolith: pick 404 for foreign ids and write it in the README so in a month you don't forget which face the station wears.
]

A test with two users. Two spacesuits, one porthole that isn't yours. Without this test Security is scenery: a green health and a leaky hatch.

```java
@Test
void cannotReadForeignTask() {
    String alex = token("alex@module.space", "secret1");
    String borya = token("borya@module.space", "secret2");
    long id = createTask(alex, "airlock secret");
    getTask(borya, id).expectStatus().isNotFound(); // or 403
}
```

Don't put userId in the JSON body of `POST /tasks` "to make it easier." The client lies. Always. Even if the client is you.

The same sin in a pretty dress: `GET /users/7/tasks`. Looks RESTful. If 7 comes from the URL and isn't checked against the ticket — same hole, just in form. The station does not have to have "nested users" in the path. `GET /tasks` and "who are you" from SecurityContext — boring and airtight.

=== When Security screams and you scream back

- `403` on everything, including login: `requestMatchers("/auth/**")` is the wrong prefix, or the JWT filter swallows login too early.
- `401` with a correct ticket: the header isn't `Authorization: Bearer ...`, or an extra newline, or you put quotes inside. PowerShell loves to wreck quotes — go into WSL.
- After a restart everyone is logged out: the JWT secret changed (random on every start). Put the secret in yml on localhost, not in git, next to the database password in `.gitignore`.
- Hash in the database, login always false: you compared hash strings by hand instead of `matches`. BCrypt makes new sausage on every `encode`. Comparing two hashes with `equals` is a walk into a wall.
- Two users, both see every task: `findAll()` instead of `findByUserId`. Security let them in the door, the service opened every locker.

=== Lisp: a toy "hash" you must not take to prod

```lisp
(defun hash-dummy (password)
  (sxhash password))
```

This is not cryptography. `sxhash` is a fast number for in-memory tables. Two different passwords can collide. No salt. The gesture: *secret ≠ password*. We don't ship real bcrypt in Lisp on this course. The station is already held together with duct tape.

```lisp
(defparameter *users* (make-hash-table :test 'equal))

(defun register (email password)
  (when (gethash email *users*)
    (error "exists"))
  (setf (gethash email *users*) (hash-dummy password))
  t)

(defun login (email password)
  (eql (gethash email *users*) (hash-dummy password)))
```

`(register "alex@module.space" "comet")` \
`(login "alex@module.space" "comet")` → `T` \
`(login "alex@module.space" "nope")` → `NIL`

Don't print the password to the log. Not even `(format t "~a~%" password)` "to check." Checked — delete it.

#exercise("13.L1", "Lisp")[
  Registry: email → "hash." Repeat email — error. `login` compares hashes. No passwords in logs, not even textbook ones, the habit is contagious.
]

#exercise("13.J1", "Java")[
  Registration and login. `GET /tasks` — only yours. Foreign ones don't glow even as "an empty list with a hint."
]

#exercise("13.J2", "Java")[
  A foreign id — 403 or 404. Pick one and stay loyal. A test with two users. Two spacesuits, one porthole that isn't yours.
]

#exercise("13.J3", "Java")[
  Three curls in the README: no ticket; with a foreign ticket on a foreign id; with your own. Three statuses. If they're all 200 — the hatch is open, don't celebrate.
]

#lesson(14, [An index doesn't speed up everything — it speeds up this])

A book with no table of contents: to find the chapter about the airlock, you flip from page one. A table of contents is a cheat sheet "airlock → p. 214." Writing the book takes a little longer (you have to update the contents). Searching is faster.

```sql
CREATE INDEX idx_tasks_user ON tasks (user_id);
```

Flyway `V4__idx_tasks_user.sql` — one line, a big personality. Without an index, `WHERE user_id = 1` on a fat table is Seq Scan, a full walk. With an index — Index Scan, a jump.

This does not speed up `SELECT * FROM tasks`. This speeds up *this* condition. An index on every column "just in case" is a table of contents that lists every word: the book is thicker, writing hurts more, and the benefit is a cat's worth.

=== An EXPLAIN session, with thousands of rows, otherwise it lies

On three rows Postgres may skip the index: "I can see it with my eyes." Pour in thousands.

```sql
INSERT INTO tasks (title, user_id)
SELECT 'task ' || g, 1
FROM generate_series(1, 5000) AS g;

INSERT INTO tasks (title, user_id)
SELECT 'foreign ' || g, 2
FROM generate_series(1, 5000) AS g;
```

Ten thousand rows. Not scary. Textbook junk.

*Before* the index (if you haven't created it yet — or drop it with `DROP INDEX idx_tasks_user` on localhost):

```sql
EXPLAIN ANALYZE SELECT * FROM tasks WHERE user_id = 1;
```

A chunk of truth that looks like:

```
Seq Scan on tasks  (cost=0.00..188.00 rows=5000 width=...)
  Filter: (user_id = 1)
  Planning Time: 0.1 ms
  Execution Time: 2.3 ms
```

`Seq Scan` — we walked the whole table. On ten thousand, 2 ms. On ten million it stops being a joke, and that's exactly what the interview asks about.

Create the index, again:

```sql
CREATE INDEX idx_tasks_user ON tasks (user_id);
EXPLAIN ANALYZE SELECT * FROM tasks WHERE user_id = 1;
```

```
Index Scan using idx_tasks_user on tasks  (cost=0.29..140.00 rows=5000 width=...)
  Index Cond: (user_id = 1)
  Execution Time: 1.1 ms
```

Your numbers will differ. Don't look at "twice as fast," look at the *word*: Seq vs Index. If after the index it's still Seq Scan — either stats didn't update (`ANALYZE tasks;`), or the condition is different (`WHERE user_id IS NOT NULL` on almost every row — the index is useless), or there are few rows and the planner isn't stupid.

#slow[
  `EXPLAIN` without `ANALYZE` is the plan, how Postgres *intends* to. With `ANALYZE` — also how long it actually took, with live numbers. For the README you need both runs: before and after, on the same volume. Three rows in the table — the comparison lies like a polite sensor: "all nominal," and oxygen is already whistling.
]

Don't index `title` "because we might search." Might — when a `WHERE title = ...` or `LIKE 'foo%'` (prefix) shows up. `LIKE '%foo%'` a normal index often won't save. Say honestly in the interview "depends on the query," that's an adult answer, not "an index is always faster."

=== Pages of twenty, not a hundred thousand in one JSON

```
GET /tasks?page=0&size=20
```

Spring Data knows `Pageable`. Let it.

```java
@GetMapping("/tasks")
public Page<TaskView> mine(Authentication auth, Pageable pageable) {
    Long me = currentUserId(auth);
    return tasks.findByUserId(me, pageable).map(this::toView);
}
```

`Page` in JSON will bring `content`, `totalElements`, `totalPages`. The browser and you deserve a better death than a hundred thousand tasks in one response. Server memory does too.

#os[
  curl with pagination is the same on a Mac and in WSL: \
  `curl -s -H "Authorization: Bearer ..." "localhost:8080/tasks?page=0&size=20"` \
  Quotes around the URL in zsh/bash help because of `?`. In cmd.exe — different quotes, WSL is easier. PowerShell sometimes swallows `?` — then quotes too, or `curl.exe`.
]

Page zero is the first page, Spring-style. If you want "page 1 for humans" — translate yourself, don't get mad at the framework.

Index and pagination are friends: `WHERE user_id = ? ORDER BY id LIMIT 20 OFFSET 0`. Without an index — Seq again, then sort, then cut 20. With an index on `user_id` it's already warmer. A composite `(user_id, id)` is warmer still, when you grow into it. Today a plain `user_id` is enough if the README is honest.

Turn on `show-sql` and hit `page=2&size=20`. In the log something like:

```
select t.id, t.title, t.done, t.user_id
from tasks t
where t.user_id=?
order by t.id
limit 20 offset 40
```

`offset 40` — "skip two pages." On huge tables OFFSET gets expensive: the database still walks the skipped rows. For a junior and ten thousand rows — fine. In an interview you can say "cursor/keyset later, page for now." Honest.

#warn[
  `size=100000` in a client's hands — a hundred thousand JSON again. Put a ceiling: `@PageableDefault(size = 20)` and `MaxPageSize`. The station is not obliged to haul the whole hold because someone typed nonsense in the address bar.
]

#exercise("14.L1", "Lisp")[
  10000 pairs (person . task). Search by walking. Second version: a hash-table in advance. Feel the difference in your body, not in an article. `(get-internal-real-time)` before and after.
]

#exercise("14.J1", "Java")[
  Pagination + an index in Flyway `V2`. If V2 is already taken by projects — the next free number. The file matters, not a magic two.
]

#exercise("14.J2", "Java")[
  README: `EXPLAIN` before and after. On three rows Postgres may skip the index — pour in thousands, otherwise the comparison lies like a polite sensor.
]

#exercise("14.J3", "Java")[
  `GET /tasks?page=0&size=5` twice: second page `page=1`. In the README two JSONs — at least the ids. If the pages are identical, you forgot Pageable or always use page=0.
]

#lesson(15, [Pockets, equality, and puzzles on your fingers])

Interviews love the same rakes. Not because they're villains. Because you've already stepped on these rakes in prod, you just didn't know the names yet.

=== Two crates with one number, and a map that betrayed you

```java
class UserId {
    private final long value;
    UserId(long value) { this.value = value; }
}
```

You put it in a map:

```java
Map<UserId, String> cabin = new HashMap<>();
cabin.put(new UserId(1), "Alex");
System.out.println(cabin.get(new UserId(1)));
```

It prints `null`. Alex is in the cabin. The key "same number" is, to the map, *a different crate*. By default `equals` is `==`: the same object in memory, not "similar inside." `hashCode` is from the address too. Two `new UserId(1)` — two planets.

#slow[
  HashMap first computes `hashCode`, runs to a bucket, then in the bucket compares `equals`. If `equals` says "we're the same" and `hashCode` is different — the key sits in one bucket, they look in another, forever a miss. The contract: equal objects must have the same hashCode. The reverse is false: one hashCode is not yet equality (a collision). Break one without fixing the other — the map lies quieter than Hibernate.
]

A hand fix:

```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof UserId other)) return false;
    return value == other.value;
}

@Override
public int hashCode() {
    return Long.hashCode(value);
}
```

Or, Java 21, without shame:

```java
record UserId(long value) {}
```

`record` already gives `equals`/`hashCode`. That's not cheating, that's the 21st century. In an interview say "record"; if they ask "write equals" — write it, so they see you understand, not only the syntax.

#warn[
  You cannot mutate a map key later: you put a `UserId`, then a setter changed `value` — the object moved to another universe, the map looks up by the old hash. `final` fields. A mutable key is pain. Like a tag on a crate they restick while the crate is in transit.
]

`==` for objects — "same crate?" `equals` — "similar inside?" For strings almost always `equals`. `==` on strings sometimes accidentally works from the intern pool, and you'll believe in success. Don't. For `int`, `==` is fine. For `Integer` with a big number `==` is a trap again: cache from -128 to 127, after that new crates. Interviews love this to trembling.

Type it, don't take it on faith:

```java
Integer a = 127;
Integer b = 127;
System.out.println(a == b);        // often true, cache
Integer c = 128;
Integer d = 128;
System.out.println(c == d);        // often false, new crates
System.out.println(c.equals(d));   // true, same number inside
```

`int` is just a number in a register, `null` cannot happen. `Integer` is a crate, can be empty, rides in collections. One sentence for the cat: "int is a value, Integer is a wrapper object."

=== Buckets: how a map loses a key, step by step

Imagine a cabinet with 8 shelves. `hashCode() % 8` is the shelf number.

1. `put(new UserId(1), "Alex")`. Hash from the address, say shelf 3. Alex lies on 3.
2. `get(new UserId(1))`. New object, different address, different hash, shelf 6. Shelf 6 is empty. `null`.
3. You fixed only `equals`, hash still from the address. Lookup arrived on shelf 6, nobody there to equals. `null` again.
4. You fixed both: both `UserId(1)` give hash, say, `1`, one shelf, equals says "yes." Alex is home.

#repl-note[
  Break it the other way: `hashCode` always `42`, `equals` is normal. The map works, but every key is on one shelf. At tens of thousands it gets slow, like a LinkedList pretending to be a HashMap. In an interview that's "degrades to a list with a bad hash."
]

=== The list you almost always want

`ArrayList` — an array under the hood, it grows. Get by index is fast. Insert in the middle — shift the tail. `LinkedList` — little train cars. Cheap into the middle *if you're already standing on the car*. From an index — walk first. In practice a junior hauls `LinkedList` "for beauty" and gets a slow `get(i)` in a loop. A rare guest. Don't haul it for beauty.

`HashMap`: key, bucket, average get is fast. Worse when everyone has the same hash — one bucket, like a queue at the only airlock.

Complexity out loud, roughly, no exam theater:

- list, find an element: walk with your eyes, the longer the slower;
- map by key: fast on average;
- put at the end of an ArrayList: usually cheap.

Streams `.filter().map()` — in moderation. A stream for the sake of a stream reads like poetry you'd be ashamed of. A `for` loop is not shameful. Shameful is not understanding what the stream does.

```java
List<String> titles = tasks.stream()
    .filter(t -> !t.isDone())
    .map(Task::getTitle)
    .toList();
```

Three lines — ok. Twelve operations with `collectingAndThen` — no, not this week and not in an interview "write it on paper."

=== Lisp: the same word frequency, the same pocket

```lisp
(defun freq (lst)
  (let ((h (make-hash-table :test 'equal)))
    (dolist (x lst)
      (incf (gethash x h 0)))
    h))
```

`:test 'equal` — otherwise strings with the same letters will be different keys (`eq` looks at "same crate"). Java `HashMap` for strings already calls `equals`. Lisp makes you choose. That's honest.

```lisp
(freq '("airlock" "antenna" "airlock"))
; table: "airlock" → 2, "antenna" → 1
```

A stack for brackets is an ordinary list: `push` onto the head, `pop` from the head. Opened `(` — put the expected `)`. A `)` arrived — take it off, match? No — the station listed. At the end the stack must be empty, otherwise the hatch never closed.

=== Algorithms: pictures, not a medium marathon

*Grokking Algorithms* (there are pictures, Barski would approve) and 3–4 easy problems a week. Not mediums in batches. Mediums in batches is how you burn out and start hating parentheses already on Java.

Three things they actually ask with fingers:

1. Reverse an array in place — two indexes from the ends, swap until they meet.
2. Character frequency — `HashMap<Character, Integer>` or an array of 26 if it's only Latin.
3. Brackets — a stack, see above.

Write it on paper. Then in the IDE. Then break the input `"]"` and `""`. Empty — brackets are balanced, by the way. A station with no hatches is airtight too. Philosophically debatable, convenient in a test.

#exercise("15.L1", "Lisp")[
  Balance of `()` `[]`. The stack is an ordinary list, `push`/`pop`. If extras remain — the station listed.
]

#exercise("15.J1", "Java")[
  Map key `UserId`. Two objects with one number inside — one key. `record` already gives `equals`/`hashCode`, that's not cheating, that's the 21st century.
]

#exercise("15.J2", "Java")[
  Three things: reverse an array in place; character frequency; brackets. No "ten more from LeetCode while it's hot."
]

#exercise("15.J3", "Java")[
  Break it on purpose: a key class *without* equals/hashCode, `put` and `get` with different `new`. README: which `null` you saw. Then a record. The same `get` — not null. Two lines of output. That's a story you'll later tell at the board.
]

#lesson(16, [Two requests at once, and why the counter lies])

Tomcat is multithreaded anyway: two HTTPs can poke the service at the same time. You didn't order this. It's already like that. One user — one thread per request, two users — two threads, one `Counter` for both, if you hung it that way.

=== A race with numbers, not slogans

```java
class Counter {
    int n;
    void inc() { n++; }
}
```

`n++` looks like one step. For the hardware it's roughly:

1. read `n` into a register;
2. add 1;
3. write it back.

Two threads, `n` is currently 42:

```
thread A read 42
thread B read 42
thread A wrote 43
thread B wrote 43
```

Two additions. The counter grew by *one*. The second addition got eaten. That's a race. Not "Java glitches sometimes." That's you letting two mechanics turn one valve without looking at each other.

Again, slower, with step numbers. Goal is 2, two threads one `inc` each, start `n = 0`:

```
time   | thread A             | thread B             | n in memory
-------+----------------------+----------------------+-----------
 t1    | read 0               |                      | 0
 t2    |                      | read 0               | 0
 t3    | 0+1, writes 1        |                      | 1
 t4    |                      | 0+1, writes 1        | 1
```

Expected 2. Got 1. Scale that to 100000 such crossings — a hole of tens of thousands. Not every `inc` has to cross. A fraction is enough.

Run it:

```java
Counter c = new Counter();
Thread a = new Thread(() -> { for (int i = 0; i < 100_000; i++) c.inc(); });
Thread b = new Thread(() -> { for (int i = 0; i < 100_000; i++) c.inc(); });
a.start();
b.start();
a.join();
b.join();
System.out.println(c.n);
```

You waited for 200000. You saw, say, 143882. Or 178001. Or a rare jackpot 200000 — and decided there is no race. No: you got lucky with timing. On Windows the threads are the same, surprise. On a Mac too. The number will differ from run to run. Write three runs in the README. The spread is evidence, not shame.

#slow[
  Why "sometimes 200000": chunks of the loops don't always cross on the same `n`. The scheduler sometimes gives A a hundred steps in a row, sometimes shuffles. A race is not "always broken." It's "not promised to be whole." The station cannot live on "well yesterday it added up." An elevator that sometimes falls is a broken elevator.
]

A textbook fix:

```java
synchronized void inc() { n++; }
```

At one moment one thread turns the valve. The other waits. 200000 again. Boring. Correct.

In real life for a counter — `AtomicInteger` (`incrementAndGet`), for money and tasks — the database and a transaction. A handmade `synchronized` on the whole service is a queue at one airlock: safe and slow. Handmade `new Thread` in prod is like welding in a spacesuit: you can, but why.

A thread pool: `ExecutorService`. Don't breed an infinite army.

```java
ExecutorService pool = Executors.newFixedThreadPool(4);
pool.submit(() -> System.out.println("watch"));
pool.shutdown();
```

Four workers. As many tasks as you like in the queue. A thousand `new Thread` for a thousand tasks — a thousand spacesuits, the oxygen runs out.

=== Where the race is in the web if I "just Spring"

Two `POST /tasks` at once — usually fine: two different rows, `BIGSERIAL` hands out ids. The race starts when two people change *the same thing*:

- a counter "how many tasks the project has" in a Java field, not in `COUNT`;
- "transfer money" with two UPDATEs and no transaction;
- `if (tasks.size() < 10) tasks.add(...)` — both see 9, both add, it became 11.

A database with `@Transactional` and a proper `UPDATE accounts SET balance = balance - 100 WHERE id = ? AND balance >= 100` is an adult valve. A check "is there enough money" in Java, then UPDATE — childish: between the check and the write a neighbor already debited.

In numbers. Alex has 100. Two requests "debit 100" at once:

```
A read balance=100, 100 >= 100? yes
B read balance=100, 100 >= 100? yes
A writes 0
B writes 0   // both "succeeded," money gone twice, lucky it was zero
```

Or worse: both write `100-100`, but if the logic is "add to the other account," Borya gets 200 from nowhere, Alex zero. A transaction + a condition in SQL: the second UPDATE hits 0 rows, the service says "not enough." Not `Thread.sleep(50)`.

Don't fix a race with "we'll just wait Thread.sleep." Sleep in an interview is a red light. Sleep in prod is duct tape on a sensor.

=== Eight questions for the cat (yes, the cat again)

By the end of the week answer *out loud*:

- how `int` differs from `Integer` in one sentence;
- why you cannot change a string "from the inside";
- collections and "this is fast / this isn't";
- checked versus unchecked;
- `try-with-resources`;
- inheritance vs "embed an object" on your own `Task`;
- what `@Transactional` rolls back;
- why `equals` together with `hashCode`.

Can't do it without peeking — not "another chapter." Retell your own code. Field names are a cheat sheet. If you're ashamed to say `mgr` out loud, rename it to `manager`, the story will go.

Lisp this week is purity: no global `defparameter`, only arguments. There's no race in single-threaded SBCL, but the habit "state flows through arguments" later helps you not breed a shared field `int n` for the whole server.

You may start a tiny language of your own: numbers and `+`. If it's a number — return it. If it's a list with `+` — add up `ev` of the tail. That's legal. That's even desirable. Java Bro does not cancel.

```lisp
(defun ev (form)
  (if (numberp form)
      form
      (let ((op (first form))
            (args (mapcar #'ev (rest form))))
        (cond
          ((eq op '+) (apply #'+ args))
          ((eq op '-) (apply #'- args))
          (t (error "unknown ~a" op))))))

(ev 3)            ; 3
(ev '(+ 1 2 3))   ; 6
(ev '(+ 1 (- 5 2))) ; 4
```

#repl-note[
  `mapcar #'ev` — compute the children first, then add. Like Lisp in general: inner parentheses earlier. You just wrote a tiny Lisp inside Lisp. The station loves that kind of recursion. Don't drag it into Spring. Drag it into `lisp-experiments`.
]

#exercise("16.L1", "Lisp")[
  Rewrite one station étude with no global `defparameter`, only arguments. Purity. Then thinking about races is easier.
]

#exercise("16.J1", "Java")[
  A race and `synchronized` — a separate class in `java-basics`, not in the live server. README: which numbers you saw. On Windows the threads are the same, surprise.
]

#exercise("16.J2", "Java")[
  Forty-five minutes, a voice recorder, eight questions from the list. Listening to yourself is embarrassing. On the interview there are fewer surprises.
]

#exercise("16.J3", "Java")[
  The same counter via `AtomicInteger`. Three numbers in the README: race / synchronized / atomic. The last two should match 200000. If atomic lied — you called `get`+`set`, not `incrementAndGet`.
]

#sicp[An object as a bundle of functions with a secret inside. If it suddenly got interesting why `private`.]

#sunday[
  Draw on paper two threads and `n++` in cells: reads / plus / writes. Label 42 and 43. That's the best cheat sheet for lesson 16, and the whiteboard won't take it away — the whiteboard is waiting for it.
]

#github[Commit `week16: auth indexes races`. In the README — EXPLAIN, three race numbers, two users. That's a portfolio, not "a little more Kafka."]
