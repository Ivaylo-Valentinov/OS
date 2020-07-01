#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "wrong number of arguments" >&2
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "not a file" >&2
	exit 2
fi

if [ ! -r "$1" ]; then
	echo "cannot read" >&2
	exit 2
fi

cat "$1" | awk '{print NR". "$0}' \
	| sed -r 's/ [0-9]{4} [[:alnum:]]\. -//' \
	| sort -t "." -k2 
