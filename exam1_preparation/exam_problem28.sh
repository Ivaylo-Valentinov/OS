#!/bin/bash

TEMP="$(mktemp)"
ABS="0"

while read LINE; do
	if egrep -q -v "^([-+]){0,1}[0-9]+$" < <( echo "${LINE}" ) ; then
		continue
	fi

	CUR_ABS="$(echo "${LINE}" | sed -r 's/-//')"
	if [ ${CUR_ABS} -gt "${ABS}" ]; then
		ABS="${CUR_ABS}"
		echo "${LINE}" > "${TEMP}"
		continue
	fi

	if [ "${CUR_ABS}" -eq "${ABS}" ]; then
		echo "${LINE}" >> "${TEMP}"
	fi

done

cat "${TEMP}" | sort | uniq

rm "${TEMP}"
