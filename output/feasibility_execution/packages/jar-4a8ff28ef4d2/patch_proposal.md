# Patch proposal: jar-4a8ff28ef4d2

CFO Narcissim and Financial Reporting Quality

DOI: 10.1111/1475-679X.12176

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied archival CFO/CEO signature-matching and financial-reporting workflow, including its manual hand-match stages and the final experimental mediation analysis.

Entry points: `HLSW_Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12176 - CFO-Narcissim-and-Financial-Reporting-Quality/hlsw-datasheet-and-code.zip",
      "sha256": "de0c799918bd570a92602fb34d4967baddc16a505e14e1eb62fd3a100f4e17a7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "6fe5dc12ee4396507b7c7af27137e453880ab3119202bb2b4786b6f8a25c7288"
}
```

## Proposed actions

### A-ARCH-SIGNATURES: Obtain the author-prepared Signatures_Master_DL.csv or the authors’ full archival extraction/measurement specification before rebuilding it from public SEC statements. The experimental rectangle formula is not assumed to apply to archival signatures.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-SIGNATURE-MASTER
Evidence: E-CODE-SIGMASTER, E-DOC-ARCH-SEC, E-DOC-ARCH-COUNT, E-PUB-SEC, E-PUB-SEC-404

Preparation / proposed procedure:

1. Request the author-prepared master file with documented CSV headers, signature-area units, legibility rules and firm/executive identifiers, or a complete reproducible measurement protocol.
2. If using the SEC route, confirm a current path to the 2002 statements and preserve the author-reported cohort counts (940 CFOs, 945 CEOs, 939 firms).
3. Prepare the exact input columns referenced by HLSW_Code.do; do not treat the SEC 10-X corpus as a proxy for officer-statement signatures.

Validation to perform later:

- Confirm the required identifiers and area/signed-name fields are present and that the file covers the documented cohort; compare unmatched/duplicate counts with author-provided specifications.

### A-HAND-MATCH: Request the missing Signatures_Firm_Names_Merged4.csv used by the supplied code and ask only whether additional firm decisions beyond the code’s hard-coded exclusions/corrections were used. Preserve all firm/GVKEY and executive/co_per_rol decisions already encoded in HLSW_Code.do; no separate unmatched-executive decision file is required by the described workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-HAND-MATCH, ISS-CLOSURE-MANUAL
Evidence: E-CODE-HAND-MATCH, E-CODE-MERGED4, E-CODE-MANUAL-EXEC, E-CODE-FIRM-GVKEY-DECISIONS, E-CODE-EXEC-EXCLUSIONS, E-CODE-COPERROL-YEAR-EXCLUSION

Preparation / proposed procedure:

1. Request the author-prepared Signatures_Firm_Names_Merged4.csv with firmnumber, firmname and permno and any permitted provenance needed to interpret those firm-name corrections.
2. Retain the supplied high-score firm exclusions, hard-coded GVKEY corrections/multiple-GVKEY exclusions, and executive/co_per_rol exclusions as already encoded; do not recreate those decisions or add a separate executive hand-match stage.
3. Clarify whether any additional firm match decisions beyond those in the supplied do-file and Merged4.csv are required for the published sample.

Validation to perform later:

- Confirm the requested Merged4 CSV imports with firmnumber, firmname and permno, and that the supplied do-file’s existing hard-coded decisions remain in place.
- After all other required files and setup are available, compare the resulting firm links and executive sample to author-confirmed outputs; do not require further unmatched-executive matches unless authors identify additional decisions.

### A-EXPERIMENTAL-DATA: Request the name-omitted experimental rows and IRB clearance for release of signature-size values, then carry out the manual Excel-to-Stata step documented before the final regressions.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-EXPERIMENTAL
Evidence: E-DOC-EXPT, E-DOC-EXPT-METHOD, E-CODE-EXPT

Preparation / proposed procedure:

1. Request the participant-level experimental worksheet with monetaryallocation, narcissism and signaturesize, omitting names as described by the authors.
2. Obtain the required University of Maryland IRB approval before release of signature-size data; no approval or denial is inferred in this assessment.
3. Load the released sheet in Stata at the final section of HLSW_Code.do using the documented manual step, preserving the source values.

Validation to perform later:

- Confirm the imported columns resolve to the lowercase names used by all four code regressions. Stata variable-name matching is case-sensitive, so differently capitalized literals do not match; an abbreviated reference is valid only if the active varabbrev setting permits it and the same-case prefix is unambiguous. Record the author-provided participant count and missingness checks.

### A-EXECUCOMP: Use a verified Execucomp source to prepare both author-named files with the exact fields, key structure and executive-year coverage, then validate the 2014 snapshot or author-approved compatible current history.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-EXECUCOMP
Evidence: E-DOC-EXECUCOMP, E-PROBE-EXECUCOMP, E-CATALOG, E-CODE-EXECUCOMP-DL, E-CODE-EXECUCOMP

Preparation / proposed procedure:

1. Confirm whether the June 2014 author snapshot or current local EXECCOMP.ANNCOMP is the intended source and document all extraction filters and year coverage.
2. Export/convert the verified product to Stata inputs Execucomp_DL.dta and execucomp.dta, mapping the probed source columns to the do-file’s names and preserving all executive-firm-year records needed for tenure.
3. Do not assume that the two author-named files are identical until their field roles and snapshot are confirmed.

Validation to perform later:

- Confirm required keys GVKEY, EXECID and CO_PER_ROL are unique at their intended levels and the name, year, role, gender and TDC1 fields cover all matched executives and periods.

### A-COMPUSTAT: Prepare the annual Compustat input from the verified historical product; the bounded local candidate has the required accounting fields and SICH, which is labeled historical SIC, while the code expects SIC.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-COMPUSTAT
Evidence: E-PROBE-COMPUSTAT, E-CATALOG, E-CODE-COMPUSTAT, E-DOC-COMMERCIAL

Preparation / proposed procedure:

1. Confirm compatible Compustat annual product filters and history for the code’s selected firms/years; preserve any required author snapshot date.
2. For the local COMP.FUNDA candidate, map SICH to the Stata variable SIC only after confirming the author’s SIC use and required product semantics; retain all raw accounting fields used in HLSW_Code.do.
3. Export/convert to compustat.dta without dropping the lag/lead observations required by the code.

Validation to perform later:

- Verify the final input contains all referenced Compustat fields and at least five prior firm-years plus the required one future firm-year around each analysis year; exact calendar bounds must be supplied by the author/sample.

### A-CCM: Prepare the CCM link input from a confirmed product and coverage. The local CRSP link table has the needed keys/date fields but lacks CONM/CONML named on line 28.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CCM-LINK, ISS-CCM-MAPPING
Evidence: E-PROBE-CCM, E-CODE-CCM, E-CATALOG

**Proposed edit:** `HLSW_Code.do:28–28`
Source SHA-256: `726963cce706e1798c341e6f2c984af1d4684f21aee69acfd22b54d881a23a02`

Conditional on using CRSP.CCMXPF_LINKTABLE and author confirmation: the local product has the link identifiers/dates but not CONM/CONML, and the supplied code does not use those two fields downstream.

Current text:
```
keep gvkey lpermno conm conml linkdt linkenddt
```

Proposed replacement:
```
keep gvkey lpermno linkdt linkenddt
```

Preparation / proposed procedure:

1. Confirm that the current local CCM table is compatible with the author’s link snapshot, identifier coding and period coverage.
2. If confirmed, map LPERMNO to the expected lpermno field and retain GVKEY, LINKPRIM, LINKDT and LINKENDDT.
3. Apply the conditional line 28 edit only after confirming CONM and CONML are unused in the intended source variant; otherwise obtain the author input with the fields the current code expects.

Validation to perform later:

- Check the Stata input fields and link interval coverage for the matched firms; then verify the code’s P/C primary-link filter and generated CCM_Link1 file without running the research analysis during this assessment.

### A-CRSP-NAMES: Prepare the CRSP name input with company name, ticker and PERMNO, using the complete author-compatible name history.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CRSP-NAMES
Evidence: E-PROBE-CRSP-NAMES, E-CATALOG, E-CODE-CRSP-NAMES, E-DOC-COMMERCIAL

Preparation / proposed procedure:

1. Confirm the local CRSP.DSENAMES or author snapshot covers all officer-statement firms and the required historical company names.
2. Export/convert the verified product columns PERMNO, COMNAM and TICKER to CRSP_DL.dta.

Validation to perform later:

- Confirm all signatures’ company names can be compared against the author’s name fields and review unresolved fuzzy-match candidates.

### A-CRSP-AGE: Prepare the CRSP PERMNO/date history used for firstyear and firmage, with full applicable listing history.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CRSP-AGE
Evidence: E-PROBE-CRSP-AGE, E-CATALOG, E-CODE-CRSP-AGE

Preparation / proposed procedure:

1. Confirm that CRSP.DSF or the author snapshot has historical dates reaching each linked firm’s first relevant observation.
2. Export/convert PERMNO and DATE to crsp.dta while preserving full applicable history.

Validation to perform later:

- Check the resulting earliest year per GVKEY against author-confirmed source history and the analysis years.

### A-CRSP-PERMNO-LINK: Request the exact producer or author file for crsppermnolink.dta and the rule that selects one GVKEY per PERMNO. Do not assume it is CCM_Link1.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSP-PERMNO-LINK, ISS-CLOSURE-CRSP-LINK
Evidence: E-CODE-CRSP-AGE, E-CODE-CCM, E-PROBE-CCM

Preparation / proposed procedure:

1. Ask the authors whether crsppermnolink.dta is derived from CCM_Link1.dta or a distinct CRSP/Compustat link extract.
2. Request the exact input fields, interval filters and deterministic one-row-per-PERMNO selection rule.
3. Prepare the named file only after the producer and row-selection procedure are confirmed.

Validation to perform later:

- Confirm one selected GVKEY per PERMNO and verify matches against the author-specified link period.

### A-AUDIT-ANALYTICS: Request the author’s Audit Analytics extraction/preparation steps or the three prepared input files, including the COMPANY_FKEY-to-CIK crosswalk and fiscal-year/date mappings needed by the Stata merges.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-AUDIT-CONTROLS, R-AUDIT-FEES, R-RESTATEMENTS, ISS-CLOSURE-AUDIT
Evidence: E-DOC-COMMERCIAL, E-CODE-AUDIT-INPUTS, E-CODE-RESTATEMENTS, E-PROBE-AUDIT-CONTROLS, E-PROBE-AUDIT-FEES, E-PROBE-AUDIT-RESTATEMENTS, E-CATALOG

Preparation / proposed procedure:

1. Request internalcontrols.dta, auditfees.dta and restatements.dta or the authors’ exact product queries, field mappings and company-key crosswalk.
2. If using local AUDIT.FEED11, FEED03 and FEED39, verify source product versions and map source fields to CIK, fyear, controlseffective, numweakness, auditfees, restatebegin and restateend only from confirmed documentation.
3. Preserve the code’s pre-2004 control handling and author download period; do not assume catalog presence establishes access rights or license coverage.

Validation to perform later:

- Check CIK/fyear uniqueness at each merge level, restatement interval construction and availability of every field used by the models.

### A-CRSP-RETURNS: Request the exact producer/extract for crspreturns.dta or confirm an author-approved construction from monthly stock and market data. The code requires matching stock RET and market EWRETD series by date/CUSIP.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSP-STOCK-RET, R-CRSP-MARKET-RET, ISS-CLOSURE-CRSP-RETURNS
Evidence: E-CODE-CRSP-ROLLING, E-PROBE-CRSP-MSF, E-PROBE-CRSP-MSI, E-DOC-COMMERCIAL

Preparation / proposed procedure:

1. Request crspreturns.dta or its exact WRDS query, period, CUSIP/date handling and market-index merge specification.
2. If authors confirm the local CRSP.MSF plus CRSP.MSI route, export CUSIP/DATE/RET and DATE/EWRETD separately and merge on confirmed monthly DATE without substituting a different market series.
3. Retain sufficient rows for the code’s 8-month prior and 3-month subsequent offsets per CUSIP; confirm how gaps and duplicate months are handled.

Validation to perform later:

- Verify the combined input contains CUSIP, DATE, RET and EWRETD, covers each event window and reproduces the author-defined monthly return series.

### A-DELTA-VEGA: Acquire the author’s current compensation-incentive data from the linked author page and prepare the do-file’s deltavega.csv input after checking its delivered format/header and overlap with the June 2014 Execucomp extract.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-DELTA-VEGA, ISS-DELTA-IMPORT
Evidence: E-PUB-DELTA, E-CODE-DELTA-VEGA, E-DOC-EXECUCOMP

Preparation / proposed procedure:

1. Obtain the linked author data for 1992–2022 and preserve its original file and citation.
2. Confirm the delivered columns GVKEY, YEAR, CO_PER_ROL, DELTA and VEGA; convert to the required CSV/input representation and map YEAR to fyear as the do-file specifies.
3. Inspect whether the delivered file has a header. Keep the current insheet behavior if the source is headerless; propose a line 670 import adjustment only if the observed format requires it.
4. Confirm exact data definitions and year overlap against the authors’ June 2014 Execucomp input before using the updated author file.

Validation to perform later:

- After data acquisition in a separately authorized run, verify the required key/measure columns, nonmissing values, unique key behavior and Stata import of deltavega.csv; confirm the delta/vega scaling by TDC1 matches the code.

### A-RESTATEMENT-ORDER: Ask the authors to confirm the intended within-CIK ordering of multiple restatement records before the code creates row-offset intervals.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-RESTATEMENT-ORDER
Evidence: E-CODE-RESTATEMENT-SORT, E-CODE-RESTATEMENTS

Preparation / proposed procedure:

1. Request the author sort key and tie-breaking rule used to order restatements within each CIK.
2. If the authors confirm a deterministic key, apply it to the prepared input or a future source edit without changing the interval definition.

Validation to perform later:

- Confirm generated yearbegin/yearend offsets follow the author-provided order for all retained restatements.

### A-SALESGROWTH-INDEX: Ask the authors to confirm the intended sales-growth comparison and record ordering; do not replace the current row-index expression with an assumed panel lag.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-SALESGROWTH-INDEX
Evidence: E-CODE-REVT-INDEX

Preparation / proposed procedure:

1. Request the intended firm-year comparison for salesgrowth and the source ordering expected at line 639.
2. Only after confirmation, update the source formula or required pre-sort so the variable uses the intended observations.

Validation to perform later:

- Check salesgrowth for adjacent firm-year rows against the confirmed author formula and verify no observation is paired across firms.

### A-SOFTWARE: Install the two missing invoked Stata add-ons from their verified SSC repository records, then confirm the exact commands resolve in Stata 18.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-RECLINK, SW-OUTREG2
Evidence: E-SW-RECLINK, E-SW-OUTREG2, E-PUB-RECLINK, E-PUB-OUTREG2

Preparation / proposed procedure:

1. In a separately authorized environment-setup step, install reclink and outreg2 from SSC using the repository-provided commands.
2. Do not replace the author’s command calls or infer availability from similarly named packages.

Validation to perform later:

- Run which reclink and which outreg2 in Stata 18; also confirm which ffind and which winsor still resolve.

### A-WORKDIR: Stage all validated author inputs and generated outputs in a prepared working directory because the do-file uses relative paths and sets no directory.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS-WORKING-DIRECTORY
Evidence: E-CODE-SIGMASTER, E-CODE-CCM, E-CODE-EXPT

Preparation / proposed procedure:

1. Place HLSW_Code.do and all confirmed source input files in one controlled working directory, preserving the exact relative filenames expected by the code.
2. Before a future authorized run, set Stata’s working directory to that folder and run do HLSW_Code.do.
3. At the final experimental section, load the author-prepared data manually as directed by the code; confirm both output workbooks are written into the intended directory.

Validation to perform later:

- Confirm the first input read resolves from the selected directory and that finaltables.xls and conservatism.xls are written to the intended location.


## Remaining issues and prerequisites

- ISS-CLOSURE-MANUAL [unresolved; full_pipeline]: The required Signatures_Firm_Names_Merged4.csv is explicitly created by hand from fuzzy firm-match candidates and imported by the do-file. The code itself supplies high-score firm exclusions, hard-coded GVKEY corrections and multiple-GVKEY exclusions, as well as specific executive/co_per_rol exclusions; it also states that checking unmatched executive candidates found no additional matches. The remaining gap is the missing Merged4.csv and clarification of whether any additional firm decisions beyond the encoded decisions were used.
- ISS-CLOSURE-CRSP-LINK [unresolved; full_pipeline]: crsppermnolink.dta is read directly and reduced to one row per PERMNO, but no code or specification produces it. The relation to generated CCM_Link1.dta and the row-selection rule are unknown.
- ISS-CLOSURE-CRSP-RETURNS [unresolved; full_pipeline]: crspreturns.dta is read directly with CUSIP, date, ret and ewretd fields, but no code builds it. Local stock-return and market-index candidates are separate products; the authors’ exact extraction/merge is not supplied.
- ISS-CLOSURE-AUDIT [unresolved; full_pipeline]: internalcontrols.dta, auditfees.dta and restatements.dta are direct inputs with no in-file producer; local Audit Analytics candidates use COMPANY_FKEY/source-specific fields and require an undocumented mapping to CIK/fyear and the author input schema.
- ISS-CCM-MAPPING [unresolved; full_pipeline]: The local CCM candidate lacks CONM and CONML, but HLSW_Code.do line 28 keeps those variables. They are not used downstream in the supplied code; using this candidate requires author confirmation or a narrowly scoped edit to drop the unused fields.
- ISS-RESTATEMENT-ORDER [unresolved; full_pipeline]: The code sorts restatement data by CIK only, then uses row offsets 1–10 for later restatement intervals. The intended within-CIK order is not defined, so a deterministic date ordering cannot be assumed.
- ISS-SALESGROWTH-INDEX [unresolved; full_pipeline]: The code defines salesgrowth with revt[_n-3] after merging firm-year data but does not group/xtset by GVKEY in this block. The intended three-year within-firm comparison or other ordering must be confirmed before changing the formula.
- ISS-DELTA-IMPORT [unresolved; full_pipeline]: The current author route identifies the delta/vega product fields and period, but the delivered file format/header has not been inspected. The do-file uses insheet on deltavega.csv without the names option, so compatibility requires checking the actual file header/import semantics.
- ISS-WORKING-DIRECTORY [preparation; full_pipeline]: All code input/output names are relative and the do-file does not set a working directory; execution must start in a prepared folder containing the input files or Stata will resolve names against the wrong directory.
- R-SIGNATURE-MASTER [undetermined]: Author-prepared archival officer-signature master data required by the do-file, with firm number/name, executive name, signed name where legible, signature area, title, legibility and match identifiers. The datasheet documents collection from the 2002 SEC order cohort but the release omits the CSV and does not give the archival signature-size measurement recipe.
- R-HAND-MATCH [undetermined]: The author-created firm-name correction file Signatures_Firm_Names_Merged4.csv remains a required external input after candidate exports; the do-file itself supplies its hard-coded high-score firm exclusions, GVKEY corrections and multiple-GVKEY decisions, plus executive/co_per_rol exclusions. The code says a separate unmatched-executive hand review found no additional matches. The Merged4.csv file is absent; only whether any additional firm decisions beyond the code remain is unclear.
- R-EXPERIMENTAL [undetermined]: Author-prepared participant-level experiment rows for the four mediation OLS regressions: monetaryallocation, narcissism and signaturesize. The Stata code instructs users to paste these rows manually from Excel; no workbook is packaged.
- R-EXECUCOMP [undetermined]: Execucomp inputs used as two author-named files: Execucomp_DL.dta supports firm/executive matching and years in office; execucomp.dta supplies the annual executive data, gender and TDC1 used by the merge and incentive scaling.
- R-COMPUSTAT [undetermined]: Annual Compustat accounting inputs for the archival models and firm-year controls. The code uses current and lagged annual fundamentals plus SIC for industry grouping.
- R-CCM-LINK [undetermined]: CRSP/Compustat link records used to map PERMNO to GVKEY with primary-link filtering and link dates.
- R-CRSP-NAMES [undetermined]: CRSP firm-name data with PERMNO, company name and ticker for fuzzy matching to the hand-collected signature master.
- R-CRSP-AGE [undetermined]: CRSP date records by PERMNO used to derive each linked firm’s first observed year and firmage.
- R-CRSP-PERMNO-LINK [undetermined]: A unique-PERMNO-to-GVKEY file named crsppermnolink.dta is directly read and reduced to one row per PERMNO. No producer or selection rule is supplied in the code.
- R-AUDIT-CONTROLS [undetermined]: Audit Analytics internal-control data for CIK/fyear, controlseffective and numweakness used in the control regressions.
- R-AUDIT-FEES [undetermined]: Audit Analytics fee data keyed by CIK/fyear with auditfees for scale and sample filters.
- R-RESTATEMENTS [undetermined]: Audit Analytics restatement start/end date records keyed by CIK, used to create restatement indicators across fiscal years.
- R-CRSP-STOCK-RET [undetermined]: CUSIP-month stock returns and dates required to create the CRSP cumulative-return input.
- R-CRSP-MARKET-RET [undetermined]: CRSP equal-weighted market return EWRETD by month, needed jointly with stock returns for the author-named crspreturns.dta input.
- R-DELTA-VEGA [public_acquisition_required]: Delta and vega data keyed by GVKEY, CO_PER_ROL and year; the code renames year to fyear and divides delta/vega by TDC1.
- SW-RECLINK [preparation_required]: The exact invoked fuzzy-match command is not found in checked Stata adopaths; an SSC repository installation route is verified.
- SW-OUTREG2 [preparation_required]: The exact table-export command is not found in checked Stata adopaths; a repository installation route is verified.

## Review notes

- Generation_004 is a targeted same-paper revision of the accepted pair. The sole assessment-text correction is that the experimental-data validation now treats Stata literal variable names as case-sensitive; the target scope, outcomes and supported uncertainties are otherwise preserved.
- Same-paper probes referenced by the carried-forward evidence were copied byte-for-byte into this generation's probes, with source/destination hashes recorded in probes/prior_metadata_provenance.json; the current environment artifact hash was verified.
- All 35 frozen dependency IDs are reviewed individually. Generated Compustat intermediate files in the j=1..10 loops are manually traced; no generated file is treated as an independent source.
- The package has one full_pipeline scope only. No author-prepared final analysis dataset supports a separate analysis_only scope. The final experimental section is included because the datasheet documents it and the do-file contains its four regressions.
- Local probes read one row only and do not establish dataset period, full history, entitlement or the exact author snapshot. Commercial-source catalog entries and local paths are candidates, not inferred licenses.
- Open workflow gaps are specifically identified: missing manual correction and raw inputs; no in-file producer for crsppermnolink.dta, crspreturns.dta and Audit Analytics prepared inputs; unresolved row ordering/formula questions; input-format uncertainty for the current Delta/Vega author route.
- No author code was edited or executed; no regressions, installations, data downloads, outgoing messages, or publishing/review actions were performed.
