#import "../lib-en.typ": *

= The workshop

#lesson(0, [Workbench, parentheses, and the green button])

Until you have a workbench, this book is just text you can't bite. Today we install tools and write one tiny program in each language. If something won't install — congratulations, you're already at work: read the *whole* error message, not just the first word.

This lesson can eat an entire evening. That's normal. Installing a JDK the first time is like finding a hatch in the dark: you swear, then you find it, then you wonder why the hatch was drawn on the map. Later evenings are shorter. This one is the cover charge.

#rhythm[
  Lisp: install SBCL, open the REPL, poke some plus signs. \
  Java: JDK 21, IntelliJ IDEA Community (or VS Code), "hello." \
  Git: name, email, two repositories, push to GitHub.
]

=== First, about Windows, Mac, and this WSL of yours

Further on, the book's commands look like Linux: `sbcl`, `java`, `curl`, `git`. On a Mac they really are that. On Windows there's a fork.

#os[
  *Mac.* Install Homebrew if you don't have it: https://brew.sh \
  Then everything through `brew install …`. The terminal is the ordinary one. Spotlight, the word Terminal, a black window. Not "the Windows command line" — you don't have one, don't look.

  *Windows — I recommend WSL2.* That's Linux inside Windows, no second machine. Win+S, "Turn Windows features on," check *Windows Subsystem for Linux*, reboot. Then from the Microsoft Store — Ubuntu. A black window opens, asks for a name and a password — that's Linux already. After that, copy almost every command from the textbook *there*. Update packages once:

  ```
  sudo apt update && sudo apt upgrade -y
  ```

  The password at `sudo` does not print as asterisks. That's not a bug. Just type blind and hit Enter. Linux is secretive like that.

  IntelliJ can stay on Windows: File → Open → `\\wsl$\Ubuntu\home\<you>\…`. Or live entirely in Ubuntu, whichever is easier. Docker on Windows installs as Docker Desktop and asks you to turn on WSL2 — agree, don't argue.

  *Windows without WSL* is also possible: SBCL and the JDK install with installers, Git is "Git for Windows," a lot of PowerShell looks similar. But paths with backslashes, `mvnw.cmd` instead of `./mvnw`, and `curl` is sometimes called `curl.exe`. If you get lost — WSL anyway. Seriously.
]

In the text, unless it says otherwise, commands are for *Mac and Ubuntu in WSL*. Native Windows is in appendix F.

#warn[
  Don't install "also Docker, also Postgres, also Android Studio" today. Three things: SBCL, JDK, Git. The rest — when a chapter asks. Greed for installers is the path to stew in `PATH` and to an evening that ended with Hello still unprinted.
]

=== Lisp: SBCL and a beast named REPL

Common Lisp is a language. SBCL is one of its implementations — decent, fast, no extra mysticism. There are many Lisp languages, like soups. We need one pot.

*Mac:*

```
brew install sbcl
```

*Ubuntu in WSL:*

```
sudo apt install -y sbcl
```

*Windows without WSL:* the installer from https://www.sbcl.org/platform-table.html — grab Windows, install, SBCL will show up in the Start menu.

Launch is the same everywhere:

```
sbcl
```

A `*` will crawl out. That's a REPL: it read, it computed, it printed, it waits again. Like a calculator you can explain games to. Exit: `(quit)`. On a Mac and in WSL, also Ctrl+D. On native Windows Ctrl+D may not work — type `(quit)` and don't play hero.

#slow[
  If after `sbcl` it said `command not found` / `is not recognized as an internal or external command` — the program isn't on PATH. On a Mac, open a *new* terminal window after brew. In WSL check `which sbcl`. On Windows without WSL — restart the terminal, sometimes the whole computer: the installer wrote the path, and the old window doesn't know. That's a classic. It's only embarrassing the first two times.
]

Type:

```lisp
(+ 2 3)
```

`5`. The operator is *in front*, then the arguments, all in parentheses. Looks like a mockery of math, but the rule is always the same: "do this thing with these things."

#repl-note[
  You wrote a list. The first element of the list is *what to do*. The rest are *with what*. Lisp does not look for a plus between the two and the three, the way school does. It looks for the plus at the front, the way a station looks for the captain on the bridge, not "well, anybody in the corridor."
]

Now break it. Type `(+ 2 3` without the closing parenthesis and hit Enter. SBCL will wait. It didn't hang. It's politely waiting until you finish the spell. Add `)` and Enter. Or hit Ctrl+C and start over. Remember: REPL silence after an open parenthesis is not death, it's "I'm still listening."

```lisp
(* (+ 1 2) 10)
```

First one plus two, then times ten. Parentheses are a tree, not decoration. There will be a lot of them. Later you'll start *not noticing* them, and that's the moment Lisp worked.

One more useful breakage:

```lisp
(1 2 3)
```

You'll get something like `illegal function call`. Lisp decided `1` is a function name. The number one took offense: it's a number, not a spell. To make a list *data*, not a call, you put a quote: `'(1 2 3)`. Remember the gesture. It comes back in week two and never leaves.

A string:

```lisp
"station MODULE"
```

Quotes — like in human language. Without quotes, `station` is a symbol, and Lisp will go looking for what function or variable that is, and not find it.

In Lisp, "yes" is written `t`, "no" is `nil`. The empty list is `nil` too. One `nil` for two roles. In Lisp that's fine. In life too, honestly. We won't say *true* and *false* after this: it sounds like a logic exam, and on the screen it's still `t` and `nil`.

```lisp
(= 2 2)     ; T
(= 2 3)     ; NIL
(not nil)   ; T
```

A semicolon is a comment to the end of the line. Lisp doesn't eat it. You eat it with your eyes.

#warn[
  Don't install ten Lisps "just in case." SBCL is enough. Emacs with SLIME is a sweet hole you'll fall into yourself when you're ripe. Today a black window is enough. Clojure, Racket, Scheme — neighboring universes. Later. If you install everything at once, the week's quest will be "which of the four REPLs did I open."
]

A file `hello.lisp` in the folder `lisp-experiments`:

```lisp
(format t "station MODULE on the line~%")
```

Load it into an already-open SBCL:

```lisp
(load "hello.lisp")
```

The path has to match *where* you launched SBCL from. If the file is in another folder — either `cd` there before `sbcl`, or a full path. "I have the file, Lisp can't see it" is almost always "you're in the wrong folder." There is no `(pwd)` in SBCL the way there is in bash; in the terminal *before* launch: `pwd`.

=== Java: wordy, but it feeds you

Check:

```
java -version
javac -version
```

You want 21 (seventeen is still alive, but 21 is better). `java` — run what's already cooked. `javac` — cook it. If you have `java` and no `javac`, you installed a JRE instead of a JDK. Fetch the JDK. On the station that's like getting a kettle with no coil.

*Mac:* `brew install openjdk@21` and, following brew's hint, put it on `PATH`. Often brew itself prints two lines of `sudo ln` or `echo '…' >> ~/.zshrc`. Copy them. Don't play hero with "I'll remember later."

*WSL:* `sudo apt install -y openjdk-21-jdk` — if the package isn't there, grab Temurin: https://adoptium.net (there's Linux and Windows).

*Windows without WSL:* the same Adoptium, MSI, check "add to PATH." After install, close PowerShell and open it again.

IntelliJ IDEA Community — from https://www.jetbrains.com/idea/download/ , there's Mac and Windows. Free. The green arrow runs `main`. VS Code works too, but then install the Extension Pack for Java. You can argue which is nobler after you have an offer.

Directory `java-basics`, file `Hello.java`:

```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("station MODULE on the line");
    }
}
```

Filename = class name. `Hello.java` and `class Hello`. If the file is `hello.java` and the class is `Hello`, on some systems you'll get lucky, on some you won't. Don't play luck. Capital letter, like Java in its passport.

From the terminal (Mac / WSL):

```
javac Hello.java
java Hello
```

On native Windows, the same, if `javac` is on PATH. If "is not recognized as a command" — PATH didn't stick, close and reopen the terminal, or WSL after all.

#slow[
  `javac Hello.java` makes a file `Hello.class`. That's not text anymore, that's bytecode for the JVM. `java Hello` — *without* `.class` in the command. Write `java Hello.class` — it'll take offense. Write `java Hello.java` on old JDKs — offense too. On 21 you can sometimes `java Hello.java` in one go, without `javac`. You can. Understanding that inside there are two steps, you still need: at work the build will be Maven, and there are more steps.
]

Java wants a class, `main`, and semicolons. Next to Lisp that's like filling out a form after talking to a friend. The jobs, though, look like this.

Break it on purpose. Remove the semicolon after `println(...)`. `javac` will write `';' expected` and a line number. That's the friendliest message on the station. Then put the semicolon back. Then put class `Hello` in a file `Bye.java` and see what it says. Then put it back. The goal is not a perfect file, it's a reflex: you read the error, you don't close it.

In IntelliJ: New Project → New Java Class → `Hello` → green arrow. If there's no arrow — click inside `main` with the mouse, a green triangle appears in the gutter with the line numbers. If "SDK not specified" — File → Project Structure → SDK → 21. The IDE is not a telepath: you have to tell it where the JDK is.

=== Git today, not "when it looks pretty"

Git is memory with versions. Not "the cloud." The cloud is GitHub, a separate company with a website. Git works without the internet. GitHub is for hanging the memory on a fence where a person with a job opening will look.

```
git config --global user.name "Vasya Module"
git config --global user.email "vasya@example.com"
```

The name is what to call you in the commit history. The email is the one on GitHub, otherwise the commit stars won't stick to the account. That's not a nitpick.

Git: on a Mac it's often already there, otherwise `brew install git`. In WSL: `sudo apt install -y git`. On Windows: https://git-scm.com/download/win — and then *either* Git Bash, *or* WSL again, where git is already the Linux one.

On github.com, make an account and an empty repository `java-basics`. No README checkbox if you're going to push an already-existing folder — otherwise GitHub creates a commit, you have yours, and they fight. Breaking up that fight later is boring.

Then:

```
mkdir java-basics
cd java-basics
git init
```

A `.gitignore` file (you can make it in an editor if PowerShell argues with `echo`):

```
*.class
.idea/
```

`*.class` — don't drag bytecode into git, it cooks from `.java`. `.idea/` — don't drag the IDE's settings, they're yours, not the station's.

```
git add .
git commit -m "Hello from week 0"
```

If git writes `Please tell me who you are` — you skipped `git config`. Do it and commit again.

Hook up the remote and `git push -u origin main`. GitHub tokens on Windows sometimes pop a window — agree, that's normal. On a Mac a browser may open. In WSL it sometimes asks for a Personal Access Token: GitHub → Settings → Developer settings → a token with the `repo` right. Paste it as the password. No asterisks again.

#slow[
  The branch may be called `master` instead of `main`. That's not you being dumb, that's git being old. Either `git branch -M main` before the push, or look on GitHub at what they named the empty repo. The main thing — don't push into the void and don't create a second "main" branch out of confusion.
]

If `push` was rejected because GitHub already has a README and you have no common ancestor:

```
git pull origin main --rebase
git push -u origin main
```

If that scares you — delete the empty repo on the site, make a new one *without* a README, push again. For week 0 that's more honest than an hour of merge rituals.

A second repository `lisp-experiments` with a file `hello.lisp`. Even one line. Two fences. Java on one, parentheses on the other. Don't dump everything in a pile called "school": in a month you won't find where the sensor is and where the server is.

#github[
  Two repositories, a commit each. A README of three sentences: who you are, what this is, how to run it. "Run" = a concrete command, not "well, in IDEA."
]

A README for `java-basics` right now:

```
java-basics
Programs from month one.

Run:
javac Hello.java
java Hello
```

Three lines. Already better than empty. You'll add more later.

=== How to talk to an error

A compiler and a REPL are nasty teachers. They're almost always right. Read the *first* error from the top. The line matters more than the feeling "everything died." If you pasted the error into search — paste it without your filename and without the pile of quotes you invented yourself.

#repl-note[
  An error is not a grade. The grade comes at the interview, and even then not for how many errors you got, but for whether you can read them. Today's drill: broke it, read it, fixed it, alive.
]

Frequent guests of week 0:

- `command not found` — no program, or no PATH.
- `';' expected` — Java wants a semicolon. Look at the line it named, and the line *above*: sometimes the compiler points at a *nearby* line.
- `cannot find symbol` — a typo in a name. `System.out` is not `system.out`. Java remembers case like an offended archivist.
- `illegal function call` in Lisp — a list without a quote that wanted to be data.
- `end of file on #<stream>` — a parenthesis not closed by the end of the file.

Don't tick ten "fix everything" checkboxes in the IDE without looking. One checkbox can rename the wrong thing. Read.

=== A map of the evening, if everything went sideways

Stuck on SBCL — leave Java for later, get Lisp to `(+ 2 3)`. Stuck on Java — leave Git, get `Hello` working. Git without Hello still has nothing to push except emptiness.

Nothing works — write three facts on paper: (1) which command, (2) the whole error, (3) which folder you were in. With that paper you can ask a neighbor, an AI, or a forum. Without the paper you'll get "well show the error," and you'll be ashamed twice.

#exercise("0.L1", "Lisp")[
  In the REPL: the sum from 1 to 5 with one `+`; the product of 2, 3, and 4; "ten minus three, then times two." Write the answers as a comment in `hello.lisp`.
]

#exercise("0.J1", "Java")[
  `Hello` prints your name and today's date (as a plain string for now). Run it from the IDE *and* from the terminal. If one of the two didn't work — that's the quest.
]

#exercise("0.G1", "Git")[
  A second commit, a push, open the page on github.com and see your files. If you didn't see them — not "later," fix it now.
]

#exercise("0.L2", "Lisp")[
  Break it on purpose: call `(+ 2 "station")`. Read the error out loud. Then call `(concatenate 'string "MODULE-" "1")`. The difference: plus adds numbers, strings glue another way. Write both errors as a comment — that's a station log, not shame.
]

#exercise("0.J2", "Java")[
  Add a second print line: how many compartments on the station (any number). Compile. Then change the number, *don't* compile, run the old `java Hello`. You'll see the old number. That's what `javac` is for. Then compile again.
]

#sunday[
  Draw on paper what happens when you hit Run. Where `java` comes from, where the `.class` goes. You don't have to guess down to the byte. You do have to start suspecting that the button isn't magic.
]
