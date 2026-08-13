#import "../lib-en.typ": *

= Answers

Try it yourself first. Really. If you jump straight here — the brain gets nothing, only the warm feeling of "I kind of know this." Below is one working version, not holy scripture.

=== Lesson 0

#solution("0.L1")[
```lisp
(+ 1 2 3 4 5)        ; 15
(* 2 3 4)            ; 24
(* (- 10 3) 2)       ; 14
```
]

#solution("0.J1")[
```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Name: Alex");
        System.out.println("Date: 2026-08-13");
    }
}
```
In the terminal: `javac Hello.java && java Hello`.
]

#solution("0.G1")[
`git add -A && git commit -m "week0: hello name" && git push`. In the browser on GitHub you can see the files on branch `main`.
]

#solution("0.L2")[
`(+ 2 "station")` — type error: `+` eats numbers. `(concatenate 'string "MODULE-" "1")` → `"MODULE-1"`. Log: two different errors side by side, so in a month you aren't hunting through memory.
]

#solution("0.J2")[
A second `println` with the number of compartments. Without running `javac` again the screen still shows the old number: the JVM runs the `.class`, not the `.java`. After `javac` — the new one. That's why there are two steps.
]

=== Lesson 1

#solution("1.L1")[
```lisp
(defun dock-ok (speed)
  (if (< speed 5) "soft" "too fast"))
```
]

#solution("1.L2")[
```lisp
(defun airlock (inside outside)
  (if (= inside outside) 'open 'sealed))
```
]

#solution("1.J1")[
```java
Scanner in = new Scanner(System.in);
int a = in.nextInt(), b = in.nextInt(), c = in.nextInt();
double avg = (a + b + c) / 3.0;
System.out.println(avg);
if (a < 0 || b < 0 || c < 0) System.out.println("ALARM");
```
Integer division `(a+b+c)/3` throws away the fraction — for an average use `3.0`.
]

#solution("1.J2")[
```java
int secret = 1 + (int) (Math.random() * 10);
int g = new Scanner(System.in).nextInt();
if (g == secret) System.out.println("right");
else if (g < secret) System.out.println("too low");
else System.out.println("too high");
```
]

#solution("1.L3")[
```lisp
(defun lamp (energy)
  (cond
    ((>= energy 80) 'green)
    ((>= energy 40) 'yellow)
    (t 'red)))
; (lamp 100) GREEN, (lamp 80) GREEN, (lamp 79) YELLOW,
; (lamp 40) YELLOW, (lamp 0) RED
```
]

#solution("1.J3")[
```java
while (true) {
    System.out.print("Energy 0..100: ");
    String raw = in.nextLine().trim();
    try {
        int n = Integer.parseInt(raw);
        if (n >= 0 && n <= 100) {
            System.out.println(n);
            break;
        }
    } catch (NumberFormatException e) {
        // prompt again
    }
}
```
]

=== Lesson 2

#solution("2.L1")[
```lisp
(defun rooms-report (lst)
  (loop for room in lst
        for i from 1
        do (format t "~a. ~a~%" i room)))
```
]

#solution("2.L2")[
```lisp
(defun has-reactor-p (lst)
  (not (null (member 'reactor lst))))
```
]

#solution("2.J1")[
Loop `while (true)`, `String line = in.nextLine()`, `split(" ", 2)`. `add` — `tasks.add(parts[1])`. `list` — numbered `for`. `del` — `remove(Integer.parseInt(n) - 1)` with a bounds check. `quit` — `break`.
]

#solution("2.J2")[
```java
Map<String, Integer> ages = Map.of("Ann", 20, "Bob", 15, "Cyd", 33);
ages.forEach((name, age) -> {
    if (age > 18) System.out.println(name);
});
```
`Map.of` — an immutable map; enough for a teaching printout.
]

#solution("2.L3")[
```lisp
(defun prepend-airlock (rooms)
  (cons 'airlock rooms))
; (defparameter *r* '(corridor))
; (prepend-airlock *r*) => (AIRLOCK CORRIDOR), *r* is still (CORRIDOR)
```
]

#solution("2.J3")[
```java
Map<String, Integer> energy = new HashMap<>();
energy.put("reactor", 80);
energy.put("antenna", 20);
energy.put("garden", 0);
energy.forEach((room, n) -> {
    if (n < 30) System.out.println(room);
});
```
]

=== Lesson 3

#solution("3.L1")[
```lisp
(defun clamp (n lo hi)
  (min hi (max lo n)))
(defun spend (energy cost) (clamp (- energy cost) 0 100))
(defun recharge (energy delta) (clamp (+ energy delta) 0 100))
(defun simulate (costs)
  (let ((e 100))
    (dolist (c costs) (setf e (spend e c)))
    e))
```
]

#solution("3.L2")[
```lisp
(defun render-room (room) (format nil "[~a]" room))
(defun print-rooms (lst)
  (dolist (r lst) (format t "~a~%" (render-room r))))
```
]

#solution("3.J1")[
`done 2` → `store.complete(2)` finds the `Task` with `id == 2` and calls `complete()`. Print: id, title, the done flag.
]

#solution("3.J2")[
Field `private int priority` defaults to `0` in the constructor. A setter or an `add(title, priority)` parameter. `list` prints `priority + " " + id + " " + title`.
]

#solution("3.L3")[
```lisp
(defun docking-score (speed fuel angle)
  (let ((speed-part (if (< speed 5) 10 0))
        (fuel-part (if (> fuel 20) 5 0))
        (angle-part (if (< (abs angle) 10) 3 0)))
    (+ speed-part fuel-part angle-part)))
```
]

#solution("3.J3")[
In `TaskStore`: loop over `tasks`, `t.getId() == id`, otherwise `null`. In `main`: `show 2` → `findById(2)`, on `null` print `missing`.
]

=== Lesson 4

#solution("4.L1")[
```lisp
(defun max-list (lst)
  (if (null (rest lst))
      (first lst)
      (let ((m (max-list (rest lst))))
        (if (> (first lst) m) (first lst) m))))
```
]

#solution("4.L2")[
```lisp
(defun filter-positive (lst)
  (cond
    ((null lst) nil)
    ((> (first lst) 0)
     (cons (first lst) (filter-positive (rest lst))))
    (t (filter-positive (rest lst)))))
```
]

#solution("4.J1")[
On start `titles = TaskFile.load(Path.of("tasks.txt"))`, rebuild `Task` with new ids in order. On `quit` — `titles` from `store.all()` via `getTitle()`, `save`. Empty file / no file → empty list.
]

#solution("4.J2")[
README: JDK 21, `javac`/`java` or IDEA, a command table, a sample dialogue. Without that, week 4 is not closed.
]

#solution("4.L3")[
```lisp
(defun rooms-length (lst)
  (if (null lst) 0 (+ 1 (rooms-length (rest lst)))))
(defun find-room (room lst)
  (cond
    ((null lst) nil)
    ((eq (first lst) room) lst)
    (t (find-room room (rest lst)))))
```
]

#solution("4.J3")[
Four disasters in the README: no `javac` → install JDK 21 and PATH; `cannot find symbol` → import or compile every `.java`; no `tasks.txt` → empty list, not a crash; letters instead of a number → prompt again.
]

=== Lesson 5

#solution("5.L1")[
```lisp
(mapcar (lambda (n) (min 100 (* n 2))) '(10 60 40))
; (20 100 80)
```
]

#solution("5.L2")[
```lisp
(defun offline-modules (alist)
  (mapcan (lambda (pair)
            (if (eq (cdr pair) 'down) (list (car pair)) nil))
          alist))
```
]

#solution("5.J1")[
`addIncreasesSize`; `completeMarksDone`; `completeMissing` — `assertThrows(NoSuchElementException.class, () -> store.complete(99))` or `assertFalse(store.complete(99))`, if you chose `boolean`.
]

#solution("5.J2")[
Temporarily comment out `task.setDone(true)`. Red test. Put it back. README: `mvn test` or IDEA's green arrow.
]

#solution("5.L3")[
```lisp
(defun energy-of (module alist)
  (cdr (assoc module alist)))
; (energy-of 'reactor *energy*) => 80, 'garden => NIL
```
]

#solution("5.J3")[
`git checkout -b feat/tests`, commit, `git switch main`, `git merge feat/tests`. In the README three lines of `git log --oneline`.
]

=== Lesson 6

#solution("6.L1")[
```lisp
(defun http-not-found ()
  (format nil "HTTP/1.1 404 Not Found~%Content-Type: text/plain~%~%missing"))
```
]

#solution("6.L2")[
```lisp
(defun json-task (id title)
  (format nil "{\"id\":~a,\"title\":\"~a\"}" id title))
```
]

#solution("6.J1")[
```java
@GetMapping("/tasks/{id}")
public ResponseEntity<Task> one(@PathVariable int id) {
    return tasks.stream()
        .filter(t -> t.getId() == id)
        .findFirst()
        .map(ResponseEntity::ok)
        .orElse(ResponseEntity.notFound().build());
}
```
]

#solution("6.J2")[
Five curls: health, list empty, POST, list one, GET by id. Expected JSON, short.
]

#solution("6.L3")[
```lisp
(defun http-created (body)
  (format nil "HTTP/1.1 201 Created~%Content-Type: application/json~%~%~a" body))
; (http-created (json-task 2 "antenna"))
```
]

#solution("6.J3")[
`curl -i -X POST ... -d '{}'` — copy the `HTTP/1.1 ...` line into the README. Before lesson 7 it's often 500; after you catch it — 400. Honestly record what you see.
]

=== Lesson 7

#solution("7.L1")[
```lisp
(defun create-task (title)
  (if (or (null title) (string= title ""))
      (error "title required")
      (list :title title :done nil)))

(defun try-create (title)
  (handler-case (create-task title)
    (error () 'bad-request)))
```
]

#solution("7.J1")[
A controller with `private final TaskService service` and a constructor. Annotations `@RestController`, `@Service`. No list in the controller.
]

#solution("7.J2")[
Service `boolean delete(int id)` / `void` + an exception. Controller 204 `noContent` or 404. A unit test of the service without `@SpringBootTest`.
]

#solution("7.L2")[
```lisp
(defun blank-p (s)
  (or (null s) (string= (string-trim '(#\Space) s) "")))
(defun create-task (title)
  (if (blank-p title)
      (error "title required")
      (list :title (string-trim '(#\Space) title) :done nil)))
```
]

#solution("7.J3")[
`create` catches `IllegalArgumentException` → 400 and `{"error":"title required"}`. Two `curl -i` in the README: `""` and `"   "`.
]

=== Lesson 8

#solution("8.L1")[
```lisp
(defun log-info (fmt &rest args)
  (format t "INFO ")
  (apply #'format t fmt args)
  (terpri))
```
]

#solution("8.J1")[
`LoggerFactory.getLogger`. `log.info("created id={}", id)`.
]

#solution("8.J2")[
```java
@GetMapping("/tasks")
public List<Task> all(@RequestParam(required = false) Boolean done) {
    if (done == null) return service.findAll();
    return service.findAll().stream()
        .filter(t -> t.isDone() == done)
        .toList();
}
```
]

#solution("8.L2")[
```lisp
(defun log-warn (fmt &rest args)
  (format t "WARN ")
  (apply #'format t fmt args)
  (terpri))
; in try-create: success — log-info, error — log-warn and 'bad-request
```
]

#solution("8.J3")[
`log.warn("task not found id={}", id)` in the service or the controller on 404. In the README a line from the Run console / `mvnw`.
]

=== Lesson 9

#solution("9.L1")[
See `save-tasks` / `load-tasks` in the chapter text. In a new session `(load-tasks "module-tasks.lisp-data")`.
]

#solution("9.J1")[
Three `INSERT`, `SELECT id, title FROM tasks;`, copy the output into the README in a code block.
]

#solution("9.J2")[
`spring.datasource.url=jdbc:postgresql://localhost:5432/taskdb`. `JdbcTemplate.query` with a `RowMapper`. `GET /tasks` reads the DB.
]

#solution("9.J3")[
Wrong password: `password authentication failed`. No database: `database "taskdb" does not exist`. No table: `relation "tasks" does not exist`. Three quotes in the README, then a working yml.
]

=== Lesson 10

#solution("10.L1")[
```lisp
(defun tasks-of (pid projects)
  (cdr (assoc pid projects)))
; example: '((1 . (a b)) (2 . (c)))
```
]

#solution("10.J1")[
`JpaRepository<Task, Long>`, `POST` → `save`, Flyway `V1__tasks.sql` matches `@Table`. `ddl-auto: validate`.
]

#solution("10.J2")[
`GET` builds a DTO: project id, name, a list of `{id,title}` without a nested project on every task.
]

#solution("10.J3")[
A field on the entity with no column → `Schema-validation: missing column [...]`. Quote the first `Caused by` in the README. Then `V2__...sql` with `ALTER TABLE ... ADD COLUMN`.
]

=== Lesson 11

#solution("11.L1")[
```lisp
(defun apply-ops (state ops)
  (if (find 'fail ops)
      state
      (append state ops)))
```
Teaching model: "all or nothing."
]

#solution("11.J1")[
One `@Transactional` method: `projectRepository.save` then `taskRepository.save`. Empty title — `IllegalArgumentException` before the second save or after a check. Test: the project count did not grow.
]

#solution("11.J2")[
In the log, count the `select`s. Put the number in the README. If it's one query per item — you saw N+1.
]

#solution("11.J3")[
`JOIN FETCH` or a DTO query. In the log one (or two: count + data) `select` with a `join`, not a spray of identical `where project_id=?`. Two numbers: before / after.
]

=== Lesson 12

#solution("12.L1")[
```lisp
(save-tasks "t.dat" '((1 . "airlock")))
; new SBCL session:
(equal (load-tasks "t.dat") '((1 . "airlock")))
; T, otherwise (error "station lost the log")
```
]

#solution("12.J1")[
Four tests: create returns an id; get of unknown — empty/404; update changes the title; delete then get is empty.
]

#solution("12.J2")[
README: Postgres version, `flyway`, `mvn test`, curl CRUD, the H2 limitation if there is one.
]

=== Lesson 13

#solution("13.L1")[
```lisp
(defparameter *users* (make-hash-table :test 'equal))
(defun register (email password)
  (when (gethash email *users*) (error "exists"))
  (setf (gethash email *users*) (sxhash password))
  t)
(defun login (email password)
  (eql (gethash email *users*) (sxhash password)))
```
]

#solution("13.J1")[
`Task.userId` from `Authentication`. Repository `findByUserId`. Security: authenticated for `/tasks/**`.
]

#solution("13.J2")[
Service: if `task.getUserId() != current` → 404 (hiding the fact) or 403. A test with two users.
]

#solution("13.J3")[
Without `Authorization` — 401. Someone else's id — 404 or 403 (as you chose in 13.J2). Your own — 200 and a body. Three curls in the README.
]

=== Lesson 14

#solution("14.L1")[
Scan: `(loop for (u . tid) in pairs if (eql u user) collect tid)`. Index: `gethash user table`. For 10000 that's already noticeable in the REPL if you spin it thousands of times.
]

#solution("14.J1")[
`V2__idx_tasks_user.sql`: `CREATE INDEX ...`. Controller `Page<Task>` + `Pageable`.
]

#solution("14.J2")[
Two `EXPLAIN ANALYZE` blocks in the README: Seq Scan vs Index Scan (depends on volume; on three rows the optimizer may skip the index — pour in thousands of rows).
]

#solution("14.J3")[
`page=0&size=5` and `page=1&size=5`. Ids in `content` don't overlap. If they overlap — Pageable never reached the repository.
]

=== Lesson 15

#solution("15.L1")[
```lisp
(defun balanced-p (s)
  (let ((st nil))
    (loop for ch across s do
      (cond
        ((char= ch #\() (push #\) st))
        ((char= ch #\[) (push #\] st))
        ((member ch '(#\) #\]) :test #'char=)
         (unless (and st (char= ch (pop st)))
           (return-from balanced-p nil)))))
    (null st)))
```
]

#solution("15.J1")[
```java
record UserId(long value) {}
// a record already gives equals/hashCode.
// If you write your own class — Objects.equals / Objects.hash(value).
```
]

#solution("15.J2")[
Reverse: two indices `i,j`. Frequency: `HashMap<Character,Integer>`. Brackets: `ArrayDeque<Character>` as a stack.
]

#solution("15.J3")[
A class without equals: `get(new UserId(1))` → `null` after `put(new UserId(1), ...)`. `record UserId(long v)` — finds it. Two `println`s in the README.
]

=== Lesson 16

#solution("16.L1")[
Instead of `*energy*` — `(defun tick (energy cost) ...)`. The call chain passes the new value. The global is not read.
]

#solution("16.J1")[
Two `Thread`s, 100000 `inc` each. Print `n`. Then `synchronized void inc()`. Compare.
]

#solution("16.J2")[
Not code: a file `core-answers.md` or your voice. The checklist from the lesson 16 text.
]

#solution("16.J3")[
`AtomicInteger n = new AtomicInteger();` in `inc` — `n.incrementAndGet()`. Three runs: the hole / 200000 / 200000.
]

=== Lessons 17–20

#solution("17.L1")[
```lisp
(defstruct centry value expire)
(defun cget (h key)
  (let ((e (gethash key h)))
    (when (and e (< (get-universal-time) (centry-expire e)))
      (centry-value e))))
(defun cset (h key value ttl)
  (setf (gethash key h)
        (make-centry :value value
                     :expire (+ (get-universal-time) ttl))))
```
]

#solution("17.J1")[
`@Cacheable` / a hand-rolled `RedisTemplate`. On update `convertAndSend` is not needed — `delete(key)`. README: reproducing stale without delete.
]

#solution("17.J2")[
TTL 1–2 s, the key goes stale, a burst of GET. In the log several identical SELECT — stampede. README: the number and how you launched it (`xargs -P` or two windows).
]

#solution("18.L1")[
`enqueue` via `append` or a tail. `drain`: `dolist` while the queue isn't empty, `format t`.
]

#solution("18.J1")[
`@ApplicationEvent` `TaskCreatedEvent` + `@TransactionalEventListener`. A log in the listener.
]

#solution("18.J2")[
`ArrayBlockingQueue<>(4)`, producer `put` 8 times, consumer `take`. Log "waiting on put" / "took". No Spring.
]

#solution("19.L1")[
```lisp
(defparameter *log* (make-array 0 :adjustable t :fill-pointer 0))
(defun produce (x) (vector-push-extend x *log*))
(defun consume (offset)
  (when (< offset (length *log*)) (aref *log* offset)))
```
]

#solution("19.J1")[
Either `KafkaTemplate.send("task-events", json)`, or an honest `docs/kafka.md`.
]

#solution("19.J2")[
A table: POST of tasks while the mail is dead — HTTP 201 vs the log catching up. Five lines in your own words, not Wikipedia.
]

#solution("20.J1")[
Compose: services `db`, `app`, `depends_on`, a Postgres healthcheck. App: `SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/taskdb`.
]

#solution("20.J2")[
```yaml
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: 21 }
      - run: mvn -B test
```
]

#solution("20.J3")[
From the host, curl → `localhost:8080`. The JVM in the `app` container → host `db`, not `localhost`. `localhost` inside a container is the container itself.
]

=== Lessons 21–26

#solution("21.J1")[
Check: a new directory, README only. Stopwatch. If you get stuck — a hole in the README, not in "obviousness."
]

#solution("21.J2")[
Template: "REST for personal tasks. Java 21, Spring Boot, PostgreSQL, JWT. Registration, CRUD, pagination. Link: github.com/…/task-manager".
]

#solution("21.J3")[
One page: name, contact, stack in a line, two projects with links. Courses at the bottom. Lisp under "also this." Forty seconds out loud.
]

#solution("22.J1")[
3 minutes: problem → demons (API, DB, auth) → one technical choice you're proud of → what you'd rewrite.
]

#solution("22.L1")[
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
```
]

#solution("22.J2")[
Bad: "Spring itself, CRUD, I wanted Kafka." Good: problem → my own tasks/JWT → a cache with invalidation → what's missing (Kafka in prod) → compose. Only what's in git.
]

#solution("23.J1")[
"Saw vacancy N. Built CRUD with PostgreSQL and tests (link). I haven't shipped Kafka in prod; queue/events live in the monolith. Happy to talk."
]

#solution("23.J2")[
Out loud: "haven't shipped it in prod, here's log vs HTTP; Redis — TTL and invalidation, I broke stale; I didn't carve out microservices because of the transaction." No apology for existing.
]

#solution("24.J1")[
One card = question + answer + a link to a project file (`TaskService.java:40`).
]

#solution("24.J2")[
Three cards before the interview: 401 vs 403; an index; the transaction that creates a project+task. In your own words, not Wikipedia.
]

#solution("25.J1")[
Anagram: sort the char array or frequencies. Merge: two indices. Emails: normalize `+` and dots in the local part per the problem statement.
]

#solution("25.L1")[
```lisp
(defun anagram-p (a b)
  (string= (sort (copy-seq a) #'char<)
           (sort (copy-seq b) #'char<)))
```
Live coding matters more than the ideal: it compiles, there are examples, you can say the complexity.
]

=== Chapter "how a computer is built"

#solution("0b.1")[
Mac / WSL:

```
mkdir module-cabin
cd module-cabin
echo "station MODULE" > note.txt
pwd
ls
cat note.txt
```

The second line in `note.txt` is exactly what `pwd` printed (for example `/Users/you/dev/module-cabin` or `/home/you/module-cabin`). PowerShell: `New-Item`, `Get-Location`, `Get-Content`. If the path is "wrong" — you created the folder from somewhere other than where you were standing. That is the answer.
]

#solution("0b.2")[
Pantry: the file `Hello.java` (and after `javac` — `Hello.class`). Counter: bytecode and variables of the running `java` process. Cook: the CPU executing JVM instructions. The Run icon only asks the chef (the OS) to start that recipe.
]

#solution("0b.3")[
The bytes are the same. What broke is the contract for how to read them. UTF-8 puts a Russian letter in two bytes, Windows-1251 expects one byte per letter — so the eye sees mojibake. Restore UTF-8 — the word is `МОДУЛЬ` again. Don't retype the mojibake "as is" into a new file: then you're corrupting the numbers themselves.
]

=== Station log MODULE

#solution("S.L1")[
```lisp
(defun ticks (n)
  (loop repeat n do (tick))
  *energy*)
```
Recursion: `(defun ticks (n) (if (<= n 0) *energy* (progn (tick) (ticks (- n 1)))))`. `clamp-energy` is already in `tick` — you won't go below zero.
]

#solution("S.L2")[
```lisp
(defun exits-report ()
  (dolist (pair *doors*)
    (format t "~a -> ~a~%" (car pair) (cdr pair))))
```
]

#solution("S.L3")[
```lisp
(defun drop (item)
  (if (member item *pocket*)
      (progn
        (setf *pocket* (remove item *pocket*))
        (setf (cdr (assoc *here* *at*))
              (cons item (stuff-here)))
        (format t "dropped ~a~%" item))
      (format t "not in pocket: ~a~%" item)))
```
Check: pick it up in the reactor, `walk` to the corridor, `drop`, go back — the reactor is empty.
]

#solution("S.L4")[
```lisp
(defparameter *lamp* 'dead)
(defun whack ()
  (cond
    ((not (eq *here* 'galley)) 'wrong-room)
    ((not (member 'wrench *pocket*)) 'need-wrench)
    (t (setf *lamp* 'ok) 'fixed)))
```
In the corridor `look`: if `*lamp*` is `'ok` — a different line about the ballast. Otherwise an honest comment: it's a prop.
]

#solution("S.L5")[
```lisp
(defun save ()
  (save-world "module-save.lisp-data"))
(defun load ()
  (if (probe-file "module-save.lisp-data")
      (load-world "module-save.lisp-data")
      'no-save))
```
`probe-file` — "is the jar on the shelf." After you tape the leak, `*fixed*` must be in the plist, or the load will forget the duct tape.
]

#solution("S.L6")[
For five rooms an honest table from `airlock`: corridor 1, galley 2, reactor 2, cupola 3. Otherwise BFS/recursion with a queue. `airlock` → `cupola` is not 1: there's no hatch, the path goes through the corridor and the galley.
]

#solution("S.L7")[
```lisp
(defun coffee ()
  (cond
    ((not (eq *here* 'galley)) 'wrong-room)
    ((< *energy* 4)
     (format t "steam. energy ~a~%" *energy*)
     'steam)
    (t
     (setf *energy* (- *energy* 4))
     (if (member 'mug *pocket*)
         (format t "into Щ's mug. energy ~a~%" *energy*)
         (format t "on the floor. energy ~a~%" *energy*))
     'sludge)))
```
]

=== Java lab

#solution("J.L1")[
First the pit: `nextInt` + `nextLine` → empty brackets. Then:

```java
int energy = Integer.parseInt(in.nextLine().trim());
String cmd = in.nextLine();
```

Comment: `nextInt` leaves the `end of line` in stdin, and the next `nextLine` will eat it.
]

#solution("J.L2")[
`split(" ")`, length 3, `parseInt` in a `try`. `energy`/`oxygen` 0..100, `temp` -20..40. Not a number — a message, `continue`. The process does not die.
]

#solution("J.L3")[
`Files.exists` — no file → defaults and the line `no station.txt, using defaults`. Each line gets its own `try` around `parseInt`, a broken one — `System.err`, the other keys live. Not one `catch (Exception e)` around the whole load.
]

#solution("J.L4")[
```java
return "{\"energy\":" + e + ",\"oxygen\":" + o + ",\"temp\":" + t + "}";
```
Validator green. A room name with a `quote` and no escape — red. README: Jackson escapes strings and nesting so you don't assemble JSON by concatenation.
]

#solution("J.L5")[
`HttpClient.send` GET `https://httpbin.org/get` — status and `body.substring(0, Math.min(200, body.length()))`. Second URL `/status/404` — print 404, that is not a broken client. Third — `catch`, the exception class name + `getMessage()`.
]

#solution("J.L6")[
Three files, state only in `Station`.

```
javac Station.java StationFile.java StationDash.java
java StationDash
```

README: those commands + a dialogue of `status` / `set energy 55` / `save` / `quit`.
]

#solution("26.J1")[
Two weeks on a calendar: dates of emails, a pitch slot, a slot for three problems. Visible to the eye, not "in your head."
]

#solution("26.L1")[
On the day of the rejection — any station étude, even `(ev '(+ 1 2))`. Parentheses don't know HR.
]

=== Android

#solution("A.J1")[
Listeners on `mul` and `div`. If the divisor is 0 — `out.setText("can't")`, not `Infinity` and not a crash.
]

#solution("A.J2")[
Empty: `trim().isEmpty()` before parse. Catch `NumberFormatException`. README: empty means zero *or* the label "enter numbers."
]

#solution("A.J3")[
`Log.d` in `onCreate`/`onStart`/`onResume`/`onPause`/`onStop`. Home: pause+stop, return start+resume. Rotate: often destroy+a new onCreate.
]

#solution("A.J4")[
`ArrayList` + `ArrayAdapter` + `ListView`. Three finger-sized tasks. README: "while it's in memory." A screenshot.
]

#solution("A.J5")[
`AboutActivity`, `Intent` + `putExtra("last", ...)`. On the other side `getStringExtra`. The system Back with no magic of your own.
]

#solution("A.J6")[
`onSaveInstanceState` / read it in `onCreate` for two fields. Recents killing the process — fields may vanish, that's in the README. The list — optional `SharedPreferences`.
]

#solution("A.J7")[
Not the UI thread, GET health, URL `10.0.2.2` from the emulator. An error on screen, not a crash. README: why not localhost.
]

=== Macros, CLOS, the live image

#solution("M.L1")[
`macroexpand-1` on `(module-when test a b)` gives `if` with `(progn a b)`. Without `progn`, `if` has one form per branch: `b` is lost or becomes the "else."
]

#solution("M.L2")[
`with-energy`: `gensym` for the cost, compare with `*energy*`, if too low `'too-low` without `decf`. If enough — `decf`, then the body. Two runs: 10 against 15 and 20 against 15.
]

#solution("M.L3")[
`twice-wrong` substitutes the argument twice: two `tick`s. `twice-right` — `let` + `gensym`, one side effect. Look at `macroexpand-1` of both, not "yeah they look the same."
]

#solution("C.L1")[
`defclass module`, `make-instance`, `setf` via the accessor, `module-status` — one line with the name and the energy.
]

#solution("C.L2")[
`antenna` inherits from `module`. Its own `defmethod module-status`. `(mapcar #'module-status (list reactor dish))` — two different lines.
]

#solution("C.L3")[
`:around` + `call-next-method`, when energy is 0 append ` ALARM`. One wrapper for everyone, not two identical `if`s.
]

#solution("C.L4")[
Class `station`, a slot that is a list of modules, `station-report` = `mapcar #'module-status`. Two different classes in the list.
]

#solution("C.L5")[
`(defclass comm-antenna (module powered radio) ())`, `typep` on all three — `t`. Slots from both sides are readable. In Java there are no two parent classes with slots, only one `extends`.
]

#solution("C.L6")[
`class-precedence-list` before and after swapping the order in `defclass`. Names in the CPL move. That isn't a bug, that's a lever.
]

#solution("I.L1")[
Without `(quit)`: old `defmethod`, a call, new `defmethod`, a call on the same instance. Data the same, status string different. If only a new `make-instance` helped — you killed the image.
]
