#!/bin/bash

if [ $# -lt 1 ]; then
	echo "too few arguments" >&2
	exit 1
fi

N="10"

if [ "$1" == "-n" ]; then
	if [ $# -lt 2 ]; then
		echo "need a integer" >&2
		exit 2
	fi

	if echo "$2" | egrep -q -v "^[1-9][0-9]+$" ; then
		echo "should be a posistive integer" >&2
		exit 3 
	fi

	N="$2"
	shift 2
fi

TEMP="$(mktemp)"

for i in "$@" ; do 
	if [ ! -f "$i" -o ! -r "$i" ]; then 
		echo "not a file or cannot read" >&2
		rm "${TEMP}"
		exit 4
	fi
	IDF="$(echo "$i" | sed -r 's/\.log$//')"
	cat "$i" | sed -r "s/^([^ ]+) ([^ ]+) /\1 \2 ${IDF} /" \
		| tail -n "${N}" >> "${TEMP}"

done 

cat "${TEMP}" \
	| sed -r 's/^([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):([0-9]+)/\1;\2;\3;\4;\5;\6/' \
	| sort -n -t ";" -k1,1 -k2,2 -k3,3 -k4,4 -k5,5 -k6,6 \
	| sed -r 's/^([0-9]+);([0-9]+);([0-9]+);([0-9]+);([0-9]+);([0-9]+)/\1-\2-\3 \4:\5:\6/' 

rm "${TEMP}"
