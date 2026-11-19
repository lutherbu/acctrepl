# Patch proposal: jar-a71a7758d50c

Does Corporate Social Responsibility (CSR) Create Shareholder Value? Evidence from the Indian Companies Act 2013

DOI: 10.1111/1475-679X.12174

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented Indian Companies Act 2013 CSR workflow, including the India-specific CMIE Prowess accounting and stock-return inputs, the author-prepared Table 3–6 analysis dataset, and the hand-collected CSR descriptive measures.

Entry points: `CSRIndia_code_for_JAR.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12174 - Does-Corporate-Social-Responsibility-CSR-Create-Shareholder-Value-Evidence-from-the-Indian-Companies-Act-2013/mr-datasheet-and-code.zip",
      "sha256": "da4932183240468df6d597c9d139755eb2d529077bec86757dd37ba7589f81f7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "8669d779c96a50abb85e20135c6fce68aef7596a74cac2c8646a708e4f55649f"
}
```

## Proposed actions

### act_author_inputs: Request the exact India-specific CMIE and prepared analysis inputs, plus the missing accounting-to-CAR construction specification.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_tables_3_6, req_cmie_accounting, req_cmie_returns, issue_event_map, issue_incomplete_preparation, issue_missing_analysis_input
Evidence: ev_datasheet_cmie, ev_datasheet_rdd, ev_datasheet_returns, ev_code_acctdata, ev_code_commented_step1, ev_code_car_stage, ev_code_tables36, ev_code_event_map

Preparation / proposed procedure:

1. Ask the authors for a permitted compatible tables_3_6.dta input and its producer manifest, with the exact Indian CMIE company-code identifier and required fields.
2. Ask for the CMIE Prowess product/version, years, unit conventions and authorized acquisition access for the Indian firm accounting fields used at the Companies Act 2013 thresholds.
3. Ask for CMIE Prowess stock-return and market-return inputs, event-date mapping, estimation/event windows, three-day market-model CAR construction and the CMIE company-code merge procedure.
4. Keep the RDD sample India-specific; do not replace CMIE/Prowess or Indian company identifiers with U.S. datasets or identifiers.

Validation to perform later:

- Before any future authorized execution, verify that the prepared analysis file contains the documented Indian firms, CMIE company-code key, threshold/running-variable fields, eight event indicators, CAR and controls; verify event mapping and source period against author specifications.

### act_csr_manual_data: Request the separate author-collected India annual-report CSR measures and their descriptive-analysis mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_csr_annual_reports, issue_manual_csr
Evidence: ev_datasheet_csr, ev_datasheet_csr_descriptive

Preparation / proposed procedure:

1. Ask for the author-prepared sample-firm annual-report dataset with CSR actual spend and spend indicator, indexed by CMIE company code.
2. Ask for years, annual-report source/selection rules, any coding instructions, and which descriptive table or output uses these measures.
3. If the authors consider this descriptive branch outside the supplied Tables 3–6 code, retain that scope statement and the corresponding data/workflow boundary.

Validation to perform later:

- Check India sample identifiers, measure definitions, reporting years and output mapping against the author-provided description before treating the descriptive branch as covered.

### act_paths_outputs: Obtain a portable working-directory configuration and the intended durable outputs for Figure 3 and Tables 3–6.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_paths_outputs
Evidence: ev_code_path, ev_code_figure3, ev_code_table3, ev_code_table4, ev_code_table5, ev_code_table6

Preparation / proposed procedure:

1. Ask the authors for the intended package-relative input and output roots replacing the absolute Windows path.
2. Confirm whether the existing outreg2 writes to t5.xls/t6.xls are the complete Table 5–6 output set, and how to preserve/compare Table 3–4 results and Figure 3 graphs.
3. Do not move data or outputs or add guessed table mapping until the authors confirm intended paths and artifacts.

Validation to perform later:

- After an authorized setup, confirm every code output has a durable, relative destination and every named Table 3–6/Figure 3 artifact has a source command.

### act_software: Configure the three missing exact Stata commands in an authorized future execution setup; Stata 18, rdplot and rdrobust were verified by bounded probes.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw_stata, sw_rd, sw_rdplot, sw_rdrobust, sw_cluster2, sw_outreg2
Evidence: ev_environment_stata, ev_probe_rd, ev_probe_rdplot, ev_probe_rdrobust, ev_probe_cluster2, ev_probe_outreg2, ev_code_figure3, ev_code_table4, ev_code_table5, ev_code_table6

Preparation / proposed procedure:

1. Confirm the author-compatible versions and sources for the missing rd, cluster2 and outreg2 commands; obtain/configure them only in a later authorized execution environment.
2. Reuse the verified Stata 18, rdplot and rdrobust commands; preserve the exact supplied syntax and check dependencies before any later authorized run.

Validation to perform later:

- In an authorized execution setup, use bounded which/version checks for rd, cluster2 and outreg2 and record exact resolved versions; do not run the author program as part of this assessment.


## Remaining issues and prerequisites

- issue_missing_analysis_input [unresolved; full_pipeline]: The executable analysis starts by loading tables_3_6.dta, which is not in the package inventory and has no supplied producer. It contains the prepared accounting/CAR sample needed by every listed result.
- issue_incomplete_preparation [unresolved; full_pipeline]: The sample-construction block is inside a block comment; the stock-return/CAR step is described but not implemented in the supplied executable code. The complete path from CMIE raw data to tables_3_6.dta, including units, company key, data period and event dates, is therefore unresolved.
- issue_event_map [unresolved; full_pipeline]: The code creates event1–event8 from tab date but does not map each date value to the paper’s event or provide the market-model estimation/event window. The event-specific CAR producer cannot be reproduced from this package.
- issue_manual_csr [unresolved; full_pipeline]: The authors say CSR spending and spender status are hand-collected from sample firms’ annual reports for descriptive analysis, but the data, Indian company identifiers, annual-report collection steps and descriptive analysis outputs/code are absent.
- issue_paths_outputs [unresolved; full_pipeline]: The code hard-codes a Windows tables directory. Figure 3 and Tables 3–4 are issued to the Stata session without a supplied relative export path; Tables 5–6 write Excel files to the current directory. The sample-generation and CAR steps are not executable in this file.
- req_tables_3_6 [undetermined]: Author-prepared Stata analysis dataset tables_3_6.dta, containing the Indian CSR-rule RDD sample, event-level CAR/accounting variables and identifiers used by the supplied Table 3–6 code (including car3d, m, date/event categories, affected, coid and model controls). No such file is included.
- req_cmie_accounting [undetermined]: Indian-company accounting data from CMIE Prowess for the authors’ Companies Act 2013 RDD sample. The datasheet requires observations around Indian mandatory CSR profitability, net-worth/book-value and sales thresholds; the commented sample-preparation code expects total assets, sales, net income, book value of equity and market capitalization, then builds the affected/RDD sample and running variable M. Exact fiscal-year coverage, Prowess product/version, units and complete control-variable mapping are not specified.
- req_cmie_returns [undetermined]: CMIE Prowess stock returns for the Indian RDD sample, with any market-return series required by the authors’ market-model CAR calculation, event dates and estimation/event windows sufficient to derive three-day CAR around the eight coded events. Merge to accounting data using CMIE company code. Dates, market-series specification, event-window/history and CAR producer are not supplied.
- req_csr_annual_reports [undetermined]: Author hand-collected CSR actual-spending amounts and a whether-the-firm-spends indicator from annual reports of the same Indian sample firms; the datasheet says these data support descriptive analysis only. Required year(s), report set, sample identifiers and descriptive output/code are not supplied.
- sw_rd [preparation_required]: The exact invoked Nichols RD command is not found by the bounded Stata 18 which probe; install/configure the author-compatible command only in an authorized later execution setup.
- sw_cluster2 [preparation_required]: The exact invoked cluster2 command is not found by the bounded Stata 18 which probe; install/configure the author-compatible command only in an authorized later execution setup.
- sw_outreg2 [preparation_required]: The exact invoked outreg2 command is not found by the bounded Stata 18 which probe; install/configure the author-compatible command only in an authorized later execution setup.

## Review notes

- Expanded checkpoint after source review, frozen inventory/catalog lookups, official product-page check, and exact bounded Stata command probes. No author program or empirical data was run.
- The only supported scope is full_pipeline. The supplied program starts at author-prepared tables_3_6.dta, which is absent; no analysis-only scope is supported because the prepared file and compatible route are not supplied.
- The full documented target remains India-specific: CMIE Prowess accounting/returns, CMIE company-code merge, the Indian Companies Act 2013 thresholds, and separate hand-collected CSR measures from Indian sample-firm annual reports. No U.S. data or identifiers are proposed as substitutes.
- The code comments include sample preparation and a stock-return/CAR stage, but those stages are not executable in the supplied file. Event-date mapping, market-model estimation/event history and the complete tables_3_6 producer remain unresolved; no new data construction is inferred.
- Stata 18, rdplot and rdrobust passed bounded checks. The exact invoked rd, cluster2 and outreg2 commands were not found and require later authorized setup. This audit did not install software or run regressions.
- CMIE’s official ProwessIQ page identifies a subscription access route; current account access and paper-specific years, fields, coverage and CMIE company-code export remain unverified. Catalog misses do not establish absent access.
