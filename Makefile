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
	ln -f ~/Documents/Other/TeX/kgorman.bib $(JOBNAME).bib
	$(BIB) $(JOBNAME)
	cat $(JOBNAME).bbl | sed -e 's!?\\/}\.!?\\/}!' > TEMP
	mv TEMP $(JOBNAME).bbl
	$(TEX) -interaction=batchmode -no-pdf $(JOBNAME)
	$(TEX) -interaction=batchmode $(JOBNAME)

clean:
	latexmk -C
	$(RM) $(JOBNAME).bbl $(JOBNAME).xdv [01]*-IDX.tex *.idx *.ilg *.ind

show:
	open $(JOBNAME).pdf
