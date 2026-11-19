# Patch proposal: jar-54083cadfa56

Debiasing the Measurement of Conditional Conservatism

DOI: 10.1111/1475-679X.12366

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied author SAS sample-construction workflow ending in the Stata export sample2017JAR.dta. The datasheet also mentions a separate synthetic-returns analysis program, but that absent program is not called by the supplied SAS entry point and remains contextual.

Entry points: `New_Basu_v4_JAR.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12366 - Debiasing-the-Measurement-of-Conditional-Conservatism/bdpr-datasheet-code-and-identifiers.zip",
      "sha256": "834020ba5fa038c48d3fdfe17b0ec8440dfbeea8a56659bd33edf809b44311fb"
    },
    {
      "path": "JAR-Volume 59/Issue 4/12366 - Debiasing-the-Measurement-of-Conditional-Conservatism/bdpr-online-appendix.pdf",
      "sha256": "f8528011bc1818268813a3f97be40721aab820e84cdada28eea305355af0c0ee"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "d616f174e7279b1daf18bb551469320016d7109cb5f3b7dbeafb17a4da49dc4e"
}
```

## Proposed actions

### ACT-MACRO: Resolve the supplied %winsor calls against the configured SAS autocall/macro path or obtain the exact author-used definition, then preserve the original call-specific transformations without substitution.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-WINSOR-MACRO
Evidence: E-SAS-WINSOR-LITIG, E-SAS-WINSOR-MAIN, E-SAS-WINSOR-CFORES, E-ENVIRONMENT

Preparation / proposed procedure:

1. Retain each source call, its exact variables, pctl=1 99, type=winsor, and existing byvar choice.
2. Confirm whether the configured SAS system/site autocall resolves %winsor; if it does, record the resolved source and version; otherwise obtain the author-used definition/include.
3. Do not emulate the macro with a guessed winsorization procedure.

Validation to perform later:

- Verify macro resolution and its grouping/percentile behavior from the resolved source before any separately authorized full workflow run.

### ACT-SETUP: Configure AT as a writable project/staging library holding verified compatible author inputs and derived AT outputs, with common catalog source libraries kept separate and read-only. Assign GLOPREM to the verified monthly input. Preserve the source-defined WRDS host/port, TCP SIGNON, prompted username, upload/query/download order, and use the authored MYDATA root only if authorized; otherwise configure the authenticated user’s authorized WRDS workspace.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS-WRDS-SETUP
Evidence: E-SAS-ENTRY, E-SAS-REMOTE, E-ENVIRONMENT, E-PUB-CONNECT, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Set the local SAS working directory to the project root. Configure AT as a writable project-owned staging library for verified compatible author input tables and generated AT outputs; keep common COMP/CRSP catalog sources separate and read-only, and assign GLOPREM separately to the verified GLOPREM.CRSP2019 input.
2. Use the source’s WRDS host/port and prompted username. The source names [redacted-path-e1f3f7c8b9f7] as the MYDATA root; retain it only if authorized, or configure a user-authorized remote workspace without changing the transfer sequence.
3. Keep local mapping preparation, remote upload/query/sort, download to AT.RAWBASDVOLAT2017, and subsequent local stages in the authored order. Record local and remote working directories and library roots separately.

Validation to perform later:

- Confirm local staging permissions, each AT/GLOPREM table schema, WRDS authentication and authorized remote workspace; do not treat a common read-only raw-data directory as the writable AT output library.

### ACT-ORDER: Confirm the native observation ordering and required lag history for AT.Compdata_perm and AT.Funda1950_2017, preserving the three separate OBS=900000 source reads at lines 11, 78 and 167 and each read’s own filters and placement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-SOURCE-ORDER-HISTORY
Evidence: E-SAS-OBS-MAP, E-SAS-OBS-LITIG, E-SAS-OBS-MAIN, E-SAS-MAIN-HISTORY, E-SAS-FUNDA, E-SAS-CRSP-RETURNS, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Obtain the source schema/order and prior-year history needed for each lag and BY merge.
2. Retain all three OBS=900000 caps before their respective subsequent transformations; do not sort or filter before a cap unless author evidence supports it.
3. Preserve the explicit mapping sort by PERMNO/DATADATE and all authored source and downstream ordering.

Validation to perform later:

- Compare the specified source-order/lag contract to each input and intermediate before an authorized run; do not execute this program during the assessment.

### ACT-OUTPUT: In a working copy, change the final PROC EXPORT OUTFILE to output/sample2017JAR.dta relative to the configured project-root working directory; preserve the source DBMS token and final sample basename pending the separate exact-version compatibility check.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS-OUTPUT-PATH
Evidence: E-SAS-PIN-EXPORT, E-WORKFLOW-TRACE

**Proposed edit:** `New_Basu_v4_JAR.sas:1018–1021`
Source SHA-256: `60b2aa05bf7957ca78abaeef4b7f695bcbeed601c192f9ff3bc81d9f4c5db528`

Use the configured project-root-relative output folder while preserving the Stata format, final dataset and sample2017JAR.dta basename. Create the output directory before a future run; no source edit was applied during this assessment.

Current text:
```
PROC EXPORT DATA= AT.sample2017JAR
            OUTFILE= "[redacted-path-d746d7c09bbe]" 
            DBMS=STATA REPLACE;
RUN;
```

Proposed replacement:
```
PROC EXPORT DATA= AT.sample2017JAR
            OUTFILE= "output/sample2017JAR.dta"
            DBMS=STATA REPLACE;
RUN;
```

Preparation / proposed procedure:

1. Set the local SAS working directory to the project root and create its output directory.
2. Apply only the proposed OUTFILE path change in a working copy; retain PROC EXPORT data, DBMS and REPLACE options exactly.

Validation to perform later:

- Confirm the SAS host resolves the relative path under the configured project root and that the output directory is writable before any separately authorized run.

### ACT-VERIFY-LOCAL-ROUTES: Reconcile the author's distinct prepared Compustat, daily CRSP, monthly CRSP, stock-header and PIN inputs against the exact local candidates and bounded column checks, without treating readable headers as vintage or historical coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-COMPUSTAT-PERM, REQ-FUNDA, REQ-CRSP-DSF, REQ-CRSP-MONTHLY, REQ-CRSP-1950-2017, REQ-CRSP-HEADER, REQ-PIN
Evidence: E-CATALOG-CANDIDATES, E-PROBE-FUNDA, E-PROBE-DSF, E-PROBE-MSF, E-DOC-SOURCES, E-SAS-REMOTE, E-SAS-FUNDA, E-SAS-PIN-EXPORT, E-PACKAGED-IDENTIFIERS, E-SAS-HEADER, E-CATALOG-FUNDA-FIELDS

Preparation / proposed procedure:

1. For COMP.FUNDA, CRSP.DSF and CRSP.MSF, retain the confirmed source-column names and verify actual required history, product vintage, key/date compatibility and population before selecting them.
2. For AT.Compdata_perm, obtain the author-prepared linked source or its exact producer/join contract, including PERMNO and industry-field sources; COMP.FUNDA alone does not provide that link.
3. Identify the source and history for AT.crspbegdates (PERMNO/begprc), the separate monthly roles GLOPREM.CRSP2019 and AT.CRSP1950_2017, and the PIN file fields/key/population.
4. Treat sample_identifiers.xlsx as an identifier list only; it does not close the author panel input.

Validation to perform later:

- Use only bounded metadata/readability checks for exact catalog-listed files; establish history and population from supported source documentation or a coverage confirmation before marking any route verified.

### ACT-SOURCE-CONTRACTS: Resolve the specific CFORES regression-input and UCCACCmve grouping contracts and verify the exact DBMS=STATA compatibility without changing specified analyses or substituting inferred inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-CFORES-INPUT, ISS-UCCACCMVE-GROUP, ISS-EXPORT-DBMS
Evidence: E-SAS-CFORES-INPUT, E-SAS-UCCACCMVE-GROUP, E-SAS-PIN-EXPORT, E-PUB-ACCESS-DTA

Preparation / proposed procedure:

1. Confirm whether the CFORES regression should consume compdatacfoa or the currently named compdata and which prior FCF screen, if any, is intended.
2. Confirm the intended SIC2/FYEAR grouping for the UCCACCmve estimation step.
3. Verify DBMS=STATA against the exact configured SAS/ACCESS maintenance release; retain the Stata output format and basename.

Validation to perform later:

- Record author/source confirmation or exact release documentation before proposing any source change; do not execute or patch the author program in this assessment.

### ACT-SAS-RUNTIME: Resolve the existing TKELS initialization failure and verify the SAS runtime/components required by the supplied program. The failed startup does not establish absent licensing, and no SAS retry or author-code run was performed in this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS-BASE, SW-SAS-CONNECT, SW-SAS-STAT, SW-SAS-ACCESS-PCFILES, ISS-SAS-RUNTIME
Evidence: E-ENVIRONMENT, E-PUB-CONNECT, E-PUB-STAT, E-PUB-ACCESS-LICENSE, E-PUB-ACCESS-DTA

Preparation / proposed procedure:

1. Use a functioning SAS 9.4 TS1M8 runtime on the intended host and verify Base SAS, SAS/CONNECT, SAS/STAT and SAS/ACCESS Interface to PC Files availability through the site configuration.
2. Confirm that the actual PROC EXPORT DBMS token is supported by that installed release.
3. Keep software capability verification separate from data-route, WRDS authentication and %winsor macro-source questions.

Validation to perform later:

- Record runtime/component evidence before any separately authorized full-workflow attempt; no author code or data are part of a software check.

### ACT-RUN-PROCEDURE: Use the supplied SAS program as one ordered full-pipeline procedure after the named inputs, source-order/history contracts, SAS components and unresolved code contracts are verified; preserve all authored branches and generated handoffs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ-COMPUSTAT-PERM, REQ-CRSP-DSF, REQ-CRSP-MONTHLY, REQ-FUNDA, REQ-CRSP-HEADER, REQ-CRSP-1950-2017, REQ-PIN, ISS-WRDS-SETUP, ISS-SOURCE-ORDER-HISTORY, ISS-OUTPUT-PATH
Evidence: E-WORKFLOW-TRACE, E-SAS-ENTRY, E-SAS-REMOTE, E-SAS-COMPUSTAT-RET, E-SAS-FUNDA, E-SAS-CRSP-RETURNS, E-SAS-CFORES-INPUT, E-SAS-UCCACCMVE-GROUP, E-SAS-QBM-RANK, E-SAS-PIN-EXPORT, E-RANK-ORDER-REVIEW, E-PUB-RANK-GROUPS, E-PUB-RANK-BY

Preparation / proposed procedure:

1. Set the local SAS working directory to the project root; configure writable project/staging AT for verified compatible author inputs and generated AT outputs, keep common catalog source libraries separate/read-only, and assign GLOPREM to its verified monthly input. Read AT.Compdata_perm into AT.PERMNOGVKEY2017 with the source OBS=900000 cap and INDFMT=INDL filter, derive date windows, and sort by PERMNO/DATADATE.
2. Run the authored WRDS SIGNON/RSUBMIT stage using the named MYDATA root only if authorized, otherwise a user-authorized remote workspace: upload the mapping to MYDATA.PERMNOGVKEY2017; create MYDATA.PERMNOS with FYEAR>1961; query remote CRSP.DSF into WORK.BAS_DVOLAT; sort to MYDATA.RAWBASDVOLAT2017; download to AT.RAWBASDVOLAT2017; then build AT.BAS_STDRET_2017 locally with the 125-observation thresholds.
3. Run the litigation-proxy block using its separate capped AT.Compdata_perm read and GLOPREM.CRSP2019, producing AT.litig after the source-defined return, skewness, lag and %winsor steps.
4. Run the main capped AT.Compdata_perm read; prepare DPW from AT.Funda1950_2017; merge it into comp0; then use AT.crspbegdates and AT.bas_stdret_2017 before computing the AT.CRSP1950_2017 return windows and 12-observation screen.
5. Continue through all supplied derived-variable and %winsor calls, industry-year residual blocks, CFO/FCF persistence stages, CFORES, ranked portfolios, unexpected-return/spread construction and the final main-sample merge. Resolve the CFORES input and UCCACCmve group contracts before changing those blocks; retain the supplied rank sequence, whose BY ordering is statically reconciled from the ascending QSIZE_lag producer.
6. Merge AT.Pins_1983_2004 using the supplied DATA data AT.sample2017JAR multi-output statement; merge ADDLVARS from AT.Funda1950_2017; merge PLIT2_LAG from AT.litig; export the result to output/sample2017JAR.dta under the configured project root after confirming DBMS compatibility.

Validation to perform later:

- At each handoff, check that the named producer exists with the keys and columns required by its next consumer and that its source-order/history contract is satisfied.
- After separate full-run authorization, confirm that the final Stata file is written at the configured relative path and retains the expected sample name and required merged fields.


## Remaining issues and prerequisites

- ISS-WINSOR-MACRO [unresolved; full_pipeline]: The supplied SAS source calls %winsor at lines 150, 515-520 and 982, but contains no definition or include. The exact call-specific transformations (including type=winsor, pctl=1 99, variables, and byvar present or absent) must be preserved. A configured SAS system/site autocall macro may exist; its resolution and semantics were not verified, so no substitute or confirmed runtime blocker is asserted.
- ISS-WRDS-SETUP [unresolved; full_pipeline]: The source supplies WRDS host/port, TCP SIGNON with prompted username, RSUBMIT/ENDRSUBMIT, an authored MYDATA default root of [redacted-path-e1f3f7c8b9f7], and the upload → CRSP.DSF query → download sequence. Those mechanics/order are known. Configure MYDATA to an authorized user-owned WRDS workspace if the authored default is not authorized; no third-party home-directory access is a prerequisite. Local AT/GLOPREM assignments, actual credentials, SAS/CONNECT availability and source-table compatibility remain unverified.
- ISS-SOURCE-ORDER-HISTORY [unresolved; full_pipeline]: The three AT.Compdata_perm reads apply OBS=900000 at lines 11, 78 and 167 with distinct KEEP/WHERE rules. The first mapping output is then sorted by PERMNO/DATADATE, while other lag constructions consume source rows in their existing order; AT.Funda1950_2017 also feeds lags and BY merges. The required native ordering and pre-sample history for each source remain unverified. Preserve every cap, its placement, filter and downstream order.
- ISS-OUTPUT-PATH [preparation; full_pipeline]: The final PROC EXPORT targets the machine-specific [redacted-path-d746d7c09bbe] path. Select the project working directory and set a writable relative output folder while preserving the sample2017JAR.dta basename and Stata handoff.
- ISS-SAS-RUNTIME [unresolved; full_pipeline]: The frozen SAS runtime probe failed to initialize TKELS (return code 1). This leaves the SAS runtime and SAS/CONNECT, SAS/STAT and SAS/ACCESS component availability unverified; it does not establish a missing license. No author code or data were run.
- ISS-CFORES-INPUT [unresolved; full_pipeline]: The CFORES branch creates compdatacfoa using the CFOA*CFOA_lag screen, then PROC REG reads compdata. The immediately preceding FCF persistence block also creates compdata with an FCF*FCF_lag screen. Confirm the intended regression input and preserve the supplied code until author/source evidence resolves it.
- ISS-UCCACCMVE-GROUP [unresolved; full_pipeline]: The UCCACCmve PROC SQL step applies HAVING and orders by SIC2/FYEAR without an explicit GROUP BY, followed by a PROC REG BY SIC2 FYEAR. Confirm the intended group construction; do not infer or insert a grouping clause.
- ISS-EXPORT-DBMS [unresolved; full_pipeline]: The source specifies PROC EXPORT DBMS=STATA. Official SAS/ACCESS 9.4 documentation provides a DBMS=DTA example, but does not establish that STATA is rejected or accepted by the exact configured maintenance release. Verify the local runtime and retain a specific compatibility question; do not change the format without evidence.
- REQ-COMPUSTAT-PERM [undetermined]: The author-prepared Compustat/CRSP firm-year input AT.Compdata_perm used for the identifier mapping, litigation proxy, and main panel. Three separate reads at lines 11, 78 and 167 each retain OBS=900000 with their own filters. Required source columns include PERMNO and industry fields as well as the Compustat variables used downstream; preserve each read’s native row order and cap placement. Catalog COMP.FUNDA overlaps accounting columns but its catalog metadata lacks PERMNO and SIC; the package supplies no producer or supported link/industry merge specification for AT.Compdata_perm.
- REQ-CRSP-DSF [undetermined]: CRSP daily stock-file observations used on WRDS to derive annual bid-ask spread and return volatility for the mapping sample, with the code's daily window and 125-observation threshold.
- REQ-CRSP-MONTHLY [undetermined]: The distinct GLOPREM.CRSP2019 monthly CRSP table used to build the litigation-proxy return, volatility, turnover, and skewness inputs.
- REQ-FUNDA [undetermined]: The separate additional Compustat annual input AT.Funda1950_2017, read for DPW accrual components and again for PPENT/INTAN/CAPX/SPPE/AQC, with the source and lag history required by those calculations.
- REQ-CRSP-HEADER [undetermined]: CRSP Stock Header Information supplying each PERMNO's first price date for the firm-age variable.
- REQ-CRSP-1950-2017 [undetermined]: The distinct raw CRSP return input AT.CRSP1950_2017 used to form annual and 12-month return measures for the main firm-year sample.
- REQ-PIN [undetermined]: The Duarte/Young PIN firm-year scores merged into the final sample for 1983-2004.
- SW-SAS-BASE [unverified]: The documented command is sas_u8. The frozen startup probe returned 1 with a TKELS initialization failure, so a working SAS runtime and exact release are not established. The supplied program uses DATA steps, PROC SQL, SORT, MEANS, RANK and CORR; PROC REG and remote transfer requirements are recorded separately.
- SW-SAS-CONNECT [unverified]: The source uses SIGNON, RSUBMIT, PROC UPLOAD and PROC DOWNLOAD. Official documentation establishes the sign-on mechanism, but local SAS/CONNECT availability and credentials are unverified.
- SW-SAS-STAT [unverified]: The supplied program uses PROC REG to estimate industry-year unexpected-measure and persistence models. Official SAS documentation attributes PROC REG to SAS/STAT; the local runtime did not initialize, so component availability remains unverified.
- SW-SAS-ACCESS-PCFILES [unverified]: The final output uses PROC EXPORT DBMS=STATA. Official SAS/ACCESS documentation shows a DBMS=DTA example and describes the PC Files license boundary; local component availability and whether STATA is accepted by the target maintenance release remain unverified.

## Review notes

- Scope is the single supplied SAS full pipeline through the Stata-format export. The complete cached datasheet and 1,023-line SAS source, the full cached online appendix text, and the identifier workbook inspection were reviewed. The separate synthetic-returns program mentioned in the datasheet is contextual because the supplied selected entry point does not call it; no analysis-only scope is supported.
- The supplied identifier workbook is a boundedly readable gvkey/fyear identifier list, not a firm-year analysis panel and not a data input read by the SAS entry point.
- Frozen-catalog token searches identified exact local COMP.FUNDA, CRSP.DSF and CRSP.MSF candidates; earlier descriptive multiword searches returned no hits and are retained as uninformative history. Bounded one-row reads confirm readability and requested columns only. History, vintage, population, key mapping and source-order compatibility remain unverified. COMP.FUNDA catalog metadata lacks PERMNO and SIC, and no compatible AT.Compdata_perm link/industry producer is supplied. CRSP header and PIN compatibility remain unresolved.
- The code has three distinct OBS=900000 reads of AT.Compdata_perm at lines 11, 78 and 167, with different filters; all placements, native input-order dependence, lag history and source-defined return windows are retained. The source supplies WRDS host/port, TCP SIGNON, prompted username, RSUBMIT, MYDATA default path and upload/query/download order. Configure AT as writable project staging for compatible author inputs and outputs; keep common catalog source libraries read-only. MYDATA is user-authorized/configurable. Authentication, runtime and input contracts remain unverified.
- The three %winsor calls and their original variables, pctl=1 99, type=winsor and byvar choices are preserved. No definition/include is in the supplied release; a configured SAS autocall capability remains unverified, so no substitute is proposed.
- Unresolved source contracts are limited to the CFORES producer/input mismatch, UCCACCmve grouping, PROC EXPORT DBMS=STATA compatibility with the target SAS maintenance release, SAS runtime/component startup, and the specific input/order/history requirements recorded in the draft. The apparent QBM sort-key mismatch is reconciled statically from the ascending QSIZE_lag producer and official PROC RANK GROUPS/BY documentation; no rank test or source edit was performed.
- Official SAS documentation supports the supplied SIGNON requirement, PROC REG attribution to SAS/STAT, the PC Files license boundary and a DBMS=DTA example. This documentation does not establish local entitlement, installed components, or DBMS=STATA alias support. The bounded web request could not fetch the author-cited PIN URL; that failure does not establish global unavailability and the PIN route remains unverified.
- The frozen environment probe recorded a SAS TKELS initialization failure with return code 1. No SAS startup retry, author program execution, dataset traversal, estimator, optimizer, simulation, installation, download, contact or applied code patch was performed.
