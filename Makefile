TYPST := typst
TYPST_HTML := $(TYPST) compile --features html --format html
PANDOC := pandoc

SRC := src
OUT := out

PDF_RU := $(OUT)/intro-k-professii-programmist.pdf
PDF_EN := $(OUT)/intro-to-the-programming-profession.pdf
HTML_RU := $(OUT)/intro-k-professii-programmist.html
HTML_EN := $(OUT)/intro-to-the-programming-profession.html
EPUB_RU := $(OUT)/intro-k-professii-programmist.epub
EPUB_EN := $(OUT)/intro-to-the-programming-profession.epub
COVER_RU := $(OUT)/cover-ru.png
COVER_EN := $(OUT)/cover-en.png

.PHONY: all pdf-ru pdf-en pdfs html-ru html-en epub-ru epub-en epubs books watch clean

all: books

$(OUT):
	mkdir -p $(OUT)

pdf-ru: $(OUT)
	$(TYPST) compile $(SRC)/book.typ $(PDF_RU)

pdf-en: $(OUT)
	$(TYPST) compile $(SRC)/book-en.typ $(PDF_EN)

pdfs: pdf-ru pdf-en

html-ru: $(OUT)
	$(TYPST_HTML) $(SRC)/book.typ $(HTML_RU)

html-en: $(OUT)
	$(TYPST_HTML) $(SRC)/book-en.typ $(HTML_EN)

$(COVER_RU): $(SRC)/cover-ru.typ $(SRC)/lib.typ | $(OUT)
	$(TYPST) compile --format png --ppi 144 $(SRC)/cover-ru.typ $(COVER_RU)

$(COVER_EN): $(SRC)/cover-en.typ $(SRC)/lib-en.typ | $(OUT)
	$(TYPST) compile --format png --ppi 144 $(SRC)/cover-en.typ $(COVER_EN)

epub-ru: html-ru $(COVER_RU)
	$(PANDOC) $(HTML_RU) -o $(EPUB_RU) \
		--from html --to epub3 \
		--css $(SRC)/epub.css \
		--epub-cover-image $(COVER_RU) \
		--toc --toc-depth=2 --split-level=2 \
		--metadata-file $(SRC)/epub-ru.yaml

epub-en: html-en $(COVER_EN)
	$(PANDOC) $(HTML_EN) -o $(EPUB_EN) \
		--from html --to epub3 \
		--css $(SRC)/epub.css \
		--epub-cover-image $(COVER_EN) \
		--toc --toc-depth=2 --split-level=2 \
		--metadata-file $(SRC)/epub-en.yaml

epubs: epub-ru epub-en

books: pdfs epubs

watch: $(OUT)
	$(TYPST) watch $(SRC)/book.typ $(PDF_RU)

clean:
	rm -rf $(OUT)
	rm -f intro-k-professii-programmist.pdf intro-k-professii-programmist.html intro-k-professii-programmist.epub
	rm -f intro-to-the-programming-profession.pdf intro-to-the-programming-profession.html intro-to-the-programming-profession.epub
