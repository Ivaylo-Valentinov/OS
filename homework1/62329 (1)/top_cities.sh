#!/bin/bash
cat spread.csv | awk -F ',' '$3 >= 101 {print $1": "int(int($4)/int($3)*1000)}' | sort -n -r -t ' ' -k 2 | head
