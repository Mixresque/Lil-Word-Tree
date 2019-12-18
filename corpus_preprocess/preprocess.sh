#!/bin/bash
#moses decoder from CLSP grid
export mosesdecoder=/home/pkoehn/moses
corpus=$1

#merge the corpus into one line
cat $corpus | awk '{printf("%s ",$0)}' > $corpus.cat
cat $corpus.cat \
  | sed 's/\r//g' \
  | sed 's/[[:space:]]\+/ /g' > $corpus.cat.remove
mv $corpus.cat.remove $corpus.cat

#calculate corpus readability
python score_readability.py --input $corpus.cat --output $corpus.cat.stats

#lower case and remove punctuation (@_$%- excluded)
cat $corpus.cat \
  | $mosesdecoder/scripts/tokenizer/lowercase.perl \
  | sed '/[[:punct:]]*/{ s/[^[:alnum:][:space:]@_$%-]//g }' > $corpus.cat.clean

#lemmatize and indexize, convert words to its lemma id, write to a new file
python lemmatize.py $corpus.cat.clean

#calculate word count and sort
echo -n $(wc -w $corpus.cat.clean.lemmatized) >> $corpus.cat.stats
(tr ' ' '\n' | sort | uniq -c | awk '{print $2" "$1}') \
    < $corpus.cat.clean.lemmatized > $corpus.cat.clean.lemmatized.cnt.tmp
sort -k2 -n -r $corpus.cat.clean.lemmatized.cnt.tmp >$corpus.cat.clean.lemmatized.cnt
rm $corpus.cat.clean.lemmatized.cnt.tmp

#convert to SQL
python tosql.py $corpus.cat

