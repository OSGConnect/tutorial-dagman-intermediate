# Node Pre-Scripts

A pre-script is an example of a DAG node `SCRIPT` , in this case one 
that runs before the corresponding node job is submitted. 
These scripts are lightweight tasks to be ran as a set-up step for a 
node. The pre-script is considered part of the node structure which 
means a pre-script failure will lead to a node failure without 
attempting to submit the nodes specified job.

It is important to know that all DAG `SCRIPT`s run on the Access Point
(where you log in and submit jobs) and not on the Execution Point 
(where the node's `JOB` actually runs).

## Examples of Pre-Scripts

1. Verifying a jobs input data exists or is valid for the job
2. Manipulate files (Rename, Move, Condense)

## Example use of Pre-Scripts

For this example, we want to verify that node `B` has valid input. To
do this, node `B` was given a pre-script (`SCRIPT PRE B ../verify.sh`) 
in the input `.dag` that checks to make sure a bad input file (`bad.txt`) 
doesn't exist. 

Run the `sample.dag` without modification:

```
$ condor_submit_dag sample.dag
```

The following sequence of events will occur during the execution of this DAG:

1. DAGMan starts up, identifies node `A` as the first to run.
2. DAGMan submits the `JOB` for node `A`.
3. The `JOB` for node `A` finishes successfully but produces the file `bad.txt`. 
4. DAGMan determines node `A` completed successfully, moves on to node `B`.
5. DAGMan executes the `PRE` script for node `B`; this script detects `bad.txt` and exits with a non-zero status.
6. DAGMan marks node `B` as failed since the `PRE` script failed.
7. DAGMan creates a rescue DAG since there are failed nodes.

Note that because the `PRE` script for node `B` failed, DAGMan did not even attempt to submit the associated `JOB`. 

By verifying the quality of the input data before attempting to submit

[DAGMAn Scripts Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-scripts.html)

