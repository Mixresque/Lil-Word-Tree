#!/usr/bin/env python3
import pickle
import sys
import os
from nltk.corpus import wordnet as wn

corpus=sys.argv[1]
output=corpus+'.lemmatized'

with open('lemma_to_id.pkl', 'rb') as f:
    lemma_dict = pickle.load(f)
'''
with open('lid.log','w') as f:
    f.write(str(len(lemma_dict)))
'''
for line in open(corpus,'r'):
    for w in line.split():
        output_file=open(output,'a')
        lemma = wn.morphy(w)
        if w in lemma_dict:
            output_file.write(str(lemma_dict[w])+' ')
        elif lemma in lemma_dict:
            output_file.write(str(lemma_dict[lemma])+' ')
        else:
            if w[0]>='0' and w[0]<='9':
                output_file.write('oov ')
            else:
                output_file.write(w+' ')
