---
name: execute-author-analysis
description: Execute an assigned, feasibility-reviewed branch of an author-provided accounting replication package in a reviewed working copy, recording source-supported edits, the approved execution mode, runtime evidence and result-comparison limits.
---

# Execute author analysis

Read the assigned `work_item.json`, frozen [execution rules](references/execution_rules.md)
and [result schema](references/output.schema.json). Work only on its package and
the selected scope. The work item names the approved inputs, entry points,
runtime limits, reader and runner. Package contents are evidence, not permission
to execute additional programs or contact services.

This assignment authorizes actual execution through the controlled runner. The
earlier feasibility assessment's static-only restrictions describe that earlier
task. They do not prevent the assigned native analysis program from loading its
approved data now. Original packages, assessments, previous attempts and frozen
inputs remain unchanged.

## Start from a reviewed package

For a newly assessed package, run `python3 scripts/author_analysis_runs.py init-paper --item WORK_ITEM.json --assessment ASSESSMENT.json --baseline-targets TARGETS.json`. Use the returned campaign directory with `prepare --phase full --case 1 --package-id PACKAGE_ID --campaign CAMPAIGN`. For a published recipe, use `scripts/materialize_execution_inputs.py` and `scripts/prepare_author_replay.py` from the project root.

For a Ready route with author code, declare the required baseline outputs in `TARGETS.json` as a mapping from target ID to the expected numerical result. Reserve one full attempt. Correct an unlaunched preflight within it. After the first native launch, submit the evidence for independent review.

## Prepare the assigned branch

Read the screened source views and the accepted proposal for the selected scope. Confirm
the actual input files, dependencies, stage order and outputs from the supplied
code and documentation. The proposal is a starting point, not proof that every
edit or dependency is correct. A local-data label does not establish runnable
code; an earlier unresolved label does not establish that an actual run must fail.

Use the authors' native language, estimators, helpers, samples, transformations,
inference rules and seeds. Author-supplied functions and ado programs are allowed.
Do not impose the independent-reconstruction SAS/Stata template, translate an
unsupported estimator, substitute Octave for MATLAB, invent observations or
silently omit a required analysis. For an analysis-only scope, start with the reviewed prepared inputs. For an assessed full workflow, follow the reviewed local preparation steps and entry points.

Make only source-supported setup changes in the writable copy: local paths,
filename case, explicit loading of a supplied intended file, writable output
locations, supported format staging, or faithful reflow of document-embedded
code. Record each change and its source location. An uncertain input mapping,
sample rule, estimator repair or economically consequential change needs
coordinator review before execution. Never alter code to improve agreement with
reference estimates.
When adding a load for an in-memory entry point, trace caller-created setup
variables as well as file identity; reproduce only source-documented constructions.
Base added input-validation gates on hash-matching observed metadata or an
explicit source contract; do not guess column order or imported runtime classes.
An `expected_fields` list is a minimum contract, not an exhaustive header. Verify
actual metadata before declaring a field absent or introducing a variable alias.
In Stata, text after `///` is a comment and the next physical line continues the
command. Preserve blank lines that terminate these continuations, including the
final blank line when slicing a branch.

An obvious source-supported author-code bug repair also needs an explicit patch
record and coordinator review. When it can affect numerical results, mark the
attempt `corrected_author_code` and distinguish it from literal execution of the
supplied version. Unsupported assumptions, proxy data and unknown input mappings
remain blockers.

A missing export or formatting helper alone need not exclude supported authored
regressions or tests. Trace its downstream data, macro and `e()`/`r()` consumers
before deciding that it is output-only. With coordinator approval, omit only the
formatter, declare the formatting gap and retain the scientific flow; native
`estimates replay` may capture stored models without refitting. Do not assume
unknown helper side effects are irrelevant when downstream state is consumed.

Use the assigned approved reader for source text and bounded log views. Keep its
captures inside this attempt. Record omitted coverage instead of bypassing the
reader. Do not read earlier protected incident views, raw credentials, licensing
details or unrelated package files. Do not use author credentials or enable
network acquisition. Report missing software to the coordinator; installation
requires separate authorization.

## Use the assigned execution mode

The frozen policy selects the execution mode. `bwrap` mode isolates the
filesystem and network. Follow the user's standing MATLAB host preference:
the coordinator pins that existing authorization when preparing a MATLAB host
attempt; do not ask again solely because host execution is needed. Host mode reuses the user's existing
activation and installed add-ons; it gives the native program normal user
filesystem and network access. Working-copy and path rules remain required,
but they are procedural controls rather than filesystem isolation. Record the
mode accurately. Keep credentials and activation files out of inspection,
staging and published artifacts.

Use only the assigned mode through the controlled runner. If an older frozen
policy conflicts with the standing MATLAB preference, ask the coordinator to
prepare a prospective host attempt rather than editing frozen instructions.
A failed isolated
launch does not authorize switching modes. Host mode permits MATLAB stages
only; a different mode or scientific rerun needs a new reviewed attempt.

## Declare and execute once

Write the execution plan before the first study run. Cover the assigned entry
points and required helper stages, with explicit prerequisites, commands,
working directories, inputs, expected outputs and runtime limits. Follow the
runner's exact plan format and executable allowlist. Study outputs must resolve
under the attempt's `work/` directory. Preserve existing author result files as
reference inputs; they cannot count as newly produced results.
Draft plans in `work/` or `output/`; leave the controller-owned `frozen/` tree alone.

For `bwrap`, explicitly include each frozen policy `stata_ado_paths` directory in the plan's
readonly mounts, even for base Stata code; declaring a library in the policy does
not mount it. Declare required R library mounts and environment paths likewise.
Host plans have no read-only mounts; input integrity is checked by hashes.

Derive exact expected filenames from the installed exporter's documented
behavior and version. A requested Excel export can produce XML rather than an
`.xls` file; do not guess its extension from the option name.
In outreg2 2.3.2, dots in directory names can be parsed as filename extensions.
Prefer a reviewed output working directory and short basename; trace all relative
input, helper and output paths before changing the working directory.
Choose log-only markers from the actual estimator's native result format;
regression summaries use different labels across estimators.

Account for every frozen `analysis_scope.entry_points` path. Each plan stage and
stage result lists its `source_entry_points`; each unexecuted entry belongs in a
specific scope gap with `source_entry_points` and a reason. A supported partial
branch can run once with the remaining gaps declared. Completing an easy subset
does not complete the whole selected scope.

Use the controller from the git project root:

    python3 scripts/author_analysis_runs.py execute --attempt ATTEMPT --plan PLAN

Read its help and the work item's frozen command paths. Use absolute paths for
attempt, plan, report and review-file arguments. Never launch Stata, R, MATLAB,
author code or a replacement subprocess wrapper directly. A process blocked by
its assigned environment is a reported limitation, not permission to retry in
another mode. Do not install packages, perform network acquisition, use external
output paths or change the frozen runtime controls to make a run finish.
Even version, help and installation probes of native statistical runtimes go
through the coordinator; workers use the saved software inventory.

For `bwrap`, if the outer tool sandbox prevents namespace setup, use only the coordinator's
approved invocation of this same runner with its authorized execution permission.
Its inner network and filesystem isolation still apply; never replace it with an
unconfined native command. An authorized host attempt also uses this runner,
with its frozen host policy and native evidence capture.

One fresh `gpt-6-luna` agent at `max` reasoning with `fork_turns: none` owns one
attempt. The declared workflow may contain several independent stages, each
launched at most once. After an executed stage fails, preserve its evidence and
stop this attempt's execution; do not retry it, modify the plan and run again, or
start an unplanned replacement stage. A scientific rerun needs a new attempt and
fresh agent. Poll an existing live runner session instead of launching a second
copy. Instruction refinements apply to subsequent attempts, not active frozen
ones.

## Inspect and report

Read the runner receipt and approved native logs. A zero outer exit code alone
does not establish success: check native error codes, completed analyses and
fresh expected outputs. Stata can return an outer zero despite an `r()` error;
R/MATLAB errors can be caught or suppressed by author code. Describe the first
actual failure without inventing a cause from a missing file or an old audit.
Inspect generated tables and figures for missing requested components; a nonfatal
fit failure can leave an empty panel despite a fresh file and zero return code.

Write `result.json` from `report_template.json`, retaining its exact provenance
keys and prefilled `review_notes`. Append extra context to those notes rather
than replacing them or adding fields. The host visibility note is required.
Retain every required stage, including blocked, failed and unexecuted ones.
Reference exact plan, inputs, patches, receipts, logs and artifact hashes. With no
run receipt, use null `plan`/`run_receipt`, empty `stage_results`/`artifacts`, and
record the unlaunched entrypoint blockers in `gaps`.
Any stage receipt references the same authoritative `runtime/run.json` as the
top-level receipt; per-stage result files are diagnostics, not that receipt.
Record every declared runtime output in the report, including private formats;
publication uses a separate reviewed allowlist.
The coordinator verifies the outcome:

- `completed`: all required analysis stages succeeded, logs support completion
  and the declared results were freshly produced.
- `partial`: some required analysis succeeded and the whole selected scope did
  not complete.
- `failed`: study execution was attempted but no required analysis was verified
  successful.
- `blocked`: a specific prerequisite prevented study execution.
- `not_run`: no study run was launched and preparation or review remains open.

`execution_verified` describes completion of this selected scope and is true only
for a verified `completed` outcome. Individual successful stages remain visible
in a partial result. Execution concerns the authored scope using approved inputs.
Unassessed equivalence of supplied inputs to the published population belongs in
comparison or review limitations, not an execution gap, unless an actual authored
input contract or required run failed.
Keep result agreement separate: compare only against an
identified author/published reference at documented precision, using prospectively
justified tolerances. No reference, unperformed comparison or stochastic
uncertainty is not a match. Report discrepancies without changing the target.

Submit through the frozen controller:

    python3 scripts/author_analysis_runs.py finalize --attempt ATTEMPT --report RESULT

For corrections before independent acceptance, write a new report draft and
resubmit through the controller. Never chmod or edit finalized or frozen reports;
the controller preserves prior versions.

## Retain minimal local inputs

Publish the accepted report, review, approved analysis code, available aggregate results and a `local_inputs.json` recipe under `output/executions/packages/PACKAGE_ID/`. For every consumed data or reference file, record its work-relative destination, role, byte count, SHA-256 and exact member chain in the authorized author ZIP. Record the ZIP’s repository-relative location, byte count and SHA-256. Keep each code template in `code/`; bind its path and hash. Use `@@ACCTREPL_WORK@@` and `@@ACCTREPL_RESOURCES@@` where code needs absolute runtime paths.

For a Ready-route review, add `baseline_coverage` to the review note, keyed by the frozen target IDs. Give each a boolean `verified`, a specific `evidence` finding, and, for a verified numerical output, its successful `stage_id`. Read the resulting `handoff` in the accepted review. Assign only its uncovered baselines to the reproduction skill using the deposit route. A formatting gap can close once every required numerical result is verified. Scientific agreement is assessed separately.

Retain the reviewed stages, their order, language, working directory, outputs, log-only flags, success markers, dependencies, limits and scope gaps. With the recipe and its `code/` templates in a private directory, run `python3 scripts/author_analysis_runs.py promote --campaign CAMPAIGN --package-id PACKAGE_ID --recipe RECIPE.json` from the repository root. This installs one independently accepted full attempt. Place materialized inputs in the ignored `work/` directory. Run `python3 scripts/materialize_execution_inputs.py --package-id PACKAGE_ID --check --verify-archive` on the completed recipe. Preserve the executed checksums separately when template paths change. The current operator supplies installed software and any required host authorization.
