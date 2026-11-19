# Patch proposal: jar-fd3f82d4cbde

The effect of managerial litigation risk on earnings warnings: Evidence from a natural experiment

DOI: 10.1111/1475-679X.12336

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Supplied SAS raw-to-matched-sample workflow, retaining the in-source Stata pscore producer because active SAS imports warn_pscore.dta; ends at the SAS match_sample.dta export. The datasheet-described paper-wide Stata analyses are not supplied as code and are contextual.

Entry points: `HLYZ Codes.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 5/12336 - The-effect-of-managerial-litigation-risk-on-earnings-warnings-Evidence-from-a-natural-experiment/hlyz-datasheet-code-and-identifiers.zip",
      "sha256": "680c595dccb7b279426241548e30c4bfdff4e9cd0fdf66a892ffe94824463dfc"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "72c7e913b48c946af36dad0c8bcf8dbc3eaa165c588c42ec6a9e21e1f4cccab7"
}
```

## Proposed actions

### A-INPUTS: Resolve a compatible route for each active input while preserving exact fields, identifiers, history and construction. Local one-row candidates are leads only; WRDS provenance by itself is not an access barrier.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-COMPQ, R-CCM, R-CRSP, R-IBLINK, R-ANALYSTDETAIL, R-IO, R-SEG, R-COMPA, R-CIG, R-IBSUM, R-HEADER, R-CIKLINK, R-STATEVALID, R-UDSTATE
Evidence: E-OVERVIEW, E-DATASHEET, E-CATALOG-LOOKUPS, E-FROZEN-CATALOG, E-PROBE-COMPQ, E-PROBE-FUNDA, E-PROBE-COMPANY, E-PROBE-CCM, E-PROBE-CRSP-MSF, E-PROBE-CRSP-MSI, E-PROBE-IBLINK, E-PROBE-IBES-DETAIL, E-PROBE-IBES-SUMMARY, E-PROBE-SEGMENTS, E-PROBE-CIKLINK, E-PROBE-13F, E-SRAF-PUBLIC, E-PROBE-LM10X, E-IBES-GUIDANCE-CATALOG, E-IBES-GUIDANCE-PAGE, E-CIG-PASS, E-ANALYST1-KEEP, E-CIG-SELECT, E-CIG-GVKEY-CONSUMER

Preparation / proposed procedure:

1. Confirm exact fields, identifiers, product version and date history for all 14 external inputs; keep independent merge inputs separate.
2. Resolve COMP.FUNDQ SIC, COMP.FUNDA incorporation/state history, CRSP VWRETD source, CIK-link interval mapping and the two author state lookup tables.
3. Request exact author CIG and prepared io_wrds contracts where needed. The TFN.S34 holdings candidate is not the prepared PERMNO/io output; its one-row probe timed out and author WRDS construction/identifier semantics remain required.
4. Treat a compatible 2016 author-prepared First Call/Compustat/IBES bundle as a primary alternative only if it supplies the final.firstcall_forecast contract; do not require it in addition to raw components.
5. Verify SRAF CSV field mapping, CIK choice, duplicate-filer handling and historical coverage. Local LM10X and SEC filing corpora are not demonstrated substitutes for the augmented-header input.
6. For each route, validate temporal coverage and transformations beyond one-row readability; do not infer missing data or licenses from catalog misses.
7. Assess catalogued IBES.DET_GUIDANCE and related guidance tables as a CIG candidate; request mapping for CUSIP/GVKEY, FPE, CIGCODEQ and estimates, and retain its required history as unresolved. The product page is metadata, not public access.
8. Verify that prepared data.cig itself contains GVKEY and passes it from a1 through the First Call merge; IBES analyst1's KEEP projection drops GVKEY and no crosswalk producer is supplied.

Validation to perform later:

- Compare exact fields, identifiers, date ranges and construction history for every staged source; one-row probes do not establish population/history fidelity.
- After separately authorized staging, verify the 1990–2012 construction history, rolling/lag windows, dated link intervals and 1995–2010 output sample without synthetic substitutions.
- Confirm data.cig supplies GVKEY and that the a.gvkey key survives into a3 for the Compustat date join; do not infer or invent a crosswalk.

### A-SOFTWARE: Verify SAS startup/format support and the Stata 18 commands used by the separate pscore stage before any separately authorized execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, SW-STATA, SW-FFIND, SW-PSMATCH2
Evidence: E-ENV, E-SW-FFIND, E-SW-PSMATCH2, E-PSCORE

Preparation / proposed procedure:

1. Stata 18 and ffind are available by bounded checks; verify release behavior and SAS/Stata DTA handoff compatibility only in a future authorized run.
2. Configure psmatch2 on the selected Stata adopath; the command is absent on checked paths. No installation is performed in this assessment.
3. SAS 9.4 failed TKELS initialization; verify runtime and DTA import/export support later without inferring license status.

Validation to perform later:

- Confirm required SAS/Stata commands and DTA format support in the selected runtime; retain software versions and command locations.
- Verify shared working directory and pscore variable/identifier preservation in an authorized future execution.

### A-GAPS: Obtain the exact missing macro, confirm the Stata/SAS handoff contract, and reconcile datasheet-only inputs/stages without inventing branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-INPUT-CONTRACT, I-WINSOR, I-PSCORE-HANDOFF, I-PATHS
Evidence: E-WINSOR, E-PSCORE, E-ROOT, E-HEADER, E-DATASHEET

Preparation / proposed procedure:

1. Obtain the exact author winsor.SAS file and implementation, then stage that file at support/winsor.SAS; do not replace its behavior.
2. Confirm that the embedded Stata pscore block runs after merged_sample.dta export and before active SAS import of warn_pscore.dta, including the exact DTA columns.
3. Ask whether Audit Analytics, CRSP beta generation and the 2016 prepared merge describe provenance or omitted author stages; do not make them extra live requirements until supported.
4. If a prepared First Call/Compustat/IBES bundle is supplied, compare its fields and dates to final.firstcall_forecast before using it as a primary alternative.

Validation to perform later:

- Verify final.qtr_control, final.event_dummy and final.firstcall_forecast producers and keys before their merge.
- Verify the exact order SAS m2 → WINSOR m3 → merged_sample.dta → Stata ffind/psmatch2 → warn_pscore.dta → SAS PROC IMPORT → match_sample.dta.
- Compare final identifiers with Firm List.xlsx only as an identifier reference, not an analysis panel.

### A-PATH-EDIT: Proposed relative paths use one run root containing input/, output/ and support/; launch both SAS and Stata with that root as their current directory. Preserve all processing logic and stage order.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I-PATHS, I-PSCORE-HANDOFF
Evidence: E-ROOT, E-HEADER, E-WINSOR, E-PSCORE, E-MATCHOUT, E-OVERVIEW

**Proposed edit:** `HLYZ Codes.sas:18–18`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Set the active input library under the shared run root.

Current text:
```
libname data 'location on computer';
```

Proposed replacement:
```
libname data 'input';
```

**Proposed edit:** `HLYZ Codes.sas:20–20`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Set the generated/output library under the shared run root.

Current text:
```
libname final 'location on computer';
```

Proposed replacement:
```
libname final 'output';
```

**Proposed edit:** `HLYZ Codes.sas:774–774`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Stage the confirmed compatible SRAF CSV under input/.

Current text:
```
proc import out=hstate1 datafile="[redacted-path-fd26f62aece9]" replace;
```

Proposed replacement:
```
proc import out=hstate1 datafile="input/LM_EDGAR_10X_Header_1994_2017.csv" replace;
```

**Proposed edit:** `HLYZ Codes.sas:1016–1016`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Stage the exact author macro under support/; this edit does not supply or replace its body.

Current text:
```
%INC"[redacted-path-db841ea12a90]";
```

Proposed replacement:
```
%INC"support/winsor.SAS";
```

**Proposed edit:** `HLYZ Codes.sas:1018–1018`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Export the SAS producer into the shared output directory.

Current text:
```
proc export data=m3 outfile="location on computer\merged_sample.dta" replace;run;
```

Proposed replacement:
```
proc export data=m3 outfile="output/merged_sample.dta" replace;run;
```

**Proposed edit:** `HLYZ Codes.sas:1023–1023`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Have Stata consume the SAS export from the same run root.

Current text:
```
use "location on computer\merged_sample.dta", clear
```

Proposed replacement:
```
use "output/merged_sample.dta", clear
```

**Proposed edit:** `HLYZ Codes.sas:1027–1027`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Have Stata write the pscore handoff where SAS will import it.

Current text:
```
save "location on computer\warn_pscore.dta", replace
```

Proposed replacement:
```
save "output/warn_pscore.dta", replace
```

**Proposed edit:** `HLYZ Codes.sas:1032–1032`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Have SAS import the Stata-produced handoff from output/.

Current text:
```
proc import out=p1 datafile="location on computer\warn_pscore.dta" replace;run;
```

Proposed replacement:
```
proc import out=p1 datafile="output/warn_pscore.dta" replace;run;
```

**Proposed edit:** `HLYZ Codes.sas:1096–1096`
Source SHA-256: `61ddb8ce3a1a2215c14290e21e3b793a81748871fe3115b92f5bc8b13d638dd4`

Write the supplied workflow's final matched sample under output/.

Current text:
```
proc export data=match4 outfile="location on computer\match_sample.dta" replace;run;
```

Proposed replacement:
```
proc export data=match4 outfile="output/match_sample.dta" replace;run;
```

Preparation / proposed procedure:

1. Prepare one host-visible run root with input/, output/ and support/ directories; place only compatible inputs in input/ and the exact supplied winsor.SAS macro in support/.
2. Apply all listed source edits together, then start SAS and Stata from the same run root so the cross-language DTA handoff is consistent.

Validation to perform later:

- Before any author-code execution, inspect the proposed source text to confirm every input/output/include reference uses the shared run-root layout.
- After a separately authorized run, verify each producer/consumer file exists at the shared path and retains the required identifiers and fields.


## Remaining issues and prerequisites

- I-INPUT-CONTRACT [unresolved; full_pipeline]: The 14 external reads D0001–D0014 remain unsupplied or unverified. Specific gaps: quarterly SIC (common FUNDQ lacks it), annual incorp/state (common FUNDA lacks them; COMPANY historical mapping is unknown), CRSP VWRETD (MSF lacks it; MSI join is unverified), CIK interval semantics, and author state lookups. History includes quarterly lags, prior 3–60 month ROA, current/prior quarter returns, annual prior-year/CRSP windows, current/prior segments and IO, RDQ analyst windows, and dated header links. Code filters selected construction to 1990–2012 and final sample to 1995–2010. The local IBES.DET_GUIDANCE candidate is a meaningful lead for CIG, but does not establish the author CUSIPG/FPE/CIGCODEQ/estimate contract. The prepared CIG table must also supply GVKEY: the forecast-summary projection omits it and the later Compustat-date join uses a.gvkey; no crosswalk is supplied.
- I-WINSOR [unresolved; full_pipeline]: Active %INC requires the exact external winsor.SAS file and %WINSOR creates m3 from m2 by fyearq at PCTL=1 99. Macro source/behavior is not packaged; no substitute is supported.
- I-PSCORE-HANDOFF [unresolved; full_pipeline]: Stata pscore code is inside a SAS block comment and must run separately after merged_sample.dta export; it uses ffind/psmatch2 to save warn_pscore.dta, which active SAS PROC IMPORT consumes as p1. Shared working directory, DTA import/export and p1 columns remain to verify.
- I-PATHS [preparation; full_pipeline]: Libraries, header CSV, macro include and three DTA handoff/output paths use placeholders or Windows locations. Configure input/, output/ and support/ under a shared run root and update all producer/consumer references coherently.
- R-COMPQ [undetermined]: Compustat quarterly fundamentals used for quarterly controls, one-quarter lags, analyst-surprise dates and the prior 3–60 month ROA-dispersion window; code uses SIC from this input.
- R-CCM [undetermined]: Dated GVKEY–PERMNO crosswalk used for quarterly and annual Compustat records.
- R-CRSP [undetermined]: CRSP monthly stock/market returns, volume and shares outstanding used for quarterly abnormal returns and annual litigation-risk proxies.
- R-IBLINK [undetermined]: IBES–CRSP ticker/PERMNO linking table used to attach analyst identifiers.
- R-ANALYSTDETAIL [undetermined]: Dated IBES analyst detail forecast and actual values used for earnings-surprise construction.
- R-IO [undetermined]: Prepared WRDS institutional-ownership input joined to Compustat/CRSP quarter controls.
- R-SEG [undetermined]: Compustat segment-history input used for business/geographic segment counts.
- R-COMPA [undetermined]: Compustat annual fundamentals used for litigation-risk inputs and incorporation state.
- R-CIG [undetermined]: First Call guidance/earnings-warning input used to define warning news.
- R-IBSUM [undetermined]: IBES US summary EPS forecasts used to classify good/bad news.
- R-HEADER [undetermined]: Augmented 10-X header CSV with incorporation, business-address state, report-period date and CIK.
- R-CIKLINK [undetermined]: Dated WRDS SEC Analytics Suite CIK–GVKEY crosswalk used to map header observations.
- R-STATEVALID [undetermined]: Author state-name validation lookup for SEC header fields.
- R-UDSTATE [undetermined]: State/event-year lookup used to construct treatment and post indicators.
- SW-SAS [unverified]: SAS 9.4 is required for active DATA/PROC SQL/SORT/MEANS/IMPORT/EXPORT and WINSOR. Existing path failed TKELS initialization; this does not prove a missing license.
- SW-PSMATCH2 [preparation_required]: psmatch2 is not found on checked default/shared adopaths; no installation or estimator run was attempted.

## Review notes

- Target: supplied SAS raw-to-matched-sample workflow, retaining its separate embedded Stata pscore stage between merged_sample.dta export and active SAS import of warn_pscore.dta.
- All 18 frozen dependency IDs are classified: D0001–D0014 active external requirements, D0015–D0017 generated SAS intermediates, D0018 Stata-generated handoff.
- Firm List.xlsx is an identifier list, not an analysis panel; no analysis_only scope. Paper-wide Stata estimators are contextual because that code is not supplied.
- One-row probes establish only fields/readability; routes remain unverified for unresolved vintage, period history, identifier mapping or construction. Commercial WRDS provenance is not an access barrier.
- No author code/study data was executed; no shared helper, catalog, source or package was modified. execution_verified remains false.
- Process records are separate: unauthorized_external_read_report.json and addendum note truncated output and unknown physical extent; evidence is excluded. temporary_helper_cleanup_report.json records seven lost helper bodies; they were not reconstructed or used.
- Datasheet-only Audit Analytics, beta-generation and paper-wide Stata analyses are contextual for this supplied SAS transformation; no separate execution requirement is added. A prepared First Call bundle is considered only as a compatible primary alternative.
- The unauthorized external catalog read report/addendum and seven-helper cleanup report remain unchanged and are excluded from data-route support.
- Failed expansion writer history is in failed_expansion_writer_v1_capture.json plus failed_expansion_writer_v1_addendum.json. The original inline source was not persisted and is not reconstructed; the addendum corrects that the first expanded draft/checkpoint was saved before the trace-construction error.
- Unauthorized external catalog read and temporary-helper cleanup reports remain unchanged and are excluded from source/route support.
