# Patch proposal: jar-e330ea5ec622

The Impact of Credit Market Development on Auditor Choice: Evidence from Banking Deregulation

DOI: 10.1111/1475-679X.12519

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied SAS program prepares the author-described firm-year panel, builds and exports both ten-cohort stacked DiD datasets, and the supplied Stata program runs the INDEXP and BIGN regression branches. The package contains only a firm-identifier DTA, not an analysis panel; full-pipeline input and software compatibility remain unresolved.

Entry points: `BDAC SAS program.sas`, `BDAC STATA program.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12519 - The-Impact-of-Credit-Market-Development-on-Auditor-Choice-Evidence-from-Banking-Deregulation/dgzz-datasheet-code-and-identifiers.zip",
      "sha256": "6168021eb2adefbb8c843538329a14c65994ae54f781de9a2cba14e485b842c0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "bc9bd2fe0e138d1d7ede5097b6a698440183c8d29595bc815ee9b884c4915296"
}
```

## Proposed actions

### A_INPUTS: Resolve a compatible source route and author-compatible fields/history for each consumed input while retaining the supplied SAS-to-Stata workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMP, R_AA, R_HIST, R_SEG, R_UNEMP, R_POP, R_IBES, R_SEDOL, R_CUSIP, R_AUDITORK, R_GC, R_RESTATE, I_INPUTS
Evidence: E_DOC_PERIOD, E_DOC_SOURCES, E_SAS_COMP, E_SAS_AA, E_SAS_HIST_READ, E_SAS_HIST_MERGE, E_SAS_SEG_READ, E_SAS_SEG_JOIN, E_SAS_UNEMP, E_SAS_POP, E_SAS_IBES, E_SAS_SEDOL, E_SAS_CUSIP, E_SAS_AUDITOR_READ, E_SAS_AUDITOR_JOIN, E_SAS_GC, E_SAS_RESTATE, E_COMP_FUNDA_CORE, E_COMP_FUNDA_FIN, E_COMP_CUSIP, E_SEG_LOCAL, E_FEED03_LOCAL, E_FEED34_LOCAL, E_CAT_FEED39, E_FEED39_LOCAL, E_IBES_LOCAL, E_SEDOL_LOCAL, E_BLS_LAUS, E_CENSUS_PEP

Preparation / proposed procedure:

1. For Compustat, obtain or construct an author-compatible annual panel for 1988–2010; map the supplied CIK, fiscal year, location and SIC fields, verify every consumed accounting column, and retain the preceding firm-year used by the lag step.
2. Treat FEED03, FEED34 and FEED39 as feed-level Audit Analytics candidates, not as the complete author tables. Obtain or construct compatible audit, going-concern and restatement inputs with the exact supplied company/fiscal-year joins and flag semantics.
3. Obtain the author-prepared historicalstate and auditorkey tables or a documented compatible equivalent keyed by gvkey/year. The datasheet's EDGAR/Compact Disclosure provenance alone does not require raw filing reconstruction.
4. Acquire BLS LAUS monthly state unemployment-rate series for the required years and map state, month and rate to the supplied state/yearmonth/ur join; preserve the author's historical vintage if an available official series supports it.
5. Identify and acquire a compatible Census PEP historical vintage of annual July 1 state population estimates; verify 1989–2010 coverage and map its state key/year/population to the supplied stateid/year/population fields.
6. Confirm that the chosen IBES US EPS summary variant covers the required forecast-period years and supports the supplied ticker/CUSIP/year joins. Confirm historical SEDOL and CUSIP mappings; the probed global and North America Compustat tables are candidates only.
7. Keep each consumed input as a separate requirement. A compatible public, local or author-prepared alternative can satisfy its own input after its field, unit, identifier and coverage mappings are established; do not require reconstruction of unrelated historical source layers as additional inputs.

Validation to perform later:

- After authorized staging, use bounded format-aware metadata checks to verify exact pre-conversion columns, units, keys and date ranges for each selected source; then validate join uniqueness, panel counts and required history in a separately authorized full run.
- Do not infer coverage from one-row samples or catalog counts; keep the analysis period and the Compustat lag year explicit.

### A_PORTABLE_PATHS: Configure one shared writable host-visible root for the SAS inputs/outputs and the two Stata handoffs in an isolated working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PORTABLE_PATH
Evidence: E_SAS_INDEXP_EXPORT, E_SAS_BIGN_EXPORT, E_STATA_INDEXP, E_STATA_BIGN

Preparation / proposed procedure:

1. Choose one relative or [redacted-path-9db5d942fd71] working root visible to both SAS and Stata; configure the SAS bank library there and keep both DTA outputs in that same working directory.
2. Preserve the producer/consumer basenames dataindexp.dta and databign.dta, and keep both Stata use paths consistent with the SAS exports. The supplied names already form coherent producer/consumer pairs; only the host root needs mapping.
3. Check host visibility and writability for the staged source tables and output directory before a separately authorized run; do not use the assigned generation directory as the execution target.

Validation to perform later:

- In a separately authorized environment, verify both SAS export destinations and both Stata input paths resolve to the same files and expected schemas.

### A_SOFTWARE: Confirm SAS runtime/component availability before the preparation program and retain the verified Stata 18 environment for the supplied built-in regressions.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SOFTWARE, SW_SAS, SW_STATA
Evidence: E_ENVIRONMENT, E_SAS_REG, E_STATA_INDEXP, E_STATA_BIGN

Preparation / proposed procedure:

1. Resolve the existing TKELS startup failure through the approved host environment, then verify the installed SAS runtime and the component required by PROC REG using non-study software metadata; do not infer a missing license from the failed startup.
2. Use the available Stata 18 runtime for the built-in areg workflow; no author-referenced user-written add-on is indicated by the supplied Stata source.
3. Do not run either author program or load the study data as part of this software check.

Validation to perform later:

- Before a separately authorized full run, record the working SAS/Stata versions and confirm the SAS procedures required by both supplied SAS branches are available.


## Remaining issues and prerequisites

- I_INPUTS [unresolved; full_pipeline]: The supplied workflow requires twelve distinct external SAS inputs and the package contains none of those panels. Exact frozen-catalog checks and bounded one-row probes found partial local candidates for Compustat, segments, Audit Analytics, IBES and identifiers, but did not establish full author-table schemas or historical coverage. The prepared historical-state and auditor-key tables have no verified route; the direct Compustat core and restatement field requests did not validate. BLS LAUS is a documented public route; Census PEP vintage/schema coverage remains unresolved.
- I_PORTABLE_PATH [preparation; full_pipeline]: The SAS exports and Stata imports use matching Windows [redacted-path-772efb4f8251] paths. Map the SAS library and both DTA handoffs to one writable host-visible working root before a future run.
- I_SOFTWARE [unresolved; full_pipeline]: Stata 18 is available, but the installed SAS startup probe failed while initializing TKELS, so SAS runtime and the component needed for PROC REG remain unverified. This startup failure does not establish a missing license or component.
- R_COMP [undetermined]: Compustat North America annual firm panel, author-named file compustat19882010.sas7bdat; source columns used in the SAS variable construction, with 1988–2010 coverage needed for lags before the 1989–2010 estimation window.
- R_AA [undetermined]: Audit Analytics annual table auditanalytics.sas7bdat used to join company/fiscal-year records and contribute audit fields.
- R_HIST [undetermined]: Author-prepared historical-state table historicalstate.sas7bdat, joined on gvkey and year; the datasheet describes its historical headquarters-state provenance.
- R_SEG [undetermined]: Segment table segment.sas7bdat used to construct business- and geographic-segment counts.
- R_UNEMP [public_acquisition_required]: BLS state unemployment table unemployment.sas7bdat, joined to firm records by state and a year-month key derived from datadate.
- R_POP [undetermined]: Census state population table population.sas7bdat, joined by state identifier and calendar year.
- R_IBES [undetermined]: IBES estimate/actual table ibes.sas7bdat used to calculate forecast error and its small-error indicator.
- R_SEDOL [undetermined]: SEDOL-to-firm mapping table sedolint.sas7bdat, used to construct the seven-character identifier joined to IBES.
- R_CUSIP [undetermined]: CUSIP-to-firm mapping table cusipus.sas7bdat, used to construct the seven-character identifier joined to IBES.
- R_AUDITORK [undetermined]: Auditor-key table auditorkey.sas7bdat, joined by gvkey and year to add auditor identity.
- R_GC [undetermined]: Going-concern table goingconcern.sas7bdat, joined by company key and fiscal-year-of-op to the prepared panel.
- R_RESTATE [undetermined]: Restatement table restatement.sas7bdat, joined by company key and fiscal year.
- SW_SAS [unverified]: The supplied SAS preparation uses PROC REG, PROC UNIVARIATE, PROC MEANS/SUMMARY, PROC SORT, PROC SQL and PROC EXPORT. The existing bounded startup probe returned 1 with a TKELS initialization failure; the SAS runtime, required component and entitlement remain unverified. No author program was run.

## Review notes

- Completed the assigned full_pipeline target from the exact supplied SAS and Stata programs, datasheet, inventory and all 25 frozen dependency IDs. The SAS program contains substantive construction plus separate INDEXP and BIGN stacked-cohort branches; Stata loads the two matching SAS export basenames and estimates four regressions per branch. The packaged DTA is only firm identifiers, so it does not support an analysis_only scope.
- The final pre-display screen flagged SAS line 4 only; SAS lines 1–9 were withheld as one opaque block, and Stata had no candidate lines. A literal-free structural inspection established only a safe bank libref assignment and the bank.rawdata1 data-step header. Do not infer credential contents, connection behavior, or an access barrier from that screen.
- Exact frozen-catalog lookups and nine one-row probes were limited to named candidate tables under ${ACCTREPL_SAS_ROOT}, through the assigned frozen CLI and registered resource helper. Probes expose schema/count metadata only, have coverage_verified=false, and do not establish history. Compustat, segments, Audit Analytics feeds, IBES and identifier candidates are not treated as complete author-prepared inputs. The FEED39 and combined FUNDA field-validation errors are schema uncertainty, not evidence that data or access are absent.
- Official static BLS LAUS and Census PEP pages were inspected. BLS documents monthly state series beginning in 1976; Census documents July 1 estimates and historical vintages. No API endpoints, data payloads, or downloads were requested, so exact Census vintage/schema and the author's historical public-data values remain to be checked during authorized acquisition.
- The existing environment artifact records Stata 18 available and SAS unverified after a TKELS startup failure; no author code or study data were executed. Static readiness findings do not establish successful reproduction. Both [redacted-path-b03a8f023939] filename pairs match; the Windows root is a known portability setup task.
- Process-only scanner, runner and bounded-query failures/corrections remain preserved in probes. The initial generic `python` lookup failure, scanner regex failures and broad-key over-redaction are not scientific evidence. A final-reference preflight also corrected stale evidence IDs inherited from the first draft checkpoint. The final source reader's candidate output and all listed artifact hashes are retained for coordinator source QA.
- One initial BLS/Census search response exceeded the available context and one BLS static-page open returned UnexpectedStatusCode; their visible requests/errors and capture limits are retained in an unreferenced process-only inspection artifact. Later official static BLS and Census pages opened successfully. No failed lookup is used as source or access-barrier evidence.
