# DAG Splicing

Sometimes there are repeating patterns in a DAG that can be described
as a different DAG and incooperated into other DAGs. One method of
utilizing another DAG within a DAG is via Splicing. When a DAG is
spliced into another, that DAGs nodes added into the parent DAGs
dependency flow. Meaning if you had a simple DAG `A->B->C` and
node `B` was a splice of another DAG `X Y` then the resulting DAG
would be a diamond DAG.

## Key Things About Splicing

1. Since the spliced DAG nodes are merged into the parent DAG, only one DAG is ran resulting in less work for an AP schedd.
2. Nodes in the spliced DAG are renamed to `<Splice Node Name>+<Node Name>` so node `A` in Splice `X` would be `X+A`
3. Various node customization options can be applied to nodes in a splice but not a splice as a whole. Including:
    1. Scripts (Pre|Post|Hold)
    2. Retries
    3. VARS
4. All DAG information must be declared in the splice DAG file at submission time of the parent DAG

## Example Using DAG Splice

In this example, we go back to the simple `diamond.dag` example. However,
this time around the middle two nodes (`LEFT` and `RIGHT`) are more complex
DAG workflows that are exactly the same. Both `LEFT` and `RIGHT` are actually
DAGs in the shape of an `X` specified in the `cross.dag` file. If the
`diamond.dag` is submitted without any modifications then it should be observed
that the DAG only creates the DAGMan files for `diamond.dag` and that twelve
jobs run rather than the usual four in a diamond DAG.

[DAGMan Splicing Documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-using-other-dags.html#dag-splicing)

