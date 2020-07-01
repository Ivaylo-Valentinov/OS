#!/bin/bash

if [ $# -gt 0 ]; then
	echo "too many arguments" >&2
	exit 1
fi

while read LINE; do
	NAME="$(echo "${LINE}" | cut -d ":" -f1)"
	HOMEDIR="$(echo "${LINE}" | cut -d ":" -f6)"
	if [ -z "${HOMEDIR}" ]; then
		echo "${NAME} has no home dir" 
	 	continue
       	fi	

	if [ ! -d "${HOMEDIR}" ]; then
		echo "${NAME} has no home dir" 
	 	continue
       	fi	

	OWNER="$( stat -c "%U" "${HOMEDIR}" )"
	PERMBITS="$( stat -c "%A" "${HOMEDIR}" )"

	if [ "${NAME}" != "${OWNER}" ]; then
		echo "${NAME} is not the owner"
		continue
	fi

	if [ "$(echo "${PERMBITS}" | cut -c3 )" != w ]; then
		echo "${NAME} cannot write in his own home directory"
	fi

done < /etc/passwd 
