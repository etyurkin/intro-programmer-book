#import "../lib-en.typ": *

= Month 1. The computer, more or less, obeys

By the end of week four you have your own Java console program — not a copied tutorial chapter, *yours* — and it lives on GitHub. There is no Spring, and that is a holiday. Lisp: names, "if", functions, the first game about a station that is always this close to falling apart.

Station MODULE has been hanging in orbit for about a hundred years, held together by duct tape, optimism, and three sensors that still work. You are the new mechanic. Congratulations. Spacesuit's in the locker. Someone already drank the coffee.

The first month is not "learn programming." It's the month the computer stops being furniture and becomes a creature you can ask questions — and it sometimes answers. Sometimes it yells. Sometimes it stays quiet, and that's worse.

Four watches. After each one — a commit, even a crooked one. Especially a crooked one.

#rhythm[
  Lisp: forty minutes in the REPL, until the parentheses stop looking like a joke at your expense. \
  Java: types, `if`, lists, objects, a file. Console, not a browser. \
  By the end of the month: a TODO that survives a power-off, and a README someone else can use to run it.
]

#lesson(1, [How to name a thing and how to tell it what to do])

#rhythm[
  Lisp: a symbol, `let`, `defun`, `if`, `cond`, ask a human. \
  Java: `int` / `String` / `boolean`, `if` / `else if`, `for`, `Scanner`. \
  Today's sensor is reactor energy. If it's zero, you can stop reading the textbook: the station will get very calm and very cold.
]

First watch. The hold smells like burnt duct tape and something that used to be coffee. On the wall a sensor blinks yellow — not because it's smart, because there's one bulb for every mode. The captain on the intercom said only: "we got energy?" You open the REPL like a toolbox.

=== Lisp: symbols, `defun`, `if`

In Lisp, names are *symbols*, almost like tags on crates in the hold. Not the string `"energy"`, not a memory cell with a sticker. A symbol. You can put it in a list, compare it, pass it around. For now, simple: hang a tag, put a number on it.

Globally (fine for our games) — `defparameter`. Locally, "only here" — `let`.

Open SBCL. On a Mac and in WSL that's just `sbcl`. On native Windows — the shortcut, or the same word in a terminal if PATH is alive. The asterisk `*` is the prompt, not multiplication.

Type this, *including the parentheses*:

```lisp
(+ 2 3)
```

You should get `5`. The operator comes first. That isn't a joke and it isn't a Polish-notation exam — Lisp is always like this: "do this thing to that thing."

Now a tag:

```lisp
(defparameter *energy* 100)
```

SBCL will answer something like `*ENERGY*`. It yells in caps because inside, symbols live without caring about case: `*energy*` and `*ENERGY*` are the same tag. The asterisks aren't syntax. They're a Lisper habit of shouting: "this is global, don't step on it." Like a wet-floor sign.

#repl-note[
  You didn't "create a variable" in the Java sense. You hung the value `100` on the symbol `*energy*`. Ask the symbol — you get a hundred. Hang something else — the hundred is gone. There's no `int` on the tag. Lisp doesn't watch whether you put a bolt in there or a nut. Yet.
]

Read it:

```lisp
*energy*
```

`100`. Without the asterisks it won't work: the symbol is literally called `*energy*`. Type `energy` and SBCL will say the variable is unbound. Translation: "there's no tag `energy` in this hold. There is `*energy*`."

Locally, not for the whole station:

```lisp
(let ((oxygen 40)
      (power 12))
  (+ oxygen power))
```

#slow[
  `let` is "make a pocket for the length of this parenthesis." Inside the pocket, two names: `oxygen` is 40, `power` is 12. The body is `(+ oxygen power)`. The result of the whole `let` is whatever the body returned, which is 52. Outside, `oxygen` means nobody again. After the `let`, try typing just `oxygen`. Error. The pocket collapsed. That isn't a bug. That's manners: don't leave nuts on the corridor floor.
]

Break it on purpose. Type:

```lisp
(let ((oxygen 40)
      (power 12))
  (+ oxygen power)
```

You're missing a closing parenthesis. SBCL will wait. The cursor blinks like a sensor nobody told to stop. Finish with `)` or Ctrl+C / get out of the mess with `(abort)` if you're already miserable. Lesson: parentheses are a tree, not decoration. Count them. Later you'll stop counting with your eyes and start feeling them.

Break it again:

```lisp
(let (oxygen 40)
  oxygen)
```

It will probably yell. `let`'s argument is a *list of bindings*, and each binding is its own little list `(name value)`. Without the inner parentheses Lisp has no idea where the name ended and the number began. It's like writing "nuts 40" on a crate with no divider: the clerk doesn't know if that's forty nuts or a nut named Forty.

Correct again:

```lisp
(let ((oxygen 40))
  oxygen)
```

`; => 40`

A function is a named spell:

```lisp
(defun report (energy)
  (if (>= energy 50)
      "reactor stable"
      "low energy"))
```

#slow[
  `defun` literally unpacks as define function. Then the name `report`. Then in parentheses, the parameter list — here, one: `energy`. This is not the global `*energy*`. This is a local tag: "whatever they handed me." The body is one `if`.
  `if` has three slots: the question, what to do if yes, what to do if no. The question: `(>= energy 50)` — is energy greater than or equal to fifty? If yes — the string about a stable reactor. If no — the string about low energy. The whole `if` *returns* a string. The function returns whatever the `if` returned. No printing. Yet.
]

Call it:

```lisp
(report 80)
(report 10)
(report 50)
```

Should be: stable, low, stable. Fifty passes because it's `>=`, not `>`. The kind of tiny thing stations turn into accidents.

#repl-note[
  `(report 80)` is a *call*. Function name in front, argument after, everything in parentheses. If you write `report(80)` like Java, Lisp will decide that `report` is a variable and `(80)` is a separate list it has to evaluate. Hurt feelings all around. Parentheses on the outside, name on the inside, arguments next to it. Always.
]

Forget the "no" branch of `if`:

```lisp
(defun report-broken (energy)
  (if (>= energy 50)
      "reactor stable"))

(report-broken 80)
(report-broken 10)
```

First call — a string. Second — `nil`. The station stays quiet. Sometimes that's worse than a siren. `nil` in Lisp is "no," "empty," "didn't work," "there is no list." One nothing wearing several hats. We don't say "false": the screen still prints `nil`.

Several rungs — `cond`:

```lisp
(defun status (n)
  (cond
    ((>= n 80) 'green)
    ((>= n 40) 'yellow)
    (t 'red)))
```

#slow[
  `cond` is a ladder of questions. Each floor: `(question answer)`. The first one that comes back non-`nil` wins; the rest don't even get a look. `t` at the end is "in every other case," the cosmic else. `t` in Lisp is "yes," the universal one. Not "true." The screen says `t`.
  `'green` is not a string. It's a *symbol*, a tag. The quote means: don't evaluate, pocket it as-is. Without the quote, Lisp goes looking for a function or variable called `green` and doesn't find one.
]

Check:

```lisp
(status 90)
(status 40)
(status 0)
```

`GREEN`, `YELLOW`, `RED`. SBCL yelling caps again. Same symbols.

Order of the rungs matters. Put `(t 'red)` first and everything is always red. A ladder whose first step is the floor. Try it, admire it, put it back.

Compare strings with `(string= a b)`. Numbers: `=`, `<`, `>`, `<=`, `>=`. The rest can wait. Life is long.

Three working examples, not one.

Example A. Docking:

```lisp
(defun dock-comment (speed)
  (if (< speed 5)
      "you can breathe"
      "dent incoming"))
```

Example B. Oxygen in a compartment — not energy, same gesture:

```lisp
(defun oxygen-ok (percent)
  (cond
    ((>= percent 18) 'ok)
    ((>= percent 12) 'masks)
    (t 'evacuate)))
```

Example C. Two sensors at once:

```lisp
(defun can-open-hatch (energy oxygen)
  (if (and (>= energy 20) (>= oxygen 18))
      'open
      'wait))
```

`and` — both. `or` — one is enough. `(not x)` — flip it. `nil` flips to `t`, everything else to `nil`. Yes, "everything else" in Lisp counts as "yes." Zero is "yes" too, unlike some languages that treat zero as a nobody. `(if 0 'yes 'no)` returns `YES`. Learn it on day one so you don't get surprised at three in the morning.

Ask a human in the REPL:

```lisp
(defun ask-number ()
  (format t "Enter a number: ")
  (finish-output)
  (parse-integer (read-line) :junk-allowed t))
```

#repl-note[
  `format t` yells into the terminal. `t` here is "standard output," not "yes," even though it's the same symbol. Life is complicated. `finish-output` — shove the letters out of the pipe *now*, don't hoard them until end of line. Without it, on some systems the prompt shows up *after* you've already typed something. Hilarious. Once.
  `read-line` listens until Enter and returns a string. `parse-integer` turns letters into a number. `:junk-allowed t` means "if there's junk after the digits, don't crash, take what you can." Type `12abc` — you get 12. Type `asdf` — you get `nil`. A shrug.
]

Call `(ask-number)`, type `42`, get `42`. Type `hello`, get `nil`. Then write a wrapper that doesn't trust `nil`:

```lisp
(defun ask-energy ()
  (let ((n (ask-number)))
    (if (numberp n)
        n
        (progn
          (format t "that's not a number~%")
          (ask-energy)))))
```

`numberp` — "is this a number?" The `p` tail on Lisper names is predicate, a yes/no question. `progn` — do several things in a row, return the last. Recursion "ask again" is a spoiler for lesson four, but for input it's honest: humans mash keys. It's their hobby.

#warn[
  Common parenthesis deaths today:
  `(defun report energy ...)` — parameters without their own parentheses. Need `(energy)`.
  `(if >= energy 50 ...)` — `>=` is a function, you call it with parentheses too: `(>= energy 50)`.
  An extra `)` at the end of `defun` — SBCL starts reading the *next* line as garbage. Look at *which* parenthesis it hates, not all of them at once.
]

One more REPL ritual. Type this on purpose:

```lisp
(1 2 3)
```

An error like `undefined function: 1`. Lisp decided this was a *call*: function `1`, arguments `2` and `3`. One takes offense. To keep a list a list, you need a quote: `'(1 2 3)`. That's lesson 2, but the error will surface today if your hand adds parentheses by itself. Now you'll recognize it.

=== Java: types that watch so you don't mix a bolt with a nut

In Java every box says what's inside. The compiler is a grouchy warehouse clerk. Not a REPL in the same sense: you write a file, compile, run, get yelled at. On the plus side, the clerk catches some of the stupidity *before* flight, not during docking.

```java
int energy = 100;
String name = "MODULE";
boolean ok = energy >= 50;
```

`int` — a whole number. `String` — text, capital S, because it's a class, not "just a digit." `boolean` — `true` / `false`. We don't translate those into "truth/falsehood" in code: the file will say `true` and `false`, and so will the job posts.

#slow[
  The line `boolean ok = energy >= 50;` is not an "if." It's an *expression* that itself becomes `true` or `false`, and you put that in the box `ok`. Later you can ask `if (ok)`. Or go straight to `if (energy >= 50)`. Both honest. The first is handy when you'll drag the condition somewhere else later.
]

```java
if (ok) {
    System.out.println("reactor stable");
} else {
    System.out.println("low energy");
}
```

Curly braces are a pen for code. The semicolon is "the sentence ended." Without it Java doesn't start the next sentence. It yells.

The class `Energy` lives in the file `Energy.java`, or Java gets offended. It does that a lot.

Input from the ground:

```java
import java.util.Scanner;

public class Energy {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.print("Energy (0-100): ");
        int energy = in.nextInt();
        if (energy >= 80) {
            System.out.println("green");
        } else if (energy >= 40) {
            System.out.println("yellow");
        } else {
            System.out.println("red");
        }
    }
}
```

#repl-note[
  `import` — "clerk, fetch the `Scanner` crate from the `java.util` room." Without the import the compiler doesn't know what `Scanner` is. `public class Energy` — the blueprint. `main` — the door that the command `java Energy` knocks on. `new Scanner(System.in)` — plug an ear into the keyboard. `nextInt()` — wait for a whole number. `else if` — the next rung, like `cond`. Order matters again: 80 first, then 40, then everything else.
]

#os[
  *Mac / WSL.* In the folder with the file:

  ```
  javac Energy.java
  java Energy
  ```

  *Windows without WSL.* Same, if `javac` is on PATH. If you get "is not recognized as an internal or external command" — JDK never got written into PATH. Close the terminal, open it again. Still no — install Temurin 21 with the PATH checkbox, or go to WSL, where `sudo apt install -y openjdk-21-jdk`.
]

A loop, so it ticks:

```java
for (int i = 0; i < 3; i++) {
    System.out.println("tick " + i);
}
```

It will print `tick 0`, `tick 1`, `tick 2`. From zero, like arrays, not like people. `i++` — add one after the pass. Three parts in the `for` parentheses: where to start, how long to spin, what to do after each round.

Three more examples, already not about energy.

Example A. Average of three temperatures — the same gesture as the quest, but with your eyes first:

```java
int a = 18, b = 21, c = 7;
double avg = (a + b + c) / 3.0;
```

`3.0` so the division is fractional. `(a + b + c) / 3` on integers chops the tail. Java's rule: integers on integers — integer. The clerk doesn't yell here. He *silently* steals the fraction. That's worse than an error.

Example B. Compare strings with `.equals`, not `==`:

```java
String cmd = "list";
if (cmd.equals("list")) {
    System.out.println("listing");
}
```

`==` on objects asks "is this the same box in memory?" not "do the boxes say the same thing?" Sometimes it works by accident. Then it stops. Then you'll spend three hours blaming the universe.

Example C. Several commands in `main` — already smells like lesson 2, but let `while` flash by:

```java
int n = 3;
while (n > 0) {
    System.out.println("left " + n);
    n = n - 1;
}
```

While `n > 0` — print and shrink. Forget to shrink — infinite loop, the terminal like a sensor nobody told to stop. Ctrl+C.

=== If it broke: Java yells, and that's normal

The compiler writes a lot. Read the *first* error, not the last. Often the first one births the rest.

*Class doesn't match the file.* In `Energy.java` you wrote `public class Energia`. It yells: class Energia is public, should be declared in a file named Energia.java. Rename either the file or the class. They are one creature.

*Forgot the semicolon.* The line `int energy = 100` without `;` — ';' expected. Java cannot guess where the thought ended. Put it there.

*Forgot the import.* `Scanner` without `import java.util.Scanner;` — cannot find symbol. A symbol is a name that isn't in scope. Not "magic broke." You're missing either an import, or you typo'd: `scanner` lowercase is already a different beast.

*Main not found.* You ran `java Energy`, but the method is called `Main` or it's missing `String[] args`. The door has to look like this: `public static void main(String[] args)`. Otherwise the JVM stands in the corridor and doesn't know where to knock.

*Brace.* `reached end of file while parsing` — you're missing a `}`. Count. In IntelliJ the highlight helps: click a brace, the other one lights up. If it didn't light up — it isn't there.

*You typed letters into `nextInt()`.* Not compilation anymore, already flight: `InputMismatchException`. Scanner waited for a number, got "pshh." We'll catch it in lesson 4. Today restart and type digits. Or read a string and parse it yourself — but that's a step later.

#warn[
  Don't paste "the missing pieces from three websites" into a file. One class, one `main`, it ran, then change it a line at a time. You don't assemble a station from three different blueprints on your knee. Well, you do, but then it doesn't dock.
]

Three working eye-runs before the quests.

1. Set energy to 80, 40, 39, 0. Four answers: green, yellow, red, red. If 40 gives red — you wrote `>`, not `>=`.
2. Swap the thresholds: `>= 40` first, then `>= 80`. Type 90. You'll get yellow, because 90 is also `>= 40`, and the second rung never gets a look. Order is not aesthetics.
3. Print `energy` before the `if` and after. The number doesn't change just because you talked about it. `if` doesn't spend energy. Spending is lesson 3.

#github[In `lisp-experiments` — `module-01.lisp`. In `java-basics` — `Energy`. A commit like `week1: energy status`.]

#exercise("1.L1", "Lisp")[
  `dock-ok`: docking speed. Under 5 — `"soft"`, otherwise `"too fast"`. Check on 3 and on 9. The station asks you not to ram the airlock.
]

#exercise("1.L2", "Lisp")[
  `airlock`: two pressures, inside and outside. Equal — `'open`, otherwise `'sealed`. Compare with `=`. Opening the hatch because it's "almost equal" is a bad comedy.
]

#exercise("1.L3", "Lisp")[
  `lamp`: energy 0..100. Return `'green` / `'yellow` / `'red` with the same thresholds as `status` in the text (80 and 40). Call it on 100, 80, 79, 40, 0. Five calls, five answers, in a comment next to them. If even one lies — thresholds or the order of `cond`.
]

#exercise("1.J1", "Java")[
  Three numbers — compartment temperatures. Print the average. If any one is below zero — also the word `ALARM`. Compute the average through `3.0`, or Java will chop the fraction as uninteresting.
]

#exercise("1.J2", "Java")[
  A game: the machine picks 1..10 (`Math.random()`), you guess once. "right" / "low" / "high". Almost Land of Lisp, only meaner, because you get one try.
]

#exercise("1.J3", "Java")[
  Energy from the keyboard, until the human gives a whole number from 0 to 100 inclusive. Letters and numbers out of range — prompt again, don't crash. For now `while (true)` and `break` when the number is honest is fine. `Scanner.nextLine()` plus `Integer.parseInt` is easier to catch than mixing `nextInt` with strings. If it broke on letters — that *is* the quest, not "later."
]

#sicp[Did it grab you that `if` in Lisp *returns* a value, instead of "doing a thing"? SICP is about expressions. Not now — when the itch won't let you sleep.]

#sunday[
  In the browser: `view-source:` and any site. That isn't Java. That's text someone executes later. Nice to feel yourself backstage.
]

The captain on the intercom again: "so how's energy?" You don't say "fine." You say `green`. The station starts to suspect you can read sensors. Someone still drank the coffee.

#lesson(2, [Boxes, lists, and an endless corridor])

#rhythm[
  Lisp: `quote`, `first` / `rest`, `cons`, `length`, `member`, `dolist`, a little `loop`. \
  Java: an array, `ArrayList`, `HashMap`, a loop over a collection. \
  Today's quest — a to-do list in the console. After you power off, everything is forgotten. Files — after the next lesson. The plot thickens.
]

Second watch. The station corridor isn't a metaphor, it's literally a corridor: airlock, then a tube, then the reactor, then the compartment that used to be a greenhouse and is now crates. On a scrap of paper the last mechanic left a list of rooms, written three times, three different ways. You decide the computer can at least be trusted with the order.

=== Lisp: lists — pretty much everything, actually

You write a list in parentheses. If you don't put a quote, Lisp decides it's a *call* and tries to call `1` as a function. `1` takes offense. You already saw this yesterday. Today it's a tool.

```lisp
'(1 2 3)
'(antenna corridor reactor)
```

#repl-note[
  The quote `'` is sugar for `(quote ...)`. `(quote (1 2 3))` and `'(1 2 3)` are the same: "here is data, don't touch it as code." Without the quote, `(antenna corridor reactor)` means: call the function `antenna` with arguments `corridor` and `reactor`. There is no function `antenna`. Error. With the quote it's just three tags in one box.
]

`(list 1 2 3)` — the same, but it evaluates the arguments first:

```lisp
(list 1 (+ 1 1) 3)
; (1 2 3)

'(1 (+ 1 1) 3)
; (1 (+ 1 1) 3)
```

In the second case `(+ 1 1)` just sits there as a list. Not a two. Quote freezes *everything*. `list` evaluates the pieces, then assembles.

Head and tail. A list, like a comet:

```lisp
(first '(a b c))  ; A
(rest  '(a b c))  ; (B C)
(first '())       ; NIL
(rest  '(a))      ; NIL
```

#slow[
  A list is not "an array of three cells." It's a pair: a head and *the rest of the list*. `(A B C)` is built as "A, and also (B C)." `(B C)` is "B, and also (C)." `(C)` is "C, and also empty." Empty is `nil` or `'()`. One nothing for everybody.
  That's why `(rest (rest (rest '(a b c))))` gives `NIL`. Took the head off three times — nobody left.
  The grandpas said `car` and `cdr`. Those are the same `first` and `rest`, they just sound like a breakdown. Old texts are `car`/`cdr` everywhere. We write `first`/`rest` so it doesn't look like the station was assembled in 1959. Although MODULE, honestly, might have been.
]

Type the chain, don't be lazy:

```lisp
(defparameter *rooms* '(airlock corridor reactor))
(first *rooms*)
(rest *rooms*)
(first (rest *rooms*))
(first (rest (rest *rooms*)))
```

`AIRLOCK`, `(CORRIDOR REACTOR)`, `CORRIDOR`, `REACTOR`. You just walked the corridor by hand. That's all of Lisp's poetry.

Stick an element on the front:

```lisp
(cons 'airlock '(corridor reactor))
; (AIRLOCK CORRIDOR REACTOR)
```

`cons` is the chief constructor of the universe. Not "add at the end." At the *front*. The old list doesn't change — you get a new one. Check:

```lisp
(defparameter *tail* '(corridor reactor))
(cons 'airlock *tail*)
*tail*
```

`*tail*` is still `(CORRIDOR REACTOR)`. `cons` didn't nail the airlock onto the old crate. It built a new one. That matters when we get to "a function doesn't wreck what you handed it."

#repl-note[
  `(cons 'x nil)` gives `(X)`. One element is still a list. `(cons 'x 'y)` gives `(X . Y)` — a dotted pair, not a "real" list. A real list ends in `nil`. Don't go building dotted pairs on purpose yet. If a dot shows up in the printout — you fed `cons` something that isn't a list as the second argument. Go back, put `'()` or another list.
]

Length: `(length lst)`. Is there a reactor: `(member 'reactor '(corridor reactor))` — returns the tail from the find, or `nil` if somebody already hauled the reactor out.

```lisp
(member 'reactor '(airlock corridor reactor))
; (REACTOR)
(member 'garden '(airlock corridor reactor))
; NIL
```

Not `t`. The tail. Convenient and annoying at the same time. "Found it? Then from here to the end." For a yes/no question people usually write `(not (null (member ...)))` — two negations around the find. Or `if` and live.

Walk it:

```lisp
(dolist (room '(airlock corridor reactor))
  (format t "room: ~a~%" room))
```

`~a` — print it like a human. `~%` — a new line. `dolist` doesn't build a new list, it *does*. For printing — exactly right. Recursion we leave for lesson four; today `dolist` is enough, and this:

```lisp
(loop for i from 1 to 5
      collect (* i i))
; (1 4 9 16 25)
```

`loop` in Common Lisp is a little language inside the language. You can love it, you can fear it. For squares — love it.

Another `loop` over a list with numbers — tomorrow's quest, today's hint:

```lisp
(loop for room in '(airlock corridor)
      for i from 1
      do (format t "~a. ~a~%" i room))
```

Two `for`s walk together. `do` — a side job (printing). `collect` — gather values into a result list.

Three examples so a list becomes a hand, not a theory.

Example A. A new room at the front of the map:

```lisp
(defun add-room (room rooms)
  (cons room rooms))
```

Example B. The second room, if there is one:

```lisp
(defun second-room (rooms)
  (first (rest rooms)))
```

For `'()` and `'(only)` you get `nil`. Don't crash. An empty corridor is also an answer.

Example C. Is the name there:

```lisp
(defun known-p (room rooms)
  (not (null (member room rooms))))
```

`(known-p 'reactor '(corridor reactor))` → `T`. `(known-p 'garden '(corridor reactor))` → `NIL`.

#warn[
  `(append '(a) '(b))` glues by *copying*. `(cons '(a) '(b))` gives `((A) B)` — a list in the head, not a join. If you expected `(A B)` and got parentheses inside, you grabbed the wrong function. You can poke `append` once today and not fall in love: for learning, `cons` + `reverse` is more honest, when you get there.
]

Break it. Type `(first 5)`. Error: 5 is not a list. `(rest 'reactor)` — a symbol isn't a list. `length` on a number — same. Lisp will not guess that you "meant a box." Put a box.

=== Java: an array, a list that grows, a pocket with labels

An array is a box with three nests, and nests don't appear out of thin air:

```java
int[] temps = {18, 21, 7};
temps[0] = 19;
for (int t : temps) {
    System.out.println(t);
}
```

#slow[
  `int[]` — "a row of integers." Curly braces at creation — the starting values. Index from *zero*: the first nest is `temps[0]`. The third is `temps[2]`. `temps[3]` — `ArrayIndexOutOfBoundsException`, a hand into the wall. The loop `for (int t : temps)` — "for each, don't think about the index." When you need the index — the old `for (int i = 0; i < temps.length; i++)`.
]

Array length is the field `.length`, not a method. On a string — the method `.length()`. On an `ArrayList` — the method `.size()`. Three names for one idea. Java likes you to trip and remember.

A list you can keep adding to — `ArrayList`:

```java
import java.util.ArrayList;
import java.util.List;

List<String> rooms = new ArrayList<>();
rooms.add("airlock");
rooms.add("corridor");
rooms.add("reactor");
System.out.println(rooms.get(1));
System.out.println(rooms.size());
```

#repl-note[
  `List<String>` — "a list of strings." Angle brackets — what beast we put inside. That's a *generic*, a word for the interview. Later you try `rooms.add(3)` — the clerk yells: 3 is not a string. `get(1)` — the second element, because zero. `size()` — how many there are now, not "how many fit." A lot will fit. Memory runs out before `ArrayList` says "no."
  Left side `List`, right side `new ArrayList`. The blueprint says "list," the hardware is "a list on an array." Don't think about why yet. Tomorrow it'll be the same with `Task` and `new Task`.
]

Throw away by number:

```java
rooms.remove(0);
```

Zero again — the first. People count from one. Your TODO in the quest has to talk to people: they type `del 1`, you do `remove(0)` inside. Forget — you'll delete the wrong line, and the antenna will wait another shift.

A pocket "key → value":

```java
import java.util.HashMap;
import java.util.Map;

Map<String, Integer> energy = new HashMap<>();
energy.put("reactor", 80);
energy.put("antenna", 20);
System.out.println(energy.get("reactor"));
System.out.println(energy.get("garden"));
```

#repl-note[
  `put` puts, `get` gets. No key — `null`, not an error. `null` is "nobody here," a meaner cousin of `nil`: call a method on it — `NullPointerException`. The station doesn't fall from space. It falls from "I thought there was a number there."
  `Integer`, not `int`, in the map's angle brackets: collections hold objects. Java will box `80` into an object and back by itself. Don't fear it yet. Don't put `null` in an `int` — it won't fit. It will fit in `Integer`, and then explode in arithmetic.
]

Walk the map:

```java
for (Map.Entry<String, Integer> e : energy.entrySet()) {
    System.out.println(e.getKey() + " " + e.getValue());
}
```

Key, value, pair. Don't memorize `Entry` as a separate science. It's "one pocket label for the length of the loop."

#warn[
  Don't learn every collection like a multiplication table. `ArrayList` and `HashMap` cover most of a junior's suffering. The rest will show up when you actually need it.
]

Today's Java game is a to-do list in the console. Add, show, delete by number. Like on a fridge, except the fridge is an array in memory, and after you power off everything is forgotten.

A sketch of the command loop — don't copy it blind, finish it yourself in the quest:

```java
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Todo {
    public static void main(String[] args) {
        List<String> tasks = new ArrayList<>();
        Scanner in = new Scanner(System.in);
        while (true) {
            System.out.print("> ");
            String line = in.nextLine().trim();
            if (line.equals("quit")) {
                break;
            }
            System.out.println("I only know quit so far, the rest is your quest");
        }
    }
}
```

#slow[
  `while (true)` — spin until `break`. `nextLine()` — the whole line, not one word. `.trim()` — cut spaces off the edges, people put them there. `equals`, not `==`. The prompt `>` is so it's clear the program is waiting, not hung. On the station, hung and waiting look the same if you don't blink.
]

Parsing the line `add fix the airlock`: first word is the command, the rest is the text. `split(" ", 2)` cuts into *two* parts: command and tail. Without the two, `"fix the airlock"` falls apart into three words, and the airlock gets lost.

```java
String[] parts = line.split(" ", 2);
String cmd = parts[0];
String rest = parts.length > 1 ? parts[1] : "";
```

The ternary `? :` is a one-line `if` that *returns* a value. Like Lisp. Sometimes handy. Sometimes people write a bedsheet with it. Today — two branches, fine.

=== If it broke: lists and input

*`cannot find symbol: ArrayList`.* No import. Two lines: `List` and `ArrayList` — both from `java.util`.

*`Index 3 out of bounds for length 3`.* Three elements — indexes 0, 1, 2. Did you subtract one? Didn't you? Print `size()` and the number the human sent, *before* `remove`.

*`InputMismatchException` from yesterday, today `nextLine` after `nextInt`.* If you mix `nextInt()` and `nextLine()`, Enter lives in the buffer, and an "empty command" arrives by itself. Today all input is `nextLine`. Numbers from text: `Integer.parseInt`. Catch `NumberFormatException` — say "a number, please" and keep spinning.

*Empty `add`.* The human typed `add` with no text. Decide: an error, or a task with an empty name. An empty name will explode your head later. Better "need a word" right now.

#os[
  Same launch: `javac Todo.java && java Todo` on a Mac and in WSL. On Windows `&&` in cmd.exe works in newer versions; if not — two commands in a row. IntelliJ: the green arrow on `main`. Don't keep two launches at once — two `Scanner`s on one input, a circus.
]

Three hand-runs before the quests.

1. An array of three temperatures, change the middle one, print them all. Make sure `temps[1]` is the middle.
2. `ArrayList`: three `add`, `get(0)`, `remove(0)`, print again. The first left, the former second became zero. Lists are dense, no holes.
3. `HashMap`: two modules, `get` of a real one and a made-up one. The second is `null`. Print that word with your eyes, make friends.

#exercise("2.L1", "Lisp")[
  `rooms-report`: a list of rooms, each with a number starting at one. `loop for room in lst for i from 1` is your friend.
]

#exercise("2.L2", "Lisp")[
  `has-reactor-p`: `t` if the list has `reactor`. The `-p` tail on Lisper names means "a question, yes or no." Cute, right?
]

#exercise("2.L3", "Lisp")[
  `prepend-airlock`: stick `'airlock` on the front of any room list with `cons` and return the new list. Don't change the old one — check that the original is the same after the call. Then `(length ...)` of the new one: one bigger. If length is the same — you returned the wrong thing.
]

#exercise("2.J1", "Java")[
  Commands: `add text`, `list`, `del number`, `quit`. They live in `ArrayList<String>`. Numbers from one, like people, not from zero, like arrays — you decide, just don't get confused.
]

#exercise("2.J2", "Java")[
  `HashMap` name → age. Print anyone over 18. Data hardcoded, input not required. The station is checking who is allowed on the bridge.
]

#exercise("2.J3", "Java")[
  A map room → energy (`HashMap<String, Integer>`). Print only those whose energy is strictly under 30. At least three keys in the data. Empty output is also an answer if everyone is fed; then lower one number and rerun so you see a line.
]

#github[Commit `week2: lists and todo`. Yes, a TODO in week two. Everybody started that way, even the ones who lie.]

At the end of the shift the corridor on the screen matches the corridor behind your back. Almost. The list still has `garden`, and behind the hatch — crates. The past lies in the data. You aren't repairing the station yet. You're repairing the list. That's already the job.

#lesson(3, [Functions that don't chatter extra])

#rhythm[
  Lisp: one function — one job, `let` inside, a little `mapcar`. \
  Java: a class `Task`, a box `TaskStore`, a skinny `main`. \
  Yesterday tasks were strings. Today they are *things* with fields.
]

Third watch. The captain doesn't want "strings on the fridge." A job should have a number, a name, and a mark "done." And energy shouldn't go negative when you fix the antenna. Negative energy on MODULE is not accounting. It's dark portholes.

=== Lisp: one job — one function

A good function does one thing and *returns* an answer. Printing — outside, if you can. Otherwise you never reuse the code, you only admire it in the terminal.

```lisp
(defun clamp (n lo hi)
  (cond
    ((< n lo) lo)
    ((> n hi) hi)
    (t n)))

(defun spend (energy cost)
  (clamp (- energy cost) 0 100))
```

#slow[
  `clamp` — squeeze a number between floor and ceiling. Below the floor — the floor. Above the ceiling — the ceiling. Otherwise the number itself. `spend` doesn't know how to clamp: it subtracts and asks `clamp`. If tomorrow you need to clamp 0..1, not 0..100, you fix one place.
  Call `(spend 10 40)`. Expecting −30? You get 0. The reactor doesn't do credit. `(spend 80 10)` → 70. `(clamp 150 0 100)` → 100. Three calls — three edges.
]

A few local names so you don't go mad:

```lisp
(defun docking-score (speed fuel)
  (let ((speed-part (if (< speed 5) 10 0))
        (fuel-part (if (> fuel 20) 5 0)))
    (+ speed-part fuel-part)))
```

#repl-note[
  Inside `let` the two pockets are computed *roughly at the same time* — don't lean on one from the other. Need a chain — `let*`. Today you don't need a chain: both pieces come from the arguments. The sum is docking points. The function stays quiet. Whoever calls it will print.
]

```lisp
(docking-score 3 30)
; 15
(docking-score 9 30)
; 5
(docking-score 3 5)
; 10
(docking-score 9 5)
; 0
```

Four combinations of two switches. A truth table, only about the airlock. If you're too lazy to check by hand — check anyway. Functions lie quieter than people.

Don't touch `&optional` yet. If you meet it — life brought it to you.

A function can take *another* function. Early, but seeing it once is useful, like a magic trick:

```lisp
(mapcar #'evenp '(1 2 3 4))
; (NIL T NIL T)
```

#slow[
  `mapcar` walks and applies. `#'evenp` — "the function evenp itself, not a call." Hash-quote is a pointer to a function. If you write `evenp` without `#'` in this spot, Common Lisp will often still treat it as a function symbol, but the `#'` habit will save you next to `lambda` in lesson five.
  The result is a new list of answers. The original `(1 2 3 4)` is intact. Again: we don't wreck the box, we assemble another.
]

If that lit you up — that's a bridge into SICP. If not — live in peace, we'll get to `mapcar` by hand later.

Two more neighboring gestures.

```lisp
(defun recharge (energy delta)
  (clamp (+ energy delta) 0 100))

(defun simulate (costs)
  (let ((e 100))
    (dolist (c costs)
      (setf e (spend e c)))
    e))
```

`setf` — hang a new value on a place. Here the place is the local `e`. `(simulate '(10 20 80))`: 100−10=90, 90−20=70, 70−80=0. Not negative. `dolist` walks, `setf` updates, at the end `e` is the answer of the whole `let`.

#warn[
  Printing inside `spend` is a favor that bites. Want to sum the costs without yelling — already can't, `format` is nailed on. Split: compute / print. `render` returns a string, `print-...` yells. Quest 3.L2 is exactly about that, not about pretty.
]

Break `clamp`: swap `lo` and `hi`. `(clamp 5 10 0)`. The `cond` ladder may return a miracle. Write two calls in the REPL until you see the lie. Then put it back.

=== Java: the blueprint and the hunk of metal

Yesterday tasks were strings. Today they are *things* with fields. How you tell a wrench from a rope, even though both "sit in a box."

```java
public class Task {
    private final int id;
    private String title;
    private boolean done;

    public Task(int id, String title) {
        this.id = id;
        this.title = title;
        this.done = false;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public boolean isDone() { return done; }
    public void complete() { this.done = true; }
}
```

#slow[
  A class is a blueprint. Until there's a `new`, there is no task in memory. `new Task(1, "fix the antenna")` — now it's hardware. Three fields. `private` hides: from outside you can't write `t.id = -7`. That isn't bureaucracy. That's so in a month you yourself don't assign `id = -7` at three in the morning.
  `final` on `id` — hung once in the constructor, don't touch it again. The title you can change (if you add a setter), the number — no. `this.id = id` — "this object's field = the parameter." Without `this` the names would collide and Java would shrug: assign the parameter to itself. Meaningless and quiet.
  Getters are holes outward "to look." `complete()` is a hole "to do." Not `setDone(true)` from the street — a verb. The task itself knows how to become done.
]

Two objects — two hunks of metal:

```java
Task a = new Task(1, "antenna");
Task b = new Task(2, "airlock");
a.complete();
System.out.println(a.isDone());
System.out.println(b.isDone());
```

`true` and `false`. Fixing the antenna doesn't close the airlock. Obvious in life. In code it's obvious only if these are *different* `new`s.

A box for tasks:

```java
import java.util.ArrayList;
import java.util.List;

public class TaskStore {
    private final List<Task> tasks = new ArrayList<>();
    private int nextId = 1;

    public Task add(String title) {
        Task t = new Task(nextId++, title);
        tasks.add(t);
        return t;
    }

    public List<Task> all() {
        return tasks;
    }
}
```

#repl-note[
  `nextId++` — give the current number, then add one. First task — id 1, second — 2. The list inside is `private`. From outside, no `tasks.add` past the register: only through `add(title)`, so the number always comes from the shop, not a guest off the street.
  `all()` currently hands back *the same* list, not a copy. A guest can do `store.all().clear()` and you will cry. In lesson 7, `List.copyOf` shows up. Today, notice the smell. You can return a copy already if your conscience itches: `return new ArrayList<>(tasks)`.
]

`main` gives orders. The rules live in `Task` and `TaskStore`. If `main` is longer than the screen, the station looks at you with reproach.

```java
public class TodoApp {
    public static void main(String[] args) {
        TaskStore store = new TaskStore();
        store.add("fix the antenna");
        store.add("close the hatch");
        for (Task t : store.all()) {
            System.out.println(t.getId() + " " + t.getTitle());
        }
    }
}
```

Three files: `Task.java`, `TaskStore.java`, `TodoApp.java`. Three blueprints. Compile them all:

```
javac Task.java TaskStore.java TodoApp.java
java TodoApp
```

IntelliJ will compile them itself. In the terminal, forget one file — `cannot find symbol: class TaskStore`. Not "Java broke." A classmate is missing.

#rule[
  Pull a chunk into a method as soon as `main` starts to feel ashamed. In two months the same instinct won't let you stuff a whole life into a Spring controller.
]

Lookup by id — a hand you'll need in the `done` quest:

```java
public Task findById(int id) {
    for (Task t : tasks) {
        if (t.getId() == id) {
            return t;
        }
    }
    return null;
}
```

Found — return it. Not found — `null`. Call `complete` on `null` — boom. So in `done`: find first, then `if (t == null) { say so; } else { t.complete(); }`.

#warn[
  `==` for `int` — correct, those are numbers. `==` for `String title` — the trap again. Compare string fields with `.equals`. Id is a number, breathe easy.
]

=== If it broke: objects and several files

*`The public type Task must be defined in its own file`.* Two `public class`es in one `.java`. Either drop `public` on the second (don't), or two files. One public class — one file with the same name.

*`constructor Task in class Task cannot be applied to given types`.* You called `new Task("antenna")`, and the constructor wants `(int, String)`. The number doesn't appear by itself — `TaskStore` hands it out.

*`id has private access`.* You're writing `t.id` from `main`. Go to `getId()`. That's what the hole is for.

*Tasks with the same id.* You `new Task` in `main` by hand and put ones yourself. Then `done 1` marks the wrong one. Let only `nextId` hand out numbers.

*`javac TodoApp.java` alone, without the others.* In the same folder the dependency `.java` files have to sit, or already `.class`. Easier to compile `*.java` (Mac/WSL). On Windows in cmd: `javac *.java` often works too.

Three runs.

1. Two `add`, print the ids. Expect 1 and 2, not 0 and 1. If zeros — `nextId` started at zero, people on the station count from one, the captain will yell.
2. `complete` on the first, print `isDone` of both. Only the first is `true`.
3. `findById(99)` — `null`. Print it explicitly `System.out.println(store.findById(99));` — you'll see the word `null`. Make friends before it shows up in Spring.

#exercise("3.L1", "Lisp")[
  `spend` and `recharge`: energy 0..100. `simulate`: a list of costs, start at 100, return what's left. Don't go negative — the reactor won't appreciate it.
]

#exercise("3.L2", "Lisp")[
  `render-room` returns a string. `print-rooms` only prints. Split "what to say" from "how to yell into the terminal."
]

#exercise("3.L3", "Lisp")[
  Take `docking-score` from the text into your own file and add a third parameter `angle` (approach angle). If the absolute value of the angle is under 10 — another +3 points. Check four or five combinations in the REPL, write the results as comments. Absolute value: `(abs angle)`.
]

#exercise("3.J1", "Java")[
  Yesterday's TODO — on `Task` and `TaskStore`. The command `done number` marks a task. The number is that id, not "the third from the end, I can feel it."
]

#exercise("3.J2", "Java")[
  A field `priority`. `list` prints priority, id, title. Sorting can wait until tomorrow. Today at least you can see that the antenna matters more than "wash the porthole."
]

#exercise("3.J3", "Java")[
  `TaskStore.findById`. No task — print `missing`, not an NPE. The command `show number` uses this method. Two files minimum: logic in the store, input in `main`. If `findById` lives in `TodoApp` — you hid the clerk in the hatch guard.
]

#sicp[Hiding fields is the same gesture as "constructors and selectors" in SICP. Scheme instead of Java, same idea.]

By the end of the watch a task has a name and a number, energy has a floor and a ceiling, and `main` has a chance to slim down. The captain asks: "and after a reboot, is the list alive?" You honestly say "no." Tomorrow — the disk. Today — objects. Don't jump ahead, even if it itches.

#lesson(4, [Recursion, files, and "say it out loud"])

#rhythm[
  Lisp: stop on an empty list, a step on the tail, a scrap of paper. \
  Java: `Files`, `Path`, `try` / `catch`, not an empty `catch`. \
  Week check: ten minutes out loud without peeking at the code.
]

Fourth watch. At night the lights blinked — scheduled, MODULE does that once a day, nobody knows why. The TODO in memory died. The captain said the word "file" like it was a spell of an older race. It isn't a spell. It's letters on a disk.

In parallel, Lisp wants you to learn to walk a list without `dolist`, on your own feet. Not to replace `loop`. So something clicks in your head: a list is a nesting doll.

=== Lisp: a function that bites its own tail — on purpose

Recursion: you call yourself on a *smaller* piece. A list: empty — stop, otherwise do something with the head and repeat with the tail. Like cleaning a corridor: one room, then the rest.

```lisp
(defun count-rooms (lst)
  (if (null lst)
      0
      (+ 1 (count-rooms (rest lst)))))
```

#slow[
  Lay `'(a b c)` out on paper. Actually lay it out.
  `(count-rooms '(a b c))` = `1 + (count-rooms '(b c))`
  `(count-rooms '(b c))` = `1 + (count-rooms '(c))`
  `(count-rooms '(c))` = `1 + (count-rooms '())`
  `(count-rooms '())` = `0`, because `(null lst)` — "nobody left here."
  Assembly backwards: 0, plus 1 is 1, plus 1 is 2, plus 1 is 3.
  Without paper, half the people decide this is magic. It isn't magic. It's nesting dolls.
]

Call it:

```lisp
(count-rooms '())
(count-rooms '(airlock))
(count-rooms '(airlock corridor reactor))
```

0, 1, 3. If the empty one errored — no stop. If the three spins forever — you aren't doing `rest`, you're biting the same list.

Sum with the same gesture:

```lisp
(defun sum-list (lst)
  (if (null lst)
      0
      (+ (first lst) (sum-list (rest lst)))))
```

`(sum-list '(10 20 80))` → 110. Head plus the sum of the tail. Stop is zero, because the sum of nobody is zero. For a maximum the stop is *not* zero: the maximum of an empty list is a philosophical fight we will lose. So `max-list` in the quest — the list is non-empty. Stop: no tail, the answer is the head.

#repl-note[
  Forget the stop or `rest` — sooner or later SBCL will write `Control stack exhausted`. Translation: "I got tired of repeating your spell." The stack is a pile of unclosed calls. Each call without `rest` puts down another plate. The plates run out. Ctrl+C, fix the stop.
]

One more layout, already about a filter — the idea of quest 4.L2:

```lisp
(defun filter-positive (lst)
  (cond
    ((null lst) nil)
    ((> (first lst) 0)
     (cons (first lst) (filter-positive (rest lst))))
    (t (filter-positive (rest lst)))))
```

#slow[
  Empty — empty. Head positive — `cons` it onto the filtered tail. Head negative or zero — *don't* put it, return only the tail. `(filter-positive '(3 -1 4 0 -8))` should give `(3 4)`. Zero is not greater than zero, into space. Negatives too.
  If you forgot `cons` and only write recursion — you get `nil`, you threw everything away. If `cons` without recursion — one element. Two pieces: what to do with the head, and always the tail.
]

`mapcar` already knows how to walk a list. Write your own recursion until it clicks. Then you can be lazy with culture.

Break it for fun:

```lisp
(defun bad-count (lst)
  (+ 1 (bad-count lst)))
```

Don't call it on a long one. Call it on `'()` and regret it fast. No `rest`, no stop. A training fire.

Tail-call optimization, accumulators — not this month. If you read it on the internet and it itches: you can. If you didn't read it — live. The main thing is the stop and a smaller piece.

=== Java: when the disk says "no"

The file didn't open, a human typed "pshh" instead of a number — Java throws an *exception*. Catch a specific one, not "everything in a sack."

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class TaskFile {
    public static void save(List<String> lines, Path path) throws IOException {
        Files.write(path, lines);
    }

    public static List<String> load(Path path) throws IOException {
        if (!Files.exists(path)) {
            return new ArrayList<>();
        }
        return Files.readAllLines(path);
    }
}
```

#slow[
  `Path` is "where it lives," not the pile of bytes itself. `Path.of("tasks.txt")` — a file in the process's *current* folder. The current folder in IDEA may not be the one you think: look at Run Configuration → Working directory. Otherwise you'll save into the project root or into `out/`, then "the file vanished."
  `throws IOException` — honest: "I might trip on the disk." The method doesn't pretend to be all-powerful. Whoever calls it decides.
  No file on `load` — empty list, not a crash. First launch of the program on a fresh station: there's no file, and that isn't an accident.
]

In `main`:

```java
try {
    TaskFile.save(titles, Path.of("tasks.txt"));
} catch (IOException e) {
    System.err.println("could not write: " + e.getMessage());
}
```

#repl-note[
  `try` — a pen where it might blow. `catch` — what to do if *exactly this* blew. `System.err` — the stream for yelling, not for ordinary output. In a simple terminal it looks the same. Later in logs (month 2) they'll split.
  `e.getMessage()` — a short complaint. Sometimes the whole `e.printStackTrace()` is useful — the pile of who called whom. This week a message plus "the file didn't write" is enough.
]

On Windows you can still write the path as `tasks.txt` in the current folder. Don't feed `Path.of` a `C:\` unless you have to. Backslashes in a Java string are hell: `"C:\\Users\\..."` or better `"C:/Users/..."`. Or don't. A relative path.

#warn[
  An empty `catch (Exception e) {}` — hide the fire under a rug. The rug will catch later, in the demo. Catch `IOException` and `NumberFormatException` where they live, not "everything."
]

`Scanner.nextInt()` on letters yells `InputMismatchException`. Catch it and ask again. Or, like in lesson 1, read a string:

```java
String raw = in.nextLine().trim();
try {
    int n = Integer.parseInt(raw);
    // n is honest
} catch (NumberFormatException e) {
    System.out.println("that's not a number");
}
```

#os[
  The file will appear wherever you launched the JVM from. Mac/WSL: `pwd` before `java TodoApp`. Windows PowerShell: `pwd` too. Found `tasks.txt` in a weird place — not magic, the working directory. Move the launch or spell the path once, write it in the README.
]

The format on disk is dumb and honest: one task — one line. Priority later, when the basics breathe. Today:

```
fix the antenna
close the hatch
```

You read the lines → for each, `store.add(line)`. Ids will be handed out again 1, 2, 3. After a restart the numbers may not match "how it was on paper yesterday" if you deleted from the middle. For week 4 that's ok. Say it in the README, don't hide it.

Write on `quit`:

```java
List<String> titles = new ArrayList<>();
for (Task t : store.all()) {
    titles.add(t.getTitle());
}
TaskFile.save(titles, Path.of("tasks.txt"));
```

Don't forget: `save` throws, `quit` has to be in a `try`. Otherwise "exit" crashes and nothing is saved — a mean irony.

=== If it broke: files and exceptions

*`Unhandled exception: IOException`.* The method calls `save`, but itself neither `throws` nor `try`. The compiler is right. Either propagate, or catch. In `main` you usually catch: the user doesn't need a stack as the only answer, but you also can't stay quiet.

*`NoSuchFileException` on write.* The directory isn't there. `tasks.txt` in a folder `data/`, and you never created `data/`. Either write in the current one, or `Files.createDirectories`. For now — current.

*Cyrillic as garbage characters.* Rare on Java 21, but if you opened the file in Notepad with the wrong encoding — don't blame `Files`. IntelliJ and a modern terminal are usually UTF-8. Old cmd.exe can be a circus. WSL and macOS Terminal are calmer.

*`AccessDeniedException`.* The file is open in Excel / Notepad with a lock, or the path is in "Program Files." Don't write into system folders.

Two disk runs.

1. Save two lines, quit the program, open `tasks.txt` with your eyes in an editor. The letters right? Good. Wrong — encoding, or the wrong file.
2. Delete the file, launch, don't crash, add one task, `quit`, the file is born. First day on the station.

=== Week check: a cat will do

Ten minutes out loud — to a cat, to a voice memo, whatever. How `TaskStore` is built, where the list is, where the file is, what if there's no file. Can't do it without peeking at the code — rename the methods so the story starts moving. Names you're ashamed to say out loud are usually a lie too.

A cheat sheet for the voice, don't read off the page — check that you remember:

- A task is an object, not a string. It has id, title, done.
- The store holds the list and hands out ids.
- The file is a spare brain for when the lights blink.
- A Lisp list is a head and a tail, recursion stops on `nil`.

If you stall on "well there's an ArrayList" — not enough. Say *why* the store, not `main`.

#exercise("4.L1", "Lisp")[
  `max-list` by recursion, list non-empty. No `apply` and no `reduce`. Bare hands, like a mechanic.
]

#exercise("4.L2", "Lisp")[
  `filter-positive`: only numbers greater than zero. Recursion. Negatives can fly into space.
]

#exercise("4.L3", "Lisp")[
  `rooms-length` — your own `length` through recursion, without calling `length`. Check against `(length lst)` on `'()`, `'(a)`, a long list. If they disagree — the stop or `rest`. Bonus: `find-room`, which returns the tail from the find, like `member`, also by recursion.
]

#exercise("4.J1", "Java")[
  On `quit` write `tasks.txt`, on start read it. One task — one line. No file — live with an empty list, don't crash.
]

#exercise("4.J2", "Java")[
  README: how to run, which commands, a sample session. This is not "later." Without a README your program is a box with no hinge.
]

#exercise("4.J3", "Java")[
  In the README a separate paragraph "if it broke": no JDK, `cannot find symbol`, no file at start, `InputMismatch` / non-numeric input. One sentence per disaster — what to *see* and what to *do*. Check by opening the README on a phone: is it clear without IDEA on the screen.
]

#github[
  Commit `week4: standalone java program`. Let someone else open it (or you from another machine — Mac, Windows, doesn't matter) and from the README understand where to press.
]

#sicp[Recursion on lists — bits of 1.1–1.2, if you yourself asked "why does this work," not "I have to get through SICP."]

#sunday[
  Draw on paper the list `'(airlock corridor reactor)` as a chain of boxes with "tail" arrows. Next to it put an `ArrayList` of three strings — cells in a row numbered 0, 1, 2. Those are not the same thing. But both answer "what's in our corridor."
]

The lights blinked again. You restarted the program — the list is there. The captain didn't praise you: on MODULE, praise looks like the absence of a siren. Four weeks. Your own console. GitHub. No Spring. You can exhale and not install Kafka "to fatten the résumé." Next month Earth will start knocking over HTTP. For now — tea. Someone still drank the coffee.
