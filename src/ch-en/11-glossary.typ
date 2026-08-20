#import "../lib-en.typ": *

= Station glossary

Not Wikipedia. Wikipedia explains as if you already know the neighboring thirty words. Here — like a mechanic in the corridor: one joke so you don't fall asleep, and one explanation you can *use*.

The words are English because they are English. Translating `null` as "nothing" is allowed once, in your soul. In code and in interviews it's still `null`.

Flip here when you need it. Memorizing from Monday is a bad quest.

== REPL

Read-Eval-Print Loop: read, compute, print, wait again. A parrot with a calculator.

In practice: SBCL's black window with a star `*`. You type a form, hit Enter, see the answer. Not "run the project." A conversation. If you didn't touch it with your hands — you read about Lisp, you didn't do Lisp.

== JDK

Java Development Kit. The box that holds the stove *and* the translator.

`java` runs what's already cooked. `javac` compiles the source. Without a JDK you sometimes only have `java` (JRE / some runtime) — you can run other people's stuff, you can't build your own. This book wants 21. Not "whatever the app store had."

== JVM

Java Virtual Machine. The stove the bytecode runs on. Not your OS, another layer: "we'll pretend to be the same machine on a Mac, Windows, and a server."

That's why a `.class` is not "a Windows program." That's why OutOfMemory is about *this* stove's memory, not always the disk. That's why "it's one thing in IDEA, another in the terminal" often means: two JVMs, different ones.

== class

A blueprint of a thing. Not the thing itself.

`class Task` says: a task will have an id, a title, a flag. `new Task(...)` — already a gadget in memory. The file is usually named after the blueprint: `Task.java`. Java loves that. The station also likes labels on the crates.

== method

A verb on a thing. "What it can do."

`complete()` on a task, `add(...)` on the store. `main` is a special method: the JVM enters here, like the main hatch. A function in Lisp is a relative in spirit, just without the `public static` paperwork.

== HTTP

The language of letters between a browser (or your `curl`) and a server. Not "the whole internet." The internet is a corridor. HTTP is the form: method, path, headers, body.

GET — "show me." POST — "accept this new thing." 200 — ok. 404 — no such door. 500 — there's a fire in their kitchen. Until you learn the form, Spring will look like button magic.

== JSON

Text pretending to be data: `{"energy": 80, "room": "reactor"}`. Curly — object, square — list. Quotes on keys are mandatory, unlike your mood.

This is not a database. This is an envelope. The database lives at their place, JSON rides over HTTP. Break a comma — "their machine" will say "couldn't chew that," and it will be right.

== Git

Not GitHub. Git is a diary of folders on your disk: what changed, when, why. GitHub is a locker on the internet where that diary also gets put.

Without Git you have "final version" and "final2_for_real." Stations don't fly like that. `git status` — look at your feet. Do that more often than `git commit`.

== commit

A snapshot: "the folder looked like this, here's a message about why." Not saving a file. The editor saves the file. A commit is a mark you can come back to.

Write the message for a human in six months. `week4: save tasks` beats `asdf`. A commit doesn't have to be pretty. It has to exist.

== SQL

The language for talking to tables. `SELECT` — give me rows. `INSERT` — put this in. `UPDATE` / `DELETE` — as they sound, just without "well, almost all of them."

This is not Java. This is a separate warehouse dialect. Spring hides it until it hides it badly — then you open a Postgres console anyway and write `SELECT` by hand. Better to know how before that day.

== JOIN

Glue rows of two tables by a key. Tasks plus people's names, compartments plus sensors.

Without JOIN a beginner makes two queries and glues them in their head. With JOIN the database glues them, that's what it's for. Forget the join condition — you get a Cartesian product: every task with every person, a party, then disk space weeps.

== index

A table of contents for a column. "Where are all tasks of user 42" without reading the whole table with a flashlight.

An index takes space and slows writes a little: you have to update the table *and* the table of contents. On three rows you don't need it. On three million — you very much do. `EXPLAIN` will show whether they use it. Guessing by vibes — no.

== transaction

"All or nothing." Drain energy from the reactor *and* turn on the antenna. If the second falls over — the first must not stay half-done.

`@Transactional` on a service — "this work is one mash." Not speed magic. Honesty magic. Two Save buttons without a transaction — a way to get a station that doesn't exist in nature: money taken, ticket not issued.

== bean

An object Spring manages: created it, handed it to others in a constructor, often one for everybody.

Not a coffee bean. Not the coffee joke, though everyone makes it, including me. If you wrote `new` on a service yourself — that isn't a bean, that's you. The container then shrugs.

== controller

A thin door from the street. HTTP arrives here. Further — not here.

The controller translates a letter into a service call and back into JSON. If there's SQL in the controller — the station is looking at you. If the business rule "no empty name" lives only in the controller — someone will call the service around it, and the name will be empty.

== service

The station's rules. May we dock, is there enough energy, is the task a duplicate.

Meaning goes here. The transaction goes here. Tests without the web live here. If there's no service and everything is in the controller — you don't have architecture, you have one big `main` with annotations.

== repository

The door into the database. "Put a task," "give me a task by id." Not "decide whether the user is allowed."

A JPA repository often looks like an interface with no body — Spring writes the implementation. That's convenient until it's too convenient: then you write the query yourself and remember SQL without shame.

== Docker

A way to say: "run this same kitchen at your place, not only at mine." Not a virtual machine with Windows inside (though that lives nearby). A box with a process and its jars.

"Works on my machine" is cured not by a meme but by a Dockerfile and `compose`. The first time will hurt. The second — less. On Windows go straight to WSL2, or the pain is eternal.

== image

A snapshot of the kitchen: which jars to put in, which recipe to run. A file (almost) you can download.

An image doesn't run. It sits. `postgres:16` — someone else's database image. Your app image — "JDK + my jar + how to start." Pin image versions. `latest` is a 3 a.m. surprise.

== container

A running image. Mash on the stove from that snapshot.

You can kill a container — the mash is gone. Data you care about goes in a volume, or Postgres inside the container will forget the tasks along with you. Two containers from one image — two mashes, not one.

== cache

A cheat sheet next to the counter: "we already computed this recently." Fast. Lies if you forget to throw it out.

A cache without invalidation is a sensor showing yesterday's air. `@Cacheable` is pretty. `delete` on update is mandatory. Otherwise the demo: "I changed it, the site didn't." The site is honest. The cheat sheet is old.

== queue

A queue of work: you put a message, someone takes it later. Not "do it now in this same request."

The letter "task created" can wait. The user already got 200. Another cook will handle the letter. If that cook died — the letter must *stay*, not dissolve. Otherwise the queue is theater.

== Kafka

A queue that is also a log: messages are remembered, you can reread them from a place.

Not a junior's first tool. Not proof of adulthood. On a résumé with no code of your own — a red rag. In this book it shows up late and for a reason: "lots of events, we don't want to lose them." If the work fits one monolith — live without Kafka, the station will survive.

== stack trace

A bedsheet of "who called whom when it fell over." Read *bottom up* or top down — whichever helps, but *your first understandable line* matters more than Spring's guts.

This is not a cipher. This is a map of corridors at the moment of a fire. The line number is a gift. If there isn't one, you're looking at the wrong build. Don't fear the length. Fear an empty `catch`.

== null

"There is no box." Not zero. Not an empty string. No crate.

In Java `null` bites: `NullPointerException` — you asked a method of an absence. In Lisp the relative in spirit is `nil`, but with a different temperament. In an interview "what is null" is not a joke. Say: a reference to nowhere. Then say how you keep from bringing it into the service without need.

== exception

A way to shout "you can't do that" instead of lying quietly.

`throw` — the shout. `try/catch` — you heard it. Catch the specific one. An empty `catch` — duct-taping the siren. Checked in Java (`IOException`) — a snitch compiler: admit that the disk is sometimes against you. Annoying. Useful.

== recursive

A function calls itself on a *smaller* piece. You clean the corridor: this compartment, then the rest.

Without a stop (`null` list, `n == 0`) — `Control stack exhausted` / `StackOverflowError`. Not mysticism. Nested dolls with no last doll. Recursion isn't "for smart people." Recursion is for lists and trees until it clicks. Then you can `loop`.

== cons

Glue a head and a tail. The main list constructor in Lisp. `(cons 'airlock '(corridor))` → `(AIRLOCK CORRIDOR)`.

Looks like a typo in granddad textbooks. It isn't a typo. A list is a chain of cons. Understand cons — understand why `rest` is cheap and "append at the end" in the obvious way isn't.

== symbol

A tag. A name. In Lisp `'reactor` is not the string `"reactor"`. Strings compare one way, tags another.

A symbol is a word of the language. A variable, a function, just a label in a list of compartments. The apostrophe: "don't evaluate, put it as is." Without the apostrophe Lisp will try to *call* `reactor` and get offended if it isn't a function.

== t

Yes. Truth. "In all other cases" in `cond`.

Not the number 1. Not the string `"true"`. In Lisp just `t`. You don't write `truth` in the code. You don't have to write `true` either — that's from the neighboring language. Here it's `t`.

== nil

No. The empty list. "Nothing." One actor, two roles, and everyone's fine with it.

`(if nil ...)` won't enter. `(rest '())` gives `nil`. Falsehood and emptiness met in the airlock and didn't argue. Java can't do that: there `false`, `null`, and an empty `List` are three different citizens.

== Maven

The Java project builder: dependencies, tests, packaging. The ritual file `pom.xml`.

`./mvnw test` — "install what's written, run the tests." The wrapper (`mvnw`) goes in the repo so a neighbor has the same Maven version. No need to "download Maven separately and configure it like a priest." On Windows without WSL — `mvnw.cmd`.

== Flyway

Database migrations: files `V1__tasks.sql`, `V2__idx.sql`. A history of the schema, not "tweaked by hand in prod."

Order matters. Once applied — don't edit the old file as if nobody saw. They saw. The database saw. A new file — a new number. It's boring and it saves stations.

== JPA

The contract "class ↔ table." Fields — columns. `save` — almost INSERT/UPDATE.

Hibernate is often under the hood. `@Entity` — "this is a table row, not just a POJO in a vacuum." Convenient until N+1 arrives. Then you remember there's SQL under the blanket, and that's fine, not cheating.

== equals

"Is this the same task in meaning?", not "is this the same crate in memory?"

`==` for objects in Java — "the same address on the counter." `equals` — "we count them equal." For strings almost always `equals`. Forget — a bug in the interview and in prod. A record often gives `equals` itself. Your own class — write it, or live with the pain.

== thread

A thread of execution. Several cooks in one program.

By default your `main` is one thread. A web server — many: per request. Two threads wreck one counter without `synchronized` / a proper queue — a race. Don't start with "parallelism for the résumé." Start when one cook can't keep up, and measure.

== port

A door on the machine. A number. 443 — https, 8080 — the teaching server, 5432 — Postgres.

Two processes don't share one door: "port already in use." Means the old server is alive or Slack took it. `localhost:8080` — this machine, this door. Not "a site in the cloud." A door.

== localhost

Yourself. `127.0.0.1`. The kitchen, not the street.

A browser on `localhost` doesn't go "to the internet," it knocks on a process in this same box. In WSL sometimes "Windows localhost" and "Ubuntu localhost" are two kitchens with a hole between them. If the database "isn't visible," check *whose* door it is.

== API

A contract: how to call someone else's program. Often HTTP+JSON, not always.

"There's an API" means: you can do it by letter, not only by mouse. Your Spring controller *is* an API. Someone else's httpbin — also. API docs — which doors, which letters, which answers. Without them you're an archaeologist.

== REST

A style of HTTP API: resources, verbs, statuses. `/tasks/3` — task 3. GET — read. PUT/PATCH — change.

Not a religion. Not "microservices required." On job posts the word means: "you can do CRUD without inventing your own Skype." If the argument "is this real REST" lasts an hour — go write a working GET.

== bytecode

What `javac` chews `.java` into. A `.class` file. Not machine code of your CPU, a JVM dialect.

That's why one Java program runs on different OSes — the stove looks different outside, inside the bytecode is the same. You don't need to look at bytecode every day. You do need to know the green button produces it.

== annotation

A label over code: `@Override`, `@RestController`, `@Test`. The compiler or the framework reads the label and behaves differently.

This is not a comment. People lie in comments. A tool eats the annotation. An extra `@Transactional` on a `private` method is a label that *won't work*, like a "wet floor" sign on a dry floor. Read where you stick it.

== DTO

Data Transfer Object. A box of "here's what we give to the street," not necessarily the whole entity from the database.

So the JSON doesn't leak a `passwordHash` field. So you don't drag a lazy association and catch a lazy fire. A boring word. An adult habit. Early on you can return the entity — then you burn yourself, and the glossary suddenly feels like home.

== IDE

An editor that also compiles, debugs, suggests. IntelliJ is ours. VS Code too, just install the Java plugins.

Not a compiler. Not Git. Not a substitute for a head. The Run button inside calls the same `javac`/`java`, only without your `pwd`. Once a week run from the terminal, so you remember.

== PATH

The list of folders where the system looks for programs when you type `javac` without a full path.

"Command not found" often means: the jar is there, it isn't in the corridor's PATH. Installed a JDK — set PATH or close and reopen the terminal. On WSL and on a Mac this is ordinary first-day pain, not a sentence.

== stdin / stdout

Standard input and output. Keyboard and screen by default.

`Scanner(System.in)` reads stdin. `System.out.println` writes stdout. You can swap in a file: `java Energy < input.txt`. Errors often go separately: stderr. So "the output vanished" sometimes means: you're looking at the wrong stream.

== hash

A fingerprint of data. Same input — same fingerprint. Change a little — a different one.

`HashMap` looks up by the key's fingerprint, so the key must equal properly (`equals` + `hashCode`). Passwords in a database aren't stored in the open — you store a hash (better: a special, slow one). `sxhash` in teaching Lisp is a toy, not a safe.

== N+1

First one query "give me the list," then a query *per* item. A hundred tasks — a hundred and one trips to the database.

On three rows you don't see it. In prod you do. Cured by JOIN / `join fetch` / not poking associations in a loop. If the SQL log looks like a machine gun — you saw N+1. Congratulations. Now it has a name.

== garbage collector

The garbage collector. The JVM (and SBCL too) throws away jars nobody points at anymore.

You don't `free` every object. That doesn't mean "memory is infinite." A leak in Java is holding a list of references to everything you ever saw. GC is honest: it doesn't touch what you can still reach.

== endpoint

An API door: method + path. `GET /tasks`. `POST /tasks`.

Not "the whole server." One handle. In Postman / curl you pull an endpoint. In a controller one method often = one endpoint. If the handle does five different jobs depending on a parameter's mood — that isn't a door, that's an attic.

== entity

An object that *lives in the database*. A table row as a class.

Not every class is an entity. `Task` with `@Entity` — yes. `EnergyReport`, which you assembled from three tables only to return JSON — more of a DTO. Mix them up — you'll get a weird `save` and weird JSON.

== primary key

The main key of a row. Usually `id`. Unique. JOIN goes by it, "give me task 3" goes by it.

Not the task title: titles repeat. Not "the number in the list on screen": the list lies after a sort. A real id. The station hasn't argued with this in sixty years.

== foreign key

A pointer to someone else's primary key. On a task — `project_id`. "This row is about that project."

The database can watch that the project exists. That's a constraint, not a whim. Without it you get tasks of ghost projects. With it — an error on insert, and that's a gift.

== log

A process diary: lines during its life. Not `print` for yourself in `main`, but proper levels: info, warn, error.

Logs are read when it already hurts. Write so future you understands *which id* and *what you wanted*. Don't write passwords. Don't write personal data "for debugging." The station records energy, not the crew's correspondence.

== pom.xml

The Maven project's passport. Coordinates, Java version, dependencies, plugins.

XML is mean about spaces in your soul; in fact it's just wordy. Don't copy someone else's `pom` whole "just in case." Every dependency is someone else's code on your station. Sometimes needed. Sometimes a transitive circus.

== Spring

A frame you hang web, beans, database access on. Boot — "the frame already has batteries, hit Run."

Not a language. Not a Java replacement. A layer of convenience and surprises. Until you can assemble a class, a list, and a file without Spring — too early. When you can — Spring saves weeks. When you can't — it saves understanding.

== constructor

The method that builds the thing on `new`. Same name as the class. Without one Java still gives you an empty one if you didn't write another — and then fields will be zeros and `null`.

Station joke: the constructor is the only moment you can honestly say "you aren't born without an id." After that setters start lying.

== static

"Belongs to the blueprint, not one gadget." `main` is static because the JVM hasn't done `new` of your class yet, and it still has to enter.

Abuse `static` on everything — you have globals with stars again, only without the stars. Sometimes you need it. Often it's laziness.

== package

A corridor of names. `com.module.tasks`. So two `Task` classes don't fight. First line of the file. The folder on disk must match, or Java gets offended like a storekeeper.

Not a religion of "how big companies do it." Just don't put a hundred classes in the root with no sign.

== import

"Take the blueprint from that corridor." Not copy-paste of code. Not "download from the internet." Without import — write the full name, like an address with a zip code.

A star `import java.util.*` works. Then in the IDE you can't see where `List` came from. For study, explicit imports are better.

== boolean

Yes/no. `true` / `false`. Not `t` and not `nil`. Not 1 and 0, though other languages lie that it's the same.

`if (energy)` in Java won't fly if `energy` is an `int`. The storekeeper wants an explicit question. Sometimes annoying. Less often lying.

== String

Text. An object, not "an array of letters you solder yourself," though inside it's almost that.

Gluing with `+` is convenient and sometimes shameful for speed. For a dashboard it's enough. `equals` for comparison, we already said that. Quotes only double: `'a'` in Java is a character, not a string.

== int

An integer in a fixed-size box. Division `7 / 2` gives `3`. The fraction went out the airlock with no siren.

For an average write `3.0` or `double`. For money at work — not `double`, but that's not the first month, thank goodness.

== array / list

An array — a crate of N slots, N decided at birth. `ArrayList` — a crate that can add more.

Indices from zero. People from one. The translator is you. `IndexOutOfBounds` is a gift: there is no slot, not "the element is null."

== 404 / 500

404 — no door. 500 — there is a door, fire behind it.

Mixing them up is embarrassing in an interview and in logs. Sometimes you lie 404 to a client instead of 403, so you don't advertise that the secret exists. That's policy, not HTTP romance.

== cookie / session / JWT

Ways to remember who you are between letters. HTTP itself is forgetful, like a CPU with no RAM.

Cookie — a note in the browser. Session — a note on the server plus a number. JWT — a note the server signed and handed you to carry. For the glossary: *not a login on every click*. Details — when you get to Spring Security. Not sooner, please.

== curl

A terminal browser with no pictures. `curl URL` — send GET, print the body.

Flags later: `-i` headers, `-X POST`, `-d` body. If you can curl, you can check an API without Postman. Postman is prettier. curl shows up on a server with no mouse.

== WSL

Windows Subsystem for Linux. Ubuntu often lives *inside* Windows. Not a second Windows in a window and not "install Linux instead." A Linux terminal and files next door, with a hole to the outside.

This book on Windows lives here: `sbcl`, `javac`, `./mvnw` — in WSL, not in CMD. The Windows disk sticks out as `/mnt/c/`. You can. File permissions there are clowns. Put study code in the Ubuntu home directory, `~/dev/...`. If "I see it in Explorer, not in WSL" — you're looking at *two* kitchens. PATH is two as well: the one in PowerShell doesn't feed the station.

== SDK

Software Development Kit. A box to *build* software for a platform: compiler, libraries, docs, sometimes an emulator.

The JDK is an SDK for Java. The Android SDK — for the phone. A runtime (`java` without `javac`) is a stove with no welder: you can run other people's, you can't cook your own. An IDE is not an SDK. An IDE is a workshop that *calls* the SDK. On a job post "experience with SDK" often means: you installed the box and built something, not just opened an editor.

== JAR

Java ARchive. Almost a zip: `.class`, resources, a manifest. Extension `.jar`.

`java -jar app.jar` — run the cooked thing as a program. Maven `package` puts that file in `target/`. What goes to the server is a jar, not a folder of `.java`. You can unzip a jar like a zip to look. Patching `.class` with a hex editor is circus. You patch the source, then `package` again.

== classpath

The list of places the JVM looks for classes and jars *when the program is already running*.

`ClassNotFoundException` often means: the file is on disk, it isn't in the classpath corridor. In the IDE the green button builds the classpath itself. In the terminal `java -cp lib/*:classes Main` — that's you. Maven stuffs dependencies into that list, so `./mvnw exec` and a "bare" `java` behave differently. Until that clicks, the phrase "it works in IDEA" will visit once a week, like a leak in the reactor.

== new

The operator "make a gadget from the blueprint." `new Task()` — an object in memory, you're the owner.

Nearby: bean. Spring creates the service *itself* and hands it to the constructor. If in the controller you wrote `new TaskService()` — that isn't a bean, that's a second parallel station in your pocket. Tests lie, the transaction is the wrong one, the database is another. Rule: `new` for your own data (`Task`, `ArrayList`, DTO). For a service and a repository — the container. That's the whole bean vs `new` difference, not a philosophy of coffee beans.

== migration

A script "the database schema became different." A file with a number. Flyway or Liquibase apply it *once* and remember it in a bookkeeping table.

This is not `UPDATE` by hand in prod. Prod already chewed V3, and you tweaked V1 — locally "it'll do," for the team it's hell. A new file — a new number. Rollback is often another migration that fixes, not a time machine. A replica reads the same history. Otherwise the nodes drift, and that's no longer a duct-tape joke.

== replica

A copy of a database (or a service): so you can read from several counters and not die alone.

You usually write to the primary / leader. You sometimes read from a replica. Physics joke: the copy lags a second, and `GET` "doesn't see" the row you just saved. That's replication lag, not a bug in your `save`. On the teaching station one Postgres — you don't need a replica. In an interview the word means "a copy," not "a second Docker for the résumé."

== offset

A bookmark in a Kafka log: "I've read up to here." A number. Not a task id and not a row number in SQL.

The consumer moves the offset when it has processed. Move it early — you lost the message for yourself. Don't move it — after a restart you'll eat it again. That's why "at least once" and idempotence come as a pair. Until there's Kafka — picture a bookmark in the station log: page 47, not "somewhere about duct tape."

== consumer group

Several Kafka eaters that share *one* log so that one message inside the group is eaten by *one*.

Two groups — two independent readings: both the dashboard and billing can eat the same event. Two eaters *in one* group — they split partitions, not the work. The group name is part of the contract: change the string — different offsets, "as if you'd read nothing." Debugging starts with "which group?", not with restarting the broker in a panic.

== CI

Continuous Integration. A robot runs tests on every push or PR, not "it's green on my laptop."

GitHub Actions, GitLab CI, Jenkins — different kitchens, one idea: a fresh clone, `./mvnw test`, a check or a cross. CI red, yours green — *someone's* kitchen is lying. Often: a file not in git, a different JDK version, a test that looks at the clock. Cured not by the "Run again" button. Cured by the robot's log. CD (delivery/deploy) is the neighbor: also *ship it*. First learn so the robot can say "tests failed."

== linter

A program that nags about style and dumb errors *before* a run.

Not a compiler. The compiler says "this isn't Java." The linter says "this is Java, but `==` on strings, and a variable is hanging." Checkstyle, SpotBugs, ESLint in the neighboring world. Rules live in the repo, not in "it's yellow in my IDE." Turn the whole linter off — duct-tape on the siren. One rule is dumb — turn *that one* off. A formatter (spaces, line breaks) is a relative, not an enemy. "Tabs vs spaces" fights are cured by a file in the repo, not a chat until morning.

== PR

Pull Request. In GitLab more often Merge Request. A request: "take my branch into the shared one."

Not a commit. A PR can have a pile of commits. There's a diff, a description, a CI bot, people's comments. A small PR is easier to look at. A PR of three thousand lines "I did everything" — nobody reads it, they merge from fatigue, then hunt the fire. For study: a PR to yourself also teaches writing "what and why," not only code. Review — a human looks at the diff. Not a trial. Not "find ten nits."

== rebase

Lay your commits on top of a fresh `main`, as if you started today.

History becomes a straight line. `merge` makes a knot: "two lines met here." Rebase lies elegantly. Don't rebase a branch other people are already pulling: you'll rewrite history under their feet. Your own study branch before a PR — you can. If you're scared — `merge`. The station won't fail you for missing zen. `git rebase -i` in week one is a way to break the watch and learn `reflog` sooner than you wanted.

== conflict

Two changes in *one* place. Git doesn't know whose line is holy.

Markers `<<<<<<<`, `=======`, `>>>>>>>` are not a ruined file, they're a form. Remove the form, keep the meaning, `git add`. A conflict is not "Git broke." A conflict is two mechanics turning one valve. Cured by reading *both* chunks, not the "take all left" button. After — build and run tests. Otherwise you'll merge a station that doesn't compile, but the history is "clean."

== 8080

The teaching web-server port. Not 80: that's often taken and wants admin rights. Not 443: that's https in prod.

`localhost:8080` — the browser knocks on *this* machine, *this* door. "Connection refused" — no process behind the door. "Already in use" — there is a process, a second one won't fit. Kill the old one or change the port. 8081 in someone else's guide is not a sacred number, it's another door when 8080 is taken. localhost — see above: the kitchen, not orbit.

== CORS

Cross-Origin Resource Sharing. The browser won't let a site from one address pull an API from another until the server says "you may."

This is protection of *the user in the browser*, not a cipher and not "the backend broke." `curl` does not obey CORS: curl is not a browser. So "200 in curl, red on the front" is often CORS. Until there's a separate front on another port, you don't have to fix it. When there is — a header on the *server*. An extension "turn off browser security" is not a profession, it's duct tape on the siren.

== lazy

"Don't touch it yet." In JPA an association is loaded when you touch the field, not at the first `SELECT`.

Convenient while the database session is alive. Session closed, you poked `task.getProject()` — `LazyInitializationException`. Station classic. Cured not by "put EAGER on everything" (hello, N+1 and a JOIN half a screen wide). Cured: fetch what you need while the repository is still in a transaction; or a DTO; or an explicit fetch. Laziness is not a lazy programmer. It's *when* to go to the database.

== eager

"Bring it now." The association loads with the entity.

On one task with one project — fine. On a list of a hundred tasks, each with comments, comments with authors — a tree of SQL. Eager as duct tape on every pipe: it holds until you can't breathe. For many `@ManyToOne` the default is eager, and you're already paying without seeing the bill. Look at the SQL log. A machine gun — the phenomenon has names: N+1, lazy, eager. Primary key and foreign key have nothing to do with it: the association *exists*. The argument is only *when* to fetch it.

== NULL

In SQL: "there is no value." Not zero. Not an empty string. A separate beast.

`WHERE energy = NULL` will *not* find rows with empty energy. You need `IS NULL`. Comparison with NULL gives UNKNOWN, not true — so `AND`/`OR` float differently than in Java. In Java `null` is "there is no reference." Similar letters, different ritual. `Integer energy` can be `null` (the box is empty). `int energy` — no, there's always a number; forgot to initialize — zero, and that's already a lie, as if "the sensor showed zero." JDBC: `wasNull()`, or zero and NULL glue into one mash. Turn the reactor off with a zero, thinking you turned it off with an absence — that's a Щ plot.

== schema

A blueprint of tables: columns, types, primary key, foreign key, constraints.

Data — rows. Schema — the rules of the shelves. A migration changes the schema. `SELECT` without a schema is archaeology. In Postgres the word is also a namespace inside the database (`public`). In month one: "how the tables are built," not three meanings from the docs. Draw the tables on paper. Paper lies less than "there's an entity in there."

== environment variable

An environment variable. A label on the *process's* door: `DATABASE_URL`, `JAVA_HOME`.

Not a class field. Not a global with stars. The OS (or Docker, or CI) puts a string, the program reads it. Passwords in `application.properties` in git — a bad joke. Passwords in env — ordinary adult. `echo $PATH` — you've already looked at env. "Works at the neighbor's" — compare env, not only code. The code is the same. The doors are different.

== working directory

The folder *from which* relative paths are counted. `station.txt` with no path — "where the process stood up."

Not the source folder. Not the repo root, unless you chose it. `pwd` in the terminal. Working directory in IDEA. WSL vs Windows Explorer. Three different "here." A save "vanished" — almost always this. Print the absolute path once. Then argue with configuration, not with ghosts.

== branch

A branch. A parallel line of commits. `main` — the shared one. `week4-save` — your sandbox.

`git switch` doesn't copy the folder by magic: it rearranges files under that line. Uncommitted stuff may ride with you or get in the way. A branch is cheap. Fearing it is like fearing a second mug. Fearing uncommitted mash on two branches at once — healthy. `origin` is someone else's locker (often GitHub), not a holy synonym of a branch.

== 0.0.0.0

"Listen on all interfaces of this machine," not only on localhost.

A server on `127.0.0.1` is visible to itself. On `0.0.0.0:8080` — also from a phone on the same Wi‑Fi, if the firewall lets it. A beginner opens "on all" and thinks that's the internet. That's a kitchen with a window onto the stairwell, not orbit. For study, localhost is enough. `0.0.0.0` — when you really need it from another box.

== override

`@Override` — "I'm replacing an ancestor's method," not a new method with a similar name.

Without the annotation a typo in the name gives a *new* method, and the one you thought you were overriding stays old. The compiler is silent. The annotation complains. Stick it always. That's a siren on a typo in `equals` / `hashCode` / `toString`, not bureaucracy. Overload is the neighbor: same name, *different* arguments. Mixing overload and override in an interview is a classic, like `==` on strings.

== interface

A contract: "you can do these methods," with no story of *how*.

`List` is an interface. `ArrayList` is one implementation, `LinkedList` another. In the variable's type write `List` unless you have a reason to stick. Spring loves repository interfaces: the container will slip in a body. In month one an interface is a socket, not "hexagonal architecture." Understood the socket — the hexagon can wait.

== 401 / 403

401 — you didn't introduce yourself (or the ticket wasn't accepted). 403 — you introduced yourself, you can't go here.

Mixing them with 404 is embarrassing in a different way: 404 no door, 403 there is a door, security is against you. Your API: don't smear everything 500. 400 — the client wrote it crooked. 500 — you. The client should understand *whose* problem it is, without reading your soul.

== volume

A Docker volume: a folder that survives the container's death.

Postgres without a volume forgets tables when the container dies. A volume is a pantry *next door*, not inside a disposable mash. For study: one named volume for the database. `compose down -v` will take the volume with the container — the `-v` flag here is not "verbose," it's "remove the pantry." Read twice, then press.

== healthcheck

The door "am I alive?" Often `GET /health` or `/actuator/health`.

The orchestrator knocks here, not on the home page. Health green, responses 500 — you checked the wrong thing. If health goes to the database, a Postgres fall becomes "the whole service is dead" in the robot's eyes. Sometimes that's honest. For the station dashboard, health is a `status` command with energy. Same instinct, just without an orchestrator.

== timeout

How long to wait before saying "the door is silent." Network, database, `HttpClient`.

Without a timeout the request hangs until the OS gets bored. Too short — a live database looks dead at rush hour. For study ten seconds on httpbin is fine. In prod the number comes from measurement, not from "a thousand, to be sure." Retry without a timeout — a way to hit someone who's already down, again.

== idempotent

The same request twice gives the same *meaning*, not necessarily the same byte in the log.

GET is usually idempotent: "show task 3" ten times. POST "create a task" twice — two tasks, if you don't watch. Kafka at least once + a non-idempotent handler — duplicates in the database. On the station: `tape-leak` a second time must not spend a second roll of duct tape you no longer have. That's the word.

== prepared statement

SQL with holes for values the driver will put in *as data*, not as query text.

`WHERE name = ?` plus a parameter — a name with a quote won't become a second query. Gluing `'... ' + userInput` is SQL injection, a classic, the station opening the airlock to a stranger. On JPA `save` this is hidden. Hand-rolled JDBC — not hidden. Even a teaching `SELECT` is better with `?` than with concatenation "it's my own number though."

== record

A short class "just data": fields, constructor, `equals`, `hashCode`, `toString` — Java writes them itself.

Handy for a DTO. Not an entity: JPA likes an empty constructor and setters, a record argues with that. Not a replacement for everything. If you catch yourself on an eight-line class with three fields and a hand-written `equals` — record. If you catch yourself on "I'll add some behavior" — an ordinary class, don't be a hero.

== CLOS

Common Lisp's object system: classes with slots, verbs on the outside (`defgeneric` / `defmethod`), several parents at once. Java still gives you one `extends`. Not "Java in parentheses." A different center: first the action, then the gadget's passport.

== macro

Code that writes code. Gets forms, returns a form. `macroexpand-1` is an X-ray. A function you're "just too lazy to name" is not a macro. If an argument with a side effect got substituted twice — you wrote `twice-wrong`.

== live image

A Lisp process where you can redefine a method without killing the data. That's how they patched Remote Agent on Deep Space 1. Gradle can't do that, and it isn't Gradle's fault: nobody invited it onto the probe.

If a word isn't in this glossary — no harm. Often it's either the name of someone else's library (google "what beast is this") or job-post marketing. First ask: *which sensor on the station does this fix?* If none — you don't have to learn it this week.
