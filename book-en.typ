#import "lib-en.typ": *

#set document(
  title: "Introduction to the Programmer's Profession",
  author: ("Evgeniy Tyurkin", "Grok"),
  keywords: ("programming", "Common Lisp", "Java", "Spring", "emagent"),
)

#set page(
  paper: "a4",
  margin: (inside: 2.4cm, outside: 2.0cm, top: 2.2cm, bottom: 2.4cm),
  numbering: none,
)

#set text(font: ("Times New Roman", "Liberation Serif"), lang: "en", size: 12pt, hyphenate: true)
#set par(justify: true, leading: 0.84em, first-line-indent: 0pt, spacing: 0.7em)
#set heading(numbering: "1.1")
#show raw: set text(font: ("Menlo", "Consolas", "Courier New"), size: 8.6pt)
#set list(indent: 1em)
#set enum(indent: 1em)

#show heading: it => {
  set par(first-line-indent: 0pt)
  v(0.55em)
  it
  v(0.2em)
}

#show heading.where(level: 1): it => {
  set par(first-line-indent: 0pt, justify: false)
  if it.numbering == none {
    set text(size: 22pt)
    v(0.6cm)
    it
    v(0.5em)
  } else {
    pagebreak(weak: true)
    set text(size: 20pt)
    v(1.2cm)
    text(size: 10pt, fill: rgb("#6b6458"), weight: "regular")[Chapter]
    v(0.2em)
    it
    v(0.8em)
  }
}

#show raw.where(block: true): it => {
  set par(first-line-indent: 0pt, justify: false)
  block(
    width: 100%,
    fill: rgb("#f6f4ee"),
    stroke: 0.4pt + rgb("#ddd6c6"),
    inset: 9pt,
    radius: 2pt,
    it,
  )
}

#show raw.where(block: false): it => box(
  fill: rgb("#f0ece3"),
  inset: (x: 3pt, y: 1pt),
  radius: 2pt,
  it,
)

#show link: it => underline(stroke: 0.4pt + rgb("#3d5a80"), it)

#titlepage
#pagebreak()
#authorspage
#pagebreak()
#aboutpage
#pagebreak()
#ackspage

#pagebreak()
#set page(numbering: "1", header: context {
  set text(size: 8.5pt, fill: rgb("#5a564c"))
  grid(
    columns: (1fr, 1fr),
    align: (left, right),
    [_Introduction to the Programmer's Profession_],
    [Contents],
  )
  line(length: 100%, stroke: 0.3pt + rgb("#c9c3b4"))
})
#counter(page).update(1)
#set par(first-line-indent: 0pt, justify: false)
#outline(title: [Contents], indent: 1.2em, depth: 2)

#set page(header: context {
  set text(size: 8.5pt, fill: rgb("#5a564c"))
  grid(
    columns: (1fr, 1fr),
    align: (left, right),
    [_Introduction to the Programmer's Profession_],
    [Lisp · Java · 26 weeks],
  )
  line(length: 100%, stroke: 0.3pt + rgb("#c9c3b4"))
})
#set par(first-line-indent: 0pt, justify: true, spacing: 0.7em)

#include "ch-en/00-preface.typ"
#include "ch-en/01-profession.typ"
#include "ch-en/01b-computer.typ"
#include "ch-en/02-workshop.typ"
#include "ch-en/03-month1.typ"
#include "ch-en/04-month2.typ"
#include "ch-en/05-month3.typ"
#include "ch-en/06-month4.typ"
#include "ch-en/07-month5.typ"
#include "ch-en/08-month6.typ"
#include "ch-en/08b-android.typ"
#include "ch-en/09-solutions.typ"
#include "ch-en/10-appendix.typ"
#include "ch-en/11-glossary.typ"
#include "ch-en/12-station-log.typ"
#include "ch-en/12b-macros-clos.typ"
#include "ch-en/13-java-lab.typ"
