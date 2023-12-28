# Reusing a Single Submit File for Multiple Nodes

While each node can take a unique job submit description, it can be a hassle
if all of your jobs are essentially the same with some slight variance. DAGMan
can help with this by allowing the reuse of a single submit file and passing
variables specific to a node for better reusability.

Specifically, DAGMan uses the `VARS` command to define the variables for 
a particular node. This is done using 

```
VARS <Node Name> sample="Foo" My.SampleAd="Bar"
```

where first the node is specified (`<Node Name>`) followed by a list of 
`key="value"` pairs to define the variables to be used with that node at submission
time. The default behavior is that the `key` definition can be referenced in 
the job's submit file using the typical submit variable syntax, i.e. `$(key)` in the
submit file will evaluate to `"value"`. Alternatively, you can define a custom job 
attribute by prefixing your `key` with `My.`, which means that `"value"` will be
available in the job's ClassAds. 

You can also define variables to be used by all nodes with 

```
VARS ALL_NODES <list of key-value pairs>
```

Here "ALL_NODES" is a reserved name that allows you to apply a declaration to all
of the DAGMan nodes.

> For a regular HTCondor job, you can define a variable for use in job submission
> by adding it to the submit file and then calling it with the `$()` syntax, i.e., 
>
> ```
> sample = Foo
> output = $(sample).out
> ```
>
> will save the standard output file as `Foo.out`. Similarly, instead of defining `sample` 
> within the submit file, you can define the variable at submission time with
>
> ```
> condor_submit my_submit_file.sub sample="Foo"
> ```
>
> This is effectively what the `VARS` command in the input `.dag` is doing.

## Exercise

In this example, we'll use `diamond.dag` to submit multiple jobs that each
print out their own message. Since each node is doing the same job but with
a different message, we can avoid writing many submit files by using a single
submit file that takes the message as an argument.

Examine the contents of `message.sub`. What variables are being used in the 
submit file? Which variables do we need to define, and which are referencing
built-in submit variables?

Next, example the contents of `diamond.dag`. Note that each node is defined
as using the same submit file, `message.sub`. Look at the `VARS` lines and 
predict what messages will be written for each node.

Run `diamond.dag` without modification:

```
$ condor_submit_dag diamond.dag
```

The DAG should complete successfully on the first try. Next examine the output
files in `./output`. Were your predictions of messages for each node correct?

For more information on the `VARS` command, see the 
[DAGMan VARS Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-vars.html).
