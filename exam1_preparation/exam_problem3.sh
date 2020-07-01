#!/bin/bash

if [ $# -ne 2 ]; then
	echo "this script takes 2 paramaters" >&2
	exit 1
fi

if echo "$1" | egrep -q -v "^[0-9]+$" ;then
	echo "must be integer" >&2
	exit 2
fi

if echo "$2" | egrep -q -v "^[0-9]+$" ;then
	echo "must be integer" >&2
	exit 2
fi

if [ "${1}" -ge "${2}" ]; then
	echo "you idiot" >&2
	exit 3
fi	

DIR="$(pwd)"

mkdir a
mkdir b
mkdir c

while read -d $'\n' line ; do
	NUM="$( cat "${line}" | wc -l )"
	if [ "${NUM}" -lt "${1}" ]; then
		mv "${line}" a/
	elif [ "${NUM}" -lt "${2}" ]; then
		mv "${line}" b/
	else
		mv "${line}" c/
	fi

done < <( find "${DIR}" -mindepth 1 -maxdepth 1 -type f -printf "%p\n" )
