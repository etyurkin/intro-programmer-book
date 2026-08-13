TYPST := typst
TYPST_HTML := $(TYPST) compile --features html --format html
PANDOC := pandoc

SRC := src
OUT := out

PDF := $(OUT)/intro-k-professii-programmist.pdf
PDF_EN := $(OUT)/intro-to-the-programming-profession.pdf
HTML := $(OUT)/intro-k-professii-programmist.html
HTML_EN := $(OUT)/intro-to-the-programming-profession.html
EPUB := $(OUT)/intro-k-professii-programmist.epub
EPUB_EN := $(OUT)/intro-to-the-programming-profession.epub

.PHONY: all pdf pdf-en pdfs html html-en epub epub-en epubs books watch clean

all: books

$(OUT):
	mkdir -p $(OUT)

pdf: $(OUT)
	$(TYPST) compile $(SRC)/book.typ $(PDF)

pdf-en: $(OUT)
	$(TYPST) compile $(SRC)/book-en.typ $(PDF_EN)

pdfs: pdf pdf-en

html: $(OUT)
	$(TYPST_HTML) $(SRC)/book.typ $(HTML)

html-en: $(OUT)
	$(TYPST_HTML) $(SRC)/book-en.typ $(HTML_EN)

epub: html
	$(PANDOC) $(HTML) -o $(EPUB) \
		--from html --to epub3 \
		--css $(SRC)/epub.css \
		--toc --toc-depth=2 --split-level=2 \
		--metadata lang=ru \
		--metadata title="Введение в профессию программиста" \
		--metadata creator="Евгений Тюркин"

epub-en: html-en
	$(PANDOC) $(HTML_EN) -o $(EPUB_EN) \
		--from html --to epub3 \
		--css $(SRC)/epub.css \
		--toc --toc-depth=2 --split-level=2 \
		--metadata lang=en \
		--metadata title="Introduction to the Programmer's Profession" \
		--metadata creator="Evgeniy Tyurkin"

epubs: epub epub-en

books: pdfs epubs

watch: $(OUT)
	$(TYPST) watch $(SRC)/book.typ $(PDF)

clean:
	rm -rf $(OUT)
	rm -f intro-k-professii-programmist.pdf intro-k-professii-programmist.html intro-k-professii-programmist.epub
	rm -f intro-to-the-programming-profession.pdf intro-to-the-programming-profession.html intro-to-the-programming-profession.epub
