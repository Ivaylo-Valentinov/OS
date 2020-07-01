#!/bin/bash


ID_SI="$(cat "my_passwd" \
	| cut -d ":" -f3 | sort -n \
	| awk '{print NR":"$0}' \
	| egrep "^201:" | cut -d ":" -f 2 )" 

GR_SI="$(cat "my_passwd" | egrep "^([^:]*:){2}${ID_SI}:" | cut -d ":" -f4)"

cat "my_passwd" | egrep "^([^:]*:){3}${GR_SI}:" \
	| cut -d ":" -f5,6 | sed -r "s/^([[:alpha:]]+) ([[:alpha:]]+)[^:]*:/\1 \2:/g"
