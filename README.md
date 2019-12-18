# LilWordtree

> Final project for 601.615 Databases

## Building the tables

- Use `CreateDB.sql` file to construct the tables in your database. (Uncomment the first three line in the file if you want to use the default database name. )

## Loading data

- Create the directory for outputing generated `.sql` file, and run python script for generating sql file that loads table LEMMA, SYN, MEANS, HYPONYM, DERIVED, ANTONYM, MORPH. ```
mkdir sql-populatedb
python LemmaAndSyn.py
```

- Run `sql-populatedb/LoadLemmaAndSyn.sql` to populate databases with words and concepts information. 

## Counting word frequency and loading corpus

