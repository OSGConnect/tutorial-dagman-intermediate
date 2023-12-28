#!/bin/bash
# Script that appends all passed args to message.txt

# $1 <- $(JOB)
# $2 <- $(ClusterId)
# $3 <- $(ProcId)
# $4 <- $(my_message)

echo "${1} [${2}.${3}]: ${@:4}" > "message.${1}.${3}.txt"

