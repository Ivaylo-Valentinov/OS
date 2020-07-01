#!/bin/bash

if [ $# -ne 2  ]; then
	echo "you dumb: (2 parameters)" >&2
	exit 1
fi


if [ ! -f "$1" -o ! -r "$1" ]; then
	echo "not a file or could not read" >&2
	exit 2
fi

if [ ! -f "$2" -o ! -r "$2" ]; then
	echo "not a file or could not read" >&2
	exit 2
fi

WINNER="$1"

LEN1="$(cat "$1" | wc -l)"
LEN2="$(cat "$2" | wc -l)"

if [ "${LEN1}" -lt "${LEN2}" ]; then
	WINNER="$2"
fi

cat "${WINNER}" | sed -r 's/^[^\-]* - //g' | sort > "${WINNER}.songs"
