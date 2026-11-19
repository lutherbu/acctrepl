# Patch proposal: jar-e16cd4bf92ad

Zombie Board: Board Tenure and Firm Performance

DOI: 10.1111/1475-679X.12209

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: prepare author-cleaned IRRC director and SDC M&A datasets, assemble the 1998–2010 firm-year analysis panel, produce the main Table 3 specifications and lowess plot, and account for online appendix Tables A1–A9. The supplied Stata files only partially cover the documented outputs.

Entry points: `MainCode_JAR.DO`, `ProcessIRRC_SDCCode_JAR.DO`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 4/12209 - Zombie-Board-Board-Tenure-and-Firm-Performance/hh-datasheet-and-code.zip",
      "sha256": "0dcc5bf1aff19f3d44616f52736615183346ee9455d04954f4f138749334471b"
    },
    {
      "path": "JAR-Volume 56/Issue 4/12209 - Zombie-Board-Board-Tenure-and-Firm-Performance/hh-online-appendix.pdf",
      "sha256": "2261a98c72ff612a950efb6526c4c0614ebda4cfc75d059923e8e894dcd7403d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "52458dd9c92f5e84dbc4af17522d1fa626c6ab4be39899b3a5d06caf91cf6407"
}
```

## Proposed actions

### ACT_INPUTS: Obtain the author-prepared inputs or confirm a compatible local-product mapping and required input schemas for the full pipeline.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_GOV_LEGACY, R_GOV_CURRENT, R_IRRC_DIRECTOR, R_MEETING_MAP, R_COMP_SEG, R_COMP_ANNUAL, R_COMP_DISCLOSURE, R_CRSP_COMP, R_RET_FISCAL, R_EXEC_CEO, R_SDC_RAW, R_FIRMAGE, R_IPO, R_SPINOFF, IS_INPUT_CONTRACTS
Evidence: EV_DATASHEET_SOURCES, EV_MAIN_GOV, EV_MAIN_EXEC, EV_MAIN_SEG, EV_MAIN_COMP, EV_MAIN_MA, EV_MAIN_FIRMAGE_IPO, EV_MAIN_RET, EV_PROCESS_CROSSWALK, EV_PROCESS_MANUAL, EV_PROCESS_SDC, EV_PROCESS_HANDOFF, EV_CATALOG_PRODUCTS, EV_AUTHOR_COMP_FIELDS, EV_AUTHOR_DID_FIELDS, EV_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Verify the RISK.GSET candidate against the legacy CN6/YEAR/CBOARD input and confirm the author-required 1990–2006 range; verify RISK.RMGOVERNANCE against the CUSIP/Year/CBOARD input and its 2007–2015 range. Convert only after those source and period mappings are confirmed.
2. Provide the author-prepared tenure_irrc19962010_did input with its actual fields and unique director IDs, plus meetingdate_datadate_match with gvkey, meetingdate, datadate and diff_meetdate_datadate. The local RiskMetrics director tables and the author’s separate Co-opted Boards link workbook are candidates, not confirmed substitutes for this cleaned input.
3. Provide or verify the Compustat segment source with gvkey, datadate, stype, snms and SICS1 for BUSSEG observations. Confirm history includes the prior available segment record used for nseg_lag.
4. Provide or map compustat19502012 and compustat19502010_disclosure to the code’s GVKEY/FYEAR accounting columns. Confirm lag construction retains the prior-year observations needed before the 1998–2010 estimation filter.
5. Provide the consumed crspcomp19502010_prc0mth author-prepared merge or a documented compatible construction mapping from local Compustat/CRSP sources; do not treat separate monthly tables as the merged author file.
6. Provide ret_fiscal_date with GVKEY/FYEAR/DATE/RET or its exact producer. Confirm prior fiscal observations needed for the 1998 return lags and coverage through 2010.
7. Provide ceo_Execucomp19922010 with the consumed GVKEY/YEAR/EXECID/CEO fields, including CEOTENURE and I_CEOFOUNDER. The linked author Compensation Data page lists a different Delta/Vega product and is not a direct replacement on current evidence.
8. Provide the SDC input schema or export so dataset_ma retains GVKEY, FYEAR and DealNumber/dealnumber through the companion stage; confirm the one-year predecessor required by MainCode’s acquisition lags.
9. Provide author-prepared firmage (GVKEY/FYEAR/LN_FIRMAGE), ipo (year/CN6/I_IPO_LAG) and spinoff (year/CN6/I_SPINOFF_LAG), or their exact producers. Preserve the documented Ritter/Capital IQ/Hoover/CRSP founding-year measure rather than replacing it with pure CRSP listing age.
10. Before a later authorized run, validate file readability, required keys/fields and periods, then inspect generated dataset_irrc and dataset_ma schemas against the consuming MainCode merge keys.

Validation to perform later:

- Confirm all named source files or mapped local routes contain the stated source columns and required period/history before running author code.
- After a separately authorized run, inspect dataset_irrc and dataset_ma keys/columns and confirm MainCode merges complete without dropping required branches.

### ACT_APPENDIX: Request the appendix analysis entry points and data contracts needed to reproduce Tables A1–A9.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: IS_APPENDIX_WORKFLOW
Evidence: EV_APPX_TOC, EV_APPX_SCOPE, EV_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask the authors to identify the program(s), stage order, prepared inputs and output-to-table mapping for appendix Tables A1–A9.
2. Keep appendix source names and variable formulas as clarification leads until the authors provide a runnable workflow or exact prepared analysis inputs.

Validation to perform later:

- Map each appendix table A1–A9 to a supplied entry point and its input/output schema before marking full-pipeline closure complete.

### ACT_TABLE3_EXPORT: Append model groups 2–5 to table3.xls so the file retains all five existing Table 3 specification groups.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: IS_TABLE3_OVERWRITE
Evidence: EV_MAIN_EXPORT, EV_MAIN_ANALYSIS

**Proposed edit:** `MainCode_JAR.DO:272–272`
Source SHA-256: `b4eb3dc480f93e2a50495ceb1a7924a6f035f9817ccfea7b5a3d76be3cdfa1d6`

Preserve this model group in table3.xls after earlier outreg2 model groups instead of resetting the file and discarding their results.

Current text:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) replace	
```

Proposed replacement:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) append	
```

**Proposed edit:** `MainCode_JAR.DO:280–280`
Source SHA-256: `b4eb3dc480f93e2a50495ceb1a7924a6f035f9817ccfea7b5a3d76be3cdfa1d6`

Preserve this model group in table3.xls after earlier outreg2 model groups instead of resetting the file and discarding their results.

Current text:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) replace
```

Proposed replacement:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) append
```

**Proposed edit:** `MainCode_JAR.DO:288–288`
Source SHA-256: `b4eb3dc480f93e2a50495ceb1a7924a6f035f9817ccfea7b5a3d76be3cdfa1d6`

Preserve this model group in table3.xls after earlier outreg2 model groups instead of resetting the file and discarding their results.

Current text:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) replace 	
```

Proposed replacement:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) append 	
```

**Proposed edit:** `MainCode_JAR.DO:295–295`
Source SHA-256: `b4eb3dc480f93e2a50495ceb1a7924a6f035f9817ccfea7b5a3d76be3cdfa1d6`

Preserve this model group in table3.xls after earlier outreg2 model groups instead of resetting the file and discarding their results.

Current text:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) replace		
```

Proposed replacement:
```
	outreg2	using table3.xls,excel drop (_I*) tstat  aster(tstat) bdec(3) tdec(2) append		
```

Preparation / proposed procedure:

1. Apply the four exact MainCode_JAR.DO line changes shown below only in a later authorized source-edit step.
2. Keep the first group’s line 265 replace and its line 267 append; the four later group starts become append, while their existing second calls remain append.

Validation to perform later:

- After a separately authorized run, confirm table3.xls contains both dependent-variable estimates for all five named specification groups.

### ACT_OUTREG2: Configure or obtain the free Stata outreg2 command in the Stata 18 adopath used for this run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2
Evidence: EV_ENV_STATA, EV_MAIN_EXPORT

Preparation / proposed procedure:

1. Make outreg2 available to Stata without changing the regression specifications.
2. Retain reghdfe 6.12.3 and ftools 2.49.1 as already available in the checked adopaths.

Validation to perform later:

- In Stata 18, verify `which outreg2` resolves to an ado file before any separately authorized author-code run.


## Remaining issues and prerequisites

- IS_INPUT_CONTRACTS [unresolved; full_pipeline]: Several consumed inputs have no producer in either supplied program (meetingdate_datadate_match, compustat19502010_disclosure, firmage, ipo, spinoff and ret_fiscal_date). The companion SDC program reads the raw SDC dataset_ma under [redacted-path-ad3fb8f2201f] and writes a distinct dataset_ma under [redacted-path-fec4d2209add]; MainCode then expects gvkey/fyear/dealnumber in that output, but the producer does not construct gvkey/fyear. The generated dataset_irrc handoff also needs an author-confirmed schema for MainCode’s cn6/year, gvkey/fyear and datadate joins; the director keep list omits cn6 before the later CRSP/Compustat merge, which may or may not add it.
- IS_APPENDIX_WORKFLOW [unresolved; full_pipeline]: The online appendix reports Tables A1–A9 covering robustness, tenure diversity, death-event reconciliation/returns, matched restatements, additional controls and SEM, but the package contains no executable appendix analysis entry point. MainCode_JAR.DO produces its supplied Table 3 specifications and a lowess plot only; appendix narrative and results do not establish the missing program order, inputs or output schemas.
- IS_TABLE3_OVERWRITE [preparation; full_pipeline]: Each of the five Table 3 model groups writes to table3.xls with replace on its first regression call and append on its second. The later groups therefore overwrite earlier groups, leaving only the last group’s two estimates.
- R_IRRC_DIRECTOR [undetermined]: Author-prepared `tenure_irrc19962010_did.dta` director panel. ProcessIRRC_SDCCode_JAR.DO expects director/firm identifiers, meeting/year, tenure and board/control fields; its comments describe manual GVKEY/CN6 mapping and unique did cleaning.
- R_MEETING_MAP [undetermined]: Author-prepared `meetingdate_datadate_match` crosswalk used by the companion program; it must map GVKEY/meetingdate to datadate and provide diff_meetdate_datadate for the 720-day exclusion.
- R_COMP_DISCLOSURE [undetermined]: Additional Compustat disclosure file `compustat19502010_disclosure`, merged 1:1 on GVKEY/FYEAR and used with the CRSP/Compustat file for accounting controls.
- R_CRSP_COMP [undetermined]: CRSP/Compustat merged file `crspcomp19502010_prc0mth.dta`, consumed in both the IRRC preparation and main financial-variable construction.
- R_RET_FISCAL [undetermined]: Preprocessed `ret_fiscal_date.dta` with daily/fiscal-date returns used for standard deviation and compounded fiscal-year return, then one-year lags.
- R_EXEC_CEO [undetermined]: CEO/Execucomp input `ceo_Execucomp19922010.dta` for CEO demographics, ownership, tenure and founder indicator.
- R_SDC_RAW [undetermined]: Raw SDC M&A input `[redacted-path-6fab2220e751]`; companion code filters/decorates deals and saves dataset_ma for the main count/lag merge.
- R_FIRMAGE [undetermined]: Relative path `firmage.dta` consumed by MainCode; required final field is LN_FIRMAGE at GVKEY/FYEAR. Author comment describes founding year from Ritter first, manual Capital IQ/Hoover follow-up, then first CRSP appearance.
- R_IPO [undetermined]: Relative path `ipo.dta` consumed by MainCode for `I_ipo_lag`, keyed by year and CN6.
- R_SPINOFF [undetermined]: Relative path `spinoff.dta` consumed by MainCode for `I_spinoff_lag`, keyed by year and CN6.
- SW_OUTREG2 [preparation_required]: Invoked by every Table 3 regression export call and not found in the checked Stata adopaths.

## Review notes

- Saved checkpoint after reading the datasheet, appendix, both native Stata programs, the frozen dependency list, product catalog, and bounded local/package/software probes. All new raw inputs and source paths are assessed as candidates only; one-row SAS reads do not establish population or historical coverage.
- firmlist.xlsx is a one-column GVKEY identifier list and neither do-file imports it; it is not a final analysis panel.
- No analysis_only scope is supported because there is no supplied complete analysis dataset or demonstrated compatible full panel bypass.
- Manual IRRC/ID construction described in source comments is historical preparation. The preferred requirement is the author-prepared cleaned director input; do not add the original proxy/Capital IQ lookup as a live requirement when that compatible file is supplied.
- Local SAS product probes use row_limit=1 and confirm only readability plus the listed sample columns; they do not establish full population or historical coverage. They do not create a SAS runtime requirement for this Stata-authored workflow.
- The preparation code generates dataset_irrc and dataset_ma in separate, traceable locations, and MainCode generates num_acq/num_acq_lag from the produced dataset_ma. The unresolved concern is the required key/schema contract, not absence of these producer blocks.
- MainCode’s `replace`→`append` proposal changes only output behavior; it leaves all five model groups and their specifications intact. No proposed edit was applied.
