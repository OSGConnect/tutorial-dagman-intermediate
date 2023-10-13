#!/bin/bash
# Fail if the file 'bad.txt' exists

if [ -f "bad.txt" ];
then
    exit 1
fi

