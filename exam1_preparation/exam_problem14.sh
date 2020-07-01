#!/bin/bash

if [ $# -ne 1 ]; then
	echo "takes one parameter" >&2
	exit 1
fi

if echo "$1" | egrep -q -v "^[0-9]+$" ; then
	echo "should be a integer" >&2
	exit 2
fi


if [ $(id -u) -ne 0 ]; then
       	echo "should be used by root" >&2
	exit 3
fi	

PS_PIC="$(mktemp)"

ps -e -o user=,pid=,rss= | tr -s " " > "${PS_PIC}"

while read _USER; do
	USER_RSS="$( cat "${PS_PIC}" | awk '{RES+=$3} END {print RES}' )"
	echo "${_USER} has used ${USER_RSS}"
	if [ "${USER_RSS}" -gt "$1" ]; then
		kill -9 "$(cat "${PS_PIC}" | sort -n -t " " -k3 | tail -n 1 | cut -d " " -f2 )"
	fi


done < <( cat "${PS_PIC}" | cut -d " " -f1 | sort | uniq )

rm "${PS_PIC}"
