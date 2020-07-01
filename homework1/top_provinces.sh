#!/bin/bash
join -t ',' -j 1 -o 2.2,1.3,1.4 <(sort -t ',' -k1 spread.csv) <(sort -t ',' -k1 city_province.csv) \
| ( sort -t ',' -k1 ; echo "not valid line" ) \
| awk -F ',' 'NR==1 {name=$1;reg=$2;dead=$3;next}  $1 == name {reg+=$2;dead+=$3;next} $1 != name && reg != 0 {print name ": "int(int(dead)/int(reg)*1000);name=$1;reg=$2;dead=$3;next} $1 != name && reg == 0 {print name ": 0";name=$1;reg=$2;dead=$3;next}' \
| sort -n -r -t ' ' -k 2 | head
