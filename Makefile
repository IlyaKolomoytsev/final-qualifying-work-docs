LATEXMKRC = ../.latexmkrc
LATEXMK = latexmk -r $(LATEXMKRC)

.PHONY: all explanatory-note statement-of-work rebuild-explanatory-note rebuild-statement-of-work clean clean-explanatory-note clean-statement-of-work

all: explanatory-note statement-of-work

explanatory-note:
	cd explanatory-note && $(LATEXMK) main.tex

statement-of-work:
	cd statement-of-work && $(LATEXMK) main.tex

rebuild-explanatory-note:
	cd explanatory-note && $(LATEXMK) -gg main.tex

rebuild-statement-of-work:
	cd statement-of-work && $(LATEXMK) -gg main.tex

clean: clean-explanatory-note clean-statement-of-work

clean-explanatory-note:
	cd explanatory-note && $(LATEXMK) -C main.tex

clean-statement-of-work:
	cd statement-of-work && $(LATEXMK) -C main.tex
