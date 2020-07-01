#!/bin/bash

if [ $# -ne 1 ]; then
	echo "needs 1 argument" >&2
	exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
	echo "should be used by root" >&2
	exit 3
fi

TEMP="$(egrep "^${1}:" /etc/passwd)"

if [ -z "${TEMP}" ]; then
	echo "should be a username" >&2
	exit 2
fi

TEMP="$(mktemp)"

ps -e -o user=,pid=,time= | tr -s " " > "${TEMP}"

NUM="$( cat "${TEMP}" | egrep "^${1} " | wc -l )"

while read _USER ; do
	
	CUR_NUM="$(cat "${TEMP}" | egrep "^${_USER} " | wc -l )"
	if [ "${CUR_NUM}" -gt "${NUM}" ]; then
		echo "${_USER}"
	fi

done < <( cat "${TEMP}" | cut -d " " -f1 | sort | uniq )


AVG_TIME="$(cat "${TEMP}" | cut -d " " -f3 \
	| awk -F ':' '{avg += ($1 * 60 * 60 + $2 * 60 + $3) ; cnt += 1} END {printf avg/cnt} ')"

echo "$(echo ${AVG_TIME} \
	| awk '{hh = ( $1 / 3600 ); mm = ( ($1 % 3600) / 60 ); ss = ($1 % 60) } END {printf int(hh)":"int(mm)":"int(ss)}' )"

AVG_TIME="$( echo "${AVG_TIME}" |  awk '{time = ($1 * 2)} END {printf int(time)} ' )"

while read LINE ; do
	
	PRC="$( echo "${LINE}" | cut -d " " -f2 )"
	TIME_PRC="$( echo "${LINE}" | cut -d " " -f 3 \
		| awk -F ':' '{time += ($1 * 60 * 60 + $2 * 60 + $3)} END {print time} ')"
	
	if [ "${TIME_PRC}" -gt "${AVG_TIME}" ]; then
		kill -9 "${PRC}"
	fi

done < <( cat "${TEMP}" | egrep "^${1} " )

rm "${TEMP}"
