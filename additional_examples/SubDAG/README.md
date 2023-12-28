# A DAG within a DAG is a SubDAG

In developing a complex DAG workflow, you may encounter the need
for a node in your workflow to submit a different DAG. In this case, the 
regular `JOB` syntax for defining a node is insufficient, as such a node is
always executed with `condor_submit`, but in order to submit another DAG,
you need `condor_submit_dag`. This is where the `SUBDAG` utility is useful.

In the main `.dag` input file, declare the following line:

```
SUBDAG EXTERNAL <Node Name> <SubDAG input>.dag
```

This will create a node named `<Node Name>` in the main DAG workflow
that can be used for defining the PARENT/CHILD relationships, while the
execution of the node itself will be carried out using `condor_submit_dag`
on the `<SubDAG input>.dag` workflow. The SubDAG will be executed 
completely independently of the main DAG, but just like a regular node,
the main DAG will not start the SubDAG node until the PARENT node(s) 
complete and will not move on to the CHILD node(s) until the SubDAG 
node is completed.

Since a SubDAG is just another node, all the node customization options 
from the other parts of this tutorial can be applied to the SubDAG node.
Typically the `PRE` and `POST` scripts and the `RETRY` commands are applied
to the SubDAG node.

A simple use case for a SubDAG is incorporating an existing DAG into
a larger workflow. In this case, the `.dag` file for the SubDAG already exists
and merely needs to be executed as part of the larger workflow.

A more complex use case is for submitting a SubDAG of arbitrary size, 
the size of which is not known when you submit the main DAG workflow.
Consider the split-and-recombine workflow that was mentioned in the
[top level of this tutorial repository](../../README.md). In that scenario, the first node splits
into multiple nodes before the results are recombined by the final node.
What if you didn't know the number of nodes that the first node would 
generate? For a regular DAG, this would be an insurmountable problem
since all of the nodes for DAG must be declared at the time of submission
of the DAG. A solution is to have the first node programmatically create the
SubDAG's input file. While all nodes have to be declared at the time a DAG
is submitted, the *submit files for a node do not have to exist until DAGMan*
*tries to execute that node*. That allows you to dynamically create nodes (as
part of the SubDAG) during the execution of the main DAG.

## Exercise

As with the other exercises, first examine the files and their contents and
try to identify the structure of the DAG workflow.

In this example, the main DAG input file `sample.dag` declares the 
following nodes:

* `split` 
* `my_subdag` 
* `recombine`

where the `split` node is the PARENT of the `my_subdag` node, which in
turn is the PARENT of the `recombine` node. While three nodes are declared,
only the submit files for the `split` and `recombine` nodes exist at the start.

Looking into the current files, you'll find that the node `split`
uses the executable `split.py`. Examining the executable shows that 
the python script creates the file `my_subdag.dag` with an arbitrary number 
(between 1 and 25) of `JOB` node declarations, each of which call `echo.sub`. 
Thus, when the `JOB` attached to the `split` node completes, it will return 
the input `my_subdag.dag` file needed to execute the next node in `sample.dag`. 
(In this example, `echo.sub` already exists, but it's easy to imagine extending 
the script to automatically generate that file or even a unique submit file for 
each node. Also, a python script was used here for easy generation of a random 
number.)

Next, examine the contents of `echo.sub` and `echo.sh`. What does this job
do? What will happen when this job is executed multiple times as part of 
the SubDAG `my_subdag`? Similarly examine the contents of `recombine.sub`
and its executable `recombine.sh`. 

In this case, the `echo` jobs will return a message in `echo.####.out` in the
`./echo` folder, and the `recombine` job will combine these messages and 
return a single file called `recombine.out`. Since the `echo` jobs are run as
part of the `my_subdag` node, the `recombine` job won't start until they have
all completed.

Finally, submit `sample.dag` without any modifications:

```
$ condor_submit_dag sample.dag
```

As the job progresses, `my_subdag.dag` will be automatically created (returned
as output of the `split` node) and in turn automatically submitted; note the
creation of the usual DAG submission files `my_subdag.dag.*`. When the main
DAG completes, there should be a file `recombine.out` that contains the job
numbers for `echo` jobs submitted as part of the auto-generated `my_subdag.dag`.
Explore the various files and logs and confirm that your understanding of the
workflow and its execution is correct.

> As you can see, a lot of files were generated in this process. As an additional
> exercise, consider resetting the example and then modifying the `.dag`, `.sub`, 
> and executable files to organize the various results/steps into individual 
> directories. The following command should reset this example to its original
> state:
>
> ```
> rm *.log && rm echo/* my_subdag.dag* recombine.out sample.dag.*
> ```

For more information on the `SUBDAG` utility, see the
[DAGMan SubDAG Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-using-other-dags.html#a-dag-within-a-dag-is-a-subdag).
