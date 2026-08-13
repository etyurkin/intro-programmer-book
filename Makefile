TYPST := typst
PDF := intro-k-professii-programmist.pdf
PDF_EN := intro-to-the-programming-profession.pdf

.PHONY: all pdf pdf-en pdfs watch clean

all: pdfs

pdf:
	$(TYPST) compile book.typ $(PDF)

pdf-en:
	$(TYPST) compile book-en.typ $(PDF_EN)

pdfs: pdf pdf-en

watch:
	$(TYPST) watch book.typ $(PDF)

clean:
	rm -f $(PDF) $(PDF_EN)
