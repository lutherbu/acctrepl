# Patch proposal: jar-d449ab60ef14

Contracts between Firms and Stakeholders

DOI: 10.1111/1475-679X.12297

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-supplied workflow: download SC 13D filings for the 1996–2018 Stata sample in Python, parse filings in Perl, manually import the pipe-delimited handoff in SAS Enterprise, merge SEC Analytics/Compustat-CRSP/CRSP/TFN/I-B/E/S inputs in SAS, export the master Stata file, and run the supplied Stata tables. The program sources are embedded in PDFs and there is no supported separate analysis-only route.

Entry points: `_1_EDGAR_DownloadForms.pdf`, `_1_EDGAR_Pac.pdf`, `_1_EDGAR_Forms.pdf`, `_1_General_Utilities.pdf`, `_2_Perl_Textual_Analysis.pdf`, `_3_SAS_Merge_Data.pdf`, `_4_Stata_Create_Tables.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 2/12297 - Contracts-between-Firms-and-Stakeholders/schoenfeld-datasheet-code-and-identifiers.zip",
      "sha256": "43df064974a4ef20f1769b5a4147e8f478b6a7266ccfe3a76ed2e7c73a204a71"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "a4f4da16fd6ac0154bc4a755cfdf7f83cb32c92921cb168aa7918ec34b33f775"
}
```

## Proposed actions

### a_working_copy_paths: Extract the embedded programs to working copies and configure a single relative execution root that preserves every producer and consumer directory. Do not edit the source PDFs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: workflow_handoffs, pdf_program_extraction
Evidence: src_datasheet, src_python_dependencies, src_perl_inputs, src_sas_import, src_sas_macro_export, src_stata_input_sample, src_stata_output_path

Preparation / proposed procedure:

1. Use a runtime working directory of ./replication_work and create code/python, code/perl, code/sas, code/stata, data/edgar, logs, intermediate/perl, sasdata/rawd, sasdata/homed, sasdata/ibes, sasdata/crspsk, stata and stata/tables beneath it.
2. Extract the _1_ Python driver and all three helpers into code/python together; extract the Perl, SAS and Stata programs from their PDF containers to their respective code directories, checking page wraps and statement boundaries.
3. Point PARM_PATH and the Perl recursive input root at data/edgar; put Perl filelist.txt and results.txt under intermediate/perl. Preserve the parser header and pipe delimiter.
4. Import intermediate/perl/results.txt manually in SAS Enterprise as rawd.results under sasdata/rawd. Set homed, ibes and crspsk to the corresponding sasdata subdirectories while preserving the exact SEC_Analytics_Jordan, compcrsp_merged_jan2019, EPS and stocknames table names.
5. Set SAS PROC EXPORT output to stata/master.dta; set the Stata use path to the same file and its table-output global to stata/tables. Keep the source remote CRSP/TFN branch and all other merge steps until a compatible input route is verified.

Validation to perform later:

- Before any separately authorized run, verify each configured directory is visible and writable from the SAS and Stata batch processes.
- After Perl output is produced, compare the pipe header and record structure with the manual SAS import variables; verify rawd.results is the imported producer table.
- After SAS export, verify master.dta exists at the Stata consumer path and contains all expected upstream columns before running Stata.

### a_form_period_config: Configure the extracted downloader for the exact form and sample that the supplied SAS and Stata branch retains. Set the start year before the end year because the author loop is ascending and inclusive.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: form_and_period_config, sec_13d_filings
Evidence: src_python_parameters, src_python_year_loop, src_python_form_list, src_sas_sec, src_stata_input_sample, sec_schedule_forms, sec_access_public

Preparation / proposed procedure:

1. In the extracted working copy, set PARM_FORMS to the exact EDGAR form string SC 13D, PARM_BGNYEAR to 1996 and PARM_ENDYEAR to 2018; retain the inclusive end-year loop and do not select SC 13D/A, which the downstream SAS filter deletes.
2. Keep the four-quarter annual loop and point its form/year output under data/edgar. Do not rely on the inactive EDGAR_Forms.f_13D alternative.
3. Configure an identifying User-Agent for SEC requests and keep request pacing within the SEC published maximum rate.

Validation to perform later:

- Review generated master-index selections for form SC 13D and years 1996–2018 before filing downloads.
- Compare downloaded filing names with the suffix normalization used to build filename2 in SAS; verify SC 13D/A is not included in the retained SAS sample.

### a_python_compatibility: Make the Python code compatible with the verified runtime by repairing only timing and logging API calls in extracted working copies.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: python_api_compatibility, python
Evidence: src_python_clock, src_python_master_index, src_python_typo, python_api_probe

Preparation / proposed procedure:

1. In extracted _1_EDGAR_DownloadForms and _1_EDGAR_Pac working copies, replace each elapsed-duration use of time.clock() with time.perf_counter(); keep the surrounding timing logic intact.
2. In the _1_EDGAR_Pac exception handler, correct the misspelled time.strfime() call to time.strftime() so the retry path can log errors.
3. Leave the PDF originals unchanged and preserve the download/filter logic.

Validation to perform later:

- Use a self-written Python 3.12 syntax and API check on extracted helper copies; confirm timing and error-log function names resolve without importing author modules.
- After a later authorized run, exercise normal logging and a controlled non-network exception path; do not download files during preparation.

### a_html_strip_setup: Provide the HTML::Strip module required by the Perl parser in the selected Perl 5.40.1 environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: perl_html_strip_setup, perl_html_strip
Evidence: src_perl_inputs, perl_modules_probe

Preparation / proposed procedure:

1. Install HTML::Strip through the approved Perl environment/package channel, or configure PERL5LIB to an already-approved compatible module location. Do not replace the parser HTML stripping behavior.
2. Keep the verified File::Find and List::MoreUtils dependencies in the same Perl environment.

Validation to perform later:

- Run an isolated Perl module require/version check for HTML::Strip and the two existing modules; do not execute the author parser.

### a_sas_components: Establish the SAS runtime and each component used by the manual import, remote merge and Stata export stages. Current probes are unverified, not evidence of an absent license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sas_component_status, sas, sas_connect, sas_pc_files, sas_enterprise_gui
Evidence: env_probe, src_sas_import, src_sas_crsp_pm5, src_sas_tfn_dsi, src_sas_macro_export, sas_connect_doc, sas_stata_export_doc, sas_pcfiles_license_doc

Preparation / proposed procedure:

1. Resolve the observed TKELS startup failure or otherwise verify the installed SAS 9.4 batch runtime with the Base SAS procedures in the supplied source.
2. Confirm SAS/CONNECT availability and WRDS access for SIGNON, RSUBMIT, UPLOAD and DOWNLOAD, including the expected interactive credential handoff.
3. Confirm the licensed SAS PC Files Interface supports DBMS=STATA export and that the author-described SAS Enterprise manual import interface is available for the pipe-delimited results.txt handoff.

Validation to perform later:

- Before running author code, verify SAS startup in the intended batch environment and confirm each required component through product documentation or local entitlement records.
- Use a small authorized-format check only after the runtime is established; do not execute the author merge or export during this assessment.

### a_sec_acquisition: Acquire only the public filing text needed for the configured SC 13D, 1996–2018 branch and place it in the configured Perl input tree.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: sec_13d_filings
Evidence: src_python_master_index, src_python_download_helpers, src_perl_inputs, sec_access_public, sec_schedule_forms

Preparation / proposed procedure:

1. Use SEC EDGAR full-index records for SC 13D in 1996–2018 and retrieve the corresponding filing text; preserve the SEC accession/file suffix used by the Perl-to-SAS filename2 link.
2. Use a descriptive User-Agent and comply with the published request limit. The existing local SEC roots may be checked later for coverage, but directory existence alone is not a filing corpus.

Validation to perform later:

- Check form and year bounds against index metadata and verify document readability and filename compatibility before Perl parsing.
- Confirm the downstream SAS exact-form filter retains the intended records and report linkage coverage; do not broaden to amendments without a separate supplied target.

### a_sec_analytics_contract: Resolve the exact author-prepared SEC Analytics input and its linkage contract before the SAS merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: sec_analytics_jordan, sec_analytics_contract
Evidence: src_sas_sec, src_perl_header, src_perl_result, cat_sec_candidate

Preparation / proposed procedure:

1. Obtain SEC_Analytics_Jordan or its documented product, format, full schema, identifier and filename rules, and 1996–2018 coverage. Preserve CIK, FORM, SECFNAME and FDATE plus any fields required downstream.
2. Confirm how SECFNAME and the Perl filename are normalized to filename2 and which records are in scope under the exact SC 13D filter.
3. Treat WRDSSEC.SEC_ITEM_SCORES as a catalog candidate only; shared metadata columns do not establish equal population, additional fields or equivalence. Raw SEC filings do not supply this linkage table by themselves.

Validation to perform later:

- After authorized receipt or access, compare full schema and coverage with SAS reads and report matched/unmatched filenames and duplicate keys before analysis.

### a_compcrsp_contract: Recover the author-specific Compustat and CRSP merged input contract instead of substituting a raw fundamentals table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: compcrsp_merged, compcrsp_contract
Evidence: src_sas_comp, cat_comp_candidate, comp_funda_probe

Preparation / proposed procedure:

1. Obtain compcrsp_merged_jan2019 or its documented producer, source products, merge keys and variable construction. Confirm CIK/year matching and required fields such as GVKEY, DATADATE, LPERMNO, SIC, CUSIP and the downstream annual controls.
2. Preserve the source distinction between computed calendar YEAR from DATADATE and Compustat FYEAR; do not infer a fiscal-year alias.
3. Treat COMP.FUNDA as a raw annual candidate only; the bounded probe does not supply the author combined link file or establish history.

Validation to perform later:

- After authorized input availability, compare field types, join keys, duplicate behavior and coverage for filing years 1996–2018 against the supplied SAS consumer.

### a_crsp_route: Configure the actual CRSP tables with the supplied measures and date windows. The exact local tables are readable, but the current measure queries execute inside a remote SAS/CONNECT session.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: crsp_dsf, crsp_dsi, crsp_stocknames
Evidence: src_sas_crsp_pm5, src_sas_crsp_m365, src_sas_tfn_dsi, src_sas_stocknames, cat_crsp_candidates, crsp_dsf_probe, crsp_dsi_probe, stocknames_probe

Preparation / proposed procedure:

1. Either verify the existing WRDS remote CRSP route or, if authorized, place the same supplied SQL against the exact readable local CRSP.DSF and CRSP.DSI candidates; preserve all measures, joins and date predicates.
2. Use CRSP.STOCKNAMES with PERMNO, ST_DATE and END_DATE and retain the supplied first-date and active-interval logic.
3. Confirm that the data cover every 1996–2018 filing, CRSP.DSF has at least 365 calendar days before and five weekdays after each filing date, and CRSP.DSI has the required plus/minus five weekday event window.

Validation to perform later:

- With authorized inputs, compare requested columns and types and verify coverage/history for the analysis sample; do not treat one-row probe ranges as full-history evidence.

### a_tfn_access: Verify and configure the catalog-listed TFN.S34 table for the supplied field, date and quarter construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: tfn_s34, tfn_access_history
Evidence: src_sas_tfn_dsi, cat_tfn_candidate, tfn_probe

Preparation / proposed procedure:

1. The catalog lists TFN.S34 with CUSIP, RDATE, SHARES and SHROUT1, but the bounded read timed out. Recheck only this exact approved catalog table through a bounded metadata/readability probe or use the supplied remote WRDS route if available.
2. Preserve the supplied missing-value handling, CUSIP6 construction, 1993 date filter, year-quarter aggregation and match to filing quarter. Do not widen the target or replace the product.

Validation to perform later:

- Verify table readability, exact field types and required 1993-through-2018 filing-quarter coverage using authorized metadata/coverage checks before execution.

### a_ibes_contract: Resolve the author-prepared I/B/E/S consensus input and its PERMNO and NUM_FORECAST mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ibes_eps_consensus, ibes_input_contract
Evidence: src_sas_ibes, cat_ibes_candidate, ibes_probe

Preparation / proposed procedure:

1. Obtain eps_consensus_unadjusted_1994 or its producer and confirm DATE, PERMNO and NUM_FORECAST fields, measure family and coverage from 1993 onward.
2. If using IBES.STATSUMU_EPSUS as a candidate, obtain documented identifier mapping and variable derivation for TICKER, STATPERS and NUMEST to the author DATE, PERMNO and NUM_FORECAST contract; do not guess NUMEST is an alias or substitute a GPS series.
3. Preserve the supplied quarter construction and average NUM_FORECAST by PERMNO/year-quarter.

Validation to perform later:

- Compare prepared fields, identifiers and quarter aggregation to the SAS consumer, then verify the 1993–2018 history needed by the filing sample.

### a_stata_fields: Identify the producer for Stata fields consumed but not generated by the delivered programs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: stata_input_field_provenance
Evidence: src_stata_readability, src_stata_ind_corporate, src_stata_industry_models, src_stata_industry_12, src_sas_industry_start, src_sas_industry_end

Preparation / proposed procedure:

1. Confirm whether the intended master input supplies flesch_reading_ease, ind_corporate and ind_code1 through ind_code12, and provide their documented producer, definitions and source columns.
2. The supplied SAS creates scalar ind_code and the supplied Stata source creates corporate; do not infer that either is equivalent to the missing fields or manufacture indicators.

Validation to perform later:

- After the documented producer or input is available, compare the exported master.dta schema to every Stata field reference before executing the tables.

### a_table6_recipe: Obtain the author manual Table 6 procedure and required inputs to close the full documented table target.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: table6_manual_recipe
Evidence: src_table6, src_overview

Preparation / proposed procedure:

1. Request the manual Table 6 recipe, source fields and inputs, transformations, table layout and verification checks.
2. Do not infer the table construction from the paper or substitute a new analysis.

Validation to perform later:

- Compare the provided recipe and input contract with the supplied master data and confirm Table 6 checks before claiming full table coverage.

### a_run_sequence: After the required inputs, code working copies, paths and software are prepared, run the author workflow in its actual cross-language order.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: workflow_handoffs
Evidence: src_overview, src_datasheet, src_perl_header, src_sas_import, src_sas_macro_export, src_stata_input_sample, src_table6

Preparation / proposed procedure:

1. From ./replication_work, run the extracted Python downloader and produce the configured SEC filing tree.
2. Run the extracted Perl parser against that tree and produce intermediate/perl/results.txt.
3. Manually import results.txt in SAS Enterprise as rawd.results, then run the supplied SAS merges, including the WRDS branch and all source inputs, and export stata/master.dta.
4. Run the extracted Stata program against stata/master.dta and save supplied tables under stata/tables. Complete Table 6 only after its manual recipe is supplied.

Validation to perform later:

- At each handoff, verify producer file, schema, key variables, expected period and consumer path before advancing.
- Record software versions, manual import settings, record/linkage counts and unresolved rows; execution remains unverified until performed under separate authorization.


## Remaining issues and prerequisites

- workflow_handoffs [preparation; full_pipeline]: The full target crosses PDF-embedded Python helpers, Perl, a manual SAS Enterprise import, SAS data libraries/export and Stata. Author paths are Windows/Dropbox-specific. The handoff must preserve the Perl pipe schema, rawd.results, all SAS inputs and the master.dta producer/consumer order.
- form_and_period_config [preparation; full_pipeline]: The active downloader sets PARM_FORMS to 10-K and PARM_BGNYEAR/PARM_ENDYEAR to 2018/1996; its ascending range is empty. The downstream SAS selector and Stata sample support configuring the working copy for SC 13D and inclusive years 1996–2018.
- python_api_compatibility [preparation; full_pipeline]: The Python program calls time.clock(), which is absent in the available Python 3.12 runtime; the companion helper also calls misspelled time.strfime() in its retry-error path. These are working-copy compatibility fixes, not a need to alter the PDFs.
- perl_html_strip_setup [preparation; full_pipeline]: HTML::Strip is imported by the Perl parser but was not found in the checked environment; File::Find and List::MoreUtils are available.
- sas_component_status [unresolved; full_pipeline]: SAS startup failed at TKELS, and availability of SAS/CONNECT, the SAS PC Files interface for DBMS=STATA and the author-described SAS Enterprise manual import interface is unverified. These findings do not establish a missing license.
- sec_analytics_contract [unresolved; full_pipeline]: SEC_Analytics_Jordan is an exact author-named SAS input whose full field list, product lineage, filename convention, history/coverage and relation to local WRDSSEC candidates are unspecified. Raw filings and SEC_ITEM_SCORES are not proven substitutes.
- compcrsp_contract [unresolved; full_pipeline]: The supplied SAS source consumes compcrsp_merged_jan2019 but does not provide its producer or complete CIK/year/GVKEY/PERMNO/SIC/CUSIP field, linking and coverage contract. COMP.FUNDA is a raw annual candidate, not a demonstrated replacement.
- tfn_access_history [unresolved; full_pipeline]: TFN.S34 has a catalog-listed matching schema, but the exact bounded read timed out; local availability and coverage from 1993 through the filing quarters remain unverified.
- ibes_input_contract [unresolved; full_pipeline]: The author expects eps_consensus_unadjusted_1994 with DATE, PERMNO and NUM_FORECAST. The local unadjusted EPS summary candidate instead exposes TICKER, STATPERS and NUMEST; no mapping or equivalence is supplied.
- stata_input_field_provenance [unresolved; full_pipeline]: The Stata program uses flesch_reading_ease and ind_corporate, and its industry regressions use ind_code1 through ind_code12. No producer for these fields is present in the supplied Perl/SAS code; SAS creates only scalar ind_code. A prepared input may supply them, but that contract is unknown.
- table6_manual_recipe [unresolved; full_pipeline]: The Stata source says Table 6 is created manually but provides no recipe, input contract or validation checks. The supplied code alone cannot close the full documented table target.
- pdf_program_extraction [preparation; full_pipeline]: Programs are embedded in PDFs rather than supplied as standalone runnable files. Extract working copies from all Python, Perl, SAS and Stata program PDFs and verify page-wrap-sensitive statements before any separately authorized run.
- sec_13d_filings [public_acquisition_required]: Raw EDGAR filing text for the supplied SAS target form SC 13D over the Stata sample period 1996–2018. The SAS branch deletes every SEC Analytics row whose form is not exactly SC 13D, so SC 13D/A amendments are outside this supplied target. The Perl parser consumes filing documents and writes the intermediate results table.
- sec_analytics_jordan [undetermined]: Author-named homed.SEC_Analytics_Jordan table. The SAS source reads CIK, FORM, SECFNAME and FDATE to filter SC 13D, build a filename suffix, and establish the filing year; additional columns are carried downstream and need a full schema/lineage contract. Its filename2 key must match the Perl output filename2 transformation.
- compcrsp_merged [undetermined]: Author-named homed.compcrsp_merged_jan2019 input. SAS derives YEAR from DATADATE and joins by CIK/YEAR; downstream code also uses GVKEY, LPERMNO, SIC, CUSIP and Compustat controls. The supplied package does not include its producer or the crosswalk/transformation contract.
- tfn_s34 [undetermined]: Thomson-Reuters 13F holdings table TFN.S34 with CUSIP, RDATE, SHARES and SHROUT1. SAS filters report dates before 1993, removes missing values, derives CUSIP6 and year-quarter, and joins holdings to filings by CUSIP6/year-quarter.
- ibes_eps_consensus [undetermined]: Author-prepared I/B/E/S input ibes.eps_consensus_unadjusted_1994 with DATE, PERMNO and NUM_FORECAST. SAS keeps dates from 1993 onward, forms year-quarter, averages NUM_FORECAST by PERMNO/quarter and joins to the filing quarter.
- perl_html_strip [preparation_required]: The supplied Perl source imports HTML::Strip, which was not available in the checked Perl environment.
- sas [unverified]: The source requires SAS DATA steps, PROC SQL, SORT, MEANS and UNIVARIATE. SAS 9.4 startup did not complete because TKELS initialization failed; runtime availability remains unverified. PROC UNIVARIATE alone does not establish a SAS/STAT dependency.
- sas_connect [unverified]: The supplied merge program uses SIGNON, RSUBMIT, PROC UPLOAD and PROC DOWNLOAD to query WRDS; the component and remote entitlement were not verified.
- sas_pc_files [unverified]: The source exports with PROC EXPORT DBMS=STATA. The SAS PC Files documentation describes this format, but component entitlement is not verified.
- sas_enterprise_gui [unverified]: The author specifies importing Perl results.txt into rawd.results using SAS Enterprise; availability of that GUI/import interface was not checked.

## Review notes

- The frozen dependency checklist is empty and the static audit reports no supported code. The actual PDF-embedded programs were traced directly; code-derived inputs and handoffs are recorded here rather than treating parser silence as closure.
- The 26,486-line identifiers PDF is a filing-ID/date list only. It is not a prepared analysis dataset and does not justify an analysis_only scope.
- FactSet is named in documentation but no supplied SAS input read for FactSet was found. Audit Analytics appears only as a Stata cross-check comment; neither is added as a live input requirement.
- The SAS local-data probes are one-row readability/field checks only. They do not establish historical coverage or author-specific prepared dataset equivalence.
- Source references use the work item cached text line ranges; program code is embedded in PDF containers and is not directly executable.
- The existing local CRSP one-row probes verify table readability and required columns, not full event/history coverage. Their locations can support a local route only after configuring the supplied queries appropriately; current code places the source queries inside SAS/CONNECT RSUBMIT.
- The SEC filing target follows the explicit SAS SC 13D selector. The companion 13-D constant is inactive, and the SAS branch excludes SC 13D/A by exact form matching; no amendment-scope clarification is required for this supplied branch.
- The SEC form/year configuration is a routine working-copy choice supported by the downstream exact SC 13D filter and inclusive 1996–2018 sample. The code current 2018-to-1996 ascending range is empty; no descending-loop rewrite is proposed.
- Actions that mention code changes apply only to extracted working copies; no PDF or author code was modified or executed. No data were downloaded and no packages were installed.
- The complete source closure is not established because SEC_Analytics_Jordan and compcrsp_merged_jan2019 have no supplied producers/contracts, TFN and I/B/E/S routes remain unresolved, Stata has unproduced field references, and Table 6 is manual.
- SAS/STAT is not listed as a separate dependency because the source uses PROC UNIVARIATE, which the frozen rules attribute to Base SAS.
- Exact Stata software checks cover winsor, eststo, estpost, estadd, esttab, reghdfe and ftools; all are separated by the command keys used in the probes.
