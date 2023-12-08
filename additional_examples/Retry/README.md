# Retrying Failed Nodes

Another way to combat intermittent DAGMan node failures without having
to restart the entire DAG is with the `RETRY` command in the DAG description
language. `RETRY` is simple. Any node that fails for some reason (Pre-Script,
Post-Script, or Job) will be rerun up to `n` times or the node has completed
successfully.

## Example Using Node Retries

In this example, the `sample.dag` has only one node called `ONLY` that runs
`fragile.sh`. This executable (`fragile.sh`) will only exit successfully if
it is passed `3` as an input. In the `fragile.sub` submit file the current
nodes retry number is passed as an argument to the script. The nodes retry
number is an incrementing number starting at zero representing which retry
attempt this nodes execution is.

If the `sample.dag` is submitted without any modifications then we should
observe a successful DAG completion. However, upon closer inspection of the
`sample.dag.dagman.out` file it can be observed that the `ONLY` node ran a total
of four times. The successful node execution attempt was the third retry
attempt where the DAG passed `3` to the job submit description to use as an
argument for the `fragile.sh`

[DAGMan Node Retries Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/node-pass-or-fail.html#retrying-failed-nodes)

