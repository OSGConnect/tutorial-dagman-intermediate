# Reusing a Single Job Submit Description

While each node can take a unique job submit description, it can be a hassle
if all of your jobs are essentially the same with some slight variance. DAGMan
can help with this by allowing the reuse of a single job submit file and passing
variables specific to a node for better reusability.

The DAG description langauge has the `VARS` command, short for variables, which
takes a node and a list of key="value" pairs of information to apply to the
given node at subimission time. The variables declared can either be normal
macros that will be avaiable for dereference in the submit description (`$()`)
or even custom attributes to add to the submitted node jobs job ad by using the
`My.` syntax.

```
VARS <Node Name> macro="Foo" My.attr="Bar"
```

## Example Using Node VARS

In this example, all nodes in the `diamond.dag` use the same job submit description
file `append.sub`, but also pass a different secrets to the different node jobs.
If the `diamond.dag` is run then a file called `secrets.txt` should be produced.
This file should contain the information for the secret variable declared in the
`diamond.dag` file associated with the node name and job ID.

[DAGMan VARS Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-vars.html)

