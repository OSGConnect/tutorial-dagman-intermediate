# POST Scripts

A `POST` script is an example of a DAG node `SCRIPT`, in this case one that 
runs after the corresponding node job has completed successfully. 
These scripts are lightweight task to be ran as minor post processing tasks. 
The post-script is considered part of the node structure which means a 
post-script failure will lead to a node failure.

It is important to note that all DAG `SCRIPT`s run on the Access Point
(where you log in an submit jobs) and not on the Execution Point 
(where the node's `JOB` actually runs).

Some example uses of `POST` scripts are:

1. Verifying job output exists or is valid
2. Manipulate files (Rename, Move, Condense)
3. Produce files for DAGMan (Sub-DAGS, scripts, submit files)
4. Make a node or sub-DAG workflow re-run on success
5. Fake a node success upon job failure

## Exercise

For this example, we will again use the `sum.dag` that was used in the `PRE` script
example. This time, instead of using a `PRE` script for `job2` to check if the contents of
`data.csv` are valid, we will use the `POST` script for `job1` to filter only the valid contents
of `data.csv` into a file called `filtered_data.csv`. 

In the `sum.dag`, we define the `POST` script as

```
SCRIPT POST job2 ./filter.sh
```

> Since the node `job2` defined `DIR ./job2`, the `SCRIPT POST` command will run in
> the `./job2` directory. Thus, `filter.sh` must be in the `./job2` directory as well.

Explore the contents of `sum.dag` and the related files in the `job1` and `job2` directories.
Then run the `sum.dag` without modification:

```
$ condor_submit_dag sum.dag
```

The following sequence of events will occur during the execution of this DAG:

1. DAGMan starts up, identifies node `job1` as the first to run.
2. DAGMan submits the `JOB` for node `job1`.
3. The `JOB` for node `job1` finishes successfully, producing the file `data.csv`. 
4. DAGMan now executes the `POST` script, `filter.sh`. This will create the file `filtered_data.csv`.
5. If the `POST` script runs successfully, DAGMan marks node `job1` as successful.
6. DAGMan now executes node `job2`.

Examine the contents of `sum.dag.dagman.out` and try to identify the entries that describe 
the above sequence of events. Compare the contents of `data.csv` and `filtered_data.csv`.
Look at the output of `job2` and see if it ran correctly. In this example, the DAG should run correctly 
without modification. 

As an additional exercise, consider what happens if the `JOB` for node `job1` produces `data.csv` 
but has a non-zero exit code. Do you think that DAGMan will mark node `job1` as a success or a failure?
Consider the behavior of the `POST` script in the situation where `data.csv` exists. Finally, test your
prediction by adding the line `exit 1` to the end of `./job1/job1.sh` and rerun `sum.dag` from scratch:

```
$ rm *data.csv job*/*.{err,log,out} sum.dag.*
$ condor_submit_dag sum.dag
```

Does the DAG finish successfully? Did DAGMan mark node `job1` as a success or failure?

As you think of incorporating `PRE` and `POST` scripts in your DAG workflow, remember that such
scripts should not be intensive tasks. Limit the use of these scripts to simple checks or parsing.
If the tasks are intensive, consider placing the code into the node `JOB` proper, or even 
insert a new node to handle the intensive task.

For more information on the `POST` and other DAGMan `SCRIPT`s, see 
[DAGMAn Scripts Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-scripts.html).
For information on how DAGMan decides if a node is a success or failure, see 
[DAGMan Node Success/Failure Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/node-pass-or-fail.html).
