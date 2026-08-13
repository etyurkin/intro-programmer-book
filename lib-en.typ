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
      #text(weight: "bold", fill: color.darken(20%), title)
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
      #text(size: 9.5pt, fill: rgb("#5a6450"))[ · #kind]
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
    They didn't talk in a browser chat. They talked through #link("https://github.com/etyurkin/emagent")[emagent] inside Emacs. That's funny twice. First, Emacs is almost entirely Lisp — the same family this book gives forty minutes a day. Second, they wrote a Lisp textbook while sitting inside a Lisp machine pretending to be an editor. Station MODULE loves that: recursion without tail-call elimination, but with a history in `*scratch*`.
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
    My name is *Evgeniy Tyurkin*. I live in Toronto. By day — Staff Data Engineer at eBay: seller recommendations and analytics, Kafka, GraphQL, OpenSearch, Java, several datacenters that hate it when you "just restart the service for a minute." By evening — parentheses, Emacs, and this book. The huskies believe evening starts at 7 a.m. They're right more often than Kafka is.
  ]
  v(0.5em)
  [
    Twenty-plus years in the job, if you count from St. Petersburg, when they sat me down at Java and the client was called T-Mobile UK. Then browser VoIP with no install (yes, that once looked like the future), a requirements editor, then a long stretch at Oracle Eloqua — multi-tenant marketing, queues, streaming, mentoring people who later start yelling at Hibernate themselves. Then Ford's connected-vehicle cloud (Autonomic), a B2B platform on GCP, a short stop in agency analytics, and back to a marketplace. Master's from Siberian Federal University, systems analysis and management. This is not "I'm too important for Hello.java." This is "I was already fixing Hello.java in 2004 and I still do, only the paycheck changed."
  ]
  v(0.5em)
  [
    If you open this book and see the law "no Kafka until you have a monolith" — that isn't the piety of someone who fears Kafka. That's someone who eats Kafka for breakfast at work and *therefore* knows what it isn't: not a junior's entry ticket, and not a substitute for a program you can run. Microservices, Kubernetes, GraphQL — later, when there's something to slice. First there has to be something. Otherwise the résumé lies more beautifully than the code.
  ]
  v(0.5em)
  [
    Java pays my bills. Lisp keeps me from hating Java. Emacs is a hole I climbed into on purpose, and from there I wrote #link("https://github.com/etyurkin/emagent")[emagent] so I could talk to models not in a browser but inside a giant Lisp program. Recursion, yes. Again.
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
    *Mikhail Ivanov* — friend and mentor. Showed me Linux when a black window still looked like a threat from a movie, and Lisp when parentheses still looked like a joke. I've lived in that black window ever since and even call it a workshop. He kept feeding me new ideas: emagent didn't come from a vacuum, it came from conversations after which you want to open Emacs, not lie face-down on the table. If station MODULE is sometimes smarter than the author — that's probably Mikhail's echo. If it's dumber — the author did that himself.
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
    The dogs. Siberian huskies *Jay* and *Sasha*. They wake me for a two-hour walk every morning, winter and summer — no respect for deadlines, for the macros chapter, or for the opinion that "five more minutes." Later, when I disappear into projects and the station is already blinking red at three in the morning, they call me to bed. They don't let me slack by day and don't let me burn by night. The best managers I've met: they don't write Jira tickets, they just stand at the door. If the textbook ends on time instead of on page five hundred about Kafka — that's them.
  ]
  v(0.55em)
  [
    *Sergey Petrov* — for long conversations about everything, and more. "More" is when you can no longer tell where daily life ends, where Lisp begins, where the universe is, and the tea has gone cold for the second time. Those talks don't go on a résumé. The ears of this book stick out of them anyway.
  ]
  v(0.55em)
  [
    His son *Danya* — for the idea of writing it. Adults walk in circles: "we should write a textbook," "someday," "when there's time." Danya said it straight. After that, blame the parentheses and stubbornness. If you're reading this — nod to Danya. He didn't ask for a fee. A dog would have eaten the fee first anyway.
  ]
  v(0.55em)
  [
    And my parents — for the fact that I exist. Without that, the preface, the REPL, and the huskies lose a lot of meaning. Thank you for not talking me out of it when, instead of a "normal profession," there were parentheses, a bow, and two-hour walks in the snow. The normal profession, it turns out, is the parentheses. The rest is a bonus.
  ]
  v(0.7em)
  [
    If I forgot someone — write. Second edition. Or just come for a walk: Jay and Sasha share space, not chapters. Grok isn't in the acknowledgments: he doesn't walk, doesn't scare turkeys, and won't go on a two-hour walk by himself. He does put parentheses in. Sometimes even the ones we asked for.
  ]
}
