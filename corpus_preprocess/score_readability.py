# Assesses the readability score of a document, line-by-line.
import argparse
import textstat

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--input',  help='input file to be scored') 
    ap.add_argument('--output',  help='output file for readability scores')
    args = ap.parse_args()

    scorers = {
        0: textstat.flesch_reading_ease,
        1: textstat.flesch_kincaid_grade,
        2: textstat.dale_chall_readability_score
    }
    for s in open(args.input,'r'):
        sentence = s
        break
    with open(args.output, 'a') as o:
        for x in [0,1,2]:
            o.write(str(scorers[x](sentence)) + ' ')
        o.close()

if __name__ == '__main__':
    main()


