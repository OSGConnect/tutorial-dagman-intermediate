#!/usr/bin/python3
# Script to produce a DAG with a random number of nodes (1-25)
from random import random as rand

with open("other.dag", "w") as f:
    num = (int(rand() * 100) % 25) + 1
    for i in range(num):
        f.write(f"JOB Node-{i} sleep.sub\n")

