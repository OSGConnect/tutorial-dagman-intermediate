# Node Post-Scripts

A post-script is a DAG node script that runs after the corresponding
node job has completed successfully. These scripts are lightweight task
to be ran as minor post prcessing tasks. The post-script is considered
part of the node structure which means a post-script failure will lead
to a node failure.

It is important to know that all scripts run on the Access Point and
not the Execution Point where the node job payload actually runs.

## Examples of Post-Scripts

1. Verifying job output is exists ir is valid
2. Manipulate files (Rename, Move, Condense)
3. Produce files for DAGMan (Sub-DAGS, scripts, submit files)
4. Make a node or sub-DAG workflow re-run on success
5. Fake a node success upon job failure

## This Example

For this example the `sample.dag` contains two nodes that both have a
failing executable. This executable always exits with the value `3` and
would normally cause the node to fail. However, for our case we will assume
`exit 3` is a transient failure we don't care about and would like work to
continue. To combat this, we add a post script to each node and pass the jobs
return value:

```
SCRIPT POST ALL_NODES ../post.sh $RETURN
```

In the `post.sh` script we simple check the passed passed value, exit code for
the nodes job, is the value of `3`. If it is then we exit successfully causing
the node to be successful. Otherwise, we do `exit 1` to cause a node failure.

If you ran the sample DAG withour modification then you should see the DAG finish
successfully. However, if you were to modify the `fail.sh` executable ran by the
`fail.sub` submit file in the FailJob sub-directory to exit any number besides `3`
then when the DAG is rerun it should fail at the execution of the first node `A`.

[DAGMAn Scripts Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-scripts.html)

