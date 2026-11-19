# Patch proposal: jar-2e72ff345908

Do U.S. Investors Value Foreign Component Auditors?

DOI: 10.1111/1475-679X.12412

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

As-downloaded supplied workflow for Equity Compensation Plans and Board of Director Discretion over Equity Grants: Equilar plan/grant preparation, CEO labor-market construction, plan and grant samples, then Tables 1–8. The frozen package record still identifies a different registered paper; preserve that metadata and do not attribute this workflow to it.

Entry points: `Equilar_Plans.sas`, `Equilar_Grants.sas`, `Internal_External_CEO.do`, `Equity_Plan_Sample.sas`, `Equity_Grant_Sample.sas`, `Equity_Plan_Grant_Tests.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12412 - Do-U-S-Investors-Value-Foreign-Component-Auditors/cc-datasheet-code-and-identifiers.zip",
      "sha256": "a77eba3e8d7883fcaea28d05774f3bbac9f76c1cf36163807d3f22daafc8ed4f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "4cb42140ff99e310424bb449e6ebd2a8aa1dabfb2d2cd24a6703727517cf574f"
}
```

## Proposed actions

### A_IDENTITY_CONFIRM: Resolve the material package-to-record attribution conflict while retaining the frozen output header.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_IDENTITY_CONFLICT
Evidence: E_IDENTITY, E_WORKFLOW, E_AUTHOR_PRODUCTS

Preparation / proposed procedure:

1. Ask the package curator or authors to confirm why the frozen registered title/DOI identifies the foreign-component-auditor paper while the supplied datasheet and code describe the Cadman/Carrizosa equity-compensation paper.
2. Keep the frozen title and DOI in the assessment record; use the confirmed mapping only to govern later citation and downstream catalog attribution.

Validation to perform later:

- Check the curator's response against the original paper/package record before attributing these files or any results.

### A_LOCAL_SOURCE_COMPATIBILITY: Match the remaining annual/event source candidates to the date, identifier and field contracts in the supplied programs. Successful one-row probes establish local readability and requested columns only; they do not establish the required event/fiscal-date coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_FUNDA, R_EXECUCOMP_PBA, R_EXECUCOMP_ANNCMP, R_CRSP_DSF, R_CRSP_DSI, R_CRSP_STOCKNAMES, R_CCMXPF_LNKHIST, R_CRSP_MSF, R_TFN_S34, R_RISK_DIRECTORS, R_RISK_GOVERNANCE, R_RISK_VAVOTERESULTS, R_BOARDEX_ORG_SUMMARY
Evidence: E_FROZEN_CATALOG, E_CATALOG_LOOKUPS, E_PROBE_COMP_FUNDA, E_PROBE_COMP_PLANBASEDAWARDS, E_PROBE_COMP_ANNCOMP, E_PROBE_CRSP_DSF, E_PROBE_CRSP_DSI, E_PROBE_CRSP_STOCKNAMES, E_PROBE_CRSP_CCMXPF_LNKHIST, E_PROBE_CRSP_MSF, E_PROBE_TFN_S34, E_PROBE_RISK_RMDIRECTORS, E_PROBE_RISK_RMGOVERNANCE, E_PROBE_RISK_VAVOTERESULTS, E_PROBE_BOARDEX_NA_WRDS_ORG_SUMMARY, E_GRANT_CONSTRUCTION_INPUTS, E_PLAN_SAMPLE_INPUTS, E_CRSP_SAMPLE_INPUTS, E_CEO_SOURCE, E_TFN_S34_SOURCE, E_BOARDEX_SOURCE, E_RMDIRECTORS_SOURCE, E_RMGOVERNANCE_SOURCE, E_ISS_VOTING_SOURCE

Preparation / proposed procedure:

1. Within applicable access terms, use the named local Compustat, Execucomp, CRSP, ISS/RiskMetrics, BoardEx and TFN products only where their actual fields and date/key coverage fit the supplied joins; do not treat a similarly named table as a substitute.
2. Match source columns, identifiers, units and date bounds to the source code: annual Compustat dates; Execucomp award rows joined at the absent grant workbook's FY1/FY2/FY3 dates; CRSP fiscal return intervals and event-relative name/link joins; ISS/BoardEx meeting and report dates; and TFN holdings by CUSIP/report date before each plan event.
3. For the CEO classification, preserve the source's 1993–2020 long-window output and its z=2003–2020 rolling construction with y=z−10. The source conditions explicitly permit missing lags and count missing lags; do not demand earlier years solely to make every lag nonmissing. Preserve `YEAR(YEAR)` and other source expressions as written. Treat any extra earlier-history check as fidelity-only unless an actual supplied consumer requires it.
4. The TFN.S34 row-limited metadata request timed out at 15 seconds. Keep its readability and expected columns unverified; do not infer absence or access restriction and do not retry it in this assessment. TFN.S34 remains the institutional 13F holdings input, separate from the CEO FFI48 panel.
5. Prepare the Stata-readable `execucomp_anncomp.dta` from a compatible annual-compensation source with the supplied identifiers and YEAR field. Byte identity with a historical export is not a route requirement; field/type compatibility and the code's stated years are.

Validation to perform later:

- Before author-code execution, record source product/version, required columns, date range and compatible identifiers for each selected table, then verify the planned cross-language file handoffs without changing sample definitions.
- After a separately authorized full run, confirm both SAS sample exports and the CEO panel cover the author-specified periods and match their consumers; retain original transformations and models.

### A_AUTHOR_SPECIFIC_INPUTS: The package names several custom workbooks and product-specific inputs that are absent from its inventory and have no verified compatible route in the frozen catalog.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_EQILAR_PLANS, R_EQILAR_GRANTS, R_EPSC_DATA, R_ERTIMUR_NCA, R_STATENAMES, R_ISSREC
Evidence: E_PACKAGE_INVENTORY, E_AUTHOR_PRODUCTS, E_EQILAR_PLANS_SOURCE, E_GRANT_CONSTRUCTION_INPUTS, E_EPSC_SOURCE, E_CROSSWALK_SOURCE, E_ISS_VOTING_SOURCE, E_CATALOG_LOOKUPS

Preparation / proposed procedure:

1. Request an authorized route to the custom Equilar plan and grant pulls, the ISS EPSC `epsc.dta`, the ISS recommendation input, the Ertimur_NCA.xlsx table and the StateNames.csv crosswalk, or compatible deliveries of those same named products and fields.
2. For each input, establish the format/import contract, fields, identifiers, units and date coverage required by the supplied reads and joins. Use the author-documented source transformations; do not require byte-identical files or a specific historical vintage when a compatible underlying product/coverage satisfies the actual code.
3. Do not infer that a catalog miss means the data are unavailable, public or restricted, and do not replace the missing sources with an independently assembled equivalent.

Validation to perform later:

- Check each delivered input against its exact import/read and join contract before planning the documented stages.

### A_MACRO_AND_HANDOFF_CLARIFICATION: Recover the missing FFI12 SAS and ffind Stata definitions and clarify the produced industry keys needed across the sample and CEO stages.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_FFI12_CODE, I_FFIND_CODE, I_FFI48_HANDOFF
Evidence: E_PACKAGE_INVENTORY, E_FFI12_GRANT_MACRO, E_FFI12_PLAN_MACRO, E_FFIND_FFI48, E_FFI48_PANEL, E_FFI48_JOIN, E_TEST_FFI12_ROLE

Preparation / proposed procedure:

1. Request the exact `ffi12.sas` and `ffind.do` versions, their source/version and the authors' specified include locations, parameters, inputs and output fields.
2. Clarify whether the plan-sample `%ffi12(sich)` call creates or preserves `FFI48` for the join to `insiders_perc.dta`, and confirm the compatible FFI48 coding used by the CEO macro and the distinct FFI12 industry controls in Stata.
3. Preserve the supplied `YEAR(YEAR)` expression, ten lag variables, 1993–2020 long-window definition, and rolling conditions z=2003–2020 with y=z−10. The supplied classification conditions permit missing lags and count missing lags; do not request earlier years solely to make every lag nonmissing. Treat any extra history check as fidelity-only unless an actual supplied consumer requires it. Do not change the formula.

Validation to perform later:

- After receiving the definitions, statically confirm call/field/key compatibility and the producer-before-consumer order; use the supplied macro versions in any later authorized run.

### A_PATH_CONFIGURATION: Set a consistent host-side configuration for SAS inputs/outputs, macro includes, CEO panel files and Stata inputs/results before a future run.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_SETUP
Evidence: E_PATH_SAS_ROOT, E_PATH_CEO_ROOT, E_PATH_CEO_TEMP, E_PATH_TEST_ROOT, E_PLAN_SAMPLE_INPUTS, E_CRSP_SAMPLE_INPUTS

Preparation / proposed procedure:

1. Choose a writable shared data/output root for SAS `Path1` and the Stata `$path`/`cd`; use the host wrapper's supported relative or `[redacted-path-693efe1afd01]`-based paths rather than embedding a Dropbox workspace path. Place or make available the author inputs there and ensure SAS `EP` outputs and exported DTA files reach the Stata consumers.
2. Set `Path2` to the directory containing the recovered `ffi12.sas` and make the CEO `ffind.do` available at the author-specified Stata include location.
3. Choose the Stata `printdir` and confirm the CEO stage's temporary `perc_insider` files are written in a writable current directory while its final `insiders_perc.dta` is written where `Equity_Plan_Sample.sas` imports it.
4. Keep these as explicit configuration values until the actual host paths are known; no source line can be safely replaced with a guessed path.

Validation to perform later:

- Before a later run, verify every configured input, include, generated handoff and output path resolves consistently across SAS and Stata.

### A_SOFTWARE_READINESS: Resolve the author workflow's unverified runtime and exact Stata command entry points before a future run, without changing the author programs or estimator calls.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS_94, S_OUTREG2, S_WINSOR, S_DISTINCT, S_OUTTABLE, S_ESTSTO
Evidence: E_ENVIRONMENT, E_STATA_WINSOR, E_STATA_DISTINCT, E_STATA_OUTTABLE, E_STATA_OUTREG2, E_STATA_ESTSTO, E_STATA_XTLOGIT

Preparation / proposed procedure:

1. Have the environment owner verify a usable SAS runtime for this workflow through the institution's supported setup. The existing environment artifact reports a TKELS startup failure; it does not establish license status or a universal access barrier, and no new SAS startup check is part of this assessment.
2. Confirm an authorized Stata 18 compatible `outreg2` command is installed and on the active adopath; the existing probe did not find it in the checked paths.
3. Check the exact commands `winsor`, `distinct`, `outtable` and `eststo` on the intended Stata 18 adopath. The available `winsor2` check is not evidence about the separately invoked `winsor` command; obtain the authors' expected command/package versions if needed.
4. Retain the available `esttab` entry point. Preserve the source's actual `xtlogit proposal ..., fe vce(bootstrap)` specification and its Table VIII margins/reporting steps.

Validation to perform later:

- Verify the exact invoked command names and runtime versions in the intended environment before a separately authorized full workflow run; do not substitute a different command or model.

### A_INCOMPLETE_CLOSURE: Complete the unresolved native input and producer/consumer contracts before treating the packaged full workflow as closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INPUT_CLOSURE
Evidence: E_WORKFLOW, E_ANALYSIS, E_PACKAGE_INVENTORY, E_CATALOG_LOOKUPS, E_FFI48_PANEL, E_FFI48_JOIN, E_PATH_CEO_TEMP, E_TFN_S34_SOURCE

Preparation / proposed procedure:

1. Use the documented full sequence: Equilar_Plans.sas produces EP.equity_plans; Equilar_Grants.sas produces EP.equity_grants; Internal_External_CEO.do produces insiders_perc.dta; then run both SAS sample stages, followed by Equity_Plan_Grant_Tests.do for Tables 1–8. Equity_Plan_Sample.sas consumes EP.equity_plans, EP.equity_grants and the CEO panel to export equity_plan_sample.dta; Equity_Grant_Sample.sas consumes the plan/grant tables and creates EP.fy_rets before exporting equity_grant_sample.dta. Preserve the macro/key gaps as unresolved.
2. In the plan branch, the Stata analysis reads equity_plan_sample.dta, saves eps0, eps1 and ep_det_samp, generates ep_det_samp_pred from its supplied predictions/residuals, then merges that intermediate to create ep_vote_samp. In the grant/timing branch, it separately reads equity_grant_sample.dta and preserves the original Table V–VIII steps.
3. The ten SAS `by group` clauses and ten Stata `use ..., replace` calls each have a supported, unapplied same-method repair in the separate static compatibility actions: SAS `GROUP BY` with unchanged grouping keys and Stata `use ..., clear` with unchanged reload targets. No syntax trial or source edit was made.
4. After input, macro, path and software contracts are resolved, make a future authorized run preserve the original sample restrictions, Tables I–VIII and bootstrap fixed-effects Table VIII model; record outputs and logs from that run without treating this static assessment as execution evidence.

Validation to perform later:

- A future closure review should map each of the 44 checklist edges to a verified external input, supplied producer/output, software dependency or explicit unresolved issue before execution.

### A_SAS_GROUP_BY_REPAIRS: Prepare a working copy with the ten SAS PROC SQL grouping clauses in the documented GROUP BY word order, preserving all existing aggregate variables, grouping keys, joins and order clauses.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SAS_GROUP_BY
Evidence: E_SAS_GROUP_BY_OFFICIAL, E_COMPAT_SAS_EQUILAR_GRANTS_L174, E_COMPAT_SAS_EQUILAR_PLANS_L57, E_COMPAT_SAS_EQUITY_GRANT_SAMPLE_L93, E_COMPAT_SAS_EQUITY_GRANT_SAMPLE_L128, E_COMPAT_SAS_EQUITY_PLAN_SAMPLE_L106, E_COMPAT_SAS_EQUITY_PLAN_SAMPLE_L214, E_COMPAT_SAS_EQUITY_PLAN_SAMPLE_L253, E_COMPAT_SAS_EQUITY_PLAN_SAMPLE_L265, E_COMPAT_SAS_EQUITY_PLAN_SAMPLE_L332, E_COMPAT_SAS_EQUITY_PLAN_SAMPLE_L339

**Proposed edit:** `Equilar_Grants.sas:174–174`
Source SHA-256: `5a9dc746fd57e4575382baeb3ad3a3a1d3e93d93a451c65cc04f8f3bdcae6f75`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group gvkey, year, datadate, coname;
```

Proposed replacement:
```
	group by gvkey, year, datadate, coname;
```

**Proposed edit:** `Equilar_Plans.sas:57–57`
Source SHA-256: `502e510b0f56cace015d6a5faf494154a5c53a105a3ad0e3656b6f828c3ef356`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group company_id, company_name, ticker, cik, FY_End, Date_of_Request, shares_out, opts_out, shares_avail;
```

Proposed replacement:
```
	group by company_id, company_name, ticker, cik, FY_End, Date_of_Request, shares_out, opts_out, shares_avail;
```

**Proposed edit:** `Equity_Grant_Sample.sas:93–93`
Source SHA-256: `0d34df8cf35ac0f702512bec95b9d5f2ec1f3e07af9697210c24daaf5ed1a195`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group permco, permno, date0, date1
```

Proposed replacement:
```
	group by permco, permno, date0, date1
```

**Proposed edit:** `Equity_Grant_Sample.sas:128–128`
Source SHA-256: `0d34df8cf35ac0f702512bec95b9d5f2ec1f3e07af9697210c24daaf5ed1a195`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group company_id, fye1, fye2;
```

Proposed replacement:
```
	group by company_id, fye1, fye2;
```

**Proposed edit:** `Equity_Plan_Sample.sas:106–106`
Source SHA-256: `63f92b017291489e9e828d7105d376c89a01069684aef89dd5bc60238e8b303b`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group company_id, date_of_request, permno;
```

Proposed replacement:
```
	group by company_id, date_of_request, permno;
```

**Proposed edit:** `Equity_Plan_Sample.sas:214–214`
Source SHA-256: `63f92b017291489e9e828d7105d376c89a01069684aef89dd5bc60238e8b303b`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group permco, rdate;
```

Proposed replacement:
```
	group by permco, rdate;
```

**Proposed edit:** `Equity_Plan_Sample.sas:253–253`
Source SHA-256: `63f92b017291489e9e828d7105d376c89a01069684aef89dd5bc60238e8b303b`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group cik1, annualreportdate;
```

Proposed replacement:
```
	group by cik1, annualreportdate;
```

**Proposed edit:** `Equity_Plan_Sample.sas:265–265`
Source SHA-256: `63f92b017291489e9e828d7105d376c89a01069684aef89dd5bc60238e8b303b`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group company_id, meetingdate, cusip8;
```

Proposed replacement:
```
	group by company_id, meetingdate, cusip8;
```

**Proposed edit:** `Equity_Plan_Sample.sas:332–332`
Source SHA-256: `63f92b017291489e9e828d7105d376c89a01069684aef89dd5bc60238e8b303b`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group permco, datadate0;
```

Proposed replacement:
```
	group by permco, datadate0;
```

**Proposed edit:** `Equity_Plan_Sample.sas:339–339`
Source SHA-256: `63f92b017291489e9e828d7105d376c89a01069684aef89dd5bc60238e8b303b`

The SAS 9.4 SQL guide documents GROUP BY. This one-line preparation edit changes only keyword order; every grouping key and adjacent ORDER BY remains unchanged.

Current text:
```
	by group permco, date;
```

Proposed replacement:
```
	group by permco, date;
```

Preparation / proposed procedure:

1. In a working copy of the four named SAS source files, replace each exact `by group ...` line with its `group by ...` form shown in the edits. Retain the identical grouping variables and all surrounding SELECT, FROM, join, aggregation and ORDER BY text.
2. Keep the original author files unchanged. These are preparation proposals supported by the SAS 9.4 SQL reference, not a claim that the package was run or that the edit was tested.

Validation to perform later:

- In a later separately authorized full workflow run, confirm the same groups and existing aggregate outputs are produced; no syntax trial is part of this assessment.

### A_STATA_USE_CLEAR_REPAIRS: Prepare a working copy that uses the officially documented `clear` option at each of the ten Stata reload sites, keeping each target filename unchanged. The supporting manual is the current official manual, not a Stata 18-specific check.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_STATA_USE_CLEAR
Evidence: E_STATA_USE_CLEAR_OFFICIAL, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L23, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L149, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L167, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L183, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L199, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L231, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L254, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L279, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L328, E_COMPAT_STATA_EQUITY_PLAN_GRANT_TESTS_L423

**Proposed edit:** `Equity_Plan_Grant_Tests.do:23–23`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use equity_plan_sample, replace
```

Proposed replacement:
```
use equity_plan_sample, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:149–149`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use eps0, replace
```

Proposed replacement:
```
use eps0, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:167–167`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use eps1, replace
```

Proposed replacement:
```
use eps1, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:183–183`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use ep_det_samp, replace
```

Proposed replacement:
```
use ep_det_samp, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:199–199`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use ep_det_samp, replace
```

Proposed replacement:
```
use ep_det_samp, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:231–231`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use eps1, replace
```

Proposed replacement:
```
use eps1, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:254–254`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use ep_vote_samp, replace
```

Proposed replacement:
```
use ep_vote_samp, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:279–279`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use ep_vote_samp, replace
```

Proposed replacement:
```
use ep_vote_samp, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:328–328`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use equity_grant_sample, replace
```

Proposed replacement:
```
use equity_grant_sample, clear
```

**Proposed edit:** `Equity_Plan_Grant_Tests.do:423–423`
Source SHA-256: `132f349a5eca2cf48a77e22c7ab7f0f478611adae2397276e743664971d0d45c`

The current official Stata use manual documents clear for replacing the dataset in memory. This edit changes only the option and preserves the reloaded filename; Stata 18-specific syntax was not tested.

Current text:
```
use equity_grant_sample, replace
```

Proposed replacement:
```
use equity_grant_sample, clear
```

Preparation / proposed procedure:

1. In a working copy of Equity_Plan_Grant_Tests.do, replace `, replace` with `, clear` on the ten exact `use` lines in the edits. Keep every input filename and surrounding data transformation unchanged; these sites reload the stated saved sample or intermediate dataset.
2. Retain the documentation limit: the current official manual documents this option, while the Stata 18 use-manual URL was not retrievable. No Stata syntax trial was performed, and this proposed same-operation edit does not change the sample or estimator.
3. Keep the original author file unchanged until any future authorized run uses the prepared working copy.

Validation to perform later:

- In a later separately authorized full workflow run, confirm each saved target reloads at the intended stage and that the plan/grant sample sequence remains intact; no syntax trial is part of this assessment.


## Remaining issues and prerequisites

- I_IDENTITY_CONFLICT [unresolved; full_pipeline]: The frozen header records Do U.S. Investors Value Foreign Component Auditors? (10.1111/1475-679X.12412), while the author datasheet identifies Equity Compensation Plans and Board of Director Discretion over Equity Grants by Brian Cadman and Richard Carrizosa. The supplied Equilar, ISS, Execucomp, CRSP, BoardEx and equity-plan code belongs to the datasheet's distinct subject. Keep frozen metadata unchanged and assess this actual package without attributing its workflow or results to the registered foreign-auditor paper.
- I_INPUT_CLOSURE [unresolved; full_pipeline]: The native source programs name multiple prepared files, vendor extracts, WRDS inputs and an FFI12/FFI48 classification handoff, while the archive inventory contains only code, a datasheet and two identifier lists. Their compatible fields, periods, file schemas, roots and several producer/consumer handoffs are not yet established.
- I_FFI12_CODE [unresolved; full_pipeline]: Equity_Grant_Sample.sas and Equity_Plan_Sample.sas both include `[Path2]\ffi12.sas`, which is not in the package inventory. Their FFI12 construction and emitted fields cannot be verified from this archive; FFI12 is subsequently used as an industry classification in the supplied analysis.
- I_FFIND_CODE [unresolved; full_pipeline]: Internal_External_CEO.do names `ffind.do` by J. Caskey and calls `ffind SIC, newvar(FFI48) type(48)`, but the macro source is not in the package inventory. The exact FFI48 classification construction is therefore unverified.
- I_FFI48_HANDOFF [unresolved; full_pipeline]: The CEO program produces the `FFI48`-keyed insiders_perc panel, while Equity_Plan_Sample.sas calls `%ffi12(sich)` and later joins `A.ffi48` to `B.ffi48`. The missing macro prevents confirming whether it also supplies FFI48 in the plan sample; do not conflate FFI48 with the FFI12 industry variable used in the Stata tests.
- I_PATH_SETUP [preparation; full_pipeline]: The author programs leave Path1, Path2, the CEO global path, the Stata cd and printdir as placeholders. The CEO program also saves perc_insider intermediates relative to the current directory. Configure a coherent host-visible data/macro/output root before a later run so the produced sample and insiders_perc files reach their named consumers.
- I_SAS_GROUP_BY [preparation; full_pipeline]: Ten supplied SAS PROC SQL aggregate clauses are written with `by group`. The official SAS 9.4 SQL reference documents `GROUP BY`; the proposed working-copy edits change only keyword order and preserve each key list, aggregate, join and adjacent ORDER BY. No author program was executed and no syntax failure is claimed.
- I_STATA_USE_CLEAR [preparation; full_pipeline]: Ten supplied Stata data reloads use the option `replace`. The current official Stata use manual documents `clear` for replacing the dataset in memory; the proposed edits change only that option and retain every filename. The Stata 18 manual URL could not be retrieved, so this is not a Stata 18-specific execution finding.
- R_COMP_FUNDA [undetermined]: Compustat North America annual fundamentals source used for GVKEY/FY matches, adjustment factors, shares, annual accounting values and SIC industry classification.
- R_EXECUCOMP_PBA [undetermined]: Execucomp plan-based awards source used to construct officer and CEO grants for Equilar grant years.
- R_EXECUCOMP_ANNCMP [undetermined]: Execucomp annual compensation source used by the separate internal/external CEO classification program.
- R_CRSP_DSF [undetermined]: CRSP daily stock file used for the FY3–FY1 grant return windows and the 365 days preceding each plan date.
- R_CRSP_DSI [undetermined]: CRSP daily stock-index file supplying vwretd matched to each daily CRSP stock-return date in the annual grant-return calculation.
- R_CRSP_STOCKNAMES [undetermined]: CRSP effective-dated stock-name file used for ticker, CUSIP, permno/permco, share-code and SIC joins in the plan sample.
- R_CCMXPF_LNKHIST [undetermined]: CRSP–Compustat link-history table used to map GVKEY to PERMCO with link-type and effective-date filters.
- R_CRSP_MSF [undetermined]: CRSP monthly stock file used to aggregate permco shares outstanding for the Compustat/CRSP share-count comparison.
- R_TFN_S34 [undetermined]: Thomson-Reuters TFN.S34 institutional 13F holdings used to construct institutional ownership for plan events.
- R_RISK_DIRECTORS [undetermined]: ISS RiskMetrics directors table used to create independent-director counts and percentages.
- R_RISK_GOVERNANCE [undetermined]: ISS RiskMetrics governance table used for board and dual-class meeting measures.
- R_RISK_VAVOTERESULTS [undetermined]: ISS Voting Analytics table used to calculate the selected annual voting outcome and vote fraction.
- R_BOARDEX_ORG_SUMMARY [undetermined]: BoardEx North America organization summary used to construct board size, independence and chair measures.
- R_ISSREC [undetermined]: ISS voting recommendations (`EP.issrec`) joined to the selected Voting Analytics observations by company, meeting and agenda item to create issrec/issfor.
- R_EQILAR_PLANS [undetermined]: The custom Equilar Additional Share Request workbook (`Equilar_plans.xlsx`) supplies plan proposal dates, requested and available/outstanding share counts, approval/new-plan status, votes, company identifiers and plan names. It is imported and normalized into EP.equity_plans.
- R_EQILAR_GRANTS [undetermined]: The custom Equilar annual equity-grant workbook (`Equilar_grants.xlsx`) supplies the three FY-end dates, CIK and vendor-coded annual grant/run-rate/depletion/conversion measures used to form EP.equity_grants.
- R_EPSC_DATA [undetermined]: The author-named ISS Equity Plan Scorecard file (`epsc.dta`) supplies company/meeting/plan identifiers, plan flexibility attributes, duration and ticker used to construct planflex and align it to plan requests.
- R_ERTIMUR_NCA [undetermined]: The Ertimur et al. (2018) state noncompete index workbook (`Ertimur_NCA.xlsx`) supplies year1, year2, state and score; the code changes year2=2013 to 2100 before joining to plan-request years.
- R_STATENAMES [undetermined]: The StateNames.csv crosswalk supplies state abbreviation (`code`) to full-state-name (`state`) mapping between Compustat company state and the noncompete workbook.
- S_SAS_94 [unverified]: The author workflow requires SAS for both workbook/table preparation stages and sample construction. The supplied environment record did not establish a working runtime; its SAS startup failed at TKELS, which does not establish a license or access barrier. No SAS command was run for this assessment.
- S_OUTREG2 [preparation_required]: The author code invokes outreg2. The existing environment record did not find it in the checked default or shared adopaths; confirm and configure an authorized Stata 18 compatible copy before a future run.
- S_WINSOR [unverified]: The author code invokes `winsor`. The existing check concerns `winsor2`, a different command name, so it does not establish availability or unavailability of the invoked command.
- S_DISTINCT [unverified]: The author code invokes `distinct`; availability of that exact command was not established by the supplied environment record.
- S_OUTTABLE [unverified]: The author code invokes `outtable`; availability of that exact command was not established by the supplied environment record.
- S_ESTSTO [unverified]: The author code invokes `eststo`; availability of that exact entry point was not established by the supplied environment record, which does report `esttab` separately.

## Review notes

- The frozen registered title and DOI remain unchanged. The author datasheet and actual supplied Equilar/ISS/Execucomp/CRSP/BoardEx equity-compensation workflow identify a material paper/package attribution conflict; this assessment does not attribute the supplied workflow to the foreign-component-auditor paper.
- The documented full workflow retains the five preparation/sample programs in the author-listed order and Equity_Plan_Grant_Tests.do for Tables 1–8. The two packaged DTA files are readable identifier lists, not analysis panels and not inputs consumed by the supplied source files; no analysis_only scope is supported.
- All 44 frozen dependency IDs are reviewed. External source reads map to distinct data requirements; outputs with supplied producers map to generated intermediates; missing FFI macro definitions map to explicit unresolved issues. `EP.fy_rets`, exported plan/grant panels, CEO panel, and Stata intermediate datasets are not treated as externally supplied raw inputs.
- The bounded SAS probes have 14 successful one-row results and one TFN.S34 timeout at the exact 15-second limit. Successful checks establish the stated local product candidates and requested columns; they do not establish event/fiscal-date coverage where those dates are supplied by absent author-specific inputs. The TFN timeout is not evidence of data absence or an access barrier; no retry was made.
- TFN.S34 is the institutional 13F holdings source. The separate Internal_External_CEO.do panel uses Execucomp and FFI48; FFI12 is separately invoked in the SAS sample stages and used for industry controls. The unprovided macros leave the FFI48 producer in the plan sample and cross-language key compatibility unresolved.
- The CEO source uses its 1993–2020 long-window observations and rolling construction for z=2003–2020 with y=z−10. Its conditions explicitly permit missing lags and count missing lags; no earlier source years are required merely to make all lags nonmissing. Preserve `YEAR(YEAR)` and the stated boundary logic as written; extra earlier-history review is fidelity-only unless an actual consumer requires it.
- Path1, Path2, the Stata `$path`, `cd`, and `printdir` are configuration placeholders. The CEO program also writes temporary intermediates relative to the current directory. These are configuration tasks; source edits were not made.
- Static compatibility review covers ten SAS `by group` clauses and ten Stata `use ..., replace` reloads. The proposal includes ten exact SAS `GROUP BY` edits and ten exact Stata `clear` edits in working copies; all source files remain unchanged. The SAS guide is version 9.4. The current official Stata manual supports the clear form, while the Stata 18 manual URL retrieval failed; no syntax trial or author-code execution was performed.
- The existing environment record reports Stata 18 and esttab, does not find outreg2 in its checked adopaths, and marks SAS unverified after a TKELS startup failure. The winsor2 check does not establish the availability of the source-invoked `winsor`; exact availability of `distinct`, `outtable`, and `eststo` remains unverified.
- Data routes remain unverified or unspecified only where the actual required date/key coverage, source fields, custom-file route or construction contract is not established. Current COMP.NAMES and COMP.COMPANY candidates are compatible with their narrow lookup roles. No public/restricted outcome is inferred from catalog misses, and no data downloads, author contact, synthetic data or independent study reconstruction were performed.
- A first read-only attempt used an incorrect local path for the coordinator checkpoint manifest and received a file-not-found diagnostic; the correct manifest path and hash were subsequently verified. The limited captured diagnostic and its status/stream-separation limits are preserved in probes/parent_checkpoint_path_lookup_history_01.json; no source or data was modified by that lookup.
