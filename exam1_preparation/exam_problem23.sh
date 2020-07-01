#!/bin/bash

[ $# -eq 2 ] || exit 1
[ -d $1 ] || exit 2

D="$1"
ARCH="$2"

NAMES="$(mktemp)"

find "$D" -mindepth 1 -maxdepth 1 -type f -name "vmlinuz-*.*.*-${ARCH}" -printf "%f\n"> "${NAMES}"

if egrep -qve "^vmlinuz-[0-9]+\.[0-9]+\.[0-9]+-" "${NAMES}" ; then
	echo "invalid names" >&2
	rm "${NAMES}"
	exit 3
fi

VER="$(cut -d "-" -f2 ${NAMES} | sort -t "." -k1,1 -k2,2 -k3,3 | tail -n 1 )"

echo "vmlinuz-${VER}-${ARCH}"
rm "${NAMES}"

