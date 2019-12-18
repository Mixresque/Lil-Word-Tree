#!/usr/bin/env python3
import sys
import textstat
import pickle

corpus = sys.argv[1]
name = corpus.split("/")[-1]
sql = 'sql/add-corpus.'+name+'.sql'
stats = corpus+'.stats'
cid_log = 'cid.log'
lid_log = 'lid.log'
cnt_file = corpus + '.clean.lemmatized.cnt'

### read fre,fkg,dc,vsize from stats file
stats_file = open(stats, 'r')
line = stats_file.readline()
stats_file.close()
s = line.split()
vsize,fre,fkg,dc = s[3],s[0],s[1],s[2]

### find current cid from cid log file
cid_file = open(cid_log, 'r')
line = cid_file.readline()
cid_file.close()
cid = int(line.split()[0])+1

'''
### find current lid from lid log file
lid_file = open(lid_log, 'r')
line = lid_file.readline()
lid_file.close()
lid = int(line.split()[0])
'''

### load lemma dictionary
with open('lemma_to_id.pkl', 'rb') as f:
    lemma_to_id = pickle.load(f)
lid = len(lemma_to_id)

### update CORPUS table
with open(sql, 'a') as f:
    f.write('INSERT INTO CORPUS (cid,filename,vsize,freScore,fkgScore,dcScore) VALUES' \
        + '('+str(cid)+',\''+name+'\','+vsize+','+fre+','+fkg+','+dc+');\n')

### update FREQUENCY table
for line in open(cnt_file,'r'):
    p = line.split()
    sql_file = open(sql,'a')
    if p[0][0]>='0' and p[0][0]<='9':
        sql_file.write('INSERT INTO FREQUENCY VALUES ('+str(cid)+','+p[0]+','+p[1]+');\n')
    elif p[0] != 'oov' and p[0][0]>='a' and p[0][0]<='z':
        lid += 1 
        num_syl = textstat.syllable_count(p[0])
        lemma_to_id[p[0]]=lid
        sql_file.write('INSERT INTO LEMMA (lid,lName,numSyllables) VALUES ('\
                       +str(lid)+',\''+p[0]+'\','+str(num_syl)+');\n')
        sql_file.write('INSERT INTO FREQUENCY VALUES ('+str(cid)+','+str(lid)+','+p[1]+');\n')

### update cid in log file
cid_file = open(cid_log, 'w')
cid_file.write(str(cid))
cid_file.close()

### write lemma dictionary pickle
with open('lemma_to_id.pkl', 'wb') as f:
    pickle.dump(lemma_to_id, f)

