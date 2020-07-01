#!/bin/bash
join -t ',' -j 1 -o 1.1,2.2,1.3,1.4  <(sort -t ',' -k1 spread.csv) <(sort -t ',' -k1 city.csv) \
| awk -F ',' '$3 >= 101 {print $1" ("$2"): "int(int($4)/int($3)*1000)}' \
| sort -t ':' -k2 -n -r | head
