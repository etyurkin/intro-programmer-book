#import "../lib-en.typ": *

= Month 2. It already answers over the network

By week eight you have a small web server on Spring Boot. The data is still in memory: restart — everything forgotten, like a dream after a night shift. But you can see HTTP, and you stop believing that "the internet" is a button. Lisp: lambdas, walks over lists, little alist pockets. And tests: a program that grabs your program by the ear.

Station MODULE learned to remember a to-do list on disk. Earth can't see that. Earth sends letters. The letters are called HTTP, and they aren't magic, they're text. If the text is scary — read it out loud. It won't get scarier. It will get clearer.

Four watches. After them — an address in the browser that answers not "this site can't be reached," but JSON. A modest holiday. Don't put Kafka on the cake.

#rhythm[
  Lisp: `lambda`, `mapcar`, alist, your own "server response" as a string, a little logging. \
  Java: JUnit, a Git branch, Spring Web, a thin controller, a service, a log. \
  By the end of the month: a README with curl, tests, `GET`/`POST`, a `done` filter. Memory, not a database. The database is next month, when you've earned it.
]

#lesson(5, [Tests and git you aren't scared to open])

#rhythm[
  Lisp: a nameless function, `remove-if` / `find-if`, pairs in an alist. \
  Java: Maven, one red test, then green. A branch, not straight to `main`. \
  An inspector from Earth promised to "look at the repo." The inspector is you, in a week.
]

Fifth watch. Someone (not you) fixed `complete` so it does nothing, but it compiles. On the station that's called "optimism." A test is the right to say "you're lying" without yelling on the intercom.

=== Lisp: a function with no name, because you can't be bothered

Sometimes you need a function once, like a paper cup. A name for it is bureaucracy. Then `lambda`:

```lisp
(mapcar (lambda (n) (* n 10)) '(1 2 3))
; (10 20 30)
```

#slow[
  `lambda` — "here's a body, I won't give it a name." Parameter list `(n)`, body `(* n 10)`. `mapcar` takes each element, feeds it to the lambda, gathers the answers. Same gesture as `#'evenp` in lesson 3, only the function isn't in the station handbook — you glued it on the spot.
  Call `(mapcar (lambda (n) n) '(1 2 3))` too. You get a copy. The identity lambda. Useless and calming: you see that an element is walking, not "mapcar magic."
]

More:

```lisp
(remove-if (lambda (n) (< n 0)) '(3 -1 4 0 -8))
; (3 4 0)

(find-if (lambda (room) (eq room 'reactor))
         '(airlock corridor reactor))
; REACTOR
```

#repl-note[
  `remove-if` throws out whoever the lambda is non-`nil` for. Negatives flew off, zero stayed: `(< 0 0)` is `nil`. `find-if` — the first one who matched. None — `nil`. `eq` compares symbols. Strings — not `eq`, for strings `string=`. Right now we have tag-symbols, `eq` is honest.
]

An energy threshold with a lambda, no separate `defun`:

```lisp
(remove-if (lambda (n) (< n 30)) '(80 20 55 10))
; (80 55)
```

And the other way, keep the hungry ones:

```lisp
(remove-if-not (lambda (n) (< n 30)) '(80 20 55 10))
; (20 10)
```

`remove-if-not` — a double negative in the name, but it reads "keep the ones who…." Two names, one family. Don't learn every `*-if` at once. These two will last the watch.

An association list is a list of pairs. A poor person's pocket:

```lisp
(defparameter *energy*
  '((reactor . 80) (antenna . 20) (life-support . 55)))

(assoc 'antenna *energy*)
; (ANTENNA . 20)

(cdr (assoc 'antenna *energy*))
; 20

(assoc 'garden *energy*)
; NIL
```

#slow[
  The dot in `(reactor . 80)` is a cons pair. Not a two-element list with `nil` in the tail, but "head and tail, and the tail is a number." Looks like a typo. It isn't a typo. That's Lisp being itself.
  `assoc` looks up a pair by the *head*. Found — the whole pair. Not found — `nil`. Then `(cdr pair)` — the value. If you go straight to `(cdr (assoc ...))` on a missing key, `(cdr nil)` gives `nil`. Handy. You can't tell "no such module" from "energy is nil," but our energy is a number, live in peace.
  Compare with Java `HashMap`: there `get` is the value or `null` in one step. Here two steps. But you can see the structure: the pocket is a list too. Everything is lists, we said.
]

Put a new pair on the front, like `cons` in lesson 2:

```lisp
(cons '(garden . 0) *energy*)
```

The old `*energy*` didn't change. To hang it on the global:

```lisp
(setf *energy* (cons '(garden . 0) *energy*))
(assoc 'garden *energy*)
```

Now the garden is there, energy zero. Greenhouse, we remember you.

Three examples, not one.

Example A. Double, but ceiling 100 — that's quest 5.L1, with your eyes first:

```lisp
(mapcar (lambda (n) (min 100 (* n 2))) '(10 60 40))
; (20 100 80)
```

`min` of two takes the smaller. `(* 60 2)` = 120, `min` cuts it to 100. The reactor isn't rubber.

Example B. Module names from an alist:

```lisp
(mapcar #'car *energy*)
```

`car` — the head of the pair, meaning the name. `#'car` is fine, a lambda is fine. Both honest.

Example C. Only `'down`:

```lisp
(defparameter *modules*
  '((reactor . up) (antenna . down) (airlock . up)))

(mapcan (lambda (pair)
          (if (eq (cdr pair) 'down)
              (list (car pair))
              nil))
        *modules*)
; (ANTENNA)
```

`mapcan` glues the answer-lists. The lambda returned `(ANTENNA)` or `nil` (empty, nothing to glue). You get a list of names, not a list of pairs. If you used `mapcar` — you'll get `((ANTENNA) NIL NIL)` and wonder. Quest 5.L2 is about that. Break it with `mapcar` first, then fix it with `mapcan` or `loop`.

#warn[
  `(lambda n (* n 10))` without parentheses around `n` — parameters have to be a list `(n)`. Same hole as `defun` on day one. SBCL will yell about `n` not in a list. Parentheses around the names, even if there's only one name.
]

=== Java: a test that has the right to offend you

A test is a separate program. It calls yours and yells if the answer is wrong. This is not "checking with your eyes." Eyes lie when they're tired. A test doesn't get tired. It only annoys.

A Maven project in IntelliJ: New Project → Maven → JDK 21. Coordinates like `com.example` / `taskstore`. On Windows without WSL you'll later run `mvnw.cmd test`, in WSL and on a Mac — `./mvnw test`. One `pom.xml` for everybody.

#os[
  *Mac / WSL.* In the project root after generating the wrapper:

  ```
  chmod +x mvnw
  ./mvnw test
  ```

  `chmod` on a Mac and in Ubuntu is needed once, if you get "Permission denied." \
  *Windows cmd.* `mvnw.cmd test`. Don't mix slashes. \
  *IntelliJ.* The green arrow on the class `...Test`. Same Maven under the hood, if you imported it as Maven.
]

`pom.xml` needs a JUnit 5 dependency. The archetype or IDEA often drop it in themselves. The chunk without which tests are a fantasy:

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.10.2</version>
    <scope>test</scope>
</dependency>
```

`scope>test` — it won't get into the real program. You don't put a test hammer in a spacesuit.

Put `Task` and `TaskStore` in `src/main/java/...`. The test — in `src/test/java/...` *the same package or an import*. Names: class `TaskStore`, test `TaskStoreTest`. Not `TestTaskStore` necessarily, but the `Test` suffix Maven/JUnit find calmly.

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TaskStoreTest {
    @Test
    void addIncreasesSize() {
        TaskStore store = new TaskStore();
        store.add("antenna");
        assertEquals(1, store.all().size());
        assertEquals("antenna", store.all().get(0).getTitle());
    }
}
```

#slow[
  `@Test` — "this is not an ordinary method, this is a quest for the machine." The method name is a sentence: what should be true. `assertEquals(expected, actual)` — that order. Swap them — the error message will mock you.
  Each test — a *new* `TaskStore`. Don't share one store across all methods of the class via a field "for speed." Tests will start depending on order, and JUnit never promised an order. The station is already on duct tape. Don't add flakes.
]

Write a test *that fails*, then fix the code. Otherwise you're testing the compiler, not yourself.

The red-bar ritual:

1. In `complete`, temporarily do nothing (empty method, don't touch `done`).
2. Test: add, `complete(id)`, `assertTrue(task.isDone())`.
3. Run — red. Read the message. It should talk about `true` vs `false`, not about "doesn't compile."
4. Put back the line that sets done. Green.

Nice, right. This isn't sadism. This is proof the test *can* yell. A green test that's green even when the code is dead — decoration.

Three tests — three edges, not three copies of `add`.

- Added — size 1, the title is that.
- `complete` of an existing one — `isDone()`.
- `complete` of a missing one — *your* decision: an exception or `false`. Check that, not "how it is on the internet."

```java
@Test
void completeMissing() {
    TaskStore store = new TaskStore();
    assertThrows(NoSuchElementException.class, () -> store.complete(99));
}
```

Or:

```java
assertFalse(store.complete(99));
```

Not both. Pick a contract, write it in the README in one line, the test holds it.

#repl-note[
  The lambda `() -> store.complete(99)` — "here's code that should blow." JUnit will call it and catch it. If it *didn't* blow — the test is red. If it blew with a different exception — also red. A specific class, not "any trouble."
]

=== Git you aren't scared to open

Until now you could live on `main` and pretend branches are for grown-ups. Today is a grown-up watch. The inspector (future you) likes a history where you can see *why*, not `asdf`.

```
git status
git checkout -b feat/tests
```

Old Git understands `checkout -b`, new Git also has `git switch -c feat/tests`. Both fine. Branch name: `feat/tests`, not `tmp` and not `aaa`.

You fix tests and code. You look in the mirror:

```
git diff
```

#slow[
  `git diff` — what changed *now*, not in your head. Red left, green arrived. Before a commit, read it the way you look at the oxygen sensor before leaving the airlock: not "yeah, probably." Accidentally committed a password — that's already a letter. Accidentally committed `.class` — embarrassing, but treatable. `.gitignore` from lesson 0: `*.class`, `.idea/`, `target/`.
]

```
git add -A
git commit -m "week5: tests for task store"
git switch main
git merge feat/tests
```

On GitHub: `git push -u origin HEAD` from the branch, then a Pull Request — or merge locally and `push` `main` if you're alone on the repo. Both paths are honest for a textbook. Not honest: editing `main` mixed with the experiment "what if complete does nothing" and pushing red as if that's the point.

#os[
  Git is the same on a Mac, in WSL, and in Git for Windows. The terminal differs. If PowerShell eats quotes in `-m` — use singles, or IDEA: the Commit checkbox. Don't do a commit through `git commit --amend` if you already pushed, and in this book we don't celebrate amend anyway: a new commit is simpler than heroics.
]

`git log --oneline` should read like a station log: `week4: standalone java program`, `week5: tests for task store`. Not `fix`, `fix2`, `asdf`. Future you will say thanks. Or at least won't say something bad.

=== If it broke: tests and Maven

*`Cannot resolve symbol Test`.* No JUnit dependency, or IDEA didn't import Maven. Right-click `pom.xml` → Reload. Terminal: `./mvnw test`. If the terminal is green and IDEA is red — that's the IDE, not Java.

*`Error: Java version`.* Project on 17, JDK 21, or the other way around. In `pom.xml`, `maven.compiler.release` (or source/target) = 21. File → Project Structure → SDK 21.

*Test not found.* The class isn't in `src/test/java`, or the method isn't `@Test`, or it isn't `void`. Or the name is `testAdd` with no annotation — JUnit 5 doesn't pick up by prefix, that's grandpa JUnit 3.

*Red `assertEquals` with a pile of lines.* Read Expected / Actual. Often 0 vs 1 — `add` hit the wrong list. Often references — you compared objects with `==` inside your own code, not in the assert.

*`BUILD SUCCESS` with zero tests.* You didn't put them there, or the name `TaskStoreTestsBackup.java` didn't get picked up. In the log, the line `Tests run:`. Zero is not a victory.

#exercise("5.L1", "Lisp")[
  `mapcar` and `lambda`: multiply energies by 2, but not above 100. `(min 100 x)`. The reactor isn't rubber.
]

#exercise("5.L2", "Lisp")[
  Alist module → status. `offline-modules`: the ones with `'down`. Someone forgot to turn off the light in a compartment that's already dead.
]

#exercise("5.L3", "Lisp")[
  `energy-of`: an alist like `*energy*` in the text, module name a symbol. Return a number or `nil`. Through `assoc` and `cdr`. Check reactor, antenna, and `'garden`, which isn't there. Three calls, three answers, in comments.
]

#exercise("5.J1", "Java")[
  Three tests: add; complete by id; complete of a missing one — decide whether that's `null` or an exception, and check *your* decision, not "how it is on the internet."
]

#exercise("5.J2", "Java")[
  Break `complete`, make sure it's red, put it back. In the README one sentence: how to run tests on your machine (Mac / WSL / `mvnw.cmd`).
]

#exercise("5.J3", "Java")[
  Branch `feat/tests`, at least one commit on it, merge into `main`. In the README: three lines of `git log --oneline` (you can copy them by hand). If every commit is `asdf` — rewrite the messages *before* the push, or live with the shame. A watch log, not a chat.
]

#github[A commit on the branch, then into main. `git log` should read like a station log, not like `asdf`.]

The inspector looked. Tests green. `complete` lies again if you turn off one line — and the test sees it. On MODULE that's the first sensor that yells *before* the explosion. You can get used to that.

#lesson(6, [HTTP is just text pretending to be the internet])

#rhythm[
  Lisp: glue a "server response" as a string, a little JSON by hand. \
  Java: start.spring.io, three holes, curl from the next window. \
  You restarted — the tasks died. That's the point. The database comes when you've earned it.
]

Sixth watch. Earth didn't send an astronaut. It sent a letter. First line of the letter: `GET /health HTTP/1.1`. The captain asks, is this a virus? This is manners. A browser knocks like that. Spring listens like that. Today you see the letter naked, then you put a Boot suit on the station.

=== Lisp: print a "server response" yourself

HTTP is letters. Not a cloud. Not Spring magic. Letters.

```lisp
(defun http-ok (body)
  (format nil "HTTP/1.1 200 OK~%Content-Type: text/plain~%~%~a" body))
```

#slow[
  `format nil` doesn't yell into the terminal. It *returns a string*. Like `render-room` versus `print-rooms`. First the status line: version, code, phrase. Then headers. Then a *blank line*. Then the body.
  `~%` — newline. Two `~%~%` in a row after the header — that blank line. Forget one — the client will wait for headers forever, or glue the body onto `Content-Type`. Remember it like a spell: method, path, status, headers, body.
]

Call it:

```lisp
(http-ok "reactor stable")
```

Print the result with `format t` and `~s`, or just look. Between `plain` and `reactor` there should be a blank line. JSON is text too, only with curly braces and grudges about commas.

A request from Earth (that's you pretending to be the client):

```
GET /health HTTP/1.1
Host: localhost:8080
```

Again a blank line at the end of the headers. Method `GET` — "let me look." `POST` — "here's a body, put it." Don't write "give/send" in code and in curl: write `GET` and `POST`, like in the RFC and in job posts.

Codes that will last the month:

- 200 — here, take it.
- 201 — created.
- 204 — did it, no body (deleted and stays quiet).
- 400 — you sent garbage.
- 404 — no such hole, or no such task.
- 500 — we are the idiots.

Five hundred is embarrassing. Four hundred is a normal conversation. The difference is like "the reactor exploded" versus "you forgot to close the hatch."

Assemble the whole letter, as if you were a pipe, not a framework. The request:

```
POST /tasks HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Content-Length: 28

{"title":"fix the airlock"}
```

The response you'll glue yourself in Lisp and that Spring will later hand out:

```
HTTP/1.1 201 Created
Content-Type: application/json

{"id":1,"title":"fix the airlock"}
```

#repl-note[
  The same blank line in both letters is the border. Above — service words. Below — cargo. You don't have to count `Content-Length` by hand right now: curl and Boot can. But seeing that it exists is useful: it's "how many letters in the body," not magic.
  `GET` usually carries no body. `POST` does. So curl without `-d` on POST is a letter with an empty hold. The server has the right to get offended.
]

Three eye-runs before Spring.

1. `(http-ok "UP")` — is there `200` and a blank line. Print through `format` with `~s`: two newlines in a row should be visible.
2. Change `200 OK` to `200OK` with no space. That's not a status line anymore, that's mush. Put the space back.
3. `(json-task 1 "airlock")` — count the quotes. If you broke escaping in `format`, you get crooked JSON. In Common Lisp a quote inside a string is written with a backslash.

Teaching JSON with no library:

```lisp
(defun json-task (id title)
  (format nil "{\"id\":~a,\"title\":\"~a\"}" id title))

(json-task 1 "airlock")
; {"id":1,"title":"airlock"}
```

Quotes in `title` will break the tin. The quest says: don't escape, this is teaching tin JSON, you don't have to marry it. Later Jackson in Spring will do it for you, and you won't even say thanks.

One more envelope:

```lisp
(defun http-created (body)
  (format nil "HTTP/1.1 201 Created~%Content-Type: application/json~%~%~a" body))
```

Glue: `(http-created (json-task 2 "antenna"))`. Read it with your eyes like a mail carrier.

#warn[
  The space in `HTTP/1.1 200 OK` is required. `200OK` without a space — not a letter, mush. The code is a number, the phrase is words. Three pieces of the first line, not two.
]

=== Java: Spring Boot, three holes in the hull

https://start.spring.io — Maven, Java 21, check *Spring Web*. Group `com.example`, Artifact `task-manager`. A zip downloads. Unpack it into `task-manager`.

#os[
  *Mac.* zip in Downloads, unpack with a double-click or `unzip task-manager.zip`. \
  *WSL.* Download in Windows, copy into Linux, or `unzip` in Ubuntu: `sudo apt install -y unzip` if needed. \
  *Windows without WSL.* Explorer → Extract. Launch later with `mvnw.cmd`. \
  Open the folder in IntelliJ as a Maven project. Wait until the dependencies on the right stop spinning. The first time it downloads the internet. Without internet, Boot won't stand up — that isn't "you unpacked it wrong."
]

Three holes. Not thirty.

```java
@RestController
public class TaskController {
    private final List<Task> tasks = new ArrayList<>();
    private int nextId = 1;

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP");
    }

    @GetMapping("/tasks")
    public List<Task> all() {
        return tasks;
    }

    @PostMapping("/tasks")
    public Task create(@RequestBody TaskRequest req) {
        Task t = new Task(nextId++, req.title());
        tasks.add(t);
        return t;
    }
}

record TaskRequest(String title) {}
```

#slow[
  `@RestController` — "I answer HTTP, the body is data, not an HTML page." `@GetMapping("/health")` — if the letter is `GET /health`, call this method. Returning a `Map`, Spring turns into JSON itself. You don't write `{"status":"UP"}` by hand, though in Lisp you just did — and that's why you aren't scared.
  `@PostMapping` — a `POST` letter. `@RequestBody` — unwrap the letter body into `TaskRequest`. `record` in Java 21 — a short class: field `title`, constructor, getter `title()`. Don't copy ten lines of boilerplate if one is enough.
  The list is still *in the controller*. Tomorrow that's embarrassing. Today — so it breathes at all. A fat hatch guard who also hauls crates. Lesson 7 will slim him down.
]

The class `Task` is yours, with id, title, done, getters. Spring serializes getters into JSON. No getter — the field won't be in the response, and you'll blame Boot. Getter there — `"id":1`. Magic that is actually a convention.

Launch:

```
./mvnw spring-boot:run
```

On Windows without WSL: `mvnw.cmd spring-boot:run`. In IDEA — the green arrow on the class `...Application` with `@SpringBootApplication`. In the log, wait for something about `Tomcat started on port 8080`. No such line — it didn't "start." Read the red *above*. Often: port taken, Java isn't 21, a typo in the package.

Then in *another* window:

#os[
  On a Mac and in WSL, a long command wraps with a backslash `\`. In cmd.exe — `^`. In PowerShell, one long line is easier. `curl` already exists on Windows 10+ (`curl.exe`). If PowerShell replaces `curl` with its `Invoke-WebRequest` — call `curl.exe`. If it yells weird — go into Ubuntu (WSL) and poke from there, `localhost` is shared if Java is in WSL too. Java on Windows, curl in WSL: `localhost` is sometimes that one, sometimes not. Keep the client and the server in one universe.
]

```
curl -s localhost:8080/health
curl -s localhost:8080/tasks
```

First — `{"status":"UP"}`. Second — `[]`. Empty list, not an error. The station is alive, no jobs.

```
curl -s -X POST localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"fix the airlock"}'
```

#repl-note[
  `-X POST` — the method. Without it, `curl` with `-d` often does POST anyway, but better to be an adult on purpose. `-H` — a header: "the body is JSON, not a form from a website." `-d` — the body. Quotes around JSON bite in different shells. In bash, singles on the outside, doubles inside the JSON. In cmd.exe — a circus with `\"`. In WSL, calmer.
  The answer is a task with an `id`. Then `GET /tasks` again — an array of one. Restart Boot — the array is empty again. Process memory. You turned off the JVM — the hold forgot. Lesson 4's files are not wired in here. Don't wire them "just in case." Month 3 — a real disk, Postgres.
]

One task by id — quest 6.J1, the idea:

```java
@GetMapping("/tasks/{id}")
public ResponseEntity<Task> one(@PathVariable int id) {
    // find in the list, ok or 404
}
```

`{id}` in the path — a hole. `@PathVariable` — pull out the number. `ResponseEntity` — "not only the body, also a status." Found — 200 and the object. None — 404 without a made-up task. A made-up task with id 0 is worse than 404: Earth will think the airlock is fixed.

#warn[Don't drag in JPA, Security, and Kafka "because they were in the guide." Today three holes. Greed for annotations is the path to the dark side and to a résumé that lies.]

=== If it broke: Boot, port, curl

*`Port 8080 was already in use`.* The previous `spring-boot:run` is alive. Find the window, Ctrl+C. Or in `application.properties` / yml a different port — then curl on that one too. Don't spawn three servers "maybe this one."

*`Whitelabel Error Page` in the browser.* You opened a path that isn't there, or GET instead of POST. That's a 404 from Boot, not "the internet broke." Look at the URL and the letters `/tasks` without the typo `taks`.

*`Content-Type` and 415.* POST without the JSON header. Add `-H "Content-Type: application/json"`.

*`JSON parse error`.* The body `'{"title": "airlock"}'` with smart quotes from a messenger. Rewrite the quotes by hand, dumb ones. Or a file `@body.json`.

*`curl: (7) Failed to connect`.* The server didn't stand up, or the wrong port. Health first. No health — no point in POST.

*`mvnw: command not found`.* You aren't in the project root where `mvnw` lives. `ls` should show `pom.xml`. On a Mac `./mvnw`, not `mvnw` without the dot — otherwise PATH.

Java compilation is the same, plus:

- the class isn't in a package, and Spring looks in subpackages from `Application` — put the controller *below* on the package tree from the class with `@SpringBootApplication`, or set `@ComponentScan`. Simpler tree: `com.example.taskmanager`, the controller there or in `.web`.
- `record` is fine on Java 17+, not on 11. JDK 21.

Three letter-runs.

1. `GET /health` before and after POST — always UP. Health is not about tasks.
2. Two POSTs in a row — id 1 and 2, not 1 twice. `nextId++`.
3. `GET /tasks/99` after the quest — 404, not an empty `{}` with zeros.

#exercise("6.L1", "Lisp")[
  `http-not-found`: status 404, body `missing`. The station knows how to get lost.
]

#exercise("6.L2", "Lisp")[
  `json-task`: id and title → `{"id":1,"title":"..."}`. Don't escape quotes in title — teaching tin JSON, you don't have to marry it.
]

#exercise("6.L3", "Lisp")[
  `http-created` (201) with `Content-Type: application/json` and a body from `json-task`. Glue one letter-string in the REPL. Check with your eyes: first line has `201`, a blank line before `{`.
]

#exercise("6.J1", "Java")[
  `GET /tasks/{id}` — one task or 404. `ResponseEntity` is your friend.
]

#exercise("6.J2", "Java")[
  README: five curl examples. Without that the lesson doesn't count, even if "it opens in IDEA for me."
]

#exercise("6.J3", "Java")[
  `POST` with no body or with `{}` — right now it might be 500. Catch the status with your eyes in curl `-i` (headers). In the README write *which* status you see today. Fixing it to 400 is the next lesson. Today, honestly record the shame of 500 if it's there. If it's already 400 — write that too, don't stay quiet.
]

#sunday[
  Write `Hello` on a naked `ServerSocket` (one thread, one response). Then Spring will stop looking like a priest. It's just a very fat `ServerSocket` in a suit.
]

Earth got `UP`. The captain said "not bad" — on MODULE that's a medal. The to-do list still lives in the hatch guard. Tomorrow we drag the hatch guard off the crates.

#lesson(7, [Who answers the call, and who thinks])

#rhythm[
  Lisp: `error`, `handler-case`, a polite `'bad-request`. \
  Java: `@Service`, a constructor, 400 not 500, `DELETE`. \
  The rule "title isn't empty" lives in the service. Then a test will check it, and a future little console, and you at three in the morning.
]

Seventh watch. The controller got fat: list, numbers, create, lookup. The hatch guard at the airlock is also smelting steel. The captain isn't yelling because he's cruel — because when Earth sends a second door (a console, a bot, "one more controller"), the rules will drift apart. Pull the brain inside once.

The controller is the watch at the airlock. The service is the mechanic inside.

Yesterday's fat chunk, so you have something to scrape out with your eyes:

```java
@PostMapping("/tasks")
public Task create(@RequestBody TaskRequest req) {
    if (req.title() == null || req.title().isBlank()) {
        // return what? null? an empty Task? 500?
    }
    Task t = new Task(nextId++, req.title());
    tasks.add(t);
    return t;
}
```

#slow[
  Three jobs glued here: understand the letter, check the title, put it in the box. The second and third aren't about HTTP. They live the same way if a task is created by the console from lesson 4. That's why a service. The controller after the diet: pulled the body, called `service.create`, packed 201 or 400. That's it. The hatch guard doesn't smelt steel.
]

Three checks that it didn't only drift apart in your head.

1. Search the project: `new ArrayList` in the controller — zero. If there is one — the list is still there.
2. A unit test `TaskService` with `new TaskService()` — green without `spring-boot:run`. If the test needs port 8080, you're testing HTTP, not rules.
3. Empty title through curl — 400. The same empty title through `service.create("")` in a test — an exception. One rule, two doors.

```java
@Service
public class TaskService {
    private final List<Task> tasks = new ArrayList<>();
    private int nextId = 1;

    public List<Task> findAll() {
        return List.copyOf(tasks);
    }

    public Task create(String title) {
        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException("title required");
        }
        Task t = new Task(nextId++, title.strip());
        tasks.add(t);
        return t;
    }
}
```

#slow[
  `@Service` — a tag for Spring: "this is a bean, put it on the shelf." Not a sacred word. It could have been `@Component`. Service is the meaning: rules and data live here.
  `List.copyOf` — the guest got a *snapshot*, not the live box. `clear()` from outside won't kill the hold. Yesterday's smell, closed.
  `isBlank()` — empty or only spaces. `"   "` is not a task title. `strip()` — trim the edges of an honest title. Earth loves spaces.
  An exception is the signal "you can't do that." Don't return `null` "they'll probably get it." The controller will understand the specific type and turn it into 400.
]

Spring will slip the service into the controller through the constructor. Don't write `new TaskService()` by hand — otherwise why did we start this whole bean religion.

```java
@RestController
public class TaskController {
    private final TaskService service;

    public TaskController(TaskService service) {
        this.service = service;
    }
}
```

#repl-note[
  One constructor — Spring will find `TaskService` on the shelf and insert it. The field is `final` — hung forever, nobody swaps it at midnight. There's no list in the controller anymore. If there is — you cheated, the hatch guard is smelting steel again.
  Check: search the project for `new ArrayList` in the controller. Zero hits. If there are some — pull them out.
]

Empty title — 400, not 500. Five hundred means "we are the idiots." Four hundred — "you sent garbage."

```java
@PostMapping("/tasks")
public ResponseEntity<?> create(@RequestBody TaskRequest req) {
    try {
        return ResponseEntity.status(201).body(service.create(req.title()));
    } catch (IllegalArgumentException e) {
        return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
    }
}
```

#slow[
  201 — created, not just "ok, 200." A tiny thing that in an interview tells a person who has seen HTTP from a person who has only seen the green arrow.
  `?` on `ResponseEntity` — "the body differs: sometimes a Task, sometimes an error map." Not ideal architecture, but honest for one watch. Later you can `@ControllerAdvice`. Today — don't. If it works, don't spawn annotations.
]

`TaskRequest` is what arrived from the street. `Task` is what lives at home. Even if the fields look alike, don't shove the home one onto the street. Later the home one will grow secrets (who the author is, an internal flag), and you'll accidentally hand them out in JSON.

Deletion:

```java
public boolean delete(int id) {
    return tasks.removeIf(t -> t.getId() == id);
}
```

`removeIf` — a lambda, you were just petting those in Lisp. Returns `true` if it threw someone out. The controller: `true` → 204 with no body, `false` → 404.

```java
@DeleteMapping("/tasks/{id}")
public ResponseEntity<Void> delete(@PathVariable int id) {
    if (service.delete(id)) {
        return ResponseEntity.noContent().build();
    }
    return ResponseEntity.notFound().build();
}
```

curl:

```
curl -i -X DELETE localhost:8080/tasks/1
```

`-i` will show the status. 204 often with an empty body — normal. Same id a second time — 404. A poor mechanic's idempotence: you can't delete it again, it's already gone.

A service test *without HTTP*. Don't stand up all of Boot to learn that an empty title is bad.

```java
class TaskServiceTest {
    @Test
    void emptyTitleRejected() {
        TaskService s = new TaskService();
        assertThrows(IllegalArgumentException.class, () -> s.create("  "));
    }

    @Test
    void deleteMissing() {
        TaskService s = new TaskService();
        assertFalse(s.delete(99));
    }
}
```

`new TaskService()` in a test — fine. This isn't a controller, it's a plain class. Spring isn't needed for a unit of rules. `@SpringBootTest` on every sneeze — slow and brittle. Save it for the month when a database shows up.

=== Lisp: the same manners without Spring

```lisp
(defun create-task (title)
  (if (or (null title) (string= title ""))
      (error "title required")
      (list :title title :done nil)))

(defun try-create (title)
  (handler-case (create-task title)
    (error () 'bad-request)))
```

#repl-note[
  `error` throws. Without a catcher SBCL opens the debugger — you've already been in it by accident. `handler-case` — "if it blew, return a symbol." `'bad-request` like 400. Success — a list with keys. Keys `:title` are another kind of tag, handy in a plist. You don't have to understand every kind. Understand: the rule lives in `create-task`, the translation into "an answer to the street" is outside. Same fat / skinny as Java.
]

Spaces: `(string= title "")` won't catch `"  "`. You can `(string= (string-trim '(#\Space) title) "")`. Quest 7.L2, if you take it on.

=== If it broke: beans and 400

*`required a bean of type TaskService`.* No `@Service`, or the class isn't scanned (wrong package). Put the service next to `Application` on the tree.

*`NullPointerException` in the controller.* Forgot the constructor, did `new` by hand on an empty service? Or `@Autowired` on a field, and the test creates the controller itself. The textbook wants a constructor. Follow it.

*POST empty title, and the status is 500.* You didn't catch the exception, Boot wrapped it in 500. That *is* "we are the idiots." Catch `IllegalArgumentException`. Don't catch `Exception` — you'll hide real bugs.

*400, but the body is HTML.* You returned a string not through `ResponseEntity` / `@RestController`. Or the error happened before the method. Look at `curl -i`, not only the browser.

*`List.copyOf` and then `UnsupportedOperationException`.* Someone outside is trying to `add` to what `findAll` returned. Good: the sensor worked. Change the list — only through service methods.

#rule[The rule "title isn't empty" lives in the service. Then a test will check it, and a future little console, and you at three in the morning.]

#exercise("7.L1", "Lisp")[
  `create-task`: empty title — `(error "title required")`. Catch with `handler-case`, return `'bad-request`. Manners in orbit.
]

#exercise("7.L2", "Lisp")[
  Empty after trim is `'bad-request` too. `(try-create "   ")` should not return a task. Compare with `(try-create "airlock")`. Two calls in the REPL — two different worlds.
]

#exercise("7.J1", "Java")[
  The service is pulled out. The controller has no `List` of its own. If it does — you cheated, the hatch guard is smelting steel again.
]

#exercise("7.J2", "Java")[
  `DELETE /tasks/{id}` → 204 or 404. A service test without HTTP: deleted, and missing.
]

#exercise("7.J3", "Java")[
  POST with `{"title":""}` and POST with spaces — both 400, a body with the key `error`. `curl -i` in the README, two real response bedsheets, not "well, 400." If 500 — it doesn't count, fix the catch.
]

The captain walked the corridor and didn't find the task list in the controller. He nodded. A nod on MODULE is rare, log it in the station log. Meaning git.

#lesson(8, [A whisper in the logs and handing over the watch])

#rhythm[
  Lisp: your own `log-info`, call it from task creation. \
  Java: `application.yml`, `Logger`, a filter `?done=`. \
  Week check: a fresh folder, README, curl. Not "it worked on my machine."
]

Eighth watch, night. `System.out.println` in the service is yelling in the corridor. The next compartment is asleep. A log is an entry in the journal: who created, who deleted, which id. Earth will later ask "so what happened at 03:12." You won't remember. The journal will.

`application.yml` (or `.properties`, if start.spring.io handed you that — don't spawn both):

```yaml
server:
  port: 8080
logging:
  level:
    com.example.taskmanager: INFO
```

#slow[
  YAML loves indentation. Two spaces, not a tab. Break the indent — Boot won't stand up, complaining about parse. Port 8080 is the default anyway, but spelling it out is honest for the README.
  `logging.level.package: INFO` — what to write from *your* classes. `DEBUG` — chatty, fine for a week, noisy for handing over the watch. `ERROR` — only fires, you'll miss task creation. INFO — "created id=3," a normal watch.
]

Instead of `System.out` — a log:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private static final Logger log = LoggerFactory.getLogger(TaskService.class);

log.info("created task id={}", t.getId());
log.info("deleted task id={}", id);
log.warn("task not found id={}", id);
```

#repl-note[
  `{}` — a hole, the argument gets substituted. Don't glue `"id=" + id` like in the corridor: the log can be lazy, and you won't pay for concatenation on a hot path. There's no hot path yet, but the habit is cheap.
  `getLogger(TaskService.class)` — the journal will have the class name. Later you grep `TaskService`, not the whole Tomcat bedsheet.
  `warn` — didn't find it to delete / didn't find it to hand out. Not `error`: a dumb client is not a reactor. Save `error` for "this should never have happened."
]

Launch, do a POST, watch the same black window where `mvnw` lives. A line `created task id=1`. No line — the logger is the wrong package, or the level is WARN globally, or you're logging in the controller and calling another class. Search.

A loudness ladder, no multiplication table:

- `ERROR` — a fire. Couldn't write. Not that the client sent an empty title.
- `WARN` — weird, but we live: deleted an id that isn't there.
- `INFO` — the watch: created, deleted, server start.
- `DEBUG` — for yourself at night. Turned it on in yml, fixed it, turned it off. Don't keep it for handing over the watch.

Break the log on purpose: set the level to `ERROR` on your package, do a POST, the `created` line won't be there. Put `INFO` back. Same ritual as a red test: make sure the sensor can stay quiet when you muted it.

#warn[
  Don't log passwords, tokens, bodies of other people's letters. Right now you only have `title`, and even that isn't a secret. The habit: into the journal — an id and a fact, not the whole life of the request. In an interview that sounds like "don't shine passwords," even if there is no password yet.
]

The filter at the end of the week — quest 8.J2, the idea isn't hidden:

```java
@GetMapping("/tasks")
public List<Task> all(@RequestParam(required = false) Boolean done) {
    if (done == null) {
        return service.findAll();
    }
    return service.findAll().stream()
        .filter(t -> t.isDone() == done)
        .toList();
}
```

#slow[
  `@RequestParam(required = false)` — the parameter may be missing. Then `done` is `null`, not `false`. An important hole: no parameter — *all*, done and not. `?done=true` — only done. `?done=false` — only alive.
  `Boolean`, not `boolean`: a primitive can't do "they didn't send it." An object can `null`.
  `stream().filter(...).toList()` — Java 16+, we have 21. A lambda again. The Lisp brain nods.
]

curl:

```
curl -s "localhost:8080/tasks?done=true"
curl -s "localhost:8080/tasks"
```

Quotes around a URL with `?` — so the shell doesn't eat it. On a Mac and in bash without quotes, `?` sometimes globs files. If you suddenly get "no file done=true" — that's it, quotes.

You need `complete` over HTTP, or the filter is boring. Minimum: `POST /tasks/{id}/complete` or `PATCH` with a body. Doesn't have to be REST-ideal. `isDone` has to be able to become `true` without a restart and without reflection. If you don't make REST in time — a service method + a temporary endpoint. The main thing — a filter you can check with curl.

=== Lisp: a watch journal in one function

```lisp
(defun log-info (fmt &rest args)
  (format t "INFO ")
  (apply #'format t fmt args)
  (terpri))
```

#repl-note[
  `&rest args` — "the remaining arguments as a list." `apply` unpacks the list into arguments for `format`. `(log-info "created id=~a" 3)` will print `INFO created id=3` and a newline. `terpri` — ter-mi-nate print, a new line, an old short word. Call it from `create-task` on the success branch. On `'bad-request` better `WARN`, if you start a `log-warn`. Quest 8.L2.
]

=== Handing over the watch: someone else's machine, your README

Week check: a fresh folder. Not the one where "I have everything open in IDEA for three days."

1. `git clone` yourself into `/tmp` (Mac/WSL) or into another Windows directory.
2. JDK 21 there? `java -version`.
3. `./mvnw test` (or `mvnw.cmd test`) — green.
4. `./mvnw spring-boot:run`.
5. curl from the README, *copy-paste*, not "I remember it by heart."

Didn't fly — fix the README, don't say "well it worked for me." It worked on *your* pile of accidents: port, JDK from IDEA, working folder, a dependency in the Maven cache. The README is for a person with their own pile.

#os[
  On Windows the log is in the same black window as `mvnw.cmd`. On a Mac — the same Terminal window. In IDEA — the Run tab. Don't look for `log.txt` in the root until you set up a file yourself. Today the console. Tomorrow, when Docker shows up, a file will appear by itself somewhere else, and you'll be looking for it again. The profession.
]

Handover checklist, out loud:

- Health is alive.
- POST creates, GET list sees it.
- GET by id: there / 404.
- POST of an empty title: 400.
- DELETE: 204 then 404.
- Log: create/delete visible.
- `?done=` doesn't crash.
- Tests without a manual "I poked it."

If a point lies — that isn't "a small thing." That's a hole in the airlock.

=== If it broke: logs and the filter

*No log.* The package in yml didn't match the real one (`com.example.taskmanager` vs `com.example.demo`). Copy it from the class `package ...`.

*Too many Hibernate logs.* There aren't any yet, you have no JPA. If you added JPA "to read about" — delete it. Month 3.

*`?done=true` always empty.* Nobody can `complete` over the network, everything is `done=false`. Make an endpoint, or a temporary `store.complete` in a `CommandLineRunner` — no, not a Runner. An endpoint. Honest.

*`done=yes`.* 400 from Boot: not a `Boolean`. Either catch it, or write `true`/`false` in the README, not "yes."

*Fresh clone, no `mvnw`.* You didn't commit the wrapper. Either commit `mvnw`, `mvnw.cmd`, `.mvn/`, or in the README honestly `mvn test` and require Maven installed. The wrapper is kinder to the inspector.

#exercise("8.L1", "Lisp")[
  `log-info`: prints `INFO ` and then like `format`. Call it from `create-task`. A watch journal.
]

#exercise("8.L2", "Lisp")[
  `log-warn` with the same gesture, prefix `WARN `. In `try-create` on the `'bad-request` branch — warn, on success — info. Two calls, two lines in the REPL of a different color... well, different text. Color in the terminal isn't required, the station is already yellow from duct tape.
]

#exercise("8.J1", "Java")[
  Logs on create/delete. README: where to look. On Windows the log is in the same black window as `mvnw.cmd`.
]

#exercise("8.J2", "Java")[
  `GET /tasks?done=true` — a filter. With no parameter — all, even the ones we promised to fix a long time ago.
]

#exercise("8.J3", "Java")[
  `WARN` in the log when `GET /tasks/{id}` or `DELETE` hit empty. Not `ERROR`. In the README one sample line from the console. If you can't pull it out — there's no log, quest 8.J1 is still alive.
]

#github[Commit `week8: rest in memory`. You can tag `v0.1`, like a game shipped.]

#sicp[If you suddenly liked that HTTP is text, and JSON is text, and a log is text: welcome. A lot of backend is agreements about text. SICP has nothing to do with it, but the itch "what's under the annotation" is useful. Sunday's `ServerSocket` scratches it.]

Watch handed over. In orbit it still smells like duct tape, someone still drank the coffee, but `curl localhost:8080/health` answers `UP`. Data in memory is a dream. Next month — Postgres, and the dream will learn to live in a table. Don't install Hibernate tonight "getting ahead." Getting ahead on MODULE ends with a dent in the airlock.

Tea. Commit. Sleep. Earth can wait until morning. It's got latency.
