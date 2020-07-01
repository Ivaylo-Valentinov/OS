#!/bin/bash

if [ $# -ne 3 ]; then
	echo "takes 3 arguments" >&2
	exit 1
fi

if [ ! -d "$1" ]; then
       echo "should be a directory" >&2
       exit 2
fi

if [ ! -d "$2" ]; then
       echo "should be a directory" >&2
       exit 2
fi 


SRC="$(dirname "$1")/$(basename "$1")"
DST="$(dirname "$2")/$(basename "$2")"

if [ ! -z "$(find "$DST" -mindepth 1 -maxdepth 1)" ];then
	echo "${DST} : should be empty"
	exit 3
fi

while read SRC_FILE; do
	DST_FILE="$(echo "${SRC_FILE}" | sed "s%${SRC}%${DST}%" )"
	mkdir -p "$(dirname "${DST_FILE}")"
	mv "${SRC_FILE}" "${DST_FILE}"
done < <( find "${SRC}" -type f -name "*${3}*" )
