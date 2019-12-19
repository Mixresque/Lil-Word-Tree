# LilWordtree

> Final project for 601.615 Databases

## Building schema

- Use `CreateDB.sql` file to construct the tables in your database. (Uncomment the first three line in the file if you want to use the default database name. )

## Loading data

- Create the directory for outputing generated `.sql` file, and run python script for generating sql file that loads table LEMMA, SYN, MEANS, HYPONYM, DERIVED, ANTONYM, MORPH. MORPH exceptions (`*.exc`) should be under `data/` path unless otherwise defined in the script. 
```
mkdir sql-populatedb
python LemmaAndSyn.py
```

- Run `sql-populatedb/LoadLemmaAndSyn.sql` to populate databases with words and concepts information. 

- Process common word flags with easy/common word list as desired under `data/` path. 

- Run generated `sql-populatedb/LoadCommonWords.sql` set `isCommon` field in LEMMA table. 

## Counting word frequency and loading corpus

- Use bash and python scripts under corpus_preprocess to preprocess corpora provided in `corpus/` folder. Or skip to next step. 

- Run the (generated) `sql-populatedb/add-corpus*.sql` files to load corpora and their corresponding word counts onto the database. 

- Run `LoadTopics.sql` for the topic information. 

