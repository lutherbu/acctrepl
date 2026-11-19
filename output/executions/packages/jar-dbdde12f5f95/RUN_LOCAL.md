# Run the selected author analysis

From the repository root, restore the inputs from your checked author archive and verify the prepared working files.

```sh
python3 scripts/materialize_execution_inputs.py --package-id jar-dbdde12f5f95
python3 scripts/materialize_execution_inputs.py --package-id jar-dbdde12f5f95 --check
```

The stages, working directories, inputs, dependencies and historical scope gaps are in [local_inputs.json](local_inputs.json). Use the reviewed execution runner described in the [project guide](../../../../README.md).
