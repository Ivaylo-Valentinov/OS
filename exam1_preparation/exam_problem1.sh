#!/bin/bash

cat "philip-j-fry.txt" | grep -E "^[^a-w]*[02468][^a-w]*$" | wc -l



ps -o ppid,pid,cmd
