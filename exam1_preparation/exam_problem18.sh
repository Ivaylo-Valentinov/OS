#!/bin/bash


TIME=""
NAME=""

while read LINE; do
	CUR_NAME="$(echo "${LINE}" | cut -d ":" -f1)"
	CUR_DIR="$(echo "${LINE}" | cut -d ":" -f6)"

	if [ ! -d "${CUR_DIR}" ]; then
		continue
	fi

	if [ ! -r "${CUR_DIR}" ]; then
		continue
	fi

	CUR_TIME="$(find "${CUR_DIR}" -type f -printf "%T@\n" 2> /dev/null | sort -n | tail -n 1)"

	if [ -z "${CUR_TIME}" ] ; then
		continue 
	fi

	
	if [ -z "${TIME}" ]; then
		TIME="${CUR_TIME}"
		NAME="${CUR_NAME}"
		continue
	fi

	CUR_TIME="$( (echo "${CUR_TIME}" ; echo "${TIME}") | sort -n | tail -n 1 )"

	if [ "${CUR_TIME}" != "${TIME}" ]; then
		TIME="${CUR_TIME}"
		NAME="${CUR_NAME}"
	fi
	
done < /etc/passwd

echo "${NAME}"
