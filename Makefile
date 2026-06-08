TYPST ?= typst

GROUP := ПРИН-466
FULL_NAME := Коломойцев Илья Сергеевич

DOCS := explanatory-note technical-assignment system-programmers-guide

explanatory-note_TYPE := ПЗ
technical-assignment_TYPE := ТЗ
system-programmers-guide_TYPE := РСП

output_name = $(GROUP) $($(1)_TYPE) $(FULL_NAME).pdf

.PHONY: all clean $(DOCS)

all: $(DOCS)

$(DOCS):
	$(TYPST) compile --root . docs/$@.typ "build/$(call output_name,$@)"

watch-explanatory-note:
	$(TYPST) watch --root . docs/explanatory-note.typ "build/$(call output_name,explanatory-note)"

watch-technical-assignment:
	$(TYPST) watch --root . docs/technical-assignment.typ "build/$(call output_name,technical-assignment)"

watch-common:
	$(TYPST) watch --root . docs/common.typ build/common.pdf

clean:
	rm -f build/*.pdf
