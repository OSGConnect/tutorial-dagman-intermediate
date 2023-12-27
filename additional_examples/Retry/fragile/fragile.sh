#!/bin/bash
# Exit 0 if first arg = 2 else exit 1

if [ $1 -eq "2" ] ; then
    echo "The argument equals 2. This job succeeds!"
    exit 0
else
    echo "The argument $1 does not equal 2. This job fails!"
fi

exit 1

