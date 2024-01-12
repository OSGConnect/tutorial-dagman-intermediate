#!/bin/bash

# Process contents of data.csv
# Check to make sure each line is a number.

file='../data.csv'
filtered_file='../filtered_data.csv'
log_file='filter.log'

# check if file exists
if [ ! -f "$file" ] ; then 
	cat << EOF > $log_file
Executing \`filter.sh\`
$(date)

Data File does not exist: $file
Current directory: $(pwd)
Contents of current directory:
$(ls)
EOF
	exit 1
fi

cat << EOF > $log_file
Executing \`filter.sh\`
$(date)

Data File = $file

Removed the following lines from $file:
EOF

# If line is an integer, output to $filtered_file

for line in $(cat $file); do 
    case $line in
        ''|*[!0-9]*) 
			echo "$line" >> $log_file
			;;
		*)
			echo "$line" >> $filtered_file
			;;
    esac
done

exit 0

