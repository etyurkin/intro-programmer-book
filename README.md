# Introduction to the Programmer's Profession

**Введение в профессию программиста**

A six-month beginner textbook: forty minutes of Common Lisp so you don’t get bored, two hours of Java so they hire you. Leaky orbital station **MODULE**, not a lecture on a rainy Monday.

Двадцать шесть недель: сорок минут Common Lisp — чтобы не соскучиться, два часа Java — чтобы взяли на работу. Дырявая орбитальная станция **«МОДУЛЬ»**, не лекция в дождливый понедельник.

Evgeniy Tyurkin · Grok · 2026

A human and a robot wrote this in Emacs, which is to say inside a giant Lisp program. Recursion, yes.

---

## Read the book

PDFs and EPUBs are built by GitHub Actions, not stored in git. EPUB reflows on a phone; PDF is the print layout.

- Latest files: [Releases / Latest books](https://github.com/etyurkin/intro-programmer-book/releases/latest)
- Or Actions → latest green run → Artifacts → `books`
- Or compile locally (`make books`)

| Language | PDF | EPUB |
|---|---|---|
| Русский | `out/intro-k-professii-programmist.pdf` | `out/intro-k-professii-programmist.epub` |
| English | `out/intro-to-the-programming-profession.pdf` | `out/intro-to-the-programming-profession.epub` |

macOS Preview: quit the app fully (**Cmd+Q**) before reopening a newly built PDF, or the sidebar table of contents may stay empty from a cached file.

## Who it’s for

Someone who has not programmed yet — or has, and bounced off annotations. Mac, Windows, WSL2. Java 21, Spring, PostgreSQL, then Redis / a queue / Docker, then interviews. Lisp stays at forty minutes a day the whole way: REPL, lists, a tiny language if you want, macros and CLOS when the main track is green.

You do **not** need Kafka in week one. You do need GitHub on day one, even if the commit is crooked.

## What this is not

- Not [Conrad Barski](https://www.nostarch.com/landoflisp)’s *Land of Lisp*. Same family of parentheses, different circus. We stole the mood, not the text. His orcs, our station.
- Not SICP from Monday. Open SICP when *you* ask why recursion works.
- Not “become a senior in 21 days.”
- Not a dump of Spring guides.

## Build from source

[Typst](https://github.com/typst/typst) 0.13+ (built with 0.15).

```bash
# macOS
brew install typst pandoc

# then
make books    # PDFs + EPUBs, both languages
make pdfs     # PDFs only
make epubs    # EPUBs only (needs pandoc)
make pdf-ru   # Russian PDF
make pdf-en   # English PDF
```

On Ubuntu CI (and WSL) the book uses Liberation Serif / Liberation Mono. On macOS, Times New Roman and Menlo if they exist; missing-font warnings are harmless.

```
make watch    # rebuild Russian PDF on save
make clean    # delete out/
```

## Repo layout

```
Makefile README.md LICENSE .gitignore
src/book.typ src/book-en.typ   # entry points
src/lib.typ src/lib-en.typ     # callouts, cover, authors, thanks
src/html-boxes.typ             # EPUB/HTML colors for the same boxes
src/ch-ru/                     # Russian chapters
src/ch-en/                     # English chapters
src/epub.css                   # phone wrapping + code background
out/                           # PDFs and EPUBs (gitignored)
```

Chapters: how to read → why this job → how a computer works → workshop → months 1–6 (Java backend + Lisp) → Android hatch if backend won’t open → answers → appendix → glossary → extra station log → macros & CLOS → more Java labs.

## Authors

**Evgeniy Tyurkin** — human. Toronto. Java for twenty-plus years; parentheses and Emacs by evening. The “no Kafka until you have a monolith” rule is from someone who eats Kafka at work and therefore knows it is not a junior’s entry ticket.

- LinkedIn: [linkedin.com/in/etyurkin](https://www.linkedin.com/in/etyurkin)
- GitHub: [github.com/etyurkin](https://github.com/etyurkin)
- emagent (Emacs ↔ models): [github.com/etyurkin/emagent](https://github.com/etyurkin/emagent)

**Grok** — language model. No body, no GitHub, will not get the job. Puts parentheses in very fast, sometimes extra ones. They wrote the book through emagent inside Emacs.

## License

[MIT](LICENSE). Copyright (c) 2026 Evgeniy Tyurkin.

Yes, that MIT. They used to teach computer science from SICP. Something went wrong, and now they teach Python. Apparently SICP really is a bit dry. We said so in the preface; they confirmed it with a whole curriculum.

Use the text and the example code. Keep the copyright notice. Don't republish Barski or SICP as this book — we didn't copy them, and you shouldn't either. Station MODULE is already on duct tape.

## Acknowledgments

In the book, after the author pages: Masha, Eva, huskies Jay and Sasha, parents, the late Valentin Fyodorovich Slyusarchuk, Mitya and friends, Steven and Sean, the late Terry, Misha Ivanov, Sergey Petrov (and the fretless guitar), Danya (the occasion, not the one who ordered the book). Then everyone who cannot be listed or the book forgets what it is about. Grok does not go on the thanks list. He doesn’t walk the dogs.
