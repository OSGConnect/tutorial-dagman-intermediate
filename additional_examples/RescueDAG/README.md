# Dealing with a Failed DAG

While it would be ideal if everything worked correctly all the
time, in reality failure is expected to happen at some point.
Normally, DAGMan will run until a successful completion (i.e.
all node jobs have run and exited successfully), but what
happens when a node's job fails?

In the event of a node failure, DAGMan will keep doing as much
work as it possibly can before exiting. This means that any
nodes that are not a descendant of a failed node it will
continue normally. Once all possible work has been completed,
DAGMan will write a rescue file and exit.

This file will be written as:
```
<DAG File>.rescue###
```
Where `###` is the rescue file number that increments
with each new rescue. The first such file will use the number 001.

When re-submitting the DAGMan job to HTCondor, unless a specific rescue
file or `-force` option was specified, DAGMan will read the newest
rescue file (file with the highest `###` value) and mark all `DONE` nodes as
DONE. The DONE nodes will be skipped and DAGMan will start
back up with submitting the remaining work (i.e. the failed nodes 
and descendants).

## Bad DAG Example

In this directory is another `diamond.dag` input file.
Examine the contents of the file and determine the structure of the DAG
and the submit files corresponding to each node.

Run the DAG without modification:

```
$ condor_submit_dag diamond.dag
```

The DAG will fail and produce the rescue file `diamond.dag.rescue001`.
Inside this rescue file are some comments about the file such as
when it was written, what nodes have failed, and a list of nodes
marked as `DONE`

```
$ cat diamond.dag.rescue001
  ...
  TOP DONE
  LEFT DONE
```

In this example the RIGHT node has failed for some reason. This
notice of node failure can be found in both the rescue file and
the `<DAG File>.dagman.out` log file. The RIGHT node's working
directory `right` should provide more information on what went wrong.
Looking at the job's standard error (`.err`) file it states:

```
ls: invalid option -- z
```

Looking at the `ls.sub` file in the `right` sub-directory, the arguments
line is passing an invalid `-lz`. 

Change the argument from `-lz` to `-la` in `right/ls.sub` and then
resubmit the DAG workflow. DAGMan should start back up but skip the
DONE nodes `TOP` and `LEFT` and proceed directly to the `RIGHT` node, 
followed by the `BOTTOM` node, and finish successfully.

For more information, see the HTCondor documentation: 
[Rescue from a Failed DAG](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-resubmit-failed.html#the-rescue-dag).

