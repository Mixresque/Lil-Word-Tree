from nltk.corpus import wordnet as wn
import textstat

class LemmaAndSyn:
    def __init__(self):
        self.lemma = []  # LEMMA
        self.syn = []  # SYN
        self.means = set()  # MEANS
        self.lid = 1
        self.sid = 1
        self.lemma_name = {}
        self.syn_name = {}

        self.morph = []  # MORPH
        self.mid = 1
        self.antonym = set()  # ANTONYM
        self.hypernym = set()  #HYPERNYM
        self.hyponym = set()  # HYPONYM
        self.derived = set()  # DERIVED
    
    def populate(self, lemmas=wn.all_lemma_names()):
        self.populate_lemma_and_synsets(lemmas)            
        self.populate_derivations_and_antonyms()

    def populate_lemma_and_synsets(self, lemmas=wn.all_lemma_names()):
        print("Loading lemmas, synsets, hypernyms, hyponyms")
        for lm in lemmas:
            # add lemma
            tlid = self._add_lemma(lm)
                
    def populate_derivations_and_antonyms(self):
        print("Loading derivations and antonyms")
        for ss, psid in self.syn_name.items():
            ps = wn.synset(ss)
            for pl in ps.lemmas():
                plid = self.lemma_name.get(pl.name())
                if psid is not None and plid is not None:
                    for dv in pl.derivationally_related_forms():
                        csid, clid = self.syn_name.get(dv.synset().name()), self.lemma_name.get(dv.name())
                        if csid is not None and clid is not None:
                            self.derived.add((psid, plid, csid, clid))
                            
                    for dv in pl.antonyms():
                        csid = self.syn_name.get(dv.synset().name())
                        if csid is not None:
                            self.antonym.add((min(psid, csid), max(psid, csid)))
                        # csid, clid = self.syn_name.get(dv.synset().name()), self.lemma_name.get(dv.name())
                        # if csid is not None and clid is not None:
                        #     if psid < csid:
                        #         self.antonym.add((psid, plid, csid, clid))
                        #     else:
                        #         self.antonym.add((csid, clid, psid, plid))
    
    def _add_lemma(self, lm):
        tlid = self.lemma_name.setdefault(lm, self.lid)
    #     sid = max(self.lid, tlid+1)
        if tlid == self.lid:
            self.lemma.append((tlid, lm, textstat.syllable_count(lm)))  #, False))  - isCommon
            self.lid += 1

            # if lemma not already visited, visit all of its synset
            for ss in wn.synsets(lm):
                tssid = self._add_synset(ss)
                self.means.add((tlid, tssid))
        return tlid


    def _add_synset(self, ss):
        tssid = self.syn_name.setdefault(ss.name(), self.sid)
        if tssid == self.sid:
            self.syn.append((tssid, ss.definition().replace('"', ''), ss.pos())) #, 0))  - domainid
            self.sid += 1

#         # Recursive loading
#         # visit hypernyms
#         for hyper in ss.hypernyms():
#             hyperid = self._add_synset(hyper)
#             self.hypernym.append((tssid, hyperid))

#         # visit hyponyms
#         for hypo in ss.hyponyms():
#             hypoid = self._add_synset(hypo)
#             self.hyponym.append((tssid, hypoid))
#         return tssid

        # visit hypernyms
        for hyper in ss.hypernyms():
            hyperid = self.syn_name.setdefault(hyper.name(), self.sid)
            if hyperid == self.sid:
                self.syn.append((hyperid, hyper.definition().replace('"', ''), hyper.pos())) #, 0))  - domainid
                self.sid += 1
            self.hypernym.add((tssid, hyperid))
            
        # visit hyponyms
        for hypo in ss.hyponyms():
            hypoid = self.syn_name.setdefault(hypo.name(), self.sid)
            if hypoid == self.sid:
                self.syn.append((hypoid, hypo.definition().replace('"', ''), hypo.pos())) #, 0))  - domainid
                self.sid += 1
            self.hyponym.add((tssid, hypoid))

        return tssid

    def load_morph_exceptions(self, file, pos):
        print("Loading exceptions of morphs from " + file)
        with open(file) as f:
            morphs = f.read().splitlines()
        
        for m in morphs:
            mm = m.split(' ')
            lid = self.lemma_name.get(mm[1])
            if lid is not None:
                self.morph.append((self.mid, mm[0], lid, pos)) # , 0)  - embeddingid
                self.mid += 1

    def export_sql(self, file='./LoadLemmaAndSyn.sql'):
        print("Exporting to " + file)
        f = open(file, "w")
        # f.write('USE wordtree;\n')

        # f = open(file+'.lemma.sql', "w")

        f.write('-- Loading data into table LEMMA\n')
        sql = 'INSERT INTO LEMMA (lid, lName, numSyllables) VALUES (%d, "%s", %d);\n'
        for l in self.lemma:
            f.write(sql % l)

        # f.close()
        # f = open(file+'.syn.sql', "w")

        f.write('-- Loading data into table SYN\n')
        sql = 'INSERT INTO SYN (sid, definition, pos) VALUES (%d, "%s", "%s");\n'
        for s in self.syn:
            f.write(sql % s)

        # f.close()
        # f = open(file+'.means.sql', "w")

        f.write('-- Loading data into table MEANS\n')
        sql = 'INSERT INTO MEANS VALUES (%d, %d);\n'
        for m in self.means:
            f.write(sql % m)

        # f.close()
        # f = open(file+'.morph.sql', "w")

        f.write('-- Loading data into table MORPH\n')
        sql = 'INSERT INTO MORPH (mid, mname, lid, pos) VALUES (%d, "%s", %d, "%s");\n'
        for m in self.morph:
            f.write(sql % m)
        
        # f.close()
        # f = open(file+'.antonym.sql', "w")

        f.write('-- Loading data into table ANTONYM\n')
        sql = 'INSERT INTO ANTONYM VALUES (%d, %d);\n'
        for a in self.antonym:
            f.write(sql % a)
        
        # f.close()
        # f = open(file+'.hypernym.sql', "w")

        f.write('-- Loading data into table HYPERNYM\n')
        sql = 'INSERT INTO HYPERNYM VALUES (%d, %d);\n'
        for h in self.hypernym:
            f.write(sql % h)
        
        # f.close()
        # f = open(file+'.hyponym.sql', "w")

        f.write('-- Loading data into table HYPONYM\n')
        sql = 'INSERT INTO HYPONYM VALUES (%d, %d);\n'
        for h in self.hyponym:
            f.write(sql % h)
        
        # f.close()
        # f = open(file+'.derived.sql', "w")

        f.write('-- Loading data into table DERIVED\n')
        sql = 'INSERT INTO DERIVED VALUES (%d, %d, %d, %d);\n'
        for d in self.derived:
            f.write(sql % d)

        f.close()

def __main__():
    ls = LemmaAndSyn()
    ls.populate()

    import pickle
    with open("lemma_to_id.pkl", 'wb') as f:
        pickle.dump(ls.lemma_name, f)

    for f, pos in zip(('adj.exc', 'adv.exc', 'noun.exc', 'verb.exc'), ('a', 'r', 'n', 'v')):
        ls.load_morph_exceptions('./'+f, pos)
    ls.export_sql()

    print('lemma', len(ls.lemma))
    print('syn', len(ls.syn))
    print('means', len(ls.means))
    print('morph', len(ls.morph))
    print('antonym', len(ls.antonym))
    print('hypernym', len(ls.hypernym))
    print('hyponym', len(ls.hyponym))
    print('derived', len(ls.derived))

if __name__ == '__main__':
    __main__()
