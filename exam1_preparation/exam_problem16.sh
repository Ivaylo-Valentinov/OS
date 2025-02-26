#!/bin/bash


if [ $# -ne 3 ]; then
	echo "takes 3 arguments" >&2
	exit 1
fi


if [ ! -f "$1" ]; then
	echo "$1 should be a file" >&2
	exit 2
fi

if [ ! -r "$1" -o ! -w "$1" ]; then
	echo "$1 cannot read or write" >&2
	exit 3
fi

F="$1"
S1="$(egrep "^2=" $F | cut -d "=" -f2)"

if [ "$(egrep -c "^$3=" $F)" -eq 0 ]; then
	echo "$3=" >> "$F"
	exit 0
fi

S2="$(egrep "^$3=" $F | cut -d '=' -f2 )"

NEWS2="$(comm -13 <(echo "$1" | tr -s ' ' | tr ' ' '\n' | sort) <(echo "$S2" | tr -s ' ' | tr ' ' '\n' | sort) | xargs )"

sed -i -e "s/^$3=$S2/$3=$NEWS2/" $F
