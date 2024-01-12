#!/bin/bash

for file in $(ls echo.*.out) ; do
	cat $file >> recombine.out
	rm $file
done

exit 0

