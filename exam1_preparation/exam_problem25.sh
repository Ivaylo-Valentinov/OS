#!/bin/bash

if [ $# -ne 1 ]; then
	echo "takes 1 argument" >&2
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "not a dir" >&2
	exit 2
fi

FRIENDS="$(mktemp)"

while read FRIEND; do
	MESS="0"
	while read DIR_FRIEND; do
		CURR_MSG="$(find "${DIR_FRIEND}" -mindepth 1 -maxdepth 1 -type f \
			| egrep "^[0-9]{4}(-[0-9]{2}){5}\.txt$" \
			| xargs cat | wc -l)"
		MESS="$(( ${MESS} + "${CURR_MSG}" ))"
	done < <( find "${1}" -mindepth 3 -maxdepth 3 -type d -name "${FRIEND}" )
	echo "${MESS}/${FRIEND}" >> "${FRIENDS}"

done < <( find "${1}" -mindepth 3 -maxdepth 3 -type d -printf "%f\n" | sort | uniq )

cat "${FRIENDS}" | sort -n -t "/" -k1 | tail | awk -F '/' '{print $2" has lines: "$1}' 

rm "${FRIENDS}"
