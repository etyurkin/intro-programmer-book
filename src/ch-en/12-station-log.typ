#import "../lib-en.typ": *

= Station log MODULE

This is not a schedule. The schedule is in months 1–6. This is an extra forty minutes for when the week's quest is already green and your fingers still want parentheses.

Station MODULE in the main course is always being repaired. In the log it also *gets played*. Its own plot: not orcs, not dungeons from someone else's book. Orbit, duct tape, notes from the previous mechanic. His name was… the watch log is smudged. A letter survived: Щ. And a coffee stain.

#rule[
  These quests are not instead of Java. Not instead of a lesson. If the server is down — bring the server up. The log is for Sunday and for itchy parentheses.
]

We talk to SBCL. Put files in `lisp-experiments/station-log/`. Commit when it isn't embarrassing *or* especially when it is.

== Watch 1. Energy that runs away

The previous mechanic left a scrap on the table:

#align(center)[
  #block(width: 88%, fill: rgb("#f3f0e8"), inset: 10pt, stroke: 0.4pt + rgb("#c9c3b4"))[
    #set par(first-line-indent: 0pt, justify: true)
    The reactor lies. The panel says 100. The corridor is cold. Don't trust the panel. Trust the function.
  ]
]

We will not make a game with pictures. We will make a world out of parentheses. A world more honest than the panel.

Start the REPL, `sbcl`, the star. First a global — yes, stars, yes, we yell:

```lisp
(defparameter *energy* 100)
(defparameter *leak* 7)
```

`*leak*` — how much energy each tick eats just because. A crack in the hull. Or a kettle somebody forgot. For the model it doesn't matter.

```lisp
(defun clamp-energy (n)
  (cond
    ((< n 0) 0)
    ((> n 100) 100)
    (t n)))

(defun tick ()
  (setf *energy* (clamp-energy (- *energy* *leak*)))
  *energy*)
```

#repl-note[
  `tick` changes a global and *returns* the new value. In the REPL you'll see a number. This is not "a procedure that silently wrecks the world" — you got an answer too. Handy to look at, without wrapping in `print`.
]

```lisp
(tick)  ; 93
(tick)  ; 86
```

Two ticks — and it isn't a hundred anymore. The panel would lie if we drew it once and forgot to call `tick`.

Recharge from the solar panel while the station is on the sunlit side:

```lisp
(defun recharge (delta)
  (setf *energy* (clamp-energy (+ *energy* delta)))
  *energy*)

(recharge 20)  ; depends how much has already leaked
```

Emergency spend — open the antenna, blink at Earth:

```lisp
(defun pulse-antenna ()
  (if (< *energy* 15)
      'too-dark
      (progn
        (setf *energy* (clamp-energy (- *energy* 15)))
        'ping)))
```

#slow[
  `progn` — "do several forms, return the last." Without it `if` has only one "then." You want to subtract *and* return a symbol — pack them. Otherwise you get the number from `setf`, and `'ping` doesn't even ride.
]

Play in the REPL: five ticks, one `pulse-antenna`, another tick. Watch when `'too-dark` shows up. That isn't a bug. That's plot.

#exercise("S.L1", "Lisp")[
  `ticks`: a number n, repeat `tick` n times, return the final energy. Without a loop you can too — recursion. With a loop — `(loop repeat n do (tick))`. Don't go below zero: `clamp-energy` is already on watch, don't go around it.
]

== Watch 2. Compartments are a graph, not a corridor from the brochure

On the chart at the entrance there are rectangles and arrows. Rectangles — rooms. Arrows — hatches. That's a *graph*: nodes and edges. Grown-up word. The thing is a list of neighbors.

Five compartments of the log. Remember them, they'll be useful in the adventure:

- `airlock` — the airlock. Smells of metal and other people's gloves.
- `corridor` — the corridor. A bulb blinks Morse, but it's just a bad ballast.
- `galley` — the galley. A mug with the letter Щ. The coffee ran out last quarter.
- `reactor` — the reactor. Warm. Hums. Lying to the panel here is indecent.
- `cupola` — the cupola. Earth in the window. For the plot: a strong receiver lives here.

Neighbors — an alist. Key — room, value — a list of where a hatch goes.

```lisp
(defparameter *doors*
  '((airlock  . (corridor))
    (corridor . (airlock galley reactor))
    (galley   . (corridor cupola))
    (reactor  . (corridor))
    (cupola   . (galley))))
```

From the airlock only into the corridor. From the corridor — almost everywhere. From the reactor back to the corridor, no secret pipe. We could add a pipe. Then the graph gets merrier and more dangerous. No pipe for now: otherwise the first game will be about how you got stuck in the vents, not about parentheses.

```lisp
(defun neighbors (room)
  (cdr (assoc room *doors*)))

(neighbors 'corridor)
; (AIRLOCK GALLEY REACTOR)
```

Can you step?

```lisp
(defun connected-p (from to)
  (member to (neighbors from)))
```

`member` returns the tail from the find, or `nil`. For `if` that's enough: non-`nil` — yes.

#repl-note[
  `(connected-p 'airlock 'reactor)` → `nil`. No hatch. Not "almost next to each other on the paper." Next to each other on the paper is geometry. In a graph there are only edges. The station is not required to be an honest office floor plan.
]

Where you stand:

```lisp
(defparameter *here* 'airlock)

(defun look ()
  (format t "you're in ~a~%" *here*)
  (format t "hatches: ~a~%" (neighbors *here*))
  *here*)
```

```lisp
(defun walk (to)
  (if (connected-p *here* to)
      (progn
        (setf *here* to)
        (look))
      (format t "no hatch to ~a~%" to)))
```

In the REPL:

```lisp
(look)
(walk 'corridor)
(walk 'cupola)   ; no hatch, it yells
(walk 'galley)
(walk 'cupola)
```

You just wrote an adventure engine. No picture. A picture would have been a lie: as if the world were bigger than five symbols. The world is five symbols and hatches. Honest.

#exercise("S.L2", "Lisp")[
  `can-reach-p`: from room A to B *in one step* already exists. Make `exits-report`: for *each* room print the name and the neighbors. Take the data from `*doors*`, don't copy five `format`s by hand. `dolist` over `*doors*`.
]

== Watch 3. Щ's notes and a mug

Now items. Not an inventory of forty slots. A pocket: a list of symbols.

```lisp
(defparameter *pocket* nil)

(defparameter *at*
  '((airlock  . nil)
    (corridor . (tape))
    (galley   . (mug note))
    (reactor  . (wrench))
    (cupola   . (photo))))
```

`tape` — duct tape. You'll patch the leak with it, otherwise what's the plot for. `mug` — Щ's mug. `note` — a note. `wrench` — a seventeen-mil wrench, the only one. `photo` — Earth, shot on film, because the digital module is "updating" again.

```lisp
(defun stuff-here ()
  (cdr (assoc *here* *at*)))

(defun take (item)
  (let ((here-stuff (stuff-here)))
    (if (member item here-stuff)
        (progn
          (setf *pocket* (cons item *pocket*))
          (setf (cdr (assoc *here* *at*))
                (remove item here-stuff))
          (format t "took ~a~%" item))
        (format t "no ~a here~%" item))))
```

#slow[
  `setf` on `(cdr (assoc …))` changes a cell in *the same* cons that lives in `*at*`. That's why the world changes. If we built a new list "outside" and forgot to assign it — the room would hold the mug forever. This isn't magic. This is a pointer to a pair.
]

```lisp
(defun read-note ()
  (if (member 'note *pocket*)
      (format t "Щ.: leak in the reactor. duct tape in the corridor. don't drink from the mug.~%")
      (format t "no note in the pocket. maybe it's still in the galley.~%")))
```

Play it as a rehearsal:

```lisp
(defparameter *here* 'airlock)
(walk 'corridor)
(take 'tape)
(walk 'galley)
(take 'note)
(read-note)
(take 'mug)
```

You can take the mug. We won't drink: the previous mechanic warned us, and a textbook is not insurance.

#exercise("S.L3", "Lisp")[
  `drop`: put an item from the pocket into the current room. If the item isn't there — say so honestly. `remove` from `*pocket*`, `cons` onto the room's list. Check: took the wrench in the reactor, left for the corridor, dropped it, came back — no wrench in the reactor. Otherwise you changed the wrong list.
]

== Watch 4. Five rooms, one leak

The whole game. An energy tick on every `walk`. You can patch the reactor only if you're *in* `reactor` and `tape` is in the pocket.

Put it in a file `module-adventure.lisp` (in the REPL later `(load "module-adventure.lisp")` from that folder, remember `pwd`).

The world resets by a function, not "close SBCL and pray":

```lisp
(defun reset-world ()
  (setf *energy* 100)
  (setf *leak* 7)
  (setf *here* 'airlock)
  (setf *pocket* nil)
  (setf *at*
        '((airlock  . nil)
          (corridor . (tape))
          (galley   . (mug note))
          (reactor  . (wrench))
          (cupola   . (photo))))
  (setf *doors*
        '((airlock  . (corridor))
          (corridor . (airlock galley reactor))
          (galley   . (corridor cupola))
          (reactor  . (corridor))
          (cupola   . (galley))))
  (setf *fixed* nil)
  'ready)
```

`*fixed*` — whether the crack is patched. While `nil`, every move eats `*leak*`.

A move is not a separate button. A move is when you walked:

```lisp
(defun walk (to)
  (cond
    ((not (connected-p *here* to))
     (format t "no hatch to ~a~%" to))
    ((<= *energy* 0)
     (format t "dark. energy 0. the station is not in the mood.~%"))
    (t
     (setf *here* to)
     (unless *fixed*
       (tick))
     (look)
     (when (stuff-here)
       (format t "on the floor: ~a~%" (stuff-here))))))
```

The patch:

```lisp
(defun tape-leak ()
  (cond
    ((not (eq *here* 'reactor))
     (format t "the leak isn't here. the panel lies, but the pipes are in the reactor.~%"))
    ((not (member 'tape *pocket*))
     (format t "no duct tape. Щ. wrote: corridor.~%"))
    (t
     (setf *fixed* t)
     (setf *leak* 0)
     (setf *pocket* (remove 'tape *pocket*))
     (format t "taped it. the hum got duller. that's a compliment.~%"))))
```

Victory is not a separate screen. Ask yourself:

```lisp
(defun status ()
  (format t "energy ~a, crack ~a, pocket ~a~%"
          *energy*
          (if *fixed* 'taped 'hissing)
          *pocket*))
```

#repl-note[
  A round: `(reset-world)`, `(walk 'corridor)`, `(take 'tape)`, `(walk 'reactor)`, `(tape-leak)`, `(status)`. Energy leaked a little on the way. Further ticks don't eat. You can go look at Earth from the cupola, like a person whose shift suddenly got boring.
]

Losing: wander without duct tape until `*energy*` hits 0. Then `walk` refuses. The station doesn't explode in ASCII art. It just doesn't open the hatch. That's meaner.

The "adventure" text lives in `look` and in the note. You can add room descriptions — an alist of strings.

```lisp
(defparameter *flavor*
  '((airlock  . "cold floor. someone else's gloves, not your size.")
    (corridor . "the bulb lies in Morse. it's just the ballast.")
    (galley   . "Щ's mug and the smell of what used to be coffee.")
    (reactor  . "warm. if it hisses — not poetry, a crack.")
    (cupola   . "earth is big. you are small. duct tape beats lyrics.")))

(defun look ()
  (format t "~a~%" (cdr (assoc *here* *flavor*)))
  (format t "compartment ~a | hatches: ~a~%" *here* (neighbors *here*))
  *here*)
```

Don't turn this into a novel. Two lines per room. A REPL game lives on moves, not paragraphs.

#exercise("S.L4", "Lisp")[
  Item `wrench` in the reactor. Command `whack`: if the wrench is in the pocket and you're in `galley` — you "fixed" the corridor bulb, set `*lamp*` to `'ok`. If there's no wrench — `'need-wrench`. Decide yourself whether the lamp affects the game. Even one line in `look`. No effect — a prop, that also counts, but write honestly in a comment that it's a prop.
]

== Watch 5. Save the world, or sleep will eat the mash

RAM is the counter. You quit SBCL — the mash is wiped. A jar on disk — `with-open-file`.

We'll save not "a pretty format for humans," but what Lisp can read back: `print` / `read`.

```lisp
(defun world-plist ()
  (list :energy *energy*
        :leak *leak*
        :here *here*
        :pocket *pocket*
        :at *at*
        :doors *doors*
        :fixed *fixed*))

(defun save-world (path)
  (with-open-file (out path :direction :output :if-exists :supersede)
    (print (world-plist) out))
  path)
```

#slow[
  `print` writes so `read` understands. `format` writes so you understand. For a save you need `print`. For "on the floor: mug" — `format`. Don't mix up the stoves.
]

```lisp
(defun apply-world (plist)
  (setf *energy* (getf plist :energy)
        *leak*   (getf plist :leak)
        *here*   (getf plist :here)
        *pocket* (getf plist :pocket)
        *at*     (getf plist :at)
        *doors*  (getf plist :doors)
        *fixed*  (getf plist :fixed))
  'loaded)

(defun load-world (path)
  (with-open-file (in path :direction :input)
    (apply-world (read in))))
```

A round:

```lisp
(reset-world)
(walk 'corridor)
(take 'tape)
(save-world "module-save.lisp-data")
```

Quit SBCL. Open it again. Load the file with the definitions, then:

```lisp
(load-world "module-save.lisp-data")
(status)
(look)
```

The pocket should remember the duct tape. If it doesn't — either you saved in the wrong `pwd`, or you loaded the definitions *after* the save and `reset-world` overwrote it. Order: game code first, then `load-world`.

#warn[
  `read` eats lisp-data. Don't feed it a file from the internet "it's just text." This is not a JSON parser on a diet. This is the language with its mouth open. A teaching save is yours, from the disk next to you.
]

#exercise("S.L5", "Lisp")[
  Command `save` with no argument writes `module-save.lisp-data` in the current folder. `load` reads. If there's no file — `'no-save`, not a crash. Check: patched the crack, saved, `reset-world`, loaded — the crack is taped again. If not, you forgot `*fixed*` in the plist.
]

== Watch 6. A map on a napkin and a little "smart" move

The graph is already there. You can ask: is there a path *longer* than one hatch.

A teaching breadth-first walk, without queues from an algorithms textbook: recursion with a pocket of "already been."

```lisp
(defun reachable (from)
  (labels ((walk-rooms (room seen)
             (if (member room seen)
                 seen
                 (let ((seen2 (cons room seen)))
                   (dolist (n (neighbors-from from-table room) seen2)
                     (setf seen2 (walk-rooms n seen2)))
                   seen2)))
           (neighbors-from (table room)
             (cdr (assoc room table)))
           (from-table () *doors*))
    (walk-rooms from nil)))
```

Stop. This already wants simplifying, because the nesting lies. Simpler like this:

```lisp
(defun reachable (from)
  (let ((seen nil))
    (labels ((visit (room)
               (unless (member room seen)
                 (push room seen)
                 (dolist (n (neighbors room))
                   (visit n)))))
      (visit from)
      seen)))
```

#repl-note[
  `(reachable 'airlock)` should return all five compartments: the graph is connected. Cut the corridor↔galley hatch in your head: then the cupola becomes an island if you start from the airlock. Try a temporary `(setf *doors* …)` without `galley` on the corridor — and look at `reachable`. Then `(reset-world)`.
]

This is not a term paper on graphs. This is the answer to "why is the room on the chart, but `walk` won't let me in": because a path is a chain of edges, not neighborhood on a picture.

#exercise("S.L6", "Lisp")[
  `steps-to`: from `*here*` to room `to`, return the number of hatches on *one* known path (doesn't have to be shortest, but not infinite). No path — `nil`. You can do it by hand for five rooms as a table, or by a walk. A table on five nodes is not shameful. Shameful is returning 1 for `airlock` → `cupola`.
]

== Watch 7. A mini-loop "the game asks itself"

Tired of typing `(walk 'x)` — make a loop. Still REPL spirit: you aren't compiling an engine. You're reading a line.

```lisp
(defun play ()
  (reset-world)
  (look)
  (loop
    (when (<= *energy* 0)
      (format t "energy gone. watch closed.~%")
      (return))
    (format t "> ")
    (finish-output)
    (let* ((line (string-downcase (read-line)))
           (parts (split-line line))
           (cmd (first parts))
           (arg (second parts)))
      (cond
        ((string= cmd "quit") (return))
        ((string= cmd "look") (look))
        ((string= cmd "status") (status))
        ((string= cmd "take") (take (intern (string-upcase arg))))
        ((string= cmd "walk") (walk (intern (string-upcase arg))))
        ((string= cmd "tape") (tape-leak))
        ((string= cmd "save") (save-world "module-save.lisp-data"))
        ((string= cmd "load") (load-world "module-save.lisp-data"))
        (t (format t "commands: look walk take tape status save load quit~%"))))))
```

Write `split-line` yourself: cut on a space. Teaching:

```lisp
(defun split-line (s)
  (let ((p (position #\Space s)))
    (if p
        (list (subseq s 0 p) (subseq s (1+ p)))
        (list s))))
```

Two words are enough: `walk corridor`. A third word the station will swallow with the second. Live with it or write a real split later.

`intern` + `string-upcase` — a bridge from "human text" to a Lisp symbol. Without it `walk` compares a symbol with a string and never walks. A classic. Щ. probably tripped on this, hence the mug.

#warn[
  `(play)` will take the REPL into itself. Exit is `quit`. Don't Ctrl+C right away, give it a chance. If you still Ctrl+C — you're back at `*`, the world in memory may be stuck mid-way. `(reset-world)` cures it.
]

== Watch 8. A coffee machine that lies

There's a machine in the galley. The button says "coffee." Inside — a function. Previous mechanic Щ. wired it to the station's `*energy*`. Every cup — 4 units. If energy is low, the machine prints steam and pours nothing.

```lisp
(defun coffee ()
  (cond
    ((< *energy* 4)
     (format t "steam. the button lies. energy ~a~%" *energy*)
     'steam)
    (t
     (setf *energy* (- *energy* 4))
     (format t "sludge. not coffee. but it's hot. energy ~a~%" *energy*)
     'sludge)))
```

#repl-note[
  This is not a new game. This is *the same world*. `coffee` changes the same global as `tick`. If after patching the crack you drink twenty cups, energy still runs out. Honest plot: duct tape is not an infinite reactor.
]

Add a `coffee` command with no arguments to `play`. Nothing new in `world-plist`: energy is already there. The save itself remembers how much you "drank."

#exercise("S.L7", "Lisp")[
  The machine pours only if you're in `galley`. Otherwise `'wrong-room`. If the `mug` is in the pocket — different text: "at least into Щ's mug, not on the floor." Without the mug — on the floor, energy still gets charged. The station is not a nanny.
]

The napkin map doesn't change after the machine. What changes is the meaning of the galley: now it isn't a set with a note, it's a room with a side effect. That's how graphs come alive. Not with a picture. With a verb.

== Watch 9. Antenna and cargo — the graph grows without a picture

Five circles on the napkin. The station lies: there are two more hatches Щ. didn't finish drawing, because the pencil broke. We'll finish them with parentheses.

- `cargo` — the hold. Smells of dust and boxes that say "this side up" in three languages, all lying.
- `antenna` — the antenna bay. Cold. A small window. From here they blinked at Earth until the connector froze.

Hatches. Cargo from the airlock: makes sense, you don't haul freight through the galley. Antenna from the cupola: also makes sense, the cable already goes there. In a graph, logic is an edge, not "well it's nearby."

```lisp
(defparameter *doors*
  '((airlock  . (corridor cargo))
    (corridor . (airlock galley reactor))
    (galley   . (corridor cupola))
    (reactor  . (corridor))
    (cupola   . (galley antenna))
    (cargo    . (airlock))
    (antenna  . (cupola))))
```

#slow[
  An edge is written *twice* if the hatch is two-way. You added `(airlock . (corridor cargo))` and forgot `(cargo . (airlock))` — you can't leave the hold. That isn't a Lisp bug. That's you drawing a one-way door and being surprised. Check `(neighbors 'cargo)` right away, not after a plot arc.
]

A room with no line in `*flavor*` — `assoc` returns `nil`, `cdr` of `nil` in `look` gives `nil`, `format` prints `NIL`. Honest and ugly. Add a description in the same moment as the edge. `*at*` too: otherwise `stuff-here` will fall over or eat someone else's pocket.

```lisp
(setf *flavor*
      (append *flavor*
              '((cargo   . "dust. a box that says this side up. they already tumbled it.")
                (antenna . "cold. the connector is frosted. earth is far and in no hurry."))))

(setf *at*
      (append *at*
              '((cargo   . (solder))
                (antenna . (frost-note)))))
```

`solder` — solder. Useful when frost on the antenna won't take duct tape. `frost-note` — a note from Щ.: "don't blow a hair dryer. energy. patience."

`append` on a global doesn't change the old list in place — it *builds a new one*. That's why `setf`. If you write a bare `append` and don't assign, the world stays five rooms, and you'll yell at the REPL. A classic.

Update `reset-world` too. Otherwise after a reset the new compartments vanish, as if Щ's pencil broke again. Reset is a contract with yourself: the *whole* world in one place.

In the REPL after fixing the doors:

```lisp
(neighbors 'airlock)  ; (CORRIDOR CARGO)
(walk 'cargo)
(take 'solder)
(walk 'airlock)
(walk 'corridor)
; ... to the cupola, then:
(walk 'antenna)
```

If `walk` yells "no hatch," you're either in the wrong room, or the edge is one-way, or `*here*` isn't what you think. `(look)` before panic. The panel lies less than memory.

#exercise("S.L8", "Lisp")[
  Put `cargo` and `antenna` into `*doors*`, `*at*`, `*flavor*`, and into `reset-world`. Command `read-frost-note`: if `frost-note` is in the pocket — print Щ's warning about the hair dryer. Not in the pocket — honestly say where it lies (antenna). Check: airlock to cargo and back; cupola to antenna; reactor to antenna in one `walk` — no.
]

== Watch 10. Two bugs that look like "Lisp broke"

It didn't break. You forgot a quote. Or you built nested dolls with no last doll. We'll take both apart, slowly, in this same world.

=== Bug 1. Forgot the apostrophe

You want to go to the reactor. You type like a human:

```lisp
(walk reactor)
```

SBCL yells something like: variable `REACTOR` is unbound. Or it tries to *call* function `reactor`. Depends what's on that name. Either way you didn't walk.

#slow[
  Lisp first *evaluates* arguments, then calls the function. `walk` wants a room symbol. `'reactor` — "put the tag, don't evaluate." Without the apostrophe `reactor` is "find this variable's value / call this name." No variable. No function. Fire.
]

Compare in the REPL, not in your head:

```lisp
'reactor     ; REACTOR  — a tag
reactor      ; error, if no defun / defparameter
'corridor
(walk 'corridor)   ; a move
(walk corridor)    ; error again, unless you (defparameter corridor 'corridor) for a joke. don't.
```

The same pit with `take`:

```lisp
(take tape)     ; looks for variable TAPE
(take 'tape)    ; takes the item
```

And with the world's `defparameter`:

```lisp
(defparameter *here* airlock)   ; evaluates airlock — no such thing
(defparameter *here* 'airlock)  ; standing in the airlock
```

#repl-note[
  The apostrophe is not decoration. It's an order "don't cook, put it raw." The string `"reactor"` is another type. `eq` of a symbol and a string won't work. `walk` compares symbols. That's why in `play` we did `intern` and `string-upcase`: a bridge from human text to a tag.
]

If the error says `undefined variable` / `unbound` and the form has no apostrophe on a room or item name — put `'` first, don't rewrite the engine.

=== Bug 2. Infinite recursion

The station graph is *cyclic*: airlock ↔ corridor. A walk with no "already been" pocket goes in a circle until the stack runs out.

Here's the "obvious" function "every room I can reach":

```lisp
(defun reachable-broken (from)
  (cons from
        (mapcan (lambda (n) (reachable-broken n))
                (neighbors from))))
```

Call `(reachable-broken 'airlock)`. Don't wait an hour. In a moment: `Control stack exhausted` / stack overflow. This is not "the computer is weak." This is nested dolls: airlock → corridor → airlock → corridor → …

#slow[
  Recursion with no stop on *this same* node is infinity. A stop of "no neighbors" doesn't save here: there are always neighbors, they're just yours. You need a `seen` list. Watch 6 already wrote it. Break it on purpose, look at the bedsheet, *then* put `seen` back. Otherwise the word "stack" stays a sound.
]

Second classic — a function calls itself *with the same argument*:

```lisp
(defun look ()
  (look)
  (format t "you're in ~a~%" *here*))
```

The first line of the body is `look` again. The queue never reaches `format`. The stack grows. Same error, even dumber cause: a typo "call myself instead of `look-at-doors`," or `walk` at the end calls `look`, and `look` out of kindness calls `walk` into the same room.

```lisp
; ring walk → look → walk
(defun walk (to)
  (setf *here* to)
  (look))
(defun look ()
  (walk *here*))   ; "refresh," ha
```

Cure: draw arrows of *who calls whom*. If it's a ring with no change of argument — you didn't walk the graph, you sat on a fan.

How to read the error: from the top (or the bottom, whichever helps) look for *your* function, repeated many times in a row. `LOOK LOOK LOOK LOOK` — there it is. Not `SBCL internals` for two screens.

The `reachable` fix is the one already there: `seen`, `unless (member room seen)`, `push`, then neighbors. Check: `(reachable 'airlock)` returns seven compartments, doesn't die. Cut the hatch `cupola → antenna` and start from the airlock — `antenna` isn't in the list. That's a graph, not a picture.

#exercise("S.L9", "Lisp")[
  Reproduce both bugs *on purpose*: (1) `(walk reactor)` without the apostrophe — write the exact error text in the log; (2) `reachable-broken` — see the stack overflow, don't leave it spinning. Then fix (2) via `seen`. Compare the list length with seven rooms. If fewer rooms — you forgot an edge one way.
]

== Watch 11. Frost on the antenna — repair as a fight

Not orcs. Frost. Thickness in made-up centimeters. You hit with heat, frost hits the station's energy. Who runs out first.

The world already knows `*energy*`. Add an opponent:

```lisp
(defparameter *frost* 12)
```

12 — thickness. 0 — the connector is dry, the antenna can `ping`. Each `blast` is a heat flash: −3 to frost, −5 to energy. Only in `antenna`. If energy is under 5 — the flash won't flash, print `'too-dark`.

```lisp
(defun blast ()
  (cond
    ((not (eq *here* 'antenna))
     (format t "the frost isn't here. drag your feet to antenna.~%")
     'wrong-room)
    ((< *energy* 5)
     (format t "dark. nothing to heat with. energy ~a~%" *energy*)
     'too-dark)
    ((<= *frost* 0)
     (format t "already dry. don't be a hero, the connector hates it.~%")
     'already-clear)
    (t
     (setf *energy* (clamp-energy (- *energy* 5)))
     (setf *frost* (max 0 (- *frost* 3)))
     (format t "hisses. frost ~a, energy ~a~%" *frost* *energy*)
     (if (<= *frost* 0) 'clear 'frosted))))
```

#repl-note[
  `max 0` — so frost doesn't go negative and become "even drier." No meaning, the plot spoils. `clamp-energy` is already on energy. Two guards, two resources. That's the whole "combat system": two numbers and a rule for when a move is legal.
]

Solder from the hold is a strong move. Costs 8 energy, strips 8 frost. No solder in the pocket — `'need-solder`. With solder — removes the item (once, this is not an infinite spool).

```lisp
(defun solder-joint ()
  (cond
    ((not (eq *here* 'antenna)) 'wrong-room)
    ((not (member 'solder *pocket*)) 'need-solder)
    ((< *energy* 8) 'too-dark)
    (t
     (setf *energy* (clamp-energy (- *energy* 8)))
     (setf *frost* (max 0 (- *frost* 8)))
     (setf *pocket* (remove 'solder *pocket*))
     (format t "solder sat. frost ~a~%" *frost*)
     (if (<= *frost* 0) 'clear 'frosted))))
```

Frost is not a gentleman. If you aren't repairing, and just `walk` in the antenna (or stay — we'll make `wait`):

```lisp
(defun wait ()
  (unless *fixed*
    (tick))
  (when (and (eq *here* 'antenna) (> *frost* 0))
    (setf *frost* (+ *frost* 1))
    (format t "frost grew. now ~a~%" *frost*))
  (status))
```

Losing: energy 0, frost still > 0. Winning: frost 0, you're in the antenna, you can blink:

```lisp
(defun ping-earth ()
  (cond
    ((not (eq *here* 'antenna)) 'wrong-room)
    ((> *frost* 0) 'iced)
    ((< *energy* 15) 'too-dark)
    (t
     (setf *energy* (clamp-energy (- *energy* 15)))
     (format t "ping gone. earth doesn't have to answer. you did what you could.~%")
     'ping)))
```

A rehearsal round, not a novel:

```lisp
(reset-world)
(walk 'cargo)
(take 'solder)
; get to antenna via corridor galley cupola, energy drips
(solder-joint)
(blast)      ; if not dry yet
(ping-earth)
```

Add `*frost*` to `reset-world` (12 again) and to `world-plist` / `apply-world`. Otherwise the save forgets the war with frost, and that's insulting after three flashes.

In `play` the commands: `blast`, `solder`, `wait`, `ping`. No arguments. A third word the station will still swallow. Live.

#warn[
  Don't add a "random crit" on the first watch. First the rule has to be repeatable: 12 frost, blast by 3, count on paper how many flashes. If paper and REPL disagree — the code is lying. Then `(random 3)`, if it itches.
]

#exercise("S.L10", "Lisp")[
  `blast` / `solder-joint` / `ping-earth` as above. Win — `'ping` after a dry connector. Lose — `walk` or `blast` at energy 0. In `status` print frost. The save remembers `*frost*`. Check: without solder, clear it with flashes; with solder — fewer moves. Write in a comment how much energy each scenario cost.
]

== Watch 12. What's in the save, syllable by syllable

The file `module-save.lisp-data` is not a novel and not JSON. It's what `print` wrote so `read` would chew it. Open it *with your eyes* after `(save-world "module-save.lisp-data")`.

Typical mash (your numbers will differ):

```
(:ENERGY 86 :LEAK 7 :HERE CORRIDOR :POCKET (TAPE) :AT ((AIRLOCK) (CORRIDOR) ...) :DOORS ((AIRLOCK CORRIDOR CARGO) ...) :FIXED NIL :FROST 12)
```

We go left to right, like a storekeeper.

*A list.* The outer parentheses — one form. `read` will eat it whole. Lose a closer — `read` will wait until end of file and get offended. Add an extra — the next form, `load-world` isn't waiting for it, the world will chew only the first, ignore the tail or fall over. Not "almost JSON." Parentheses count.

*Keys with a colon.* `:ENERGY` is a keyword. It's its own value, no quote needed. `getf` looks for exactly that. Write `ENERGY` without the colon — a different object, `getf` returns `nil`, energy becomes `nil`, `tick` explodes on subtraction. The colon is not decoration.

*Numbers.* `86` is a number. Not `"86"`. If you type quotes by hand, `*energy*` becomes a string, `(- *energy* 7)` will say type error. Hand-editing a save is fine for study, don't change the type.

*Symbols.* `CORRIDOR`, `TAPE`, `NIL`. Not strings. `NIL` is both false and the empty list, we already ate that. `:FIXED NIL` means "the crack still hisses," not "the string nil."

*Nested parentheses.* Pocket `(TAPE)` — a list of one symbol. Empty pocket — `NIL` or `()`. `*at*` and `*doors*` are alists, that is lists of pairs. If in a hand edit you break the pair `(AIRLOCK . (CORRIDOR CARGO))` into `(AIRLOCK CORRIDOR CARGO)` without the dot — `cdr` will return the wrong thing, `neighbors` will go mad. The dot in an alist is "here's the pair's tail." Not a period at the end of a sentence.

#slow[
  `print` writes for `read`. `format` writes for you. A save is `print`. If "to make it pretty" you stick in commas like JSON, `read` will choke. A comma in Lisp is other syntax (not your friend here). Spaces are fine. Commas — no.
]

A useful hand sabotage:

```lisp
(reset-world)
(save-world "module-save.lisp-data")
```

Open the file in an editor. Change `:ENERGY 100` to `:ENERGY 3`. Save. In the REPL:

```lisp
(load-world "module-save.lisp-data")
(status)
```

Energy should be 3. If it's 100 — you loaded the wrong path, or after `load-world` you called `reset-world`. Order: game code → `load-world` → *no* reset.

Second sabotage: delete one closing parenthesis. `load-world` should fall over. Read the error. Put the parenthesis back. This is not "the file is mystically broken." The form isn't closed.

Third: write `:ENERGY "lots"`. The load may pass, the world becomes poisonous. The first `tick` will show the truth. There's no validation in `apply-world` — this is a teaching save, not a bank. That's why `read` from *your* disk is ok, from a disk on the internet — no. We already yelled, we're yelling again.

#exercise("S.L11", "Lisp")[
  Save the world, by hand set `:FROST 1` and `:HERE ANTENNA`. Load. One `blast` should make frost 0 (if energy is enough). Second file: break a parenthesis, catch the `read` error, fix it. In the watch log — one sentence: how a `print`-save differs from `energy=80` in the Java dashboard.
]

== Why this was here

You made: state, a graph, items, a side effect, a save, a tiny command language, two new compartments, two bugs taken apart, a war with frost. That's the whole profession, only without a salary and without Jira.

In the main course the same ideas will arrive as `TaskStore`, HTTP, and a table. Here they smell of airlock metal. You can go back to watch 1 and add a second crack. You can not go back. The log doesn't grade you.

If you got hooked and you're writing a text station for a third night — set an alarm for Java. Station MODULE on a résumé doesn't feed you. Parentheses feed the brain. The brain then feeds Java.

#sunday[
  Draw seven circles and the hatches. Walk a token. Then walk in the REPL. If they disagree — either the paper is lying, or `*doors*`. Usually `*doors*`.
]
