# PRE Scripts

A `PRE` script is an example of a DAG node `SCRIPT` , in this case one 
that runs before the corresponding node job is submitted. 
These scripts are lightweight tasks to be ran as a set-up step for a 
node. The `PRE` script is considered part of the node structure which 
means a `PRE` script failure will lead to a node failure without 
attempting to submit the nodes specified job.

It is important to note that all DAG `SCRIPT`s run on the Access Point
(where you log in and submit jobs) and not on the Execution Point 
(where the node's `JOB` actually runs).

Some example uses of `PRE` scripts are:

1. Verifying a jobs input data exists or is valid for the job
2. Manipulate files (Rename, Move, Condense)

## Exercise

For this example, we want to verify that node `job2` has valid input. To
do this, node `job2` is given a pre-script (`SCRIPT PRE job2 ./verify.sh`) 
in the input `.dag` that checks that the contents of `data.csv` are valid. 

> Note: `SCRIPT` will use the same `DIR` value as defined in the node's
> `JOB` definition.

Explore the contents of `sum.dag` and the related files in the `job1` and `job2` directories.
Run the `sum.dag` without modification:

```
$ condor_submit_dag sum.dag
```

The following sequence of events will occur during the execution of this DAG:

1. DAGMan starts up, identifies node `job1` as the first to run.
2. DAGMan submits the `JOB` for node `job1`.
3. The `JOB` for node `job1` finishes successfully, producing the file `data.csv`. 
4. DAGMan determines node `job1` completed successfully, moves on to node `job2`.
5. DAGMan executes the `PRE` script for node `job2`; this script checks the contents of `data.csv`
   and finds that there is a non-integer entry, so it exits with a non-zero status.
6. DAGMan marks node `job2` as failed since its `PRE` script failed.
7. DAGMan creates a rescue DAG since there are failed nodes.

Note that because the `PRE` script for node `job2` failed, DAGMan did not even attempt to submit the associated `JOB`. 

Examine the contents of `sum.dag.dagman.out` and try to identify the entries that describe
the above sequence of events. 

In this example, `job2/verify.sh` generates a log file `job2/verify.log`. 
Look in the log file to determine the reason why the `verify.sh` script failed.
Make the necessary changes to `data.csv` and submit the DAG a second time.

If you make the correct changes, then when DAGMan starts node `job2` the
`PRE` script should run successfully and DAGMan should submit the corresponding 
job. Once it finishes, the sum of the contents of `data.csv` will be printed
in `job2/job2.out`.

We now see that the `PRE` script can be used to check the input of a job
and prevent the job from being submitted if something is wrong.
Combined with the rescue DAG utility, this allows you to manually intervene
and correct the input data, then resume the DAG from where it failed.

For more information on the `PRE` and other types of `SCRIPT`s, see
[DAGMAn Scripts Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-scripts.html).
