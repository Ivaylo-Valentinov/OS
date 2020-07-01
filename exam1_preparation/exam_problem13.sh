#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: ./this argument" >&2
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "not a dir" >&2
	exit 2
fi
	

while read -d $'\n' LINE ; do
	if [ ! -e "${LINE}" ]; then
		echo "${LINE}"
	fi
done < <( find "$1" -type l )
