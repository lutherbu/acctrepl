# Patch proposal: jar-a95ec7bbadc8

Did the Siebel Systems Case Limit the SEC’s Ability to Enforce Regulation Fair Disclosure?

DOI: 10.1111/1475-679X.12423

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata workflow in ABKP_Code.txt, covering the earnings-break and BAR construction, real-effects and suspect-trading branches, and Appendix A preparation code.

Entry points: `ABKP_Code.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12423 - Did-the-Siebel-Systems-Case-Limit-the-SECs-Ability-to-Enforce-Regulation-Fair-Disclosure/abkp-datasheet-code-and-identifiers.zip",
      "sha256": "eebf8ae958d9953ad3bb0d7265e472f7149e971e1e9ad0cec40747d51c619b62"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12423 - Did-the-Siebel-Systems-Case-Limit-the-SECs-Ability-to-Enforce-Regulation-Fair-Disclosure/abkp-online-appendix.pdf",
      "sha256": "8faac99c80a464043e2ced41d9a126f40377f2d5927754c37aa11bdac5dfa0db"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "b9b0bade14b088c028db3f40981ca9af25d01026e157df16e2016f53f25a2a0f"
}
```

## Proposed actions

### act_map_inputs: Resolve the remaining source fields, periods, identifiers, and producer contracts for the native earnings-break, BAR, real-effects, suspect-trading and Appendix A branches; preserve distinct public, subscription-dependent, and author-request routes.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_crsp_daily, req_crsp_monthly, req_compustat_q, req_ccm_link, req_ibes_eps, req_ibes_recommendations, req_s34, req_bushee_class, req_generic_missing, issue_workflow_closure, req_ciq_keydev, req_compustat_annual, req_crsp_daily_index, req_crsp_monthly_index, req_comp_industry_classification, req_dgtw_earnings_returns, req_event_file, req_wang2007_data, req_bestcalls_data, req_investor_conference_inputs, req_sec_investigations, req_table8_abret_variable, req_appendix_abnormal_return, issue_cusip_group_name
Evidence: ev_ds_wrds, ev_ds_calls, ev_ds_unavailable, ev_code_crsp_daily, ev_code_crsp_monthly, ev_code_ibes_eps, ev_code_ibes_rec, ev_code_s34, ev_code_crsp_supplement, ev_code_link, ev_code_returns, ev_code_real, ev_code_suspect, ev_code_appendix, ev_code_sic_use, ev_code_cusip_partition, ev_code_manager_partition, ev_code_dgtw_spec, ev_code_event_sources, ev_code_event_merge, ev_code_wang_adjpin, ev_code_abret_variable, ev_code_appa_abret_spec, ev_code_ciq_keydev_appendix, ev_code_appa_firm_override, ev_code_sec_investigation, ev_pub_bushee, ev_pub_crsp, ev_pub_compustat, ev_pub_ibes, ev_pub_s34, ev_pub_ciq, ev_pub_lseg_eikon, ev_pub_workspace, ev_pub_sec_form8k, ev_pub_sec_edgar, ev_pub_seekedgar, ev_pub_hu, ev_pub_bushee_holdings_access

Preparation / proposed procedure:

1. For the earnings-break chain, reconcile CRSP daily/monthly, quarterly Compustat, CCM, I/B/E/S EPS and recommendation summaries, S34 plus Bushee classifications, and the author-named ADR, closed-call, conference, and `TRA_LG_TRA_SM_Data` inputs against the source keys and periods. The Bushee variable-definition page returned HTTP 400 twice; keep its raw class-field mapping unresolved.
2. For annual Compustat, use the successful probe's genuine `sich` field as the local candidate evidence, but resolve how the source's string `sic` used by `substr(sic,1,2)` is obtained and historically aligned. Do not substitute or convert current `sic`/historical `sich` without an author-compatible definition.
3. Obtain exact producers/contracts for the I/B/E/S recommendation summary, Table 6–7 three-day DGTW earnings-return table, Table 9 mixed filing/conference `event_file.dta`, Table 8 `ABRET_Variable`, and Appendix A `AppA_AbnormalReturn`; preserve each source-defined filter, identifier, date window, and separate benchmark method.
4. Keep Bestcalls pre-Reg-FD calls, `Wang2007_Data`, and FOIA-derived `sec_investigations` as conditional author-request dependencies; no request or denial is recorded. Keep CRSP, S34, I/B/E/S, CIQ and Eikon entitlements distinct.
5. Use the evidence-linked `act_native_run_order` trace for the current source order and cwd configuration; do not invent producers for comment-only stages or add independent paper-wide analyses.

Validation to perform later:

- Before a future full run, verify each named input's actual field types, keys, historical coverage, and population against author exports or exact specifications; catalog rows, landing pages, and identifier lists alone do not establish the analysis panel.
- Keep Table 6–7's three-day DGTW earnings-announcement return distinct from Appendix A's separate 0..+1 size/book-to-market/momentum return.
- Check the documented conference, event, and confounding windows and each supplied table/appendix output against the ordered trace before running the native program.

### act_winsor2_setup: Make the source-required `winsor2` add-on available on the Stata adopath before a full run. The saved environment check did not find it in either checked adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: soft_winsor2
Evidence: ev_code_winsor2, ev_stata_environment

Preparation / proposed procedure:

1. Configure an authorized Stata package source or adopath so the existing `winsor2` command resolves; do not install or replace the estimator during this assessment.
2. Keep the source's existing `replace cuts(1 99)` call unchanged.

Validation to perform later:

- After later setup, verify `which winsor2` and inspect installed help for `replace cuts(1 99)`; no example data or estimator trial is needed.

### act_fix_cusip_group_name: Prepare the supported one-line CUSIP partition name alignment before execution; the proposal retains the source's 25-group `xtile` assignment.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_cusip_group_name
Evidence: ev_code_cusip_partition, ev_code_manager_partition, ev_code_cusip_partition_edit

**Proposed edit:** `ABKP_Code.txt:151–151`
Source SHA-256: `37c4d4c48d7188199b6e139d1f2f8e49377b09414098cbafe91f157bd638cb67`

The next statement retains `firmgroup`, while the immediately preceding manager partition separately creates `fundgroup`; this preserves the existing CUSIP partition count and xtile operation.

Current text:
```
	egen fundgroup=xtile(rand), nq(25)
```

Proposed replacement:
```
	egen firmgroup=xtile(rand), nq(25)
```

Preparation / proposed procedure:

1. At ABKP_Code.txt line 151, align the generated name with line 152's retained `firmgroup` by changing only `egen fundgroup=xtile(rand), nq(25)` to `egen firmgroup=xtile(rand), nq(25)`; keep `nq(25)`, the CUSIP partition loop, and downstream merges unchanged.

Validation to perform later:

- Before a future full run, compare the exact line against the frozen source; after authorized execution, confirm `cusip_groups` retains `firmgroup` and the same 25-group operation.

### act_fix_cusip_use_clear: Prepare the two active CUSIP input calls with Stata's documented `use, clear` option; preserve each filename, append loop, and partition method.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_cusip_use_replace_option
Evidence: ev_code_cusip_use_replace_303, ev_code_cusip_use_replace_355, ev_pub_stata_use_syntax

**Proposed edit:** `ABKP_Code.txt:303–303`
Source SHA-256: `37c4d4c48d7188199b6e139d1f2f8e49377b09414098cbafe91f157bd638cb67`

Stata 18's official `use` syntax permits `clear` to replace the in-memory dataset when loading a file; `replace` is not a `use` option. Preserve the existing file name and append of groups 2–25.

Current text:
```
	use "cusip_working_group1", replace
```

Proposed replacement:
```
	use "cusip_working_group1", clear
```

**Proposed edit:** `ABKP_Code.txt:355–355`
Source SHA-256: `37c4d4c48d7188199b6e139d1f2f8e49377b09414098cbafe91f157bd638cb67`

Stata 18's official `use` syntax permits `clear` to replace the in-memory dataset when loading a file; `replace` is not a `use` option. Preserve the existing file name and append of groups 2–25.

Current text:
```
	use "cusip_working_group1", replace
```

Proposed replacement:
```
	use "cusip_working_group1", clear
```

Preparation / proposed procedure:

1. Keep both option corrections unapplied until the source-edit pass; no data, directory, group, append, or estimation changes are proposed.

Validation to perform later:

- Review both before/after lines against the frozen source and Stata 18 `use` syntax; a future full run should be the first execution of these statements with the actual group files.

### act_native_run_order: Stage and run the single supplied Stata program in its native order after the listed data and setup gaps are resolved; do not skip a branch or invent a producer.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: issue_workflow_closure
Evidence: ev_trace_ordered_workflow, ev_code_header

Preparation / proposed procedure:

1. Create one isolated project working directory containing `ABKP_Code.txt`, all prepared `.dta` inputs, and the authorized output location. The source has no project-root `cd`; unqualified `use`, `merge`, and `save` paths resolve from Stata's process cwd. After data inputs and the two source-option preparations are ready, invoke Stata 18 from that cwd with `stata -b do ABKP_Code.txt`.
2. Run the source's earnings-break preparation first (lines 22–711): daily/monthly CRSP return intermediates, I/B/E/S EPS/recommendation files, S34 plus Bushee ownership preparation, quarterly Compustat/CCM merging, then `ABKP_1995_to_2017` and the Table 2–5 branches. Stage the source-named ADR, closed-call, conference, and `TRA_LG_TRA_SM_Data` inputs where each branch reads them.
3. Continue with BAR Tables 6–7 (lines 960–1957), using the generated cleaned ownership files and required CRSP supplement; stage the separate `rdq_dgtw_3d_returns.dta` Step A input and the source-used `winsor2` setup before this branch.
4. Continue with real-effects Table 8 (lines 1974–2109): annual Compustat and CRSP intermediates, `Wang2007_Data`, acquired/imported `AdjPIN_Data.dta`, and `ABRET_Variable`; the source computes `adjPIN` from the named parameters, but no `ABRET_Variable` producer is supplied.
5. Continue with suspect-trading Table 9 (lines 2110–2272): daily CRSP stock input plus `event_file.dta`, then the supplied `rangestat` rolling-return/residual preparation. The mixed filing/conference event producer and its source mappings remain prerequisites.
6. Finish Appendix A (lines 2273–2537): Compustat–CRSP matching, daily volatility, Capital IQ event flags, then `AppA_AbnormalReturn` and `sec_investigations` joins. The separate 0..+1 characteristics-adjusted return input and FOIA-derived investigation file remain prerequisites; preserve the explicit source overrides.

Validation to perform later:

- Before execution, resolve every specific producer/input gap recorded in `workflow_trace_scientific_setup_revision_001.json` and verify source-relative filenames, fields, keys, and paper-period coverage in the staged cwd.
- After a separate authorized full run, confirm all native intermediate and table/appendix outputs are present and preserve Table 6–7's three-day DGTW method separately from Appendix A's two-day characteristics-adjusted method.

### act_prepare_adjpin_public_data: Acquire and stage the compatible author-hosted legacy yearly PIN parameter file for the source's explicit adjusted-PIN calculation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req_adjpin_data
Evidence: ev_pub_hu, ev_code_wang_adjpin

Preparation / proposed procedure:

1. Acquire the author's legacy `dy_yearly.csv` release for 1993–2012 through its published public release, then import the CSV into Stata and save it in the source working directory as `AdjPIN_Data.dta`, retaining `permno`, `year`, `a`, `d`, `ub`, `us`, `sb`, `ss`, `tn`, `es`, and `eb`.
2. Use the supplied source's explicit formula at lines 2037–2048 and sample restrictions at lines 2050 onward; do not substitute current GPIN/OWR products or request the original author's transformed file. No payload was fetched during this assessment.

Validation to perform later:

- After public acquisition/import, verify the declared column names, unique `permno`/`year` keys, and year coverage; confirm the source formula inputs and 1996–2009 sample with 2000 and 2005 excluded before a future full run.


## Remaining issues and prerequisites

- issue_workflow_closure [unresolved; full_pipeline]: The evidence-linked ordered trace now records the supplied source branches and their order, but mandatory author-prepared inputs, some exact fields/history, and producer contracts remain unresolved. The identifier workbook is not the analysis panel.
- issue_cusip_group_name [preparation; full_pipeline]: The CUSIP partition creates `fundgroup` and immediately retains `firmgroup`; prepare the supported one-line name alignment before running this branch. The change preserves the existing CUSIP assignment and 25-group `xtile` operation.
- issue_cusip_use_replace_option [preparation; full_pipeline]: At lines 303 and 355, the unmodified source uses `use "cusip_working_group1", replace`; Stata 18's official `use` syntax lists `clear` and `nolabel`, not `replace`. The exact same-file `replace`-to-`clear` edits are documented in `act_fix_cusip_use_clear` and preserve the group files and append loops. Under the frozen assessment rule for known same-method edits, this is a preparation correction, not a remaining scientific or access blocker; the source remains unmodified.
- req_crsp_daily [undetermined]: CRSP daily returns file `rfd_crsp_d` used to build earnings-announcement returns; exact source-table fields, dates and compatible prepared export remain to be mapped. The exact row-one field probe succeeded; history and conversion to the author file remain unverified. The same unresolved daily-source contract also covers `CRSP_DAILY_STOCK_FILE_1998-2018`, `CRSP_DAILY_ALL_VARIABLES_1980-2020` and `CRSP_Daily_File`; the supplied Appendix A volatility producer uses trading-day positions 0..254.
- req_crsp_monthly [undetermined]: CRSP monthly file `rfd_crsp_m` used for quarterly returns, market value and holdings-price inputs; exact source-table fields, dates and identifiers remain to be mapped. The exact row-one field probe succeeded; NCUSIP, index fields, history and author-file construction remain unverified. Related prepared inputs include `CRSP_Monthly_File_1980-2018` and `CRSP19942012`; source-required NCUSIP and index fields remain unmapped.
- req_compustat_q [undetermined]: Compustat quarterly fundamentals file `rfd_comp_q` used for earnings-break variables and the main quarterly sample; required history and source-field contract remain to be mapped. The submitted probe requested author-side SIC along with genuine candidate columns; catalog validation rejected the absent SIC alias before reading a row. Underlying field mapping remains unresolved. A follow-up exact one-row probe using only genuine declared fundamentals columns succeeded. SIC is an auxiliary classification field in the author export; no alias is assigned. The Appendix A prepared input `Compustat-Quarterly-Fundamentals_Merged-with-CRSP` also requires a compatible quarterly/CCM merge.
- req_ccm_link [undetermined]: CRSP/Compustat linking file `CRSP_Compustat_Linking_File` used to join quarterly Compustat to PERMNO over link dates. The exact row-one field probe succeeded; links, historical validity and author mapping remain unverified.
- req_ibes_eps [undetermined]: I/B/E/S EPS summary file `IBES_Summary-EPS_1993-2018` used to construct forecast changes. Both exact row-one field probes succeeded; adjustment status, history and mapping to the prepared EPS export remain unknown.
- req_ibes_recommendations [undetermined]: The earnings-break branch consumes IBES_Summary-Recommendations_1993-2018 using CUSIP, STATPERS, MEANREC and MEDREC; no matching recommendation-summary table was identified in the frozen catalog searches.
- req_s34 [undetermined]: Thomson Reuters S34 holdings file `Thomson_S34_MasterFile_1980-201806` used to construct transient institutional ownership changes.
- req_bushee_class [undetermined]: Bushee institutional classification file `Bushee_Inst_Classification_1981-2018` used to identify transient institutions.
- req_generic_missing [undetermined]: Remaining named author-prepared inputs without an executable producer or verified route include `ADR_Firms` and `TRA_LG_TRA_SM_Data`. Source-specific requirements separately track the named closed-call, investor-conference, CRSP, Compustat, Capital IQ, return-benchmark, event-file, Wang, AdjPIN, abnormal-return, and SEC-investigation inputs. Executable intermediates in the supplied source remain workflow stages, not additional raw-data requirements.
- req_ciq_keydev [undetermined]: Capital IQ Key Development data supply Table 9 confounds (IDs 80/81/82/225, 94/213, 26/27, 101/102) and Appendix A flags (IDs 16, 25, 101/102). The local exact key-development candidate was row-one readable, but event definitions, histories, author filters, and mapping remain unresolved.
- req_compustat_annual [undetermined]: Annual Compustat input `Compustat19942012` is used in the real-effects branch. The original exact request containing author-side string `sic` was rejected before row access because that alias is not declared for `COMP.FUNDA`. A separate successful one-row probe used genuine declared annual fundamentals fields including numeric `sich`; this does not make `sich` the author's required string `sic`. The source applies `substr(sic,1,2)` and groups by fiscal year, so the historical/string mapping into the named annual file and paper-period coverage remain unresolved.
- req_crsp_daily_index [undetermined]: The Table 9 branch uses CRSP daily market-return fields `vwretd` (renamed `mktret`) alongside the stock daily series. The registered CRSP daily index table is a candidate, but its merge/series alignment, period and prepared-file construction are unresolved.
- req_crsp_monthly_index [undetermined]: The real-effects branch consumes monthly market-index fields `vwretd`, `vwretx`, `ewretd`, `ewretx` and `sprtrn` in the author-prepared CRSP panel. The registered monthly index table is a candidate; history, alignment and preparation remain unresolved.
- req_comp_industry_classification [undetermined]: The supplied annual branch uses author-side string `sic` to form two-digit SIC-by-year industry groups. The registered Compustat company candidate declares current character `sic`; the separate company-industry candidate declares numeric historical `sich`, `year` and `datadate`. Their roles differ, and no identity, conversion, historical interval or merge into the named annual/quarterly exports is established. Source use is a string `sic` transformed by `substr(sic,1,2)` and grouped by fiscal year; neither current company `sic` nor historical numeric `sich` has been substituted.
- req_dgtw_earnings_returns [undetermined]: The BAR Tables 6–7 code consumes `rdq_dgtw_3d_returns.dta`. Its comment-only Step A specifies Compustat quarterly/CRSP matching, nonmissing RDQ, and stock minus the corresponding Daniel et al. 5x5x5 benchmark return over [-1,+1], with fields PERMNO, CUSIP, RDQ, EABMRET and quarter. The producer and market/benchmark field construction are not executable in the supplied source.
- req_event_file [undetermined]: Table 9 consumes `event_file.dta` with PERMNO and event date for Item 7.01 8-K filings or investor conferences. The source uses events in the five days before the target event and purges the specified [-5,+1] confound window; it does not create this mixed event file. Public filing and vendor pages below are candidates only and do not replace the conference source or establish the author panel.
- req_adjpin_data [public_acquisition_required]: Table 8 merges annual PIN parameters by PERMNO/year and computes `adjPIN` directly from `a`, `d`, `ub`, `us`, `sb`, `ss`, `tn`, `es` and `eb` in ABKP_Code.txt lines 2031–2048. The author's legacy public `dy_yearly.csv` release declares `permno`, `year` and the matching parameter family for 1993–2012; the source uses 1996–2009 and excludes 2000 and 2005. The supported remaining work is public acquisition and CSV-to-Stata staging as `AdjPIN_Data.dta`, retaining the published keys and parameters.
- req_wang2007_data [undetermined]: Table 8 merges `Wang2007_Data` by GVKEY. The frozen author datasheet describes these data as not public and generally author requested; no access request was made and no denial is observed.
- req_bestcalls_data [undetermined]: The Table 6 closed-call branch uses `CLOSED_Data` and `preRFD_closed_confcall_firms.dta`; the author datasheet says Bestcalls pre-Reg-FD calls are no longer actively provided and generally author requested. No request was made and access was not denied.
- req_investor_conference_inputs [undetermined]: The earnings-break branches consume `invconfsample`, `INVCONF_Data`, and `preSBL_InvConf_attend.dta`; the datasheet identifies investor conferences via Eikon event ID 7. The source exports and event mapping are absent. LSEG documentation shows a licensed product family but not this study's event contract.
- req_sec_investigations [undetermined]: Appendix A consumes `sec_investigations` by PERMNO/month. The supplied source describes undisclosed SEC investigation data obtained via FOIA by Blackburne et al.; the datasheet says these are generally author requested. This is distinct from public SEC filings; no request or access denial was observed.
- req_table8_abret_variable [undetermined]: Table 8 consumes `ABRET_Variable` by GVKEY/FYEARQ; the supplied program contains no producer or schema for it. Keep it distinct from Appendix A's separate two-day characteristics-adjusted market-reaction table.
- req_appendix_abnormal_return [undetermined]: Appendix A joins `AppA_AbnormalReturn`. A comment-only specification describes a separate daily t through t+1 raw cumulative return minus size/book-to-market/momentum benchmark using CRSP daily stock security data spanning 2002–2019. The file's executable producer and benchmark-table fields are absent; this is not Table 6/7's three-day DGTW earnings-announcement return.
- soft_winsor2 [preparation_required]: The source invokes `winsor2` repeatedly. The saved Stata 18 environment check did not find it in either checked adopath; the command therefore needs installation or path configuration before a full run. This does not establish system-wide absence, and no install or rerun was attempted.

## Review notes

- Catalog checkpoint follows the immutable early full-source checkpoint and precedes bounded data/software probes.
- Catalog hits and misses are discovery evidence only and do not establish live access, license, history or a compatible author transformation.
- The supplied .txt contains a substantive Stata preparation program covering the coded earnings-break, BAR, real-effects, suspect-trading and Appendix A branches.
- Bounded SAS probe checkpoint records eight exact row-one successes, two Compustat alias-validation rejections before row access, and one S34 timeout at its single 15-second attempt; none establishes historical coverage.
- Exact registered COMP.COMPANY and COMP.CO_INDUSTRY records were separately inspected; their one-row probes used declared columns. Current character SIC and historical numeric SICH are distinct candidates, not substitutes asserted by this assessment.
- Official/author static product pages were checked as bounded route evidence. These sources establish named products or access models, not local field compatibility, entitlement, or study-period coverage; no payloads or author-request contacts were used.
- Exact SEC raw/parsed root stats found only documented directories; the approved file probe performed no listing or recursion and reported coverage false.
- The CUSIP partition variable-name mismatch is a supported one-line proposal only. No original source was edited and no author code was run.
- The CUSIP `fundgroup`/`firmgroup` name alignment is a supported preparation repair that preserves the 25-group operation; it is no longer labeled as a blocking issue.
- Two active `use ..., replace` calls are unsupported in Stata 18; the exact `use ..., clear` fixes are fully specified same-operation preparation, preserving filenames, fields, calculations, and append loops. The source remains unmodified.
- The source-linked workflow trace is now evidence in the proposal and its ordered stage list is made actionable with a cwd configuration and branch-by-branch future run procedure.
- The author-hosted legacy DY yearly parameter table is credited as a compatible public acquisition route; download/import as `AdjPIN_Data.dta` is preparation, and no data payload was requested.
- The Bushee classification page remains a public candidate with an unresolved raw-field mapping; its 13F holdings subscription condition is scoped to the S34 holdings route.
- The saved successful annual Compustat probe used declared `sich`; it does not satisfy the author's string `sic` field or establish the needed historical mapping.
- The `winsor2` environment finding is classified as setup preparation required, without installing or rerunning it.
