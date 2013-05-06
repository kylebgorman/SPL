TEX=xelatex -halt-on-error
BIB=bibtex
JOBNAME=SPL

all:
	$(TEX) $(JOBNAME)

bib: 
	$(BIB) $(JOBNAME)
	$(TEX) $(JOBNAME)
	$(TEX) $(JOBNAME)

clean:
	latexmk -C
	rm $(JOBNAME).bbl

show:
	open $(JOBNAME).pdf
