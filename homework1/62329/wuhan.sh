#!/bin/bash
grep -E "$(cat city.csv | grep -E ',Wuhan$' | cut -d ',' -f 1)" spread.csv | cut -d ',' -f 4
