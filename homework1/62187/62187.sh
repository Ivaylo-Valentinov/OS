#!/bin/bash

 cat text.txt| awk '{print tolower($0)}'\
 | sed 's/[^a-zа-я]/ /g'\
 | tr -s ' '| sed 's/\s/\n/g'|sort| uniq\
 | xargs -I@  bash -c 'echo -n @: && echo  $(tre-agrep -s -w -B -99 @  dic.txt| head -n 1) ' \
 | grep -v 0
