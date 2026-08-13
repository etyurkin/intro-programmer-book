#import "../lib.typ": *

= Отгадки

Сначала своя попытка. Правда. Если сразу сюда — мозг ничего не получит, только тёплое чувство «я как будто умею». Ниже — один из рабочих вариантов, не священное писание.

=== Занятие 0

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
        System.out.println("Имя: Алекс");
        System.out.println("Дата: 2026-08-13");
    }
}
```
В терминале: `javac Hello.java && java Hello`.
]

#solution("0.G1")[
`git add -A && git commit -m "week0: hello name" && git push`. В браузере на GitHub видны файлы ветки `main`.
]

#solution("0.L2")[
`(+ 2 "станция")` — type error: `+` ест числа. `(concatenate 'string "МОДУЛЬ-" "1")` → `"МОДУЛЬ-1"`. Журнал: две разные ошибки рядом, чтобы через месяц не искать в памяти.
]

#solution("0.J2")[
Вторая `println` с числом отсеков. Без повторного `javac` на экране старое число: JVM запускает `.class`, не `.java`. После `javac` — новое. Вот зачем два шага.
]

=== Занятие 1

#solution("1.L1")[
```lisp
(defun dock-ok (speed)
  (if (< speed 5) "мягко" "слишком быстро"))
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
Целочисленное деление `(a+b+c)/3` отбросит дробь — для среднего используй `3.0`.
]

#solution("1.J2")[
```java
int secret = 1 + (int) (Math.random() * 10);
int g = new Scanner(System.in).nextInt();
if (g == secret) System.out.println("верно");
else if (g < secret) System.out.println("мало");
else System.out.println("много");
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
    System.out.print("Энергия 0..100: ");
    String raw = in.nextLine().trim();
    try {
        int n = Integer.parseInt(raw);
        if (n >= 0 && n <= 100) {
            System.out.println(n);
            break;
        }
    } catch (NumberFormatException e) {
        // снова приглашение
    }
}
```
]

=== Занятие 2

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
Цикл `while (true)`, `String line = in.nextLine()`, `split(" ", 2)`. `add` — `tasks.add(parts[1])`. `list` — нумерованный `for`. `del` — `remove(Integer.parseInt(n) - 1)` с проверкой границ. `quit` — `break`.
]

#solution("2.J2")[
```java
Map<String, Integer> ages = Map.of("Ann", 20, "Bob", 15, "Cyd", 33);
ages.forEach((name, age) -> {
    if (age > 18) System.out.println(name);
});
```
`Map.of` — неизменяемая карта; для учебного вывода достаточно.
]

#solution("2.L3")[
```lisp
(defun prepend-airlock (rooms)
  (cons 'airlock rooms))
; (defparameter *r* '(corridor))
; (prepend-airlock *r*) => (AIRLOCK CORRIDOR), *r* ещё (CORRIDOR)
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

=== Занятие 3

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
`done 2` → `store.complete(2)` ищет `Task` с `id == 2` и вызывает `complete()`. Печать: id, title, флаг done.
]

#solution("3.J2")[
Поле `private int priority` в конструкторе по умолчанию `0`. Сеттер или параметр `add(title, priority)`. `list` печатает `priority + " " + id + " " + title`.
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
В `TaskStore`: цикл по `tasks`, `t.getId() == id`, иначе `null`. В `main`: `show 2` → `findById(2)`, при `null` печать `missing`.
]

=== Занятие 4

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
При старте `titles = TaskFile.load(Path.of("tasks.txt"))`, восстановить `Task` с новыми id по порядку. При `quit` — `titles` из `store.all()` через `getTitle()`, `save`. Пустой файл / нет файла → пустой список.
]

#solution("4.J2")[
README: JDK 21, `javac`/`java` или IDEA, таблица команд, пример диалога. Без этого неделя 4 не закрыта.
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
В README четыре беды: нет `javac` → ставь JDK 21 и PATH; `cannot find symbol` → импорт или компиль все `.java`; нет `tasks.txt` → пустой список, не падение; буквы вместо числа → повторить ввод.
]

=== Занятие 5

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
`addIncreasesSize`; `completeMarksDone`; `completeMissing` — `assertThrows(NoSuchElementException.class, () -> store.complete(99))` или `assertFalse(store.complete(99))`, если выбрал `boolean`.
]

#solution("5.J2")[
Временно закомментируй `task.setDone(true)`. Красный тест. Верни. README: `mvn test` или зелёная стрелка IDEA.
]

#solution("5.L3")[
```lisp
(defun energy-of (module alist)
  (cdr (assoc module alist)))
; (energy-of 'reactor *energy*) => 80, 'garden => NIL
```
]

#solution("5.J3")[
`git checkout -b feat/tests`, коммит, `git switch main`, `git merge feat/tests`. В README три строки `git log --oneline`.
]

=== Занятие 6

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
Пять curl: health, list empty, POST, list one, GET by id. Ожидаемый JSON коротко.
]

#solution("6.L3")[
```lisp
(defun http-created (body)
  (format nil "HTTP/1.1 201 Created~%Content-Type: application/json~%~%~a" body))
; (http-created (json-task 2 "антенна"))
```
]

#solution("6.J3")[
`curl -i -X POST ... -d '{}'` — скопируй строку `HTTP/1.1 ...` в README. До занятия 7 часто 500; после ловли — 400. Честно зафиксируй то, что видишь.
]

=== Занятие 7

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
Контроллер с `private final TaskService service` и конструктором. Аннотации `@RestController`, `@Service`. Списка в контроллере нет.
]

#solution("7.J2")[
Сервис `boolean delete(int id)` / `void` + исключение. Контроллер 204 `noContent` или 404. Юнит-тест сервиса без `@SpringBootTest`.
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
`create` ловит `IllegalArgumentException` → 400 и `{"error":"title required"}`. Два `curl -i` в README: `""` и `"   "`.
]

=== Занятие 8

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
; в try-create: успех — log-info, error — log-warn и 'bad-request
```
]

#solution("8.J3")[
`log.warn("task not found id={}", id)` в сервисе или контроллере на 404. В README строка из консоли Run / `mvnw`.
]

=== Занятие 9

#solution("9.L1")[
См. `save-tasks` / `load-tasks` в тексте главы. В новой сессии `(load-tasks "module-tasks.lisp-data")`.
]

#solution("9.J1")[
Три `INSERT`, `SELECT id, title FROM tasks;`, вывод скопировать в README в блок кода.
]

#solution("9.J2")[
`spring.datasource.url=jdbc:postgresql://localhost:5432/taskdb`. `JdbcTemplate.query` с `RowMapper`. `GET /tasks` читает БД.
]

#solution("9.J3")[
Неверный пароль: `password authentication failed`. Нет базы: `database "taskdb" does not exist`. Нет таблицы: `relation "tasks" does not exist`. Три цитаты в README, потом рабочий yml.
]

=== Занятие 10

#solution("10.L1")[
```lisp
(defun tasks-of (pid projects)
  (cdr (assoc pid projects)))
; пример: '((1 . (a b)) (2 . (c)))
```
]

#solution("10.J1")[
`JpaRepository<Task, Long>`, `POST` → `save`, Flyway `V1__tasks.sql` совпадает с `@Table`. `ddl-auto: validate`.
]

#solution("10.J2")[
`GET` собирает DTO: id проекта, имя, список `{id,title}` без вложенного project в каждой задаче.
]

#solution("10.J3")[
Поле в entity без колонки → `Schema-validation: missing column [...]`. Цитата первого `Caused by` в README. Потом `V2__...sql` с `ALTER TABLE ... ADD COLUMN`.
]

=== Занятие 11

#solution("11.L1")[
```lisp
(defun apply-ops (state ops)
  (if (find 'fail ops)
      state
      (append state ops)))
```
Учебная модель: «всё или ничего».
]

#solution("11.J1")[
Один `@Transactional` метод: `projectRepository.save` затем `taskRepository.save`. Пустой title — `IllegalArgumentException` до второго save или после проверки. Тест: count проектов не вырос.
]

#solution("11.J2")[
В логе посчитайте `select`. Вставьте число в README. Если по запросу на элемент — ты видел N+1.
]

#solution("11.J3")[
`JOIN FETCH` или DTO-запрос. В логе один (или два: count + data) `select` с `join`, не пачка одинаковых `where project_id=?`. Два числа: до / после.
]

=== Занятие 12

#solution("12.L1")[
```lisp
(save-tasks "t.dat" '((1 . "шлюз")))
; новая сессия SBCL:
(equal (load-tasks "t.dat") '((1 . "шлюз")))
; T, иначе (error "станция потеряла журнал")
```
]

#solution("12.J1")[
Четыре теста: create возвращает id; get неизвестного — empty/404; update меняет title; delete затем get пусто.
]

#solution("12.J2")[
README: Postgres version, `flyway`, `mvn test`, curl CRUD, ограничение H2 если есть.
]

=== Занятие 13

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
`Task.userId` из `Authentication`. Репозиторий `findByUserId`. Security: authenticated для `/tasks/**`.
]

#solution("13.J2")[
Сервис: если `task.getUserId() != current` → 404 (скрытие факта) или 403. Тест с двумя пользователями.
]

#solution("13.J3")[
Без `Authorization` — 401. Чужой id — 404 или 403 (как выбрал в 13.J2). Свой — 200 и тело. Три curl в README.
]

=== Занятие 14

#solution("14.L1")[
Проход: `(loop for (u . tid) in pairs if (eql u user) collect tid)`. Индекс: `gethash user table`. Для 10000 это уже ощутимо в REPL, если крутить тысячи раз.
]

#solution("14.J1")[
`V2__idx_tasks_user.sql`: `CREATE INDEX ...`. Контроллер `Page<Task>` + `Pageable`.
]

#solution("14.J2")[
Два блока `EXPLAIN ANALYZE` в README: Seq Scan vs Index Scan (зависит от объёма; на трёх строках оптимизатор может не взять индекс — налей тысячи строк).
]

#solution("14.J3")[
`page=0&size=5` и `page=1&size=5`. Id в `content` не пересекаются. Если пересекаются — Pageable не дошёл до репозитория.
]

=== Занятие 15

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
// record уже даёт equals/hashCode.
// Если свой класс — Objects.equals / Objects.hash(value).
```
]

#solution("15.J2")[
Reverse: два индекса `i,j`. Частота: `HashMap<Character,Integer>`. Скобки: `ArrayDeque<Character>` как стек.
]

#solution("15.J3")[
Класс без equals: `get(new UserId(1))` → `null` после `put(new UserId(1), ...)`. `record UserId(long v)` — находит. Два `println` в README.
]

=== Занятие 16

#solution("16.L1")[
Вместо `*energy*` — `(defun tick (energy cost) ...)`. Цепочка вызовов передаёт новое значение. Глобаль не читается.
]

#solution("16.J1")[
Два `Thread` по 100000 `inc`. Печать `n`. Затем `synchronized void inc()`. Сравни.
]

#solution("16.J2")[
Не код: файл `core-answers.md` или голос. Чеклист из текста занятия 16.
]

#solution("16.J3")[
`AtomicInteger n = new AtomicInteger();` в `inc` — `n.incrementAndGet()`. Три запуска: дыра / 200000 / 200000.
]

=== Занятие 17–20

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
`@Cacheable` / ручной `RedisTemplate`. На update `convertAndSend` не нужен — `delete(key)`. README: воспроизведение stale без delete.
]

#solution("17.J2")[
TTL 1–2 с, ключ протух, пачка GET. В логе несколько одинаковых SELECT — stampede. README: число и как запускал (`xargs -P` или два окна).
]

#solution("18.L1")[
`enqueue` через `append` или хвост. `drain`: `dolist` пока очередь не пуста, `format t`.
]

#solution("18.J1")[
`@ApplicationEvent` `TaskCreatedEvent` + `@TransactionalEventListener`. Лог в listener.
]

#solution("18.J2")[
`ArrayBlockingQueue<>(4)`, продюсер 8 раз `put`, консьюмер `take`. Лог «жду put» / «взял». Без Spring.
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
Либо `KafkaTemplate.send("task-events", json)`, либо честный `docs/kafka.md`.
]

#solution("19.J2")[
Таблица: POST задач при мёртвой почте — HTTP 201 vs журнал догонит. Пять строк своими словами, не Википедия.
]

#solution("20.J1")[
Compose: сервисы `db`, `app`, `depends_on`, healthcheck Postgres. App: `SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/taskdb`.
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
С хоста curl → `localhost:8080`. JVM в контейнере `app` → хост `db`, не `localhost`. `localhost` внутри контейнера — он сам.
]

=== Занятие 21–26

#solution("21.J1")[
Проверка: новая директория, только README. Секундомер. Если застрял — дыра в README, не в «очевидности».
]

#solution("21.J2")[
Шаблон: «REST для личных задач. Java 21, Spring Boot, PostgreSQL, JWT. Регистрация, CRUD, пагинация. Ссылка: github.com/…/task-manager».
]

#solution("21.J3")[
Одна страница: имя, связь, стек строкой, два проекта со ссылками. Курсы внизу. Lisp в «ещё вот». Сорок секунд вслух.
]

#solution("22.J1")[
3 минуты: проблема → что показать (API, БД, auth) → одно техническое решение, которым гордишься → что бы переписали.
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
Плохой: «Спринг сам, CRUD, хотел Кафку». Хороший: проблема → свои задачи/JWT → кэш со сбросом → чего нет (Kafka в бою) → compose. Только то, что в git.
]

#solution("23.J1")[
«Видел вакансию N. Делал CRUD с PostgreSQL и тестами (ссылка). Kafka в проде не внедрял; очередь/события — в монолите. Готов обсудить».
]

#solution("23.J2")[
Вслух: «в бою не внедрял, вот лог vs HTTP; Redis — TTL и сброс, ломал stale; микросервисы не выкусывал из-за транзакции». Без извинения за жизнь.
]

#solution("24.J1")[
Одна карточка = вопрос + ответ + ссылка на файл проекта (`TaskService.java:40`).
]

#solution("24.J2")[
Три карточки до собеса: 401 vs 403; индекс; транзакция create проекта+задачи. Своими словами, не Википедия.
]

#solution("25.J1")[
Anagram: сортировка массива символов или частоты. Merge: два индекса. Emails: нормализация `+` и точки локальной части по условию задачи.
]

#solution("25.L1")[
```lisp
(defun anagram-p (a b)
  (string= (sort (copy-seq a) #'char<)
           (sort (copy-seq b) #'char<)))
```
Живой coding важнее идеала: компилируемость, примеры, сложность.
]

=== Глава «как устроен компьютер»

#solution("0b.1")[
Мак / WSL:

```
mkdir module-cabin
cd module-cabin
echo "станция МОДУЛЬ" > note.txt
pwd
ls
cat note.txt
```

Вторая строка в `note.txt` — ровно то, что напечатал `pwd` (например `/Users/ты/dev/module-cabin` или `/home/ты/module-cabin`). PowerShell: `New-Item`, `Get-Location`, `Get-Content`. Если путь «не там» — ты создал папку не оттуда, где стоял. Это и есть отгадка.
]

#solution("0b.2")[
Кладовая: файл `Hello.java` (и после `javac` — `Hello.class`). Стойка: байткод и переменные запущенного процесса `java`. Повар: CPU выполняет инструкции JVM. Иконка Run только просит шефа (ОС) запустить этот рецепт.
]

#solution("0b.3")[
Байты те же. Сломался договор, как их читать. UTF-8 кладёт русскую букву в два байта, Windows-1251 ждёт один байт на букву — поэтому глаз видит крякозябры. Вернул UTF-8 — слово снова `МОДУЛЬ`. Не перепечатывай крякозябры «как есть» в новый файл: тогда портить уже сами числа.
]

=== Бортовой журнал «МОДУЛЬ»

#solution("S.L1")[
```lisp
(defun ticks (n)
  (loop repeat n do (tick))
  *energy*)
```
Рекурсия: `(defun ticks (n) (if (<= n 0) *energy* (progn (tick) (ticks (- n 1)))))`. `clamp-energy` уже в `tick` — ниже нуля не уйдёшь.
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
        (format t "бросил ~a~%" item))
      (format t "в кармане нет ~a~%" item)))
```
Проверка: взять в реакторе, `walk` в коридор, `drop`, вернуться — в реакторе пусто.
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
В `look` коридора: если `*lamp*` равно `'ok` — другая строка про балласт. Иначе честный комментарий: бутафория.
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
`probe-file` — «есть ли банка». После починки щели `*fixed*` должен быть в plist, иначе загрузка забудет изоленту.
]

#solution("S.L6")[
Для пяти комнат честная таблица от `airlock`: corridor 1, galley 2, reactor 2, cupola 3. `Иначе` BFS/рекурсия с очередью. `airlock` → `cupola` не 1: люка нет, путь через коридор и камбуз.
]

#solution("S.L7")[
```lisp
(defun coffee ()
  (cond
    ((not (eq *here* 'galley)) 'wrong-room)
    ((< *energy* 4)
     (format t "пар. энергии ~a~%" *energy*)
     'steam)
    (t
     (setf *energy* (- *energy* 4))
     (if (member 'mug *pocket*)
         (format t "в кружку Щ. энергия ~a~%" *energy*)
         (format t "на пол. энергия ~a~%" *energy*))
     'sludge)))
```
]

=== Лаборатория Java

#solution("J.L1")[
Сначала яма: `nextInt` + `nextLine` → пустые скобки. Потом:

```java
int energy = Integer.parseInt(in.nextLine().trim());
String cmd = in.nextLine();
```

Комментарий: `nextInt` оставляет `конец строки` в stdin, его съест следующий `nextLine`.
]

#solution("J.L2")[
`split(" ")`, длина 3, `parseInt` в `try`. `energy`/`oxygen` 0..100, `temp` -20..40. Не число — сообщение, `continue`. Процесс не умирает.
]

#solution("J.L3")[
`Files.exists` — нет файла → дефолты и строка `no station.txt, using defaults`. На каждую строку свой `try` вокруг `parseInt`, битое — `System.err`, остальные ключи живут. Не один `catch (Exception e)` на весь load.
]

#solution("J.L4")[
```java
return "{\"energy\":" + e + ",\"oxygen\":" + o + ",\"temp\":" + t + "}";
```
Валидатор зелёный. Имя комнаты с `кавычкой` без экрана — красный. README: Jackson экранирует строки и вложенность, чтобы не собирать JSON конкатенацией.
]

#solution("J.L5")[
`HttpClient.send` GET `https://httpbin.org/get` — статус и `body.substring(0, Math.min(200, body.length()))`. Второй URL `/status/404` — напечатать 404, это не поломка клиента. Третий — `catch` , имя класса исключения + `getMessage()`.
]

#solution("J.L6")[
Три файла, состояние только в `Station`.

```
javac Station.java StationFile.java StationDash.java
java StationDash
```

README: эти команды + диалог `status` / `set energy 55` / `save` / `quit`.
]

#solution("26.J1")[
Две недели в календаре: даты писем, слот питча, слот трёх задач. Видно глазами, не «в голове».
]

#solution("26.L1")[
В день отказа — любой этюд станции, хоть `(ev '(+ 1 2))`. Скобки не знают HR.
]

=== Android

#solution("A.J1")[
Слушатели на `mul` и `div`. Если делитель 0 — `out.setText("нельзя")`, не `Infinity` и не краш.
]

#solution("A.J2")[
Пустое: `trim().isEmpty()` до parse. `NumberFormatException` поймать. README: пустое это ноль *или* надпись «введи числа».
]

#solution("A.J3")[
`Log.d` в `onCreate`/`onStart`/`onResume`/`onPause`/`onStop`. Home: pause+stop, возврат start+resume. Поворот: часто destroy+новый onCreate.
]

#solution("A.J4")[
`ArrayList` + `ArrayAdapter` + `ListView`. Три пальцевых задачи. README: «пока память». Скрин.
]

#solution("A.J5")[
`AboutActivity`, `Intent` + `putExtra("last", ...)`. На той стороне `getStringExtra`. Системная «назад» без своей магии.
]

#solution("A.J6")[
`onSaveInstanceState` / чтение в `onCreate` для двух полей. Recent убивает процесс — поля могут исчезнуть, это в README. Список — по желанию `SharedPreferences`.
]

#solution("A.J7")[
Поток не UI, GET health, URL `10.0.2.2` с эмулятора. Ошибка на экране, не краш. README: почему не localhost.
]

=== Макросы, CLOS, живой образ

#solution("M.L1")[
`macroexpand-1` на `(module-when test a b)` даёт `if` с `(progn a b)`. Без `progn` у `if` одна форма на ветку: `b` потеряется или станет «иначе».
]

#solution("M.L2")[
`with-energy`: `gensym` на стоимость, сравнение с `*energy*`, при нехватке `'too-low` без `decf`. При хватке — `decf`, потом тело. Два прогона: 10 против 15 и 20 против 15.
]

#solution("M.L3")[
`twice-wrong` подставляет аргумент дважды: два `tick`. `twice-right` — `let` + `gensym`, один побочный эффект. Смотри `macroexpand-1` обоих, не «ну вроде одинаково».
]

#solution("C.L1")[
`defclass module`, `make-instance`, `setf` через accessor, `module-status` — одна строка с именем и энергией.
]

#solution("C.L2")[
`antenna` наследник `module`. Свой `defmethod module-status`. `(mapcar #'module-status (list reactor dish))` — две разные строки.
]

#solution("C.L3")[
`:around` + `call-next-method`, при энергии 0 дописать ` ALARM`. Один обходчик на всех, не два одинаковых `if`.
]

#solution("C.L4")[
Класс `station`, слот список модулей, `station-report` = `mapcar #'module-status`. Два разных класса в списке.
]

#solution("C.L5")[
`(defclass comm-antenna (module powered radio) ())`, `typep` на всех троих — `t`. Слоты с обеих сторон читаются. В Java двух классов-родителей со слотами нет, только один `extends`.
]

#solution("C.L6")[
`class-precedence-list` до и после смены порядка в `defclass`. Имена в CPL едут. Это не баг, это рычаг.
]

#solution("I.L1")[
Без `(quit)`: старый `defmethod`, вызов, новый `defmethod`, вызов на том же экземпляре. Данные те же, строка статуса другая. Если помог только новый `make-instance` — образ ты убил.
]
