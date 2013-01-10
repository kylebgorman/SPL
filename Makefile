TEX=xelatex -halt-on-error
BIB=bibtex
JOBNAME=morphophonology

all:
	$(TEX) $(JOBNAME)

bib: 
	$(BIB) $(JOBNAME)
	$(TEX) $(JOBNAME)
	$(TEX) $(JOBNAME)

clean:
	latexmk -C

show:
	open $(JOBNAME).pdf
