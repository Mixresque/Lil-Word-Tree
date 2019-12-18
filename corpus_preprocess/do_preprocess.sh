#!/bin/bash -v
. ./local-settings.sh

echo You are running on machine: `hostname`
echo Here is what free-gpu returned: `free-gpu` 
echo '$CUDA_VISIBLE_DEVICES: ' $CUDA_VISIBLE_DEVICES
echo Here is the output of nvidia-smi: `nvidia-smi`

stage=$1
if [ $stage -eq 1 ]; then
  sh preprocess.sh 'corpus/europarl2000.en'
fi
if [ $stage -eq 2 ]; then
  sh preprocess.sh 'corpus/bible.txt'
fi
if [ $stage -eq 3 ]; then
  sh preprocess.sh 'corpus/intro-phil.txt'
fi
if [ $stage -eq 4 ]; then
  sh preprocess.sh 'corpus/greek-myth.txt'
fi
if [ $stage -eq 5 ]; then
  sh preprocess.sh 'corpus/sonnets.txt'
fi
if [ $stage -eq 6 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/alt.atheism.txt'
fi
if [ $stage -eq 7 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/comp.graphics.txt'
fi
if [ $stage -eq 8 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/comp.os.ms-windows.misc.txt'
fi
if [ $stage -eq 9 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/comp.sys.ibm.pc.hardware.txt'
fi
if [ $stage -eq 10 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/comp.sys.mac.hardware.txt'
fi
if [ $stage -eq 11 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/comp.windows.x.txt'
fi
if [ $stage -eq 12 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/misc.forsale.txt'
fi
if [ $stage -eq 13 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/rec.autos.txt'
fi
if [ $stage -eq 14 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/rec.motorcycles.txt'
fi
if [ $stage -eq 15 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/rec.sport.baseball.txt'
fi
if [ $stage -eq 16 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/rec.sport.hockey.txt'
fi
if [ $stage -eq 17 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/sci.crypt.txt'
fi
if [ $stage -eq 18 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/sci.electronics.txt'
fi
if [ $stage -eq 19 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/sci.med.txt'
fi
if [ $stage -eq 20 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/sci.space.txt'
fi
if [ $stage -eq 21 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/soc.religion.christian.txt'
fi
if [ $stage -eq 22 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/talk.politics.guns.txt'
fi
if [ $stage -eq 23 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/talk.politics.mideast.txt'
fi
if [ $stage -eq 24 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/talk.politics.misc.txt'
fi
if [ $stage -eq 25 ]; then
  sh preprocess_non_update.sh 'corpus/20newsgroup/talk.religion.misc.txt'
fi




#if [ $stage -eq 20 ]; then
#  for d in 'corpus/20newsgroup/*'; do
#    #not updating lemma
#    sh preprocess_non_update.sh $d
#  done
#fi

