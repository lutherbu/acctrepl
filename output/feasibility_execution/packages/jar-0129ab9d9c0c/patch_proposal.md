# Patch proposal: jar-0129ab9d9c0c

Economic Growth and Financial Statement Verification

DOI: 10.1111/1475-679X.12165

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

All author-documented main-paper analyses and the online-appendix analyses for Economic Growth and Financial Statement Verification, assessed across the supplied RMA, Sageworks and IRS Stata branches.

Entry points: `LMS_code_RMA 2016-01-19.txt`, `LMS_code_Sageworks 2016-01-19.txt`, `LMS_code_IRS 2016-01-19.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 4/12165 - Economic-Growth-and-Financial-Statement-Verification/lms-datasheet-and-code.zip",
      "sha256": "6645b6cf34ec6044dffc9c8a5bb63b55f55ac46518432c5ba831c44d46c64e8d"
    },
    {
      "path": "JAR-Volume 55/Issue 4/12165 - Economic-Growth-and-Financial-Statement-Verification/lisowsky-minnis-sutherland-online-appendix.pdf",
      "sha256": "0d0a5e187f5608e76a00d77c08a4b91771fa4f6567d9367d475610341dd5b5b9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "541ec271c4a08ee2eefcb87fb203b093994565b811a21d4a36002b240902300c"
}
```

## Proposed actions

### act_callreports_acquisition: Acquire and convert the public quarterly Call Report source needed by the RMA branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req_call_reports
Evidence: ev_pub_ffiec_bulk, ev_pub_ffiec_history, ev_callreports_source, ev_callreports_fields, ev_callreport_lags, ev_callreport_windows

Preparation / proposed procedure:

1. Use FFIEC CDR Public Data Distribution bulk downloads for every required quarter in 2002–2011, selecting the quarterly product and tab-delimited or XBRL format.
2. Convert the official reports to the Stata structure expected as Callreport.dta, retaining bank RSSD identifiers, report dates and the specific item codes consumed by the author program.
3. Preserve full quarterly ordering and the source history needed by one-, two-, and three-year offsets and four- and eight-quarter charge-off windows.
4. Confirm that all institutions matched to RMA and all author-required item codes are present; consult the author’s WRDS extract specification where the current public source differs.

Validation to perform later:

- Before a future authorized run, verify the 2002–2011 quarter coverage, bank/item completeness and mapped Stata fields; then check that each lag/window is generated only from the intended bank and quarter history.

### act_rma_inputs: Request the exact bank-level RMA product and author-produced bank-to-RSSD mapping needed by the supplied RMA workflow.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_rma_banklevel, req_rma_rssd
Evidence: ev_datasheet_workflows, ev_rma_years, ev_rma_fields, ev_rma_banknames, ev_rma_idmap, ev_catalog_lookup

Preparation / proposed procedure:

1. Ask the authors for permitted access to the 2003–2012 RMA publication-year bank-level files and the RSSD.dta crosswalk, or a compatible author-prepared bank-level input.
2. Confirm data rights, file coverage, year/field names, bank identifiers, NAICS, region, size category, sales/assets, and statement-type counts.
3. Do not substitute publicly aggregated Annual Statement Studies for bank-level data used by the code unless authors confirm that the substitution preserves the target analyses.

Validation to perform later:

- Check that the supplied bank-level files and crosswalk have the required publication years, fields and bank keys before the RMA-to-Call-Report merge.

### act_gdp_source: Confirm the exact source, vintage and construction of the industry GDP files used in RMA Table 4.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_gdp_industry
Evidence: ev_rma_gdp, ev_rma_gdp_vars, ev_pub_bea, ev_catalog_lookup

Preparation / proposed procedure:

1. Ask the authors to identify the source/product, vintage, unit, year coverage, GDP3.dta and GDP2.dta field names, and how current/lagged GDP growth is constructed.
2. If the authors confirm the BEA GDP-by-industry product, obtain the matching historical tables and convert them to the specified NAICS/year keys and code variables without changing the series or vintage.

Validation to perform later:

- Verify the 2-digit and 3-digit NAICS/year keys, GDP levels/growth fields, units, vintage and lag history against author-provided specifications.

### act_sageworks_inputs: Request authorized complete Sageworks inputs, the report-type lookup, and the withheld sample-filter instruction.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_sageworks, req_sageworks_reports, issue_sageworks_redaction
Evidence: ev_datasheet_sageworks, ev_sageworks_file_2001, ev_sageworks_file_2005, ev_sageworks_file_2006, ev_sageworks_file_2007, ev_sageworks_file_2008, ev_sageworks_reportmap, ev_sageworks_lags, ev_sageworks_forward, ev_sageworks_redaction

Preparation / proposed procedure:

1. Ask the authors for a permitted compatible 2001–2008 Sageworks firm-year dataset or current authorized acquisition route, with the identifiers and report/financial fields expected by the code.
2. Request reports.dta and its source/producer documentation.
3. Request the exact confidential customer-ID exclusion or an author-supplied runnable version that preserves the stated sample construction; do not guess the filter or drop the step.

Validation to perform later:

- Verify source years, firm-year identifiers, adjacent-year sales history and reporttype mapping; confirm the authorized replacement for the withheld filter before any execution.

### act_irs_inputs: Clarify whether the authors can provide a currently authorized IRS input route and the missing pre-Stata preparation specification.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_irs_returns, issue_irs_access, issue_irs_preprocessing
Evidence: ev_datasheet_irs, ev_datasheet_irs_retention, ev_irs_inputnames, ev_irs_fields, ev_irs_sample, ev_datasheet_preprocessing

Preparation / proposed procedure:

1. Ask the authors to confirm current access and reuse permission under the IRS contract; do not infer an available license or a current barrier from historical retention language.
2. Request permitted compatible prepared Stata inputs for the three filer types or the documented authorized raw-to-Stata conversion, including field mappings for Forms 1120/1120S/1065 and Schedule M-3.
3. Confirm the actual file paths replacing the bracketed aliases and coverage for fiscal years 2008–2010 and the stated asset/e-file restrictions.

Validation to perform later:

- Check each filer input’s fields, EIN/fiscal-year key, period and Schedule M-3 pairing against the supplied harmonization and sample-selection steps before attempting the branch.

### act_paths_run_order: Obtain a complete root/path map and author-confirmed run instructions for the three text-embedded Stata programs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_paths, sw_stata
Evidence: ev_datasheet_stata, ev_rma_years, ev_rma_order, ev_sageworks_root, ev_irs_inputnames, ev_irs_output

Preparation / proposed procedure:

1. Ask the authors to identify the required working directory, full paths replacing RMA placeholders, Sageworks project root, IRS dataset aliases and intended order for the three independent data branches.
2. Preserve the source order within the RMA program: produce the intermediate RMA files before consumers; produce RMAcollapse before loading Callreport.dta and merging bank-quarter records.
3. Confirm the Stata release used by the authors; Stata 18 is available in this environment, but compatibility has not been established.

Validation to perform later:

- After permitted inputs and setup are supplied, confirm each entry point resolves every path and generated producer before any authorized execution.

### act_appendix_workflows: Map all reported online-appendix analyses to executable author code and their exact inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_appendix_workflow, issue_appendix_coverage
Evidence: ev_appendix_a1, ev_appendix_a2, ev_appendix_a3, ev_appendix_a4, ev_appendix_a5, ev_appendix_a6, ev_appendix_a7, ev_appendix_a8, ev_catalog_lookup

Preparation / proposed procedure:

1. Ask the authors which supplied program generates each of A1–A8 and request any independent companion scripts, run order, data inputs and output instructions.
2. For A7, ask the authors to specify the AuditAnalytics and Compustat products, fields, identifiers, period and sample/merge construction; treat frozen-catalog hits as discovery candidates only until compatibility is established.
3. Retain the separate RMA, Sageworks and IRS appendix branches where they are required for the reported analyses.

Validation to perform later:

- Review the author-provided mapping and code against every appendix table description, source requirement and panel period before claiming full-paper coverage.

### act_xtilej_setup: Obtain the author-required xtileJ implementation for Sageworks Table 7.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_xtilej
Evidence: ev_probe_xtilej, ev_sageworks_outputs

Preparation / proposed procedure:

1. Ask the authors for the xtileJ ado source, package identity/version and supported installation instructions or a permitted compatible copy.
2. In a later authorized setup, place the confirmed command on the Stata adopath and retain the author’s quintile semantics. Do not substitute another command without confirmation.

Validation to perform later:

- Use a bounded which xtileJ check in the confirmed runtime before any future authorized analysis run.


## Remaining issues and prerequisites

- issue_paths [unresolved; full_pipeline]: The three supplied programs are substantial Stata code embedded in TXT files, but paths or input names are placeholders: RMA uses *** path prefixes, Sageworks sets [redacted-path-a9831e33deb5]**\** and uses a relative 4-6-09 folder, and IRS uses [file1120]/[file1120S]/[file1065] placeholders. The datasheet does not provide a complete project-root configuration or entry/run order.
- issue_irs_access [unresolved; full_pipeline]: The IRS data were confidential and the datasheet says the contract required purge after the other project, with access expected to end by the end of 2017. Present access, reuse permission, and a compatible authorized route are unknown; the historical expectation does not establish a current barrier.
- issue_irs_preprocessing [unresolved; full_pipeline]: The datasheet says some preprocessing, including converting raw data to Stata datasets, occurred before these do-files. The IRS program starts from prepared filer-specific data and placeholder names, and the conversion steps and raw-to-Stata field mapping are not supplied.
- issue_sageworks_redaction [blocking; full_pipeline]: The Sageworks program replaces a required customer-ID exclusion with the literal withheld text “drop if ******CONFIDENTIAL REFERENCE - THIS STEP IS WITHHELD************”. The exact criterion affects sample construction and cannot be supplied as executable code or reconstructed from the package. This blocks the complete Sageworks branch until the authors clarify or provide an authorized runnable version.
- issue_appendix_coverage [unresolved; full_pipeline]: The online appendix reports A1–A8, but the package gives no explicit mapping from those results to supplied entry points and no separate appendix workflow. The A7 source names alone do not establish exact required products, inputs or transformations. Clarify coverage before treating any appendix output as reproduced.
- req_rma_banklevel [undetermined]: Author bank-level RMA Annual Statement Studies records for Tables 1–5 and the bank-level analysis in Table 8. The Stata program stacks RMA publication-year files 2003–2012, which the datasheet describes as calendar years 2002–2011. It uses Bank, State, NAICS, Region, size category, sales/assets, and counts by statement type. The publicly available aggregate product mentioned by the authors is not established as a compatible substitute for these bank-level records.
- req_rma_rssd [undetermined]: Author bank-name to RSSD identifier crosswalk used to link the RMA bank records to Call Reports.
- req_call_reports [public_acquisition_required]: Quarterly bank Call Report records for the supplied RMA bank sample over 2002–2011, including RSSD identifiers and the report items consumed by the Stata program. The code creates one-, two-, and three-year offsets and sums charge-offs over four- and eight-quarter windows; retain complete quarter ordering and source history needed for those constructions.
- req_gdp_industry [undetermined]: Annual U.S. industry GDP source files for the RMA Table 4 analysis. The code merges GDP3.dta by three-digit NAICS and year, then GDP2.dta by two-digit NAICS and year, and consumes GDP_3/GDP_2 plus current and lagged GDP-growth variables. The source series, vintage, units, file fields and producer are not specified.
- req_sageworks [undetermined]: Private Sageworks firm-year financial statement records for the supplied Tables 6–7 analysis and related appendix work. The code expects yearly batches for 2001–2008 and derives prior- and next-year sales measures from adjacent firm-year observations, so retain the full stated input window and firm identifiers/history.
- req_sageworks_reports [undetermined]: Report-type lookup required to merge the Sageworks records to report-form labels before sample selection.
- req_irs_returns [undetermined]: Parent-level consolidated IRS Forms 1120, 1120S and 1065, each combined with its consolidated Schedule M-3, for fiscal years 2008–2010 and assets at least $10 million. The supplied program relies on filer-specific Stata variables and merges filer types on EIN and fiscal year.
- req_appendix_workflow [undetermined]: Author-supplied code and compatible input specifications for online-appendix analyses not explicitly mapped to the three supplied Stata programs. The appendix reports bank-level robustness tables A1–A3, Sageworks analyses A4–A6, a public-firm audit-fee analysis A7, and an IRS robustness analysis A8. Table A7 names AuditAnalytics and Compustat, but its required fields, identifiers, periods and construction are not provided.
- sw_xtilej [preparation_required]: The exact command used to create Sageworks quintiles was not found by Stata which in the assigned probe. Obtain the author ado/package or supported installation instructions; no substitute was assumed.

## Review notes

- Expanded checkpoint after reading all three author Stata programs, the datasheet and online appendix; checking the frozen catalog, FFIEC/BEA official pages and exact Stata command availability. No author code was executed, no datasets were read/downloaded, and no packages were installed.
- The static report’s zero code artifacts is a syntax-coverage limitation: actual source content in the three TXT files establishes substantial Stata data preparation and analysis programs, as the authors also call them do-files.
- The only justified scope is full_pipeline. This package supplies no author-prepared analysis data or distinct analysis-only entry point; all three supplied branches still need their underlying author data and producers.
- Producer/consumer order traced from source: RMA publication-year records create precollapse and National1 intermediates; Table 4 consumes National1 plus GDP3/GDP2; Table 5 consumes precollapse; the Table 8 section reconstructs RMAcollapse before loading quarterly Call Reports and merging bank-quarter records. Sageworks yearly batches are cleaned/appended before reports.dta merge and analysis. IRS filer datasets are harmonized, merged by EIN/fiscal year, sample-filtered, then used for Table 9.
- Call Report history is not inferred from estimation dates alone: source requests quarterly data for 2002–2011 and creates 1-, 2- and 3-year offsets and charge-off sums over prior quarters. The exact author windows and 2002–2011 source range remain in the requirement; no unrelated history is guessed.
- Online appendix A1–A8 analyses have no explicit code mapping in the release; appendix table descriptions are clarification evidence, not proof that similarly named main-paper branches reproduce them.
- Frozen-catalog hits are discovery metadata only. Empty lookups do not establish missing licenses or unavailable sources; the AuditAnalytics/Compustat candidates are not validated or treated as compatible A7 inputs.
- IRS historical retention text is not used to declare a current access barrier. The Sageworks literal redaction is a confirmed executable gap affecting sample construction and blocks completion of that branch until authors clarify it.
- No frozen dependency edges were supplied in work_item.json; dependency_review is therefore empty. Closure remains incomplete because inputs, path setup, IRS preprocessing, the Sageworks redaction and appendix workflow mapping remain unresolved.
