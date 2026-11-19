# Patch proposal: jar-c021c721c24c

Fraud Power Laws

DOI: 10.1111/1475-679X.12520

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: GeoPeer DID sample construction and analysis plus both total and v2 restatement amount-construction branches feeding the supplied restatement analysis. No separate analysis-only route or paper-wide stages are added.

Entry points: `GeoPeer_Step1_TreatmentConstruction.sas`, `GeoPeer_Step2_DIDAnalysis.do`, `Step0_restatement_dataprep_FZ_total.do`, `Step0_restatement_dataprep_FZ_v2.do`, `Step1_MisstatementAmount_Total.sas`, `Step1_MisstatementAmount_v2.sas`, `restatement_analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 3/12520 - Fraud-Power-Laws/ccz-datasheet-code-and-identifiers.zip",
      "sha256": "ceaf6120217e10eabf43b5bc40898dc0100f56387c6888b987ea468db9d07aea"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "4c67c3506f626eb1cda1dcfb35a1237e786248d63399e60c048d0dc2f604272e"
}
```

## Proposed actions

### A_PORTABILITY: Create a working copy with relative data roots and POSIX path separators while preserving every author input/output basename and both restatement branches.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PATHS
Evidence: E_GEOP_ROOT, E_GEOP_STATA_ROOT, E_STEP0_TOTAL_ROOT_DATA, E_STEP0_TOTAL_ROOT_OUTPUT, E_STEP0V2_ROOT_DATA, E_STEP0V2_ROOT_OUTPUT, E_STEP1_TOTAL_ROOT, E_STEP1_V2_ROOT, E_REST_ANALYSIS_ROOT, E_COMMON_PATH_POLICY, E_GEOP_SAS_PATH_TOTAL, E_GEOP_SAS_PATH_V2, E_GEOP_SAS_PATH_FISCAL, E_GEOP_SAS_PATH_HEADER, E_STEP1_TOTAL_PATH_CCMA, E_STEP1_TOTAL_PATH_AMOUNT, E_STEP1_TOTAL_PATH_OUTPUT, E_STEP1_V2_PATH_CCMA, E_STEP1_V2_PATH_AMOUNT, E_STEP1_V2_PATH_OUTPUT

**Proposed edit:** `GeoPeer_Step1_TreatmentConstruction.sas:22–22`
Source SHA-256: `cd7d073b2388c5f5989a5559a9934b579bc6339a603fbf4272665766401fde1d`

Use the agreed Data/20231110 working directory instead of an author Mac/Dropbox absolute path.

Current text:
```
%let path=[redacted-path-0b3a920b9375];
```

Proposed replacement:
```
%let path=.;
```

**Proposed edit:** `GeoPeer_Step2_DIDAnalysis.do:4–4`
Source SHA-256: `97dd61d97bad1aed6c47896f5603bc679504080ff9edecea2de0498b7370e6bb`

Use Data/20231110 as the working directory for the GeoPeer Stata consumer.

Current text:
```
global data "[redacted-path-10f39385a20a]"
```

Proposed replacement:
```
global data "."
```

**Proposed edit:** `Step0_restatement_dataprep_FZ_total.do:5–5`
Source SHA-256: `141b249a76d5a16fbfd9a54e53d2ef54f75216955e7df4c7a5724867b520b07c`

Run the total preprocessing branch from Data/Restatement so its datasets/ input resolves relatively.

Current text:
```
global data "[redacted-path-b5951645cdd7]"
```

Proposed replacement:
```
global data "."
```

**Proposed edit:** `Step0_restatement_dataprep_FZ_total.do:6–6`
Source SHA-256: `141b249a76d5a16fbfd9a54e53d2ef54f75216955e7df4c7a5724867b520b07c`

Write generated total outputs to the sibling Data/20231110 working directory.

Current text:
```
global output "[redacted-path-d63eaa0d068a]"
```

Proposed replacement:
```
global output "../20231110"
```

**Proposed edit:** `Step0_restatement_dataprep_FZ_v2.do:6–6`
Source SHA-256: `67a8e7deb506a7c35aa46d2579ca39229026a9652fd5f6781e257805589347e3`

Run the v2 preprocessing branch from Data/Restatement so its datasets/ inputs resolve relatively.

Current text:
```
global data "[redacted-path-b5951645cdd7]"
```

Proposed replacement:
```
global data "."
```

**Proposed edit:** `Step0_restatement_dataprep_FZ_v2.do:7–7`
Source SHA-256: `67a8e7deb506a7c35aa46d2579ca39229026a9652fd5f6781e257805589347e3`

Write generated v2 outputs to the same sibling Data/20231110 working directory.

Current text:
```
global output "[redacted-path-d63eaa0d068a]"
```

Proposed replacement:
```
global output "../20231110"
```

**Proposed edit:** `Step1_MisstatementAmount_Total.sas:7–7`
Source SHA-256: `25ebeaf513555563d1a03d9eff5a138b1cd573d83160b2920263aeff8644e956`

Use Data/20231110 as the shared folder for the total SAS amount branch.

Current text:
```
%let path=[redacted-path-0b3a920b9375];
```

Proposed replacement:
```
%let path=.;
```

**Proposed edit:** `Step1_MisstatementAmount_v2.sas:7–7`
Source SHA-256: `8dcfa156c685ced0e62882c08e839ea25ea87c098332cf09d7ff821dfff23334`

Use Data/20231110 as the shared folder for the v2 SAS amount branch.

Current text:
```
%let path=[redacted-path-0b3a920b9375];
```

Proposed replacement:
```
%let path=.;
```

**Proposed edit:** `restatement_analysis.do:4–4`
Source SHA-256: `432650be20547b4da1877fdb6289ab9475bd969293a092f604dcfd0010a2b9c2`

Use Data/20231110 as the working directory for the supplied restatement analysis.

Current text:
```
global path "[redacted-path-10f39385a20a]"
```

Proposed replacement:
```
global path "."
```

**Proposed edit:** `GeoPeer_Step1_TreatmentConstruction.sas:32–32`
Source SHA-256: `cd7d073b2388c5f5989a5559a9934b579bc6339a603fbf4272665766401fde1d`

Use a POSIX forward slash after the relative path macro while preserving the exact file name.

Current text:
```
proc import datafile="&path\comp_restate_total.dta" out=misstate_total replace; run;
```

Proposed replacement:
```
proc import datafile="&path/comp_restate_total.dta" out=misstate_total replace; run;
```

**Proposed edit:** `GeoPeer_Step1_TreatmentConstruction.sas:40–40`
Source SHA-256: `cd7d073b2388c5f5989a5559a9934b579bc6339a603fbf4272665766401fde1d`

Use a POSIX forward slash after the relative path macro while preserving the v2 branch input.

Current text:
```
proc import datafile="&path\comp_restate_v3.dta" out=misstate_amount replace; run;
```

Proposed replacement:
```
proc import datafile="&path/comp_restate_v3.dta" out=misstate_amount replace; run;
```

**Proposed edit:** `GeoPeer_Step1_TreatmentConstruction.sas:44–44`
Source SHA-256: `cd7d073b2388c5f5989a5559a9934b579bc6339a603fbf4272665766401fde1d`

Use a POSIX forward slash after the relative path macro while preserving the exact CSV name.

Current text:
```
proc import datafile="&path\restatement_fiscal_year_ends.csv" out=restatement_fiscal_year_ends dbms=csv replace; run;
```

Proposed replacement:
```
proc import datafile="&path/restatement_fiscal_year_ends.csv" out=restatement_fiscal_year_ends dbms=csv replace; run;
```

**Proposed edit:** `GeoPeer_Step1_TreatmentConstruction.sas:57–57`
Source SHA-256: `cd7d073b2388c5f5989a5559a9934b579bc6339a603fbf4272665766401fde1d`

Use a POSIX forward slash after the relative path macro while preserving the exact header file name.

Current text:
```
proc import datafile="&path\LM_EDGAR_10X_Header_1993-2021.dta" out=hq dbms=dta replace; run;
```

Proposed replacement:
```
proc import datafile="&path/LM_EDGAR_10X_Header_1993-2021.dta" out=hq dbms=dta replace; run;
```

**Proposed edit:** `Step1_MisstatementAmount_Total.sas:35–35`
Source SHA-256: `25ebeaf513555563d1a03d9eff5a138b1cd573d83160b2920263aeff8644e956`

Use a POSIX forward slash after the relative path macro while preserving the original Compustat input name.

Current text:
```
proc import datafile="&path\ccma_original.dta" out=comp dbms=dta replace; run;
```

Proposed replacement:
```
proc import datafile="&path/ccma_original.dta" out=comp dbms=dta replace; run;
```

**Proposed edit:** `Step1_MisstatementAmount_Total.sas:40–40`
Source SHA-256: `25ebeaf513555563d1a03d9eff5a138b1cd573d83160b2920263aeff8644e956`

Use a POSIX forward slash after the relative path macro while preserving the total branch input name.

Current text:
```
proc import datafile="&path\restatement_impact_total.dta" out=restate_amount dbms=dta replace; run; 
```

Proposed replacement:
```
proc import datafile="&path/restatement_impact_total.dta" out=restate_amount dbms=dta replace; run;
```

**Proposed edit:** `Step1_MisstatementAmount_Total.sas:152–152`
Source SHA-256: `25ebeaf513555563d1a03d9eff5a138b1cd573d83160b2920263aeff8644e956`

Use a POSIX forward slash after the relative path macro while preserving the total branch output name.

Current text:
```
proc export data=restate_amount3 outfile="&path\comp_restate_total.dta" dbms=dta replace; run;
```

Proposed replacement:
```
proc export data=restate_amount3 outfile="&path/comp_restate_total.dta" dbms=dta replace; run;
```

**Proposed edit:** `Step1_MisstatementAmount_v2.sas:35–35`
Source SHA-256: `8dcfa156c685ced0e62882c08e839ea25ea87c098332cf09d7ff821dfff23334`

Use a POSIX forward slash after the relative path macro while preserving the original Compustat input name.

Current text:
```
proc import datafile="&path\ccma_original.dta" out=comp dbms=dta replace; run;
```

Proposed replacement:
```
proc import datafile="&path/ccma_original.dta" out=comp dbms=dta replace; run;
```

**Proposed edit:** `Step1_MisstatementAmount_v2.sas:39–39`
Source SHA-256: `8dcfa156c685ced0e62882c08e839ea25ea87c098332cf09d7ff821dfff23334`

Use a POSIX forward slash after the relative path macro while preserving the v2 branch input name.

Current text:
```
proc import datafile="&path\restatement_impact_annual_v2.dta" out=restate_amount dbms=dta replace; run;
```

Proposed replacement:
```
proc import datafile="&path/restatement_impact_annual_v2.dta" out=restate_amount dbms=dta replace; run;
```

**Proposed edit:** `Step1_MisstatementAmount_v2.sas:154–154`
Source SHA-256: `8dcfa156c685ced0e62882c08e839ea25ea87c098332cf09d7ff821dfff23334`

Use a POSIX forward slash after the relative path macro while preserving the v2 branch output name.

Current text:
```
proc export data=restate_amount3 outfile="&path\comp_restate_v3.dta" dbms=dta replace; run;
```

Proposed replacement:
```
proc export data=restate_amount3 outfile="&path/comp_restate_v3.dta" dbms=dta replace; run;
```

Preparation / proposed procedure:

1. In a writable working copy, preserve the supplied source files and create the relative Data/Restatement and Data/20231110 folders required by the drivers.
2. Run Step0 total/v2 from Data/Restatement; run GeoPeer SAS, both SAS amount branches and both Stata analyses from Data/20231110. Keep the output folder at Data/20231110/Output.
3. Apply the active-root edits and the listed SAS forward-slash separator edits in the working copy; preserve exact file basenames, data definitions and branch identities.

Validation to perform later:

- Before any separately authorized run, confirm each active root resolves to the intended directories and each SAS input/output filename operand uses a path separator supported by the Linux host.
- Confirm generated restatement outputs land in Data/20231110 and that no data/source basename or analysis logic changed.
- Use the common README batch wrappers with relative paths; no author program was run in this assessment.

### A_LINKFILE_HANDOFF: Align the v2 link-file consumer with the output path used by its immediately preceding producer. The proposal changes only the handoff path.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_STEP0V2_HANDOFF
Evidence: E_STEP0_V2_LINK, E_STEP0V2_LINK_CONSUMER

**Proposed edit:** `Step0_restatement_dataprep_FZ_v2.do:46–46`
Source SHA-256: `67a8e7deb506a7c35aa46d2579ca39229026a9652fd5f6781e257805589347e3`

Line 33 writes this generated file under ${output}; this consumer should use the same location unless the authors confirm a separate producer.

Current text:
```
merge m:1 restatement_notification_fkey using datasets/restatement_linkfile, keep(3) nogenerate
```

Proposed replacement:
```
merge m:1 restatement_notification_fkey using "${output}/restatement_linkfile", keep(3) nogenerate
```

Preparation / proposed procedure:

1. In a writable working copy, change the consumer to the ${output}/restatement_linkfile location produced immediately above.

Validation to perform later:

- Inspect the producer and consumer paths together in the working copy before any separately authorized execution.

### A_INPUT_SPEC: Resolve the exact author product snapshots, variable contracts and producers for the Audit Analytics and supplemental restatement files. Current catalog candidates and misses do not establish complete history, author version or access restrictions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DATA_CLOSURE, R_AA_FEES, R_AA_FEED39, R_RESTATEMENT_PERIODS, R_RESTATEMENT_FILINGS, R_FISCAL_ENDS
Evidence: E_DOC_INPUTS, E_GEO_AUDIT_FIELDS, E_STEP0_TOTAL_FIELDS, E_STEP0_TOTAL_CATEGORY, E_STEP0V2_PERIOD_FIELDS, E_STEP0_V2_FILINGS, E_GEO_FISCAL_READ, E_CAT_FEED39_EXACT, E_CAT_FEED39_CANDIDATE, E_FEED39_META, E_CAT_FEED03_CANDIDATE, E_AUDIT_FEES_META, E_CAT_PERIODS, E_CAT_FILINGS, E_CAT_FISCAL_ENDS

Preparation / proposed procedure:

1. Obtain the exact author-era file/version or its data dictionary and provenance for feed39_washun, AuditFees200001_202112, restatement_periods, restatement_filings and restatement_fiscal_year_ends.csv.
2. Confirm whether AUDIT.FEED39_FINANCIAL_RESTATEMENTS is the intended product and resolve RES_ACCOUNTING_RESTATEMENT_CATEG against the catalog candidate field name without assuming they are equivalent.
3. Identify the producer and required key/date/value fields for restatement_periods and restatement_filings; determine which table supplies file_date and file_accepted.
4. Confirm the FEED03 audit-fee candidate covers the named author period and version before mapping the four required join fields.

Validation to perform later:

- Compare the provided file schemas and periods against the author-source fields using bounded metadata only; do not infer history from one-row probes or catalog counts.

### A_PANEL_SPEC: Confirm the exact prepared Compustat-CRSP, monthly CRSP, original Compustat and CIK-link inputs or document a supported field/date mapping for the local candidates. No candidate is currently a verified substitute.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DATA_CLOSURE, R_CCMA_PANEL, R_CCMA_ORIGINAL, R_MSF_PANEL, R_CIK_LINK
Evidence: E_GEO_CCMA_FIELDS, E_GEO_MARKET_FIELDS, E_STEP1_TOTAL_CCMA_FIELDS, E_STEP1_V2_CCMA_FIELDS, E_GEO_CIK_FIELDS, E_CAT_CCMA, E_CAT_FUNDA, E_FUNDA_META, E_CAT_CCM, E_CAT_MSF, E_MSF_META, E_CAT_MSI, E_MSI_META, E_CAT_CIK, E_CIK_META

Preparation / proposed procedure:

1. Request the exact ccma_200001_202211 and ccma_original files or their complete field/version documentation, keeping them distinct until compatibility is demonstrated.
2. Confirm how the COMP.FUNDA and CRSP/Compustat link-history candidates could supply the GeoPeer panel fields, including LPERMNO, geography and incorporation fields; do not independently rebuild undocumented transformations.
3. Confirm the author monthly panel and period. If the CRSP.MSF and CRSP.MSI candidates are intended, document the date join and field mapping for PERMNO/DATE/RET/VWRETD before any authorized preparation.
4. Resolve the CIK-link candidate’s FLAG and date-bound mappings against the author code’s flag/datadate1/datadate2 contract; do not infer date-field equivalence.

Validation to perform later:

- Use bounded metadata to compare exact author inputs with their source-declared fields and expected file formats; verify historical ranges separately before execution.

### A_HEADER_SPEC: Confirm the author header-file schema or a documented conversion from the SRAF product; the public page does not document all fields the author code consumes.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DATA_CLOSURE, R_LM_HEADER
Evidence: E_GEO_HEADER_READ, E_GEO_HQ_FIELDS, E_GEO_HQ_MERGE, E_PUBLIC_HEADER, E_CAT_LM_HEADER

Preparation / proposed procedure:

1. Request the author LM_EDGAR_10X_Header_1993-2021.dta schema or confirm a specific conversion from the SRAF 1993-2025 CSV.
2. Resolve filing/filer identifier and date naming and provide documented sources for ba_county and ba_msa before treating the public candidate as compatible.

Validation to perform later:

- Compare fields, date formats, filer identity and 1993-2021 coverage using bounded metadata after the exact candidate file is supplied; do not fetch the public payload during this assessment.

### A_STATA_EXTENSIONS: Prepare the required Stata extensions winsor2 and outreg2 on the intended host; both were not found in the checked adopaths.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_STATA_SETUP, SW_WINSOR2, SW_OUTREG2
Evidence: E_STATA_WINSOR, E_STATA_OUTREG, E_REST_OUTREG, E_ENVIRONMENT

Preparation / proposed procedure:

1. Provision winsor2 and outreg2 from an authorized package source in the target Stata adopath; record versions and paths.

Validation to perform later:

- Use Stata command availability/version checks only; do not run supplied analysis code as part of the metadata check.

### A_SAS_RUNTIME: Confirm that the target host can use the required SAS 9.4 batch runtime and the code’s SAS7BDAT, CSV and Stata import/export operations. Existing probe status is unverified and is not evidence of a license or capability barrier.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_RUNTIME_UNVERIFIED, SW_SAS
Evidence: E_ENVIRONMENT, E_GEO_SAS_PURPOSE, E_STEP1_TOTAL_OUT, E_STEP1_V2_OUT, E_COMMON_SAS_VERSION

Preparation / proposed procedure:

1. Confirm the documented SAS 9.4 batch invocation and required import/export procedures on the intended host before scheduling the author workflow.
2. Use the authorized common README batch settings when preparing any future run; do not infer license status from the prior probe result.

Validation to perform later:

- Record runtime readiness and SAS/Stata file-format support from host documentation or an authorized non-author software check before author programs are run.


## Remaining issues and prerequisites

- I_DATA_CLOSURE [unresolved; full_pipeline]: The supplied archive has code, documentation and an identifier file, not an analysis-ready dataset. Named audit, Compustat-CRSP, CRSP, CIK-link, header and restatement-period/filing inputs remain unverified by exact fields, history, version or producer. Catalog candidates and bounded metadata are useful leads, not proof of compatible complete inputs or an access barrier.
- I_PATHS [preparation; full_pipeline]: Author drivers contain Mac/Dropbox absolute roots; SAS filename operands also use literal backslashes after &path. The proposed working copy uses relative roots plus forward-slash path separators, preserving file names and branches.
- I_STEP0V2_HANDOFF [preparation; full_pipeline]: Step0 v2 writes restatement_linkfile under the configured output root and the later consumer uses a different relative datasets/ path. The supplied source gives the direct producer location, so align the consumer path in the working copy as a preparation edit.
- I_STATA_SETUP [preparation; full_pipeline]: winsor2 and outreg2 are required author commands but were not found in the environment report’s checked Stata adopaths; they need preparation on the intended Stata host.
- I_RUNTIME_UNVERIFIED [unresolved; full_pipeline]: The existing SAS runtime probe did not establish a successful startup. This remains an unverified environment fact, not evidence of absent license or a confirmed software barrier.
- R_AA_FEES [undetermined]: Audit Analytics audit-fee observations read by the GeoPeer SAS stage; the author file is named AuditFees200001_202112 and must support the company/auditor/year fee join.
- R_AA_FEED39 [undetermined]: Audit Analytics restatement feed used by both the total and v2 preprocessing branches as feed39_washun; preserve both downstream branches.
- R_RESTATEMENT_PERIODS [undetermined]: The author-named restatement_periods input consumed by the v2 amount-construction branch.
- R_RESTATEMENT_FILINGS [undetermined]: Filing-level input merged by restatement_filing_fkey in the v2 amount-construction branch; it is a source-level read not enumerated by the frozen parser dependency list.
- R_FISCAL_ENDS [undetermined]: CSV imported by the GeoPeer SAS stage under restatement_fiscal_year_ends.csv. Its producer, field contract and role in the supplied workflow remain unknown.
- R_CCMA_PANEL [undetermined]: Author-prepared annual Compustat-CRSP merged panel ccma_200001_202211 used by GeoPeer sample construction, with the source-declared columns below.
- R_CCMA_ORIGINAL [undetermined]: Separate ccma_original.dta input imported by both SAS misstatement-amount branches; it is not established to be the same file as the GeoPeer ccma panel.
- R_MSF_PANEL [undetermined]: Author-prepared monthly CRSP panel msf_200001_202210 consumed by GeoPeer sample construction, requiring PERMNO, DATE, RET and VWRETD.
- R_LM_HEADER [undetermined]: Author-named LM_EDGAR_10X_Header_1993-2021.dta used to join filing header geography to company CIK and datadate.
- R_CIK_LINK [undetermined]: The author-named wciklink_gvkey SAS table read by GeoPeer and both SAS amount-construction branches to associate CIK and GVKEY over dated link intervals.
- SW_SAS [unverified]: The authorized common README identifies SAS 9.4 TS1M8, while the existing bounded environment report does not establish a successful runtime startup. This is not evidence of a missing license or absent capability.
- SW_WINSOR2 [preparation_required]: The GeoPeer Stata driver calls winsor2; the environment report did not find it in the checked adopaths.
- SW_OUTREG2 [preparation_required]: Both supplied Stata analyses call outreg2; the environment report did not find it in the checked adopaths.

## Review notes

- The assigned author workflow is retained across all seven supplied entry points and both restatement branches. All 19 frozen dependency IDs are classified. Additional source reads include restatement_filings, the generated restatement_linkfile handoff and restatement_analysis.do’s merge of comp_restate_total; these are represented without inventing parser IDs.
- The proposed source edits are active-root and POSIX separator portability edits plus the Step0_v2 handoff alignment. No proposed edit was applied. Relative roots assume Step0 runs from Data/Restatement and the other SAS/Stata stages run from Data/20231110.
- No author program, import, compile, parser, syntax, statistical or model trial was run; no SAS process was started; no software was installed; a frozen Stata which-only metadata query confirmed coefplot under Stata 18; no data/model/archive/API payload or connection was used. SAS candidate metadata probes read one row only; full history remains unknown.
- Process-only scope note: one workspace filename enumeration used `rg --files -g 'README.md' historical artifact execution_feasibility git/skills/check-execution-feasibility` from the workspace root. The tool report stated original token count 296543 and 137596 bytes omitted; raw stdout was not persisted and stderr/return status were not captured. No other author-package body was opened or changed, and omitted filenames are not reconstructed. This was a search-scope/efficiency lapse, not a package or scientific blocker.
- A bounded display of the assigned datasheet included an author-contact identifier; only the category and cached document hash 77d4cda6d9efeb3028a1e3b38d44f14684ba4480987ae9eccf64dc333a12032b are retained here. Its value was not used, repeated or enriched; no credential was involved. A separately malformed saved-reader path failed before any code read.
