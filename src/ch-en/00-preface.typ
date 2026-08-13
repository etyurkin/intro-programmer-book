#import "../lib-en.typ": *

= How to read this book

If you were waiting for a preface about "competencies" and "learning trajectories" — wrong book. This one is about spending six months playing with parentheses, repairing an imaginary space station, and in parallel building a Java thing you wouldn't be ashamed of in an interview.

Each chapter is one evening, about *two hours and forty minutes*. Not "complete the module." An evening. Tea is allowed. Cookies are even desirable: a brain learning parentheses burns glucose like the reactor on station MODULE.

In six months this can grow a person companies hire as a junior. But only if the measure isn't "I read the chapter," it's "it ran, and I pushed it somewhere."

Reading the whole book in a weekend, nodding, and closing it — almost nothing happens. That isn't a scolding. That's physics. Programming lives in fingers and in errors, not in the feeling of "I kind of got it." Got it means you *changed* the example, it broke, you fixed it, and you can tell a neighbor *why* it broke.

== Why learn languages if there's AI

AI will do it. A service, a test, even a README where you "confidently know Kafka." Fast. Sometimes even right.

The catch is the question. The model answers what you asked. "Write me a backend" — you get a cathedral with no evacuation plan. "Why does the button save a trailing space" — you get a decent answer *if* you already know a string can lie at the edges. That isn't from the chat. That's the foundation: a variable, an error, a file is not a database, a test is not a ritual.

Without the foundation you cannot ask the right question. You'll ask "make it work" and sit in someone else's code like a dark compartment with no flashlight. In the interview they'll ask *you* for the flashlight. They won't let the model into the room.

#slow[
  AI speeds up the person who can see *where to look*. The person who can't, it drives to someone else's repository and leaves them there alone.
]

== Two languages, and that isn't confusion

*Lisp* is not here for the résumé. Almost nobody wants Lisp on a résumé, and that's wonderful: you can do stupid things. Forty minutes. Read a chunk → type it in the REPL → *definitely break it and fix it* → write a tiny horrible thing of your own. If you didn't break it — you weren't practicing, you were watching. Watching a welding show and actually welding are different jobs. The main thing is not to turn Lisp into lecture notes. Lecture notes about parentheses are no longer parentheses.

*Java* is what they pay you for later. Two hours. Twenty minutes of those looking at how an idea is built, and an hour and a half making it work *on your machine*. Red errors, docs, Stack Overflow, a dumb question to the chat next door — not failure. That's the profession, just without the salary. The salary shows up when you stop fainting at red.

*SICP* is not on the schedule. For a beginner it's an anatomy textbook instead of a kitchen: useful, but you want to eat now. You'll open it when you yourself hit a wall: "is recursion magic?" — and suddenly the dry book gets interesting. Not before. Open it in week one and you might hate Lisp, yourself, and books in general. Don't.

#slow[
  Lisp answers "how does this work *at all*?" Java answers "how do I get *paid* for this?" They don't fight. They live at different hours of the day, like tea and coffee. Mixing them in one mug isn't forbidden, but the taste will be weird.
]

== How to live a week

#rhythm[
  *Mon–Thu:* 40 min Lisp + 120 min Java. \
  *Friday:* Lisp, and Java — finish whatever fell apart during the week. No new textbooks. \
  *Saturday:* two or three hours on *your* project only. Music allowed. "One more theory chapter" is not. \
  *Sunday:* a walk. Or a small sabotage from the box at the end of the lesson: a server on the knee, HTTP by hand, your own parody of a database. Not a third chapter.
]

Friday is boring on purpose. A beginner on Friday opens "one more Kafka guide" because the weekday work isn't done and it feels shameful. Don't. Finish the weekdays. Shame passes. A mash of three half-written servers does not.

Saturday is sacred. This is not "more lessons." This is *your* station: a TODO, task-manager, anything you can poke and say "I made this." If theory eats Saturday, in three months you'll have notes and no repository. HR does not clone notes.

Sunday you may walk. Seriously. The brain finishes wiring while you go for bread. Open chapter four instead of bread and Monday you'll have mash and a grudge against parentheses.

#rule[
  Learned a thing — into code immediately. Don't read about Spring storage for two hours. After twenty minutes: "ok, this should now show up in *my* project." Then let it scream errors. That's the design.
]

#rule[
  Until you've written one normal program all the way (database, endpoints you can hit), no "microservices." Otherwise you'll learn the word Kafka and say it with a smart face without knowing why it's there.
]

#rule[
  The plan is a treasure map, not a sentry's rulebook. Stuck on Hibernate for three days — normal, the station is always being repaired too. Got hooked on Lisp and you're writing a tiny language — write it. Don't drop Java entirely, but killing curiosity for a checkbox is stupid.
]

== Roughly where you crawl to

This is not an exam. This is "if it's roughly like this — you aren't making it up."

#align(center, block(width: 95%)[
  #set par(first-line-indent: 0pt)
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.4pt + rgb("#d0cbb8"),
    fill: (_, y) => if y == 0 { rgb("#e8e4d8") } else if calc.odd(y) { rgb("#faf8f2") } else { white },
    [*Week*], [*Roughly, you can*],
    [4], [Your own Java program, and it lives on GitHub],
    [8], [A small web server you start yourself],
    [12], [A real backend: tasks, a database, create/read/update/delete],
    [16], [In an interview about Java and SQL you don't go silent and don't invent],
    [20], [A cache or a queue *in your code*, plus Docker],
    [23], [Repos you aren't ashamed to put in an email],
    [26], [You go to interviews instead of "I'll just learn a bit more Kafka"],
  )
])

No GitHub in week four — don't read Spring. Go back and push. No database in week twelve — don't read Redis. The database matters more than the fashionable word. The table lies in only one direction: it's *optimistic*. Real life sometimes lags a week. That isn't failure while you're fixing the current thing, not collecting chapters like stickers.

== What to do with a chapter

1. Lisp: read, run, *change*, write your own.
2. Java: a little theory, then the project for the rest of the evening.
3. Quests. Yourself first. Answers at the back of the book. Peeking before twenty minutes of stubborn pain is allowed, but then the brain gets nothing.
4. A commit. Even a crooked one. Especially a crooked one.

AI is a roommate who has seen this before: "why won't it compile," "what's that wall of glyphs in the error." Not a genie: "write me a service." They won't let the genie into the interview room, and they will ask *you* why that field is there.

#warn[
  If the AI roommate wrote you half of `TaskService` and you can't explain out loud why `strip()` is on the title — that isn't your code. That's code that lives in your folder. They won't hire the folder. They'll hire you.
]

== If life ate the day

Missed Tuesday — on Wednesday don't read Tuesday *and* Wednesday. Read Tuesday. Wednesday can wait. Three chapters on Saturday isn't a feat, it's mash: parentheses mix with annotations and you'll decide "I'm stupid." You aren't stupid. You just fed the brain three dinners at once.

Missed two weeks — open the last lesson that *ran*, and your repo. Not "from scratch, I forgot everything." You didn't forget everything. You forgot details. Details come back faster than it feels if the code is alive.

Sick, working, fixing a toilet — station MODULE also goes quiet for weeks sometimes. Then it blinks yellow again. You can too.

== A pile of folders by the end of the half-year

```
github.com/<your-handle>
├── java-basics        # month one: console, lists, files
├── lisp-experiments   # station MODULE and other mischief
├── task-manager       # the main thing: server + database + tests
├── shop               # a second one, if you aren't bored
└── mini-lisp          # your tiny language (optional, but nice)
```

In every README — what it is, how to run it, a couple of examples. Honest terminal output beats "architecture" drawn at midnight.

#github[
  Make two repositories *today*, even if there's one line inside. Empty GitHub at the end of the month looks like "I was going to." Crooked non-empty GitHub looks like "I did." They hire the second kind.
]

== What this book doesn't have, and that isn't a bug

No "become a senior in 21 days." No Kubernetes in chapter one. No promise of an offer by a date. There is a schedule, a station, parentheses, and Java 21.

No correct answer to "IntelliJ or VS Code." There is "install one and write." Editor wars are a hobby for people who already have a job.

No mobile development on the main path. There is a spare hatch at the end: Android, if backend listings look through you. Same Java. Different screen.

== How to know a chapter "passed"

Not "I read to the end." At least one of three:

- You changed the example so it does *something slightly else*, and that runs.
- You can say in your own words what will break if you remove this line.
- The quest is solved by hand, not by pasting the answer — crooked is fine.

If none — the chapter hasn't passed yet. That's normal. Reread a chunk, not the whole book. They repair the station by sensor too, not by rebuilding from the keel every shift.
