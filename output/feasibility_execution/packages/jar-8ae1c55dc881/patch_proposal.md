# Patch proposal: jar-8ae1c55dc881

Did the Dodd-Frank Whistleblower Provision Deter Accounting Fraud

DOI: 10.1111/1475-679X.12421

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete as-downloaded author Stata workflow: Compustat and 13F/fund/FCA panel preparation, all sample construction and required merges, Dodd–Frank 2008–2014 and 2009–2013 analyses, state-FCA 2007–2010 analyses, Tables 3–9, and Figure 1. The supplied identifier workbook does not provide the required analysis panel.

Entry points: `BL_Final_Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12421 - Did-the-Dodd-Frank-Whistleblower-Provision-Deter-Accounting-Fraud/bldatasheetcodeandidentifiers.zip",
      "sha256": "b5df99e3e7c0fe1e8c9684a0c2eed6a6f51d2c9c2019faffab8f9c7ab2b19ea4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "5e8745c168d57318b24d1b7206e3e652c2993625ff7a672a68194d412d9681cc"
}
```

## Proposed actions

### A_COMP_INPUT: Resolve the author Compustat panel contract, including a documented complementary COMPANY lookup if appropriate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMP, I_COMP_FIELDS, I_INPUT_COVERAGE
Evidence: E_COMP_INPUT, E_COMP_OUTPUTS, E_PROBE_COMP_FUNDA, E_CAT_ENTRY_FIELDS, E_DOC_SOURCES, E_COMPANY_CATALOG_INSPECTION, E_PROBE_COMP_COMPANY

Preparation / proposed procedure:

1. Provide the exact author-prepared Data/rawdata/compustat.dta or document a compatible preparation from the annual COMP.FUNDA candidate, with any COMP.COMPANY lookup joined only under an evidenced gvkey and temporal contract.
2. Map the author's required loc, state, sic and fyrc fields to their documented source roles. The catalog labels COMPANY loc/state/sic/fyrc as current company attributes and FUNDA SICH as historical numeric SIC; do not substitute current sic for historical sich or infer an undocumented join.
3. Confirm annual source history sufficient for the authored lag, difference and three-year asrol operations and the whole-input Autenure construction before the 2007–2014 restriction. Preserve the source's literal boundaries and missing-to-zero conventions; do not add arbitrary lag years.

Validation to perform later:

- In a separately authorized working-copy preparation, compare the delivered panel and any documented lookup against every source field read at BL_Final_Code.do lines 31–168, including keys, types and temporal roles.
- Check documented coverage against the actual lag/difference/rolling and pre-filter Autenure contracts; record unresolved history instead of assuming the sampled 2007–2014 period is sufficient.

### A_13F_INPUT: Obtain a compatible author statefund.dta or the documented transformation from the named 13F product and target-fund selection.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_13F, I_INPUT_COVERAGE
Evidence: E_FUND_INPUT, E_DOC_SOURCES, E_DOC_SAMPLE, E_CAT_13F, E_PROBE_TFN_S34

Preparation / proposed procedure:

1. Obtain the author-prepared statefund.dta or a precise WRDS 13F selection recipe for the 22 state pension funds, with CUSIP, manager ID/name, filing date, price and shares.
2. Confirm the exact December filings, state-fund population and coverage needed by the code; the local TFN.S34 one-row request timed out and was not retried.
3. Retain the source-authored row ordering and missing-usdf_lag-to-zero convention; do not add extra holdings years solely to override it.

Validation to perform later:

- Before an authorized run, confirm the prepared data schema, target manager population and period needed by the source code.
- If using a future approved local readability check, use only its exact registered bounded probe protocol; do not infer access or coverage from the catalog entry.

### A_FUND_MAP: Obtain the separate state-to-manager mapping workbook used to create fundlevel.dta.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FUND_MAP, I_INPUT_COVERAGE
Evidence: E_FUND_MAP_AND_WRITE, E_FUNDLEVEL_WRITE, E_ID_WORKBOOK, E_DOC_SAMPLE

Preparation / proposed procedure:

1. Provide Data/rawdata/statefund_list.xlsx with the author-specified WRDSdata worksheet and state/mgrno mapping; BL_Identifiers.xlsx is a different CUSIP identifier list.
2. Preserve the source merge and selection of state managers when preparing the authored fundlevel.dta intermediate.

Validation to perform later:

- Check the delivered workbook's sheet and state/mgrno headers before the source merge, then confirm the prepared manager/state counts against author documentation.

### A_STATE_FCA: Obtain or document the exact state-level FCA input used by the authored BR_stata import.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATE_FCA, I_INPUT_COVERAGE
Evidence: E_STATE_FCA, E_DOC_SAMPLE, E_DOC_SOURCES

Preparation / proposed procedure:

1. Provide Data/rawdata/StateFCA_table.xlsx with the BR_stata worksheet and the state, passed, falseclaims and quitam fields used by the code.
2. If recreating that lookup from the cited literature, request the authors' exact source/edition, state coding and passage-year/category mapping; the datasheet reference alone does not establish the workbook values.

Validation to perform later:

- Check the worksheet, state-key coverage, passage years and source classifications against the documented author input before merging.

### A_INSTOWN: Resolve the author-prepared InstitutionOwn.dta source and ownership-percentage contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_INSTOWN, I_INSTOWN_PRODUCER, I_INPUT_COVERAGE
Evidence: E_INSTOWN, E_CAT_INSTOWN, E_DOC_SOURCES

Preparation / proposed procedure:

1. Provide InstitutionOwn.dta with rdate, CUSIP and instown_perc, or document the exact source product, ownership numerator/denominator, date/year mapping and construction of that measure.
2. Do not treat the generic 13F catalog candidate as equivalent to this prepared institutional-ownership percentage file.

Validation to perform later:

- Check the exact required fields, December date filter, CUSIP/year match and percentage units before continuing the merge.

### A_SEGMENTS: Resolve the producer and key/count mapping for fund_segment.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SEGMENT, I_SEGMENT_PRODUCER, I_INPUT_COVERAGE
Evidence: E_SEGMENTS, E_CAT_ENTRY_FIELDS, E_PROBE_COMPSEG

Preparation / proposed procedure:

1. Provide the author-prepared fund_segment.dta with CUSIP, fyear and N_seg, or document the segment-type selection, gvkey/CUSIP mapping, date-to-fiscal-year mapping and count definition from the local Compustat segment candidate.
2. Preserve the supplied tsfill and forward/backward carryforward sequence; do not infer a segment-count definition from SICS fields alone.

Validation to perform later:

- Check key uniqueness and N_seg construction for the firm-years consumed by the merge and carry-forward sequence.

### A_AUDIT_FEES: Resolve the audit-fee key/year meanings and prepared-file producer, consulting the authorized dictionary or supplied author metadata before deciding whether a crosswalk is needed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AUDIT_FEES, I_AUDIT_FEE_MAPPING, I_INPUT_COVERAGE
Evidence: E_AUDIT_FEES, E_CAT_ENTRY_FIELDS, E_PROBE_AUDIT_FEES, E_DOC_SOURCES, E_WRDS_AA_PRODUCT, E_WRDS_AA_DICT_GATE

Preparation / proposed procedure:

1. Provide fund_auditfees.dta with the author-required CIK, fyear and audit_fees fields, or document the exact FEED03 COMPANY_FKEY, FISCAL_YEAR/FISCAL_YEAR_ENDED and AUDIT_FEES meanings and normalization into that consumer schema.
2. First verify COMPANY_FKEY and fiscal-year semantics from authorized dictionary or author metadata. Add a CIK crosswalk only if the documented key meaning requires one; the public static check did not establish key equivalence or difference.
3. Retain the source-authored merge and scaling/log transformations. No new entitlement attestation is a prerequisite for the already-readable local candidate.

Validation to perform later:

- Check documented key and fiscal-year alignment, audit_fees units, and author-file producer fields before the merge; record any remaining mapping or history gap.

### A_ICW: Resolve the ICW key/year meanings, suffix/drop-range contract and prepared-file producer using authorized dictionary or author metadata.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ICW, I_ICW_MAPPING, I_INPUT_COVERAGE
Evidence: E_ICW, E_CAT_ENTRY_FIELDS, E_PROBE_ICW, E_DOC_SOURCES, E_WRDS_AA_PRODUCT, E_WRDS_AA_DICT_GATE

Preparation / proposed procedure:

1. Provide fund_icw.dta with the author-required CIK, fyear, count_weak and sig_date_ic_op_x fields, or document the exact FEED11 source-field and merge/suffix construction that produces them.
2. Verify COMPANY_FKEY meaning and the `FY_IC_OP` fiscal-year relationship to author fyear from authorized dictionary or author metadata before deciding whether a CIK crosswalk or year conversion is needed.
3. Resolve the source-authored `drop sig_date_ic_op_x- _merge` schema/order and retain the missing fund_icw.dta producer as an explicit gap. No new entitlement attestation is a prerequisite for the already-readable local candidate.

Validation to perform later:

- Check documented key uniqueness, fiscal-year alignment, required field names, suffix construction and the source-authored drop-range schema before merging.

### A_FIGURE: Resolve the separate Figure 1 Fscore workbook producer and plotted-value contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FIGURE_COEFFICIENTS, I_FIGURE_PRODUCER
Evidence: E_FIGURE_MODEL, E_FIGURE_ESTIMATE, E_FIGURE_IMPORT, E_FIGURE_PLOT_FIELDS

Preparation / proposed procedure:

1. Provide working/coefficient.xlsx with sheet Fscore and year, coeff, lci and uci, or supply the author's documented producer and mapping of coefficient estimates and confidence limits to those columns.
2. Do not invent a workbook exporter or infer its values from the reghdfe model statement alone.

Validation to perform later:

- Verify the workbook producer, sheet, year range, column names and confidence-limit semantics before executing the Figure 1 graph statement.

### A_PATHS: Configure the Stata driver for a relative working-copy root and connect the fund merge to its exact same-run producer.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PATH_ROOT, I_FUND_PATH, I_USE_REPLACE
Evidence: E_CODE_ROOT, E_FUNDLEVEL_WRITE, E_FUND_PATH_MISMATCH, E_STATA_USE_OPTIONS, E_USE_REPLACE_INVENTORY

**Proposed edit:** `BL_Final_Code.do:16–16`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
global main "[redacted-path-4f650f7d779e]"
```

Proposed replacement:
```
global main "Data"
```

**Proposed edit:** `BL_Final_Code.do:17–17`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
local outdir "[redacted-path-51d794000fd5]" 
```

Proposed replacement:
```
local outdir "Tables"
```

**Proposed edit:** `BL_Final_Code.do:31–31`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\rawdata\compustat" , clear
```

Proposed replacement:
```
use "$main/rawdata/compustat" , clear
```

**Proposed edit:** `BL_Final_Code.do:164–164`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\compfull", replace
```

Proposed replacement:
```
save "$main/working/compfull", replace
```

**Proposed edit:** `BL_Final_Code.do:168–168`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\comp_fyear2_full", replace
```

Proposed replacement:
```
save "$main/working/comp_fyear2_full", replace
```

**Proposed edit:** `BL_Final_Code.do:177–177`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\rawdata\statefund.dta", clear
```

Proposed replacement:
```
use "$main/rawdata/statefund.dta", clear
```

**Proposed edit:** `BL_Final_Code.do:191–191`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
import excel using "$main\rawdata\statefund_list.xlsx" ,sheet(WRDSdata) firstrow clear 
```

Proposed replacement:
```
import excel using "$main/rawdata/statefund_list.xlsx" ,sheet(WRDSdata) firstrow clear 
```

**Proposed edit:** `BL_Final_Code.do:199–199`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\fundlevel.dta", replace
```

Proposed replacement:
```
save "$main/working/fundlevel.dta", replace
```

**Proposed edit:** `BL_Final_Code.do:203–203`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\working\comp_fyear2_full", clear
```

Proposed replacement:
```
use "$main/working/comp_fyear2_full", clear
```

**Proposed edit:** `BL_Final_Code.do:204–204`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
merge 1:m cusip fyear using "[redacted-path-402f6e454c22]"
```

Proposed replacement:
```
merge 1:m cusip fyear using "$main/working/fundlevel.dta"
```

**Proposed edit:** `BL_Final_Code.do:208–208`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\fundComp_full_fyear2", replace
```

Proposed replacement:
```
save "$main/working/fundComp_full_fyear2", replace
```

**Proposed edit:** `BL_Final_Code.do:215–215`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use  "$main\working\fundComp_full_fyear2", clear
```

Proposed replacement:
```
use  "$main/working/fundComp_full_fyear2", clear
```

**Proposed edit:** `BL_Final_Code.do:223–223`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
import excel using  "$main\rawdata\StateFCA_table.xlsx" ,sheet(BR_stata) firstrow clear 
```

Proposed replacement:
```
import excel using  "$main/rawdata/StateFCA_table.xlsx" ,sheet(BR_stata) firstrow clear 
```

**Proposed edit:** `BL_Final_Code.do:290–290`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\fundComp_full_fyear2_before shrink_full.dta", replace
```

Proposed replacement:
```
save "$main/working/fundComp_full_fyear2_before shrink_full.dta", replace
```

**Proposed edit:** `BL_Final_Code.do:297–297`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\working\fundComp_full_fyear2_before shrink_full.dta", clear
```

Proposed replacement:
```
use "$main/working/fundComp_full_fyear2_before shrink_full.dta", clear
```

**Proposed edit:** `BL_Final_Code.do:387–387`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use the relative rawdata path and the documented Stata `clear` option in one working-copy edit; preserve the author's input and in-memory replacement operation.

Current text:
```
use "$main\rawdata\InstitutionOwn.dta" ,replace
```

Proposed replacement:
```
use "$main/rawdata/InstitutionOwn.dta" ,clear
```

**Proposed edit:** `BL_Final_Code.do:411–411`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
merge 1:1 cusip fyear using  "$main\rawdata\fund_segment.dta"
```

Proposed replacement:
```
merge 1:1 cusip fyear using  "$main/rawdata/fund_segment.dta"
```

**Proposed edit:** `BL_Final_Code.do:429–429`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
merge 1:1 cik fyear using  "$main\rawdata\fund_auditfees.dta"
```

Proposed replacement:
```
merge 1:1 cik fyear using  "$main/rawdata/fund_auditfees.dta"
```

**Proposed edit:** `BL_Final_Code.do:437–437`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
merge 1:1 cik fyear using  "$main\rawdata\fund_icw.dta"
```

Proposed replacement:
```
merge 1:1 cik fyear using  "$main/rawdata/fund_icw.dta"
```

**Proposed edit:** `BL_Final_Code.do:446–446`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\data_before_final_cleaning_full.dta", replace
```

Proposed replacement:
```
save "$main/working/data_before_final_cleaning_full.dta", replace
```

**Proposed edit:** `BL_Final_Code.do:453–453`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\working\data_before_final_cleaning_full.dta", clear
```

Proposed replacement:
```
use "$main/working/data_before_final_cleaning_full.dta", clear
```

**Proposed edit:** `BL_Final_Code.do:489–489`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
save "$main\working\Sample-selection-winsor.dta", replace
```

Proposed replacement:
```
save "$main/working/Sample-selection-winsor.dta", replace
```

**Proposed edit:** `BL_Final_Code.do:501–501`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\working\Sample-selection-winsor.dta", clear
```

Proposed replacement:
```
use "$main/working/Sample-selection-winsor.dta", clear
```

**Proposed edit:** `BL_Final_Code.do:558–558`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\working\Sample-selection-winsor.dta", clear
```

Proposed replacement:
```
use "$main/working/Sample-selection-winsor.dta", clear
```

**Proposed edit:** `BL_Final_Code.do:618–618`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
use "$main\working\Sample-selection-winsor.dta", clear
```

Proposed replacement:
```
use "$main/working/Sample-selection-winsor.dta", clear
```

**Proposed edit:** `BL_Final_Code.do:1021–1021`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Use one relative working-copy layout for every author read/write and output, with the fundlevel consumer pointed to the exact line-199 producer.

Current text:
```
import excel using  "$main\working\coefficient.xlsx" ,sheet(Fscore) firstrow clear 
```

Proposed replacement:
```
import excel using  "$main/working/coefficient.xlsx" ,sheet(Fscore) firstrow clear 
```

Preparation / proposed procedure:

1. Apply the proposed edits only in a separate working copy; use the working-copy root as the current directory with Data/rawdata, Data/working and Tables directories.
2. Keep all reads and writes relative, create the required directories before execution and preserve the author analysis sequence.

Validation to perform later:

- Before a separately authorized run, confirm the working directory contains every requested rawdata input, Data/working and Tables are writable, and line 204 resolves to the line-199 fundlevel.dta output.
- Review every edited path together and confirm no machine-specific Dropbox path remains in the working-copy configuration.

### A_DIFF_INSTALL: Remove the runtime SSC install line and retain the two source-authored diff calls after separate Stata package setup.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DIFF_AUTO_INSTALL, S_DIFF
Evidence: E_DIFF_INSTALL_SOURCE, E_DIFF_CALL, E_SW_diff

**Proposed edit:** `BL_Final_Code.do:667–667`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Remove the runtime package-install statement while retaining both source-authored diff calls; configure the package separately before a future authorized run.

Current text:
```
ssc inst diff, replace
```

Proposed replacement:
```
* Configure diff.ado separately before the Table 4 diff calls.
```

Preparation / proposed procedure:

1. Apply the comment replacement only in a separate working copy.
2. Configure a Stata 18 compatible diff package separately before running the Table 4 branch.

Validation to perform later:

- Confirm `which diff` succeeds in the configured Stata 18 adopath before any separately authorized workflow run.
- Retain both author diff calls and confirm no package installation statement remains in the run path.

### A_STATA_ADDONS: Prepare Stata 18 add-ons not found in the checked default adopath: asrol, carryforward, winsor2, asdoc, diff and outreg2.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_ASROL, S_CARRYFORWARD, S_WINSOR2, S_ASDOC, S_DIFF, S_OUTREG2
Evidence: E_SW_asrol, E_SW_carryforward, E_SW_winsor2, E_SW_asdoc, E_SW_diff, E_SW_outreg2, E_ASROL_CALL, E_CARRYFORWARD_CALL, E_WINSOR2_CALL, E_ASDOC_CALL, E_DIFF_CALL, E_OUTREG2_CALL

Preparation / proposed procedure:

1. In a separately authorized environment setup, install or configure Stata 18 compatible releases of the six commands in the active adopath; no installation was performed during this assessment.
2. Keep the source-authored call options and methods. `unique`, `ebalance`, `reghdfe` and the egen `_gnvals` entry point were found by the metadata checks; no estimator or example was executed.

Validation to perform later:

- Check `which` for each required add-on and review its installed version/help metadata against the authored options before a separately authorized run.
- After prerequisites are prepared, run the complete author workflow only under separate authorization and retain the native logs and outputs.

### A_RUN_FULL_WORKFLOW: After all data contracts, software and paths are prepared, run the complete supplied Stata driver in source order, including every table and Figure 1 branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_CODE_SCOPE, E_COMP_INPUT, E_FUND_INPUT, E_STATE_FCA, E_PRE_SHRINK_WRITE, E_FUNDCOMP_WRITE, E_INSTOWN, E_SEGMENTS, E_AUDIT_FEES, E_ICW, E_CLEANING, E_DF_WINDOW, E_DF_ROBUSTNESS, E_EBALANCE_DF, E_EBALANCE_0913, E_FCA_SAMPLE, E_TABLES, E_FIGURE_IMPORT, E_OUTREG2_CALL

Preparation / proposed procedure:

1. Run BL_Final_Code.do from the configured working-copy root after all required Data/rawdata inputs, Stata 18 add-ons and directories are prepared.
2. Follow Part A in order: construct Compustat files; build state fund holdings and merge to Compustat; merge StateFCA and create exposures; collapse the fund-year panel; then merge institutional ownership, segments, audit fees and ICW before common cleaning/winsorization.
3. Follow Part B for the 2008–2014 Dodd–Frank, 2009–2013 Dodd–Frank and 2007–2010 state-FCA samples, retaining both pre/post SECWB requirements and the authored entropy-balance target(3) calls.
4. Follow Part C for every supplied Table 3–9 branch, preserving source outcomes, controls, sample restrictions, fixed effects and firm-cluster methods; keep all original and robustness variants.
5. Run the Figure 1 event-time model and import/graph stage only after the missing coefficient.xlsx producer and Fscore column contract are resolved; do not reconstruct that workbook from model output without author documentation.

Validation to perform later:

- Check each native intermediate exists before its next consumer, including the same-run fundlevel, fund-Compustat, pre-cleaning, cleaned sample and branch tempfiles.
- Confirm all Tables 3–9 outputs and Figure 1 output are written to the configured locations and inspect logs for every required branch; execution success remains unverified until that separately authorized run occurs.

### A_USE_CLEAR_REPAIR: In the separate working copy, replace `replace` with `clear` at the 30 remaining active Stata `use` calls; line 387 is combined with its path correction in A_PATHS. Preserve CRLF source formatting and all authored files, samples and methods.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_USE_REPLACE
Evidence: E_STATA_USE_OPTIONS, E_USE_REPLACE_INVENTORY

**Proposed edit:** `BL_Final_Code.do:656–656`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace 
```

Proposed replacement:
```
use `DF_sample',clear 
```

**Proposed edit:** `BL_Final_Code.do:666–666`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:688–688`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:697–697`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:706–706`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:715–715`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample_09_13',replace
```

Proposed replacement:
```
use `DF_sample_09_13',clear
```

**Proposed edit:** `BL_Final_Code.do:724–724`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample_09_13',replace
```

Proposed replacement:
```
use `DF_sample_09_13',clear
```

**Proposed edit:** `BL_Final_Code.do:739–739`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:755–755`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:764–764`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:773–773`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:782–782`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:791–791`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:808–808`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:817–817`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:826–826`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:835–835`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample_09_13',replace
```

Proposed replacement:
```
use `DF_sample_09_13',clear
```

**Proposed edit:** `BL_Final_Code.do:844–844`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample_09_13',replace
```

Proposed replacement:
```
use `DF_sample_09_13',clear
```

**Proposed edit:** `BL_Final_Code.do:858–858`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:867–867`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:876–876`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:885–885`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:894–894`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:912–912`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:921–921`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:930–930`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:939–939`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample_09_13',replace
```

Proposed replacement:
```
use `DF_sample_09_13',clear
```

**Proposed edit:** `BL_Final_Code.do:948–948`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample_09_13',replace
```

Proposed replacement:
```
use `DF_sample_09_13',clear
```

**Proposed edit:** `BL_Final_Code.do:959–959`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `FCA_sample',replace
```

Proposed replacement:
```
use `FCA_sample',clear
```

**Proposed edit:** `BL_Final_Code.do:1008–1008`
Source SHA-256: `92eae9a9a514d1fac3398f686f3cc8dfec27af828b7e972dcc9e86cc2a121aeb`

Replace the unsupported `use` option with documented `clear`, preserving the same dataset, tempfile, command, sample and workflow position in a separate working copy.

Current text:
```
use `DF_sample',replace
```

Proposed replacement:
```
use `DF_sample',clear
```

Preparation / proposed procedure:

1. Apply these exact option-only edits to a separate copy of BL_Final_Code.do, together with line 387's existing path edit in A_PATHS. Keep every path, tempfile, dataset, command position, sample boundary, zero-fill and analysis unchanged; preserve the cached source's CRLF line endings.

Validation to perform later:

- Before a separately authorized full workflow attempt, confirm the working-copy diff changes only the `use` option and existing path setup. Do not use a syntax trial as part of this assessment.


## Remaining issues and prerequisites

- I_FUND_PATH [preparation; full_pipeline]: Line 199 writes fundlevel.dta under $main/working, but line 204 reads the same basename from an unrelated absolute RR/Round2/data path. Stage the exact line-199 output at the consumer path or use that produced working file consistently.
- I_FIGURE_PRODUCER [unresolved; full_pipeline]: The Figure 1 code imports working/coefficient.xlsx (Fscore) after estimating a model, but the supplied source contains no save/export producer or supported mapping of coefficient estimates into year/coeff/lci/uci.
- I_INPUT_COVERAGE [unresolved; full_pipeline]: The package lacks several author-required raw/source, lookup and prepared inputs. Frozen-catalog checks identified COMP.FUNDA and COMP.COMPANY, Thomson Reuters 13F, Compustat segments and Audit Analytics candidates; bounded one-row checks were readable except the single 13F timeout. Catalog and sampled fields do not establish the required author-specific population, period, history, key mappings or producer contracts, and several prepared files have no verified route. The datasheet's broad public-availability wording does not establish free commercial access; already-readable local candidates are not classified as license-blocked and no new entitlement attestation is required for them.
- I_COMP_FIELDS [unresolved; full_pipeline]: The COMP.FUNDA candidate contains the annual financial fields used by the do-file. A separate exact COMP.COMPANY catalog entry and one-row probe expose gvkey, loc, state, sic and fyrc; these are labeled current company-level fields, while FUNDA's SICH is numeric and explicitly historical. The documented COMPANY-to-FUNDA join, temporal role in the author panel, any required annual mappings, and the complete compustat.dta producer remain unresolved. Do not equate current SIC with historical SICH or treat COMPANY as an annual panel.
- I_SEGMENT_PRODUCER [unresolved; full_pipeline]: The code consumes fund_segment.dta with CUSIP/fyear/N_seg, while the local Compustat segment candidate exposes gvkey/segment identifiers/dates. No supplied producer, type filter, key/date mapping or N_seg definition establishes compatibility.
- I_AUDIT_FEE_MAPPING [unresolved; full_pipeline]: FEED03 is locally readable with COMPANY_FKEY, FISCAL_YEAR, FISCAL_YEAR_ENDED and AUDIT_FEES. The public WRDS dictionary check did not expose field definitions, so it establishes neither that COMPANY_FKEY is CIK nor that a separate crosswalk is needed, and it does not resolve FISCAL_YEAR-to-fyear semantics. The author fund_auditfees.dta producer and normalization remain absent.
- I_ICW_MAPPING [unresolved; full_pipeline]: FEED11 is locally readable with COMPANY_FKEY, FY_IC_OP, SIG_DATE_IC_OP and COUNT_WEAK. The public WRDS dictionary check did not disclose field definitions; do not assume COMPANY_FKEY is or is not CIK, and do not equate FY_IC_OP with author fyear without documentation. The `sig_date_ic_op_x` suffix, the ordered `drop sig_date_ic_op_x- _merge` field range, and the fund_icw.dta producer remain unresolved.
- I_INSTOWN_PRODUCER [unresolved; full_pipeline]: InstitutionOwn.dta is required for instown_perc and matched by CUSIP/fyear, but its upstream product, source field, ownership denominator, history and producer are unspecified. A 13F catalog candidate is not assumed to produce this measure.
- I_DIFF_AUTO_INSTALL [preparation; full_pipeline]: The do-file executes `ssc inst diff, replace` before its diff calls. That line would install a package at run time; this audit did not execute it. The required diff command is not found by Stata 18 in the checked default adopath.
- I_PATH_ROOT [preparation; full_pipeline]: The driver hard-codes Windows-specific Data and Tables roots. A working-copy root and matching relative Data/rawdata, Data/working and Tables directories need to be configured before the complete workflow can run on the assigned host.
- I_USE_REPLACE [preparation; full_pipeline]: The supplied Stata source has 31 active `use ...,replace` calls. The official `use` syntax lists `clear` and `nolabel`, and documents `clear` as the option for replacing unsaved in-memory data. A same-operation `replace`-to-`clear` working-copy correction is supported at all 31 calls; no syntax trial or author-approval gate is needed.
- R_COMP [undetermined]: Compustat annual company/fiscal-year source used to construct the F-score, controls, identifiers and growth/rolling variables.
- R_13F [undetermined]: December Thomson Reuters 13F fund holdings used for lagged portfolio ownership and fund/state exposure; code-level fields include CUSIP, manager ID/name, filing date, price and shares.
- R_FUND_MAP [undetermined]: State-to-manager crosswalk in statefund_list.xlsx, sheet WRDSdata; needed to construct fund-level holdings. The workbook is absent; the supplied identifier workbook is not this state-to-manager crosswalk.
- R_STATE_FCA [undetermined]: State FCA table in StateFCA_table.xlsx, sheet BR_stata, including state, passage year, false-claims category and qui-tam flag. The workbook is absent; the datasheet names the cited state FCA sources but does not provide the BR_stata worksheet data or its exact source mapping.
- R_INSTOWN [undetermined]: InstitutionOwn.dta with date, CUSIP and institutional ownership percentage; exact upstream product/table mapping is unspecified. The frozen catalog literal filename lookup for InstitutionOwn returned no candidate; the datasheet names 13F at a broad product level, but no supplied route maps that product to this prepared instown_perc file.
- R_SEGMENT [undetermined]: fund_segment.dta with CUSIP, fiscal year and N_seg used in the segment-count merge and carry-forward stage.
- R_AUDIT_FEES [undetermined]: Audit Analytics audit-fee export fund_auditfees.dta matched on CIK/fiscal year, with audit_fees.
- R_ICW [undetermined]: Audit Analytics internal-control-weakness export fund_icw.dta matched on CIK/fiscal year, including count_weak and the referenced sig_date_ic_op_x field.
- R_FIGURE_COEFFICIENTS [undetermined]: Figure 1 coefficient workbook working/coefficient.xlsx, Fscore sheet, expected to supply imported year, coeff, lci and uci plotting columns; its producer is not supplied. No supplied producer creates or exports this sheet; the preceding reghdfe call alone does not write the workbook.
- S_ASROL [preparation_required]: Stata 18: capture which asrol returned code 111 in the checked default adopath. It was not installed or configured during this audit; prepare it separately before attempting the authored workflow. This is not a license/access barrier.
- S_CARRYFORWARD [preparation_required]: Stata 18: capture which carryforward returned code 111 in the checked default adopath. It was not installed or configured during this audit; prepare it separately before attempting the authored workflow. This is not a license/access barrier.
- S_WINSOR2 [preparation_required]: Stata 18: capture which winsor2 returned code 111 in the checked default adopath. It was not installed or configured during this audit; prepare it separately before attempting the authored workflow. This is not a license/access barrier.
- S_ASDOC [preparation_required]: Stata 18: capture which asdoc returned code 111 in the checked default adopath. It was not installed or configured during this audit; prepare it separately before attempting the authored workflow. This is not a license/access barrier.
- S_DIFF [preparation_required]: Stata 18: capture which diff returned code 111 in the checked default adopath. It was not installed or configured during this audit; prepare it separately before attempting the authored workflow. This is not a license/access barrier.
- S_OUTREG2 [preparation_required]: Stata 18: capture which outreg2 returned code 111 in the checked default adopath. It was not installed or configured during this audit; prepare it separately before attempting the authored workflow. This is not a license/access barrier.

## Review notes

- This assessment covers the complete supplied BL_Final_Code.do workflow, including the Dodd–Frank and state FCA branches, Tables 3–9 and Figure 1. BL_Identifiers.xlsx is a CUSIP identifier list, not an analysis panel; no analysis-only scope is supported.
- All 14 frozen dependency checklist IDs are reviewed. Same-run intermediates and tempfiles are distinguished from external/prepared inputs; the additional unlisted segment, audit-fee and ICW reads are covered by explicit requirements and unresolved producer/key issues.
- Frozen-catalog candidates and one-row local probes establish only candidate identity/readability and sampled columns. COMP.COMPANY provides current company-level loc/state/sic/fyrc alongside the separate COMP.FUNDA annual financial candidate; the join and annual temporal contract remain unresolved. TFN.S34 timed out once at 15 seconds and was not retried. Neither failed probes, empty filename matches nor the datasheet's broad public-availability statement establish data absence, license denial or free commercial access.
- Stata 18 version/which metadata covers every active add-on and the egen `_gnvals` entry point. Six commands were not found in the checked default adopath; no packages were installed, and no author code, syntax, estimator or empirical data were run. Historical SAS startup attempts are present in the inherited environment record but were not repeated for this assignment.
- Administrative helper history is retained under probes/: the first checkpoint-03 launch used a relative path from the git cwd; the initial source-quote update used the wrong file for datasheet quotations; and preflight v1 treated an omitted optional patch_proposal field as null. Each stopped before changing the submitted draft; corrected invocations and their separate logs/status records are preserved. These process records are not scientific evidence.
- The proposed path edits are for a separate working copy and use relative Data and Tables roots. The fundlevel consumer is redirected to its exact same-run producer. Scientific input contracts, the Figure 1 workbook producer and specific data-construction contracts remain unresolved; no blanket entitlement precondition is imposed on already-readable local candidates; the proposed run procedure preserves all source branches and authored methods.
- A bounded official WRDS check confirmed the Audit Analytics schema listing but its public data-dictionary link redirects to login, leaving COMPANY_FKEY and fiscal-year definitions unresolved; this is only a public metadata-viewing limit. The official Stata use manual supports replacing all 31 active `use ...,replace` options with `clear` in a separate working copy, with line 387 combined into the existing path edit. No author code or syntax was run.
