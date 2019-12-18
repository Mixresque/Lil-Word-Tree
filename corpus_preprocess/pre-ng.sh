#!/bin/bash
data=$1
for dir in $data/*; do
  for d in $dir/*; do
    sed -i '1,8d' $d
    sed -i 's/<.*>//g' $d
    sed -i 's/|\|-\|<\|>\|(\|)\|:\|\_\|\[\|\]\|\/\|\\//g' $d
    sed -i 's/\$\|#\|=\|\*\|+\|%\|~\|{\|}//g' $d
    sed -i 's/[^ ]\+@[^ ]\+//g' $d
    sed -i 's/[[:digit:]]\+\(\.[[:digit:]]\+\)\?//g' $d
  done
  find ./$dir -type f -exec cat {} + >> ./$dir.txt
done
