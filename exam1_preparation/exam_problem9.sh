#!/bin/bash


find "$(echo ~ivaylo)" -type f -links +1 -printf "%T@ %i\n" \
	| sort -n -t " " -k1 \
	| tail -n 1 \
	| cut -d " " -f2
