# Reusing a Single Submit File for Multiple Nodes

While each node can take a unique job submit description, it can be a hassle
if all of your jobs are essentially the same with some slight variance. DAGMan
can help with this by allowing the reuse of a single submit file and passing
variables specific to a node for better reusability.

Specifically, DAGMan uses the `VARS` command to define the variables for 
a particular node. This is done using 

```
VARS <Node Name> macro="Foo" My.attr="Bar"
```

where first the node is specified (`<Node Name>`) followed by a list of 
`key="value"` pairs to define the variables to be used with that node at submission
time. The default behavior is that the `key` definition can be referenced in 
the job's submit file using the typical submit variable syntax, i.e. `$(key)` in the
submit file will evaluate to `"value"`. Alternatively, you can define a custom job 
attribute by prefixing your `key` with `My.`, which means that `"value"` will be
available in the job's ClassAds. 

## Exercise

In this example, all nodes in the `diamond.dag` use the same job submit description
file `append.sub`, but also pass a different secrets to the different node jobs.
If the `diamond.dag` is run then a file called `secrets.txt` should be produced.
This file should contain the information for the secret variable declared in the
`diamond.dag` file associated with the node name and job ID.

[DAGMan VARS Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-vars.html)

