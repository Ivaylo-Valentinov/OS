#!/bin/bash

if [ "$#" -ne 3 -a "$2" != "distance" ]; then
	echo "error: not a valid number of arguments" >&2
	exit 2
fi

if [ "$2" = "distance" -a "$#" -ne 4 ]; then
	echo "error: not a valid number of arguments" >&2
	exit 2
fi

if [ ! -f "$1" -o ! -r "$1" ]; then
	echo "error: '${1}' not a regular file or don't have read permissions" >&2
	exit 3
fi

if echo "$3" | grep -E -q -v "^[[:alnum:]/]+$" ; then
	echo "error: '${3}' not valid format" >&2
	exit 4
fi

if [ "$#" -eq 4 ]; then
	if echo "$4" | grep -E -q -v "^[[:alnum:]/]+$" ; then
		echo "error: '${4}' not valid format" >&2
		exit 4
	fi
fi

function mapdata {
	
	FOUND=""	
	FOUND="$(cat "${1}" | grep -E "^=${2}(\[|\(|,)")"

	if [ -z "${FOUND}" ]; then

		ANS=""
		COUNT="$(echo "$2" | wc -c )"
		while [ "${COUNT}" -gt "0" ]; do
			PREFIX="$(echo "$2" | cut -c1-"${COUNT}")"
			ANS="$(cat "${1}" | grep -E "^${PREFIX}(\[|\(|,)" | head -n 1 )"
			if [ ! -z "${ANS}" ] ; then
				echo "${ANS}"
				return
			fi
			COUNT="$(( ${COUNT} - 1 ))"
		done
		
		ANS="$(cat "${1}" | head -n 1)"
		echo "${ANS}"
		return

	else 
		echo "${FOUND}"
		return
	fi
}

TEMP="$(mktemp)"
if [ -z "${CTY_FORMAT}" -o "${CTY_FORMAT}" != "DAT" ]; then

	while read -d $'\n' LINE ; do
		COUNTRY="$(echo "${LINE}" | cut -d "," -f 1)"
		WAZ="$(echo "${LINE}" | cut -d "," -f 2)"
		ITU="$(echo "${LINE}" | cut -d "," -f 3)"
		WIDTH="$(echo "${LINE}" | cut -d "," -f 4)"
		LENGTH="$(echo "${LINE}" | cut -d "," -f 5)"
		echo "${LINE}" | cut -d "," -f 6 | tr " " "\n" \
			| xargs -l -I{} echo "{},${COUNTRY},${WAZ},${ITU},${WIDTH},${LENGTH}" >> "${TEMP}"
	done < <( cat "$1" | cut -d ";" -f 1 | cut -d "," -f 2,5,6,7,8,10  )

else	
	while read -d $'\n' LINE ; do
		COUNTRY="$(echo "${LINE}" | cut -d ":" -f 1)"
		WAZ="$(echo "${LINE}" | cut -d ":" -f 2 | tr -d " ")"
		ITU="$(echo "${LINE}" | cut -d ":" -f 3 | tr -d " ")"
		WIDTH="$(echo "${LINE}" | cut -d ":" -f 4 | tr -d " ")"
		LENGTH="$(echo "${LINE}" | cut -d ":" -f 5 | tr -d " ")"
		echo "${LINE}" | cut -d ":" -f 6 | tr -d " " | tr "," "\n" \
			| xargs -l -I{} echo "{},${COUNTRY},${WAZ},${ITU},${WIDTH},${LENGTH}" >> "${TEMP}"
	done < <(cat "$1" | sed -r "s%\r%%g" | sed -z -r "s%:\n%:%g" | sed -z -r "s%,\n%,%g" | cut -d ";" -f 1 | cut -d ":" -f 1,2,3,5,6,9)
	
fi

case "$2" in
	"country")
		RESULT="$(mapdata "${TEMP}" "${3}")"
		echo "${RESULT}" | cut -d "," -f 2
		;;
	"zones")
		RESULT="$(mapdata "${TEMP}" "${3}")"
		ITU="$(echo "${RESULT}" | cut -d "," -f 4)"
		WAZ="$(echo "${RESULT}" | cut -d "," -f 3)"
		RULE="$(echo "${RESULT}" | cut -d "," -f 1)"
		if grep -q -E "\([0-9]+\)" <(echo "${RULE}") ; then
			WAZ="$(echo "${RULE}" | sed -r 's%(.*\(|\).*)%%g')"
		fi
		if grep -q -E "\[[0-9]+\]" <(echo "${RULE}") ; then
			ITU="$(echo "${RULE}" | sed -r 's%(.*\[|\].*)%%g')"
		fi
		echo "${ITU} ${WAZ}"
		;;
	"distance")
		R="6371"
		RES_A="$(mapdata "${TEMP}" "${3}")"
		RES_B="$(mapdata "${TEMP}" "${4}")"
		X_A="$(echo "${RES_A}" | cut -d "," -f 5)"
		Y_A="$(echo "${RES_A}" | cut -d "," -f 6)"
		X_B="$(echo "${RES_B}" | cut -d "," -f 5)"
		Y_B="$(echo "${RES_B}" | cut -d "," -f 6)"
		
		FI_A="$(echo "${X_A} * a(1) / 45" | bc -l)"
		THETA_A="$(echo "${Y_A} * a(1) / 45" | bc -l)"
		FI_B="$(echo "${X_B} * a(1) / 45" | bc -l)"
		THETA_B="$(echo "${Y_B} * a(1) / 45" | bc -l)"

		X_A="$(echo "${R} * c(${FI_A}) * c(${THETA_A})" | bc -l)"
		Y_A="$(echo "${R} * c(${FI_A}) * s(${THETA_A})" | bc -l)"
		Z_A="$(echo "${R} * s(${FI_A})" | bc -l)"

		X_B="$(echo "${R} * c(${FI_B}) * c(${THETA_B})" | bc -l)"
		Y_B="$(echo "${R} * c(${FI_B}) * s(${THETA_B})" | bc -l)"
		Z_B="$(echo "${R} * s(${FI_B})" | bc -l)"

		D="$(echo "sqrt( (${X_A} - ${X_B})^2 + (${Y_A} - ${Y_B})^2 + (${Z_A} - ${Z_B})^2 )" | bc -l )"
		EXP="$(echo "sqrt(4 * ${R} * ${R} - ${D} * ${D}) * ${D} / (2 * ${R} * ${R})" | bc -l )"
		D="$(echo "${R} * a(${EXP} / sqrt(1 - ${EXP} * ${EXP}))" | bc -l)"
		D="$(echo "(${D} + 0.5) / 1" | bc)"
		echo "${D}"

		;;
	*)
		echo "error: UNKOWN SUBCOMMAND" >&2
		rm "${TEMP}"
		exit 1
		;;
esac


rm "${TEMP}"
