#!/usr/bin/env python3
# Script to produce a DAG with a random number of nodes (1-25)
from random import random as rand

with open("my_subdag.dag", "w") as dag_file:
    num = (int(rand() * 100) % 25) + 1
    for i in range(num):
        dag_file.write(f"JOB Node-{i} echo.sub\n")

