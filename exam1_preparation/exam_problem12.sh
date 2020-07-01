#!/bin/bash

MIN_DEPTH=""

while read -d $'\n' LINE ; do
	DEPTH="$( echo "${LINE}" | grep -o "/" | wc -l )"

	if [ -z "${MIN_DEPTH}" ];then
		MIN_DEPTH="${DEPTH}"
	fi


	if [ "${MIN_DEPTH}" -gt "${DEPTH}" ];then 
		MIN_DEPTH="${DEPTH}"
	fi

done < <( find ~ivaylo -type f \
	-inum "$(find ~ivaylo -type f -printf "%T@ %i\n" \
	| sort -n -t " " -k1 \
	| tail -n 1 | cut -d " " -f2)" \
       	-printf "%p\n" )


echo "${MIN_DEPTH}"
