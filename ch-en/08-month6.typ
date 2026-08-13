#import "../lib-en.typ": *

= Month 6. Out into open space, meaning the market

Almost no new sacred technologies. There is a product, and there are emails to strangers. Forty minutes of Lisp stay: when they reject you (they will), the parentheses still listen, unlike HR.

This is a strange month. You already know more than it feels like at 2 a.m. The market doesn't know that until you write a README so a stranger gets, in a minute and a half, *what to open*, and until you send a letter that has truth in it, not "stress-resistant." Station MODULE has nothing to do with this. The calendar and your voice do.

#rule[
  The measure of the month is slots on the calendar and letters sent, not a new chapter on Kubernetes. Kubernetes can wait. HR will not wait for "just a little more Kafka": they'll just take someone else whose README opens.
]

#lesson(21, [README as a porthole, not as an attic])

The person on the other side looks for a minute and a half. Sometimes forty seconds. They don't read your inner monologue about "I'll finish it later." They look at the top of the screen. If it's empty, or "task manager on spring boot" with no verb, or a wall of emoji — they close the tab. Like a porthole smeared from the inside: from outside it looks like there is no station.

The order that works:

1. README `task-manager`: what it does, a curl or a screenshot, how to run it on a Mac *and* on Windows/WSL, what it's made of.
2. The repo has no `.env` with secrets and no `target/` folder.
3. Commits are not `asdf`.
4. Let `java-basics` live — that's a path, not a shame. Shame is pretending Hello never happened.

Résumé: one page. Stack, two projects with links, how to reach you. Courses at the bottom or not at all. Lisp — under "also."

=== The black box you have to drag into the sun

Open your README now, before edits. Time one minute. Pretend you're a classmate on Windows, Docker Desktop installed yesterday, a different IDEA. What breaks first?

Usually:

- no run command, just "open the project";
- Postgres is "you know, the usual";
- curl only for GET, and login is silence;
- Java 17 in the text, 21 in the `pom`, or the other way around;
- a screenshot from 2024, the endpoints have moved since.

That isn't shame. That's an attic. Everybody has an attic. You wipe a porthole with a rag, not with self-esteem.

=== Sample README (steal the structure, not the biography)

Below is a *teaching* text. Put in your URLs, your endpoints, your study-database password. If you have JWT — show two curls: registration and "the list with your token." If you have a session — show the cookie. Don't write "etc." "Etc." in an interview means "I didn't check."

```
# task-manager

Personal tasks over HTTP. Not a tracker for a million people — a study
monolith you can poke CRUD, login, and tests on.

## What it does

- registration and login (JWT)
- your tasks: create / list / update / delete
- list with pagination
- list cache in Redis for 30 seconds, drop on write

## Run (Docker)

You need Docker Desktop (Mac or Windows+WSL2) and free
ports 8080, 5432, 6379.

    docker compose up --build

Check:

    curl -s localhost:8080/health

Then registration, login, POST /tasks. Examples below.

## Run without Docker (cabin)

JDK 21, PostgreSQL 16, Redis 7. Create a database `taskdb`.
Copy `application-example.yml` → `application.yml`
(local password, don't put the file in git).

    ./mvnw spring-boot:run          # Mac, WSL
    mvnw.cmd spring-boot:run        # Windows

## Stack

Java 21, Spring Boot, PostgreSQL, Flyway, Redis, JUnit.

## What isn't here (so we don't lie)

Kafka is not running in production. The notification queue is an event
inside the monolith and a log. There is no cluster. That's fine.
```

A Postman screenshot or a curl screenshot is a plus, not a requirement. The requirement is that a classmate *without you in chat* sees health `UP`.

#os[
  Two columns of commands in the README aren't aesthetics, they're survival. Mac and WSL: `./mvnw`, backslash in a multiline curl. Windows cmd: `mvnw.cmd`, `^`. PowerShell is often easier as one line. Write "if curl screams — go into Ubuntu (WSL) and hit it from there, the server on localhost is shared." That one sentence saves an hour of someone else's life and your evening of "well it works on my machine."
]

=== A repository that doesn't smell like a dorm

`.gitignore` has to exist: `target/`, `.idea/`, `.env`, `*.iml`, `.DS_Store`. If `target/classes` is on GitHub — a recruiter may not get it, but a developer in the interview will get it and sigh. A sigh in an interview is bad currency.

Secrets: a study `task/task` in compose — fine, that's a sandbox. An email token, a password "like production," an AWS key you dropped "for a second" — not fine. Even in git history. If you already pushed — rotate it, don't pretend "nobody saw." Bots saw.

Commits: `week12: flyway tasks table` reads. `fix`, `asdf`, `doesn't work` — the log of a drunk watch. Don't rewrite the whole history for beauty. Starting next Monday, write them properly.

Let `java-basics` and `lisp-experiments` stay public. That's the path from Hello. A person who hides the first program often hides the second. You don't hide.

=== A résumé on one page, not a novel

Name, city (or "remote"), email, GitHub, phone if you're ready to hear unknown numbers.

Then *not* "goal: grow in a friendly team." The goal is already clear: a job. Then the stack in one line: Java 21, Spring, PostgreSQL, Docker, Git.

Two projects:

- task-manager — what it does, a link, one detail ("JWT, Redis cache, compose").
- a second, if you have one: shop, android-calc, even a console list. Better a live small one than "microservices planned."

Experience: school, a side job, "I wrote such-and-such." Don't lie about dates. Courses — at the bottom, one line, or not at all. Lisp: "for myself, Common Lisp, study études" — under "also," not in the header instead of Java.

#exercise("21.J1", "Java")[
  Rewrite the README so a classmate can bring the project up without you in chat. Mac and Windows. If "well that's obvious" pops up — it isn't obvious.
]

#exercise("21.J2", "text")[
  Eight to twelve lines about task-manager: why, what you built, what you used, a link. No "communicative, stress-resistant."
]

#exercise("21.J3", "text")[
  A résumé on one page. Photograph it or PDF. Read it out loud in forty seconds. If in forty seconds it isn't clear *how you're useful* — cut adjectives, not the stack.
]

#github[
  Check with your eyes, not "git status is green": opened GitHub in incognito, README, no `target/`, there is compose, there is a CI checkmark. Incognito — so you don't confuse "I'm logged in and I know everything" with "a stranger."
]

#lesson(22, [Rehearsal in the cabin])

Three chunks of fifteen–twenty minutes. Not "when I feel like it." The feeling will not arrive at the interview. A person with a laptop will arrive, and the question "tell me about the project."

1. Java and SQL (joining tables, an index, a transaction, how 401 is not 403).
2. "Tell me about task-manager" without a screen, three minutes, then "what if the database dies."
3. A twenty-minute problem out loud. Silence in an interview reads as "I died."

Record your voice. Listening to yourself is embarrassing. Embarrassment is cheaper than a rejection where you never figured out *where* you drifted.

=== A bad pitch, three minutes (don't do this)

"Well it's like a task manager on Spring. Well Boot kinda brings it up itself, and Java, and a Postgres database. I added endpoints. And Redis, because Redis is in the job posts. I also wanted Kafka but didn't have time. Anyway, regular CRUD. And there are tests, kind of."

What the other side hears:

- you aren't the author, you're a witness to Spring;
- Redis "because job posts" — a red flag;
- Kafka, which isn't there, took story-time from what *is* there;
- "regular CRUD" — you shrunk yourself, even though you have JWT and other people's tasks don't leak.

Spring will *not* tell the interview anything by itself. You will.

=== A good pitch, the same three minutes (steal the frame)

"I built a personal-task service — REST, Java 21, Spring Boot, PostgreSQL.

The problem is a study problem, but a real one: a to-do list that survives a restart, and you can't read other people's items. So a task has an owner: the user id from login, not from a URL parameter.

The moving parts: registration and login, JWT, CRUD, pagination. Flyway migrations — the schema is in git, not 'in my head.' On list reads there's Redis for 30 seconds, on write I drop the key; without the drop the cache lies, I broke that on purpose and wrote it in the README.

The email queue isn't a separate service, it's an event after the transaction commits and a log line 'tell the human.' I didn't put Kafka in production: I understand a log versus HTTP, and in the repo there's either a tiny broker or notes — whichever is honest.

If the database dies — the API returns 5xx, the cache may show stale for a while; that isn't a rescue, that's a delay. Compose brings up the app, Postgres, and Redis; the README has curl from a Mac and from Windows.

If I rewrote it — I'd pull notifications out more cleanly and add Testcontainers so CI doesn't depend on 'the database on my desk.'"

Time it. If it's over four minutes — cut. If it's under a minute and a half and there's not a single *your* decision — add not technologies, but "why."

#slow[
  A frame on paper, four blocks, one sentence each, then grow them:

  1. What it is, for whom.
  2. One rule you're proud of (your own tasks, a transaction, dropping the cache).
  3. What it *isn't* (not microservices, not Kafka in production).
  4. How to bring it up and what breaks if Postgres goes down.

  No screen. Hands are allowed. A laptop is not. In an interview they may not give you a screen to poke — they may give you "tell me." The story has to stand on its own.
]

=== A Java and SQL chunk, so you don't mumble

Speak short truths. Not a lecture.

- *Joining tables:* `tasks.user_id` points at `users.id`. JOIN is "put them next to each other." Without JOIN you get either a raw id or N+1, which you already smelled in month 3.
- *Index:* a cheat sheet for "where are this user's tasks." Writes a bit slower, finds faster. On three rows Postgres may skip the index — you already wrote that in the README too.
- *Transaction:* several writes as one gesture. It fell over — nothing happened. `@Transactional` on a public service method, not on `private`, not "on every controller just in case."
- *401 and 403:* 401 is "I don't know who you are" (no token / expired). 403 is "I know who, you can't come in here." Mixing them up is like mixing "the airlock is locked because you didn't give a name" and "you gave a name, but you can't go into the reactor."
- *equals and hashCode:* `==` is the same box. For a map key — the contents. A `record` already gives you both.

If you don't remember — say "I can't phrase it exactly right now, here's how I did it in code" and describe your file. "I don't know" plus a map beats a fairy tale about MVCC from the middle.

=== Lisp: a tiny `eval`, the reason the parentheses are on the schedule at all

Not the whole language. One evening of joy. Being able to evaluate `(+ 1 2)` and `(- 5 3)` and nesting. That isn't "write SBCL." That's understanding that parentheses are a tree, and a tree can be walked.

#slow[
  A form is either a number, or a list whose head is an operation and whose tail is arguments. The arguments are forms too: that's why nesting works.

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

  `(ev 3)` — a number, return it as is. `(ev '(+ 1 2))` — not a number, head `+`, tail `(1 2)`, run each tail through `ev` (they're numbers), add. `(ev '(+ 1 (- 5 3)))` — the inner `(- 5 3)` becomes `2`, then `(+ 1 2)`.

  Break it: `(ev '(+ 1 foo))`. Error. Fix it either by not accepting symbols, or by teaching `foo` to be a variable — that's already the next evening, don't get greedy.

  Want a little more language — add `*` with the same `cond`. Want unary minus `(- 3)` — remember that `apply #'-` in Common Lisp already can. Don't drag `lambda` and `defun` into `ev` the same evening: you'll get a compilers textbook, and tomorrow you have a letter. A thimble. Not a station inside a station.

  Draw the tree on paper. Without paper, half the people decide `eval` is REPL magic. It isn't magic. It's `first`/`rest` and the faith that a smaller piece evaluates.
]

#repl-note[
  `(ev '(+ 1 2))` → `3`. `(ev '(- 5 3))` → `2`. `(ev '(+ 1 (- 5 3)))` → `3`. You just wrote a language the size of a thimble. The thimble matters more than "I read about compilers." In an interview you can smile: "I evaluated parentheses for myself." Someone will smile back. That's enough.
]

#exercise("22.J1", "practice")[
  Record a talk about the project. Listen. If every five seconds it's "well Spring does that itself" — retell until *you* show up.
]

#exercise("22.L1", "Lisp")[
  A tiny `eval`: `(+ 1 2)`, `(- 5 3)`, nesting. Not the whole language. One evening of joy. That's the game Lisp is on the schedule for.
]

#exercise("22.J2", "text")[
  On one page: a bad pitch (yours, honestly, how you talk now) and a good one (from the frame in this chapter). Don't invent technologies that aren't in the repo. If there's no Kafka — it isn't in the good pitch either; there's an event-queue and the words "I didn't put it in."
]

#sunday[
  Call a live human for fifteen minutes. Let them ask "what if the database dies" and "how is 401 not 403." A live human is worse than a cat: a cat doesn't wince. Wincing is useful.
]

#lesson(23, [Letters into the unknown])

Five to ten applications a week. Not fifty by copy-paste. Not one "when the letter is perfect." Cover letters are about *your* server, not "I learn fast." A posting with Kafka and kube: you can write if you're ready to say the truth: "I didn't put it in production, here's a monolith and here's a queue." A lie burns on the second question. Sometimes on the first.

HR does not read a soul. HR reads whether there's Java, whether there's a link, whether the letter screams "READY FOR CHALLENGES!!!" Then the letter reaches a person who *can* open GitHub. They need a hook, not a novel.

=== Sample letter (short, with one truth)

Subject: Java / junior, task-manager — applying for "Backend Java, team X"

```
Hello.

I saw the "Java developer" posting at N: you have PostgreSQL,
REST, and a message queue.

I've spent six months building a study monolith: Java 21, Spring Boot,
PostgreSQL, JWT, tests, Docker Compose.
Tasks are yours only, Redis cache dropped on write.
The notification queue is an in-process event, not a separate service.

I haven't put Kafka in production. I understand a log vs HTTP; the repo
has honest notes / a study broker (as in the README).
Happy to talk about what's missing for your posting.

GitHub: https://github.com/<nick>/task-manager
Email / telegram: ...

Name
```

What works here: the company name, *one* detail from the posting that you actually have (Postgres, REST), one detail you don't have — honest right away. A link. How to reach you.

What doesn't work: "I am a goal-oriented individual." "I'll consider an internship and junior and middle." "Kafka, Kubernetes, AWS, Grafana" as a list, if of those you only have the word Grafana in a course title.

=== A bad letter (so you have something to compare)

```
Hello!!! My name is Alex.
I really want to work at your company, I learn fast,
I'm stress-resistant, communicative, ready for challenges.
I've studied Java, Spring, Kafka, Docker, k8s, React.
Please find my résumé attached.
```

Three exclamation marks — a panic sensor. A wall of stack — a lying sensor: React next to k8s with no link means "I read words." No company name. No GitHub. Not *one* sentence about what you *built*. You can not send a letter like that: it saves someone else's time and your own embarrassment.

The second bad genre — a sheet three screens long: childhood, courses, "I loved math in school." The person on the other side is not hiring a school. They're hiring whether the link opens and whether you're lying about Kafka.

=== Honest answers you can say out loud

In an interview (and in a letter, if they ask) a short truth beats a long fairy tale. Here are drafts. Say them in your own words, don't memorize them as an oath.

*"What's your Kafka experience?"*

"I haven't put it in production. I stood up a study broker / I read the log model: topic, offset, how it isn't HTTP. In the project, events go through a Spring event after commit. If you have Kafka — I'll need time to learn *your* cluster and conventions, not Wikipedia."

If the broker is actually in your compose and messages show up in the log — say that. Don't undersell. Don't undersell *and* don't say "well basically production."

*"Why Redis?"*

"The task list is read often, written less. I cached it for 30 seconds, on write I delete the key. I broke the drop on purpose — saw stale. I didn't catch a stampede with three users, but I know a short TTL plus a crowd of simultaneous GETs will hit the database."

*"Microservices?"*

"One process, one database. I didn't carve notifications out: otherwise the email leaves on a rollback. When a compound gesture survives one transaction — then we talk."

*"Why is Lisp on the résumé?"*

"Forty minutes a day so I don't get bored and so I see lists. I'm not applying as a Lisper. I can show a tiny eval. If that's not interesting — fine, let's do Java."

*"Where do you see yourself in five years?"*

Not "CTO of your company." "I write a backend I'm not ashamed to fix at night, and I understand what I'm doing." Boring. Boring beats science fiction.

*"Any questions for us?"*

Yes. "What does a junior's first month look like?" "Who reviews?" "What's prod on, and will I get to the logs?" The question "do you have Kafka?" makes sense if you're ready for the answer. The question "how much do you pay" — better later, when they bring it up, or very calmly if this is already the second conversation.

*"Tell me about HashMap"*

"A key, a bucket, on average you get it fast. Two objects with the same meaning must be equal via equals and have the same hashCode, or the map will put them on different shelves. A mutable key is pain: you put it in, you change a field, you can't find it. For ids I use a record."

*"What's a transaction?"*

"Several writes to the database as one gesture. Either all of them, or none. In Spring — `@Transactional` on a service method. If I create a project and a task, and the title is empty — I want the project gone too. That's in my month-3 code, I can open it."

If you can't open it — don't cite it. Say the idea. A link to a file that isn't there burns faster than a Kafka lie.

=== Where to send so you aren't yelling into a vacuum

Job sites, internship telegram chats, people from the course, *warm* letters ("you said they were hiring"). Five to ten cold ones a week. If you sent fifty copies overnight — you aren't a hero, you're spam. Spam gets marked.

A posting "three years experience, Kafka, k8s, highload" — you can send one honest letter if the rest (Java, SQL) matches. You can't spend ten hours bolting on Kafka for that one posting. The calendar matters more than their dream stack.

An unpaid internship: decide yourself, don't hero it out of shame. Three months "for experience" with no mentor and no code in git is often more expensive than ten more letters. If there's a mentor, there's code, Java is alive — maybe. If it's "make coffee and look at Jira" — no, even if it says Kafka on the door.

#exercise("23.J1", "text")[
  A letter template: company name + one detail from the posting that you *actually* have. Not "ready for challenges."
]

#exercise("23.J2", "practice")[
  Out loud, on a recorder: the Kafka answer (didn't put it in / here's what I did put in), Redis, microservices. Three minutes for all three. Listen. If it sounds like an apology for being alive — rewrite the tone. Truth without a hedgehog in the voice.
]

#warn[
  Don't paste someone else's README and someone else's curls into the letter. In the second interview they'll ask you to "open your repo and change this." Someone else's repo will not open with your hands.
]

#lesson(24, [After a miss — the same day, not a month of shame later])

They will reject you. Sometimes with silence, which is worse than words. Sometimes "we've decided to move forward with another candidate." Sometimes on a HashMap question where you started a fairy tale. That isn't a sentence on the station. That's a sensor.

A list of questions where you drifted. Usually SQL, `HashMap`, transactions, HTTP codes. Close the hole locally. Not "reread the whole textbook from lesson 0." They repair the station by the sensor too, they don't rebuild from the keel every watch.

The same day, while memory is hot:

1. What they asked (literally, even crooked).
2. What you answered (honestly, "I mumbled").
3. What answer wouldn't have been embarrassing — five to eight sentences.
4. A link to your file if the topic is in your code. If not — a small étude in `java-basics`, not a new framework.

The card lives in a folder `interview-log/` or in a paper notebook. Paper isn't ashamed. You don't have to push to GitHub if it says "I was dumb" inside. You can push without the dumb: just the question and a careful answer. Like a station log.

=== Typical holes and how not to treat them

Drifted on JOIN — don't buy a "SQL in 48 hours" course. Write three queries on *your* tables: a user's tasks, tasks with the owner's name, task count per person. Out loud.

Drifted on "what if two requests at once" — go back to the counter and `@Transactional`, not to a whole book on the JMM.

Drifted on "tell me about the project" — that's lesson 22, not Kafka. Kafka has nothing to do with it, however much you'd like to hide in a new topic.

Silence after ten letters is a sensor too. Check: is there a link, does compose come up, does the README scream on Windows. Sometimes the market is just slow. Sometimes the porthole is dirty. Dirt you fix. A slow market — more letters, not "I'll wait it out in shame."

=== Sample card (you can almost copy the form)

```
Date: 2026-08-13
Where: company N, screen
Question: how is 401 different from 403?
What I said: "well both are errors"
How it should go:
  401 — didn't identify (no token, expired).
  403 — identified, can't go here (someone else's task).
  In task-manager a foreign id gives 403 or 404 —
  see TaskService.java, method getOwned.
Étude: no, the code is already there.
```

Three of those sheets in a month — no longer "I'm always dumb," it's a map of holes. A map can be fixed. Eternal dumbness cannot.

#exercise("24.J1", "Java")[
  A card for a hole: the question, an answer of five to eight sentences, a link to your file if there is one. That's your new station log.
]

#exercise("24.J2", "text")[
  Three cards in advance, before the first miss: 401 vs 403; why an index; what a transaction does on creating a project with a task. Write how you talk, not like Wikipedia. Then, when it comes up in an interview, it won't be "I should have prepared," it'll be "I've already said this out loud."
]

#rule[
  Forbidden after a rejection: deleting the repo, going silent for a month, starting a "full rewrite on microservices." Allowed: a card, one étude, the next letter this week.
]

#lesson(25, [Code by hand, no magic button])

Forty-five minutes, an easy problem, the standard library, even in Notepad. On Windows — Notepad++ or IDEA with no autocomplete, if you have the nerve. Out loud: what's the invariant, what's an example, how fast is this.

A whiteboard (or Miro, or an A4 sheet) is not a place to show you memorized streams. It's a place to show you *think*: an example, an edge, complexity "I'll walk the list / I'll put it in a map."

Three study ones, mean on a timer:

- anagrams: the same letters, different order;
- merge two already-sorted arrays into one sorted array;
- unique emails (as the problem says: dots, plus — read the statement, don't guess Gmail).

#slow[
  Before the timer ticks, rehearse the ritual:

  1. Restate the problem in your own words. If you didn't restate — already a miss, you solved the wrong problem.
  2. Example: `"ab"`, `"ba"` — yes; `"ab"`, `"abc"` — no.
  3. Edge: empty string, one character, different case — ask, or pick and say it out loud.
  4. Idea: sort the characters or a frequency array. Complexity.
  5. Code. Don't go silent. "I'll put frequencies in a HashMap" — they can hear you're alive.
  6. Walk the example with a finger. Find the hole yourself, before the interviewer.

  If you're stuck for five minutes — say "I see two paths, I'm taking the simpler one, this one." Silence reads as "I died." A bug in the code reads as "a person you can fix things with."
]

On Java 21 you can use a `record`, you can use `char[]` arrays. You don't need `Stream` for Stream's sake. On a whiteboard a stream is often crooked and you can't run it.

A Lisp version of anagrams is the same gesture, different parentheses. In an interview that's a joke at the end, not the main act. The main act is Java, which they're hiring for.

=== Anagrams with a finger, while the timer isn't mean yet

The problem: two strings are made of the same letters.

```java
static boolean anagram(String a, String b) {
    if (a.length() != b.length()) {
        return false;
    }
    char[] x = a.toCharArray();
    char[] y = b.toCharArray();
    Arrays.sort(x);
    Arrays.sort(y);
    return Arrays.equals(x, y);
}
```

Out loud: "different length — no right away. Otherwise I sort the characters and compare the arrays." Example: `listen` / `silent` — yes. Complexity: sorting, not "I'll walk all permutations." Permutations are a path to heroics and dying on `abcd`.

Second path — frequencies in `HashMap<Character,Integer>`: plus on the first string, minus on the second, all zeros. On a whiteboard sorting is shorter. In the interview say both, take one, write one. Two unfinished paths are worse than one working one.

Merge arrays: two indices `i` and `j`, a third array, whoever is smaller — put that one, advance. Write the tail. Don't `sort` everything after `concat`: they're checking whether you can use the fact that it's *already* sorted.

#os[
  Practice in the layout you'll walk into. If the interview is on Windows in their office and you've lived on a Mac — one evening in Notepad won't kill you. Parentheses and semicolons are the same. The buttons are different. Better to swear at home than in a room with a marker.
]

#exercise("25.J1", "Java")[
  Three on a timer: anagrams; merge two sorted arrays; unique emails. The timer is mean. That's the point.
]

#exercise("25.L1", "Lisp")[
  The same anagrams in Lisp. Then in an interview you can say: "I also did this with parentheses." Someone will smile. That's enough.
]

#lesson(26, [Walk, don't "just a little more Kafka"])

The measure of the month is calendar slots, not a new chapter. Lisp forty minutes. Sunday — a walk. Seriously, a walk.

"Walk" means: an application went out, a slot is on the calendar, you slept, the README opens, the pitch was said out loud at least twice. It does not mean: you learned one more broker the night before the call. A night broker in an interview smells like fear. Fear is audible.

=== What a week looks like when you're already on the market

Monday: two applications from the template, different postings, in each letter one truth from *their* text.

Tuesday: a card from the last rejection or a practice question. Forty-five minutes of whiteboard.

Wednesday: a slot, if they gave you one. If they didn't — two more letters. Not "waiting for fate."

Thursday: Lisp, a small bug in task-manager you promised yourself after the pitch ("Testcontainers," "a clearer 401 error"). One bug, not a universe refactor.

Friday: finish what's broken. Don't open new textbooks. Especially about Kubernetes.

Saturday: the project as a project, not as a sacrifice to the interview.

Sunday: legs, air, station MODULE with no laptop. A brain with no air lies that "one more chapter will save you." It will not.

=== On the interview day itself

Laptop charged. IDE open on the project, if they ask you to "show." Zoom/Meet checked yesterday, not five minutes before. Headphones. A glass of water. You know the README by heart — not because you memorized it, because you wrote it.

Three minutes late — write. Silence is worse than three minutes.

They asked something you don't know: "I don't know it in production, here's how I understand it, here's where my model lies." Then you can ask "how is it for you." A conversation. Not an expulsion exam, even if it feels like one.

After the call — a card the same day. Even if it feels like "everything went well." Well also has to be repeatable.

=== A call, an office, a whiteboard in someone else's room

Zoom: camera at eye level, not up the nostrils. A calm background. Phone in airplane mode, a *second* internet channel (hotspot) just in case. The Meet link open ten minutes early, not ten seconds: a browser update loves to coincide with your entrance.

Office: passport, if there's a badge. A notebook. Your own pen. Water. Headphones not needed if they take you to a meeting room. Laptop — if they said "bring it," and a charger for *their* outlets. In Russia the outlets are usually the same; in a coworking space sometimes not.

On the whiteboard write large. Tiny handwriting in a corner is "I'm ashamed of my code." At the top, the problem in your own words. On the left, an example. On the right, code. Erase not from panic, from "this chunk lies, here's a new one." Ask for a minute to think — normal. Ask for a hint after seven minutes of honest struggle — also normal. Ask for a hint after thirty seconds of silence — too soon.

If they share a screen and ask you to open IDEA: turn off autocomplete if you have the nerve, or leave it and *don't* accept the first nonsense Guava whispers. The interviewer can see when you hit Tab without looking.

=== When the book is over

You've finished the book when:

- on GitHub you can see the path from Hello to a server with a database;
- you fix your monolith without theater;
- you honestly say what you haven't done.

An offer is not a button at the end of a chapter. It's a probability. A plan raises it. It doesn't promise a date. Nobody promised station MODULE wouldn't fall apart either — and it's still there. Somehow.

The evening before a slot: not Kafka. README out loud. One curl. The pitch once on a recorder. Sleep. If you can't sleep — a scrap of paper with the four pitch blocks under the pillow, not a Habr article "how Raft works." Raft can wait for Tuesday after a rejection. Or after an offer. It doesn't care.

If the letters are silent — it isn't necessarily another six months of Kafka. Further in the book there's a short spare hatch: Android, a calculator, Studio from developer.android.com. Same Java. Different screen.

#exercise("26.J1", "practice")[
  A calendar for two weeks: application slots (dates), one slot "rehearse the pitch," one slot "three problems on a timer." Hang it on the wall or put it in a calendar you *see*. An invisible plan is a dream, not a watch.
]

#exercise("26.L1", "Lisp")[
  Forty minutes on the day they rejected you. Any station étude, even `ev`, even an oxygen sensor. Parentheses don't know about HR. That's the point of the forty minutes.
]

#github[
  On the GitHub profile: pin `task-manager`. Profile bio — one line, not a quote about passion for code. The link in the résumé opens. Check from a phone.
]

A profile with no pinned repo is an attic. The person on the other side will not hunt `task-manager` in a list of twenty forks of other people's tutorials. Pin it. Unpin the `spring-petclinic` fork if you didn't fix it. A fork with no commits is not a project.

Check the links from a phone: GitHub, résumé PDF, email in the profile. A recruiter often sits on the subway, not at a big monitor. If the README on a narrow screen is a wall — cut. If the email has a typo — the letters "went into space," and the station has nothing to do with it.

And with that the book as a textbook ends. Next — other people's rooms, other people's questions, your files. Station MODULE isn't going anywhere. Neither are the parentheses. Go.

If you're scared — that's normal. It's scary to fix a reactor in month one, it's scary to hit Send. Hit it anyway. A letter that didn't go out doesn't open. A station that wasn't turned on doesn't scream with sensors — and that isn't calm, that's the silence of an empty corridor.

Tea. Send. A card. Parentheses.

#warn[
  Don't vanish into "I'll rewrite everything in Kotlin + Kafka + k8s in August." August will end, there will be no letters, the monolith will be dead on a `rewrite` branch. The market takes what's alive. Alive is what comes up today.
]
