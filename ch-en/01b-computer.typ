#import "../lib-en.typ": *

= How a computer works when you aren't a programmer yet

This chapter is for someone who has never written a program. At all. If you already installed a JDK and fought with `PATH`, skim it and go to the workshop. If the word `terminal` sounds like a threat from a hacker movie — sit down. Tea is allowed. A spacesuit is not required.

Station MODULE hangs in orbit and pretends to be smart. It is dumb as a hammer. A hammer doesn't think either. It hits wherever you sent it, even if you sent it into your thumb. A computer is the same: it obeys *exactly*, not "yeah, I got the idea."

What follows is slow. No digital electronics, no von Neumann architecture on a chalkboard, no feeling that you missed the first week of college. Just a kitchen, a pantry, and a black window that somehow scares everybody.

#slow[
  If a paragraph didn't click — read it out loud. The computer will not be offended. It doesn't feel anything. That's its superpower and its curse.
]

== A box that obeys, stupidly

A computer is a box. Inside: motors made of sand (almost true: chips are silicon). Outside: buttons, a screen, sometimes a sticker that says "don't pour coffee." You tell it what to do. It does *exactly that*.

"Exactly that" is the trap.

Tell a human "put the kettle on." They'll fill it, switch it on, wait, yell "ready." For a computer you have to spell it out:

1. Pick up the kettle.
2. If there's no water — fill it.
3. If there's too much water — pour the extra out.
4. Set it on the base.
5. Switch it on.
6. Wait until it boils *or* until five minutes have passed.
7. Switch it off.
8. If there is no kettle — don't sit there in silence. Say so.

Forget step 8 and the program will wait for a kettle until the heat death of the universe. Forget step 3 and you'll flood the galley. Forget "switch it off" and the coil burns out, and the flight engineer will become very eloquent.

This is not a metaphor "for kids." This is the job. A programmer is a person who writes lists like that and then wonders which step they forgot.

#rule[
  The computer does not guess. It did not "kind of understand." Either the instruction is there, or it isn't. There is no third option, even if you asked very politely.
]

On station MODULE it looks like this. You write: "open the airlock." The hardware opens the airlock. It will not ask "is anyone wearing a suit?" — not unless you wrote that. That's why half the programs on Earth are not "do the thing," they're "do the thing, *and check that we don't kill everybody*."

The instruction is called a *program*. Scary word, simple object: text (or almost text) the box knows how to run. Until it knows how — it's just a letter to yourself.

We aren't writing programs yet. First we look at *where* they live and *who* cooks them.

== The station galley

Picture MODULE's galley. Not a datacenter. A galley.

*The cook* is the processor, the CPU. He doesn't store anything for long. He *does*: chops, stirs, counts, compares. Very fast, very forgetful. Look away — he already doesn't remember how much salt. So there's a counter next to him.

*The counter* is RAM. What the cook is working with *right now*. Knives, a bowl, an open recipe, an onion half chopped. Lights out on the station — everything is swept off the counter. The recipe in the cook's head is gone too: the CPU has no "head for tomorrow."

*The pantry* is the disk. Hard drive, SSD, "laptop storage," a USB stick — for now they're one thing: the place where stuff still is after the lights go out. Jars of grain, jars of programs, jars of your vacation photos, which the station does not approve of. Fetching a jar from the pantry is slower than grabbing a bowl off the counter. So the cook does not sprint to the pantry for every spoon.

*The recipe* is the program. Text: what to do with the onion. The recipe lives in the pantry (a file on disk). When you "open a program," somebody copies the recipe onto the counter, and the cook starts working from it.

#slow[
  A file on disk is a jar in the pantry. A running program is the stew being stirred *right now* on the counter. Those are different things. A jar can sit for years. The stew goes cold the moment you switch the burner off.
]

A few more galley guests, briefly, no tour of the factory floor:

- *Screen and keyboard* — a window into the galley, and the mouth you yell at the cook with. The mouse is a finger that pokes pictures.
- *The network* — an elevator to other kitchens. Later. There will be mail.
- *The graphics card* — a separate cook for pictures. This book almost never needs it. Let it fry its own frames.
- *BIOS / firmware* — a note on the door: "how to light the burner when everything else is still asleep." Don't touch it until the station asks.

Why does a game stutter while Notepad doesn't? There's one cook (okay, several hands, but not infinity). The counter is small. If the recipe is huge, some jars have to stay in the pantry and get hauled back and forth. You can see the hauling: everything "thinks." That's not the computer not loving you. That's the pantry being far away and the counter being small.

#warn[
  "I have eight gigabytes of RAM, so I can keep eight gigabytes of tabs." You can. The cook will start sprinting to the pantry constantly. That's called swap, and it's sad. Close twenty chats. The station will say thank you.
]

An ordinary morning looks like this:

1. You switch the box on.
2. From disk rises the operating system — the master recipe, which then lets the others in.
3. You poke an icon.
4. The system finds the file in the pantry, copies what it needs onto the counter, tells the CPU: "cook."
5. The cook cooks until you close the window or the stew boils over (error, crash, "not responding").

An icon is a picture. A picture computes nothing. The file the picture *points at* computes. Sometimes it points at the wrong place. Then you get angry at the picture. Get angry at the path. We'll do paths.

== Files, folders, a path, and the tail with a dot

A file is a jar with a name. Inside: bytes. We'll poke bytes later. Right now: a file *lives somewhere*. "Somewhere" is a tree of folders.

A folder (catalog, directory — same thing in daily life) is a crate that holds jars and other crates. On a Mac people say "folder"; in the terminal, `directory`. Don't fear the synonyms. Pantry clerks love three words for one shelf.

A path is how you walk from the pantry entrance to the jar.

On a Mac and on Linux (and in WSL, which is Linux in a Windows coat) a path looks like this:

```
/Users/vasya/dev/lisp-experiments/hello.lisp
```

Read left to right, like a station corridor:

- `/` — the root, the main hatch.
- `Users` — the people compartment.
- `vasya` — your cabin.
- `dev` — the workbench.
- `lisp-experiments` — the crate with parentheses.
- `hello.lisp` — the jar.

On Windows without WSL, same meaning, different handwriting:

```
C:\Users\vasya\dev\lisp-experiments\hello.lisp
```

`C:` is a drive, like a separate warehouse. The slashes go *the other way*. Paste a Linux path into native `cmd` and it will take offense. That's why in this book, on Windows, we almost immediately go into WSL and write paths with ordinary `/`.

#os[
  *Mac.* Terminal → path like `/Users/…`. In Finder you can drag a folder onto the terminal window — it pastes the path. Lazy and correct.

  *Windows + WSL2 (recommended).* Inside Ubuntu your home is `/home/vasya/…`. Drive `C:` shows up as `/mnt/c/Users/…`. Live *in* `/home`, not on `/mnt/c`: otherwise Linux and Windows will fight about permissions and line endings like two mechanics over one wrench.

  *Windows without WSL.* File Explorer shows `C:\Users\…`. PowerShell understands both kinds of slash *sometimes*. Don't tempt fate: either WSL, or always backslashes and quotes around paths with spaces.
]

A space in a folder name is a petty villain. The path `my project` is two words to the terminal: `my` and `project`. Quotes save you: `"my project"`. Better still — don't put spaces in study folders. `lisp-experiments` sounds boring and never bites.

A filename often has a tail: `.txt`, `.java`, `.lisp`, `.pdf`. That's the *extension*. Not magic. Not a quality stamp. Just a pact: "guess from the last letters what to open this with."

- `note.txt` — "this is text, open it in a notepad."
- `Hello.java` — "this is text, but the Java compiler thinks it's its recipe."
- `hello.lisp` — "this is text, SBCL will be pleased."
- `photo.jpg` — "this is not text, don't open it in a notepad, you'll get garbage and tears."
- `archive.zip` — "a bundle of files in one jar, squeezed."

You can rename `Hello.java` to `Hello.txt`. The bytes inside *will not change*. Only the label changes. A notepad will open it and show the same code. `javac` may take offense: it looks for `.java`. The operating system looks at the tail when you double-click. A programmer looks *inside*, once they're already in the terminal.

#slow[
  An extension is a label on the jar. Not the taste of the stew. The stew is the contents. You can stick a lying label on. That's why a "broken file" with an `.mp3` tail happens. And the other way: a Java recipe saved as `.txt` is still a recipe, the burner just won't recognize it by its clothes.
]

Hidden files on a Mac and on Linux start with a dot: `.gitignore`, `.ssh`. Finder is shy about them. The terminal shows them if you ask `ls -a`. This is not a secret police. This is "don't clutter the ordinary list."

Two phrases everybody mixes up:

- *File not found* — the path is lying: a typo, the wrong folder, the wrong drive.
- *Permission denied* — the jar is there, the pantry clerk won't let you touch it. Rare in your own study folder. In system ones like `/usr`, `C:\Windows` — please don't play hero.

== Text, and "the computer understands"

Here's a surprise that saves you a year of life.

Almost everything you'll write in this book is *text*. Letters, parentheses, semicolons. The same sort of thing as a letter to your grandmother, only grandmother doesn't require `public static void`.

`Hello.java` opens in a notepad. `hello.lisp` too. `README.md` too. Even `.json` and `.xml` and `.html` — text. You can read text with your eyes. You can ruin text with one extra character.

A computer "understands" text unlike a human. A human sees "energy 80" and guesses the reactor. A computer sees bytes, turns them into numbers, numbers into commands. If the recipe has a typo — it will not fix it. It will say "I didn't get that" or, worse, it got *something else*.

#slow[
  There are two worlds.

  World 1: you look at a file and read words. That's for you.

  World 2: some program (compiler, interpreter, browser) *eats* that text by strict rules. That's for it.

  "The computer understood" means: the eater program chewed the text and didn't choke. It does not mean the meaning is good. You can perfectly chew the recipe "open the airlock with no check." The station will understand. The crew will too, but briefly.
]

Binary files are not text. A picture, music, a compiled program `Hello.class`, a Word document `.docx` (it pretends; inside it's zip). Open it in a notepad — a stew of glyphs. Don't fix that stew by hand. Pictures have other tools. `.class` belongs to Java; give it to Java.

Why IntelliJ and VS Code, then, if a notepad can do text? Because a code editor highlights parentheses, yells at typos, jumps to the error. A notepad is honest, but it's like repairing a reactor with an eyeglass screwdriver. You can. Once. Then get a real wrench.

One more pact: *encoding*. Letters in a file are numbers too. There will be a compartment for that. For now remember one thing: if you opened a file and instead of `naïve` you see `naÃ¯ve` — nobody hacked the station. Two pantry clerks are just reading the same jars with different tables.

== The black window, or why everybody needs a terminal

A terminal is a program where you *type commands as text*, instead of poking icons. The black (or dark grey) background is a habit from the seventies, when screens were green and the furniture was an ashtray. You can make it white. People will still call it "the black window."

Why, if you have Finder and File Explorer?

Because it's easier to tell a program "run this recipe with these jars" than to draw a button for every move. `javac Hello.java` is one sentence. In a menu it would be: File → Open → hunt through god-knows-where → Build → if the item is named something else in this version → give up.

Also because an error in the terminal is *text*. Text you can copy. Text you can search. A picture of "a red lamp in the IDE" sometimes hides the same text three clicks sideways. Learn to read the black window — and the IDE becomes a helper, not a priest.

#rule[
  A command is a program too. `ls` is a tiny recipe: "show what's in the crate." You launch programs all day, even when you "aren't programming."
]

The main idea of the terminal, without which everything else is a circus:

The window has a *current folder*. Current directory. "Where I'm standing in the pantry." Commands look *here* by default. Not "the whole computer." Here.

Show where you're standing:

```
pwd
```

Print Working Directory. Print the working directory. On a Mac and in WSL this is a holy command. The answer looks like:

```
/Users/vasya/dev
```

or

```
/home/vasya/dev
```

In native PowerShell `pwd` often works too (it's an alias). If it suddenly doesn't:

```
Get-Location
```

Show the jars in the current crate:

```
ls
```

List. A listing. On a Mac and in WSL, `ls` is native. In PowerShell `ls` is often there too (an alias for `Get-ChildItem`). Ancient `cmd` loves `dir`. If `ls` wasn't found — `dir`. Same meaning: what's lying *here*.

```
ls -la
```

On Linux/macOS: a detailed list, including the hidden ones with a dot. Columns of permissions, sizes, dates. Don't memorize them today. Just know that `-la` means "show me honestly."

Go into another crate:

```
cd lisp-experiments
```

Change Directory. Change the directory. Now `pwd` is different, `ls` is different. You *moved*.

One level up:

```
cd ..
```

Two dots — "the crate that holds the current crate." Like "step out into the corridor." One dot `.` means "here." Handy when a command wants a path: `./mvnw` means "the file `mvnw` *in this* folder."

Home:

```
cd
```

or

```
cd ~
```

The tilde `~` is your cabin: `/Users/vasya` or `/home/vasya`. Not the root of the drive. The cabin.

An absolute path — from the main hatch:

```
cd /Users/vasya/dev/java-basics
```

A relative one — from where you're standing. If you're already in `dev`:

```
cd java-basics
```

Both are correct. Confused — `pwd`, then think.

#slow[
  Most of "it can't find the file" is you standing in the wrong folder. Not "the computer erased it." Not "Java broke." `pwd`, then `ls`, then panic. On the station they call this ritual "look down at your feet."
]

Make a crate:

```
mkdir java-basics
```

An empty file (Mac / WSL):

```
touch Hello.java
```

In PowerShell `touch` may be missing. Then:

```
New-Item Hello.java
```

or open an editor and save. A file does not have to be born from a command. The command is just faster.

Print the contents of a text file:

```
cat Hello.java
```

In PowerShell often `Get-Content Hello.java`, or `cat` as an alias. If a stew of glyphs comes out — either it isn't text, or it's encoding (see below).

Clear the screen when the output is stew:

```
clear
```

In PowerShell also `cls`. Commands are not deleted from history, only from your eyes.

History: up arrow. Repeat a command without typing it. On a Mac and in WSL, also Ctrl+R — search history. A drug. Later you won't be able to live without it.

Interrupt a program that's hung and yelling:

Ctrl+C. Not copy (in a terminal, copy is usually Cmd+C / Ctrl+Shift+C, depends on the window). Ctrl+C is "stop, cook, put the knife down."

Leaving some programs: `exit`, or `(quit)` in SBCL, or Ctrl+D (end of input). If nothing helps — close the window. Brute force. Works.

#warn[
  Don't paste from the internet commands that start with `rm -rf /` or `del /s /q C:\`. That's "carry the whole pantry out the airlock." This textbook doesn't give you those. If someone did — that's not a mentor, that's a joker or worse.
]

== Three black windows: Mac, PowerShell, Ubuntu in WSL

Same idea: current folder, commands, text. Different furniture.

*Terminal on a Mac.* The Terminal app. Inside, usually zsh (it used to be bash — doesn't matter for us). Copy commands from this book here with almost no translation. Homebrew puts programs in places this terminal can see.

*PowerShell on Windows.* Blue or black. Can do a lot. Some Linux names are faked with aliases (`ls`, `pwd`, `cat`). Some aren't (`sbcl` appears only if you install it). Paths with spaces and `C:\`. You can live. A lot of textbook pain lives right here: the author wrote for a Mac, you've got PowerShell, one slash is wrong — and you think you're stupid. You aren't stupid. The dialect is different.

*cmd.exe.* Older still. `dir`, `cd`, backslashes. If you can not open it — don't.

*WSL2 + Ubuntu.* This is what I recommend if you have Windows. A subsystem: Linux *inside* Windows, no second machine and no eternal fight with slashes. The window looks like an Ubuntu terminal. `ls`, `pwd`, `apt`, `sbcl`, `javac` — like the textbook, like a server, like your neighbor on a Mac (almost).

#os[
  *How to turn on WSL2, short version.* Win+S → "Turn Windows features on or off" → check *Windows Subsystem for Linux* (and *Virtual Machine Platform*, if it's there). Reboot. Microsoft Store → Ubuntu. The first window will ask for a username and password — that's a *Linux* user, not your Windows password. The password at `sudo` does not print asterisks: that's normal, type blind.

  Then:

  ```
  sudo apt update && sudo apt upgrade -y
  ```

  After that, almost every command in the book goes *in this window*. Not PowerShell. Not cmd.

  Put textbook files in `/home/<you>/dev/…`. IntelliJ on Windows can open `\\wsl$\Ubuntu\home\<you>\dev\…`. Docker Desktop on Windows will ask for WSL2 itself — say yes.

  *Mac.* You don't need WSL. You already have Unix. Install Homebrew and breathe.
]

Why not "two systems in equal shares"? Because you'll be googling errors. Most of the answers are for Linux commands. Spring, Docker, the server at work — Linux. You can learn PowerShell. First, better learn the dialect the profession speaks.

#rule[
  On Windows: WSL2. Book commands — in Ubuntu. If something "is not recognized as a command" in PowerShell, ask yourself: is this the right window? Often it isn't.
]

One more mix-up: *where the file actually is*.

You downloaded `Hello.java` through a Windows browser into `Downloads`. In WSL that's `/mnt/c/Users/vasya/Downloads/Hello.java`. You can run it from there. Better copy it into `/home/vasya/dev/java-basics/`, so you aren't assembling recipes from someone else's warehouse through a hole in the wall.

Line endings: Windows likes `\r\n` (two characters: carriage return and newline). Linux and Mac — `\n`. Git sometimes yells `LF will be replaced by CRLF`. For study Java/Lisp this is almost never death. If a script "won't run" and prints a weird `^M` — that's it, Notepad's inheritance. In WSL: `file your.sh` will sometimes hint. You'll learn later. Today just know that *text is not always the same text*.

== Program, process, "it's running"

The file `Hello.java` is not a running program. It's a recipe in the pantry.

`Hello.class` isn't stew either. It's a recipe translated into a language more convenient for the Java burner. Still a jar.

When you type `java Hello` or hit the green arrow, the operating system:

1. Finds the right file.
2. Allocates a piece of counter (memory).
3. Gives the cook (CPU) a job.
4. Hangs a tag on that job: a *process*.

A process is *a recipe being cooked right now*, plus bowls (memory), plus a number in the queue.

The same file can be launched twice — you'll get two processes. Two notepads. Two `java Hello`. They don't share bowls unless they agreed to. Close one window — the other lives.

"The program hung" means: the process is still on the list, but it doesn't answer "how's the stew?" Sometimes it's computing (a heavy recipe). Sometimes it's waiting on the network. Sometimes it's waiting for you, and you can't see *what* it's waiting for. Sometimes it's dead, but the tag is still hanging.

"Not responding" in a Windows / Mac menu is a polite translation of "I knocked, nobody home." You can wait. You can force-quit. Force-quit is switching the burner off. The stew on the counter is gone. The jar in the pantry stays.

#slow[
  Quitting a program ≠ deleting a program.

  Close the window — stop cooking. The file on disk is still there.

  Delete the file — throw out the jar. A running process *may still live* (the recipe is already on the counter). Rarely matters in month one. Then suddenly it matters, when "I deleted it and it's still yelling."
]

Where several Java processes come from: IDEA itself, your program itself, maybe Maven too. That's normal. That's not "a virus." Task Manager / Activity Monitor will show names. The name `java` will be there a lot. Don't kill everything in a row: you can shoot the IDE.

A program can be a *server*: the process lives and listens. A browser knocks on it. Close the terminal where the server was running — the server often dies. That's why words like Docker show up later. Today it's enough: if the cursor is blinking in the window after a command — the program may be *waiting*. Don't open a second copy until you know whether the first is alive.

How to see what you launched in this terminal: it writes you lines. When it writes a prompt again (`$`, `%`, `*`, `PS C:\…`) — that command *finished*. If it doesn't write and doesn't return a prompt — it's still working, or waiting for input.

SBCL: the prompt is `*`. You're inside the `sbcl` process. `(quit)` — the process dies, you're back in an ordinary terminal.

== Compiler and interpreter — one stew, two burners

There's a recipe "say the energy." Here it is in two languages, tiny on purpose.

Lisp:

```lisp
(print (+ 40 40))
```

Java:

```java
public class Energy {
    public static void main(String[] args) {
        System.out.println(40 + 40);
    }
}
```

Both should print `80`. Same meaning. Different ritual.

An *interpreter* reads the recipe and cooks immediately. SBCL in REPL mode is like that. You start `sbcl`, see `*`, type:

```lisp
(+ 40 40)
```

Enter. `80`. No separate "translate the file." The cook looks at the parentheses *right now*.

#repl-note[
  You wrote an expression. SBCL read it. Evaluated it. Printed the result. Waits again. Read, Eval, Print, Loop. That's a REPL. Not a temple. A calculator you can explain the station to.
]

You can put the same thing in a file `energy.lisp`:

```lisp
(print (+ 40 40))
```

and say:

```
sbcl --script energy.lisp
```

Still no separate "build" file on disk that you run later. They read the script and did it.

A *compiler* first translates the recipe into another form, convenient for the machine (or a burner like the JVM), and *then* you run the translation.

```
javac Energy.java
```

`Energy.class` appeared. That's not text for you. That's bytecode for the Java machine. Then:

```
java Energy
```

`80`. If there's a typo in the `.java`, `javac` yells *now*, and the `.class` either isn't born or the old one stays. An old `.class` is a separate meanness: you fixed the source, forgot to compile, you're running yesterday's stew. That's why the green arrow in IDEA does both steps. In the terminal, remember there are two.

#slow[
  A compiler is a translator who works *before* dinner. It will catch a grammar error on the shore.

  An interpreter is a translator at the table. You say a sentence — they eat at once. An error on line three you'll see when you get there.

  Java feels "stricter" to a beginner, Lisp "more alive." At work both kinds show up. Even Java later interprets its bytecode, in a sense. Don't cling to a pure classification. Cling to the ritual: *do I need javac first*.
]

The same idea "add 40 and 40":

#align(center, block(width: 100%)[
  #set par(first-line-indent: 0pt)
  #set text(size: 10.5pt)
  #table(
    columns: (1fr, 1.2fr, 1.2fr),
    inset: 6pt,
    stroke: 0.4pt + rgb("#d0cbb8"),
    fill: (_, y) => if y == 0 { rgb("#e8e4d8") } else if calc.odd(y) { rgb("#faf8f2") } else { white },
    [*Step*], [*Lisp, SBCL*], [*Java*],
    [Recipe], [parentheses in the REPL or `.lisp`], [`Energy.java`, a class, `main`],
    [Translate ahead of time], [not required], [`javac` → `.class`],
    [Run], [Enter in the REPL or `--script`], [`java Energy`],
    [Typo], [error right in that phrase], [often already at `javac`],
    [Repeat], [up arrow], [fixed the file → `javac` and `java` again],
  )
])

#v(0.4em)

Why is Java so wordy with `public class` and `main`? Because the burner is big and loves forms. Why can Lisp be one line? Because the REPL already knows you want to "compute this." That doesn't mean Lisp is a toy. It means the on-ramp is lower. There are more Java jobs, though. That's why the book has both.

An IDE hides compilation. That's convenient. Once a week, run from the terminal so you don't forget *what* they hide. Otherwise the Run button becomes magic again, and we just took magic apart.

#warn[
  Don't confuse a file and a process and also the compiler. `javac` is a separate program. It worked and died. Then `java` is another program, another process. Two burners in one galley, a queue.
]

== Bits and bytes without a soldering iron

A computer loves two states: current / no current, pit / bump, yes / no. Convenient to call that 0 and 1. One such answer is a *bit*.

A bit is too small, like a crumb of salt. They pack them by eights: a *byte*. A byte can tell 256 variants apart (from 0 to 255). That's enough for a Latin letter, a tiny piece of a picture, a "which command."

After that, just labels, so you don't have to say "a million million":

- kilobyte (KB) — about a thousand bytes (sometimes 1024; pantry clerks argue, you don't care right now).
- megabyte (MB) — about a million.
- gigabyte (GB) — about a billion. A movie, a game, RAM.
- terabyte (TB) — a disk that says "come on, that's enough."

#slow[
  The number `80` in a program is not always one byte "eighty." For a human, 80 is two digits on paper. For a machine there are different boxes: a small integer, a big integer, a fractional. Java writes `int`, `double` — those are box sizes. Don't pick a box like a sommelier yet. Know this: *a number needs space on the counter too*.
]

The text `naïve` is several bytes in a row. A picture is a lot of bytes: the color of every dot. A song is even more, if you don't compress. Compression (zip, jpg, mp3) is "let's throw away repeats and what the ear won't notice." Sometimes it notices. Then artifacts.

A disk that's "full" means: the pantry ran out of shelves for bytes. RAM that's "gone" — no room on the counter for stew. Those are different shelves. A 512 GB disk does not cure a shortage of 8 GB of RAM. You can install a huge pantry and still trip over the counter.

Why does a programmer need this in month one? So you don't believe in magic sizes. So you understand: a `.class` file is bytes too. So "out of memory" doesn't sound like a curse, it sounds like "the counter is packed." So "corrupt file" means: the bytes aren't in the order the eater expected.

We will not convert numbers to binary in a column today. That's a charming sport. At a junior job they almost never ask. They will ask why you put a hundred-megabyte picture in git. Answer: bytes weigh, a repository is not a pantry for movies.

== Letters are numbers. UTF-8. Garbage glyphs

The keyboard lies. You think the letter `é` is flying into the file. What's flying onto the disk is a *number* that, by a table, means `é`.

The table is an encoding. A pact: which number is which letter.

There used to be many pacts, like dialects on a station after a century of isolation:

- ASCII — Latin letters, digits, signs. Enough for `Hello`, not enough for `naïve`, and definitely not for the old hull stencil `МОДУЛЬ`.
- Windows-1252, Latin-1, and a zoo of one-byte tables for other alphabets (Windows-1251, KOI8-R, CP866 for Russian — heroic, incompatible with each other).
- UTF-8 — the current world. Almost every letter on Earth, emoji, and signs you should not use in a variable name.

UTF-8: a Latin letter often takes 1 byte, `é` or a Russian letter takes 2, some ideographs and emoji take more. You don't need to remember that. You need to remember: *a file with no "I am UTF-8" sticker can be read with a different table*.

Mojibake, garbage glyphs — when bytes were written with one table and read with another. `naïve` in UTF-8, opened as Latin-1, turns into hell. Hell looks scholarly: `naÃ¯ve`. Or `����`. Or the old stencil `МОДУЛЬ` becoming `ÐœÐžÐ”Ð£Ð›Ð¬`.

#slow[
  Mojibake is not "the file died." The bytes are often intact. The *translator* is broken. Open it in the same editor, pick encoding UTF-8. Or resave. Don't retype the garbage "as is" — you'll get *new* bytes on top of the old mix-up, and then yes, the patient dies.
]

Practical rules for year one:

- In IDEA / VS Code look at the corner: it should say UTF-8. If not — set it.
- Textbook files, `.java`, `.lisp`, README — UTF-8.
- Don't copy code from Word or from a "smart" PDF where the quotes are fancy and curly instead of straight `"`. The compiler does not count curly quotes as quotes. To it they're just pretty blots.
- Filenames with non-English letters *can* work. They can also fail in old tools. Study files `Hello.java`, `module.lisp` — Latin, fewer surprises. Strings *inside* the file — any, UTF-8.

The terminal window has an encoding too. Rarely bites on a Mac. On old `cmd` it bit often. One more vote for WSL.

Java likes to write `\u00e9` instead of a letter — that's "the letter's number in the Unicode catalog." Unicode is a big catalog of characters. UTF-8 is one way to pack the number into bytes. You can live without passing this exam. You can just not paste into code a character you can't see: a non-breaking space from the web looks like a space and breaks everything. If "identical" strings aren't equal — suspect the invisible.

#warn[
  Saved a file "as ANSI" from Windows Notepad — a gift to your future self, with a grenade. Notepad learned UTF-8, but the menu items can still betray you. Watch *what* you save with.
]

== The network: two kitchens and mail

While the computer is alone — a galley. The network is a corridor between galleys.

Your machine. Their machine (a site, a server, a friend's phone). Between them, not "a tube of water," but a pact to send *packets*. A packet is an envelope: where to, where from, a chunk of data, a number "I'm part 4 of 10."

You open a browser, type an address. Cartoon version, no telecom diploma:

1. The browser asks: "who is `example.com`?" — like "which cabin does Vasya live in." DNS answers, a notebook of names. Name → number.
2. The number is an IP. The apartment address, not the last name.
3. An apartment has many doors. A door is a *port*. 80 and 443 — "browsers knock here for websites." 5432 — often Postgres. 8080 — your study server, when you get there.
4. Envelopes run down the corridor. They can get lost. The protocol (TCP — the one under the web) can ask again: "the fourth envelope didn't arrive."
5. The server reads the letter ("give me the home page"), puts the answer in envelopes going back.
6. The browser assembles the envelopes into a page.

#slow[
  `localhost` is "this same kitchen." Not the internet. The address of yourself. When you learn to stand a server up at home, the browser goes to `http://localhost:8080` like to the neighboring burner in the same galley. No cloud magic. One process listens at door 8080, another process (the browser) knocks on that door.
]

Wi-Fi dropped — the envelopes stopped moving. A program that was waiting for an answer can hang. That isn't always a bug in your `if`. Sometimes the letter just didn't arrive.

HTTP is the language of letters for the web: `GET /tasks` means "give me the list of tasks," `POST` means "accept a new one." JSON is often the *body* of the letter, text like `{"energy":80}`. Details will take months. Right now the picture: not "the site lives in the browser." The site lives on someone's machine. The browser is a window through which you read other people's jars.

A firewall is a picky doorman at the port doors. Sometimes your server is alive and the doorman won't let anyone in. Sometimes antivirus. Sometimes a corporate network. The message `connection refused` is "the door is closed, or nobody's there." `timed out` is "I don't even know if there's a door, the envelopes vanished in the corridor."

We are not configuring a router today. We are only killing the myth that the internet is a cloud with no addresses. There are addresses. There are doors. Letters sometimes get lost. Programs that go on the network have to think: "and if they didn't answer?"

#rule[
  Someone else's computer is not your pantry. You ask by letter. They can refuse. They can lie. They can not answer. That isn't an insult. That's a network.
]

== Errors are a gift

A beginner sees red and hears: "I'm unfit." A programmer sees red and hears: "here's the line."

A compiler, an interpreter, an operating system — creatures with no tact and no laziness. They don't hint. They write *what's wrong*, often even *where*. The first line of the error matters more than the last. The last is a tail, like panic in the corridor. The first is who yanked the sensor.

Sample gifts:

- `No such file or directory` — the path. `pwd`. `ls`. Not "Java died."
- `command not found` / "is not recognized as a command" — the program isn't installed, or the window is wrong, or `PATH` doesn't know which crate holds the jar with the command. `PATH` is a list of corridors where the system looks for programs. You install a JDK, forget PATH — `javac` "vanished." It didn't vanish. They aren't looking where you're standing.
- `cannot find symbol` in Java — a typo in a name, or you forgot an import, or the wrong file.
- Lisp `unmatched close parenthesis` — an extra parenthesis. A gift. Honest. Count them.
- `Connection refused` — nobody is listening at the door. The server isn't running, or the port is different.

#slow[
  An error is not a grade. It's a sensor on the station. The sensor yells because the air is running out, not because you're a bad person. Switch the sensor off (`catch` everything, ignore red in the IDE) — you'll die quietly in your cabin. Read the sensor.
]

What to do with your hands is always the same:

1. Read the *whole* first error. Not "the red word." The line.
2. Look at the line number in *your* file.
3. If it's a path — `pwd` and `ls`.
4. If the command wasn't found — either the window, or the install, or PATH.
5. Then search the internet. Copy the error *without* your username and without the unique path to your cabin. Otherwise you'll only find your own footprints.

It isn't shameful to "get an error." It's shameful to close your eyes and poke until it goes away by itself. At work it doesn't go away by itself. On MODULE even less: vacuum is patient, air is not.

#rule[
  You broke it — good. Means you weren't watching a video, you were touching the station. Fix it from the error text, not from your mood. Mood lies more often than the compiler.
]

== One shift in the terminal, slowly, out loud

Let's walk the same walk as if you're already at the desk. Don't install Java yet. Just feet in the pantry.

You opened a window. On a Mac, the left side often has the machine name and `~`. In Ubuntu inside WSL — `vasya@pc:~$`. The tilde is you're home. The `$` or `%` sign is "you may type a command." It isn't money.

```
pwd
```

Read it out loud. `/Users/vasya` or `/home/vasya`. That's the cabin.

```
ls
```

You'll see `Desktop`, `Documents`, `Downloads` — or the local names if the system named them that way. On a Mac, Finder and `ls` are one pantry, different view. Delete in Finder — it's gone in `ls` too. Not two worlds. Two windows.

Make a workbench:

```
mkdir dev
cd dev
mkdir module-cabin
cd module-cabin
pwd
```

Now the path should end in `module-cabin`. If not — you either created it somewhere else, or `cd` didn't work (typo in the name). `mkdir` is silent when it succeeds. Silence in a terminal often means "ok." Rude and familiar.

A file with text, Mac / WSL:

```
echo "station MODULE" > note.txt
cat note.txt
ls
```

`>` means "put the output in a file, wipe the old." If the file already existed — the old contents die. Two arrows `>>` — append at the end. For a study note, an editor is enough. `echo` is so you don't have to leave.

#os[
  *PowerShell.* `echo` exists. Redirect `>` exists too. File encoding can sometimes be UTF-16 — a surprise for anything that isn't boring ASCII. One more vote for study files being born in WSL or in a real editor set to UTF-8.
]

Go back at random:

```
cd ..
pwd
ls
```

You should see `module-cabin` as a folder, not be living inside it. Two dots — the most common dance of week one. Overshot — `pwd`. Not shameful.

== Words after the command: arguments and flags

`ls` is a program. `ls -la` is the same program, you passed it a note `-la`. The note is an *argument*. Minuses at the front are often called *flags*: "turn this mode on."

```
ls module-cabin
```

An argument without a minus is usually *what* to apply it to: show this folder, not the current one. The current one does not change. `ls x` — look in crate x. `cd x` — go into crate x. Different verbs.

`java Energy` — program `java`, argument `Energy` (a class name, not a `.class` file in the argument). `javac Energy.java` — the other way around, here it really is a file. Everybody mixes them up. You will too. Then you'll stop.

Tab — name completion. You start `cd mod`, hit Tab, the terminal finishes `module-cabin` if there's only one. If several — it beeps for another letter, or shows a list. This is not intelligence. This is the list of files already in the folder. Get used to it. Without Tab, life is longer by typos.

#rule[
  A command is a program name, then a space, then its arguments. Like Lisp, only custom puts the parentheses in, not you. A typo in an argument is already a different error, not "command not found."
]

== Who's the head cook: the operating system

macOS, Windows, Linux (Ubuntu in WSL) — these are not "different computers." The hardware is similar: CPU, RAM, disk. What's different is the *master recipe* that lets the others in: who draws windows, who reads the keyboard, who decides whether you may touch a file.

You can think of an operating system as the shift's head chef. You don't yell at the CPU yourself. You yell at the chef: "start this recipe." The chef gives the cook time, a piece of counter, the right to read a jar. Without a chef every program would fight over one bowl. That happened. It was called badly.

#slow[
  An icon on the desktop is not a program. It's a picture and a pointer: "chef, start this file." The terminal does the same, only you say the name yourself. Same chef.
]

Why then "the Mac command doesn't work on Windows"? Because the chefs handed out crate names and staff cooks differently. `ls` lives with a Unix chef. A Windows chef lived with `dir` for a long time. WSL is a *second chef in the same box*. That's why textbook commands paste there.

"Install a program" means: put files in the pantry and tell the chef where to look (often — add a corridor to PATH). An icon in the menu is a bonus. Uninstall — remove the files. Sometimes some old jars stay. That's "junk after uninstall," not a ghost.

== PATH, again, because everybody trips on it

You type `javac`. The chef does not telepathize. He looks at a list of folders: PATH. In each one — is there a file named `javac`. Found it — launched it. Didn't find it — `command not found`.

See the list (Mac / WSL):

```
echo $PATH
```

A stew of corridors, separated by colons. Don't memorize it. Know this: *the search goes left to right*. Two `java`s in different folders — the one whose corridor comes first wins. Hence "old Java in the terminal, new Java in IDEA."

```
which javac
```

(on Mac/Linux) — which jar it will take. Empty — it will take none. In PowerShell a close gesture: `Get-Command javac`.

#warn[
  Don't paste from chat "put this twenty-line sheet into PATH" if you don't understand *which folder* you're adding. A wrong PATH breaks commands that already worked. First — close and reopen the terminal after the installer. Often that's enough.
]

== Stdin, stdout, a pipe on your finger

A program, when you launched it from a terminal, has three pipes:

- *stdin* — this is where what you type flows. `Scanner` reads it.
- *stdout* — this is where it writes "ordinary" output. `System.out`, `format t`.
- *stderr* — this is where it yells errors. Often also on the screen, but it's a *different* pipe. That's why you can save output to a file and still see the errors.

```
cat note.txt
```

`cat` reads a file and shoves it into stdout. The screen caught stdout — you see the text. You can catch it with a file: `cat note.txt > copy.txt`. A pipe between programs is `|`:

```
ls | cat
```

Meaning for your finger: the left one's output became the right one's input. At work people live on this. Today it's enough to see the stick. Don't build a pipeline of ten commands "like an adult." First learn where you're standing.

#slow[
  When a program "waits and writes nothing," it is often waiting on stdin: for you to type something. Not a second launch. Type. Or Ctrl+C, if you didn't understand *what* it's waiting for.
]

== A letter as a number, again, with your fingers

Take Latin `A`. In ASCII that's the number 65. Little `a` is 97. Space is 32. The computer does not store "a pretty A." It stores 65, and the font on the screen draws a letter. Change the font — the number is the same.

The letter `é` in Unicode is another number (if you really need it: 233). UTF-8 packs that number into *two* bytes. Latin `e` is one. That's why a file with the word `naïve` weighs more than a file with `naive`. Not a bug. Arithmetic. The old hull stencil `МОДУЛЬ` is heavier still than `MODULE`. Same reason.

Compare in your head: "the file weighs 12 bytes" and "there are 6 letters." If it's UTF-8 and the letters are fancy — it adds up. If someone opened it as a one-byte table, there may be "more letters" or garbage: they slice two UTF-8 bytes as two *different* letters of the old table. That's mojibake in the kitchen, no information theory required.

A space and an "invisible space" from a website are different numbers. To the eye they're the same. To `equals` they aren't. When "I copied it exactly" and Java disagrees — suspect numbers, not fate.

== A URL — the address on the envelope

What you paste into a browser is text too. Not button magic.

```
https://httpbin.org/get?foo=1
```

Pieces:

- `https` — the *scheme*: how to talk. `https` is HTTP plus a cipher. `http` is without. For study it's enough: "the letters before the `//` are the mail rule."
- `httpbin.org` — the host. The kitchen's name. DNS will turn it into an IP.
- `/get` — a path on *their* machine. Like a folder, only theirs. Not your `/Users`.
- `?foo=1` — the query tail. Small `name=value` pairs. Sometimes that's where sessions — and leaks — get stuffed. Don't put passwords here.

`http://localhost:8080/tasks` — scheme http, host localhost (this box), door 8080, path `/tasks`. When you get to a server — this string will stop being a spell. Right now it's enough to be able to cut it.

A browser will hide the response body and *draw*. `curl` and Java's HttpClient show the body as-is: HTML or JSON as text. That's why "pretty in the browser, a stew of tags in curl" is not broken. The stew of tags *is* the page, until someone draws it.

== More gifts that look like insults

`Permission denied` — the jar is there, the chef won't allow it. Rare in your own `dev`. On `/usr/bin` — please. Don't `sudo` at every sneeze. `sudo` is "I'm the chef for five seconds." A mistake under sudo is a loud mistake.

`Address already in use` — the port door is taken. An old server is alive. Find the process, close it, or change the port. Don't reinstall the computer "just in case" as step one. You can, of course. That's like fixing a crack by rebuilding the station.

`Segmentation fault` / "the application quit unexpectedly" — the process died ruder than a Java exception. Rare in study Java. If SBCL died on recursion — you'll more often see text about a stack. Also a gift.

A red stripe in IDEA with no text — click the tab or the bottom Run panel. The same stack lives there as in the terminal. The IDE is not instead of the error. The IDE is a frame around the error.

== What to do with this today

Don't install ten languages yet. Install a habit:

1. Open a terminal (Mac: Terminal; Windows: Ubuntu in WSL if you have it, otherwise at least PowerShell and a plan to turn WSL on).
2. `pwd`. See where you're standing.
3. `ls`. See what you see.
4. `cd` into some folder you recognize with your eyes (Documents, `dev`, home).
5. `pwd` and `ls` again. You just drove a computer *with text*. That's the entrance to the profession, no romance required.

Next in the book — the workshop: SBCL, JDK, Git. Recipes there. Here was the kitchen. Without a kitchen, a recipe is poetry.

If something from this chapter is still fog — that's normal. The fog lifts when you've done `cd` a hundred times. A hundred is not an exaggeration. In a week the fingers will do it themselves.

== Fears you don't need to carry into the workshop

"I'll break the computer with a command." Study `ls`, `cd`, `pwd`, `mkdir`, `echo` don't break anything. `rm -rf` with the root does, and the habit of living under `sudo`. We don't go there. If you're scared — work in `dev/module-cabin`, not in system folders.

"The terminal is for hackers." The terminal is for people too lazy to draw a button for every recipe. Half the profession is text. The black background is makeup.

"I have to understand the processor down to the byte." You don't. You have to tell the counter from the pantry and a file from a process. Processor bytes can wait until you become the strange person who likes that.

"Windows means this textbook isn't for me." It means: WSL2. After that the textbook is for you. PowerShell is a spare hatch, not the main one.

"The file vanished." Usually: another folder, another drive, another chef (Windows vs WSL). `pwd`. Search by name in Finder / File Explorer. Rarely — you really deleted it. Recycle Bin exists. On disk, not in RAM.

"Encoding is for linguists." Encoding is why `naïve` suddenly became `naÃ¯ve`. One evening of fighting this saves a month of "I have garbage in my JSON."

"The network is a cloud, that's where sites live." Sites live on machines. Machines have addresses. Addresses have doors. Your `localhost` is a machine too, just you yourself.

"An error means I'm not one of those people." An error means a sensor fired. The people who are "one of those" are the ones who read the sensor. The rest buy a course labeled "no pain" and are surprised by pain at work.

#rule[
  A computer is dumb, precise, and not cruel. If it seems to be mocking you — almost always it's the path, the encoding, or the wrong current folder. Check those three, then the machine's personality.
]

The cloud, by the way. It isn't the sky. It's someone else's computer, rented out, and letters reach it down the same corridor. "Saved to the cloud" — you copied a jar onto their disk. Their disk fills up too. Their disk can lie about encoding too. Less romance than on the sticker.

The clipboard (copied — pasted) is not a file. It's a chunk of RAM with a short shelf life. Pasted into an editor and didn't save to disk — there's no jar in the pantry. Switched the box off — gone from the counter too. Beginners lose an evening of work on this more often than on hard algorithms.

#slow[
  Saved — pantry. Not saved — counter. Closed without a "save?" prompt — the chef sometimes asks, sometimes doesn't. Terminal `echo > file` saves at once: that's already a file. An editor with a dot in the tab name — often "not saved." Watch the dot.
]

Now you can go to the workshop. If your hands haven't done `pwd` yet — do it, then read about SBCL. Otherwise the workshop becomes a lecture again, and we just didn't give a lecture.

== A cheat sheet for the cabin wall

Don't learn it like a poem. Look when you forget.

#align(center, block(width: 100%)[
  #set text(size: 10pt)
  #set par(first-line-indent: 0pt)
  #table(
    columns: (1.1fr, 1.35fr, 1.55fr),
    inset: 5.5pt,
    stroke: 0.4pt + rgb("#d0cbb8"),
    fill: (_, y) => if y == 0 { rgb("#e8e4d8") } else if calc.odd(y) { rgb("#faf8f2") } else { white },
    [*What for*], [*Mac / WSL*], [*PowerShell, if you really must*],
    [Where am I], [`pwd`], [`pwd` or `Get-Location`],
    [What's here], [`ls` / `ls -la`], [`ls` or `dir`],
    [Go], [`cd folder` / `cd ..` / `cd ~`], [same; `cd ~` sometimes sulks],
    [New crate], [`mkdir name`], [`mkdir name` or `New-Item -ItemType Directory`],
    [Show text], [`cat file`], [`Get-Content file` / `cat`],
    [Path to a command], [`which javac`], [`Get-Command javac`],
    [Stop a program], [Ctrl+C], [Ctrl+C],
    [Leave SBCL], [`(quit)` / Ctrl+D], [`(quit)`],
    [Compile Java], [`javac Hello.java`], [same, if PATH is alive],
    [Run Java], [`java Hello`], [same],
    [Lisp right now], [`sbcl` then `(+ 40 40)`], [same, if SBCL is installed],
  )
])

#v(0.35em)

If the right-hand cell annoys you — that's a sign. Don't become a dialect translator in week one. WSL2.

Printing the cheat sheet is not shameful. Pretending you "just remember" `pwd` and hunting a file in the neighboring cabin for half an hour is. Station MODULE already has mechanics like that. Their mugs sit in the galley. The letter on the mug has worn off.

Once more, short, before the quests: the box obeys, stupidly; the cook is the CPU; the counter is RAM; the pantry is the disk; the recipe is a file; the stew on the burner is a process; the black window is how you talk to the chef in text; `cd` changes *where* you're standing; a compiler translates ahead of time, a REPL — at the table; letters are numbers; the network is mail; an error is a sensor.

If that paragraph already reads like home — the chapter worked. If not — don't cram it. Go back to the word that's still foreign and reread *that* compartment. The station does not exam you on a retelling. The station exams you on `pwd`.

The quests below are ten minutes, not a night. Do them before the workshop. Otherwise you'll start installing a JDK without being able to say which folder you're standing in. That's like looking for duct tape without opening the hatch.

Three quests. Not ten. If you want heroics — heroics in `cd` back and forth until the fingers remember.

Answers live in the answers chapter, like the other quests. Yourself first. Really.

Let's go.

#exercise("0b.1", "terminal")[
  Open a terminal (Mac / WSL Ubuntu / PowerShell if you must). Create a folder `module-cabin`, go into it, create a text file `note.txt` with one line `station MODULE`. With commands, show: where you are (`pwd` or equivalent), what's in the folder (`ls` or `dir`), the file contents (`cat` / `Get-Content`). Write into `note.txt` *as another line* the full path that `pwd` printed. If the path isn't what you thought — that *is* the quest, not a nitpick.
]

#exercise("0b.2", "kitchen")[
  On paper or in the same `note.txt`: for the action "run `Hello.java`," write who the cook is, what's on the counter, what's in the pantry. Three sentences, not an essay. If you wrote "the computer thinks" — erase it and replace with "the CPU executes instructions, RAM holds the current stuff, the disk stores the file."
]

#exercise("0b.3", "text")[
  Type the word `café` in a file. Save UTF-8. Open it in the same editor. Then deliberately open it with a *different* encoding, if the editor can (VS Code: bottom corner → Reopen with Encoding → something like Western Windows 1252). Photograph the garbage with your soul. Switch back to UTF-8. Write in `note.txt` why the letters "broke" even though you didn't erase them.
]

#sunday[
  Draw boxes: your machine, "their" machine, envelopes between them. Label `localhost` on your box. That's all the network you need so the word HTTP doesn't scare you later.
]
