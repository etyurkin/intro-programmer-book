#import "../lib-en.typ": *

= Macros and CLOS: the station learns new words

This is not a month from the schedule. This is a Sunday hole for people who don't have enough parentheses: first macros — code that writes code, then CLOS — objects the Lisp way, not "like Java, only in parentheses."

If task-manager is down — bring task-manager up. If Hibernate has been red for three days — read `Caused by`, not this chapter. You come here when the main course is green, or when Sunday itches and Java already said "enough."

#rule[
  A macro is not an "advanced defun." A function computes values. A macro gets *forms* and returns another form, which Lisp then computes. Mix them up — you get either magic that isn't there, or mash you're ashamed to read in a week.
]

CLOS is the Common Lisp Object System. Not "classes like in Java." There, methods live *inside* the class. Here methods live outside: a generic function, and classes only say *which* method to pick. On the station that's handy: one `status` for the reactor, the antenna, and the kettle, without a ten-floor hierarchy.

Files: `lisp-experiments/macros-clos/`. Commit. Even a crooked macro.

== Why a macro, if there's a function

A function sees values. A macro sees code *before* it was computed.

```lisp
(+ 1 2)
```

`+` gets `1` and `2`. It doesn't care whether you wrote `(+ 1 2)` or `(+ x y)`, where `x` is already 1.

But `if` cannot be an ordinary function in the naive sense: if both arguments were computed ahead of time, the "else" branch would always run. In Common Lisp `if` is a *special operator*. Macros are a way to make such things for yourself, without asking the language committee.

The most honest teaching example is "make your own `when`." `when` already exists. We'll write our own to see the guts, then immediately forget it in favor of the built-in. Like taking apart a sensor that already works.

First — that code in Lisp is *already data*.

```lisp
'(+ 1 2)
; (+ 1 2)

(first '(+ 1 2))
; +

(second '(+ 1 2))
; 1
```

You can build the list `(+ 1 2)` by hand:

```lisp
(list '+ 1 2)
; (+ 1 2)
```

And *run* it:

```lisp
(eval (list '+ 1 2))
; 3
```

`eval` in ordinary code smells of burnt duct tape. A macro is exactly so you *don't* call `eval` by hand: you return a form, and the compiler/interpreter inserts it where the macro was called.

#slow[
  Function: numbers and list-values in, a value out. \
  Macro: pieces of code in (not yet computed), a piece of code out. \
  Then Lisp computes that piece *at the call site*. As if you added the parentheses yourself, only the station added them for you.
]

=== Backquote: a template with holes

Writing `(list 'if test (list 'progn ...))` by hand hurts. There's a template: the backquote `` ` `` and the comma `,`.

```lisp
(let ((n 3))
  `(+ 1 ,n))
; (+ 1 3)
```

Everything under `` ` `` is like quote, *except* what follows a comma: that's substitute the value.

Comma-at `,@` — splice the *elements* of a list, not the list as a whole:

```lisp
(let ((body '(a b c)))
  `(progn ,@body))
; (PROGN A B C)
```

Without `,@` it would be `(PROGN (A B C))` — one argument that is itself a list. The dog unpacks. On the station: duct tape *inside* the crate vs a crate of duct tape in another crate.

#repl-note[
  An ordinary apostrophe `'x` — never compute. A backquote — compute only the holes. A comma is a hole. If you forget the comma, the template keeps the symbol `n`, not the number 3. Then `+` gets offended at a symbol. Read what the macro *returned* before you blame SBCL.
]

=== First macro: your own `when`

Built-in `when`: if the condition, do the body (may be several forms). Otherwise `nil`.

```lisp
(defmacro module-when (test &body body)
  `(if ,test
       (progn ,@body)
       nil))
```

`&body` is the same as `&rest`, only polite for macros: "here's a body." Editors thank you with indent.

The check is not "call it and believe," it's *expand*:

```lisp
(macroexpand-1 '(module-when (> *energy* 10)
                  (format t "still alive~%")
                  (tick)))
```

Something like this should come out:

```lisp
(IF (> *ENERGY* 10)
    (PROGN (FORMAT T "still alive~%") (TICK))
    NIL)
```

`macroexpand-1` — one layer. `macroexpand` — until macros run out. For study always `-1` first: otherwise you'll drown in the guts of `format`.

#slow[
  1. Type `defmacro` as above. \
  2. Call `macroexpand-1` on a form with two lines of body. \
  3. Make sure both lines are inside `progn`. \
  4. Only then call `module-when` live. \
  If you go "live" first — you're testing luck, not a macro.
]

Why `progn`? `if` has one form per branch. The macro body is several. Glue them into one — `progn`. A function won't do that: by the time the function is called, the body would already have been computed.

#warn[
  Don't write a macro if a function is enough. A macro is justified when you need to *not compute* some argument, or introduce a new name (`let` inside), or so the call looks like new grammar. "So it's cool" is a bad reason. Cool is reading your `defun` in a week.
]

=== A macro that guards the reactor

You want to write:

```lisp
(with-energy 15
  (blast)
  (ping-earth))
```

Meaning: if energy is under 15 — don't run the body, return `'too-low`. If there's enough — run it, charge the energy *once* at the start. Awkward as a function: the body would compute before entry again. A macro:

```lisp
(defmacro with-energy (cost &body body)
  (let ((cost-name (gensym "COST")))
    `(let ((,cost-name ,cost))
       (if (< *energy* ,cost-name)
           'too-low
           (progn
             (decf *energy* ,cost-name)
             ,@body)))))
```

`gensym` — a fresh name that isn't in your code. Why: if we wrote `(let ((cost ,cost)) ...)` and a person called `(with-energy cost ...)`, where `cost` is their variable, you'd get mash: the name collided. That's *capture*. On a three-line teaching macro you might not meet it. On the fourth — you will. Habit: names the macro introduces itself go through `gensym`.

#repl-note[
  `(gensym "COST")` will return something like `#:COST1234`. Ugly in the expand. But it won't collide with your `cost`. Ugly is better than quietly wrong.
]

Check:

```lisp
(defparameter *energy* 10)
(macroexpand-1 '(with-energy 15 (print 'boom)))
(with-energy 15 (print 'boom))
; TOO-LOW
*energy*
; 10
```

Energy wasn't charged — the body didn't live. Now `*energy*` = 20, `with-energy` 15 again — the body lives, energy 5.

#exercise("M.L1", "Lisp")[
  `module-when` and `macroexpand-1` on a form with *two* expressions in the body. In a comment — what would happen if you forgot `progn`.
]

#exercise("M.L2", "Lisp")[
  `with-energy`: not enough energy — `'too-low` and `*energy*` doesn't change; enough — the body and the charge. Check both. The `cost` counter through `gensym`, not "eh my name is rare."
]

=== When a macro lies: computed twice

A classic:

```lisp
(defmacro twice-wrong (x)
  `(+ ,x ,x))
```

A call `(twice-wrong (tick))` substitutes `(tick)` *twice*: two ticks, not one. If `tick` writes to `*energy*`, the station loses double. Expand — you see twins.

Right: first one name in `let`, then the name twice.

```lisp
(defmacro twice-right (x)
  (let ((g (gensym "X")))
    `(let ((,g ,x))
       (+ ,g ,g))))
```

`(twice-right (tick))` → one `tick`, add the value to itself. Not two ticks.

#slow[
  After every macro ask: *if the argument is a form with a side effect, how many times will it run?* If not once — you almost always need `let` + `gensym`. That isn't paranoia. That's a leak sensor.
]

=== Macros you've already eaten without knowing

`defun` is a macro (over something lower). `loop` is a macro, a whole language. `with-open-file` is a macro: open, do the body, close even if it fell over. `setf` is a macro. You've used them since week 1.

Java can't do this. It has annotations, codegen, lombok, processors — neighboring galaxies. That's why in Java you write more letters, and in Lisp you sometimes write a new word of the language. Don't drag macros into a Java-head as "I need this at work." At work you have Spring. A macro is so the brain knows grammar isn't a sacred cow.

#sicp[
  "Code as data" is the heart of SICP and Lisp. If it itches why `eval` and quote — go there, the pieces on quotation. Not instead of this chapter: first your own `module-when`, then Abelson.
]

== CLOS: objects whose methods live outside

In Java: class `Task`, inside it methods `complete()`, `getTitle()`. The object carries both data and verbs.

In CLOS: the class carries *slots* (fields). Verbs live in *generic functions*. One function `status`, several methods: for the reactor, for the antenna, for "anything." When you call `(status x)`, Lisp looks at the class of `x` and picks a method.

This isn't "worse than Java" and isn't "better." It's a different center: the verb matters more than the object's passport. Handy on the station: you yell `status` all the time, and the gadgets are different.

=== A class — a blueprint of slots

```lisp
(defclass module ()
  ((name :initarg :name
         :accessor module-name)
   (energy :initarg :energy
           :initform 0
           :accessor module-energy)))
```

`defclass` — declare a class. Name `module`. `()` — no parents (yet). Then slots:

- `:initarg :name` — at creation you can say `:name "reactor"`.
- `:accessor module-name` — Lisp will write a reader and a writer. Not a three-line getter.
- `:initform 0` — if you didn't say energy, it'll be 0.

Create:

```lisp
(defparameter *reactor*
  (make-instance 'module :name "reactor" :energy 80))

(module-name *reactor*)
; "reactor"

(module-energy *reactor*)
; 80

(setf (module-energy *reactor*) 75)
```

`make-instance` — like `new`, only the word is more honest: an instance. `setf` with an accessor — like a setter, only without a separate `setEnergy`.

#repl-note[
  `*reactor*` is now not a number and not an alist. It's an object. `describe` in the REPL will show the slots, if you forgot what's inside:

  ```lisp
  (describe *reactor*)
  ```

  Useful when there are five slots and memory is already lying.
]

Without an accessor you can `(slot-value obj 'energy)` — crude, like opening a panel with a screwdriver. An accessor is a normal door. `slot-value` — when you're writing infrastructure. In this chapter's quests — accessor.

=== Generic function and method

```lisp
(defgeneric module-status (m)
  (:documentation "A string for the panel. One verb, different gadgets."))

(defmethod module-status ((m module))
  (format nil "~a energy=~a"
          (module-name m)
          (module-energy m)))
```

`defgeneric` — "there will be a function `module-status` of one argument." You can skip it: the first `defmethod` sometimes starts the generic itself. Explicit is more honest, like a README.

`((m module))` — parameter `m`, and it is *specialized* on class `module`. Not a Java type in the compiler sense. Method choice at runtime: whichever class arrived, that method.

```lisp
(module-status *reactor*)
; "reactor energy=80"
```

Now a child — an antenna, which also has a signal level:

```lisp
(defclass antenna (module)
  ((signal :initarg :signal
           :initform 0
           :accessor antenna-signal)))

(defmethod module-status ((m antenna))
  (format nil "~a energy=~a signal=~a"
          (module-name m)
          (module-energy m)
          (antenna-signal m)))

(defparameter *dish*
  (make-instance 'antenna :name "dish" :energy 20 :signal 3))

(module-status *dish*)
; "dish energy=20 signal=3"

(module-status *reactor*)
; still the method for module
```

`antenna (module)` — an antenna *is* a module. It inherits name and energy slots. The method for `antenna` is *more specific*, so that's the one they take. For a bare `module` — the general one.

#slow[
  In Java you'd write `Antenna extends Module` and `@Override status()`. In CLOS override lives not in the class but in a separate `defmethod`. You can leave the class alone and add methods in another file. That's weird if you came from Java. That's normal if you think in verbs: "one more way to show status."
]

=== Several arguments — not only "this object"

In Java a method belongs to one class. In CLOS you can specialize *several* arguments. A teaching gesture, not a dissertation:

```lisp
(defgeneric dock (ship port))

(defmethod dock ((ship module) (port module))
  (format nil "~a -> ~a" (module-name ship) (module-name port)))
```

Then you'll add a method `(dock (ship shuttle) (port airlock))` — different text. Choice by a *pair* of classes. In Java that's visitor dances. Here — a second parameter in `defmethod`. Not required in the quest. Required to see once, so "the object model" doesn't look like a copy of Java.

=== `call-next-method`: don't copy the parent by hand

```lisp
(defmethod module-status :around ((m module))
  (let ((s (call-next-method)))
    (if (<= (module-energy m) 0)
        (concatenate 'string s " ALARM")
        s)))
```

`:around` — a wrapper around the other methods. `call-next-method` — "do what they would have done anyway." Then we appended `ALARM` if energy is zero.

There's also `:before` and `:after` — before and after the primary. For study, `:around` or a simple method on the child is enough. Don't build a five-floor combinator on the first evening. The station holds on duct tape, not on the MOP.

=== Several parents at once. Java still can't

In Java a class has one `extends`. Then as many `implements` as you want — but those are *interfaces*: promises with (almost) no state. There are no two real dads with slots. You write `extends Module implements Powered, Radio` and then by hand sort out what goes where.

CLOS allows several parents *as classes*:

```lisp
(defclass powered ()
  ((watts :initarg :watts
          :initform 0
          :accessor watts)))

(defclass radio ()
  ((freq :initarg :freq
         :initform 0
         :accessor radio-freq)))

(defclass comm-antenna (module powered radio)
  ())
```

`comm-antenna` is a module, and power, and radio. Slots `energy`, `watts`, `freq` all present. Not "pretend to be an interface." The ancestors are real.

```lisp
(defparameter *comm*
  (make-instance 'comm-antenna
                 :name "comm"
                 :energy 40
                 :watts 12
                 :freq 437))

(list (module-name *comm*) (watts *comm*) (radio-freq *comm*))
; ("comm" 12 437)

(typep *comm* 'module)   ; T
(typep *comm* 'powered)  ; T
(typep *comm* 'radio)    ; T
```

The `module-status` method for `module` already works: an antenna *is* a module. You can add a method specially for `comm-antenna` or for `powered` — the generic will pick the most fitting.

Parent order matters. Lisp builds a *class precedence list* (CPL): who is more specific, whose slot `:initform` to take, whose method is closer. If two granddads share a slot name — there will be a rule, not a lottery. The algorithm is called C3, you don't have to memorize the name. You do have to: `(class-precedence-list (find-class 'comm-antenna))` in the REPL if it's suddenly unclear *whose* method got picked.

```lisp
(mapcar #'class-name
        (class-precedence-list (find-class 'comm-antenna)))
; (COMM-ANTENNA MODULE POWERED RADIO STANDARD-OBJECT T)
```

`STANDARD-OBJECT` and `T` are ancestors of everyone. You didn't write them. If `POWERED` is before `RADIO` in the list — that's how you put them in `defclass`. Swap them — they swap. That isn't a bug. That's a lever.

#slow[
  Java: one dad, many plaques "I can do this."\\
  CLOS: several dads, slots and methods from all of them.\\
  A diamond "both granddads → one grandchild" is forbidden for classes in Java precisely because it's scary. In CLOS it isn't forbidden: order in `defclass` and the CPL settle the fight. This isn't "better for Spring." This *exists*, and in many languages it still doesn't. Python can a little. Java — no. C\# — no. Remember it as a sensor: "the object model" is not equal to "like in Java."
]

#warn[
  Don't build a six-floor pedigree "because you can" for study. Multiple inheritance is easy to turn into a hold where nobody remembers whose `status` this is. Two ancestors with different meanings (`powered` and `radio`) — ok. Two ancestors that both want to be "the main module" — a smell. Like microservices: possibility is not necessity.
]

#exercise("C.L5", "Lisp")[
  A class with *two* parents, not counting `module` as one of them: for example `powered` + `radio`, or `module` + `powered`. Make an instance, check `typep` on each ancestor, read slots from both sides. In a comment one sentence: what Java doesn't have for this (not "an interface," but exactly *two parent classes with slots*).
]

#exercise("C.L6", "Lisp")[
  `(class-precedence-list (find-class 'comm-antenna))` — or your class. Write down the order of names. Swap the parents in `defclass` and again. If the order in the CPL changed — there's the lever. If not — the parents are too simple, add a same-name slot conflict on purpose and see who won.
]

#warn[
  Don't learn "all of CLOS" like a multiplication table. `defclass`, `make-instance`, accessor, `defgeneric`/`defmethod`, one child — already more than you need so you don't go silent in a Lisp interview (rare), and so Java classes look like *one* way, not the only one.
]

=== A station of objects, not of globals

In the MODULE log the world lived in `*energy*` and `*here*`. That's fine for a three-screen game. When there are five entities, globals start lying: whose energy, which compartment.

A sketch, not the whole engine:

```lisp
(defclass station ()
  ((modules :initarg :modules
            :initform nil
            :accessor station-modules)))

(defun station-report (st)
  (mapcar #'module-status (station-modules st)))

(defparameter *module*
  (make-instance 'station
                 :modules (list *reactor* *dish*)))

(station-report *module*)
```

A list of objects. `mapcar` over the verb `module-status`. Each object knows how to answer, because the method was chosen by class. In Java that's `for (Module m : list) m.status()` — the same gesture, a different address for the verb.

#exercise("C.L1", "Lisp")[
  Class `module` with slots name and energy. `make-instance`, change energy through the accessor, `module-status` prints both. No need to put `describe` in a comment — live in the REPL.
]

#exercise("C.L2", "Lisp")[
  Class `antenna` child of `module`, slot `signal`. Its own `module-status`. Two objects in a list, `mapcar #'module-status` — two different strings, one verb.
]

#exercise("C.L3", "Lisp")[
  An `:around` method or a separate function `alarm-p`: energy 0 — the status has `ALARM`. A reactor at 0 and an antenna at 0 both yell. Not copy-paste of two `if`s in two methods, if you already know `call-next-method`. If you don't — two `if`s, but write in a comment how that's worse.
]

== Macro + CLOS: don't blend them on night one

You can write a `define-module` macro that expands into `defclass` + a method. On the second evening. On the first — *don't*. First each tool separately. Otherwise a bug: unclear whether the macro, CLOS, or you is guilty.

An order that doesn't explode:

1. Functions and lists (you already).
2. A macro you expanded and *read* the expand.
3. One class, one method.
4. A child.
5. Only then "a macro writes defclass."

#rule[
  If you haven't run `macroexpand-1` — you don't have a macro, you have hope. If you haven't called `describe` on an instance — you don't have a class, you have a `defparameter` with an object you're afraid to open.
]

== How this rhymes with Java, without a sermon

- A Java class ≈ a CLOS class + methods *nailed* to it. CLOS methods you can add in another file.
- A Java `interface` ≈ "a set of generics," but Java requires the class to *declare* that it can. CLOS doesn't require a declaration: a method for a class can be defined next door.
- Java has no macros. Repeating try/finally — you write by hand or live with lambdas. Lisp writes `with-open-file`.
- `record` in Java 21 — slots without ceremony. Closer to `defclass` with an accessor than to an old hundred-line JavaBean.
- Spring `@Service` is not a macro, though the *feeling* of "they extended the language with an annotation" is similar. Don't lie in an interview that an annotation = a macro. Neighboring galaxies.

They won't ask this in a Java interview. It will settle in the head: an object is not the only religion. When in Java you crawl into visitor or "duck" serialization, remember `defgeneric`. When you copy the same try/catch for the tenth time — remember that in Lisp this would have been a macro, and in Java — a method with a lambda. And write the method with a lambda, don't wait for macros from Oracle.

== Typical breakage

*The macro doesn't expand, it's called as a function.* You forgot `defmacro`, wrote `defun`. Then arguments get computed first. `when` becomes a trap. Look at `macro-function`:

```lisp
(macro-function 'module-when)  ; a function or NIL
```

`NIL` — it isn't a macro.

*`comma not inside backquote`.* A comma in ordinary code. The backquote got lost.

*Wrong slot.* `:initarg :name`, and you create with `:title`. The slot is `nil`, because the initarg didn't match. Names are tags, not "come on you understood."

*`there is no applicable method`.* You called a generic on a number or on `nil`. There's a method for `module`, something else arrived. `(class-of x)` in the REPL.

*The child doesn't see the slot.* A typo in the parent's name. `(defclass antenna (modlue) ...)` — a new class with no ancestor `module`. Parentheses around the parent are required: `(module)`, not `module` alone in some layouts of the brain. Write it like the example.

#exercise("M.L3", "Lisp")[
  Break `twice-wrong` via `(twice-wrong (tick))` (or a counter `incf`). Show in a comment: two side effects. Fix via `twice-right`. `macroexpand-1` of both.
]

#exercise("C.L4", "Lisp")[
  Station: class `station`, a slot that is a list of modules, function `station-report`. At least two modules of different classes. Print the report. This is not the whole MODULE log — this is a panel of objects.
]

#github[
  Folder `macros-clos/`: `when.lisp`, `energy-mac.lisp`, `modules.lisp`. README: how to load in SBCL (`(load ...)` in order). Paste one `macroexpand-1` into the README as proof you expanded, not only called.
]

#sunday[
  Write a macro `dountil-energy` (while energy is above N, do the body). Expand. Don't run without expand: easy to catch an infinite loop if the condition is wrong. `Ctrl+C` in SBCL is your spacesuit.
]

== A program that doesn't ask for a restart

In Java the loop is: wrote → `javac` or Maven → built a jar → stopped the server → uploaded → started → you pray that `main` is the one. On a phone it's worse: APK, install, green arrow, the activity is born again. Hot swap in the IDE sometimes lies. "Rewrite a method on a live object" the language does not promise as a staff feature.

Common Lisp promises it as staff. The REPL is not a week-one toy. It's *the same* world the program is spinning in. `defun` and `defmethod` don't "compile the project." They replace a function *in an already live image*.

```lisp
(defmethod module-status ((m module))
  (format nil "~a energy=~a"
          (module-name m)
          (module-energy m)))

(module-status *reactor*)
; "reactor energy=80"
```

Don't leave SBCL. Don't load the file "from scratch" if you don't want to. Just type a *different* method:

```lisp
(defmethod module-status ((m module))
  (format nil "[~a] ~a%"
          (module-name m)
          (module-energy m)))

(module-status *reactor*)
; "[reactor] 80%"
```

The same object `*reactor*`. The same process. A new verb. No `mvnw`, no "wait, Gradle is downloading." The station didn't reboot. The sensor swapped firmware on the fly.

Same with an ordinary function: you redefined `tick` — the next call is already new, the globals are in place. Broke it — redefine again. The image remembers data. You change behavior.

#repl-note[
  This is interactive programming, not "a console to poke pluses." You don't rebuild the world. You repair it while it's on. Emacs has lived like this for decades: you redefine a function — the editor is already different, the session is the same. Not an accident that this book was written inside Emacs. Recursion, yes. Again.
]

Almost nowhere else is like this anymore. Smalltalk could. Some Erlang/Elixir images hot-swap a module, but that's another religion. Python "rerun the notebook cell" is a cousin, plus rakes with objects already created. Java HotSwap in the debugger — sometimes, if the method signature didn't change, and so you don't relax. Lisp doesn't make this a debugger trick. This is a way to *write*.

#slow[
  1. Create `*reactor*`, call `module-status`. \\
  2. No `(quit)`. Type a new `defmethod`. \\
  3. `module-status` again on *the same* object. \\
  4. If you saw the old string — you loaded the file into another image or recreated the class so the objects became the "old" class. `(class-of *reactor*)` and the method once more.
]

#exercise("I.L1", "Lisp")[
  A live object, two `defmethod`s in a row without leaving SBCL. In a comment: what stayed the same (data) and what changed (the verb). If it only changed after `make-instance` again — you did the wrong exercise, you restarted the station.
]

== A hundred million miles and one REPL

Sometimes this story is told as "a satellite left orbit, they connected, they patched it." Closer to the truth — even stranger.

1999. NASA probe *Deep Space 1*, far from Earth (tens of millions of miles, round-trip delay — tens of minutes, not "a ping from the next room"). On board, the Remote Agent experiment: a piece of autonomy, written mostly in Common Lisp (Harlequin Lisp on VxWorks). Not a teaching REPL. A real one. On hardware worth over a hundred million dollars.

The software was supposed to run the probe for several days on its own. On the ground they ran it for months, a piece they even "proved" with a model checker. On the second day an expected event didn't happen. A race that had *never* shown up in tests: a deadlock. You can't flash firmware like a phone app: mail doesn't go to Mars, and the ceremony "compile — put in a jar — upload — restart `main`" here costs light and the risk of losing the machine.

There was a REPL on board. From Earth, through Deep Space Network antennas, they asked for a backtrace: who is waiting for whom. They found the hang. Not "they rebuilt the project." They manually poked the event the code was waiting for — and the agent went on. Ron Garret, who tells this, says it straight: without a "read — compute — print" loop on the ship, they wouldn't have patched this thing.

#rule[
  That's why in chapter one the black window wasn't a toy. The same gesture as `(+ 2 3)`: a live language next to live data. On DS1 the data was a station priced like a small town. Yours is `*reactor*`. Same ritual. Different scale.
]

Politically, Lisp at JPL almost died after this: the experiment was officially a success, and it mostly scared NASA's autonomy career. This is not a moral of "Lisp won." This is a moral of "a language where a program is not a sacred binary but a conversation sometimes saves hardware you can't reach with your hands." Station MODULE is made up. DS1 is not. Source of the tale: Garret's text *Lisping at JPL* and his talk on debugging from sixty million miles.

Don't lie in an interview that "I patched a satellite." Lie less: "in Lisp you can redefine a method without killing the process; that's how they once debugged a probe." That's enough for the person across the table to either smile or ask about `HotSwap`. Both outcomes are good.

== Lisp and artificial intelligence, the original one

John McCarthy invented Lisp in 1958 not to feed Java juniors. To talk to a machine about *symbols*: not only numbers, but lists, rules, "if this — then that." For twenty or thirty years Lisp was the native language of artificial intelligence. MIT, Stanford, expert systems, Symbolics "Lisp machines" — separate computers, because ordinary ones were gasping then.

The idea was beautiful: intelligence as the manipulation of symbols. Code = data, a macro extends the language for the task, a REPL lets you sharpen a thought without rebuilding the world. On paper and in the lab it worked. In life they hit hardware. Little memory, a garbage collector on machines of that day — a luxury, symbolic search explodes combinatorially faster than you can buy another kilobyte. They promised "AI" by the end of the decade. The decade ended, the kilobyte wasn't enough.

Then winter came: the money left, Lisp machines went bankrupt, industry was overfed on promises. Not because parentheses are stupid. Because the task was bigger than a 1985 box.

About the box separately, because this isn't a metaphor. A Symbolics Lisp machine — a separate computer, so the garbage collector and lists wouldn't be ashamed of household hardware. Cost as much as a decent car. An ordinary office PC of the same year ate Lisp slowly and with resentment. When they promised "artificial intelligence by Monday," on Monday it turned out there wasn't enough memory for rules about the whole world, and if-then combinatorics grows faster than the bill. You could buy another Lisp machine. You couldn't buy another world in kilobytes. Winter arrived on electricity bills and grants, not on the aesthetics of parentheses.

Now "AI" is on posters again, only the box is different: video cards, tensors, statistics, not a rule-based expert system.

Hardware caught up. The approach isn't the same — and that's fine. Lisp from this doesn't have to become a job-post language again. It already did the main thing: showed that a program can be *plastic*. A macro, CLOS with several parents, a method you change while the object is alive, a probe you don't reboot for one race — branches of one tree. McCarthy planted the tree, AI labs watered it until the sockets gave up.

#slow[
  If they ask "Lisp is dead, right?" — don't defend job posts. Say: the first AI grew on it, the hardware of the day ate it, and the ideas (REPL, code as data, a live image) crawled into other languages in pieces. Java took objects and a garbage collector, didn't take macros, didn't take several parents, didn't take hot-swapping a method. Pieces, not the tree. That's why forty minutes of parentheses in this book aren't nostalgia for a résumé. It's looking at the tree, not only at IKEA furniture.
]

Emacs, where emagent sits, is almost entirely Lisp. An editor you don't restart to add a command. You've already touched that, even if you thought you were "just writing a textbook." The station loves those loops.

== Why Lisp then. A wrap-up, not a sermon

Put it on one panel before it scatters across chapters:

- *Code is data.* You can build a list, take it apart, feed it to a macro. The language isn't closed by a committee. You extend the grammar when a gesture repeats. In Java for that you have annotations, codegen, lombok — neighboring galaxies, plus a build ceremony.
- *A macro computes forms, not values.* That's why `when` and `with-open-file` exist. That's why `(twice-wrong (tick))` is dangerous. That's why `macroexpand-1` is a sensor, not scholarship.
- *CLOS: the verb on the outside.* A method isn't nailed to a class forever. Several parents with slots — yes, in 2026 Java still doesn't. Several arguments on a generic — yes. `call-next-method` — not copy-paste of dad.
- *Live image.* You redefined `defmethod` — the station is already different, the objects are the same. Interactive programming, not "a console for Hello." Almost nowhere else still spoon-feeds you this.
- *AI.* Lisp was the native language of artificial intelligence until the hardware gave up. Winter didn't come because of parentheses. Parentheses survive winters better than grants.
- *DS1.* A REPL on a probe. A race. A backtrace at light delay. A patch without "upload the APK." Not a fairy tale about a falling satellite — a talk from JPL.

Why does a Java junior need this? Not to write Spring in CLOS. To see the *edge* of a language: what's a choice in Java, and what's industry habit. When you copy try/finally for the tenth time — remember a macro. When one dad's `extends` isn't enough — remember that's a Java limit, not physics. When Gradle spends five minutes building to change a status string — remember `defmethod` in the same REPL. When they say in an interview "a real language is Java" — you can nod: it feeds you. And have in your pocket forty minutes that feed curiosity.

A language can be weird *and* useful for a head. We show that with a leaky station and someone else's probe.

#github[
  In the README of folder `macros-clos/` three proofs, not slogans: `macroexpand-1` output; `typep` on an object with two parents; two different `module-status`es on the same instance without `(quit)`.
]

== What not to take to work tomorrow

Don't rewrite Spring in CLOS. Don't macro every sneeze in teaching Lisp. Do:

- be able to read `macroexpand-1`;
- tell "don't compute the argument" from "compute and pass";
- create a class with slots and two methods of one verb;
- know that several parents in CLOS are normal, in Java they aren't;
- once redefine a method *without* killing the process;
- not lie that a Java class and a CLOS class are the same word;
- if AI comes up — don't mix 1958-with-parentheses and 2026-with-video-cards, but remember whose first workshop this was.

That's enough so macros don't look like outer space, and Java objects don't look like a religion. Station MODULE after this is still leaky. The leaks just got *types of gadget*, and the language got *new words*. The duct tape didn't go anywhere. The probe, just in case, also once held on more than duct tape. Also on a REPL.

== If they ask at dinner why you need parentheses

A short answer, no lecture and no shame about Java.

Lisp is a language where a program isn't nailed to a file on disk. A macro extends the grammar. CLOS allows several parents, which Java still doesn't do with classes. You can change a method while the object is alive. AI once stood on that, until the kilobyte ran out. A probe once stood on that, until a backtrace arrived from Earth.

You don't need this to pass Spring. You need this so you don't take Spring for physics. Physics — a computer obeys exact instructions. Spring is one way to pack those instructions. Parentheses are another. Both honest. One feeds you. The second doesn't let you get bored. The book promised that from the title page.

If after this chapter you want to throw out Java — don't. The huskies will still wake you at seven, and the job post will still be Java. If after this chapter you want to throw out Lisp — don't either. The forty minutes didn't go anywhere. You just now know *where* they go: into the tree, not into one more annotation.
