#!/bin/bash

# Process contents of data.csv
# Check to make sure each line is a number.

file='../data.csv'
# file='tacos.csv'
log_file='verify.log'

# check if file exists
if [ ! -f "$file" ] ; then 
	cat << EOF > $log_file
Executing \`verify.sh\`
$(date)

Data File does not exist: $file
Current directory: $(pwd)
Contents of current directory:
$(ls)
EOF
	exit 1
fi

cat << EOF > $log_file
Executing \`verify.sh\`
$(date)

Data File = $file

EOF

error=false

for line in $(cat $file); do 
    case $line in
        ''|*[!0-9]*) error=true ;;
    esac
done

if $error ; then
    echo "Encountered non-integer entry in 'data.csv'" >> $log_file
    exit 1
fi

exit 0

