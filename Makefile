TYPST ?= typst

DOCS := explanatory-note technical-assignment system-programmers-guide

.PHONY: all clean $(DOCS)

all: $(DOCS)

$(DOCS):
	$(TYPST) compile --root . docs/$@.typ build/$@.pdf

clean:
	rm -f build/*.pdf
