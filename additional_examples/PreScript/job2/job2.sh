#!/bin/bash

# Process contents of data.csv
# Check to make sure each line is a number.

error=false

for line in $(cat data.csv); do 
    case $line in
        ''|*[!0-9]*) error=true ;;
    esac
done

if $error ; then
    echo "Encountered non-integer entry in 'data.csv'"
    exit 1
fi

echo "Confirmed that all the data are integers."

declare -i sum=0
for line in $(cat data.csv); do
	sum=$((sum+line))
done

echo "The sum of 'data.csv' is:"
echo $sum

exit 0

