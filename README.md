# Introduction to DAGMan

This is a worked example of a simple DAGMan workflow and will cover key knowledge
and ideas along with the basics of creating, submitting, and managing DAG workflows submitted to HTCondor. 
For more information on DAGMan and DAG workflows, see our guide on [How to Create Workflows using DAGMan](). 
Additional information is provided in HTCondor's [DAGMan Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-introduction.html).

## What is DAGMan?

DAGMan is short for "DAG Manager", and is a utility built into HTCondor for automatically running a workflow (DAG) of jobs, 
where the results of an earlier job are required for running a later job. 
DAG itself is an acronym for "Directed Acyclic Graph", a concept from the mathematic field of graph theory.

1. Graph: a collection of points ("nodes" or "vertices") connected to each other by lines ("edges").
2. Directed: the edges between nodes have direction, that is, each edge begins on one node and ends on a different node.
3. Acyclic: the graph does not have a cycle - or loop - where the graph returns to a previous node.

By using a directed acyclic graph, we can guarantee that the workflow has a defined 'start' and 'end'. 

## The Diamond DAG

This example (diamond.dag) is one of the simplest of examples of
using a DAG to create a specific workflow. While this DAG shows the
flow of work being done in a diamond shape, there are many forms
a workflow can take. Including but not limited to:

1. A bag of jobs (Group of jobs submitted by DAGMan with no edge connections)
2. Disjointed Graphs (Two separate/independent graphs ran managed by DAGMan)
3. A Shish Kabob graph (A straight line from top to bottom structured graph)

To describe the flow of the DAG and parts needed, DAGMan uses a custom
description language in written in a file. The standard naming convention
for this is file is '<DAG Name>.dag'. The two most important commands
in the DAG description language are:

1. JOB - Describes a node and the job it will run
2. PARENT/CHILD - Describes an edge representing job relationships

To view the Diamond DAG description run

```
$ cd DiamondDAG
$ cat diamond.dag
```

## Submitting a DAG

To submit a DAGMan workflow to HTCondor simply run one of the following
commands from the DiamondDAG directory:

```
$ condor_submit_dag diamond.dag
  or
$ htcondor dag submit diamond.dag
```

## What Happens?

When a DAG is submitted to HTCondor a special job is created to run DAGMan
on behalf of you the user. This job runs the provided HTCSS DAGMan executable
in the AP job queue. This is an actual job that can be queried and acted upon.

You may also notice that lots of files are created. These files are all part
of DAGMan and have various purposes. Note: that these are not all the files
that DAGMan can produce as depending on your DAG description more files with
different purposes will be created. However, the general files that should
always exist are as follows:

* DAGMan job proper files
  1. <DAG File>.condor.sub - Submit file for the DAGMan job proper
  2. <DAG File>.dagman.log - Job event log file for the DAGMan job proper
  3. <DAG File>.lib.err - Standard error stream file for the DAGMan job proper
  4. <DAG File>.lib.out - Standard output stream file for the DAGMan job proper
* Informational DAGMan files
  1. <DAG File>.dagman.out - General DAGMan process logging file
  2. <DAG File>.nodes.log - Collective job event log file for all managed jobs (Heart of DAGMan)
  3. <DAG File>.metrics - JSON formatted information about the DAG

## Monitoring DAGMan

Since DAGMan is submitted to the AP job queue as a job itself and all jobs
managed by DAGMan are submitted to the AP job queue, the normal methods of
job monitoring work. For more inforomation checkout
[DAGMan Interaction Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-interaction.html)

The primary way of running a query on the job queue will result in an
condensed batch view of jobs submitted, running, and managed by the
DAGMan job proper. You can add one or two more flags to get more per
job information about jobs running under DAGMan:

```
# Basic job query (Batched/Condensed)
$ condor_q

# Non-Batched query
$ condor_q -nobatch

# Increased information
$ condor_q -nobatch -dag
```

You can also watch the progress of the DAG and the jobs running under it
by running:

```
$ condor_watch_q
```

Finally, if the DAGMan job is still running or in the AP job queue then you
can get lots of information about the DAG such as nodes states, submitted jobs,
and overall progress by running:

```
$ htcondor dag status <DAGManJobId>
```

Note: The DAGMan job ID is the cluster ID of the DAGMan job proper.

## Where do my jobs run?

It can be difficult to discern where your job is ran from, and the short
answer is DAGMan does work from the working directory that you submitted
it from. Meaning all other work such as job submission will be relative to
the directory DAGMan was submitted from.

This can be oberved by inspecting the sleep.sub submit file in the SleepJob
sub-directory and the diamond.dag decription file. In the diamond.dag file
the jobs are declared with

```
./SleepJob/sleep.sub
```

meaning the submit file is sleep.sub found at SleepJob directory in this
current directory. Similarly, inside sleep.sub the log command is set to
a similar path so that the job event log is written to the sub-directory
SleepJob. This only applies to information using relative paths.

This is just the default behavior, and there are ways to make the location
of job submission/management more obvious.

[File Paths in DAGs Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-file-paths.html)

## Additional Examples

Additional examples are provided in the folder `additional_examples` with corresponding READMEs. 
The following order of tutorial examples to cover various topics related to DAGMan is recommended:

1. RescueDag - Example for DAGs that don't exit successfully
3. PreScript - Example using a pre-script for a node
4. PostScript - Eample using a post-script for a node
5. Retry - Example for retrying a failed node
6. VARS - Example of reusing a single submit file for multiple nodes with differing variables
7. SubDAG (Intermediate) - Example using a subdag
8. Splice (Intermediate) - Example of using DAG splices
