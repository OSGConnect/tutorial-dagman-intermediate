# A DAG within a DAG is a SubDAG

Sometimes you may not know how many jobs you need to run in
a DAG until a job within DAGMan has run or maybe you need to
apply a script for a section of workflow in the DAG. A DAGMan
SubDAG can help achieve these because of how a SubDAG is ran.

Unlike a DAG splice where the spliced DAG is read and all of its
nodes are merged into the parent DAGs workflow, a SubDAG is
a node that runs `condor_submit_dag` on the DAG file. This means
the SubDAG will have all of its own DAGMan stuff (Process, job in
the AP job queue, files, etc.) and to the parent DAG is just
another node making SubDAGs more versatile than Splices. However,
SubDAGs come at the cost of the fact that each SubDAG is its own
job/process making more work for the AP schedd and more files
to dig through.

Because a SubDAG is a separate process/job submitted to HTCondor,
it only has to be declared at the time of submission for the
parent DAG but not have its contents exist until it is actually
submitted. Due to this behavior, it is common to have a DAG job
that is a parent of a SubDAG produce the DAG file that is to be
ran allowing for dynamically creating `n` nodes for a SubDAG to
run prior to actual submission of the DAG Job.

Since the SubDAG is just another node, all the node customization
stuff can be applied to portions of a workflow ran in a SubDAG.
The most common parts added to SubDAGs are scripts (Pre & Post)
and retries.

## Example using SubDAGs

In this example, our workflow needs to process `n` jobs worth of data.
Except we don't know how many `n` is until the `PRODUCE` node runs.
The `PRODUCE` node in our case simply just makes a bag DAG (DAG filled
with nodes without any PARENT/CHILD relationships) to a file called
`other.dag` just before we run it. For our test `produce.py` generates
a random number of nodes with a minimum of 1 and max of 25.

If you submit `sample.dag` without any modifications then it should
be observed that the DAG starts running and all the various `sample.dag.*`
files are produced. Once the `PRODUCE` node runs, the `other.dag` file
should be created and ran next. When the `other.dag` is ran, another
set of DAGMan files starting with `other.dag.*` should be created. Both
the parent DAG and SubDAG should complete successfully.

[DAGMan SubDAG Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-using-other-dags.html#a-dag-within-a-dag-is-a-subdag)

