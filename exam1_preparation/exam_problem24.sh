#!/bin/bash

if [ $# -gt 0 ]; then
	echo "too many arguments" >&2
	exit 1
fi

USERS="$(mktemp)"

while read LINE; do
	NAME="$(echo "${LINE}" | cut -d ":" -f1)"
	HOMEDIR="$(echo "${LINE}" | cut -d ":" -f6)"

	if [ "${NAME}" == "root" ]; then 
		continue
	fi

	if [ -z "${HOMEDIR}" ]; then
		echo "${NAME}" > "${USERS}" 
	 	continue
       	fi	

	if [ ! -d "${HOMEDIR}" ]; then
		echo "${NAME}" > "${USERS}" 
	 	continue
       	fi	

	OWNER="$( stat -c "%U" "${HOMEDIR}" )"
	PERMBITS="$( stat -c "%A" "${HOMEDIR}" )"

	if [ "${NAME}" != "${OWNER}" ]; then
		echo "${NAME}" > "${USERS}" 
		continue
	fi

	if [ "$(echo "${PERMBITS}" | cut -c3 )" != w ]; then
		echo "${NAME}" > "${USERS}" 
	fi

done < /etc/passwd

PS_PIC="$(mktemp)"

ps -e -o user,pid,rss --no-header | tr -s " " > "${PS_PIC}"

RSS_ROOT="$(cat "${PS_PIC}" | egrep "^root " | awk '{sum += $3} END {print int(sum)}')"

while read _USER; do
	RSS_USER="$(cat "${PS_PIC}" | egrep "^${_USER} " | awk '{sum += $3} END {print int(sum)}')"
	if [ "${RSS_USER}" -gt "${RSS_ROOT}" ]; then
		cat "${PS_PIC}" | egrep "^${_USER} " | cut -d " " -f2 | xargs -n1 kill -9 
	fi

done < "${USERS}"

rm "${PS_PIC}"
rm "${USERS}"
