# Assessment fields and verification rules

## Unit of assessment

The work item freezes all baseline model/result-set pairs. A model without a
tabulated result set has one assessment with result_set_id=null. Cross-fit means
or distributions remain the supplied fit family; do not invent individual fits.
Include the transitive supporting-model closure and every model in a shared
estimation_group_id. Do not add robustness models.

Every variable in that closure needs one variable_coverage entry, using its local
model_id and variable_id. The construction text explains raw fields and the
formula, transformation or supporting fit. A generated score links to the inputs
needed to estimate it. Use non_data_reason only for an estimated parameter or
constant that is not itself an observed input. An undefined observed variable
needs an unresolved requirement, not a non-data exemption.

Keep frozen variable IDs when an inherited definition conflicts with the paper.
Use the original source's construction and record the input conflict as an
implementation issue. Enumerate every raw component of a formula, even when
terms algebraically cancel if their missingness affects the paper's sample.
Check whether a supporting fit is estimated before later baseline sample screens;
its source population can be broader than the reported baseline sample.
In sampling design_coverage, name each supporting/joint model and explicitly
separate its estimation population/screens from the final regression or draw
frame. Read footnotes attached to the fit/sample description. Verify a claimed screen order from an explicit source statement; do not derive it from paragraph order. If the relevant page or footnote is clipped in the reading JSON, inspect the whole physical PDF page before writing sampling.reason. Explain the earlier fit population separately for each required supporting model; an unknown order remains unknown. A final sample N
or minimum-history screen must not silently restrict an earlier fit. If the
earlier population is unspecified, retain that uncertainty rather than copying
the final sample definition. Raw requirements must cover the earlier universe.

Complete design_coverage for sampling, identifiers, fixed_effects, clusters,
weights, estimation and preprocessing. Requirements can be shared between
variables/aspects/fits, but their coverage must support every referencing fit.
The baseline sample period does not include required lags, leads, rolling
estimation windows or benchmark universes; explicitly extend raw requirements.
Unknown sample linkage or a hidden raw input must remain unresolved. Compose the sample offset, supporting-fit lookback and within-fit predictor lags; do not stop at the start of the support-fit window. The window command sums source-supported month offsets and returns a conservative year envelope while preserving unknown endpoints. State the arithmetic in required_coverage.detail.

A letter-posting interval, filing interval, auditor-change interval and fiscal-year interval need not coincide. Use the date that actually anchors each input. Unknown event dates or comparison universes cannot be covered by assuming they equal a nearby reported period or sample.

## Mandatory inputs and alternative routes

Each requirements entry is mandatory for at least one fit. Its routes are
alternative ways to obtain the **same required input**. A partial substitute
cannot count as a complete route. Separate input bundles when their access or
coverage differs. If the paper compares two databases or resolves their disagreements,
each comparison source is mandatory; neither is a complete alternative to the other.
Separate an unknown ranking/benchmark universe from the known sample-firm inputs. The route's field list contains actual catalog/live column
names, while variable construction text maps those fields to paper definitions.
Do not map historical Compustat item numbers by numeric/name resemblance.

Keep original definitions, population, timing, adjusted/unadjusted products,
observation frequency and identifier-link validity dates. Daily prices are not
intraday transactions. Current director records do not establish historical
boards. Vendor coverage generally does not establish the coverage of a local
snapshot. Different physical copies or library aliases are not independent
sources. Use current vintages and flag their differences without changing the
original study period.

Public raw/standard sources can replace a commercial delivery route when the
same necessary information can be independently reconstructed. Preserve the
reconstruction work and coverage evidence. Analysis datasets prepared by the target paper’s authors
belong in author_alternatives and cannot satisfy a mandatory primary requirement.
Cited third-party public reference indices are allowed standard inputs once their
source and definition are independently verified; the target article’s copied table
is an alternative when the original reference source has not been verified.
Author code is not evidence that raw inputs are available.

## Evidence

Use short evidence records linked by evidence_id:

- paper: literal assigned reading_json path, one-based physical page, and exact
  source quotation. Read the original passage when an extraction is ambiguous.
- catalog: qualified dataset or catalog line location, field labels and a useful
  description. Catalog metadata supports discovery, not live verification.
- probe: workspace JSON artifact path and its SHA-256 from the helper.
- public: official URL, access timestamp, and a short supporting quote/description
  showing relevant access/coverage. Keep direct quotations within 25 words per
  external page. A stale cited URL without verification is not a checked route.
- coverage_confirmation/access_confirmation: coordinator-supplied JSON artifacts
  explicitly whitelisted and hashed in the frozen work item. Workers must not
  create, alter or self-approve confirmations.

Evidence must support the claim attached to it. A source landing page can prove
the provider exists, but not that a historical field is available for the required
population. Paper assertions about authors' access do not prove our entitlement.
Public-access statements must distinguish a raw archive from derived author data.
Check record-type-specific access and release policies: a provider's generic
archive start year can predate the requested material's public availability.

A file-directory probe with status=ok, is_directory=true and readable=false
establishes that the directory exists. Its contents were not tested; this is not
evidence of unreadable files or denied access. A reader timeout does not supersede
a successful exact-resource probe for the same requested columns.

## Verification dimensions and statuses

Each route records access, fields, mapping, coverage and identifiers separately.
fields means live column presence; mapping means semantic correspondence to the
paper, including units, direction, product/version, and code meanings. A header
probe can verify fields without verifying mapping. Reuse existing matching probes
in the shared index rather than discarding known access evidence. Never lower a
supported field/access claim merely to bypass a missing evidence link; attach its
actual probe and keep genuine semantic or coverage uncertainty in its own dimension. Set a
dimension to unverified when its evidence is insufficient. not_applicable is
allowed for fields of unstructured records and for identifiers when no external
link is needed; explain why in mapping_notes. Do not use it to skip actual fields
of a SAS/PostgreSQL table.

A complete route requires verified mapping as well as access/fields/coverage/identifiers.
A verified coverage claim needs bounded required calendar years and a specified
population. If actual event years or the benchmark universe are unknown, preserve
that gap rather than declaring a public archive complete for it.

For local access/fields marked verified, include a successful probe of that exact
resource and every claimed field. A readable directory alone is insufficient.
Local coverage=verified additionally requires a frozen coordinator confirmation
whose location, period, population and frequency support the requirement.
Sampled dates, file modification times, declared row counts and vendor-wide
documentation do not establish complete local coverage. A bounded probe's
rows_read is the slice size, never the table's total observations.

A coordinator coverage confirmation has kind=coverage_confirmation,
verification=verified, location, a nonempty basis, and coverage containing begin,
end, years, population and frequency. It must be backed by reviewed coverage
evidence, not inferred from file existence. An access confirmation has
kind=access_confirmation, verification=blocked, requirement_id and a documented
basis for the current access barrier and absence of an allowed route.

The helper calculates requirement status:

- local_ready: at least one complete verified local route.
- public_acquisition_required: no complete local route but a verified public route.
- access_blocked: no complete route and a frozen confirmation of a mandatory
  barrier. Missing catalog entries, local timeouts or permissions alone cannot
  establish this status.
- undetermined: anything else, with a specific unresolved_reason.

For a fit, a confirmed mandatory blocker dominates; otherwise unresolved inputs
dominate; otherwise any required public acquisition dominates; otherwise all
inputs are local. A model containing multiple fits keeps their separate outcomes.
Paper summaries distinguish all feasible fits, some feasible fits and none
confirmed feasible. Unknown fits remain in the denominator.

For an entirely synthetic fit, set data_mode=synthetic_only, give a specific
data_mode_reason and original-paper data_mode_evidence_ids, and use an empty
requirement_ids list. Its entire supporting/joint estimation closure must also
use generated inputs. Each variable still needs a source-supported construction
and non_data_reason; complete all seven design aspects and the temporal audit.
Do not invent an observed-data requirement for a random seed, estimator choice,
error variance or simulation parameter. Python assigns
no_observed_data_required. Any empirical calibration, benchmark or other observed
input instead requires data_mode=observed and ordinary requirements. A paper
with no baseline regression remains not_applicable, a distinct case.
Judge this per frozen fit, not by labeling the whole paper: later empirical
applications can exist outside the assigned model inventory. Flag a consequential
upstream omission in review_notes without silently expanding the frozen scopes.
Unreported DGP parameters that affect the target results remain blocking
specification issues; a freely chosen random seed need not be blocking. Do not
assume scale/parameter invariance without a source-supported justification.

implementation_issues describe unresolved specifications, ordinary construction,
manual coding, linkage and data-vintage differences. Mark unresolved essential
definitions/estimators as blocking; routine construction work need not be blocking.
Before asserting an essential detail is absent, search relevant terms throughout
the assigned reading and follow its appendix/table-note/footnote cross-references.
A derivation can specify the estimator or inference rule even when the main
methods paragraph does not repeat it. Inspect the PDF if extracted text omits a
needed sign, equation or line. Describe the locations checked in an unresolved
specification issue. Keep a detail not yet located distinct from a source that
actually leaves the design unspecified.
attempt_ready is true only when all inputs are local (or no observed inputs are
required) and no implementation issue is marked blocking. Explicit calendar
indicators use existing date inputs; uncertain estimation choices belong here,
not in invented dataset requirements. It means ready to attempt reconstruction, not completed data
engineering or reproduced results. Never use reported coefficients to tune maps.

## Probe requests and bounds

The probe command reads one JSON request. A SAS reader runs directly in the sole
bounded child process, so its timeout also terminates its actual reader. All probes have a 15-second outer time
limit, at most 1,000 returned rows, and no recursive directory discovery. Failures
are recorded as unverified, with their actual error. Optional timeout_seconds
can reduce the bound; optional row_limit defaults to one.

For kind=sas, specify dataset (qualified catalog name) and fields (actual column
names). Optional row_offset is bounded at 1,000; date_fields records sampled
numeric ranges plus SAS formats without asserting coverage. Use row_limit rather
than metadataonly reads of huge files. Only exact catalog paths under the approved
/storage/sas/base root are supported.

For kind=postgres, specify database (wrds or data_store_api). Omit table to obtain
bounded table metadata. For a table probe, specify schema, table and fields;
optional filters contain field, op (eq/ge/le) and value. Identifiers are quoted,
values parameterized, and the transaction is read-only with a five-second
statement timeout. No arbitrary SQL is accepted.

For kind=files, specify resource_id (sec_raw, sec_parsed, lm10x) and optionally an
exact relative_path. Directory probes establish existence only. Exact file
probes read at most a 256-byte prefix and record its hash, not document contents.
No globs, recursive scans or paths outside the documented resource are allowed.
NDACAN is inventoried but is outside this campaign's authorized external checks.

## Window arithmetic

The window subcommand accepts optional --begin/--end anchor years and repeatable
--lookback-months/--lead-months nonnegative offsets. Add each nested construction
offset separately. It rounds the total outward to calendar-year bounds; it cannot
infer source timing, resolve whether a lag applies before or after scaling, or turn
an unknown event endpoint into a known date. Read the source before choosing offsets.

## Campaign and output

The coordinator uses prepare to freeze work items and a copy of the skill for
each round. Limits are seven pilot rounds and one full sweep. A full sweep
requires an accepted, published pilot using the same skill version. A failed
round still consumes its slot; format/evidence corrections within that round
do not create a new independent pilot. Preserve drafts and final outputs.

Workers write only their assigned drafts, probe requests/artifacts and assessment.
Use template to obtain the output header, then fill the schema and run finalize.
Computed statuses/provenance are filled by Python; substantive unsupported claims
cause errors. validate checks a finalized result without writing.

publish verifies original input hashes and every assigned paper, and exports
ordered assessments.jsonl, summary.json and summary.csv in the run directory.
Papers without baseline regressions remain present as not_applicable. Unknown cases remain
present with reasons. Publication never rewrites source model/sample extractions.

The coordinator can supply prepare --confirmations INDEX.json. The index is keyed
by inventory paper_id; each value has coverage_confirmations and/or
access_confirmations arrays of {path, sha256}. Paths resolve from the project
root and confirmation artifacts must be stored inside that project. The helper validates artifact types, hashes and required fields before
charging a round, then freezes selected references into work items. A coordinator
must review the underlying evidence before creating these artifacts. Omitting
the option supplies no confirmations and never infers coverage or access denial.

Published earlier rounds retain their frozen schema and helper snapshots. Replay
them from the project root with scripts/validate_feasibility_run.py --run RUN;
the wrapper sets the project root correctly for archived relative evidence paths.
The current helper validates schema 1.2. A recorded schema conversion is a
coordinator review of existing outputs, not another independent Luna sweep;
preserve the original aggregate, work items, review decisions and converter hashes.
