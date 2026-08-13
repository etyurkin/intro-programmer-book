TYPST := typst
PDF := intro-k-professii-programmist.pdf
PDF_EN := intro-to-the-programming-profession.pdf

.PHONY: all pdf pdf-en watch clean

all: pdf

pdf:
	$(TYPST) compile book.typ $(PDF)

pdf-en:
	$(TYPST) compile book-en.typ $(PDF_EN)

watch:
	$(TYPST) watch book.typ $(PDF)

clean:
	rm -f $(PDF) $(PDF_EN)
