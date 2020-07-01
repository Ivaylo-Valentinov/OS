#!/bin/bash
join -t ',' -j 1 -o 2.2,2.3,1.3,1.4 <(sort -t ',' -k1 spread.csv) <(join -t ',' -1 2 -2 1 -o 1.1,1.2,2.2 <(sort -t ',' -k2 city_province.csv) <(sort -t ',' -k1 province.csv) | sort -t ',' -k1) \
| ( sort -t ',' -k1 ; echo "not valid line" ) \
| awk -F ',' 'NR==1 {name=$1;en=$2;reg=$3;dead=$4;next}  $1 == name {reg+=$3;dead+=$4;next} $1 != name && reg != 0 {print name" (" en "): "int(int(dead)/int(reg)*1000);name=$1;en=$2;reg=$3;dead=$4;next} $1 != name && reg == 0 {print name" (" en "): 0";name=$1;en=$2;reg=$3;dead=$4;next}' \
| sort -n -r -t ' ' -k 3 | head
