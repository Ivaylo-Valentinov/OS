#!/bin/bash

cat <(find /home/SI -mindepth 1 -maxdepth 1 -printf "%C@:%p" \
	| awk -F ':' ' $1 >= 155116800 && $1 <= 155176100 {printf $2}' \
	| xargs -I{} egrep "^([^:]*:){5}:{}:" ) | cut -d ":" -f1,5 | cut -c2- \
	| sed -r 's/([[:alpha:]]+) ([[:alpha:]]+)[^[:alpha:]]+$/\1 \2/g' 
