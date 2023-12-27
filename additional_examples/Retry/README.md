# Retrying Failed Nodes

As demonstrated in the earlier examples, the rescue DAG utility allows you to 
resume a DAG from where it failed without having to restart the whole DAG 
from scratch. While the rescue DAG utility is useful, it is not necessarily 
convenient, since it requires manual intervention and resubmission.

If you know that a node will occasionally fail through no fault of your own, 
and simply want DAGMan to try that node again, then you can tell DAGMan to
automatically retry that node again. To do so, define a `RETRY` statement :

```
RETRY your_node N
```

where you should replace `your_node` with the name of the 
node that experiences intermittent failures and `N` with the number of times
that you want DAGMan to automatically retry that node. Now, should that node
fail for any reason (whether from a `PRE` or `POST` script, or the `JOB` proper), 
DAGMan will automatically retry that node up, to `N` times.

You can also apply the `RETRY` statement to all nodes in the DAG with
```
RETRY ALL_NODES N
```

where you replace `N` with the number of automatic retries.

> Note that the number of automatic retries should generally be kept low
> (ideally at 3 or less) if using the `RETRY` statement for handling intermittent failures. 
> If your job repeatedly fails, it is better to troubleshoot the underlying cause
> of the failure instead of increasing the value of the `RETRY` statement.

## Exercise

To start, first examine the contents of `retry.dag`. What are the nodes in the DAG?
How is the `RETRY` statement used?

Next, examine the contents of `fragile.sub`. What is the executable? What 
arguments are passed to the executable? What files will be generated when 
this job is submitted?

In this example, the `retry.dag` has only one node (`fragile`) that runs
`fragile.sh`. The job for the `fragile` node passes the current number of retries 
(`$(RETRY)` in the `.sub` file) to the executable `fragile.sh`. The executable will 
only exit successfully if the number `2` is passed as an input. 

Now run `retry.dag` without modification:

```
$ condor_submit_dag retry.dag
```

The DAG should run to completion. 

Examine the output files of the `fragile` job. Can you tell how many times
the job ran? Confirm your answer by examining the contents of
`retry.dag.dagman.out`.

For more information on the `RETRY` command, see 
[DAGMan Node Retries Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/node-pass-or-fail.html#retrying-failed-nodes).

