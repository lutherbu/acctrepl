# Patch proposal: jar-b8cad26d8520

Contracting on GAAP Changes: Large Sample Evidence

DOI: 10.1111/1475-679X.12175

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented GAAP debt-contract workflow, including SEC Exhibit 10 contract/context extraction, Compustat/VIX controls, CIK–GVKEY merging, standard-setter proxies, and the separate manually coded appendix analyses.

Entry points: `importing and preparing data.sas`, `XPF variables defined.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12175 - Contracting-on-GAAP-Changes-Large-Sample-Evidence/cn-datasheet-and-code.zip",
      "sha256": "36a23ee8d6dbbfbff9298eace3ba898a082020c569e5c15a50a5358e34dc3da8"
    },
    {
      "path": "JAR-Volume 55/Issue 5/12175 - Contracting-on-GAAP-Changes-Large-Sample-Evidence/cn-2017-internet-appendix.pdf",
      "sha256": "b9c276b40c0af964185dbd0f737b97869856340a7627a93af1d8281264a8d995"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "e7a254f64fd36a2b85d36220cd8554aec95b3291c7171018ee2c49f905e4b6ee"
}
```

## Proposed actions

### act_contract_sources: Request the exact DirectEdgar lists/context exports or author-approved source package and the search configuration that produced them.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_contract_lists, req_contract_context, req_sec_exhibits, issue_missing_contract_inputs
Evidence: ev_datasheet_contracts, ev_import_container, ev_public_sec, ev_probe_sec_exhibits, ev_catalog_sec_exhibits, ev_package_inventory, ev_local_sec_corpus_pointers

Preparation / proposed procedure:

1. Request all three tab-delimited contract lists and four context CSVs actually imported by the code, with their data dictionary and matching CIK/report-date/contract-date keys.
2. Request DirectEdgar version, filing date range, query syntax, Exhibit 10/form filters, keyword logic, context-window settings, and details behind words/hits/relevance/size fields.
3. Treat the documented raw and parsed local SEC exhibit roots as candidates only; verify exact document text, forms, period and exhibit population, and whether the parsed files preserve DirectEdgar-compatible context exports. WRDSSEC.EXHIBITS metadata alone is not a substitute.

Validation to perform later:

- Check exported schemas and identifiers against the supplied SAS import and join keys; compare the candidate list and extracted context to author-provided counts/specifications before any future authorized run.

### act_compustat_controls: Confirm a Compustat source compatible with the required annual history, population and control construction; record the reported June/July 2014 extraction as provenance and assess the local COMP.FUNDA candidate against study requirements.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_compustat_funda, issue_compustat_history
Evidence: ev_datasheet_compustat, ev_xpf_compfunda, ev_xpf_fields, ev_xpf_growth, ev_xpf_macro, ev_probe_comp_funda, ev_catalog_compustat, ev_public_wrds

Preparation / proposed procedure:

1. Request or document the Compustat source/version, required years, population and field availability, plus the authors’ expected full XPF_CONTROLS observation population before contract joining; use the reported June/July 2014 extraction as provenance when assessing compatibility.
2. Preserve the code’s full-result control construction and winsorization: the SQL has no year filter, and a_growth requires the same gvkey’s prior calendar-year datadate record. Confirm required prior-year coverage from author specifications rather than guessing a start year.
3. Compare the local COMP.FUNDA candidate’s required source fields, period coverage, population and construction with study requirements; the one-row probe confirms columns only.

Validation to perform later:

- Before a future authorized run, verify all selected Compustat columns, identifier formats, sample years, prior-year observations and the output of the full-input winsor macro against author documentation.

### act_names_vix: Resolve the missing xpf.names CIK/GVKEY map, gaap.vix source/history, and the SAS libraries used by the two programs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_compustat_names, req_vix, issue_names_mapping, issue_paths_libraries
Evidence: ev_import_container, ev_xpf_download, ev_xpf_vix, ev_xpf_vix_join, ev_probe_comp_names, ev_catalog_comp_names, ev_catalog_nohits

Preparation / proposed procedure:

1. Request the producer/version for xpf.names, its gvkey and cik1 fields, CIK type/conversion, and period-valid mapping rules; do not assume COMP.NAMES is a drop-in replacement.
2. Request gaap.vix source, variable formats and full history needed for every Compustat datadate month, including actual VIX rows whose date minus 120 days falls inside each joined month.
3. Obtain exact GAAP and XPF LIBNAME/autoexec assignments and clarify which program creates each library dataset.

Validation to perform later:

- Verify the author-specified CIK–GVKEY join, date ranges, VIX date-120 aggregation and annual/monthly joins to datadate; do not infer coverage from the one-row sample or catalog counts.

### act_auxiliary_sources: Request the source files and exact variable construction for the FASB and Allen–Ramanna standard-setter proxies.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_fasb_minutes, req_allen_ramanna, issue_auxiliary_data
Evidence: ev_datasheet_fasb, ev_datasheet_allen, ev_catalog_nohits

Preparation / proposed procedure:

1. Request the FASB minutes used for 1994–2012, the word list, annual aggregation rules and merge keys.
2. Request the exact Allen and Ramanna (2013) data file/version, fields, period, proxy mapping and merge procedure used by this study.

Validation to perform later:

- Confirm source fields, time coverage, definitions and joins against the author’s variable construction before producing either proxy.

### act_manual_appendix: Request the authors’ manually coded 1,410-contract subset and supplemental appendix analysis program.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_manual_contracts, issue_manual_appendix
Evidence: ev_appendix_contents, ev_appendix_manual, ev_appendix_years, ev_appendix_ia2, ev_appendix_ia3, ev_public_sufi

Preparation / proposed procedure:

1. Request the 1,410-contract manual labels, subset membership, coding rules and any author-prepared analysis dataset used in IA1.
2. Request the Stata program and inputs for IA1–IA3. The public 3,720-contract raw archive is only a source candidate and does not replace the manual coding or output program.

Validation to perform later:

- Verify the manual sample count/period and the separate IA1, IA2 and IA3 output mappings against author documentation; keep the 1,410-contract branch separate from the SEC large-sample workflow.

### act_missing_analysis: Obtain the omitted Stata regression program and full main-paper result mapping after the SAS/StatTransfer handoff.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: issue_missing_analysis_code
Evidence: ev_import_container, ev_datasheet_programs, ev_appendix_contents, ev_appendix_ia2, ev_appendix_ia3

Preparation / proposed procedure:

1. Request the exact Stata source, required packages/options, StatTransfer settings and all main-paper table/figure commands that consume gaap_xpf.
2. Confirm the SAS producer outputs and the transfer interface/path; the supplied code stops at a comment and cannot establish the Stata estimator dependencies.

Validation to perform later:

- Compare the supplied Stata program to each main-paper table/figure and the stated GAAP_Panel/GAAP_XPF sample and variables before any future authorized run.

### act_source_environment: Resolve the OOXML source packaging, exact paths/LIBNAMEs and required execution services before a future authorized run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: sw_sas, sw_sas_connect, sw_directedgar, sw_stattransfer, issue_container_format, issue_paths_libraries
Evidence: ev_import_container, ev_xpf_remote, ev_environment_probe, ev_probe_stattransfer, ev_datasheet_programs

Preparation / proposed procedure:

1. Ask the authors for the plain SAS source file or confirmed extraction procedure for the OOXML container; do not edit the container or treat ZIP bytes as executable SAS.
2. Request the exact input/output paths, GAAP/XPF LIBNAME assignments, WRDS remote configuration, SAS/CONNECT requirements and credentials pathway; do not attempt a WRDS signon during this assessment.
3. After source/configuration is supplied, verify SAS 9.4/TKELS, SAS/CONNECT, DirectEdgar and StatTransfer availability in an authorized execution environment; the current probes do not establish their absence or licensing.

Validation to perform later:

- Before a future authorized run, verify the code is plain/extracted SAS with matching source hashes, all libraries point to confirmed inputs/outputs, remote source access is authorized, and the cross-language producer order is respected.


## Remaining issues and prerequisites

- issue_missing_contract_inputs [unresolved; full_pipeline]: Seven DirectEdgar text/CSV inputs are referenced by the SAS program but absent from the package. Step 1 is a block-commented procedure rather than an executable search program. The original filing period, search settings/version, section population and context window needed to reproduce the exports remain unresolved. The documented local raw and parsed exhibit roots exist as candidate locations, but exact sample coverage, query provenance and context compatibility remain unverified.
- issue_compustat_history [unresolved; full_pipeline]: The remote Compustat query filters format/population but has no year condition; %wins processes q, rnd, roa, levbook, a_growth and uncert across the entire resulting xpf_controls table. a_growth joins the same gvkey’s prior calendar-year datadate. The datasheet reports a June/July 2014 extraction, but required study years, full history, population and construction compatibility remain unknown; a one-row local probe cannot establish coverage.
- issue_names_mapping [unresolved; full_pipeline]: The import program reads xpf.names with gvkey and cik1 for the contract-to-Compustat join, but no producer or library assignment is supplied. The local COMP.NAMES candidate has CIK and GVKEY columns, but the mapping to the exact xpf.names/cik1 input and historical validity are unverified.
- issue_missing_analysis_code [unresolved; full_pipeline]: The SAS preparation produces contract classifications, gaap_xpf and a by-year summary, then ends with a comment to convert gaap_xpf through StatTransfer and run Stata regressions. No Stata analysis source or full output program is supplied for the main paper or the appendix’s IA2/IA3 results.
- issue_auxiliary_data [unresolved; full_pipeline]: The datasheet identifies FASB minutes and Allen–Ramanna data as separate inputs to standard-setter proxies, but the package contains no minute files, word list, source data, constructions or merge instructions for either proxy.
- issue_container_format [preparation; full_pipeline]: The file named importing and preparing data.sas is a ZIP/OOXML WordprocessingML container, not plain SAS text. Bounded XML inspection using the frozen paragraph helper recovered 255 SAS-text paragraphs; a plain author-provided .sas file or confirmed extraction procedure is needed before execution. No edits to the container are proposed.
- issue_paths_libraries [unresolved; full_pipeline]: The import program uses [redacted-path-8a2b73a5ef63] context inputs; GAAP and XPF libraries are not assigned in the supplied code. The WRDS remote session configuration, local output locations and required SAS autoexec/library setup are not supplied.
- issue_manual_appendix [unresolved; full_pipeline]: Internet Appendix IA1 uses author-coded practices for 1,410 private credit agreements, while IA2 aggregates main observations by year and IA3 separates UF/FOR results. The raw 3,720-contract author page link does not establish the coded subset, labels or supplemental Stata analyses.
- req_contract_lists [undetermined]: Three DirectEdgar tab-delimited candidate-contract exports for 8-K, 10-K and 10-Q filings. The SAS import code parses CIK, report/contract dates and DirectEdgar screen fields (path, source, words, hits, relevance and size), then filters words>7000, hits>15, relevance>0.2 and deduplicates by CIK/contract date/report date. These files are absent from the package.
- req_contract_context [undetermined]: Four DirectEdgar CSV context exports: two parts for 8-K, one 10-K and one 10-Q. The program stacks them, retains context lines mentioning GAAP/accounting principles, and joins them to the candidate list by CIK, report date and contract date before phrase classification. The CSVs and their schema are absent.
- req_sec_exhibits [undetermined]: SEC Exhibit 10 contract documents attached to 8-K, 10-K and 10-Q filings. The documented search filters for credit/loan/security agreements and financial covenants with GAAP language; the datasheet says the authors used DirectEdgar in July 2014. The exact filing period, covered exhibits and search/context extraction settings are not fully specified.
- req_compustat_funda [undetermined]: Compustat annual fundamentals read from comp.funda using gvkey, datadate, fyear, tic, cik, cusip, indfmt, datafmt, popsrc, consol and accounting/control fields AT, REVT, ACCHG, DD1–DD5, DLTT, SEQ, PRCC_F, CSHO, XRD, IB, PRCH_F and PRCL_F. The authors report a June/July 2014 WRDS extraction. The code has no year restriction before the control construction and winsorization; the exact study period, population, prior-year history and construction compatibility are unresolved; the reported retrieval date is provenance, not a requirement to match a particular vintage.
- req_compustat_names [undetermined]: The importing program joins GAAP_PANEL to xpf.names by CIK=Cik1 and takes GVKEY/Cik1. The xpf.names dataset and its producer are not supplied; the code does not show how the required numeric CIK1 field is created.
- req_vix [undetermined]: Daily VIX observations in gaap.vix with date and VIX values. The XPF program sets date_lag=date-120, aggregates VIX by year/month of date_lag, then joins the yearly/monthly aggregates to Compustat controls on datadate year/month. The required raw rows are those whose actual date minus 120 days falls within each joined Compustat month; target months and full source coverage are not specified.
- req_fasb_minutes [undetermined]: FASB meeting minutes from 1994–2012 used to construct word-count measures of standard setters’ focus on international accounting harmonization. The minutes, word list and author’s annual aggregation/merge procedure are not included.
- req_allen_ramanna [undetermined]: Allen and Ramanna (2013) data used to construct the proxy for standard setters’ shift toward relevance of accounting information. The exact source file, required fields, period, variable mapping and merge procedure are not supplied.
- req_manual_contracts [undetermined]: The author’s manually coded contracting-practices data for a 1,410-private-credit-agreement sample used in Internet Appendix IA1. The appendix reports additional analyses based on this sample; neither the manual labels/subset membership nor its analysis code is in this package.
- sw_sas [unverified]: The SAS 9.4 executable path is listed in the environment, but the supplied bounded runtime probe failed to initialize TKELS. This does not establish a missing license or usable SAS runtime.
- sw_sas_connect [unverified]: The XPF code requires a TCP remote WRDS signon and rsubmit; SAS/CONNECT and authorized WRDS access were not tested.
- sw_directedgar [unverified]: The documented Step 1 requires DirectEdgar for SEC contract search and contextual extraction; this assessment did not verify a local installation or author-compatible version/settings.
- sw_stattransfer [unverified]: The embedded SAS text calls for StatTransfer to convert gaap_xpf to Stata. The exact stattransfer CLI name was not found on PATH; availability of a GUI or alternate install is unverified.

## Review notes

- Expanded checkpoint after frozen-helper OOXML inspection, same-run packaged/environment probe reuse, frozen catalog lookups, three one-row SAS metadata probes, bounded StatTransfer PATH check and official SEC/WRDS/author landing-page checks. No author code, SAS job, Stata regression, WRDS signon or dataset download was run.
- The supplied file importing and preparing data.sas is a ZIP/OOXML WordprocessingML container; the frozen _docx_paragraph_text helper recovers 255 embedded SAS paragraphs while preserving explicit breaks/tabs. XPF variables defined.sas is plain SAS. The container is evidence/code content, not a runnable source path; request the author’s plain .sas file or extraction method.
- Producer-consumer order: DirectEdgar SEC contract-list/context exports feed the SAS import and classification steps through GAAP_PANEL. The independent XPF program reads Compustat and VIX inputs and produces XPF controls; it must finish, along with the missing xpf.names map, before importing Step 7 joins by CIK/CIK1 then GVKEY/FYEAR. Step 8 only comments on StatTransfer to Stata; Stata regression code is absent.
- Macro/raw-history trace: comp.funda is read remotely with no year restriction. a_growth joins the same gvkey to the prior calendar-year datadate. %wins processes q, rnd, roa, levbook, a_growth and uncert across the full generated xpf_controls table. VIX is read from gaap.vix, shifted by date-120, averaged by shifted year/month and joined to Compustat datadate keys; required source coverage depends on the complete joined months, which are unspecified.
- Local COMP.FUNDA and COMP.NAMES probes verify required columns/readability only; WRDSSEC.EXHIBITS is filing/exhibit metadata without body/context columns. The packaged CN 2017_cik_Table1.dta probe shows cik/cdate only, so it is not an analysis-ready dataset and does not support analysis_only.
- The complete documented target also includes FASB minutes (1994–2012), Allen–Ramanna proxy inputs and the separate manually coded 1,410-contract appendix sample. The Sufi page’s 3,720 raw-contract link is only a source candidate, not the coded sample. Keep CIK/GVKEY links and SEC filing identities as documented; do not invent substitute sources or undocumented constructions.
- Environment probe reports Stata 18 available. SAS failed TKELS initialization and remains unverified rather than absent; StatTransfer was not found under the exact PATH command name, but other installations remain unknown. SAS/CONNECT, WRDS access and DirectEdgar were not verified.
