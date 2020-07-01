#!/bin/bash

if [ $# -gt 2 -o $# -lt 1 ]; then 
	echo "takes one or two arguments" >&2
	exit 1
fi	

if [ ! -d "$1" ]; then
	echo "first argument must be dir" >&2
	exit 2
fi

if [ $# -eq 2 ]; then
	if egrep -q -v "^[1-9][0-9]*$" <( echo "$2" ) ; then
		echo "second argument must be a integer" >&2
		exit 3
	fi
fi

if [ $# -eq 1 ]; then
	while read LINE; do
		if [ ! -e "${LINE}" ]; then
			echo "${LINE}"
		fi
	done < <( find "$1" -type l ) 
	exit 0
fi

NUM="$(( ${2} - 1 ))"

find "$1" -type f -links "+${NUM}"
