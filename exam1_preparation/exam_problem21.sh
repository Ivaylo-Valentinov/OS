#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
	echo "should be used by root" >&2
	exit 1
fi


TEMP="$(mktemp)"

ps -e -o user,pid,rss --no-header | tr -s " " > "${TEMP}"

while read _USER; do
	
	SUM_RSS="$( cat "${TEMP}" | egrep "^${_USER} " \
		| awk 'BEGIN {sum = 0} {sum += $3} END {print sum}' )"
	DAVG_RSS="$( cat "${TEMP}" | egrep "^${_USER} " \
		| awk '{sum += $3 ; cnt += 1 } END {print int((2 * sum)/cnt)}' )"
	MAX_PID_RSS="$( cat "${TEMP}" | sort -n -t " " -k3 | tail -n 1  )"

	echo "${_USER} ------> ${SUM_RSS}"
	if [ "${DAVG_RSS}" -lt "$(echo "${MAX_PID_RSS}" | cut -d " " -f3)" ]; then
		kill -s SIGTERM "$( echo "${MAX_PID_RSS}" | cut -d " " -f2 )"
		sleep 2
		kill -s SIGKILL "$( echo "${MAX_PID_RSS}" | cut -d " " -f2 )"
	fi

done < <( cat "${TEMP}" | cut -d " " -f1 | sort | uniq )


rm "${TEMP}"
