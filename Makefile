TYPST ?= typst

DOCS := explanatory-note technical-assignment system-programmers-guide

.PHONY: all clean $(DOCS)

all: $(DOCS)

$(DOCS):
	$(TYPST) compile --root . docs/$@.typ build/$@.pdf

watch-explanatory-note:
	$(TYPST) watch --root . docs/explanatory-note.typ build/explanatory-note.pdf

clean:
	rm -f build/*.pdf
