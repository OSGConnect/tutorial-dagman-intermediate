# Node Pre-Scripts

A pre-script is a DAG node script that runs before the corresponding
node job is submitted. These scripts are lightweight task to be ran
as a set up step for a node. The pre-script is considered part of the
node structure which means a pre-script failure will lead to a node
failure without attempting to submit the nodes specified job.

It is important to know that all scripts run on the Access Point and
not the Execution Point where the node job payload actually runs.

## Examples of Pre-Scripts

1. Verifying a jobs input data exists or is valid for the job
2. Manipulate files (Rename, Move, Condense)

## Example use of Pre-Scripts

For this example, we want to verify that node `B` has valid input. To
do this, node `B` was given a pre-script that checks to make sure a bad
input file (`bad.txt`) doesn't exist. If the `sample.dag` is run without
modification then we should observe node `A` produce a `bad.txt` resulting
in node `B`'s pre-script to fail. Thus, preventing node `B`'s job from
running and causing the node to fail.

[DAGMAn Scripts Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-scripts.html)

