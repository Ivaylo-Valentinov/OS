#!/bin/bash

cat "my_passwd" | egrep "^([^:]*:){5}/home/Inf" | cut -c3-4 | sort | uniq -c | sort -n -r | head -n 1 
