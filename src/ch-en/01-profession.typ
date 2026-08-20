#import "../lib-en.typ": *

= Why become a programmer at all

A programmer is not a person with a memorized language. A programmer is a person who tells the hardware "do it like this," the hardware does it like *that*, and then the investigation starts. Languages, frameworks, databases — screwdrivers. The craft is the loop:

1. Understand what they want (sometimes — what you want).
2. Cut it into pieces a machine can do.
3. Write.
4. See that it does something wrong or crashes.
5. Fix it.
6. Again. Again. Again.

At work it's the same, only the pieces are someone else's, the deadlines are someone else's, and people sit nearby who have grabbed the same spot a hundred times. They don't hire you for a certificate from an online course. They hire you because you can *drag a small piece to working* and then tell, in your own words, what you did.

It's duller than the movies. In the movies a hacker in a black hoodie cracks the Pentagon in three seconds. At work a junior spends forty minutes on why the Save button doesn't save, and the cause is a trailing space. Then they fix it. Then they write a test so the space doesn't come back. Then they drink tea. That is the profession. If that day already makes you angry — maybe this isn't your job. If that day looks like ordinary craft — welcome aboard.

== Myths better shoved out the airlock

*"You need a mathematical mind."* You need a willingness to look stupid out loud. Algebra helps sometimes. Stubbornness helps every day. A person who isn't ashamed to write on paper "what I just did" outruns a genius who is too shy to ask.

*"You need ten languages."* You need one well enough that lying in it would be embarrassing, and the ability to open a second when you need it. This book takes two: Lisp — so you don't get bored, Java — so they hire you. Ten languages on a résumé with no repo look like ten screwdrivers with no handle.

*"Theory first, then practice."* First practice on a tiny piece, then theory that *explains* why the piece worked. Otherwise theory is an audiobook for falling asleep.

*"Real programmers don't Google."* Real programmers Google better. The difference: they understand what they pasted, and they can throw half of it away.

*"A junior can't do without Kafka."* A junior can't do without a program that runs. Kafka can wait. It isn't going anywhere, unfortunately.

== What they actually look at

Job posts are written like spells: Kafka, k8s, microservices, "one year of experience." For the first four months you can skip them — that's marketing and HR fear. The live filter is almost always duller:

- Java: types, lists, how `equals` differs from `==`, exceptions, objects.
- HTTP: methods, statuses, JSON.
- SQL: a select with a join, why a key, why an index.
- Spring Boot: the controller takes HTTP, the service holds the rules, the repository talks to the database, the transaction sits on the service.
- Git: commits, a diff, not fainting at a branch.
- Your own project, which you can tell in three minutes *without notes*.

Kafka on the résumé and an empty repo — they see it immediately. A course with no GitHub — same.

#slow[
  The person across the table isn't checking whether you memorized the word "microservice." They're checking whether you'll fall apart when they give you a ticket "the button saves an empty name" and a chunk of someone else's code. If you've already done that *for yourself* — you aren't the beginner they're afraid of. You're the beginner they can teach.
]

In interviews they often ask you to write a loop, explain JOIN, and talk about your repo. Three things. Not "design YouTube." If you can do those three without panic — you're already past half the emails HR throws out for "I took a course, diploma attached."

== What a day looks like after they hired you

Not Hollywood. A test failed. Ticket: "the button saves an empty name." You read someone else's code. You write twenty lines. You argue what to call a field. A call where twenty minutes go to whether `cancelled` is a status or a separate table. Lunch. Another ticket. That isn't the whole profession. That's *docking*: it shakes, but you're already on the station.

Sometimes the day is beautiful: you found why prod glitches on Mondays, and it was a timezone. Sometimes the day is dumb: rename a field in five places. Both days are work. Romanticizing only the beautiful ones is how you burn out by month three, when the beautiful ones are scarce.

They'll ask "so how are you doing on time." An honest "I don't know, here's what I already did" beats the theater of "everything's great." The station likes sensors, not optimism without numbers.

== Where it grows, if you don't run into the woods

Further on, if you don't get stuck copying annotations:

- *Middle* — they trust you with a slice of the system, not one button. You already say "that's a bad idea" and sometimes they listen. Pay goes up. The pile of Slack messages does not get smaller.
- *Senior* — people come with a question, not a ready ticket. You decide *what* to build, not only *how* to write the loop. Pay grows faster than hair. An unpleasant duty appears: stopping other people's bad ideas, including yesterday's yours.
- *Architect* — you decide how the station is built: which compartments exist, how they dock, what happens if this hatch opens. The arrows on the diagram are the side effect. The job is decisions that decide whether the station falls apart in six months or not. Sometimes you argue whether Kafka is needed *this time* for a reason.
- *Manager* — if you suddenly stop wanting code. Then meetings and "so how are we on the timeline." Same `loop`, only the arguments are people, and they return `nil` less often than they promise. That isn't in this textbook, and we all sighed with relief.

This book is the first hatch. The rest happens by itself if you don't stop fixing things.

In week one, `Hello` has to print. A career is what grows out of a pile of evenings, not a slide labeled "trajectory."

== Why Lisp then

Because the on-ramp to Java is easy to turn into six months of `@Autowired` annotations and a quiet wish to go live in the woods. Lisp in a REPL shows the same ideas naked: a list, a function, recursion, "data is code too." Play with lists and `ArrayList` and JSON stop being hieroglyphs. Forty minutes a day — so you don't hate programming by month three of Spring.

On a résumé you can poke Lisp into "also I can." They won't ask in the interview. Good. They'll ask about `HashMap`. And `HashMap` after an alist in Lisp is no longer magic, it's a pocket with labels, only fast.

Lisp also treats the fear of errors. In the REPL you broke it — you got a message, you fixed it, you live. No five-minute build to learn you forgot a parenthesis. That reflex ("broke → read → fix") later saves you in Java, where the build takes five minutes and the error is one missing parenthesis.

== Six months is dense

Weekdays: two-forty. Plus Saturday. If by week twelve you have no server of your own with a database — don't tweak Kafka, finish the server. Curiosity is cheaper than a lost month. Missed a week — don't read three chapters on Saturday, that isn't a feat, that's a jumble in your head. Take the current lesson and your project.

Six months × about six evenings × two-forty — that's a lot of hours. Enough for fingers to remember. Not enough to become someone who "has already seen everything." And you don't need to. They hire juniors not for "seen everything." They hire them for "I see, I fix, I tell."

If you work another full-time job — six months may stretch to eight months. Fine. The calendar in the book is a plan, not a bomb timer. Station MODULE wasn't built on a Jira sprint either, judging by the duct tape.

== On copying

Other people's answers — after your own attempt. At work you'll Google every day, that's normal. The difference is whether you can *read* what you pasted and change one line without collapsing the rest.

Copying a quest from the answers in the first minute is like looking up a crossword and deciding you're smart. Feels like you got it. You didn't. In a month the interview crossword won't have answers at the back of the book.

Peeking after twenty minutes of failed attempts — fine. You already thought. The brain got the query. Then the answer *lands*, instead of flying past.

Code from this book — into your study repos, please. Other people's books and commercial repos — don't pass them off as yours. The station is already on duct tape; let's skip lawsuits and résumé lies. Lies in orbit end with an open airlock.
