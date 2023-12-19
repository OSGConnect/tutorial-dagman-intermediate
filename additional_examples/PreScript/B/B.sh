#!/bin/bash

# Normally, you can use 
#   awk '{ sum += $1 } END { print sum }' data.txt
# to sum the contents of a file, and awk is smart enough
# to skip over non-numeric values.

# For this exercise, we want to cause an error when 
# attempting to add a non-numeric value to a sum.
# While this is almost identical in construction to 
# verify.sh, in practice the commands in this script
# would be much more intensive and NOT suitable for 
# running on the Access Point

sum=0
error="Encountered non-numeric entry in 'data.txt'"

for line in $(cat data.txt); do
    case $line in
        ''|*[!0-9]*) echo $error && exit 1 ;;
		*) sum=$((sum+line)) ;;
    esac
done

echo $sum

exit 0

