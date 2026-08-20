#import "../lib.typ": *

= Месяц 3. Память, которая не сдувается

К двенадцатой неделе — PostgreSQL, нормальный набор «создать-прочитать-поменять-удалить», миграции Flyway, тесты. Микросервисов нет, и если кто-то шепчет «давай Кафку» — это сирена с соседней станции, не слушай. Застрял на Hibernate три дня? Добро пожаловать в профессию. Остаёшься здесь, не прыгаешь «вперёд».

До сих пор задачи жили в `ArrayList`. Перезапустил Spring — список пустой, как коридор после ночной смены. Файл из месяца 1 уже умел переживать кнопку «закрыть». База — тот же жест, только с языком, который умеет искать, не читая всё с начала, и с железным правилом: два человека не должны одновременно сломать одну и ту же строку так, чтобы станция раздвоилась.

#rhythm[
  *Пн–Чт:* 40 мин Lisp (файлы, вложенные списки, учебные «транзакции») + 120 мин Java (psql, JPA, тесты). \
  *Пятница:* добить красный Hibernate. Новых стартеров Spring не открывать. \
  *Суббота:* свой CRUD до конца: схема в README, curl на четыре жеста, десяток тестов. \
  *Воскресенье:* диверсия — крошечная «база» в файле. Postgres после этого покажется вежливым.
]

#rule[
  Сначала руками в `psql`. Потом Java. Кто сразу вешает `@Entity` на пустую таблицу в голове — потом три дня читает `Caused by` и винит Вселенную. Вселенная тут ни при чём. Колонки нет.
]

#lesson(9, [Сначала руками в базу, потом из Java])

=== Lisp: сохранить в файл — уже бессмертие

Процесс умер — память умерла. Файл живёт. В Lisp это выглядит почти неприлично просто: напечатать значение так, чтобы потом его же прочитать.

```lisp
(defun save-tasks (path tasks)
  (with-open-file (out path :direction :output :if-exists :supersede)
    (print tasks out)))

(defun load-tasks (path)
  (with-open-file (in path :direction :input :if-does-not-exist nil)
    (if in (read in) nil)))
```

`print`/`read` — Lisp разговаривает сам с собой текстом. Это не Postgres. Это тот же жест: состояние переживает кнопку «закрыть».

Набери в REPL, не копируй глазами:

```lisp
(defparameter *board*
  '((1 . "починить шлюз")
    (2 . "проверить антенну")
    (3 . "не открывать шлюз 3")))

(save-tasks "module-tasks.lisp-data" *board*)
```

Выключи SBCL. Открой заново. Память пустая. Файл — нет:

```lisp
(load-tasks "module-tasks.lisp-data")
; ((1 . "починить шлюз") (2 . "проверить антенну") (3 . "не открывать шлюз 3"))
```

#repl-note[
  `with-open-file` открывает поток и *закрывает* его, даже если посередине орнули ошибкой. Это тот же жест, что Java `try-with-resources`. Файл, который забыли закрыть, на станции потом не открывается «ну просто так».
]

Посмотри файл глазами — обычный текстовый редактор, не шаманство. Там скобки и кавычки. Если допишешь рукой ерунду, `read` обидится. Честная обида: «я ждал Lisp-значение, а получил кашу».

Сравни с Java-файлом из месяца 1: там ты сам решал, как класть строку. Здесь Lisp уже умеет сериализовать списки. Postgres умеет сериализовать *таблицы* и отвечать на вопросы вроде «все несделанные задачи вот этого человека». Файл на это отвечает только если ты сам напишешь цикл. База отвечает одним предложением на своём странном языке.

=== SQL, этот странный язык про таблицы

SQL — не Java. Не Lisp. Это язык про «покажи мне строки, которые вот такие». Пишешь, *что* хочешь, не *как* бежать по массиву. Postgres сам решит, идти глазами по всей таблице или заглянуть в шпаргалку (индекс — в следующем месяце, не торопись).

Сначала поставь Postgres *локально*. Не «в облаке на бесплатном тарифе». Станция чинится руками.

#os[
  *Мак:* `brew install postgresql@16`. Brew сам подскажет, как запустить сервис (`brew services start postgresql@16` или `pg_ctl`). Клиент: `psql postgres`. \
  *WSL (Ubuntu):* `sudo apt install -y postgresql postgresql-contrib`, потом `sudo service postgresql start`. Пользователя и базу заведи через `sudo -u postgres psql`. \
  *Windows без WSL:* установщик с https://www.postgresql.org/download/windows/ — галка pgAdmin по вкусу, пароль *запиши на бумажку*, правда запиши. Потом либо pgAdmin, либо `psql` из меню. \
  Пароль суперпользователя — не `1234` и не пустой, даже на локалке. Привычка. Через месяц этот же палец потянется в `application.yml`.
]

База `taskdb`. В `psql`:

```sql
CREATE DATABASE taskdb;
```

Postgres ответит `CREATE DATABASE`. Это не ошибка и не вопрос. Это «сделал». Дальше переключись внутрь:

```
\c taskdb
```

Строка приглашения сменится на `taskdb=#`. Если осталась `postgres=#`, ты всё ещё в служебной базе и сейчас создашь таблицу не там. Потом Java будет искать `tasks` в `taskdb`, не найдёт, и ты полчаса будешь спорить с пустотой.

=== Сессия, которую надо набрать пальцами

Не читай. Набери. Если скопировал целиком — набери ещё раз, хотя бы `INSERT` и `SELECT`.

```sql
CREATE TABLE tasks (
    id         BIGSERIAL PRIMARY KEY,
    title      TEXT NOT NULL,
    done       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Ответ: `CREATE TABLE`. Посмотри, что получилось:

```
\dt
```

```
         List of relations
 Schema | Name  | Type  |  Owner
--------+-------+-------+----------
 public | tasks | table | ты
```

`\d tasks` — чертёж таблицы: колонки, типы, default, первичный ключ. Это карта отсека. Без карты ты потом в Hibernate будешь гадать.

Теперь три задачи — священные четыре жеста начинаются с «положить»:

```sql
INSERT INTO tasks (title) VALUES ('починить шлюз');
INSERT INTO tasks (title) VALUES ('проверить антенну');
INSERT INTO tasks (title) VALUES ('не открывать шлюз 3');
```

Каждый раз: `INSERT 0 1`. Единица — сколько строк приехало. Ноль в середине — устаревшая вежливость про OID, забей.

```sql
SELECT id, title, done FROM tasks;
```

```
 id |        title         | done
----+----------------------+------
  1 | починить шлюз        | f
  2 | проверить антенну    | f
  3 | не открывать шлюз 3  | f
(3 rows)
```

`f` — false. Postgres не рисует галочки. `id` сам вырос: `BIGSERIAL` — счётчик. Ты его не передавал. Не передавай, пока сам не поймёшь, зачем.

Пометить первую сделанной:

```sql
UPDATE tasks SET done = TRUE WHERE id = 1;
```

`UPDATE 1` — одна строка. Если написал `WHERE id = 99`, будет `UPDATE 0`. Тишина. Не ошибка. Просто никого не нашли. В Java ты потом удивишься, что «обновил», а в базе тишина.

```sql
SELECT id, title, done FROM tasks WHERE id = 1;
```

```
 id |     title      | done
----+----------------+------
  1 | починить шлюз  | t
```

Удалить:

```sql
DELETE FROM tasks WHERE id = 1;
SELECT id, title FROM tasks;
```

```
 id |        title
----+----------------------
  2 | проверить антенну
  3 | не открывать шлюз 3
(2 rows)
```

Строка 1 исчезла. Дырки в id — норма. Первичный ключ — не «номер по порядку в отчёте капитану». Это бирка. Выкинул ящик с биркой 1 — следующие всё равно 4, 5, 6. Не пытайся «поджать». Станция не любит, когда переклеивают бирки задним числом.

#slow[
  Четыре жеста, запомни телом. `INSERT` — положить. `SELECT` — посмотреть. `UPDATE` — поменять *уже лежащее*. `DELETE` — выкинуть. HTTP из прошлого месяца — те же четыре, только через сеть: POST, GET, PUT/PATCH, DELETE. CRUD — не священное слово из вакансии. Это эти четыре жеста с таблицей. Если можешь сделать их в `psql`, Java — переводчик, не маг.
]

Попробуй сломать. Это важнее красивого `SELECT`.

```sql
INSERT INTO tasks (title) VALUES (NULL);
```

Postgres орнёт что-то вроде:

```
ERROR:  null value in column "title" of relation "tasks"
violates not-null constraint
```

`NOT NULL` — «пустое не класть», даже если Java забыла проверить. База — последний шлюз. Вахтёр на входе (сервис) вежливый. Шлюз железный.

```sql
INSERT INTO tasks (id, title) VALUES (2, 'дубликат бирки');
```

Если id=2 ещё жив:

```
ERROR:  duplicate key value violates unique constraint "tasks_pkey"
```

Первичный ключ — бирка, которая не должна повторяться. Две задачи с одним id — как два отсека с одной табличкой на двери. Пожарная команда приедет не туда.

=== Карман выживания в psql

Это не «выучи все слэш-команды». Это пять штук, без которых ты слепой:

- `\c имя` — перейти в базу
- `\dt` — какие таблицы
- `\d tasks` — чертёж таблицы
- `\q` — уйти
- Стрелка вверх — предыдущая команда, как в терминале

Точка с запятой в конце SQL *обязательна*. Забудешь — psql будет ждать и смотреть на тебя приглашением `taskdb-#` (минус вместо равно). Допиши `;` и Enter. Все так сидели. Даже те, кто потом пишет про «нативный SQL».

Строки в SQL — одинарные кавычки `'починить шлюз'`. Двойные `"title"` — это имена, и в Postgres они ещё и регистр фиксируют. Пока живи в нижнем регистре без кавычек: `title`, `tasks`, `done`. Java потом будет спорить с `"Title"` vs `title`, и это отдельный цирк.

=== Из Java: пока без магии, простой JDBC

Когда запрос живой в `psql`, можно звать его из Java. Стартер `spring-boot-starter-jdbc` плюс драйвер Postgres. В `pom.xml` (Spring Boot 3.x, Java 21):

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

`application.yml` — адрес станции, не секрет вселенной:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/taskdb
    username: postgres
    password: тот-что-на-бумажке
```

Пароль локалки в README ок. Пароль «как на проде» в git — нет, даже в шутку. Даже «временно». Git помнит дольше, чем ты.

`JdbcTemplate` — тонкий переводчик: вот SQL, вот как строку превратить в объект.

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

`rs` — текущая строка результата. `rowNum` — номер по порядку, часто не нужен, но сигнатура такая. Один `findAll` с `SELECT`. Контроллер как в прошлом месяце: `GET /tasks` зовёт репозиторий, не держит список в поле класса.

Когда этот запрос живой — на следующем занятии JPA, эта летающая аннотация. Сегодня важно увидеть: Java не «хранит в базе». Java *спрашивает* базу текстом. Тот же текст, что ты только что набрал в `psql`.

#os[
  В `application.yml` url будет `localhost` и на маке, и в WSL, и на Windows — если Postgres слушает локально. Если Java в WSL, а Postgres установлен *родным* виндовым MSI, `localhost` иногда капризничает: либо оба в WSL, либо оба на Windows. Не смешивай без нужды. Станция не любит два капитана. \
  Порт по умолчанию `5432`. Если установщик предложил другой — запиши. `Connection refused` почти всегда значит: сервис не запущен, или порт не тот, или ты стучишься не в ту машину.
]

=== Когда ругается, читай снизу не сразу — но и не сверху

Типичная каша при старте Spring:

```
org.postgresql.util.PSQLException: FATAL: password authentication failed
```

Пароль не тот. Не «пересоздать проект». Не «наверно Hibernate». Пароль.

```
org.postgresql.util.PSQLException: FATAL: database "taskdb" does not exist
```

Базу не создал, или создал в другом Postgres (виндовый MSI vs WSL — два сервера, две пустоты).

```
Connection to localhost:5432 refused
```

Сервис не запущен. Мак: brew services. WSL: `sudo service postgresql start`. Windows: службы или иконка слона.

```
ERROR: relation "tasks" does not exist
```

Таблицы нет. Ты в той базе? `\c taskdb`, `\dt`. Часто люди создают таблицу в `postgres`, а Java смотрит в `taskdb`.

#warn[
  Не ставь `ddl-auto: create` «чтобы само». Сегодня таблицы делает твоя рука в `psql`. Завтра — Flyway. Hibernate, который сам дорисовывает схему в полночь, — как механик, который подкручивает болты без журнала. Наутро никто не знает, какие болты.
]

#exercise("9.L1", "Lisp")[
  Сохрани alist задач в файл и открой *новую* сессию SBCL, загрузи. Бессмертие за пять минут. Если загрузилось то же, что сохранил — ты уже понял базы лучше, чем половина гайдов с `@Entity` на первой странице.
]

#exercise("9.J1", "Java")[
  В `psql` (или pgAdmin) создай таблицу и три задачи. `SELECT` скопируй в README. Честный вывод, не «ну я сделал». Три строки, заголовок, `(3 rows)` — вот это.
]

#exercise("9.J2", "Java")[
  `GET /tasks` из базы через `JdbcTemplate`. Пароль локалки в README ок. Пароль «как на проде» в git — нет, даже в шутку.
]

#exercise("9.J3", "Java")[
  Сломай специально: неверный пароль в yml, запусти, *одну* строку исключения — в README. Потом верни. Потом несуществующая база. Потом несуществующая таблица. Три разных орá, три разных смысла. Это не садизм. Это карта аварий.
]

#github[Коммит `week9: psql and jdbc`. В коммите — SQL создания таблицы, не только Java. Схема — тоже код.]

#lesson(10, [JPA: таблица притворяется объектом])

Вчера Java спрашивала базу текстом. Сегодня объект притворяется строкой. Это удобно, пока не врёт. Врёт оно красиво: «у меня же поле есть», а колонки нет.

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

Нужен пустой конструктор — JPA странная и вызывает его из-под земли, потом расставляет поля. `protected` — чтобы ты сам не писал `new Task()` без названия по привычке. Геттеры/сеттеры — да, многословно, мы в Яве. `record` как entity — пока не надо: JPA хочет менять поля у живого объекта, а record — заморозка.

`GenerationType.IDENTITY` — «id выдаст Postgres, у нас `BIGSERIAL`». Не `AUTO` «ну как-нибудь». Не `SEQUENCE`, пока сам не понял, зачем отдельная последовательность. Станция на IDENTITY держится, и нормально держится.

=== Пустой интерфейс, который врёт что он пустой

```java
public interface TaskRepository extends JpaRepository<Task, Long> {}
```

Пустой интерфейс, а Спринг дописывает реализацию. Это выглядит как мошенничество. Внутри — не мошенничество, а кодогенерация, но ощущение то же.

`JpaRepository<Task, Long>` значит: сущность `Task`, первичный ключ `Long`. Методы уже есть: `save`, `findById`, `findAll`, `deleteById`. Имена `findByTitle`, `findByDone` Спринг тоже соберёт из названия метода. Пока не собирай десять `findBy`. Один CRUD.

Сервис:

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

Контроллер как в месяце 2, только список живёт не в поле сервиса, а в Postgres. Перезапустил Spring — задачи на месте. Вот ради чего мы вообще завели слона.

=== Flyway: схема из файлов, не из полночных догадок

Файл `src/main/resources/db/migration/V1__tasks.sql`:

```sql
CREATE TABLE tasks (
    id         BIGSERIAL PRIMARY KEY,
    title      TEXT NOT NULL,
    done       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Два подчёркивания после версии. `V1__tasks.sql` — да. `V1_tasks.sql` — Flyway не съест и обидится загадочно. Имя файла — контракт.

В `application.yml`:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
  flyway:
    enabled: true
```

`validate` — «сверь аннотации с живой схемой, ничего не дорисовывай». Не совпало — не стартуем. Это хорошо. Лучше красный старт, чем тихая колонка-призрак.

#rule[
  Схема живёт в SQL-миграциях. Аннотации описывают то, что *уже есть*. Если поменял поле — напиши `V2__...sql`, не надейся, что Hibernate догадается и все вокруг скажут спасибо.
]

Стартер: `spring-boot-starter-data-jpa` плюс Flyway (`flyway-core` и для Postgres  — `flyway-database-postgresql` в свежих версиях). Версию смотри в документе *твоего* Spring Boot, не в статье 2019 года.

Удали базу, создай пустую, подними приложение. Flyway прогонит V1, в таблице `flyway_schema_history` появится строка. Это журнал шлюза: какие миграции уже были. Не правь руками V1, который уже улетел на другую машину. Только новая версия. Иначе у друга история разъедется, и вы оба будете правы, и оба красные.

=== Три дня красный Hibernate: читай первое `Caused by`

Стек Spring — как объявление по станции: сначала «внимание», потом десять уточнений, и только внизу «люк открыт». Читать сверху целиком — путь к отчаянию. Ищи *первое* `Caused by`.

Вот типичный сеанс ужаса. Старт приложения, полэкрана красного.

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
  Первая строка говорит: «не создался бин». Это погода. Настоящая новость — `Caused by`. Тут: в таблице `tasks` нет колонки `created_at`. Либо забыл миграцию, либо в entity поле есть, в SQL нет, либо наоборот. Лечение: `\d tasks` в psql, сравни с классом, допиши `V2` или поправь V1 *если ещё никто этим V1 не пользовался*. Не «пересоздать проект». Проект ни при чём. Колонки нет.
]

Ещё хит:

```
Caused by: org.hibernate.InstantiationException:
No default constructor for entity:  : com.example.taskmanager.Task
```

Пустого конструктора нет. JPA не может вызвать `new Task()` из-под земли. Добавь `protected Task() {}`. Не делай его `public`, если не хочешь, чтобы коллега создавал безымянные задачи.

Ещё:

```
Caused by: org.springframework.beans.factory.BeanCreationException:
Error creating bean with name 'taskController'
...
Caused by: ... No default constructor for ... TaskService
```

Это уже не Hibernate, а Спринг: сервис без конструктора, который принимает репозиторий, и без пустого. Один конструктор с зависимостями — нормально, Спринг его возьмёт. Два — запутается. Не плоди.

Ещё, любимый цирк с именами:

```
Caused by: org.hibernate.tool.schema.spi.SchemaManagementException:
Schema-validation: missing column [done] in table [tasks]
```

В SQL ты назвал `is_done`, в Java — `done`. Или наоборот. Или Postgres сложил в `"done"` с кавычками, а Hibernate ищет `done`. `\d tasks` — правда. Аннотация `@Column(name = "done")` — если хочешь явно.

#warn[
  Три дня красный Hibernate — читай *первое* `Caused by`. Почти всегда «нет колонки» или «нет конструктора». Не «пересоздать проект». Пересоздать проект — как выйти в космос без скафандра, потому что в шлюзе пикнуло.
]

=== Проект содержит задачи, JSON не должен есть свой хвост

Связь «проект содержит задачи»:

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

Миграция V2 (раз V1 уже про задачи без проекта — не переписывай V1, допиши):

```sql
CREATE TABLE projects (
    id   BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

ALTER TABLE tasks
    ADD COLUMN project_id BIGINT REFERENCES projects (id);
```

Не отдавай в JSON цикл «проект → задачи → проект → …». Jackson пойдёт по геттерам, как робот-пылесос в зеркальном отсеке. Браузер зависнет, ты будешь винить Вселенную.

Отдавай DTO без обратной ссылки:

```java
public record TaskView(Long id, String title, boolean done) {}
public record ProjectView(Long id, String name, List<TaskView> tasks) {}
```

Сервис собирает `ProjectView` руками. Контроллер не возвращает entity. Entity — домашний халат. JSON — то, что можно показать гостю.

#repl-note[
  `mappedBy = "project"` значит: «чувак, колонка связи живёт на стороне Task, не рисуй вторую». Без этого Hibernate иногда заводит лишнюю таблицу-мост, и ты в `\dt` видишь `projects_tasks` как незваного родственника.
]

`FetchType.LAZY` — «задачи не тащи, пока не попросили». Добрый до поры. Пора называется N+1, это следующее занятие. Сегодня достаточно не сделать `EAGER` «на всякий случай». На всякий случай — это всегда все сразу, даже когда ты хотел имя проекта.

=== Починить станцию, когда «ну вчера работало»

- Приложение стартануло, таблиц нет: Flyway выключен или кладёт файлы не в `db/migration`.
- Flyway пишет `checksum mismatch`: ты поправил уже применённый V1. Верни файл как был, сделай V3. Или на *локалке* можно снести базу и прогнать с нуля — на проде так нельзя, запомни это предложение.
- `failed to connect`: снова пароль, порт, WSL vs Windows.
- Сохранил entity, в psql пусто: смотришь не ту базу / не ту схему `public`. Или транзакция откатилась — об этом завтра.

#exercise("10.L1", "Lisp")[
  Проекты вложенными списками. `tasks-of` по id проекта. Карта станции, не таблица Excel. Например `'((1 . (шлюз антенна)) (2 . (кофе)))`.
]

#exercise("10.J1", "Java")[
  Entity, repository, CRUD по HTTP, Flyway V1. Чтобы после удаления базы мир поднимался из SQL, а не из памяти. Проверка: дропни `taskdb`, создай пустую, `spring-boot:run`, таблицы на месте.
]

#exercise("10.J2", "Java")[
  `Project` и `GET /projects/{id}/tasks`. JSON без бесконечной вложенности. Станция не рекурсивна. Ну, почти.
]

#exercise("10.J3", "Java")[
  Намеренно разъедь схему: добавь поле в entity, миграцию не пиши, `ddl-auto: validate`. Старт красный. Первое `Caused by` — в README одной цитатой. Потом напиши V2 и почини. Это занятие про чтение ошибок, не про «чтобы зелёное».
]

#lesson(11, [Всё или ничего, и запах лишних запросов])

=== Шлюз и деньги: зачем вообще «сделка»

На станции два люка шлюза. Если открыть оба сразу — воздух улетает, ты тоже. Правило: либо оба закрыты, либо открыт один, второй держит. Промежуточного «ну я как раз посередине» для воздуха не существует.

Деньги — тот же шлюз. Списать 100 со счёта Алекса, начислить 100 Боре. Если после списания свет моргнул и начисление не случилось — 100 исчезли. Не «временно в пути». Исчезли. Капитан будет недоволен, и это ещё мягко сказано.

```
начало сделки
  Алекс: 500 → 400
  Боря:  100 → 200
конец сделки  → оба изменения видны
```

Если между двумя UPDATE упало:

```
начало сделки
  Алекс: 500 → 400
  БАБАХ
откат → Алекс снова 500, Боря 100, как будто не было
```

#slow[
  Транзакция — не «быстро». Транзакция — *всё или ничего*. Либо оба люка в правильном положении, либо станция делает вид, что ты к рычагу не прикасался. `@Transactional` на методе сервиса говорит Спрингу: все SQL внутри — одна сделка. Исключение (unchecked, обычный RuntimeException) — откат. Дошёл до конца метода — фиксация, `COMMIT`. Пока нет фиксации, другой сеанс в psql может этих изменений не видеть. Это не баг. Это шлюз ещё не закрылся.
]

В psql можно потрогать руками. Сеанс 1:

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE name = 'alex';
-- ещё не COMMIT
```

Сеанс 2, другое окно psql:

```sql
SELECT name, balance FROM accounts WHERE name = 'alex';
```

Пока первый не сказал `COMMIT`, второй часто видит старое (зависит от изоляции, для учебника: «не видно, пока не закрыли шлюз»). В первом: `COMMIT;` — и у второго после нового `SELECT` уже 400. Или в первом `ROLLBACK;` — и как не было.

Для задач то же самое: создать проект и первую задачу. Если title задачи пустой — проекта в базе тоже не должно остаться. Иначе в `\dt` живёт проект-сирота, а ты клянёшься, что «метод же упал». Упал. Но без сделки успел закоммитить первую половину.

=== `@Transactional`: на публичном, не на секретном

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

В `completeAll` нет явного `save`. Грязный трюк JPA: объект, которого достали в транзакции, при фиксации сам уедет в UPDATE. Это называется dirty checking, «подглядеть, что испачкали». Удобно. И страшно, когда ты не ждал UPDATE, а он уехал.

На `private` не вешай: Спринг смотрит через прокси и частное не видит. Магия с дыркой.

#slow[
  Спринг подсовывает вместо твоего сервиса *обёртку*. Вызов снаружи: обёртка открывает транзакцию, зовёт твой метод, закрывает. Вызов `this.createWithFirstTask(...)` из соседнего метода того же класса — обёртку обходит, идёшь напрямую. Транзакции нет. Как постучать в свой же шлюз изнутри: дверь не та. Поэтому `@Transactional` живёт на *публичном* методе, который зовут снаружи — из контроллера, из теста. Не на `private void helper()`.
]

Проверь глазами. Тест или curl: создай проект с пустым title задачи. В psql:

```sql
SELECT * FROM projects;
SELECT * FROM tasks;
```

Обе пустые — сделка сработала. Проект есть, задач нет — ты только что изобрёл сироту. Ищи: исключение checked и не откатило; или `private`; или два метода без общей транзакции; или в контроллере уже поймал исключение *после* того как первый `save` ушёл без `@Transactional`.

#warn[
  Не лови `Exception` внутри транзакционного метода и не проглатывай. Проглотил — Спринг думает, что всё хорошо, делает COMMIT. Пожар записан в журнал как «успешная вахта».
]

=== N+1: пятьдесят проектов, пятьдесят один запрос, горелая изолента

Включил `spring.jpa.show-sql=true` (а лучше ещё `logging.level.org.hibernate.SQL: DEBUG`). Сделал `GET /projects`. В логе:

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

И так дальше. Один `select` проектов. Потом *на каждый* проект — свой `select` задач, потому что список задач ленивый: Jackson (или твой цикл) ткнул в `getTasks()`, Hibernate сходил в базу. 50 проектов — 51 запрос. Это N+1. Пахнет как горелая изолента.

#slow[
  Почему «плюс один»: N штук детей + один запрос родителей. Не «база медленная». Ты спросил её пятьдесят один раз вместо одного JOIN. На трёх строках не заметишь. На трёх тысячах заметит капитан, пользователь и твой ноутбук, который начнёт выть как насос.
]

Лечение потом, но сегодня хотя бы запах узнать и *один* раз увидеть лекарство:

```java
@Query("select p from Project p left join fetch p.tasks where p.id = :id")
Optional<Project> findWithTasks(@Param("id") Long id);
```

`JOIN FETCH` — «притащи задачи тем же запросом». В логе после этого часто *один* `select ... from projects ... left join tasks`. Не всегда красивый SQL. Зато один.

Не лечи всё подряд `EAGER`. EAGER — «всегда тащи». Потом `findAll` проектов для выпадающего списка будет возить тонны задач, которые никто не просил. Лечи конкретный запрос, который пахнет.

JOIN в psql, чтобы увидеть, чего Hibernate хочет:

```sql
SELECT p.id, p.name, t.id, t.title
FROM projects p
LEFT JOIN tasks t ON t.project_id = p.id
ORDER BY p.id, t.id;
```

Одна таблица слева, задачи справа, пустые задачи — `NULL` в правых колонках. Это тот же JOIN FETCH, только руками. Если этот SELECT понятен — аннотация уже не молитва.

Посчитать запросы: один `GET`, глаза в лог, палочками на полях README. Если запросов как отсеков — вот он, N+1, здоровайся.

=== Изоляция — слово на собесе, не кнопка на этой неделе

Тебя могут спросить «что такое isolation». Короткий честный ответ: насколько сделка видит чужие незакрытые шлюзы. По умолчанию Postgres `READ COMMITTED` — видишь только зафиксированное. `SERIALIZABLE` — строже и дороже. Не ставь сериализуемость «для надёжности» на учебный CRUD. Надёжность сегодня — `@Transactional` на том методе, где два изменения должны жить или умереть вместе.

#exercise("11.L1", "Lisp")[
  Список операций. Если среди них `'fail` — не применять ни одну. Учебная «транзакция»: либо шлюз закрыли, либо не трогали. Без полуоткрытого люка.
]

#exercise("11.J1", "Java")[
  Один метод: проект + первая задача. Пустой title задачи — проекта в базе тоже не должно остаться. Проверь глазами в `psql`. Не верь только тесту, который смотрит в тот же EntityManager: глянь другим глазом, из другого окна.
]

#exercise("11.J2", "Java")[
  SQL-лог, один `GET` списка, число запросов в README. Если запросов как отсеков — вот он, N+1, здоровайся.
]

#exercise("11.J3", "Java")[
  Тот же `GET`, но через метод с `JOIN FETCH` (или DTO-запрос без ленивой коллекции). Снова посчитай `select` в логе. Два числа рядом в README: до и после. Если «после» не меньше — fetch не туда прикрутил, или Jackson всё равно тыкает в другую связь.
]

#lesson(12, [Тесты, которые ходят в настоящую базу])

Юнит-тест сервиса с моком репозитория проверяет, что ты вызвал `save`. Он не проверяет, что Postgres проглотил строку, что Flyway прогнался, что `NOT NULL` жив. К концу месяца нужны тесты, которые *стучатся*. Иначе у тебя зелёная полоса и мёртвая база — как зелёная лампочка у открытого люка.

=== Идеал — Postgres в коробке на время теста

Testcontainers: Docker поднимает настоящий Postgres, тест гоняет миграции, потом коробка умирает. На маке и Windows (Docker Desktop + WSL2) это умеет. Зависимость `spring-boot-testcontainers` плюс `postgresql` модуль Testcontainers — смотри BOM своего Boot.

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
        Task t = service.create("шлюз");
        assertTrue(service.findById(t.getId()).isPresent());
        assertEquals("шлюз", service.findById(t.getId()).get().getTitle());
    }
}
```

Это не «магия Docker». Это честный слон, только временный. Если тест зелёный здесь, велик шанс, что и на твоём `localhost:5432` не соврёт.

#os[
  Docker Desktop на маке: обычно просто работает. На Windows — ставь с WSL2 backend, не с Hyper-V «потому что галочка». В WSL `docker ps` должен видеть те же контейнеры. Если IDEA на Windows, а Docker только в Ubuntu — снова два капитана. \
  Нет Docker и пока страшно: профиль `test` и H2. В README *честно*: «прод — Postgres, тесты — упрощение». Ложь в README потом всплывёт на собесе быстрее, чем ты скажешь «на самом деле». H2 не Postgres. `TIMESTAMPTZ`, массивы, куча функций — другой диалект. Для джуна на месяц 3 — допустимый костыль, если подписан.
]

=== Четыре жеста — четыре теста, не «ну глазами»

```java
@Test
void unknownIdIsEmpty() {
    assertTrue(service.findById(9_999_999L).isEmpty());
}

@Test
void updateChangesTitle() {
    Task t = service.create("старое");
    service.rename(t.getId(), "новое");
    assertEquals("новое", service.findById(t.getId()).get().getTitle());
}

@Test
void deleteThenGone() {
    Task t = service.create("временное");
    service.delete(t.getId());
    assertTrue(service.findById(t.getId()).isEmpty());
}
```

Красное/зелёное, не «ну глазами потыкал». Глаза врут, когда хочется спать. `assertTrue(true)` — преступление против станции: тест, который не умеет упасть.

Для HTTP — `@SpringBootTest(webEnvironment = RANDOM_PORT)` и `TestRestTemplate` или `MockMvc`. Хотя бы create и get неизвестного. Четыреста на пустой title, не пятьсот.

Транзакционный тест из занятия 11 тоже сюда: пустой title — `assertEquals(0, projectRepository.count())`. Потом всё равно глянь psql один раз в жизни, чтобы поверить, что count не врёт.

=== README этой недели — бортовой журнал, не поэзия

Как поднять Postgres на маке *и* в WSL/Windows. Какой url в yml. Как гонять миграции (они сами на старте — напиши это). Как тесты: `./mvnw test` / `mvnw.cmd test`. Пять curl: health если есть, POST, GET списка, GET одного, DELETE. Пример JSON. Если Docker для Testcontainers обязателен — одной строкой «без Docker интеграционные тесты не встанут».

Чужая машина (или твоя вторая ОС) — критерий. «У меня в IDEA» не считается сдачей вахты.

=== Что должно стоять на палубе к концу недели 12

Живой CRUD. Схема в SQL, не в голове. Entity не торчат циклом в JSON. Хотя бы один `@Transactional` сценарий, который откатывается. SQL-лог, который ты видел своими глазами. Десяток тестов, среди них не все моки. Коммит. Это и есть «монолит». Одна программа. Не зоопарк.

Кафку в этот коммит не класть, даже «на почитать». Почитать можно в браузере, не в `pom.xml`.

#exercise("12.L1", "Lisp")[
  Учебный «интеграционный тест» без JUnit: сохрани задачи, запусти *новую* SBCL, загрузи, проверь `equal` с тем, что ждал. Если не equal — `(error "станция потеряла журнал")`. То же чувство, что зелёный IT: второй процесс, не та же память.
]

#exercise("12.J1", "Java")[
  create; get неизвестного; update title; delete. Красное/зелёное, не «ну глазами потыкал».
]

#exercise("12.J2", "Java")[
  README: как поднять Postgres на маке *и* в WSL/Windows, миграции, тесты, curl.
]

#github[Коммит `week12: crud postgres`. Кафку в этот коммит не класть, даже «на почитать».]

#sunday[
  Своя крошечная «база»: дописываешь файл, в памяти карта id → место в файле. `insert` пишет в конец. `select` по id прыгает. Потом сравни с Postgres и немного его уважай: ты только что набросал кусок того, за что людям платят зарплату и ещё дают отпуска.
]

#sicp[
  Состояние, которое переживает процесс — старый вопрос: что такое данные, если программа выключилась. Файл, таблица, лог. Если зудит «а можно ли базу как список пар» — можно, ты уже делал alist. Postgres — список пар, который научили отвечать на вопросы и не терять хвост при сквозняке.
]
