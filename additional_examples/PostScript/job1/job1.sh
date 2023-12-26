#!/bin/bash

cat << EOF > data.csv
0
1
2
3
5
7
11
EOF

# Add bad data

sed -i 's/3/cat/g' data.csv

exit 1

