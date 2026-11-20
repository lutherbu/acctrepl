# Assessment and proposal rules

Assess the supplied author-package variant, not an independently rebuilt model.
Use the frozen work item and its output header. Full pipeline is mandatory;
analysis-only is a separate scope when the authors supply usable inputs and code
for that route. A complete analysis-only route cannot make full pipeline ready.
Do not add this scope merely because an analysis entry script or partial/raw data
are present. A hypothetical bypass with no supported compatible route to necessary
analysis inputs, or requiring undocumented reconstruction, belongs in full-pipeline
actions until supported. A verified route to compatible author-prepared analysis
data may still need downloading; treat that as acquisition preparation.
Do not apply our SAS–Stata architecture or notebook template to author programs.

## Establish the scope

Read the datasheet/README and entry scripts, then follow their required inputs,
includes and generated intermediates. Use the dependency checklist as discovery
evidence, not as a complete parser or an unquestionable finding. Review every
checklist item as a mandatory requirement, a generated intermediate, an optional
input, a software dependency, or an issue. Generated/optional classifications
need evidence; unresolved macros and unknown directory changes stay unresolved.
Record author-defined alternative branches explicitly. Do not silently select
only the easiest script or remove a required preprocessing/supporting stage.
Map the outputs named in author instructions or code headers to their required
entry/supporting scripts. Independently supplied companion analyses may not be
called by the apparent main script; retain them and their data/order requirements.
Optionality is relative to the assessed branch. Retain the required stages and
inputs for every branch included in the target scope, even when the authors allow
a different workflow to omit that branch. Keep unselected alternatives distinct
from the full target and its patch proposal.
The work item's `related_packages` lists other already-imported archives in the
same paper directory. Check these discovery candidates when an author references
an original release. Do not merge variants or assume compatibility; inspect and
retain evidence before crediting a route. If uninspected, name the existing local
candidate rather than implying it must first be downloaded or requested.

A dependency review uses either `dependency_id` or a nonempty unique
`dependency_ids` list. Group only edges sharing the supported disposition, scopes,
targets and evidence; name every covered frozen ID. This is useful for repeated
stages but does not establish their producers or completeness. Unknown producers
remain linked unresolved issues with actions. Uncovered and invented IDs are
rejected by the finalizer.

Author-prepared datasets are valid primary inputs here. For data-only releases, distinguish readable supplied material from an unknown executable workflow. Descriptions of how the authors historically collected a supplied dataset do not make those original sources mandatory live execution dependencies. Do not reconstruct that dataset independently; request missing code/input specifications and preserve the workflow uncertainty. Distinguish full data
from identifier lists, synthetic demonstrations, snippet extracts, and pilot
samples. Inspect expected fields and formatting against the code. A packaged
file name alone is insufficient; use the helper's bounded metadata/readability
probe. A sampled date range does not establish complete historical coverage.
When the exact author input is present, assess compatibility with that input;
independent rederivation of all paper variables is not required.
For a documented exact author input with matching format and required fields,
the absence of a full-data sweep alone is a probe limitation and future validation
task, not a new prerequisite for author confirmation of completeness. Keep concrete
field, type, period or construction gaps unresolved when evidence supports them.

For manual or GUI stages included in the chosen scope, account for their lookup
or crosswalk inputs and spreadsheet/statistical software, not just code-file
reads. A supported prepared-input route may bypass those stages; state that
bypass rather than claiming the raw-construction branch is closed.

Inspect explicit author URLs for data/code and record candidate prepared-input
routes before defaulting to raw-source rebuilding. A landing page or request form
supports only its stated access/product information; unknown delivery, fields or
coverage remain unverified. Do not submit forms or acquire data during this audit.

## Evidence

The work item `resource_catalog_sha256` identifies the catalog JSON file. Legacy resource probes use `catalog_sha256` for the underlying PROC CONTENTS text, whose hash is stored inside that JSON. These are different artifacts; compare each hash with its matching artifact, not with the other hash.

Search documented source products as well as author-specific filenames. A missing
prepared-file alias does not exclude catalogued raw candidates; record those
candidates without claiming live access or compatible construction.

Every evidence record has an ID, kind, and description. IDs are unique across
all record types. Keep quotes short and source locations exact.
Probe `status` and `result` fields belong inside the hashed JSON artifact, not
directly on the assessment evidence record; evidence objects use only the schema's
listed fields.

- `source`: `file`, one-based `line_begin`/`line_end`, and a matching `quote` from
  the cached text in the work item. Add `cell_id` for notebook evidence when known.
  Source SHA and cached-text SHA are checked separately when they differ.
- `probe`: `artifact_path` and `sha256` for a helper-generated JSON result. Successful
  data probes have `status: "ok"`, `result.readable: true`, matching `result.location`,
  and the claimed columns. A failed probe does not prove no data or no license.
  `rows_read` is the sample size of the probe. A `catalog_observations` value is a
  full file count only when `observation_count_scope` says `file_metadata` (or the
  format provides explicit file metadata); older readstat one-row probes reported
  the sampled count there. Neither count establishes population/history fidelity.
  For SAS metadata/readability checks, use the frozen one-row helper or an equally
  bounded `row_limit=1` read. `read_sas7bdat(metadataonly=True)` can traverse the
  whole file; it is not a proven bounded header inspection. Keep the whole-file
  SAS count unknown unless a bounded header method is established. Preserve the
  original artifact and qualify its method if an earlier check used that reader.
- `inspection`: an artifact path/hash for an inventory or other bounded inspection,
  or the same file/line/quote fields as source evidence. Probe/inspection artifact files must be JSON; refer to raw logs from a JSON probe record with their paths and hashes. An inventory proves only
  what it actually inventories; it cannot establish historical data coverage.
- `catalog`: metadata/discovery evidence only; it cannot verify live access.
- `public`: an authoritative `url`, ISO `checked_at`, short supporting `quote`, and
  `authority` of `official`, `author`, or `repository`. Verify the needed product,
  period, access conditions and file/interface against the source; a generic
  vendor landing page is not enough. Free registration is a preparation task.

For a restricted route with `status: "blocked"`, cite source/public evidence
whose `access_barrier` is true and whose actual quotation describes that barrier.
Do not infer an absent license from a catalog miss or a generic commercial label.
A restriction on one delivery method does not establish a barrier for every route to the required information. In particular, bulk-export/NDA, no-scraping, or redistribution conditions do not by themselves rule out the authors' documented permitted public/manual method. Record an unverified alternative and its unresolved access/coverage conditions when appropriate; never propose bypassing restrictions. Locally accessible commercial sources can be usable local routes. Keep the source
access property distinct from whether the particular needed input is available.

Successful software evidence uses a helper probe with `status: "ok"` and either
`result: {location: "software:<name>", available: true, ...}` or a
`result.software` mapping keyed by the exact software name. Set `software.name`
to that exact key or location suffix; put versions and descriptive prefixes in
`description`. Author instructions
prove what is required, not what is installed. Record unavailable free packages
as preparation, explicit incompatibility/access barriers as blocked, and untested
availability as unverified. Do not install anything during assessment.
An unspecified author release alone is a version-verification limit, not evidence
that the available runtime cannot run the code; retain actual incompatibilities separately.
Check extension functions and required helper packages invoked through built-in
wrappers as well as standalone commands; the wrapper's presence does not establish
availability of its invoked extension.
Probe the actual command/function entry point rather than only its distribution
name. For example, `egen ... = nvals()` invokes `_gnvals`; `which egenmore`
can fail even when that function is installed. A missing distribution-name lookup
alone does not justify an installation requirement.
Installed libraries do not establish availability of required model weights,
tokenizers, scalers, dictionaries or configuration/index artifacts. Trace their
packaged, generated or acquisition routes separately. A training fit does not
prove that the deployment artifact is serialized in the expected format/path.

## Schema records and aggregation

Fill reusable mandatory data `requirements` with scope membership and alternative
`routes`. List software separately and link both from each scope. Every issue has
scope IDs and severity: `preparation`, `blocking`, or `unresolved`. Non-runnable
packages need an explicit missing-code issue. Incomplete dependency closure needs
an unresolved issue. Scripts in unsupported languages are code, not no-code;
record the language/runtime/parser limitation as an issue.

The shared [classification contract](../../check-replication-feasibility/references/feasibility_classification.schema.json) defines the data-by-code matrix and the three Ready routes. The finalizer classifies each scope, then publishes the analysis-only scope when present or the full pipeline otherwise. Retain all underlying data and code observations for review.

Python computes each native requirement outcome:

1. A verified packaged/local route gives `local_available`.
2. Otherwise a verified public route gives `public_acquisition_required`.
3. If all considered routes are blocked and a restricted route has explicit
   barrier evidence, use `restricted_access_required`.
4. Otherwise use `undetermined`.

Alternatives are delivery routes for the same input. Inputs jointly needed for a
merge, benchmark, check, or construction are separate requirements. One usable
alternative wins over unknown unused alternatives; it does not satisfy another
mandatory input. A verified local route needs a matching readable probe and all
`expected_fields`. The agent remains responsible for evidence of period, product,
units, identifiers and construction compatibility; leave the route unverified if
those are unresolved. `expected_period` records the author requirement, not a
claim that sampled rows prove it.
Do not override uncertain route availability by restating the same uncertainty as
a blocking issue; a confirmed blocker needs its own supported barrier or failure.

Route verification concerns availability of compatible underlying inputs, not
completion of their download or cleaning. Supported field mappings, format
conversion and other specified construction can remain preparation actions.
Do not demand the original author's byte-identical file when the documented
compatible source and transformation suffice. Unverified history, required fields
or an unknown author construction still prevent a verified route.
For a verified local route, `expected_fields` names columns in the probed
underlying source, before conversion. Describe the mapping to final analysis
variables in the route and preparation action, rather than listing nonexistent
post-conversion columns as if they were already present.

Within a scope, a confirmed mandatory access barrier dominates, then unresolved
inputs, then public acquisition, otherwise local availability. A scope requiring
no observed data uses `not_applicable`; do not use that value to skip unknown data.
`data_required` describes what the target needs, not whether data are supplied or
whether concrete requirements have been identified. Empirical targets keep it
true even in PDF-only releases. If their exact inputs are unknown, use a generic
unresolved input requirement or an explicit unresolved data issue; do not derive
this flag from the length of `requirement_ids`.
Assess code presence from content, including substantial preparation/analysis
programs embedded in documents or text. Extraction, undefined setup and incomplete
branches are separate readiness gaps; a standalone script extension is not
required. Several explicitly used variable-construction blocks can constitute
substantive partial preparation code even without imports or a cohesive driver;
credit that code and record the missing driver separately. Isolated illustrative
snippets alone need not establish a supplied program.
Stored formulas and PivotTable definitions that implement the study's computations
are supplied partial program code. No standalone command-line file is required.
For XLSX sources, use the frozen static inspection's original workbook hash and
sheet/cell/pivot locations. It contains formula text and pivot/source-range
definitions only, without evaluation, cached cell values, shared items or
pivot-cache row records. Data-only workbooks do not automatically become code;
partial/failed inspection cannot establish absence. Record required workbook
inputs, engine/version, source ranges, external links and manual refresh steps,
with unresolved coverage or compatibility explicit. Never launch Office or
LibreOffice, recalculate formulas, refresh pivots, execute macros or dereference
external links for this audit. The original workbook is the entry point. Its
binary ZIP bytes cannot receive cached-text line edits: proposed cell changes
belong in preparation steps anchored to the workbook hash and cell/range.

Execution readiness is separate: no supplied code → `no_runnable_code`; confirmed
code/data/software blockers → `blocked`; unresolved closure or compatibility →
`undetermined`; known acquisition/setup/edits → `preparation_required`; otherwise
`ready_to_attempt`. No outcome establishes a successful execution.

Do not fill computed fields in a draft. If they are supplied, unsupported claims
are rejected. Every finalized scope has `execution_verified: false`.

## Concrete patch proposals

Every nonlocal/unknown data requirement, unavailable/unverified software dependency,
and recorded issue must have an action addressing its ID in every affected scope.
Actions may be shared by scopes. Cite evidence, give concrete steps or exact source
edits, and specify checks to perform later. Use `clarification` or `access_request`
when the correct change cannot yet be specified. No missing access is repaired by
fabricating data or bypassing restrictions.

A source edit needs the frozen file hash, one-based line range, exact current
`before` text, proposed `after` text, and a reason. Notebook edits additionally need
`cell_id` and may not cross cells. These are proposal fragments, not an executable
patch. Never edit a binary PDF/DOCX using text line numbers. If a source location or
replacement value is unknown, propose the prerequisite/clarification, not guessed
code. Check proposed edits as a coherent whole: a renamed path must remain consistent across all affected producing and consuming calls. Verify this from text without applying or executing the author code. Preserve observations, variable definitions, samples, estimators, and analyses. Respect language and import semantics before diagnosing a defect. Stata variable-name prefixes can be valid unique abbreviations unless disabled or ambiguous. An uninitialized local does not by itself establish missing setup; assess its expansion and whether the resulting statement is a valid no-op. Spreadsheet headers are not necessarily imported variable names: Stata can use Excel column letters for blank/invalid names, while other readers may normalize or deduplicate headers. Inspect column positions and the prescribed import options before proposing a missing-variable repair; raw metadata headers alone are insufficient. A repeated regressor alone does not establish which omitted category the authors intended. Keep genuinely unresolved specification questions conditional.

For SAS, trace actual block-comment boundaries and macro processing before
declaring a producer inactive. Asterisk statement comments (`*...;`) can still
allow macro processing; inspect the macro definition and emitted statements. If
that definition is unavailable, keep expansion/output dependencies unresolved
rather than assuming the call is disabled. See the official
[SAS comment reference](https://support.sas.com/documentation/cdl/en/lestmtsref/63323/HTML/default/n1v51exifva71an1cvfn2z6j26lo.htm).

Do not drop stages, substitute dummy data, or change the design merely to run.

The finalizer renders `patch_proposal.md` from the structured actions and records
its hash in `assessment.json`. It includes targets and source hashes, readiness
by scope, proposed changes and prerequisites, future validation, and unresolved
issues. The document is produced even for blocked, no-code, and no-change cases.
For no changes, state the entry points and the remaining verification limits.

Neither the skill nor the finalizer applies edits, generates `.patch` files,
downloads data, installs packages, or executes author code. Validation commands
in a proposal are instructions for a future authorized execution step only.
