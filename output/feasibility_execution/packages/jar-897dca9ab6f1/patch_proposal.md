# Patch proposal: jar-897dca9ab6f1

Strategic Subsidiary Disclosure

DOI: 10.1111/1475-679X.12308

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented data preparation and merge workflow for this release: supplied partial SAS variable and Exhibit 21 preparation blocks plus the referenced IRS-linked assembly route. The public package does not contain a complete driver or IRS-only branch; paper-wide regression programs are contextual and are not independently reconstructed.

Entry points: `DHLW Notes on Compustat, etc. Variables and Merging.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 3/12308 - Strategic-Subsidiary-Disclosure/dhlw-datasheet-and-code.zip",
      "sha256": "94ac400d7d503d982bcca27f05906785e4944f20258dad96a8fb05cd86fee4db"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "0ba105b9ff66377e46a9aa9559093d5f875f6b0f42063da36916fd5f1e723d51"
}
```

## Proposed actions

### A_COMPLETE_DRIVER: Close the partial preparation and identifier handoffs using author-specified source contracts. Preserve the supplied country mapping and the author-prepared Exhibit 21 route. Do not guess table names, field aliases, period extensions or missing SAS source.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INCOMPLETE_DRIVER, I_COUNTRY_HANDOFF, I_HISTORY_HANDOFF, I_SALE_FNCD, R_COMP_FUNDA, R_COMP_FUNDA_FNCD, R_CRSP_COMPHIST, R_EX21_DATA, R_COUNTRY_MAP, R_FF48_MAP
Evidence: E_SAS_FUNDA, E_SAS_FUNDA_FNCD, E_SAS_COMPHIST, E_SAS_EIN_FALLBACK, E_SAS_EX21_INPUT, E_SAS_EX21_PRODUCER, E_SAS_EX21_FINAL, E_SAS_SICH, E_SAS_ROA_LAG, E_MAP_INSPECTION, E_DS_EX21_URL

Preparation / proposed procedure:

1. Complete the driver with a compatible implementation once the author field, history and construction contracts are known: fill the COMP.FUNDA keep list, complete the DATA ; SET ; stage, name the input/output tables and specify each producer-consumer handoff, including the second RSUBMIT block.
2. Use the supplied CRSP.COMPHIST date-valid join once its placeholder input/output names and compatible history coverage are resolved. Preserve the stated earliest-available historical-ID rule. Apply the author-specified Exhibit 21 EIN fill-in and consider the EIN-header source only as a conditional fallback for records still lacking EIN after those steps, with its source contract and precedence confirmed. Produce historical IDs and the control-variable table before the Exhibit 21 final consumer.
3. Resolve the source and join keys for sale_fn from the author-noted comp.funda_fncd product; do not infer sale_fn from the readable COMP.FUNDA table.
4. Preserve Country mapping.xlsx as the supplied lookup. Confirm whether it is manually applied or imported, its relationship to the inline country_name_final_ex21 normalization, and the exact key passed into the IRS merge.
5. If the study workflow uses the cited Exhibit 21 file, use the prepared country31june2019 input and verify its actual fields before running the supplied country normalization. Keep the generated chain ex21.country31june2019_dhlw → subs0 → subs1/dups → subs2 → ex21firm_country_yr; the last stage also needs the named control dataset and CIK key.
6. Specify the SIC backfill/forward-fill history and the author’s SIC-to-Fama–French 48 mapping/version; retain all years necessary for the stated operations without guessing a minimum.
7. Clarify where atm1 is produced and whether an observation at fyear 1990 is part of the analysis; if it is, supply the preceding fiscal-year at input needed for that observation.

Validation to perform later:

- Before a separate authorized run, statically match every consumed field, table and join key to the author-specified contracts; verify the country-name mapping and history rules without replacing them.
- After an authorized run, confirm each named intermediate has the expected columns and firm-country-year keys before its consumer executes.

### A_AUX_INPUTS: Resolve the actual non-IRS source products and field/key transformations while retaining readable common local candidates and the authors’ stated measures.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_AUX_HANDOFF, R_IBES_ANALYSTS, R_CCMXPF_LINK, R_RAVENPACK_ARTICLES, R_AA_COMMENT_LETTERS, R_AA_RESTATEMENTS
Evidence: E_DS_VENDORS, E_SAS_IBES, E_SAS_RAVENPACK, E_SAS_AUDIT, E_IBES_US_PROBE, E_IBES_INT_PROBE, E_CCMXPF_PROBE, E_RP_2015_PROBE, E_RP_MAP_PROBE, E_AA_COMMENTS_PROBE, E_AA_RESTATEMENTS_PROBE, E_CATALOG_QUERIES

Preparation / proposed procedure:

1. For I/B/E/S, name the author-selected summary file, region/adjustment family and required history; show how TICKER becomes the PERMNO consumed by the merge and preserve FPEDATS=Compustat DATADATE. The local STATSUMU_EPSUS candidate is readable and contains NUMEST/FPEDATS, but it does not supply the required PERMNO directly.
2. For RavenPack, identify the exact file years/product and the author-defined procedure that produces number_of_articles by fiscal year and ticker, including the ticker/entity mapping and whether repeated stories are deduplicated. The bounded probe timeout leaves the local raw-file candidate unverified.
3. For Audit Analytics, identify the comment-letter and restatement input fields, historical-CIK company mapping, study-year coverage and the rule for any restated portion of a fiscal year announced in a subsequent period. Use the local feed candidates when they match; a timeout or one-row sample is not a license or coverage finding.
4. Do not add an independent current-entitlement gate for readable common Compustat, I/B/E/S, CRSP or Audit Analytics files. Keep actual field, period, ID and construction gaps explicit; do not substitute a different vendor product.

Validation to perform later:

- Before a separate authorized run, verify the chosen source fields, identifiers and history against the author contracts; compare produced numest, article-count, comment-letter and restatement firm-year columns with the consuming merge.

### A_PRS_INPUT: Resolve the exact PRS political-risk product, data field, units, frequency and country-year matching contract before acquiring or substituting any risk series.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PRS_RISK
Evidence: E_DS_PRS, E_SAS_POLITICAL_RISK, E_PUBLIC_PRS

Preparation / proposed procedure:

1. The authors report PRS data obtained around August 2017. The official PRS page describes subscription access to historical ICRG data, but the source file and political_risk_index mapping are not identified.
2. Use only the author-specified PRS field/product and an already authorized source route if available; do not substitute a different risk provider or infer current access from the historical datasheet.

Validation to perform later:

- Verify the selected historical series has the author-required country keys, years, scale and frequency before joining it to the firm-year panel.

### A_IRS_INPUT: The public release cannot define the Form 5471 branch because its data field names and programs are withheld. The documented historical restriction is preserved without inferring current user eligibility or access denial.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_IRS_BRANCH, R_IRS_5471
Evidence: E_DS_IRS_RESTRICTION, E_DS_IRS_SHARED, E_SAS_IRS_FORMULAS, E_SAS_IRS_COUNTRY, E_SAS_EIN_FALLBACK

Preparation / proposed procedure:

1. If this study is run in an already IRS-approved project setting, use only the inputs and programs permitted in that setting and obtain a non-sensitive table/field and merge-key specification sufficient to account for the documented Form 5471, EIN and country steps.
2. Keep the actual IRS variable formulas, dataset names and output schema unresolved until the approved author workflow supplies them; do not infer names from the published labels or seek private files as part of this review.

Validation to perform later:

- Before any separately authorized run, confirm the permitted IRS input/program scope and reconcile its identifiers and period with the documented CIK/EIN/country merge.

### A_SAS_RUNTIME: Establish a host-side batch SAS runtime and SAS/CONNECT configuration for the supplied remote-submit workflow. Current runtime operation is unverified after the recorded TKELS initialization failure.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_REMOTE_SAS, S_SAS, S_SAS_CONNECT
Evidence: E_ENVIRONMENT, E_SAS_FUNDA, E_SAS_COMPHIST

Preparation / proposed procedure:

1. For any separately authorized run, use the documented host SAS batch wrapper from a host-visible, writable relative execution root or [redacted-path-498c78f9b827] path, preserve the author directory structure, and avoid absolute Dropbox paths in executable configuration.
2. Configure the documented RSUBMIT remote session and verify the exact SAS 9.4 runtime and SAS/CONNECT component on the host; the existing launch diagnostic is not a license finding.

Validation to perform later:

- Before running the author program, confirm runtime version, remote-submit configuration, and visibility/writability of each input and output directory on the host.

### A_ORDERED_PROCEDURE: After all listed inputs, the missing driver and runtime configuration are resolved, follow this ordered author workflow without changing the analyses.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_SAS_FUNDA, E_SAS_COMPHIST, E_SAS_EX21_INPUT, E_SAS_EX21_PRODUCER, E_SAS_SUBS0, E_SAS_SUBS1, E_SAS_SUBS2, E_SAS_EX21_FINAL, E_SAS_IBES, E_SAS_RAVENPACK, E_SAS_AUDIT, E_SAS_EIN_FALLBACK

Preparation / proposed procedure:

1. Initialize the authorized SAS/CONNECT host session and documented library assignments. Resolve the full driver, required source contracts, input/output paths and table schemas before starting.
2. Read COMP.FUNDA into cdata_raw with the supplied keep list and active fyear 1990–2015, INDL/STD/D/C/USD, positive-assets/sales and nonmissing-NI filters; keep the FIC=USA condition inactive as shown. Retain the prior-year at needed for atm1 if it precedes the analysis observations; the sample start is unspecified.
3. Produce historical CIK/EIN values from the supplied CRSP.COMPHIST SQL fragment before any historical-ID consumer: join on GVKEY and retain the date-valid HCHGDT ≤ DATADATE ≤ HCHGENDDT condition. Resolve the /INSERT DATASET/ input/output placeholders and required coverage, and preserve the stated earliest-available historical fallback.
4. Prepare the other required source outputs before their consumers: resolve sale_fn from the author-named function-code source, SIC backfill/forward-fill and FF48 mapping, I/B/E/S numest with its PERMNO link and FPEDATS = Compustat DATADATE alignment, RavenPack article counts by fiscal year/ticker, Audit Analytics comment-letter and restatement inputs (historical CIK is stated for comment letters; restatement company/date mapping is unresolved), and PRS country-year values. Keep each actual source field, history and join contract unresolved until specified.
5. Complete the named control-variable table from COMP.FUNDA, the supplied variable-construction blocks and the resolved producers in steps 3–4. Resolve the incomplete DATA ; SET ; block and output table/column names; preserve every supplied control and non-IRS variable branch. Defer IRS-dependent constructs to the IRS stage.
6. Supply the author-prepared country31june2019 Exhibit 21 input and preserve the provided Country mapping.xlsx. Run the supplied chain: country normalization to ex21.country31june2019_dhlw → grouped country counts in subs0 → sort/deduplicate into subs1 while retaining dups → date alignment in subs2.
7. Only after the historical-ID output and control-variable table exist, join subs2 to the named control table using the author-specified CIK and datadate_ex21 = datadate conditions to produce ex21firm_country_yr. Resolve the placeholder CIK expression and table names without guessing aliases. Preserve the author-specified Exhibit 21 EIN fill-in for missing historical EINs; an EIN-header file is only a conditional fallback for rows still lacking EIN if its contract and precedence are confirmed.
8. After the completed Exhibit 21/control/historical-ID handoffs, merge the combined data to the Form 5471/IRS branch on the author-specified EIN and year/month rules, and complete IRS-derived measures only within the permitted approved workflow. Preserve the historical restriction as evidence about confidential inputs and omitted code, not as a finding about current-user grant or automatic current access denial.
9. Keep all supplied SAS branches in the procedure. The public package contains no paper-wide regression program, so treat those estimators as contextual and do not independently reconstruct them.

Validation to perform later:

- Before a separately authorized run, statically match each producer output to its actual consumer: historical CIK/EIN and control table before Exhibit 21 final join; all auxiliary source outputs before their variable/merge consumers; completed Exhibit 21/control/history before the IRS merge.
- After a separately authorized run, check the named tables, fields, keys, labels and fiscal-year/date columns at each handoff; retain the generated ex21.country31june2019_dhlw → subs0 → subs1/dups → subs2 → ex21firm_country_yr chain and execution remains unverified until the full workflow is run.

### A_FNCD_COMMENT_SEMICOLON: Add the missing SAS statement-comment terminator at line 103. This ends the comment before the supplied sale_fn IF/ELSE chain; it does not supply the separate sale_fn producer.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SALE_FNCD_COMMENT
Evidence: E_SAS_FUNDA_FNCD, E_SAS_COMMENT_RULE

**Proposed edit:** `DHLW Notes on Compustat, etc. Variables and Merging.sas:103–103`
Source SHA-256: `75fd85219999057612325fad9ac2ca01f9efc0c841bee794d3053f48b4efe270`

SAS asterisk statement comments terminate at a semicolon. Without a terminator here, the semicolon on line 104 is swallowed as part of the comment, so the first IF is not active and the ELSE IF on line 105 is unmatched. Adding one semicolon restores the comment boundary without changing the indicator logic; the sale_fn producer remains unresolved.

Current text:
```
*data from from comp.funda_fncd
```

Proposed replacement:
```
*data from from comp.funda_fncd;
```

Preparation / proposed procedure:

1. In a working copy of the frozen SAS source, add exactly one semicolon after the line 103 comment text; do not apply or execute the edit during this assessment.
2. Keep the actual sale_fn source, firm-year join key and coverage as a separate unresolved contract under I_SALE_FNCD.

Validation to perform later:

- Before any separately authorized run, confirm the comment ends at line 103 and the supplied IF/ELSE chain is active, then verify sale_fn provenance and join keys against the resolved source contract.


## Remaining issues and prerequisites

- I_INCOMPLETE_DRIVER [unresolved; full_pipeline]: The supplied SAS attachment is substantive partial preparation/merge code, but it has an empty DATA ; SET ; block, a missing keep-list, placeholder input/output table names and no explicit producer for the control-variable table consumed by the final join. The second RSUBMIT block’s remote-session closure and execution order are not shown. Do not treat the attachment as a complete executable driver.
- I_IRS_BRANCH [unresolved; full_pipeline]: Form 5471 data and IRS-only variable programs are required by the documented workflow but are not in this public package. The cited restrictions are historical limits on publication and IRS-approved access; they do not establish this user’s current grant, retention, eligibility or an automatic current access barrier. Exact IRS fields, schemas and producers remain unresolved.
- I_COUNTRY_HANDOFF [unresolved; full_pipeline]: Country mapping.xlsx is supplied and readable, but no supplied program reads it or identifies how its IRS_COUNTRY_NAME/EX21_COUNTRY_NAME/Country_Name_Final columns feed the withheld IRS merge. The SAS attachment separately creates country_name_final_ex21 using inline Exhibit 21 normalization; the join between those keys is unspecified.
- I_HISTORY_HANDOFF [unresolved; full_pipeline]: A CRSP.COMPHIST read and GVKEY/date-valid historical CIK/EIN join are supplied in RSUBMIT SQL, and the notes specify an earliest-available historical fallback. The input/output dataset names, compatible current history and coverage, concrete fallback implementation, and producer of the control-variable table consumed by the Exhibit 21 final join remain unresolved. The notes also specify Exhibit 21 EIN fill-in and a conditional EIN-header fallback if EIN remains unavailable; the exact source contract and precedence need clarification. The author defines atm1 as prior-year assets while the raw Compustat query begins at fyear 1990; whether fyear 1990 is analyzed and where prior-year history is retained are unknown. Missing-SIC backfill/forward-fill periods are unspecified.
- I_SALE_FNCD [unresolved; full_pipeline]: The supplied merger/acquisition block consumes sale_fn and comments that it comes from comp.funda_fncd, but the function-code file is not read, the frozen catalog query has no exact match, and no join key or producer is supplied. COMP.FUNDA’s readable schema does not establish that this field is there. The separate missing comment terminator and its minimal source repair are recorded under I_SALE_FNCD_COMMENT.
- I_AUX_HANDOFF [unresolved; full_pipeline]: The required I/B/E/S numest merge, RavenPack number_of_articles firm-year input and Audit Analytics comment-letter/restatement firm-year variables lack complete source-to-analysis handoffs. The local catalog provides candidates and bounded probes, but exact product choices, identifier/date crosswalks, annual construction and historical coverage are not all verified. Readable common resources are not treated as independently unlicensed.
- I_REMOTE_SAS [unresolved; full_pipeline]: The code requires RSUBMIT processing. The environment probe did not establish a working SAS session because TKELS failed to initialize, and no SAS/CONNECT remote session details are included. Component availability remains unverified, not blocked.
- I_SALE_FNCD_COMMENT [preparation; full_pipeline]: At source line 103, the asterisk statement comment has no terminating semicolon. Under SAS comment syntax, it continues through the first semicolon on line 104, swallowing the first sale_fn IF statement and leaving the following ELSE IF unmatched. A single semicolon after the comment text is a supported minimal repair. This repairs the statement boundary only; the sale_fn raw producer and join contract remain unresolved under I_SALE_FNCD.
- R_IRS_5471 [undetermined]: Confidential Form 5471/IRS tax-return inputs and their withheld IRS-only producers, used for undisclosed-country/assets, country-asset, foreign-subsidiary and related tax constructs. The public release does not name the IRS fields, schemas or full program.
- R_COMP_FUNDA [undetermined]: Annual Compustat fundamentals read as COMP.FUNDA: firm keys, fiscal year/date, screening fields and the variables consumed by the supplied control-variable blocks. Active filters specify fyear 1990–2015, INDL/STD/D/C/USD, positive assets/sales and nonmissing NI; the USA-only FIC filter is commented out. The keep list is a placeholder; exact prior-year coverage for ROA is unresolved.
- R_COMP_FUNDA_FNCD [undetermined]: Compustat function-code input for sale_fn, which the supplied merger/acquisition block consumes; the source comment names comp.funda_fncd but gives no read, producer or join keys.
- R_CRSP_COMPHIST [undetermined]: CRSP company-history input for historical CIK/EIN values and effective dates. The supplied SQL reads CRSP.COMPHIST, joins on GVKEY and applies the date-valid condition using HCHGDT and HCHGENDDT; it also states an earliest-available historical fallback. The exact input/output table names, compatible current history and coverage, and the producer of the control-variable table remain unresolved. After the author-specified Exhibit 21 EIN fill, an EIN-header source is only a conditional fallback for rows still lacking EIN if its contract and precedence are confirmed.
- R_EX21_DATA [undetermined]: Author-prepared Exhibit 21 country31June2019 dataset, assembled June 25, 2019, used to build country-firm-year subsidiary records and support the IRS merge. The supplied code expects CIKNUMBER, IRSNUMBER, NAME, DATADATE, FILEDATE, country names and country counts.
- R_FF48_MAP [undetermined]: Author-specified SIC to Fama–French 48 industry classification mapping required by the note following the Compustat extraction; the mapping version, values and producer are not included.
- R_IBES_ANALYSTS [undetermined]: I/B/E/S analyst-count input used as numest and aligned by forecast-period end date to Compustat datadate. The author-selected summary family, region, frequency and source-to-PERMNO construction are not supplied.
- R_CCMXPF_LINK [undetermined]: CRSP/Compustat Link History table referenced for the analyst coverage PERMNO merge; required link keys and effective-date semantics must match the author branch.
- R_RAVENPACK_ARTICLES [undetermined]: RavenPack source required to produce number_of_articles by fyear and ticker for the media-coverage measure; exact article product, ticker mapping, annual aggregation and years are not specified.
- R_AA_COMMENT_LETTERS [undetermined]: Audit Analytics SEC comment-letter input merged by historical CIK and fiscal year, with missing observations set to zero according to the author notes. Exact company/date mapping and period are not provided.
- R_AA_RESTATEMENTS [undetermined]: Audit Analytics restatement input to flag a firm-year if any part of the year was restated, as announced in a subsequent period. Company mapping, lookahead/announcement timing and full period are not specified.
- R_PRS_RISK [undetermined]: Political risk data attributed by the authors to Political Risk Services and used as political_risk_index. The exact PRS product/table, frequency, country-key mapping and variable scale are not supplied.
- S_SAS [unverified]: The supplied code uses SAS DATA steps, PROC SQL, PROC SORT, INTNX and remote-submit syntax. The supplied SAS 9.4 environment probe failed to initialize TKELS, so SAS version/runtime operation is unverified; this is not a license denial.
- S_SAS_CONNECT [unverified]: The code uses RSUBMIT/ENDRSUBMIT remote processing, but no remote host/session configuration or SAS/CONNECT availability is established. PROC SQL and PROC SORT alone do not establish SAS/STAT use.

## Review notes

- All seven frozen dependency IDs are explicitly reviewed. D0004 is produced by the supplied Exhibit 21 normalization, and D0005–D0007 are the supplied subs0→subs1→subs2 WORK chain; these are generated intermediates, not separate external files.
- The author-prepared Exhibit 21 route and the supplied Country mapping.xlsx workbook are preserved as different inputs. The workbook inspection is read-only and did not recalculate the workbook; its four headers are on row 2 and it contains 258 mapping rows.
- Common catalog candidates were searched by product and dataset ID. Successful one-row reads verify only exact-file readability and columns; RavenPack and Audit Analytics comment-letter probes timed out, which is not evidence of absence or entitlement. No full-data scan, author-code execution, download, install, workbook recalculation or source edit was performed.
- IRS restrictions are described as historical publication/access conditions only. Current user authorization, eligibility, retention and license were not researched or inferred. No private IRS files or secure facilities were accessed.
- No analysis-only scope is supported because the package supplies no prepared full analysis dataset and no estimation entry code. The paper-wide estimators remain contextual; this assessment does not reconstruct them.
