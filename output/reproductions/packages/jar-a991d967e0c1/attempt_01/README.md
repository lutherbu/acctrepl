# Chen, Jermias, and Panggabean (2016) reproduction

This build reconstructs the primary mean-split chi-square tests, the repeated-measures ANCOVA, and the separately reported median-split appendix checks from the supplied author-prepared participant workbook.

## Replay inputs and commands

The SAS program expects the workbook at `input/chen-et-al-dataset.xlsx` relative to a private working copy of this reproduction. Set `REPO_ROOT` to a checkout root and `WORKDIR` to a new private working directory. Copy the published reproduction files and source workbook into that directory, then verify the workbook SHA-256 is `b5906d63d71121c2bcf39dcaa73ae577f87b834314d4435178bd5b81de7d87f0`. Keep the published source package intact. The code also expects writable `data/`, `logs/`, `tables/`, and `sas_work/` directories.

From a shell, set the checkout and private working-copy paths, stage the reproduction files and workbook, and run SAS 9.4 and Stata 18 from the environment where their executables are on `PATH`:

```bash
REPO_ROOT=$(pwd)   # run from the checkout root
WORKDIR=$(mktemp -d)
mkdir -p "$WORKDIR"/{input,data,logs,tables,sas_work}
cp "$REPO_ROOT/output/reproductions/packages/jar-a991d967e0c1/attempt_01/"{build.sas,stata_run.do,stata.ipynb,README.md,design.md,result.json} "$WORKDIR/"
cp "$REPO_ROOT/papers/packages/JAR-Volume 54/Issue 1/12102 - The-Role-of-Visual-Attention-in-the-Managerial-Judgment-of-Balanced-Scorecard-Performance-Evaluation-Insights/chen-et-al-dataset.xlsx" "$WORKDIR/input/chen-et-al-dataset.xlsx"
cd "$WORKDIR"
sha256sum input/chen-et-al-dataset.xlsx
sas_u8 -nodms -work sas_work -log logs/build_sas.log -print logs/build_sas.lst -sysin build.sas
stata -bq do stata_run.do
```

`stata.ipynb` contains the same analysis in three self-contained Stata cells. Each cell loads `data/reg.dta` and writes aggregate test results to `tables/`. The `.dta`, workbook copy, and native logs are working artifacts only. Do not add them to the review publication allowlist.

## Reproduction files

- `build.sas`: import the workbook, retain the fields required by the source procedures, run aggregate sample checks, and export the private Stata input.
- `stata.ipynb`: Stata 18 analysis following the local notebook template.
- `stata_run.do`: same Stata code in a batch form for native execution.
- `design.md`: source-based model, data, mapping, and unresolved-assumption record.

The result tables in `tables/` contain only aggregates. No participant-level workbook rows or original subject codes are included in them.
