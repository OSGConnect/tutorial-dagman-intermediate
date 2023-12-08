# Dealing with a Failed DAG

While it would be ideal if everything worked correctly all the
time, in reality failure is expected to happen at some point.
Normally, DAGMan will run until a successful completion (i.e.
all node jobs have run and exited successfully), but what
happens when a nodes job fails?

In the event of a node failure, DAGMan will keep doing as much
work as it possibly can before exiting. This means that any
nodes that are not a descendant of a failed node it will
continue normally. Once all possible work has been completed,
DAGMan will write a rescue file and exit.

This file will be written as:
```
<DAG File>.rescueNNN
```
Where NNN is a number represent the resuce file number incrementing
with each new rescue. This rescue number starts at 001.

When re-submitting the DAGMan job to HTCondor, unless a specific rescue
file or `-force` option was specified, DAGMan will read the newest
rescue file (file wiht highest NNN value) and mark all `DONE` nodes as
DONE. This will make DAGMan skip rerunning those nodes and starting
back up with the remaining work (i.e. where nodes failed).

## Bad DAG Example

In this directory is another diamond.dag description file. However,
if this DAG is ran as is then the DAG will fail and produce the
expected rescue file `diamond.dag.rescue001`.

Inside this rescue file is some comments about the file such as
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
the `<DAG File>.dagman.out` log file. The RIGHT node jobs working
directory `right` should shine more information on what went wrong.
Looking at the jobs standard error stream file `*.err` it states:
```
ls: invalid option -- z
```

Looking at the `ls.sub` file in the `right` sub-directory, the arguments
line is passing an invalid `-lz`. If this is changed to `-la` and then
DAGMan is re-submitted, then DAGMan should start back up skipping the
done nodes `TOP` and `LEFT` and finally finish successfully.

[Rescue from a Failed DAG](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-resubmit-failed.html#the-rescue-dag)

