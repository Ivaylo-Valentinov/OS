#!/bin/bash

find "$(pwd)" -mindepth 1 -maxdepth 1 -printf "%n %p\n" | sort -n -r | cut -d " " -f2- | head -n 5
