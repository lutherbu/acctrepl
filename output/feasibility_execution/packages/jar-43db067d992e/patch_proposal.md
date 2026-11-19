# Patch proposal: jar-43db067d992e

Economics of Information Search and Financial Misreporting

DOI: 10.1111/1475-679X.12528

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: SAS preparation imports and constructs the annual firm panel, exports main.dta, and Stata reads that intermediate for descriptive statistics, main regressions, and the final-sample CIK/fyear list.

Entry points: `1_sas.sas`, `2_stata.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 3/12528 - Economics-of-Information-Search-and-Financial-Misreporting/kim-datasheet-code-and-identifiers.zip",
      "sha256": "7bab7c91b06063b9e6c50d2234427c9291bb3c5de8ea9953c5c57746ea8d6bb6"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "f9f42761efced09d5b102fe5551b79be57c05b6c91d276e4204b2ecb84db495e"
}
```

## Proposed actions

### A_ROUTE_INPUTS: Resolve each required author input against a compatible source and its code-consumed raw fields, identifiers, date windows, and history. The frozen local candidates are useful route candidates but several have explicit field mismatches, and one-row success does not establish population or history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPUSTAT_ANNUAL, R_COMPUSTAT_QUARTERLY, R_CRSP_MONTHLY, R_CRSP_DAILY, R_CCM_LINK, R_AA_NONRELIANCE, R_AA_SUPPLEMENT, R_IBES_SUMMARY, R_IBES_LINK, R_TFN_OWNERSHIP, R_COMP_SHORT, R_WRDS_BETA, R_RYAN_EDGAR, R_SEC_EDGAR_INDEX, I_LOCAL_CANDIDATE_GAPS
Evidence: E_SHEET_PRODUCTS, E_SAS_FUND_CRSP_CCM, E_SAS_RESTATEMENTS, E_SAS_IBES, E_SAS_TFN, E_SAS_SHORT, E_SAS_BETA, E_SAS_EDGAR_BEGIN, E_SAS_EDGAR_END, E_SAS_EDGAR_LINK, E_SAS_EDGAR_USE, E_CATALOG_FUNDA, E_CATALOG_FUNDQ, E_CATALOG_MSF, E_CATALOG_DSF, E_CATALOG_CCM, E_CATALOG_AUDIT, E_CATALOG_AUDIT_ALIAS, E_CATALOG_IBES, E_CATALOG_IBCRSPHIST, E_CATALOG_TFN, E_CATALOG_SHORT, E_CATALOG_BETA_SUITE, E_CATALOG_BETA_FILE, E_PROBE_FUNDQ, E_PROBE_CCM, E_PROBE_IBES, E_PROBE_IBCRSPHIST, E_PROBE_TFN, E_PUBLIC_SEC_EDGAR, E_SAS_RETURN_WINDOWS, E_SAS_PERSISTENCE_HISTORY, E_SAS_FSCORE_HISTORY, E_SAS_RDQ_HISTORY, E_SAS_RESTATEMENT_LEAD_WINDOW

Preparation / proposed procedure:

1. For the local candidates, resolve the exact required fields without treating candidate-schema gaps as vendor-product absence: COMP.FUNDA conml, naics, ggroup, gind, gsector, gsubind; CRSP.MSF ewretd; CRSP.DSF sprtrn; Audit Analytics res_sec_invest, res_acc_res_fkey_list, res_notif_key; and Compustat short interest cik.
2. Confirm date, identifier, population, and history coverage for readable local candidates: annual 1980–2020 plus the code's two-year F-score and ten-year persistence windows; quarterly RDQ history; fiscal-date monthly/daily return windows; active CCM and I/B/E/S link intervals; and the stated ownership, short-interest, restatement, and EDGAR periods.
3. Clarify compatible author inputs and source contracts for the Audit Analytics supplemental workbook, Beta Suite B_MKT file, James Ryan 2003–2017 CSV series, and tab-delimited SEC index. Keep raw sources and produced intermediates distinct.

Validation to perform later:

- Document a compatible local or public route for every required input, with the raw source columns, key mapping, date coverage, and transformations verified against the supplied code before a future run.

### A_SAS_RUNTIME: SAS 9.4 runtime initialization remains unverified after the recorded TKELS/launch-service startup error. Resolve the host runtime setup and confirm required procedures before any separately authorized author-program run; the error does not establish a licensing barrier.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENVIRONMENT, E_README_SAS, E_COMMON_HOST_WRAPPER

Preparation / proposed procedure:

1. Use the documented SAS batch parameters `-nodms -work [redacted-path-661134a281e3] -autoexec operator SAS autoexec` after the host runtime initialization issue is resolved.
2. Confirm SAS batch availability and the supplied workflow's required import, SQL, sort, summary, regression, and export procedures; do not infer license status from the TKELS error.

Validation to perform later:

- A separately authorized metadata check confirms SAS batch initialization and required Base procedures before the author workflow is run.

### A_STATA_ADDONS: Stata 18 is available, but winsor2 is not found in the checked default/shared adopaths and the required relative-path `which univar` probe returned command code 111. The ado source/version compatible with the authors' use is not supplied; prepare a compatible implementation before a future analysis run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_UNIVAR
Evidence: E_STATA_INPUT_AND_ADDONS, E_ENVIRONMENT, E_UNIVAR_METADATA

Preparation / proposed procedure:

1. Identify the author-compatible winsor2 and univar ado sources/revisions and the intended Stata adopath; keep installation as future software preparation.
2. After a separately authorized setup, use read-only command metadata to confirm each required command resolves in the same Stata runtime.

Validation to perform later:

- Record the resolved command paths and versions for winsor2 and univar before any author analysis code is run.

### A_BETA_MAPPING: Identify the author-prepared WRDS Beta Suite input or its documented producer and the raw mapping for daily PERMNO/date B_MKT records; preserve the supplied join contract until the source is established.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_BETA_PRODUCER_MAPPING, R_WRDS_BETA
Evidence: E_SHEET_PRODUCTS, E_SAS_BETA, E_CATALOG_BETA_SUITE, E_CATALOG_BETA_FILE

Preparation / proposed procedure:

1. Request the prepared file specification or a documented producer/source mapping for beta_d_FF3_Jan90_Dec19.sas7bdat.
2. Confirm the B_MKT field, PERMNO/date key, and date coverage before a later input validation.

Validation to perform later:

- The selected source contract supports the supplied B_MKT join without assuming an unprovided beta-construction stage.

### A_HOST_PATHS: The supplied programs contain Windows data and handoff paths, while the documented host wrappers require batch execution with relative or [redacted-path-6df88a6f9dd9] paths. Prepare a coherent task-specific path mapping for the SAS DATA library, external file inputs, the SAS main.dta export, and the Stata input. The SAS setup line withheld by screening is not reproduced; its non-sensitive root mapping remains to be confirmed.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R_COMPUSTAT_ANNUAL, R_COMPUSTAT_QUARTERLY, R_CRSP_MONTHLY, R_CRSP_DAILY, R_CCM_LINK, R_AA_NONRELIANCE, R_AA_SUPPLEMENT, R_IBES_SUMMARY, R_IBES_LINK, R_TFN_OWNERSHIP, R_COMP_SHORT, R_WRDS_BETA, R_RYAN_EDGAR, R_SEC_EDGAR_INDEX, SW_SAS, SW_STATA
Evidence: E_COMMON_HOST_WRAPPER, E_SAS_FUND_CRSP_CCM, E_SAS_RESTATEMENTS, E_SAS_PANEL, E_STATA_INPUT_AND_ADDONS

Preparation / proposed procedure:

1. Create a task-specific working copy and separate staged-input and generated-output directories outside the evidence/probe directory.
2. Confirm the non-sensitive SAS DATA library root and map each required input path to a relative or [redacted-path-6df88a6f9dd9] location supported by the host wrappers.
3. Map the SAS main.dta export and Stata main.dta input to the same handoff path in the working tree; keep the screened setup line and any authentication material out of evidence.

Validation to perform later:

- Before a separately authorized run, confirm every input/output path resolves in the host working directory or under [redacted-path-6df88a6f9dd9] and that the SAS export path equals the Stata read path.

### A_RUN_ORDER: The documented handoff is a full SAS preparation stage followed by Stata analysis and final-sample identifier export. Run only after the source, software, and host-path contracts are resolved and the user separately authorizes execution.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_COMPUSTAT_ANNUAL, R_COMPUSTAT_QUARTERLY, R_CRSP_MONTHLY, R_CRSP_DAILY, R_CCM_LINK, R_AA_NONRELIANCE, R_AA_SUPPLEMENT, R_IBES_SUMMARY, R_IBES_LINK, R_TFN_OWNERSHIP, R_COMP_SHORT, R_WRDS_BETA, R_RYAN_EDGAR, R_SEC_EDGAR_INDEX, SW_SAS, SW_STATA
Evidence: E_README_SAS, E_README_STATA, E_SAS_PANEL, E_STATA_INPUT_AND_ADDONS, E_STATA_MODELS, E_STATA_IDENTIFIERS, E_COMMON_HOST_WRAPPER

Preparation / proposed procedure:

1. Stage and map each required raw input in the isolated working tree using only the confirmed routes and host-compatible paths.
2. Run 1_sas.sas in documented batch mode; it builds data_final, applies the main-sample preparation, and exports main.dta.
3. After confirming the produced main.dta path, run 2_stata.do from the same working tree; it reads main.dta, performs descriptive and regression analysis, and exports K_Identifiers.xlsx.
4. Keep generated outputs in the working output directory and keep the assessment evidence/probe directory read-only for the future run.

Validation to perform later:

- Before execution, verify the source/input mapping and exact SAS-to-Stata handoff path; after a separately authorized run, confirm the generated main.dta is the file Stata reads and K_Identifiers.xlsx contains the final-sample CIK/fyear identifiers.


## Remaining issues and prerequisites

- I_LOCAL_CANDIDATE_GAPS [unresolved; full_pipeline]: The frozen local candidates do not yet close several raw-source contracts: COMP.FUNDA lacks the directly selected raw fields conml, naics, ggroup, gind, gsector, and gsubind; CRSP.MSF lacks ewretd; CRSP.DSF lacks sprtrn; the related AUDIT.FEED39_FINANCIAL_RESTATEMENTS candidate lacks res_sec_invest, res_acc_res_fkey_list, and res_notif_key; and COMP.SEC_SHORTINT lacks cik, which the supplied join uses directly. Other bounded successful one-row reads show coverage_verified=false; TFN.S34's candidate field metadata lists its expected names but its 15-second readability probe timed out. These are candidate-level field/history/inspection gaps, not evidence that a vendor product or license is unavailable.
- I_BETA_PRODUCER_MAPPING [unresolved; full_pipeline]: The supplied SAS directly reads a daily Beta Suite prepared file and joins B_MKT by PERMNO/date. The datasheet names WRDS Beta Suite, but the supplied package has no producer or raw-field mapping and exact frozen-catalog alias lookups did not establish a compatible route. The source/producer remains unknown; lookup results do not establish data absence or license status.
- R_COMPUSTAT_ANNUAL [undetermined]: Annual data.funda input used for firm characteristics, restatement outcomes, F-score and EPS-persistence construction; code filters FYR-positive observations with fyear 1980–2020 and needs the lag history used in those transformations.
- R_COMPUSTAT_QUARTERLY [undetermined]: Quarterly input used to obtain fourth-quarter earnings announcement dates and prior-year quarterly dates; code filters FYR-positive observations with fyearq 1980–2020.
- R_CRSP_MONTHLY [undetermined]: Monthly security returns and prices are joined around fiscal dates for annual returns, volatility, price and buy-and-hold-return measures.
- R_CRSP_DAILY [undetermined]: Daily prices/returns are joined at annual announcement dates and at the code's stated event-date windows.
- R_CCM_LINK [undetermined]: Link history maps Compustat GVKEY to PERMNO using LINKTYPE and LINKDT/LINKENDDT conditions in both annual and quarterly joins.
- R_AA_NONRELIANCE [undetermined]: SAS derives restatement, HLM restatement, fraud and SEC-investigation indicators from this input and joins them by CIK/date.
- R_AA_SUPPLEMENT [undetermined]: SAS imports the named restatement-data sheet, renames CIK_CODE and RESTATEMENT_KEY, and uses cumulative change in net income and disclosure date to construct the restatement amount.
- R_IBES_SUMMARY [undetermined]: SAS selects FPI=1 forecasts before fiscal-period end, deduplicates by TICKER/FPEDATS and later consumes NUMEST.
- R_IBES_LINK [undetermined]: SAS matches each ticker/estimate date to its link-date interval and uses PERMNO plus SCORE for deduplication.
- R_TFN_OWNERSHIP [undetermined]: SAS constructs security/date ownership shares and institution counts from manager-level holdings.
- R_COMP_SHORT [undetermined]: SAS creates month-end dates, joins by GVKEY/CIK and month, and scales shortintadj by shares outstanding.
- R_WRDS_BETA [undetermined]: This is a direct SAS input with no producer in the supplied SAS file; the code joins B_MKT by PERMNO/date to construct BETAff.
- R_RYAN_EDGAR [undetermined]: SAS imports 15 yearly page-view files, concatenates them, joins by CIK/accession and aggregates DRTPV by CIK/date and filing form.
- R_SEC_EDGAR_INDEX [undetermined]: The index supplies CIK, ACCESSION and FORM for the join to annual page-view records; code removes duplicate CIK/accession keys.
- SW_SAS [unverified]: SAS 9.4 TS1M8 is listed by the host environment, but bounded runtime startup attempts failed during TKELS/launch-service initialization. Runtime readiness is unverified; the error does not establish a license problem.
- SW_WINSOR2 [preparation_required]: winsor2 is not found in the checked default/shared Stata adopaths. The required command's author-compatible source/version is not established; this is future software preparation, not an access or license barrier.
- SW_UNIVAR [preparation_required]: The relative-path batch `which univar` probe did not find the command (Stata command return code 111). The required command's source/version compatibility is not established; this is future software preparation, not an access or license barrier.

## Review notes

- The assigned package contains the two executable entry programs 1_sas.sas (668 lines) and 2_stata.do (55 lines), source documentation, and K_Identifiers.xlsx; it does not contain the raw source datasets or a standalone analysis dataset. The workbook is a final-sample CIK/fyear identifier list, not analysis data.
- The full pipeline scope preserves the documented SAS preparation/export followed by Stata analysis/final-sample identifier export. ARIN Whois, TAQ, WRDS SEC Analytics Suite Form 4/8-K/exhibits, insider trades, and hand-collected float are mentioned in the datasheet but are not direct inputs in either supplied entry program.
- Frozen catalog actual file SHA-256 is 4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27. The catalog's internal PROC CONTENTS text hash is 45894893e45d56cb56150252c2ce4e85dfa88f5d891f3e547d3e9ea8003993fb; these identify different artifacts.
- Catalog candidates have specific field gaps recorded in the requirements: COMP.FUNDA conml/naics/ggroup/gind/gsector/gsubind, CRSP.MSF ewretd, CRSP.DSF sprtrn, the related Audit Analytics FEED39 candidate res_sec_invest/res_acc_res_fkey_list/res_notif_key, and COMP.SEC_SHORTINT cik. A candidate schema gap does not establish absence from the named vendor product or entitlement.
- One-row bounded metadata reads succeeded for COMP.FUNDQ, CRSP.CCMXPF_LINKTABLE, IBES.STATSUM_EPSUS, and WRDSAPPS.IBCRSPHIST; each reports coverage_verified=false. TFN.S34 field metadata lists the expected names, but its 15-second one-row attempt timed out and was not retried. No sample data values were retained in the assessment.
- The exact Beta Suite and beta_d_FF3 catalog lookups did not establish a matching prepared file. SAS directly joins B_MKT by PERMNO/date and no in-package producer is supplied; this remains a specific unresolved source/producer question, not a confirmed unavailable dataset or license barrier.
- The SEC public static page capture describes EDGAR log-file data for January 1, 2003 through June 30, 2017. No year/download link or payload was requested, and that page does not establish compatibility with edgar_daily_index.txt or James Ryan's page-view files. The James Ryan homepage fetch returned 502; this does not establish data absence/access restriction, and there was no retry or payload request.
- SAS startup remains unverified after the recorded TKELS/launch-service initialization error; no license conclusion is drawn. Stata 18 is available; reghdfe 6.12.3 and ftools 2.49.1 are available; winsor2 was not found in checked adopaths and relative-path `which univar` returned Stata command code 111. Their author-compatible ado versions remain unknown; no installation was performed.
- common/README.md states the host Stata/SAS wrappers require batch mode with relative or [redacted-path-6df88a6f9dd9] paths. Supplied code uses Windows data/handoff paths; the SAS setup line at line 2 was withheld as a complete opaque line by the fail-closed reader and is not reproduced. A coherent host-root/DATA-library and same-file SAS-to-Stata mapping remains future configuration preparation.
- A malformed first reader invocation split the cached datasheet filename at its space and returned argparse code 2 before reading; its process-only JSON capture is retained without scientific-evidence references, and a corrected quoted invocation succeeded. The first Stata metadata call used an absolute .do path; its exact artifacts were preserved before the compliant relative-path rerun. The first log summarizer also selected an echoed Stata command line and errored; its helper copy/error record are preserved and the corrected summary captures the unchanged Stata result.
- No author program, analysis, model, statistical command, data payload, installation, credential/connection use, or external message was performed. The only new Stata invocation queried `which` command metadata; the existing SAS startup record was not repeated. The assigned draft still needs the coordinator's independent source QA and separate replay after this package submission is finalized.
