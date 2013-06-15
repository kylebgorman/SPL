TEX=xelatex -halt-on-error
BIB=bibtex
IDX=splitindex
INDEXIFY=./indexify.py

JOBNAME=SPL

all: idx bib

idx:
	$(RM) [01]*-IDX.tex
	python indexify.py [01]*.tex
	$(TEX) $(JOBNAME)
	splitindex $(JOBNAME)
	$(TEX) -interaction=batchmode $(JOBNAME)

bib:
	$(BIB) $(JOBNAME)
	cat $(JOBNAME).bbl | sed -e 's!?\\/}\.!?\\/}!' > TEMP
	mv TEMP $(JOBNAME).bbl
	$(TEX) -interaction=batchmode -no-pdf $(JOBNAME)
	$(TEX) -interaction=batchmode $(JOBNAME)

clean:
	latexmk -C
	$(RM) [01]*-IDX.tex 
	$(RM) $(JOBNAME).bbl $(JOBNAME).xdv
	$(RM) *.idx *.ilg *.ind

show:
	open $(JOBNAME).pdf
