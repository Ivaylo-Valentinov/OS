#!/bin/bash

if [ $# -ne 1 ]; then
	echo "needs one argument" >&2
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "not a dir" >&2
	exit 2
fi

COUNT_BROKEN="0"

while read LINE; do
	LINE="$(echo "${LINE}" | cut -d " " -f2- )"
	if [ ! -e "${LINE}" ]; then
		COUNT_BROKEN="$(( ${COUNT_BROKEN} + 1 ))"
		continue
	fi
	FILE="$(stat "${LINE}" --printf "%N" | sed -r "s/^.* -> '(.*)'/\1/")"
	echo "$(basename "${LINE}") -> ${FILE}"

done < <( find "${1}" -type l -printf "%Y %p\n" )

echo "Broken symlinks: ${COUNT_BROKEN}"
