#import "../lib-en.typ": *

= Month 5. Vacancy words, on your own hardware

This month's job posts sound like a parts list from someone else's station: Redis, a queue, Kafka, Docker, CI. Pretty words. In interviews people say them with a smart face. Your job is not to memorize the words. It's to touch each thing *on your own* monolith, while it lies, screams, and refuses to start.

If the cache lies — you'll see it with curl. If the queue doesn't drain — you'll see it in the log. If in Docker the database "can't be found" — you almost certainly wrote `localhost` inside the container. This isn't theory. This is an evening with a kettle.

#rule[
  Entry here is with a living monolith: a database, password login, tests, a README. Otherwise finish month 4. Better a delay than Kafka on an empty CRUD. Empty CRUD plus Kafka is a station with no walls and a loudspeaker.
]

#os[
  Redis, Postgres, and the app this month live in Docker. On a Mac — Docker Desktop or Colima, whichever you already have. On Windows — Docker Desktop + WSL2. One YAML. The same `docker compose up` commands. Don't install Redis "also brew, and MSI, and apt in WSL" all at once: three Redises on one machine is a quest nobody ordered.
]

#lesson(17, [Cache: fast, cheeky, sometimes a liar])

A cache is a copy closer by. Faster than the database. It can also tell a fairy tale about a task you already deleted. On station MODULE that's a plaque on the airlock wall: "oxygen: nominal." They hang the plaque so you don't run to the hold every time. If the tank is already empty and the plaque is old — you'll open the hatch anyway. That's a cache.

The database is the hold. The cache is the plaque. HTTP without a cache goes down to the hold every time. With a cache — it looks at the wall. While the plaque is fresh, life is beautiful. Then someone changed the tank, forgot the plaque, and the interview asks: "you updated, the cache is stale — what happens?"

If you answer "well it does it itself" — it doesn't. Itself it only expires on TTL, if you set a TTL. Or it lies forever, if you set "forever" and forgot the eviction.

=== Why bother, if the database is "fast anyway"

On three tasks Postgres answers instantly, and a cache looks like theater. On three thousand tasks that get read a hundred times a second, the hold starts puffing. A cache makes sense when:

- the same data gets read often;
- you can write less often than you read;
- you *agree* to sometimes show something slightly stale, or you know how to drop the key on write.

A user's task list for 30 seconds is a textbook ceiling. Don't cache "every task of every person forever." That's not speed. That's a museum of lies.

=== Redis in a box, not "I'll install it on the system"

Image `redis:7`. Not latest. Latest is "whatever environment," and you're already old enough to get angry at sudden surprises.

In `docker-compose.yml` for now you can have *only* Redis, if Postgres is still local. Later, in lesson 20, you'll put everyone in one play. Today this is enough:

```yaml
services:
  redis:
    image: redis:7
    ports:
      - "6379:6379"
```

`docker compose up -d redis`. Then:

```
docker compose exec redis redis-cli ping
```

It should answer `PONG`. That's not a joke and not a password. That's Redis saying "alive."

#os[
  Port 6379 on a Mac and in Docker Desktop on Windows is the same: from the host, `localhost:6379`. Java on the host (IDEA) talks to `localhost`. Java *inside* the app container in lesson 20 will go to host `redis`, not `localhost`. Write that in pencil on your forehead. In two weeks the forehead will come in handy.
]

In Spring Boot 3 / Java 21 usually a cache starter plus Redis. Check property names against *your* version, not a 2019 guide. Roughly:

```yaml
spring:
  cache:
    type: redis
  data:
    redis:
      host: localhost
      port: 6379
```

Cache the task list for 30 seconds. On write — throw the key away. Don't "update the cache by hand with the same JSON": throw it away. Let the next GET go to the database and put something fresh. Two actions, not twelve.

=== Story one: the plaque lies (stale cache)

Someone created a task "fix the antenna." GET `/tasks` — they see it. Then they renamed it to "fix the antenna now." GET — still "fix the antenna," no "now." Ten seconds passed. The person screams that the server is broken. The server isn't broken. *You* are: you cached the list and forgot to drop the key on update.

That's the main interview question about cache. Not "what is Redis." It's: you updated, the cache is stale — what happens, and how do you fix it.

Fix it like this:

1. On any write (create / update / delete) delete the key. Not "later." In the same request, after a successful write to the database.
2. A TTL, so even a forgotten key dies on its own. 30 seconds for study. In battle you pick a TTL, it isn't magic of the number 30.
3. Don't cache things that are different every time (a random quote of the day — fine; "the current user just saved" — no).

#slow[
  Reproduce the lie on purpose. Comment out the key drop. Create a task. GET. Update the title. GET immediately — the old name. Wait 31 seconds. GET — the new one. There, you *saw* TTL in your body, not in an article. Put the drop back. Now the second GET is immediately fresh. README: how to repeat both variants. It's useful to know how to break your own station on purpose. Otherwise in the interview you'll say "well in theory," and theory will smile at you with a yellow card.
]

=== Story two: a hundred elephants on a footbridge (cache stampede)

The cache expired. No key. In that millisecond a hundred GET `/tasks` arrived. A hundred requests didn't find the plaque, a hundred went down to the hold. Postgres got a herd. That's called cache stampede or thundering herd — a loud herd. On the station: the sensor went dark, and the whole crew ran for one hatch.

On three users you won't see this. In a demo you can draw it in the log: turn Redis off, or set TTL to 1 second, and throw a bunch of curls in a loop. In the log — a bunch of identical `SELECT`s. The database is alive, but that's already a smell.

You don't fix it with "install Redis again." Redis just expired, that's the joke. You fix it like this:

- *drop on write* matters more than a short TTL "so it's always fresh." Fresh and stampede are neighbors;
- one recompute: whoever first didn't find the key goes to the database, the others wait for them (in Java that's already a lock / `synchronized` on the key, or libraries like Caffeine with refresh; in prod also singleflight — remember the word, don't write the implementation from scratch today);
- sometimes honestly serve something slightly stale while the new key computes. That's adult games. For the textbook it's enough to know the *name of the trouble*.

In an interview this is enough: "if a lot of requests hit an empty key at once — they all go to the database; I'd keep a short lock on recompute or not set a one-second TTL on a hot key." That's better than "Redis is very fast."

=== Lisp: a stick-and-string Redis

We don't need a socket. We need a hash-table and time. Time in Common Lisp is `(get-universal-time)`, seconds since 1900, like a ship's clock that doesn't care about your timezone.

```lisp
(defstruct centry value expire)

(defun cset (h key value ttl)
  (setf (gethash key h)
        (make-centry :value value
                     :expire (+ (get-universal-time) ttl))))

(defun cget (h key)
  (let ((e (gethash key h)))
    (when (and e (< (get-universal-time) (centry-expire e)))
      (centry-value e))))
```

`cset` puts a value and writes on the crate "good until." `cget` looks at the clock. Expired — `nil`, as if the key was never there. Doesn't have to delete: you can delete, you can leave a corpse. For the étude `nil` is enough.

#repl-note[
  Put `'tasks` for 2 seconds. Immediate `cget` — the list. Wait three seconds in the REPL: `(sleep 3)`. `cget` again — `nil`. You just touched TTL without Docker. Redis in prod does roughly this gesture, only with a network, persistence, and a pile of buttons you don't need yet.
]

Drop on write is just `(remhash key h)`. Forgot `remhash` — you get a fairy tale until the deadline. Same lie as in Java, only without YAML.

#exercise("17.L1", "Lisp")[
  A hash-table that expires by time. `get` after the deadline — `nil`. A stick-and-string Redis.
]

#exercise("17.J1", "Java")[
  Cache the list, 30 seconds, drop on write. README: how to see the cache lie *if you forget* the drop. It's useful to know how to break your own station on purpose.
]

#exercise("17.J2", "Java")[
  A short TTL (a second or two) and a loop of twenty `curl`s in a row while the key is dead. In the log count how many times the service went to the database. Write the number in the README. This isn't a benchmark, it's touching a stampede with a finger. If it's always one SELECT — either the cache didn't turn off, or you got lucky with one thread; then add parallelism (`xargs -P` or two windows).
]

#warn[
  Don't cache responses with personal data "for everyone" under one key `tasks`. The key must know *whose* this is: `tasks:user:42`. Otherwise a neighbor on the station reads your list titled "don't tell anyone." A cache is not where permissions suddenly vanish.
]

#github[
  A commit like `week17: redis cache ttl 30s`. In the README — two scenarios: the lie without a drop and the truth with a drop. A log screenshot is optional. The words "I saw stale" are required.
]

#lesson(18, ["Do it later": a queue, not a second server])

An email "a task was created" must not knock HTTP over if mail is down. Imagine: you're on watch, someone asks "write down the task and tell ground." If you call ground first and the antenna is silent for three minutes, the person at the airlock stands there and hates you. Right: write the task, answer "got it," and put the note "tell the human" in a tray. The tray is a queue.

First a Spring event or a `BlockingQueue` in the same process. Then RabbitMQ — *one* scenario. Kafka isn't needed today, however many times it shows up in the dream vacancy. Kafka is a log in the next lesson. A queue is a tray. Those are different objects, even if résumés write them through a comma like siblings.

=== First a tray in the cabin: `BlockingQueue`

Java has a queue that can *wait*. Not spin in `while (true)` and burn CPU, but sleep until someone puts a note.

```java
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

BlockingQueue<String> q = new ArrayBlockingQueue<>(16);
```

Capacity 16 — on the station the tray isn't rubber. If you put a 17th while nobody took one, `put` *stops and waits*. That isn't a bug. That's "don't lose notes and don't inflate memory."

#slow[
  Two characters. The producer is the watch officer. The consumer is the runner.

  ```java
  Thread producer = new Thread(() -> {
      try {
          q.put("tell ground: task 7");
          System.out.println("put");
      } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
      }
  }, "producer");

  Thread consumer = new Thread(() -> {
      try {
          String note = q.take();
          System.out.println("took: " + note);
      } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
      }
  }, "consumer");

  consumer.start();
  producer.start();
  ```

  `take` with no note — waits. `put` with no room — waits. `InterruptedException` is "they asked me to stop"; we put the flag back and don't pretend nothing happened. Run it in `java-basics`, not in the live server. Watch the order of the lines: sometimes "put" before "took," sometimes the other way — that's two threads, not a detective story.
]

`offer` doesn't wait: didn't fit — `false`. `poll` doesn't wait: empty — `null`. For "do it later" in the same process you usually want `put`/`take`: better to stand than to lose "tell the human."

Why not an `ArrayList` plus your own thread with `sleep(100)`? Because `sleep` is fortune-telling. `take` is a contract. In an interview "I spun sleep in a loop" sounds like "I fixed the airlock with a hammer." A hammer sometimes works. Then the hatch falls off.

=== Spring: an event, not a second microservice

In a monolith it's even simpler than handmade threads. Created a task — published an event. A listener writes to the log. HTTP already answered 201, or is about to, depending on *when* you listen.

A rough skeleton:

```java
public record TaskCreatedEvent(long id, String title) {}
```

In the service after `save`:

```java
publisher.publishEvent(new TaskCreatedEvent(saved.getId(), saved.getTitle()));
```

Listener:

```java
@Component
public class NotifyListener {
    private static final Logger log = LoggerFactory.getLogger(NotifyListener.class);

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void on(TaskCreatedEvent e) {
        log.info("tell ground: task {} \"{}\"", e.id(), e.title());
    }
}
```

`AFTER_COMMIT` — don't shout "created" if the transaction later rolled back. Otherwise the runner sprints down the corridor with news of a task that doesn't exist. This is a tray-queue tied to the fact "it's already in the database."

Don't hook up real mail. A log is enough. SMTP on a textbook station is an invitation to spend Friday on a Gmail password.

=== When RabbitMQ already, and when not yet

RabbitMQ is a separate broker: you put a message, another process takes it, even if your server died and came back. That's already "a tray in the next room." It makes sense when:

- "tell the human" must survive a JVM restart;
- or another service will do it (you are *not* carving that out today).

One scenario: after create you put JSON on queue `task-created`. A separate `@RabbitListener` writes the same log. Docker image `rabbitmq:3-management`. If the broker doesn't stand up in an evening — fall back to `BlockingQueue` / a Spring event and write that honestly in the README. Honesty is prettier than a checkbox again.

#warn[
  Don't stand up a "notifications microservice" as a separate repository while the monolith's compose doesn't stand up. Carving out a service is easy. Then fixing "the task is in the database but the email went out about a rollback" is not. Pain of transactions between two databases we did not order.
]

=== Lisp: a queue as a list with a bad temper

```lisp
(defparameter *q* nil)

(defun enqueue (x)
  (setf *q* (append *q* (list x))))

(defun dequeue ()
  (let ((x (first *q*)))
    (setf *q* (rest *q*))
    x))
```

`append` walks the whole list every time. For an étude that's fine. For a station in battle — like carrying bolts one at a time from the hold to the nose, starting from the hatch every time. In Java for a queue — `ArrayDeque` or `ArrayBlockingQueue`, don't invent `append`.

`drain` — until empty, print:

```lisp
(defun drain ()
  (loop while *q*
        do (format t "~a~%" (dequeue))))
```

#repl-note[
  Three `(enqueue ...)`, then `(drain)`. The queue is empty. Another `(drain)` — silence. FIFO: whoever lay in the tray first gets read first. This is not priority "the antenna beats washing a porthole." Priority is another story, not today's.
]

#exercise("18.L1", "Lisp")[
  A notification queue. `drain` prints them all. Like a watch officer who finally reached the stack of notes.
]

#exercise("18.J1", "Java")[
  After create — an event, the listener writes to the log "tell ground …". A listener test is optional. Working code is required.
]

#exercise("18.J2", "Java")[
  A separate class in `java-basics`: a `BlockingQueue` of 4 slots, the producer puts 8 notes, the consumer takes them. Log: when `put` waited, when `take` waited. README — five lines "what a blocking queue is." No Spring. By hand.
]

#sunday[
  Draw on paper: HTTP request → service → database → event → tray → "email." Where did the human already get 201? If after the database — good. If after the email — the antenna is holding the airlock again. Paper is cheaper than Kafka.
]

#lesson(19, [Kafka: a log, not a telephone])

Kafka is not "call the neighboring service." It's a log: a writer appended to a topic, a reader crawls from an offset. Like a ship's log you cannot erase with a rubber. On MODULE they keep a log like that at the reactor: the watch wrote "pressure 1.2," the next watch reads *from a bookmark*, they don't call the previous one and ask "repeat, I didn't write it down."

If Docker is already a friend: one broker, one topic `task-events`, a producer from the service, a consumer that logs. If it's hard — an honest outline in `docs/kafka.md` and *don't break* the monolith. Kafka on a résumé only if *this* code opens. A word with no repository is a whistle with no air.

=== How a log is not a telephone (Kafka vs HTTP)

HTTP is a telephone. You call, wait for a tone, hear "201" or "500," hang up. If the other party is asleep, you hang or get an error *now*. Two services over HTTP know each other by name and by the contract "I wait for an answer."

Kafka is a log on the watch desk.

- The writer doesn't know whether anyone is reading. Appended a line — went to fix the antenna.
- The reader comes when they want. Slept an hour — they'll catch up. The bookmark (offset) remembers how far they read.
- Lines are not "rewrite." Usually you append. The old stays. That infuriates until you understand why: you can replay the day, you can debug "who put what at 03:12."
- If two readers have different bookmarks — both read the same thing, each at their own pace. A telephone can't do that unless you're a conference call and an admin.

So the vacancy phrase "integration via Kafka" does not mean "instead of REST." Often REST stays for the human and for "do it now." The log is for "it happened, you'll figure it out." Created a task — HTTP 201 to the human. Into the log — event `TaskCreated`, so later email, search, analytics, whoever, *without holding the receiver*.

#slow[
  Compare out loud, even to the cat:

  1. A human POSTs `/tasks`. The service writes to Postgres. Response 201. That's HTTP.
  2. The same service additionally puts JSON `{ "id": 7, "title": "airlock" }` on topic `task-events`. That's a producer. It doesn't wait for the email to leave.
  3. Another process (or thread) reads the topic from offset 0, then 1, then 2. That's a consumer. It crashed — stood up, asked the broker "I'm at 2," reads on.
  4. If instead of a log there was HTTP to a "mail service," and mail is down, the task POST would get 502. A log survives that: the event is already in the log, mail will catch up.

  If you mix them up — go back to the paper. Telephone vs ship's log. Not "another queue, only fashionable."
]

A queue (lesson 18) *takes* the note from the tray. A log *doesn't take*: the bookmark moves forward, the paper stays. So "Kafka = a queue" in an interview is half a point and a polite smile. Finish: "sometimes they use it as a queue, but the model is a log with an offset."

=== One broker, one topic, no clusters in the kitchen

In Docker for study people often take an image where Kafka no longer needs a separate ZooKeeper (versions change, read the image README today, not "like the 2020 article"). One broker. One topic `task-events`. Replication "three brokers, rack awareness" is not your watch.

A producer from Spring (class names again, check the version):

```java
kafkaTemplate.send("task-events", String.valueOf(id), json);
```

Consumer:

```java
@KafkaListener(topics = "task-events")
public void on(String payload) {
    log.info("from the log: {}", payload);
}
```

If this stands up — in the README: how to `compose up`, how to see a line in the log after POST. If it doesn't stand up in an evening — *stop*. The monolith isn't guilty. Write `docs/kafka.md`.

=== An honest outline if the broker ate you

In `docs/kafka.md` in your own words, not a Wikipedia paste:

- why a log if you already have HTTP;
- what a topic is, a partition (at least: "a folder of the log" and "several notebooks so you can write in parallel");
- what an offset is;
- how a consumer group differs from "just two readers";
- what you *didn't* stand up (a cluster, exactly-once, Schema Registry).

That's stronger in an interview than "I took a course." A course doesn't open on GitHub. Your file does.

=== Lisp: a tiny Kafka in the REPL

A vector, append only, read from an index. Don't delete the old.

```lisp
(defparameter *log* (make-array 0 :adjustable t :fill-pointer 0))

(defun produce (x)
  (vector-push-extend x *log*))

(defun consume (offset)
  (when (< offset (length *log*))
    (aref *log* offset)))
```

`produce` always at the end. `consume` from zero, from one, from seven — like a bookmark. No key "delete event 3." Want "don't read" — move the offset.

#repl-note[
  `(produce 'airlock)` `(produce 'alarm)` `(consume 0)` → `AIRLOCK`. `(consume 1)` → `ALARM`. `(consume 2)` → `nil`. The log is still length 2. You didn't erase the air. You only looked.
]

We'll make a log. The game can wait until Sunday.

#exercise("19.L1", "Lisp")[
  A vector-log: append only, read from an index. Don't delete the old. A tiny Kafka in the REPL. We'll make a log.
]

#exercise("19.J1", "Java")[
  Either a living producer/consumer, or a page in your own words: why a log, how it isn't HTTP. Honesty matters more than a checkbox. Truth looks better in an interview than "well I took a course."
]

#exercise("19.J2", "text")[
  In `docs/kafka-vs-http.md` a five-row table: the human's action, HTTP, the log. Example: "the mail service is down." What POST `/tasks` sees in each world. No English bedsheet. Your own words, like a ship's mechanic, not like a landing page.
]

#sicp[
  A log as a sequence is a relative of the "stream of events" from the chapters on streams. If it suddenly itches, not instead of Docker. After. The station first has to leave in a box.
]

#lesson(20, [The box the station leaves in])

Until now the station lived in the cabin: IDEA, local Postgres, "works on my machine." Today it has to leave for another person (or for you on another OS) with a command from the README. The box is Docker. The schedule of boxes is Compose. On Windows Docker Desktop is the same compose, the same files. WSL and a Mac don't fight over YAML. They fight over CRLF and over someone forgetting `.dockerignore`.

The check: another person does `docker compose up` and walks the curls from the README. If it's only "works in my IDEA" — that isn't a station yet, that's a mockup in the cabin.

=== Dockerfile, line by line

A file with no extension, name `Dockerfile`, at the root of `task-manager`. Each line is a layer. Layers are cached: you changed Java code — you don't have to download the JDK again if `FROM` and the dependencies above didn't move. So *manifest first*, then sources. Not the other way around.

Textbook, honest, Java 21:

```dockerfile
FROM eclipse-temurin:21-jdk AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN ./mvnw -q -DskipTests package || mvn -q -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
```

#slow[
  Read it like a watch log, not like a spell.

  `FROM eclipse-temurin:21-jdk AS build` — take an image with JDK 21 (you need a compiler). Stage name `build`. Not `latest`. Temurin is a normal distro, the same one they often put in CI.

  `WORKDIR /src` — "from here on every command is from this folder." Like `cd`, only in a layer.

  `COPY pom.xml .` — dependencies first. If you haven't copied sources yet, Docker can cache the Maven layer when you only change `.java`. For simplicity we `COPY src` right after — a textbook compromise. The adult version: copy `.mvn` and `mvnw`, run `dependency:go-offline`, then `src`. If it didn't fit in an evening — don't die. The main thing: the jar is built in Linux, not "I brought a jar from a Mac."

  `RUN ... package` — build the jar inside Linux. `skipTests` in the image is arguable: tests should live in CI, not necessarily inside an image build. If tests poke localhost-Postgres, the image just won't build. So tests — outside, in GitHub Actions.

  The second `FROM eclipse-temurin:21-jre` is a *different* image, no compiler. In prod (and in textbook prod) a JRE is lighter. That's multi-stage: from the first stage we take only the jar.

  `COPY --from=build ... app.jar` — move the artifact. Not the sources. Not `.git`. Not the host `target/` wholesale.

  `EXPOSE 8080` — a plaque "I listen on 8080." By itself it doesn't punch a hole to the host. `ports:` in compose punches the hole.

  `ENTRYPOINT ["java", "-jar", ...]` — *exec form* (a JSON array). Not `java -jar` as a string through a shell, unless you need it. That way "stop" signals reach the JVM, not `/bin/sh`.
]

Next to it, `.dockerignore`:

```
.git
target
.idea
*.md
```

Otherwise half a disk and your secrets from `.env` ride into the context, if they happen to sit nearby. Don't copy `.env` into the image. Never. Even a textbook password `postgres/postgres` is better fed as a variable than baked in.

#os[
  Building the image: `docker build -t task-manager:dev .` in the project folder. Same on a Mac and in WSL. In PowerShell too, if Docker Desktop is running (the whale in the tray is alive, not dead). If the build screams at `mvnw` — no execute bit: in git, `mvnw` needs the executable bit, on Windows it sometimes gets lost. Then in the Dockerfile call `mvn`, and put Maven in the stage, or copy the wrapper carefully. Don't surrender to "well then only IDEA."
]

=== Compose: three tenants, one network, and the `localhost` trap

```yaml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_DB: taskdb
      POSTGRES_USER: task
      POSTGRES_PASSWORD: task
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U task -d taskdb"]
      interval: 5s
      timeout: 3s
      retries: 10
    ports:
      - "5432:5432"

  redis:
    image: redis:7
    ports:
      - "6379:6379"

  app:
    build: .
    depends_on:
      db:
        condition: service_healthy
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/taskdb
      SPRING_DATASOURCE_USERNAME: task
      SPRING_DATASOURCE_PASSWORD: task
      SPRING_DATA_REDIS_HOST: redis
    ports:
      - "8080:8080"

volumes:
  pgdata:
```

Service names `db`, `redis`, `app` are DNS inside the Compose network. Container `app` knocks on host *`db`*, not `localhost`.

#slow[
  Why everyone falls into one pit.

  Inside a container `localhost` is *itself*. The app asks Postgres at `localhost:5432` — it knocks on its own empty pocket. There's no Postgres there. Postgres is in the neighboring container named `db`.

  From the host (your curl, your IDEA) `localhost:5432` is the `ports:` forward. So *from a Mac* `psql localhost` works, and *from the app in Docker* it doesn't.

  Two worlds, two names:

  - Java in IDEA on the host → `localhost`
  - Java in container `app` → `db` and `redis`

  The database URL is from the environment, not baked in. One `application.yml` with a default for the cabin, in compose — variables that override. Inside an image with an unmarked `localhost` — a trap. Almost everyone falls in. You now know the "wet floor" sign.
]

`depends_on` without a healthcheck is "the container *started*," not "Postgres *accepted* the password." That's a race: the app died five times while the database yawned. `pg_isready` is a sensor. Let it be there.

Password `task/task` is fine for study. The same password on public GitHub is fine only because this is a textbook sandbox. A real password — no. Not even as a joke. Not even in `docker-compose.override.yml` that you "accidentally" committed.

=== CI: a robot that doesn't care which IDEA you have

File `.github/workflows/ci.yml`. Not "someday." On every push. A green check on GitHub is nicer than self-esteem.

```yaml
name: ci

on:
  push:
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: "21"
          cache: maven
      - name: tests
        run: mvn -B test
```

#slow[
  `name: ci` — like signing the watch. The Actions tab will show this name.

  `on: push` — any shove into the repository. `pull_request` — also on a PR, so you see red *before* the merge. You can narrow branches later. Right now let it scream always.

  `jobs.build` — one job. You can have several, you don't need to.

  `runs-on: ubuntu-latest` — someone else's machine, Linux. So "on my Mac" does not interest the robot. Tests must be green without mouse clicks.

  `actions/checkout@v4` — fetch the code. Without this the robot sits in an empty cabin.

  `actions/setup-java@v4` + `temurin` + `21` — the same JDK as in the book. `cache: maven` — don't download half the internet every time.

  `mvn -B test` — `-B` is batch: less interactive, less "press Enter." Tests. Not `package` skipping tests. If a test needs Postgres, either Testcontainers, or H2 *only* in `src/test`, and the README says so. Lying to the robot "green, but I didn't bring up the database" works exactly until the first person who believes the check.
]

Don't put secrets in the YAML. The robot doesn't need your password to Earth. If a token is ever needed — GitHub Secrets, not a string in a file.

#os[
  First push from Windows: watch that `ci.yml` is LF, not CRLF with a surprise. Git usually handles it. If Actions screams at a weird character at the start of the file — BOM. Save UTF-8 without BOM. On a Mac this trouble is rarer. That doesn't mean "Mac is better." It means "Windows Notepad sometimes helps too hard."
]

=== A check that the station left

A fresh folder. Someone else's laptop, or your second OS, or just `docker compose down -v` and again.

```
docker compose up --build
```

Then from the host:

```
curl -s localhost:8080/health
```

Login, task list — as in the README. If health is alive and the database isn't — `localhost` inside again. If the port is taken — an old Postgres from month 3 is already sitting on the host. Turn the local one off or change the forward to `5433:5432` and *write that in the README*. A silent port is an enemy.

#exercise("20.J1", "Java")[
  Compose brings up the database and the app. The database URL is from the environment, not a baked `localhost` inside the image with no note. Inside the Docker network the database host is often called `db`, not `localhost`. Yes, that's a trap. Almost everyone falls in.
]

#exercise("20.J2", "Java")[
  `.github/workflows/ci.yml` — build and tests. A green check on GitHub is nicer than self-esteem.
]

#exercise("20.J3", "text")[
  In the README a section "Why not localhost": five to seven sentences. Host vs container. Names `db` and `redis`. Where curl from a Mac goes. Where the JVM inside `app` goes. If a classmate still writes `localhost` in the image after that — that's their watch, not yours.
]

#warn[
  Don't carve out a "notifications microservice" while the monolith's compose doesn't stand up. If you carved it — write in the README what got more painful: data, transactions, debugging. Pain is study material, not shame.
]

#github[
  Commit `week20: compose postgres redis app`. A tag if you want. The README starts with `docker compose up`, not "open IDEA." Otherwise the tag lies.
]

#sunday[
  Break one Dockerfile line on purpose (`FROM` a nonexistent tag, or a typo in `ENTRYPOINT`). Read the error out loud. Fix it. The fear "Docker is too big" passes when the red became specific, not cosmic.
]

#rule[
  By the end of the month you can honestly underline in a vacancy: cache, a queue *or* a log, a box. Underline means open a file. Don't underline a word that isn't in `git log`.
]
