#!/bin/bash

if [ $# -ne 2 ]; then 
	echo "needs 2 arguments" >&2
	exit 1
fi

if [ ! -f "$1" -o ! -r "$1" ]; then
	echo "should exist" >&2
	exit 2
fi

if [ -e "$2" ]; then 
	echo "already exists" >&2
	exit 3
fi

TEMP="$(mktemp)"

cat "$1" | cut -d ',' -f2- | sort | uniq > "${TEMP}"

while read LINE; do 
	
	cat "${1}" | fgrep ",${LINE}" | sort -n -t ',' -k1 | head -n 1 >> ${2}

done < "${TEMP}"


rm "${TEMP}"
