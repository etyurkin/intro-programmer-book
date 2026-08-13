TYPST := typst
TYPST_HTML := $(TYPST) compile --features html --format html
PANDOC := pandoc

PDF := intro-k-professii-programmist.pdf
PDF_EN := intro-to-the-programming-profession.pdf
HTML := intro-k-professii-programmist.html
HTML_EN := intro-to-the-programming-profession.html
EPUB := intro-k-professii-programmist.epub
EPUB_EN := intro-to-the-programming-profession.epub

.PHONY: all pdf pdf-en pdfs html html-en epub epub-en epubs books watch clean

all: books

pdf:
	$(TYPST) compile book.typ $(PDF)

pdf-en:
	$(TYPST) compile book-en.typ $(PDF_EN)

pdfs: pdf pdf-en

html:
	$(TYPST_HTML) book.typ $(HTML)

html-en:
	$(TYPST_HTML) book-en.typ $(HTML_EN)

epub: html
	$(PANDOC) $(HTML) -o $(EPUB) \
		--from html --to epub3 \
		--css epub.css \
		--toc --toc-depth=2 --split-level=2 \
		--metadata lang=ru \
		--metadata title="Введение в профессию программиста" \
		--metadata creator="Евгений Тюркин"

epub-en: html-en
	$(PANDOC) $(HTML_EN) -o $(EPUB_EN) \
		--from html --to epub3 \
		--css epub.css \
		--toc --toc-depth=2 --split-level=2 \
		--metadata lang=en \
		--metadata title="Introduction to the Programmer's Profession" \
		--metadata creator="Evgeniy Tyurkin"

epubs: epub epub-en

books: pdfs epubs

watch:
	$(TYPST) watch book.typ $(PDF)

clean:
	rm -f $(PDF) $(PDF_EN) $(HTML) $(HTML_EN) $(EPUB) $(EPUB_EN)
