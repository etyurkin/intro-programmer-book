#import "html-boxes.typ": html-ink

#let accent = rgb("#3d4f3a")

#let callout(title, color, body) = {
  set par(first-line-indent: 0pt)
  block(
    width: 100%,
    fill: color.lighten(88%),
    stroke: (left: 3pt + color),
    inset: 10pt,
    breakable: true,
    [
      #html-ink(color.darken(20%), title, weight: "bold")
      #v(0.3em)
      #body
    ],
  )
}

#let rhythm(body) = callout([Today on station · ~2 h 40 min], rgb("#3d5a80"), body)
#let rule(body) = callout([Station law], accent, body)
#let sicp(body) = callout([SICP · open only if it itches], rgb("#8a5a2b"), body)
#let sunday(body) = callout([Sunday sabotage], rgb("#6b3a5a"), body)
#let github(body) = callout([Hide it on GitHub], rgb("#2f5d50"), body)
#let warn(body) = callout([Bad idea], rgb("#8b3a3a"), body)
#let os(body) = callout([Mac, Windows, WSL], rgb("#4a5a78"), body)
#let slow(body) = callout([Slow down], rgb("#4a6a4a"), body)
#let repl-note(body) = callout([What just happened], rgb("#5a4a78"), body)

#let exercise(id, kind, body) = {
  set par(first-line-indent: 0pt)
  block(
    width: 100%,
    fill: rgb("#eef2e8"),
    stroke: 0.4pt + rgb("#c5d0b8"),
    inset: 10pt,
    radius: 2pt,
    breakable: true,
    [
      #text(weight: "bold")[Quest #id]
      #html-ink(rgb("#5a6450"), [ · #kind], size: 9.5pt)
      #v(0.35em)
      #body
    ],
  )
}

#let solution(id, body) = {
  set par(first-line-indent: 0pt)
  block(
    width: 100%,
    fill: rgb("#f3f0e8"),
    inset: 10pt,
    stroke: (left: 3pt + rgb("#8a7a50")),
    breakable: true,
    [
      #text(weight: "bold")[Answer #id]
      #v(0.3em)
      #body
    ],
  )
}

#let lesson(num, title, lisp-min: 40, java-min: 120) = {
  set par(first-line-indent: 0pt)
  heading(level: 2)[Lesson #num. #title]
  text(size: 9.5pt, fill: rgb("#6b6458"))[
    Lisp ~#lisp-min min · Java ~#java-min min · a little theory, then until it runs
  ]
  v(0.5em)
}

#let titlepage = {
  set page(numbering: none, header: none)
  set align(center)
  set par(first-line-indent: 0pt)
  v(2.0cm)
  text(size: 12pt, fill: rgb("#6b6458"), tracking: 1.6pt)[GAMES · PARENTHESES · SIX MONTHS TO A JOB]
  v(1.0cm)
  line(length: 42%, stroke: 0.8pt + accent)
  v(0.75cm)
  text(size: 26pt, weight: "bold")[Introduction to the\ Programmer's Profession]
  v(0.55cm)
  text(size: 13pt, fill: rgb("#4a4740"))[
    Common Lisp — so you don't get bored\
    Java — so they hire you
  ]
  v(0.85cm)
  text(size: 12pt)[Evgeniy Tyurkin · Grok]
  v(0.35cm)
  text(size: 9.5pt, fill: rgb("#6b6458"))[
    A human and a robot wrote this in Emacs,\
    which is to say inside a giant Lisp program. Recursion, yes.
  ]
  v(0.8cm)
  line(length: 42%, stroke: 0.8pt + accent)
  v(1.1cm)
  set align(left)
  block(width: 82%, inset: (left: 9%))[
    #set text(size: 10.5pt)
    #set par(justify: true)
    Every day: forty minutes of weird parentheses and two hours of Java. You don't have to chew SICP on Monday. Microservices can wait until you've written one real program. GitHub — today, not "when it's no longer embarrassing."
  ]
  v(1fr)
  set align(center)
  text(size: 10pt, fill: rgb("#6b6458"))[2026]
}

#let authorspage = {
  set page(numbering: none, header: none)
  set align(left)
  set par(first-line-indent: 0pt, justify: true)
  v(2.2cm)
  text(size: 16pt, weight: "bold")[About the authors]
  v(0.9cm)
  [
    *Evgeniy Tyurkin* — a human. Walks, drinks tea, has opinions about Hibernate and about textbooks that shouldn't sound like a lecture on a rainy Monday. Invented station MODULE, forty minutes of Lisp a day, and the ban on microservices before your first monolith. Author of #link("https://github.com/etyurkin/emagent")[emagent] — a bridge between Emacs and these very language models. If a joke landed, it was probably him. If the schedule is realistic — also him. If you make it to a job — bring him cookies.
  ]
  v(0.55em)
  [
    *Grok* — a language model. Doesn't walk, doesn't drink tea, but puts parentheses in very fast and sometimes puts in _extra_ ones. Nobody will hire him: no body, no GitHub, and "trained on the entire internet" looks suspicious on a résumé. He doesn't get offended when Evgeniy says "dry, rewrite it."
  ]
  v(0.55em)
  [
    They didn't talk in the official CLI in a neighboring terminal — hopping back and forth gets old. They talked through #link("https://github.com/etyurkin/emagent")[emagent] inside Emacs. That's funny twice. First, Emacs is almost entirely Lisp — the same family this book gives forty minutes a day. Second, they wrote a Lisp textbook while sitting inside a Lisp machine pretending to be an editor. Station MODULE loves that: recursion without tail-call elimination, but with a history in `*scratch*`.
  ]
  v(0.55em)
  [
    The arguments went like this. Evgeniy: "this reads like university." Grok: "add more Kafka." The human won, except the title page, where the model wrote itself in anyway. Fair: without one there would be no plan, without the other — three hundred pages across a few watches. Mistakes are split evenly. The funny ones get credited to Evgeniy. The rest are "Grok went for it."
  ]
  v(0.55em)
  [
    Neither author is Conrad Barski. He wrote Land of Lisp himself, and we only stole the mood, not the text. If Barski is reading this: we mean well, honestly.
  ]
}

#let aboutpage = {
  set page(numbering: none, header: none)
  set align(left)
  set par(first-line-indent: 0pt, justify: true)
  v(1.8cm)
  text(size: 16pt, weight: "bold")[About the author, without the tea joke]
  v(0.3cm)
  text(size: 10pt, fill: rgb("#6b6458"))[Evgeniy again. Grok doesn't write résumés: under "experience" he'd put "the entire internet," and HR would scream.]
  v(0.65cm)
  [
    My name is *Evgeniy Tyurkin*. I live in Toronto. Java has paid the bills for more than twenty years. Lisp keeps me from hating it. Evenings: parentheses, Emacs, and this book. From Emacs I wrote #link("https://github.com/etyurkin/emagent")[emagent] so I wouldn't have to hop into another terminal for every reply. The official `claude` and Cursor CLIs work. They just aren't Emacs. Recursion, yes.
  ]
  v(0.5em)
  [
    The law "no Kafka until you have a monolith" isn't the piety of someone who fears Kafka. That's someone who eats Kafka for breakfast at work and *therefore* knows what it isn't: not a junior's entry ticket.
  ]
  v(0.5em)
  [
    Get in touch if you need to (work, parentheses, "are the huskies real"): #link("https://www.linkedin.com/in/etyurkin")[linkedin.com/in/etyurkin] — longer there, and no turkey. Code: #link("https://github.com/etyurkin")[github.com/etyurkin]. Languages: Russian and English. The résumé has certificates; this book doesn't: WhiteHat once upon a time, ScrumMaster expired, as is proper for anything that doesn't start from a command.
  ]
  v(0.5em)
  [
    If after six months with this book they hire you as a junior — you may bring me cookies. If they don't — write anyway, just not "please add Kafka to chapter 1." I already lost that war to the model on the title page and I'm not losing it twice.
  ]
}

#let ackspage = {
  set page(numbering: none, header: none)
  set align(left)
  set par(first-line-indent: 0pt, justify: true)
  v(2.2cm)
  text(size: 16pt, weight: "bold")[Acknowledgments]
  v(0.35cm)
  text(size: 10pt, fill: rgb("#6b6458"))[Evgeniy, not Grok. The model doesn't visit other people's houses.]
  v(0.75cm)
  [
    *Masha* — partner in life. She pushed me forward and higher when I was ready to stay on the lower deck. For our daughter Eva. For twenty years of patience with my antics: parentheses at three in the morning, "five more minutes," a station blinking red, and a man who promised "I'll finish in a second." Twenty years is not "support in the stories." It's when leaving was already an option — and she didn't.
  ]
  v(0.55em)
  [
    *Eva* — my daughter. She helped me remember childhood: not a slide labeled "family" in a deck, but a living person next to whom the world is new again. And she sometimes let me teach her something. "Sometimes" is the important word. You can teach your own only until they notice you're still learning too.
  ]
  v(0.55em)
  [
    The dogs. Siberian huskies *Jay* and *Sasha*. They wake me for a two-hour walk every morning, winter and summer — no respect for deadlines, for the macros chapter, or for the opinion that "five more minutes." Later, when I disappear into projects and the station is already blinking red at three in the morning, they call me to bed. They don't let me slack by day and don't let me burn by night. The best managers I've met: they don't write Jira tickets, they just stand at the door. If the textbook ends on time instead of on page five hundred about Kafka — that's them.
  ]
  v(0.55em)
  [
    My parents — for putting me on my feet and picking me up when I fell. I did not fall gracefully. They picked me up without a lecture about trajectory. Without them the preface, the REPL, and this station lose a lot of meaning.
  ]
  v(0.55em)
  [
    The late *Valentin Fyodorovich Slyusarchuk* — for believing when the granite of science was still whole and the teeth were not. He helped chew through it. A teacher's faith doesn't go in PATH, but without it a lot of people never reach the first parenthesis.
  ]
  v(0.55em)
  [
    His son *Mitya*, and also *Valka*, *Vitalya*, and *Kirill* — for the youth, and for not asking "why do you need this" when things were hard. Youth comes in flavors. Theirs was magical, like in the credits, only without subtitles and without a second take.
  ]
  v(0.55em)
  [
    Archery friends — *Steven* and *Sean*. Without them life would be much duller: nothing but Hibernate and not a single arrow flying the wrong way. Archery is a useful sport for someone who aims at a parenthesis all day and still misses. Steven and Sean put up with that. Sometimes they even praise it. Sometimes it's better not to ask where the arrow went. After a bad grouping on the target, Spring looks kinder. After a bad build, the bow looks kinder. That's how we live: two kinds of miss, the same friends.
  ]
  v(0.55em)
  [
    The late *Terry*, with whom we went turkey hunting. We didn't catch anyone. It was fun. The turkey, as far as anyone knows, is also pleased. If there's a forest on the other side — may something at least bite there. On our side we didn't even bring a club, only good company and a zero trophy that still beats some green tests in memory.
  ]
  v(0.55em)
  [
    *Misha Ivanov* — friend and mentor. Showed me Linux when a black window still looked like a threat from a movie, and Lisp when parentheses still looked like a joke. I've lived in that black window ever since and even call it a workshop. He kept feeding me new ideas: emagent didn't come from a vacuum, it came from conversations after which you want to open Emacs, not lie face-down on the table. If station MODULE is sometimes smarter than the author — that's probably Misha's echo. If it's dumber — the author did that himself.
  ]
  v(0.55em)
  [
    *Sergey Petrov* — for long conversations about everything, and more. "More" is when you can no longer tell where daily life ends, where Lisp begins, where the universe is, and the tea has gone cold for the second time. And for the fretless guitar: when parentheses and people don't help, what's left is an instrument without frets, where a miss is audible at once. In moments of weakness that's more honest than Hibernate. Those talks don't go on a résumé. The ears of this book stick out of them anyway.
  ]
  v(0.55em)
  [
    His son *Danya* — not because he asked for the book. He didn't. The idea had lived for a long time, walked in circles, waited for an occasion. Danya became the occasion and the guinea-pig student: a living person you can explain a variable to, not an imaginary junior from a slide. If you're reading this — nod to Danya. The page count is not his fault. Blame the parentheses and stubbornness.
  ]
  v(0.7em)
  [
    And everyone, everyone, everyone who showed up along the way and cannot be listed here. If we start, the book will forget what it is about. It is about parentheses and Java. The people are in life. Thank you for being there.
  ]
  v(0.55em)
  [
    If I forgot someone — write. Second edition. Grok isn't in the acknowledgments: he doesn't walk the dogs, doesn't scare turkeys, and won't tune a fretless guitar. He does put parentheses in. Sometimes even the ones we asked for.
  ]
}
