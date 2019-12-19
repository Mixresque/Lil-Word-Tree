import pickle

file_word_list = 'data/easy_words.txt'
file_output = 'sql-populatedb/LoadCommonWords.sql'

with open('data/lemma_to_id.pkl', 'rb') as f:
    lemma_to_id = pickle.load(f)

print("Loading common words from " + file_word_list)

with open(file_word_list) as f:
    words = f.read().splitlines()

print("Writing sql to " + file_output)

f = open(file_output, "w")

sql = "UPDATE LEMMA SET isCommon = 1 where lid = %d;\n"
for w in words:
    lid = lemma_to_id.get(w)
    if lid is not None:
        f.write(sql % (lid))

f.close()
