#!/bin/bash

if [ $# -ne 2 ]; then 
	echo "needs 2 arguments" >&2
	exit 1
fi

if [ ! -f "$1" -o ! -r "$1" ]; then
	echo "not a file or cannot read" >&2
	exit 2
fi

if [ ! -d "$2" ]; then
	echo "not a dir" >&2
	exit 3
fi

if [ ! -z "$(find "$2" -mindepth 1 -maxdepth 1)" ]; then
	echo "dir not empty" >&2
	exit 4
fi

DICT="$(dirname $2)/$(basename $2)/dict.txt"
COUNT="0"
while read NAME; do
	
	FIRST="$(echo "${NAME}" | cut -d " " -f1)"
	SECOND="$(echo "${NAME}" | cut -d " " -f2)"
	FILE_SAVE="$(dirname $2)/$(basename $2)/${COUNT}.txt"

	cat "$1" | egrep "^${FIRST} " | egrep " ${SECOND}" \
		 | cut -d ":" -f2- > "${FILE_SAVE}"
	
	echo "${NAME};${COUNT}" >> ${DICT}
	COUNT="$(( ${COUNT} + 1 ))"

done < <(cat "$1" | cut -d ":" -f1 \
	| sed -r 's/\(.*\)//' | awk '{print $1" "$2}' | sort | uniq )
