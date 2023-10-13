# OSG Introduction to DAGMan tutorial

This repository is filled with examples of introductory level features for
DAGMan. DAGMan is a software provided by the HTCondor Software Suite to help
users automate workflows in a high throughput computing environment. For a
complete desctiption on DAGMan visit the [HTCondor DAGMan documentation](https://htcondor.readthedocs.io/en/latest/automated-workflows/dagman-introduction.html)

## Tutorial Flow

The following order of tutorial examples to cover various topics related
to DAGMan is recommended:

1. DiamondDag - Basic Example of creating a DAG workflow
2. RescueDag - Example for DAGs that don't exit successfully
3. PreScript - Example using a pre-script for a node
4. PostScript - Eample using a post-script for a node
5. Retry - Example for retrying a failed node
6. VARS - Example of reusing a single submit file for multiple nodes with differing variables
7. SubDAG (Intermediate) - Example using a subdag
8. Splice (Intermediate) - Example of using DAG splices

For a better breakdown of individual examples checkout the README in the
given examples sub-directory. Links to the documentation in regards to
specific DAGMan feature will also be available in the given examples
README.

