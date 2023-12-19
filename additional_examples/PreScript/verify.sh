#!/bin/bash

# Fail if the file 'data.txt' contains non-numeric characters

error="Encountered non-numeric entry in 'data.txt'"

for line in $(cat data.txt); do
	case $line in
		''|*[!0-9]*) echo $error && exit 1 ;;
	esac
done

exit 0

