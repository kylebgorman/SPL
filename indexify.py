#!/usr/bin/env python
# encoding: UTF-8
# Insert word and author index information
# Kyle Gorman <gormanky@ohsu.edu>

import re
from os import path
from sys import argv
from pybtex.database.input import bibtex

PARSER = bibtex.Parser()

STOPLIST = 'stoplist.txt'
BIBFILE  = 'SPL.bib'

AUTHOR = 'author'
WORD   = 'word'

CITE_COMMANDS = ['citet', 'citep', 'citealt', 'citealp', 
                 'citeauthor', 'citeyear']
CITED = re.compile('\\.?(' + '|'.join(CITE_COMMANDS) + '){(.+?)}')
EMPHED = re.compile('\\emph{(.+?)}') 
# both non-greedy!


def readbib(source):
    """
    Return a dictionary of bibtex keys mapped to a list of author names
    """
    data = PARSER.parse_file(source)
    mydict = {}
    for (k, v) in data.entries.iteritems():
        if 'author' in v.persons:
            mydict[k] = v.persons['author']
    return mydict

def readstop(source):
    """
    Return the stoplist of emph-items
    """
    return {L.rstrip() for L in open(source, 'r') if not L.startswith('#')}


if __name__ == '__main__':

    # check usage
    if len(argv) < 2:
        exit('USAGE: ./indexify.py [TEXTFILES]')

    # get bib data
    bib = readbib(BIBFILE)

    # read stoplist for "WORD"
    stop = readstop(STOPLIST)

    # run through the text files
    for fid in argv[1:]:
        source = open(fid, 'r')
        (head, ext) = path.splitext(fid)
        sink = open(head + '-IDX' + ext, 'w')
        for line in source:
            # search for emphasis
            newlist = list(line.rstrip())
            offset = 0
            for match in EMPHED.finditer(line):
                word = match.group(1)
                if word in stop:
                    continue
                end = match.end()
                label = list('\sindex[' + WORD + ']{' + word + '}')
                newlist = newlist[:end + offset] + label + \
                          newlist[end + offset:]
                offset += len(label)
            # search for citations
            line = ''.join(newlist)
            newlist = list(line)
            offset = 0
            for match in CITED.finditer(line):
                key = match.group(2)
                end = match.end()
                for author in bib[key]:
                    label = list('\sindex[' + AUTHOR + ']{' + \
                                              str(unicode(author)) + '}')
                    newlist = newlist[:end + offset] + label + \
                              newlist[end + offset:]
                    offset += len(label)
            print >> sink, ''.join(newlist)
