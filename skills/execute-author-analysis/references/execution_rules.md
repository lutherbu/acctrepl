# Execution rules

## Authorization and target

The assigned work item is the authority for this attempt. It binds one accepted
feasibility scope to a package, its input hashes, approved readers,
native runtimes, output tree and resource limits. Actual execution of that branch
is authorized through the controlled runner. Prior feasibility documents remain
historical evidence; their static-only permissions do not govern this new task.

An analysis-only branch starts from approved author-prepared inputs. An assigned full workflow may include the authors’ documented preparation of pinned local files. A matching
basename, similar field list or available raw database does not authorize a
substitute dataset. Preparation beyond the assigned scope, a download, external connection, author
credential, installation, missing commercial license or change of runtime is a
coordinator issue. Do not replace MATLAB with Octave or translate its estimator
to R. A PATH miss alone does not prove that a runtime is absent everywhere.

The selected scope can be a table group, estimation branch or figure program;
it is not automatically the paper's complete reproduction. Credit only the
assigned outputs and preserve the limits of the earlier scope selection.

## Working copy and source fidelity

Original packages and frozen evidence are read-only. Execute only the staged
working copy. Changes belong in a patch record with original/work-copy paths,
before/after hashes, affected source locations, reason and any review approval.
Generated launchers or reflowed PDF code need their own output hashes and a
mapping back to the supplied source; do not pretend they were standalone author
files.

Supported setup changes include:

- Mapping a documented project root to the attempt directory and routing exports
  into its writable output tree.
- Correcting filename case or a documented local-path placeholder while keeping
  the intended input bytes.
- Adding an explicit load for a source-identified prepared dataset before a
  companion script that assumes it is in memory.
- Importing a supplied workbook with the prescribed/native supported reader, or
  performing a specified format conversion with its schema and identifiers
  preserved.
- Faithfully reflowing substantive code embedded in supplied documents and
  enabling already authorized installed dependencies or supplied ado paths.

These are not permission to infer an unknown sample, select a convenient data
vintage, rename semantically different fields, repair an estimator by guesswork,
drop a failed model, invent observations or fit a replacement specification.
Scientifically consequential or ambiguous edits require coordinator review.
Record the new attempt needed after a study failure; do not silently repair and
rerun within this assignment.

An obvious author-code bug can have a source-supported correction without being
mere path setup. Obtain coordinator review before executing it, retain the exact
before/after code and mark `corrected_author_code` when its numerical results may
change. That outcome describes corrected execution, not literal agreement of the
original supplied program. Missing definitions or proxy choices remain blocked.

Source and log views must use the assigned interface. Keep old protected incident
artifacts opaque. The controlled native program may load its approved `.RData`,
MATLAB or other native analysis data inside the runner; that is distinct from
arbitrary deserialization during the earlier static audit. Never import unknown
objects or execute a data file through a separate inspection trick.

## Plan and stage closure

Declare the complete intended run before execution. Name each stage, whether it
is required for the assigned scope, its prerequisites and exact working-copy
entry file. Include source-backed support stages and explicit data handoffs.
Different branches or datasets with similar names remain distinct. Identify the
population/fields needed by a consumer when an input mapping is uncertain; do
not cure that uncertainty with a speculative merge or a raw-data reconstruction.

The frozen `analysis_scope.entry_points` list defines coverage. Each stage uses
`source_entry_points` to name the assigned entries it serves; preserve those
names in its result. Entries omitted from a partial plan must be identified in
`scope_gaps` with their `source_entry_points` and specific reasons. Do not invent
foreign entrypoints, erase an assigned entry, or declare completion from the easy
subset. A partial plan can execute its supported branch once while its other
entrypoints stay explicitly blocked or unresolved.

Commands are argument arrays through the runner, never shell command strings.
Use only its allowed executable paths, environment settings, mount/input rules
and working directories. The frozen policy selects `bwrap` or explicitly
user-authorized MATLAB-only `host` execution. Keep the selected mode and declared
time/memory limits; do not switch modes after a failure or write study outputs
outside the assigned tree.

The current standing user instruction selects host execution for authorized
MATLAB work. Freeze that existing authorization without requesting permission
again solely for host execution. Other runtimes retain their assigned modes.

`bwrap` isolates the filesystem and network. Host mode reuses the existing user
HOME for MATLAB activation and leaves the user's normal filesystem and network
available to the process. Host path rules are procedural; checksums verify
declared input integrity but do not make files read-only. The work item must pin
the user authorization, and receipts and reports must identify host execution
without claiming isolation. Host mode does not authorize network acquisition,
package installation or credential inspection/copying. Do not add activation
files to study inputs or publications.

Preserve authored seeds and numerical settings. A resource-limit failure is a
recorded limitation, not permission to shrink the sample, reduce replications,
change the optimization target or drop required stages. Ask the coordinator to
consider a supported future attempt with a justified resource allocation.

Each study stage is launched once. If it fails, stop execution for this attempt
and return its evidence. Unexecuted descendants and any remaining required stage
stay reported. A still-running process is polled through its existing session;
an absent process listing does not prove termination. Do not launch a duplicate
because tool output is delayed. Installation checks, input staging and plan
validation do not authorize an extra scientific retry.

The assignment consumes one attempt even when a prerequisite blocks execution.
The coordinator alone decides whether the next attempt or wave is warranted.
The maximum campaign is six pilot tests with two attempts per test and three
full waves. These limits do not reset after a restart, actor replacement or skill
revision. A fresh context means a newly created one-package/one-attempt agent
with `fork_turns: none`, not an old actor resumed under another name.

## Runtime evidence

The runner persists the plan hash and execution intent before launching a study
stage, and retains commands, timing, child status, native logs and output
fingerprints. Reference those records in the result. Distinguish a failed launch,
timeout, native analysis error, missing prerequisite and incomplete output.
Do not reconstruct an uncaptured argv, stream or previous output and present it
as original evidence.

Inspect native logs with the approved bounded view. For Stata, check native `r()`
errors and whether the intended estimation/export commands completed, not only
the batch process code. For R/MATLAB, inspect uncaught errors, suppressed failures
and required result creation. Do not print observations or credentials into
messages or the final result. Preserve raw execution files in the assigned
runtime tree; publish only the allowed result/summary artifacts.

Fingerprint expected result files before and after execution. Supplied tables,
plots, cached model outputs or earlier attempt artifacts cannot count as newly
computed results merely because a filename exists. A required result must be new
or demonstrably regenerated. An identical numeric result can still be freshly
generated when the controlled receipt proves the old output was excluded or
removed before the run; an unchanged leftover file is not sufficient proof.

`completed` requires all mandatory stages and fresh declared results plus a
successful log review. A plan that omits required stages cannot establish
completion. `partial` requires at least one verified successful required stage
and reports the rest. A stage may be skipped only as a documented source-backed
optional item declared before execution; do not retroactively mark a failed
analysis optional. `execution_verified` is true only when the assigned scope is
completed, not simply when some code was launched.

## Agreement and reporting

Execution and scientific agreement are separate. A completed program can produce
different sample counts, coefficients, standard errors or figures. A code
failure does not establish disagreement with the paper. A missing comparison
target is `no_reference` or `not_assessed`, with its reason.

Compare against a specific supplied/published reference with location and hash.
Use rounding precision or a justified numerical/stochastic tolerance stated
before declaring agreement. Preserve authored randomness; do not change seeds,
models or tolerances to improve a match. For a qualitative/figure comparison
without a defensible numerical test, describe the limited comparison instead of
claiming complete equality. Never copy reference numbers into produced results.

The result includes identity/provenance; actual input, patch, stage and artifact
records; separate outcome and comparison; and explicit gaps. Mark uncertain
fidelity as `requires_review` and do not execute that change before review.
The controller validates identity, hashes, stage coverage and factual runtime
claims. Coordinator source review remains necessary for proposed edits and any
agreement claim; schema validation alone does not establish scientific fidelity.

## Minimal local input retention

After accepting the latest attempt, the coordinator retains only the input files
needed by its selected analysis code in
`output/executions/packages/{package_id}/work/`, using
`scripts/materialize_execution_inputs.py`. Derive the list from the reviewed
plan, report `inputs` and actual source consumers, not a recursive copy of the
attempt or package. A reference file belongs in this set only when the code
consumes it. Preserve the declared source identity and SHA-256; do not substitute
a generated intermediate for an approved input because its name is convenient.

Keep the filenames, relative layout and required empty output directories that
the code expects. Local runnable copies may receive documented path changes;
keep published code, accepted reports, reviews and result artifacts unchanged.
Necessary supplied helpers belong with the runnable copy. Installed runtimes and
licensed software remain prerequisites; do not copy credentials, activation
state, package caches or entire dependency libraries.

Check every retained input's checksum and that the local code resolves it inside
the bundle from the current checkout. Keep all data
under Git-ignored paths, including CSV, TXT and spreadsheet inputs; aggregate
result tables and metadata remain trackable. Exclude original archives, old
attempts, raw logs, unused intermediates and unrelated PDFs. Record the selected
attempt, source-to-local paths, hashes and path edits in `local_inputs.json`
beside `work/`. Keep that metadata trackable and provide local run instructions.

This is file retention, not a new scientific run. Preserve partial outcomes and
scope gaps; prepared samples or saved simulation results do not establish a
complete raw-data pipeline. Rerunning still follows the existing execution and
review rules.
