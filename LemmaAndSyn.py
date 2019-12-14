from nltk.corpus import wordnet as wn
import textstat

class LemmaAndSyn:
    def __init__(self):
        self.lemma = []  # LEMMA
        self.syn = []  # SYN
        self.means = []
        self.lid = 0
        self.sid = 0
        self.lemma_name = {}
        self.syn_name = {}

        self.morph = []  # MORPH
        self.mid = 0
        self.antonym = []  # ANTONYM
        self.hypernym = set()  #HYPERNYM
        self.hyponym = set()  # HYPONYM
        self.derived = []  # DERIVED
    
    def populate(self, lemmas):
        for lm in lemmas:
            # add lemma
            tlid = self._add_lemma(lm)
    
    def _add_lemma(self, lm):
        tlid = self.lemma_name.setdefault(lm, self.lid)
    #     sid = max(self.lid, tlid+1)
        if tlid == self.lid:
            self.lemma.append((tlid, lm, textstat.syllable_count(lm)))  #, False))  - isCommon
            self.lid += 1

            # if lemma not already visited, visit all of its synset
            for ss in wn.synsets(lm):
                tssid = self._add_synset(ss)
                self.means.append((tlid, tssid))
        return tlid


    def _add_synset(self, ss):
        tssid = self.syn_name.setdefault(ss.name(), self.sid)
        if tssid == self.sid:
            self.syn.append((tssid, ss.definition(), ss.pos())) #, 0))  - domainid
            self.sid += 1

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
                self.syn.append((hyperid, hyper.definition(), hyper.pos())) #, 0))  - domainid
                self.sid += 1
            self.hypernym.add((tssid, hyperid))
            
        # visit hyponyms
        for hypo in ss.hyponyms():
            hypoid = self.syn_name.setdefault(hypo.name(), self.sid)
            if hypoid == self.sid:
                self.syn.append((hypoid, hypo.definition(), hypo.pos())) #, 0))  - domainid
                self.sid += 1
            self.hyponym.add((tssid, hypoid))

        return tssid

    def load_morph_exceptions(self, file, pos):
        with open(file) as f:
            morphs = f.read().splitlines()
        
        for m in morphs:
            mm = m.split(' ')
            lid = self.lemma_name.get(mm[1])
            if lid is not None:
                self.morph.append((self.mid, mm[0], lid, pos)) # , 0)  - embeddingid


def __main__():
    ls = LemmaAndSyn()
    ls.populate(wn.all_lemma_names())
    for f, pos in zip(('adj.exc', 'adv.exc', 'noun.exc', 'verb.exc'), ('a', 'r', 'n', 'v')):
        ls.load_morph_exceptions('./'+f, pos)

if __name__ == '__main__':
    __main__()
