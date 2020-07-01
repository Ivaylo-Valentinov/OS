#!/bin/bash

TEMP="0"
MAX="0"

while read LINE; do
	if egrep -q -v "^([-+]){0,1}[0-9]+$" < <( echo "${LINE}" ) ; then
		continue
	fi

	CUR="$(echo "${LINE}" | sed -r 's/-//' \
		| egrep -o "." | awk '{sum += $1} END {print sum}')"
	if [ ${CUR} -gt "${MAX}" ]; then
		MAX="${CUR}"
		TEMP="${LINE}"
		continue
	fi

	if [ "${CUR}" -eq "${MAX}" -a "${LINE}" -lt "${TEMP}" ]; then
		TEMP="${LINE}"
	fi

done

echo "${TEMP}"
