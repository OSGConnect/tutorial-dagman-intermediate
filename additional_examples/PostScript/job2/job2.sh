#!/bin/bash

# Process contents of data file
# Check to make sure each line is a number.

file='filtered_data.csv'

# Main

if [ ! -f $file ] ; then 
	echo "Data file does not exist: $file"
	exit 1
fi

error=false

for line in $(cat $file); do 
    case $line in
        ''|*[!0-9]*) error=true ;;
    esac
done

if $error ; then
    echo "Encountered non-integer entry in $file"
    exit 1
fi

echo "Confirmed that all the data are integers."

declare -i sum=0
for line in $(cat $file); do
	sum=$((sum+line))
done

echo "The sum of $file is:"
echo $sum

exit 0

