# Run the selected author analysis

From the repository root, restore the inputs from your checked author archive and verify the prepared working files.

```sh
python3 scripts/materialize_execution_inputs.py --package-id jar-a244ca32a401
python3 scripts/materialize_execution_inputs.py --package-id jar-a244ca32a401 --check
```

The stages, working directories, inputs, dependencies and historical scope gaps are in [local_inputs.json](local_inputs.json). Use the reviewed execution runner described in the [project guide](../../../../README.md).
