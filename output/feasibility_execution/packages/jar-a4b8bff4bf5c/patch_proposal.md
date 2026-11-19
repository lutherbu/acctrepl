# Patch proposal: jar-a4b8bff4bf5c

Equity Incentive Plans and Board of Director Discretion over Equity Grants

DOI: 10.1111/1475-679X.12532

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied six-program workflow for building equity plan and annual equity grant samples and running the supplied Tables 1–8 analyses.

Entry points: `Equilar_Plans.sas`, `Equilar_Grants.sas`, `Internal_External_CEO.do`, `Equity_Plan_Sample.sas`, `Equity_Grant_Sample.sas`, `Equity_Plan_Grant_Tests.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12532 - Equity-Incentive-Plans-and-Board-of-Director-Discretion-over-Equity-Grants/cc-datasheet-code-and-identifiers.zip",
      "sha256": "a77eba3e8d7883fcaea28d05774f3bbac9f76c1cf36163807d3f22daafc8ed4f"
    },
    {
      "path": "JAR-Volume 62/Issue 4/12532 - Equity-Incentive-Plans-and-Board-of-Director-Discretion-over-Equity-Grants/cc-online-appendix.pdf",
      "sha256": "1b38b08c7d82e448c8a631dd20f0b079fadeb8c18704f23e2e8843f92177bbc9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "1178ed046f37fe2898713439ba6ee80bfb68d9082be1a092c70984ae3e1568e2"
}
```

## Proposed actions

### A_EQUILAR_PLANS_WORKBOOK: Identify a supported source or prepared route for the Equilar plans workbook and verify its plan-period and field contract; the route remains unverified.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_EQILAR_INPUTS, R_EQUILAR_PLANS_WORKBOOK
Evidence: S_DOC_EQILAR, S_EQ_PLANS_IMPORT, S_EQ_PLANS_OUTPUT, S_PLAN_SAMPLE_EQUILAR_INPUTS, E_PACKAGED_PLAN_IDS

Preparation / proposed procedure:

1. Identify a supported source or prepared route for the Equilar plans workbook.
2. Record version, plan-proposal period, and available schema definitions; leave unverified fields and coverage gaps explicit.
3. Stage the approved input under the configured Path1 directory without putting credential values into source files.

Validation to perform later:

- Confirm the plan branch input and EP.equity_plans handoff against the retained source map after paths are configured.
- Verify plan-proposal coverage for April 2006–June 2020 and document which source fields remain unverified.

### A_EQUILAR_GRANTS_WORKBOOK: Identify a supported source or prepared route for the Equilar grants workbook and verify its grant-period and field contract; the route remains unverified.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_EQILAR_INPUTS, R_EQUILAR_GRANTS_WORKBOOK
Evidence: S_DOC_EQILAR, S_EQ_GRANTS_IMPORT, S_EQ_GRANTS_OUTPUT, S_GRANT_SAMPLE_EQUITY_GRANTS, S_PLAN_SAMPLE_EQUILAR_INPUTS, E_PACKAGED_GRANT_IDS

Preparation / proposed procedure:

1. Identify a supported source or prepared route for the Equilar grants workbook.
2. Record version, annual grant period and three-year-history coverage; leave unverified fields and coverage gaps explicit.
3. Stage the approved input under the configured Path1 directory without putting credential values into source files.

Validation to perform later:

- Confirm the grant branch input and EP.equity_grants handoff against the retained source map after paths are configured.
- Verify annual grants coverage for January 2008–December 2019 and document the additional three-year-history and field gaps.

### A_FFI12_MACRO: Obtain the exact ffi12.sas macro included by the authors and confirm the Fama–French 12-industry mapping version.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_FFI12_MACRO
Evidence: S_FFI12_GRANT, S_FFI12_PLAN

Preparation / proposed procedure:

1. Request the original macro from the authors or a documented approved source.
2. Confirm the `%ffi12` interface used in both sample-building SAS programs and the required SIC/industry fields.
3. Stage it under Path2 as an external source dependency.

Validation to perform later:

- Verify the source file is present at the configured Path2 and its macro name matches both calls.
- Compare industry classifications with the paper's documented Fama–French 12-industry definition before full execution.

### A_ISS_PRODUCTS: Obtain the author-used ISS EPSC data file and ISS recommendation table, or document an author-approved equivalent for each distinct product.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_ISS_PRODUCTS, R_ISS_EPSC, R_ISSREC
Evidence: S_DOC_EPSC, S_DOC_VOTING, S_PLAN_SAMPLE_EPSC_IMPORT, S_PLAN_SAMPLE_ISSREC, E_CATALOG

Preparation / proposed procedure:

1. Ask the authors or data administrator for the exact EPSC and ISSREC products and their date/version metadata.
2. Keep the recommendation source separate from Voting Analytics vote results.
3. Confirm permissions, company/meeting/agenda keys and sample-date coverage.

Validation to perform later:

- Verify the EPSC file supports the columns sorted in the plan sample program.
- Verify the ISSREC table contains the recommendation field and joins on company, meeting and agenda identifiers.

### A_EXECUCOMP_PANEL: Confirm or reconstruct the author-used ExecuComp annual Stata panel required by the CEO helper.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_EXECUCOMP_PREP, R_EXECUCOMP_PANEL
Evidence: S_HELPER_SOURCES, S_HELPER_DTA_INPUT, E_PROBES, S_APPENDIX_PLAN_PERIOD

Preparation / proposed procedure:

1. Request the prepared execucomp_anncomp.dta or the exact author transformation from COMP.ANNCOMP.
2. Document the historical years, executive identifiers, CEO flags, SIC/FFI fields and any screening rules.
3. Treat the prepared DTA and raw Compustat source as alternative routes until the original preparation is confirmed.

Validation to perform later:

- Confirm complete annual history through 1993–2020 and inputs needed for rolling ten-year CEO rates.
- Compare the generated insiders_perc.dta to the schema expected by Equity_Plan_Sample.sas.

### A_INSTOWN: Resolve the source and preparation of EP.inst_own, including units and the shares-outstanding denominator.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_INSTOWN_PRODUCER, R_INST_OWN
Evidence: S_PLAN_SAMPLE_INSTOWN, E_CATALOG, E_PROBES

Preparation / proposed procedure:

1. Request the author-prepared EP.inst_own table and its producer, or confirm the raw Thomson S34 extraction and author transformation as an alternative.
2. Document CUSIP/ticker/report-date keys, holdings-share units, duplicate treatment and the origin of shrout2.
3. Do not combine the prepared table and raw rebuild as simultaneous mandatory inputs.

Validation to perform later:

- Confirm report-date history from 2004 onward and valid date-matched identifiers.
- Reconcile units and denominators before the plan sample SAS stage.

### A_NCA_STATE_INPUTS: Find the exact Ertimur et al. state index workbook and the state-name lookup used by the authors.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_NONCOMPETE_LOOKUP, R_ERTIMUR_NCA, R_STATE_NAMES
Evidence: S_DOC_NCA, S_PLAN_SAMPLE_NCA, S_PLAN_SAMPLE_STATES, E_PUBLIC_WILEY, E_PUBLIC_JAR_SUPPLEMENT

Preparation / proposed procedure:

1. Inspect the official JAR online-appendix route for the cited 2018 report and confirm the correct table/file and version.
2. If the exact workbook is not listed, request Ertimur_NCA.xlsx from the package authors.
3. Request the author's StateNames.csv schema or identify an approved state-name source that produces the same join fields.

Validation to perform later:

- Confirm state identifiers, year fields, score definitions and historical ranges match the SAS join.
- Check the state-name lookup keys and duplicate policy before joining.

### A_LOCAL_COVERAGE: Verify that each readable local candidate is the intended data product and covers the full study population and dates.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_LOCAL_COVERAGE, R_COMP_NAMES, R_COMP_FUNDA, R_PLANBASEDAWARDS, R_COMPANY, R_CCMXPF, R_CRSP_DSI, R_CRSP_STOCKNAMES, R_CRSP_DSF, R_CRSP_MSF, R_BOARDEX, R_RMDIRECTORS, R_RMGOVERNANCE, R_VAVOTERESULTS
Evidence: E_CATALOG, E_PROBES, S_APPENDIX_PLAN_PERIOD, S_APPENDIX_GRANT_PERIOD

Preparation / proposed procedure:

1. Use an authorized data session to confirm product/version and full history metadata for each listed local table.
2. Confirm yearly coverage for the 2006–2020 plan period and 2008–2019 grant sample, plus return windows and required historical lags.
3. Record variable definitions, link-date semantics and the target institution's permissions.

Validation to perform later:

- Compare verified coverage with the source-specific expected periods in each requirement route.
- Do not infer coverage from the one-row probes or catalog observation counts.

### A_SITE_CONFIGURATION: Set site-specific library and path configuration for the six programs and preserve the SAS-to-Stata sample handoffs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_SITE_PATHS
Evidence: S_EQ_PLANS_IMPORT, S_EQ_GRANTS_IMPORT, S_FFI12_GRANT, S_FFI12_PLAN, S_PLAN_SAMPLE_EXPORT, S_GRANT_SAMPLE_EXPORT, S_TEST_PATHS

Preparation / proposed procedure:

1. Choose a project run root visible to the authorized SAS and Stata host wrappers; use relative paths or an approved [redacted-path-b7c14209d249] location.
2. Configure Path1, Path2, SAS library references, the Stata global path and current directory through the approved site configuration.
3. Ensure SAS exports equity_plan_sample.dta and equity_grant_sample.dta into the directory read by the Stata driver and that printdir points to the intended report output folder.
4. Keep vendor credentials outside source-controlled code and use the host's approved secret mechanism.

Validation to perform later:

- Check all required input, macro, work and output directories exist and are writable before execution.
- Confirm both generated DTA handoffs and the table-output directory resolve to the same intended run root.

### A_SAS_RUNTIME: Confirm a usable SAS 9.4 runtime on the target host after required inputs and site configuration are prepared.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SAS_RUNTIME, SW_SAS
Evidence: E_ENV

Preparation / proposed procedure:

1. Ask the host administrator to confirm the supported SAS batch command and site license for the intended replication environment.
2. Use the documented batch wrapper and work directory after configuration is approved; this assessment did not start SAS.

Validation to perform later:

- Record successful runtime startup metadata without running author programs during the feasibility review.

### A_STATA_ADDONS: Prepare the three Stata add-ons that the exact Stata 18 availability checks did not find.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: I_STATA_ADDONS, SW_OUTTABLE, SW_OUTREG2, SW_DISTINCT
Evidence: E_SW_OUTTABLE, E_SW_OUTREG2, E_SW_DISTINCT, E_ENV

Preparation / proposed procedure:

1. Obtain outtable, outreg2 and distinct through the institution's approved Stata package channel.
2. Record package versions and configure the same Stata ado path used for the run.
3. Retain already available Stata 18, winsor, eststo and esttab without changing the author workflow.

Validation to perform later:

- Confirm exact `which` resolution for the three required commands in the target batch Stata environment.
- Check the available package versions are recorded before running the analysis driver.

### A_FINAL_RUN: After all missing inputs, software and paths are resolved, execute the complete as-downloaded workflow in the documented order and compare its declared sample counts and outputs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_DEPENDENCY_CLOSURE
Evidence: S_DOC_CODE_ORDER, S_APPENDIX_PLAN_PERIOD, S_APPENDIX_GRANT_PERIOD, S_TEST_DRIVER_INPUTS, E_ENV

Preparation / proposed procedure:

1. Run Equilar_Plans.sas, Equilar_Grants.sas, Internal_External_CEO.do, Equity_Plan_Sample.sas, Equity_Grant_Sample.sas and Equity_Plan_Grant_Tests.do in the documented dependency order.
2. Keep each program's native intermediates, export both sample DTA handoffs and save output tables in the configured run root.
3. Record all runtime logs, output hashes, row counts and any deviations.

Validation to perform later:

- Compare equity plan and annual grant sample counts and dates with the online appendix's stated targets.
- Inspect generated tables 1–8 and source-provided intermediate contracts after full execution.
- Do not mark execution verified until the complete workflow and outputs have been checked.


## Remaining issues and prerequisites

- I_EQILAR_INPUTS [unresolved; full_pipeline]: Both required Equilar source workbooks are imported by the preparation programs but are not in the package; the packaged identifiers do not provide the full sample fields. A separate author/vendor route remains unverified.
- I_FFI12_MACRO [unresolved; full_pipeline]: Both SAS sample programs include the external ffi12.sas macro, which is not among the supplied source files; its approved source and runtime path remain unknown.
- I_ISS_PRODUCTS [unresolved; full_pipeline]: The required ISS EPSC file is not packaged and EP.issrec has no producer; exact EPSC and ISSREC catalog searches returned no candidates. Voting Analytics is a separate product and does not replace either input; an approved route remains unverified.
- I_INSTOWN_PRODUCER [unresolved; full_pipeline]: EP.inst_own is required but no producer is included. The code comment points to Thomson S34; the local S34 candidate probe timed out and the required shares/denominator preparation remains unknown.
- I_EXECUCOMP_PREP [preparation; full_pipeline]: The CEO helper reads an ExecuComp annual panel as a Stata DTA, but the package has no producer for the file. A local raw COMP.ANNCOMP candidate is readable for one row; the author transformation and 1993–2020 coverage are unverified.
- I_NONCOMPETE_LOOKUP [unresolved; full_pipeline]: Ertimur_NCA.xlsx and StateNames.csv are external inputs. An official paper/online-appendix route exists for the cited state index, but the specific workbook was not verified; the state CSV schema is also unknown.
- I_LOCAL_COVERAGE [unresolved; full_pipeline]: Bounded catalog probes established readable one-row slices for several local Compustat, CRSP, BoardEx and RiskMetrics candidates. They explicitly do not establish target-period or full-population coverage.
- I_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: All 44 frozen dependency IDs were reviewed, but the full workflow is not closed because required external data, the FFI12 macro, prepared-table producers, site paths and complete coverage remain unresolved.
- I_SITE_PATHS [preparation; full_pipeline]: The workflow leaves Path1, Path2, SAS library setup, Stata working directory/global path and report output directory unresolved; generated SAS exports must be staged where the Stata driver reads them.
- I_SAS_RUNTIME [preparation; full_pipeline]: The frozen environment record marks SAS runtime availability unverified. No additional SAS process was started for this assessment.
- I_STATA_ADDONS [preparation; full_pipeline]: The exact Stata 18 checks found outtable, outreg2 and distinct unavailable. Their source use must be retained and the required add-ons prepared before the analysis driver can run.
- R_EQUILAR_PLANS_WORKBOOK [undetermined]: The separate Equilar plans workbook imported by Equilar_Plans.sas and emitted as EP.equity_plans. The package contains only plan identifier lists, not the full workbook; exact source fields and full period coverage remain unverified.
- R_EQUILAR_GRANTS_WORKBOOK [undetermined]: The separate Equilar grants workbook imported by Equilar_Grants.sas and emitted as EP.equity_grants. The package contains only grant identifier lists, not the full workbook; exact source fields and full history coverage remain unverified.
- R_COMP_NAMES [undetermined]: Compustat names table used to map Equilar CIK identifiers to GVKEY.
- R_COMP_FUNDA [undetermined]: Compustat annual fundamentals used for fiscal-year matching, accounting controls and annual grant data.
- R_PLANBASEDAWARDS [undetermined]: ExecuComp plan-based awards table used by the Equilar grant preparation script.
- R_COMPANY [undetermined]: Compustat company master used for firm identifiers and state fields.
- R_CCMXPF [undetermined]: CRSP/Compustat link-history table used to map GVKEY and plan dates to PERMCO.
- R_CRSP_DSI [undetermined]: CRSP daily index return series used to calculate market-adjusted annual returns.
- R_CRSP_STOCKNAMES [undetermined]: CRSP name history used for CUSIP, ticker and PERMCO/PERMNO mappings.
- R_CRSP_DSF [undetermined]: CRSP daily stock file used for stock returns, shares outstanding and volatility.
- R_CRSP_MSF [undetermined]: CRSP monthly stock file used for firm-level monthly shares outstanding.
- R_BOARDEX [undetermined]: BoardEx North America organization summary used to derive board independence measures.
- R_RMDIRECTORS [undetermined]: ISS/RiskMetrics director classifications used to construct board-independence measures.
- R_RMGOVERNANCE [undetermined]: ISS/RiskMetrics governance table used to construct dual-class and board measures.
- R_VAVOTERESULTS [undetermined]: ISS Voting Analytics results table used to derive plan vote outcomes and vote percentages.
- R_EXECUCOMP_PANEL [undetermined]: The internal/external CEO helper expects an ExecuComp annual compensation Stata file. The exact prepared DTA has no in-package producer; a local COMP.ANNCOMP candidate is an alternative raw-data route only if the original preparation and full history are confirmed.
- R_INST_OWN [undetermined]: The plan sample requires prepared EP.inst_own institutional holdings. Its source comment identifies Thomson S34 by CUSIP, ticker and report date; no producer or exact `shrout2` mapping is supplied. Use the prepared table or rebuild from raw S34 as alternatives, not as simultaneous required inputs.
- R_ERTIMUR_NCA [undetermined]: Ertimur_NCA.xlsx is imported to construct the state-level noncompete index. The cited 2018 paper has an official online-appendix route, but the specific workbook and version were not verified.
- R_STATE_NAMES [undetermined]: The plan sample imports a StateNames.csv lookup and joins it to state-level data; the CSV is not supplied or otherwise verified.
- R_ISS_EPSC [undetermined]: The plan sample imports epsc.dta as an ISS Equity Plan Scorecard source. The file is not packaged and the exact catalog query returned no match.
- R_ISSREC [undetermined]: The plan sample joins EP.issrec to add the ISS recommendation field. No producer is supplied and the exact ISSREC catalog query returned no match; Voting Analytics results are a separate input and are not a substitute.
- SW_SAS [unverified]: Machine instructions list SAS 9.4 TS1M8, while the frozen environment record did not establish a usable SAS runtime. No new SAS process or startup check was made for this package review.
- SW_OUTTABLE [preparation_required]: Exact `software:outtable` lookup returned not found in Stata 18.
- SW_OUTREG2 [preparation_required]: Exact `software:outreg2` lookup returned not found in Stata 18.
- SW_DISTINCT [preparation_required]: Exact `software:distinct` lookup returned not found in Stata 18.

## Review notes

- Frozen package identity is the Equity Incentive Plans and Board of Director Discretion over Equity Grants article, DOI 10.1111/1475-679X.12532. The online appendix carries that title and the same authors; the datasheet's opening title uses a minor wording variant. All six listed programs and their original order are retained in full_pipeline. [S_APPENDIX_IDENTITY, S_DOC_CODE_ORDER]
- The datasheet states that the study ‘does not use proprietary data’ while listing vendor products; this wording is retained as context only. No generic author-approval or transfer-permission prerequisite is added for common resources already authorized and readable in the environment. This context does not establish access rights, field schemas, or history for the still-unverified Equilar and ISS routes; those remain undetermined. [S_DOC_NO_PROP, S_DOC_EQILAR, S_DOC_EPSC, S_DOC_EXECUCOMP, S_DOC_NCA, S_DOC_VOTING, S_DOC_TFN, S_DOC_BOARD, S_DOC_COMPUSTAT, S_DOC_CRSP]
- Only the two named DTA identifier lists are packaged; bounded probes read one row from each and identify their columns. They are not the full plan or grant sample data required by the supplied programs. [S_DOC_CODE_ORDER, E_PACKAGED_GRANT_IDS, E_PACKAGED_PLAN_IDS]
- Local catalog candidates for named Compustat, CRSP, BoardEx and RiskMetrics products were checked with bounded row-limit-one reads. Those checks establish limited readability and requested fields only; they do not establish the appendix period, full population or product compatibility. TFN.S34 timed out. No raw data values were retained in this review. [E_CATALOG, E_PROBES]
- The direct native workflow includes two SAS sample programs, an external FFI12 macro dependency, a Stata CEO-rate helper, exported SAS-to-Stata handoffs and the Table 1–8 Stata driver. No author code was imported, parsed, compiled or executed, and no statistical or descriptive output was produced. [S_DOC_CODE_ORDER, S_FFI12_GRANT, S_FFI12_PLAN, S_HELPER_INSIDERS_OUTPUT, S_PLAN_SAMPLE_EXPORT, S_GRANT_SAMPLE_EXPORT, S_TEST_DRIVER_INPUTS]
- Four SAS connection statements were withheld by the byte-first reader; their line numbers and raw line hashes remain in the screened artifacts. Cached SAS text files ended in `.sas.txt`, so reader dispatch used generic physical-line/continuation screening rather than SAS semicolon-statement mode. A separate coordinator metadata-only boundary audit confirms the four known candidates are complete single-line statements covered by the recorded masks, with zero known nonblank candidate bytes uncovered. This finding is limited to those known candidates; it does not claim exhaustive absence of other sensitive logic. No candidate values were displayed, copied or used. [E_PREP_GRANTS, E_PREP_PLANS, E_GRANT_SAMPLE, E_PLAN_SAMPLE, E_READER_BOUNDARY]
- Internal_External_CEO.do is explicitly included in the supplied datasheet order. It reads the ExecuComp annual-panel DTA and writes insiders_perc.dta, which Equity_Plan_Sample.sas consumes. The separate-paper/table header is retained as provenance context only and does not create an author-clarification prerequisite. The helper and its actual input and output handoff remain part of the native workflow; the existing ExecuComp producer and coverage gap remains unresolved. [S_DOC_CODE_ORDER, S_HELPER_HEADER, E_PUBLIC_OUP, S_HELPER_SOURCES, S_HELPER_DTA_INPUT, S_HELPER_INSIDERS_OUTPUT, S_PLAN_SAMPLE_CEO]
- The Stata driver has a legacy set memory statement. Official Stata documentation says Stata 12 and later automatically manage memory and ignore that command; no source edit is proposed. The blank working/output paths still require site configuration. [S_TEST_PATHS, E_STATA_MEMORY_DOC]
- The full pipeline is not closed or execution-verified because required external inputs, the FFI12 macro, local data coverage, site paths and several Stata add-ons remain unresolved or unverified. The actions preserve product alternatives such as prepared EP.inst_own versus a raw S34 rebuild as alternatives rather than simultaneous requirements. [E_CATALOG, E_PROBES, E_ENV]
- Prior full_pipeline scope claims were data_status=`undetermined` and execution_readiness=`preparation_required`. Pinned finalizer attempt 003 rejected the submitted execution_readiness claim because it differed from the evidence-computed outcome (E_READINESS_FAILURE_003). This correction omits both optional claim keys so the frozen helper derives them from the unchanged scope facts, routes, evidence, issues, and actions. No source, requirements, outcome, issue severity, data requirement, closure, has_code, software, or action facts were changed. The failed draft and capture are preserved at `probes/failed_readiness_predecessor_20261111T171726Z/`. [E_READINESS_FAILURE_003]
