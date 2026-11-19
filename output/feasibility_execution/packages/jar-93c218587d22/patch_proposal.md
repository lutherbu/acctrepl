# Patch proposal: jar-93c218587d22

Measuring Risk Information

DOI: 10.1111/1475-679X.12413

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete code-supplied mixed SAS/Stata workflow: remote panel preparation, local filtering/standardization/ranking/winsorization, descriptive and portfolio outputs, and all supplied Stata branches. The TXT container needs separate working SAS and Stata files. Table 7/8 and appendix analyses mentioned without executable branches remain contextual extensions.

Entry points: `smithsoJAR_code.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 2/12413 - Measuring-Risk-Information/ss-datasheet-code-and-identifiers.zip",
      "sha256": "42b85e39c75a03b40e2de3f75fa2ea2ee2cd12704b3d6253107403e780aee4fd"
    },
    {
      "path": "JAR-Volume 60/Issue 2/12413 - Measuring-Risk-Information/ss-online-appendix.pdf",
      "sha256": "1ad31ac14c1a518d294c4f15ab1c8a2d700c3366a79259f626561ba26dda4fb4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "1450f17a68a1f66eb97436d5a7c51ca8a32f19b8fbbbf0d2ac65ed5a64580857"
}
```

## Proposed actions

### act_resolve_native_sources: Confirm the exact input product, access route and required period for each remote source table, and validate whether the bounded local Compustat/IBES/CCM/CRSP/French candidates cover the authored filters and histories.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_inputs_and_handoff, req_comp_fundq, req_compa_namesq, req_ibes_statsum, req_crspa_ccmxpf, req_comp_funda, req_crspa_msp500, req_crsp_mport1, req_crsp_dsf, req_crsp_dsi, req_ff_factors_daily, req_option_stdopd, req_option_securd, req_option_opprcd, req_cboe
Evidence: src_datasheet_public_wrds, src_datasheet_window, src_compustat_join, src_ibes_read, src_ccm_read, src_funda_read, src_msp500_read, src_mport1_read, src_option_year_pairs, src_option_fields_window, src_cboe_read, src_crsp_windows, src_french_factors, src_opprcd_read, src_allvol_producer, cat_registered_resources, probe_comp_fundq, probe_compa_namesq, probe_ibes_statsum, probe_crspa_ccmxpf, probe_comp_funda, probe_crspa_msp500, probe_crsp_dsf, probe_crsp_dsi, probe_ff_factors, inspect_workflow_trace

Preparation / proposed procedure:

1. For each exact catalog-listed local candidate, confirm product identity and the required event/history period; the existing one-row probes establish readable fields only, not the full period or population.
2. Confirm access and source fields for the named remote CRSP.MPORT1, OPTIONM.STDOPD1996-2019, OPTIONM.SECURD, OPTIONM.OPPRCD1996-2019 and CBOE.CBOE inputs; retain the code's joins, conditions, yearly loops and source windows.
3. Keep COMP.FUNDQ and COMPA.NAMESQ separate because SIC comes from the joined NAMESQ table, and keep COMP.FUNDA separate from FUNDQ.
4. Treat JSOPT and MYDIR.ALLVOL as supplied generated intermediates: produce them from the stated OPPRCD/SECURD/CRSP.DSF chain before SSOPVOL; do not add ALLVOL as a missing raw input.

Validation to perform later:

- Before future execution, verify each selected product's actual schema and coverage against the registered field/date contracts without treating sampled rows as complete coverage.
- After an authorized run, check each intermediate's columns and keys before its next consumer, including SSBase, SSIV1, BetaIVOL/BetaIVOL2, JSOPT, ALLVOL, SSOPVOL and the merged remote panel.

### act_resolve_erp_input: Identify a compatible monthly ERP input for the ICC branch, using the datasheet's ERP_PUBLIC_210621 file as the documented lead.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_erp_public, issue_erp_contract
Evidence: src_datasheet_erp, src_erp_join

Preparation / proposed procedure:

1. Obtain the described file or another prepared input and confirm its GVKEY, YEAR, MONTH and GLS_AN fields, measure units, construction and monthly coverage against both adjacent-month joins; the actual input values and compatibility remain unknown until checked.
2. Retain the two source-specific INTCK('MONTH') directions, annualization expression and negative-to-missing treatment; do not reconstruct ERP values independently.

Validation to perform later:

- Before execution, compare the supplied table's fields, units, construction and monthly coverage with both source joins; after authorized execution, confirm both GLS1/GLS_1 sides are consumed and DeltaGLS is produced.

### act_resolve_winsor_macro: Confirm a macro implementation matching the supplied %WINSOR invocation contract before running the local SAS analysis.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_winsor_contract
Evidence: src_winsor_call, pub_wrds_winsor

Preparation / proposed procedure:

1. Identify a routine implementing the supplied DSETIN/DSETOUT/BYVAR/TYPE/PCTL call and verify its signature, PERIOD grouping and 1/99 percentile behavior against the source contract.
2. The current official WRDS %WINSORIZE page macro has a different displayed name and parameters, and is not verified as compatible with this invocation.

Validation to perform later:

- Before future execution, verify the implementation's parameter mapping and behavior contract statically; after authorized execution, confirm the routine produces SSOPT1a while retaining the authored variables and cutoffs.

### act_sas_runtime_setup: Establish a working SAS/WRDS setup with the procedures, remote submission and export formats required by the supplied workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas
Evidence: src_remote_stage, src_option_fields_window, src_french_factors, src_winsor_export, probe_environment

Preparation / proposed procedure:

1. Use an authorized SAS environment with functional RSUBMIT/SAS-CONNECT to WRDS and verify the needed PROC EXPAND, PROC GLM, PROC UNIVARIATE/STANDARD and PROC EXPORT DTA/XLS/XLSX capabilities.
2. The assigned environment artifact records a prior TKELS initialization failure; that does not establish a missing license. Recheck through the normal supported environment setup when the run is authorized; no SAS retry occurred in this assessment.

Validation to perform later:

- Before author-code execution, confirm SAS startup and required remote/libref/export capabilities in a separate authorized setup check; do not infer compatibility from the executable path alone.

### act_split_mixed_source: Prepare language-specific working files from the supplied TXT container while preserving the author's section order and complete branches.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: issue_mixed_container
Evidence: src_remote_stage, src_stata_boundary, src_stata_input, inspect_workflow_trace

Preparation / proposed procedure:

1. Preserve the frozen smithsoJAR_code.txt and create a working copy.
2. Reflow the remote SAS code bounded by RSUBMIT/ENDRSUBMIT into a SAS driver, retaining all supplied macro producers and their execution order.
3. Reflow the subsequent local SAS preparation/descriptive/portfolio section into a separate SAS driver; reflow every Stata branch into a DO-file, preserving its estimator calls, fixed effects and clustering.
4. Keep supporting comments with their respective sections, but do not turn Table 7/Table 8 notes or appendix descriptions into invented executable branches.

Validation to perform later:

- Before future execution, compare the prepared working files line by line with the frozen container, verify no branch was dropped, and verify the remote/local/Stata handoffs match the recorded workflow trace.

### act_configure_working_paths: Configure writable remote and local library roots and the shared SSD/results directory while keeping the authored filenames and outputs consistent.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: issue_output_paths
Evidence: src_remote_stage, src_winsor_export, src_output_dirs, src_stata_input

Preparation / proposed procedure:

1. Set the WRDS-side MYDIR location and the local SAS A library to the staged remote file using the same working-copy filename.
2. Choose a writable project root for the authored SSD file and create the corresponding RawResults folder; set SAS and Stata to use the same path while preserving the published output names.
3. Confirm the selected SAS setup supports the .dta export/read handoff and XLS/XLSX exports; leave any format incompatibility unresolved until checked.

Validation to perform later:

- Before a future run, check the configured input/output paths and permissions statically; after authorized execution, confirm SAS writes the SSD file that every Stata branch reads and that all result outputs use the configured RawResults directory.

### act_reconcile_dated_handoff: In a working copy, rename the actual remote output to the 20211022 staging name already used by PROC DOWNLOAD and the local SAS reader, and align the explanatory section comment.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: issue_handoff_name
Evidence: src_final_producer, src_download_consumer, src_mismatch_comment, src_local_download_instruction, src_local_read, src_datasheet_window

**Proposed edit:** `smithsoJAR_code.txt:892–892`
Source SHA-256: `bdf32ffc8024f213415600675148de14c0e417f0110a154df60c280640288c66`

The produced table currently differs from the existing PROC DOWNLOAD request and local A.SMITHSOJAR_20211022 reader. Matching the producer to the existing 20211022 staging contract changes only the output name, not the data or analysis.

Current text:
```
data mydir.smithsoJAR_20211102;
```

Proposed replacement:
```
data mydir.smithsoJAR_20211022;
```

**Proposed edit:** `smithsoJAR_code.txt:1003–1003`
Source SHA-256: `bdf32ffc8024f213415600675148de14c0e417f0110a154df60c280640288c66`

Keep the explanatory staged-file comment consistent with the remote producer, PROC DOWNLOAD, explicit filename instruction and local reader.

Current text:
```
** THIS SECTION CONTAINS CODE TO PROCESS DATA AFTER DOWNLOADING THE FILE mydir.smithsoJAR_20211102 FROM WRDS;
```

Proposed replacement:
```
** THIS SECTION CONTAINS CODE TO PROCESS DATA AFTER DOWNLOADING THE FILE mydir.smithsoJAR_20211022 FROM WRDS;
```

Preparation / proposed procedure:

1. Apply both exact edits only in the working copy; retain the original author bytes unchanged.

Validation to perform later:

- Statically confirm the producer, PROC DOWNLOAD, download instruction, section comment and A.SMITHSOJAR_20211022 reader all name the same staged table before a future run.

### act_clarify_ppvmalt: Clarify the intended source field or construction for PPVMALT in the supplied SAS correlation branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_ppvmalt_alias
Evidence: src_ppvmalt_read, src_ppvma_defined

Preparation / proposed procedure:

1. Request the exact intended PPVMALT definition or confirm the author-approved source variable for this correlation table.
2. Keep the supplied PPVMALT reference unresolved until its meaning is confirmed; do not silently replace it with PPVMA or drop it.

Validation to perform later:

- Before future execution, reconcile the confirmed source field against the dataset created by the preceding SAS steps and then verify the correlation branch consumes that field.

### act_ordered_run_procedure: Run the complete supplied remote SAS, local SAS and Stata sequence only after its input, handoff, software and macro contracts are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: inspect_workflow_trace, src_allvol_producer, src_final_producer, src_download_consumer, src_winsor_export, src_stata_input, src_stata_main, src_stata_subsamples, src_stata_factor_loadings, src_stata_method, src_stata_horizon, src_stata_icc_liquidity

Preparation / proposed procedure:

1. Prepare the separate working drivers and configured remote/local roots; fix the dated producer-consumer name and resolve required input/software contracts.
2. Run the remote quarterly Compustat FUNDQ plus NAMESQ and IBES construction, then the CCM/FUNDA/S&P/MPORT1 link stage to SSBase.
3. Build standard OptionMetrics implied-volatility panels and CBOE VIX/CRSP daily outcome measures, then the French-factor GLM beta/idiosyncratic-volatility panels using the authored periods and strict/inclusive weekday boundaries.
4. Build yearly OPPRCD option-volume tables joined with SECURD and DSF, then JSOPT -> MYDIR.ALLVOL -> MYDIR.SSOPVOL; ALLVOL is generated by the supplied Step 8 code.
5. Merge SSIV1, SSV1-SV9, BetaIVOL/BetaIVOL2, VIX and SSOPVOL into the dated remote analysis table, download the reconciled filename, and stage it in the local A library.
6. Run local SAS filtering, period standardization, the two ERP joins, percentile ranks using next-quarter breakpoints, the exact winsor call, SSD creation/export, descriptive/correlation outputs and both portfolio-construction branches.
7. Run every supplied Stata branch on the shared SSD file: PPVMA specifications, option-volume and S&P subsamples, factor-loading changes, methodological controls, volatility horizon and ICC/liquidity regressions.

Validation to perform later:

- After separately authorized execution, verify each generated table exists before its consumer, compare actual columns/keys at language handoffs, confirm the date windows and missing-value rules are unchanged, and review the expected result files and regression fixed-effect/cluster settings.


## Remaining issues and prerequisites

- issue_inputs_and_handoff [unresolved; full_pipeline]: Closure is incomplete. Several exact local candidates have compatible one-row fields but no demonstrated required history; OptionMetrics, CBOE and MPORT1 remain named remote products without a verified route; and the author-prepared ERP file is not supplied. No catalog miss or single-row read establishes availability or date coverage.
- issue_handoff_name [preparation; full_pipeline]: The supplied remote DATA step produces MYDIR.SMITHSOJAR_20211102, but PROC DOWNLOAD requests MYDIR.SMITHSOJAR_20211022; the local download instruction and A.SMITHSOJAR_20211022 consumer also use 20211022. This is a preparation-level naming mismatch that the proposed source-hashed working-copy edit can align without changing the table contents or analysis.
- issue_mixed_container [preparation; full_pipeline]: The substantive code is stored in one TXT document with remote SAS, local SAS and Stata sections, not separate runnable SAS/DO drivers. Create language-specific working copies that retain supplied order and all branches before execution.
- issue_output_paths [preparation; full_pipeline]: The authors hard-code [redacted-path-7fc00441e0c0] and [redacted-path-6bc4597cabeb] outputs and use separate remote MYDIR and local A libraries. Set consistent working-copy roots, library mappings and result directories; verify the SAS DTA/XLS/XLSX export support before a future run.
- issue_winsor_contract [unresolved; full_pipeline]: The code calls %WINSOR with DSETIN/DSETOUT/BYVAR/TYPE/PCTL parameters, but a matching macro definition or compatible implementation is not supplied or verified. The current official WRDS WINSORIZE page displays a different macro name and parameter signature, so that routine cannot be presumed to satisfy this call; another implementation could be used only after its actual call and percentile behavior are verified.
- issue_erp_contract [unresolved; full_pipeline]: The main ICC/liquidity branch consumes monthly ERP_PUBLIC_210621 data described as available from the authors, joining by GVKEY and YEAR/MONTH and requiring GLS_AN. This package does not provide the input or establish its consumed schema, units, construction or coverage. A compatible prepared input must match those contracts; original-byte identity is not established as a requirement, and the values must not be independently reconstructed.
- issue_ppvmalt_alias [unresolved; full_pipeline]: The SAS PROC CORR branch reads PPVMALT, but the supplied source constructs PPVMA and has no PPVMALT construction. The intended variable or definition is unresolved; do not silently substitute PPVMA.
- req_comp_fundq [undetermined]: Quarterly Compustat FUNDQ fields used for quarterly fundamentals and earnings-event dates. The code filters RDQ>01JAN1990 and uses quarterly lags and an eight-quarter moving standard deviation.
- req_compa_namesq [undetermined]: Compustat NAMESQ GVKEY-to-SIC lookup joined to FUNDQ. The source maps SIC to DNUM and later derives SIC=floor(DNUM/100).
- req_ibes_statsum [undetermined]: IBES US summary-statistics EPS consensus data for analyst surprise, forecast dispersion and coverage, joined by CUSIP and announcement date.
- req_crspa_ccmxpf [undetermined]: CRSP/Compustat CCM link history supplying LPERMNO and link dates/types for the event panel.
- req_comp_funda [undetermined]: Annual Compustat FUNDA data separately joined in the CRSP link stage with the code's fiscal/year, format, currency, status, CIK/TIC, assets, sales and CUSIP fields.
- req_crspa_msp500 [undetermined]: CRSP S&P 500 membership intervals joined on PERMNO and ACTDATE to create SNP.
- req_crsp_mport1 [undetermined]: CRSP MPORT1 is a separate source table for CAPN/NYSE size decile used to construct NYSD and the year-by-NYSE-size-decile fixed effect.
- req_crsp_dsf [undetermined]: CRSP Daily Stock File for event linking, stock returns, prices, shares, volume, quotes and HEXCD filters throughout the supplied workflow.
- req_crsp_dsi [undetermined]: CRSP Daily Index File for EWRETD market-adjusted return calculations paired with DSF by DATE.
- req_ff_factors_daily [undetermined]: French daily factor file for RF, market, SMB, HML and UMD inputs to both supplied GLM beta/idiosyncratic-volatility branches.
- req_option_stdopd [undetermined]: OptionMetrics standard-volatility yearly STDOPD files for all option maturity/event-date observations in the remote panel.
- req_option_securd [undetermined]: OptionMetrics SECURD CUSIP/SECID crosswalk used jointly by STDOPD and OPPRCD joins.
- req_option_opprcd [undetermined]: OptionMetrics daily OPPRCD product for the option trading volume, option dollar volume, delta, open interest, volatility and liquidity subsample construction.
- req_cboe [undetermined]: CBOE daily VIX table for the supplied pre/post event VIX measures and event-window average VIX.
- req_erp_public [undetermined]: Monthly ERP_PUBLIC_210621 input described as available from the authors and joined to event dates for the two-sided ICC change measures; required fields are GVKEY, YEAR, MONTH and GLS_AN.
- sw_sas [unverified]: The author source requires SAS remote submission to WRDS, SAS/CONNECT, PROC EXPAND/GLM/UNIVARIATE/STANDARD and SAS export to Stata/XLS/XLSX. The machine's SAS 9.4 executable path is recorded, but the assigned environment artifact says the prior bounded startup failed at TKELS; runtime/module and export compatibility remain unverified, and this is not evidence of a missing license.

## Review notes

- Assessed the complete code-supplied mixed SAS/Stata workflow in smithsoJAR_code.txt and its supplied documentation; discussion of Table 7, Table 8 and appendix analyses without executable branches remains contextual.
- The registered packaged SAS dataset contains RI30, RI60, RI182 and RI365 plus identifiers and dates. It is credited as partial evidence and is not treated as a complete author analysis panel or an analysis-only route.
- Exact catalog-listed local datasets and one-row probes establish candidate paths and readable fields only; the required historical coverage, source compatibility and vintages remain unresolved. Remote WRDS/OptionMetrics/CBOE inputs and the ERP input named in the author datasheet also need their actual access and field contracts.
- The source itself produces MYDIR.ALLVOL in Step 8. Its remote final table is named 20211102 while PROC DOWNLOAD, the instruction and local reader use 20211022; the proposed working-copy edit aligns this handoff. No source edit was applied.
- Other unresolved contracts are a compatible %WINSOR implementation matching the supplied invocation, SAS/CONNECT and export setup, the working library/output roots, and the PPVMALT reference in the supplied correlation step. The current public WRDS winsor macro signature is not verified as compatible with the call in this source.
- ERP and macro resources must match the consumed fields, units, construction, coverage and call behavior; this assessment does not require original-byte identity. Those compatibility details remain unknown until an actual resource is checked.
- Source date directions, weekday units and boundaries, missing-value rules, table construction, fixed effects and clustering are retained in the requirements, issues and ordered procedure. No author program was executed or transformed, and no estimation or data generation was performed.
