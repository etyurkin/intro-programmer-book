#import "../lib-en.typ": *

= Appendices

== A. A week on one napkin

#set par(first-line-indent: 0pt)

- *Mon–Thu:* 40 min Lisp (Barski and/or station MODULE) + 120 min Java (look a little, then until it runs).
- *Fri:* Lisp + finish whatever fell apart.
- *Sat:* two or three hours on the project only.
- *Sun:* a walk, or a small sabotage. Not a third chapter.

SICP — when you asked yourself. Microservices — after one normal program. GitHub — from lesson 0.

If the evening got eaten — don't "catch up three chapters." One chunk of Lisp *or* one chunk of Java, and a commit. The napkin is not a judge.

== B. A cheat sheet for the corridor before the interview

Read it out loud, not with your eyes. Eyes lie: "yeah I know this." The mouth checks.

*Java:* `==` and `equals`, strings, lists and "is this fast / not," `ArrayList` versus `LinkedList`, `HashMap`, generics without fanaticism, checked/unchecked, `try-with-resources`, objects on your own `Task`, `final`. `int` versus `Integer` in one sentence. Why you can't change a string from the inside.

*Spring:* a box of dependencies, a bean, a thin controller, a service, what `@Transactional` rolls back, the controller does not walk into the repository itself. Where the object in the constructor comes from if you never wrote `new`.

*HTTP and SQL:* GET you can repeat, POST twice — careful. 401 is not 403, 400 is not 500. Keys, an index, a transaction, JOIN versus two queries. `EXPLAIN`, at least the idea.

*Hardware:* how the app starts, where logs go, why Docker, how an image isn't a container, why inside compose the database host is `db`, not `localhost`.

If the question "what is a transaction" comes out as "well it's when" and then silence — go back to lesson 11, don't read about Kafka.

== C. What else to read, if you aren't bored yet

- Conrad Barski, *Land of Lisp* — a neighbor in spirit, not the text of this book. The orcs are his, the station is ours.
- One Java reference, not three courses at once. Horstmann or anything, as long as it's *one*.
- Spring Guides — one per week's topic, not "all the guides over the weekend."
- Postgres on your own `tasks` table. The postgresql.org docs, the SQL section. Boring, useful.
- Aditya Bhargava, *Grokking Algorithms* — pictures, conscience clean.
- SICP — in spots, when you yourself asked about recursion or "data as code."
- Official Java tutorials: https://docs.oracle.com/javase/tutorial/ — dry, but they don't lie for clicks.

Don't read five books in parallel. Read one, write code. A book without code is a TV series.

== D. The AI roommate

Allowed: "why won't it compile," "what's this wall of text in the error," "compare my two versions," "explain this line like I'm a person who just learned about parentheses."

Not allowed: "write a task-manager from scratch" and pass someone else's off as a portfolio. They'll ask about a line you never touched. It will be insulting and fair.

Grey zone: "sketch a test skeleton, I'll fill in the asserts." Allowed if you fill them in. Not allowed if the skeleton already has all the logic and you only renamed variables.

#rule[
  The roommate rule: after a hint you should be able to *close the chat* and repeat the step with your hands. If you can't — that wasn't a roommate, that was a genie, and you owe a debt that will surface in a room with a whiteboard.
]

== E. About copying

Code from the textbook — into your study repos, please. Don't put Barski's and Abelson's books into your own PDF. Quest answers are not a commercial product without your own work. Station MODULE is already on duct tape; let's skip the lawsuits.

Other people's code from GitHub in a portfolio with no note — a lie. A fork signed "I changed this here" — fine. The difference is one sentence in the README.

== F. Mac, Windows, WSL — a command cheat sheet

From here on, "like the book" = Mac or Ubuntu inside WSL2. Native Windows is the right-hand column, when you really must.

#align(center, block(width: 100%)[
  #set text(size: 9pt)
  #set par(first-line-indent: 0pt)
  #table(
    columns: (1.15fr, 1.2fr, 1.35fr),
    inset: 5.5pt,
    stroke: 0.4pt + rgb("#d0cbb8"),
    fill: (_, y) => if y == 0 { rgb("#e8e4d8") } else if calc.odd(y) { rgb("#faf8f2") } else { white },
    [*What for*], [*Mac / WSL (Ubuntu)*], [*Windows without WSL*],
    [Packages], [`brew` / `sudo apt`], [Installers, `winget`, Chocolatey],
    [SBCL], [`brew/apt install sbcl`], [sbcl.org → Windows],
    [JDK 21], [`openjdk@21` / `openjdk-21-jdk`], [Adoptium MSI, PATH],
    [Git], [`brew/apt install git`], [git-scm.com],
    [Postgres], [`brew/apt` + service], [Installer from postgresql.org],
    [Maven wrapper], [`./mvnw …`], [`mvnw.cmd …`],
    [Line break in curl], [backslash `\`], [cmd: `^`; better PowerShell in one line],
    [Leave SBCL], [`(quit)` or Ctrl+D], [`(quit)`],
    [Docker], [Docker Desktop / engine], [Docker Desktop + WSL2],
    [Project in IDEA], [open the folder], [or `\\wsl$\Ubuntu\home\…`],
    [Where am I], [`pwd`], [`cd` with no args in cmd; `pwd` in Git Bash],
    [List files], [`ls -la`], [`dir` / `Get-ChildItem`],
    [Copy a file], [`cp a b`], [`copy a b`],
    [mvnw permissions], [`chmod +x mvnw`], [not needed: `mvnw.cmd`],
  )
])

#v(0.4em)

A rule that saves a month of life: on Windows *WSL2 immediately*, copy Java commands from the textbook into Ubuntu. IntelliJ can stay "windowed" and open a folder inside WSL. Postgres and Docker — better from one side of the wall too: either everything in WSL, or everything native. Two captains, remember.

If `localhost` from WSL can't see a database installed by MSI on Windows — that's not you being dumb. That's two worlds. Install Postgres in Ubuntu (`apt`) and live in peace.

PATH broke: close every terminal window. Not one. All of them. Open a new one. If that didn't help — reboot. This isn't shamanism, it's an environment cache that clutches a dead path like a treasure.

== G. If you're really stuck

Order, not panic:

1. Read the *first* error whole. Not a screenshot of the top half.
2. Check the folder: `pwd` / `ls`. Is the file there?
3. Check you called the right program: `which java`, `java -version`.
4. A minimal example: one function, not the whole server.
5. Then the AI roommate or a search. Put the error in the query, not "my spring doesn't work."

Stuck three days on Hibernate — that's the profession, not a sign to leave. Stuck three days installing a JDK — go back to the workshop, don't jump to month 3.

== H. What counts as "I finished the book"

Not the last page. This:

- on GitHub you can see the path from Hello to a server with a database;
- the README brings the project up on someone else's machine (or on your second OS);
- you honestly say what you didn't do;
- you go to interviews instead of stockpiling chapters.

An offer is not a button. The pages after month 6 are about letters and rejection, not one more framework. If you want one more framework instead of a letter — that's fear, not study. Understandable fear. The letter still has to go.
