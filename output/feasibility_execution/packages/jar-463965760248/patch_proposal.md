# Patch proposal: jar-463965760248

Credit Default Swaps and Managers' Voluntary Disclosure

DOI: 10.1111/1475-679X.12194

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full workflow spanning SAS construction, Stata PSM/XPORT export, SAS completion of PSM/change data, and final Stata analyses for Tables 2–7.

Entry points: `SAS_Codes_Final_Ver_2017_11.sas`, `STATA_Codes_Final_Tests_Ver_2017_11.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 3/12194 - Credit-Default-Swaps-and-Managers-Voluntary-Disclosure/ksvw-datasheet-and-code.zip",
      "sha256": "36079c9070b7a504fb051bb5007aa2dfe215a2d40e181a98442f3d495c27eb60"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "8a7def4b37574433f68b9f8828ebb61db0e6f3b4fe8bd433ab8d4ae739b43b20"
}
```

## Proposed actions

### A_CUSTOM_INPUTS: Resolve the remaining author-specific input contracts and locations before full-pipeline execution.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R002, R008, R011, R012, R013, R014, R015, R016, R017, R018, R019, R020, R021, R022, R023, R024, I001
Evidence: E001, E002, E003, E005, E017, E018, E019, E020, E021, E022, E023, E026, E028, E029, E030, E031, E041, E054

Preparation / proposed procedure:

1. For R002 and R008, confirm the WRDS COMP.FUNDA_FNCD and TFN.S34 products, expected fields, and historical coverage. The S34 one-row probe timed out; treat the source as unverified, not absent.
2. Locate or obtain the exact prepared files consumed by the code: raw.Cibeslnk_xpf_2015_01; pay1.rogers_mgmt_forecast; ibes.rogers_forecast_issuance_v_15_11; cds.cds01_14; seo.raw_ver_2013_08; cds.Sdc_equity_issue90to15sep; cds.aud_1_9_ver_2015_11; cds.tmp_1_7_ver_2015_11_21; cds.loans_data; cds.bank_data_may25; acq.tmp_c_4_1_ver_2016_12; cds.Data_blockholding_ver_2017_03_27; cds.tmr_0_4_ver_2016_01_15; and cds.ratings_jan2016.
3. For each prepared file, preserve the author-provided version and record the fields, key identifiers, types, date bounds, construction steps, and the two-year/rolling-window history required by its linked requirement. In particular, the audit and tmp_1_7 snapshot saves are commented out while the later reads are active; do not assume their WORK predecessors are equivalent.
4. Treat the catalog matches as discovery evidence only. Do not infer a missing license from catalog absence, and do not rebuild these author-prepared datasets independently.

Validation to perform later:

- After an exact candidate file is placed at its mapped path, perform a format-aware bounded readability/field check (SAS reads limited to one row) and verify key/type/date coverage against each linked requirement. Confirm construction provenance for author-prepared snapshots before marking routes compatible.

### A_PROJECT_PATHS: Map placeholder libraries and all shared handoff files to a single project data/output root.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I002
Evidence: E005, E032, E033, E034, E035, E036, E037, E038, E039

Preparation / proposed procedure:

1. Choose one writable project data root and its input/output subdirectories; populate inputs separately from generated handoff files.
2. Map SAS librefs pay1, fc, ibes, cds, raw, SEO, and ACQ from the literal placeholder directories at lines 5–11 to the corresponding populated input directories.
3. Map SAS exports data_1 and data_2, the psm_1st.xpt XPORT handoff, and data_3 and data_4, plus the Stata working directory and all four use paths, to matching locations under that root. Preserve the same filenames on every producer/consumer side.
4. Leave WRDS librefs as remote sources when authorized; do not replace local author-prepared input routes with unrelated catalog candidates.

Validation to perform later:

- Check each SAS OUTFILE/libname XPORT path against its consuming Stata use/export path, and check all seven SAS placeholder librefs resolve to the intended input directories before execution.

### A_SAS_ENVIRONMENT: Resolve SAS startup and confirm SAS/CONNECT, WRDS and Stata-export capability in the assigned environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW001, SW003, SW005, I003
Evidence: E024, E044, E057, E068, E069

Preparation / proposed procedure:

1. Use the site-supported SAS 9.4 installation/configuration to identify and resolve the observed TKELS initialization failure. No runtime or license absence is inferred from the failed probe.
2. Once SAS starts normally, confirm SAS/CONNECT can establish the authorized WRDS session used by SIGNON/RSUBMIT; credentials and service access remain user/site supplied.
3. Confirm the local SAS host/version has SAS/ACCESS Interface to PC Files support for DTA export. SAS documentation lists DTA as Stata output and recognizes a supported filename extension when DBMS is omitted; this package’s local component/platform capability is still unverified.
4. Do not change PROC EXPORT to add a DBMS option unless the actual installed SAS behavior or a later authorized run shows it is needed.

Validation to perform later:

- After the startup cause is resolved, verify one normal supported SAS launch, authorized SAS/CONNECT/WRDS sign-on, and the available DTA export capability using a disposable one-row check. Then confirm the actual data_1 through data_4 handoffs are readable as Stata .dta files during an authorized run.

### A_STATA_PSMATCH2: Install the missing Stata psmatch2 command from its documented SSC distribution before the PSM stage.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW004
Evidence: E045, E058

Preparation / proposed procedure:

1. When software installation is authorized, run `ssc install psmatch2` in the Stata 18 environment.

Validation to perform later:

- Run `which psmatch2` and verify Stata resolves the installed ado command before the PSM stage; retain the installation log/version.

### A_MINIMAL_SOURCE_REPAIRS: Propose the two localized SAS syntax/control-boundary repairs supported by source inspection.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I006, I007
Evidence: E024, E025, E033, E057

**Proposed edit:** `SAS_Codes_Final_Ver_2017_11.sas:1555–1555`
Source SHA-256: `1f4079c5757de48a551c391a3ed2c19aaf28edf43dff4f1c27f9b6a55f6334cb`

Close the a1 remote query block before the next RSUBMIT starts, so the a1/z-score producer boundary is well-formed.

Current text:
```

```

Proposed replacement:
```
endrsubmit;
```

**Proposed edit:** `SAS_Codes_Final_Ver_2017_11.sas:2165–2165`
Source SHA-256: `1f4079c5757de48a551c391a3ed2c19aaf28edf43dff4f1c27f9b6a55f6334cb`

Remove the extra out= token from DATA=; the preceding step creates tmr_1_0_1.

Current text:
```
proc sort data=out=tmr_1_0_1 out=tmr_1_1  nodupkey;
```

Proposed replacement:
```
proc sort data=tmr_1_0_1 out=tmr_1_1  nodupkey;
```

Validation to perform later:

- After the source edits are authorized, verify the remote block closes before the next RSUBMIT and that PROC SORT reads the tmr_1_0_1 producer. During an authorized staged run, confirm the z-score download and data_2 export complete without SAS syntax errors.

### A_STAGED_RUN_AND_CAPTURE: Run the author workflow in its supplied SAS → Stata → SAS → Stata order and capture durable logs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I004, I008
Evidence: E032, E033, E034, E035, E036, E037, E038, E039, E068, E069

Preparation / proposed procedure:

1. After mandatory inputs, paths, SAS/CONNECT, PC Files export support, psmatch2, and the two SAS source repairs are ready, start the SAS session and run the SAS preparation/construction code through the data_2 export at line 2173. Pause before the XPORT read at line 2178.
2. In Stata, run the supplied first block through line 130: it consumes data_1/data_2, runs Tables 2–5 and the first PSM stage, then writes psm_1st.xpt. Capture the Stata log/console output for this stage in the configured Results directory.
3. Resume the same SAS session at the PSM handoff beginning line 2176 so its WORK intermediates remain available. SAS reads IN.PSM_1ST from the XPORT file and exports data_3 and data_4. Keep the SAS log for this stage.
4. Run the final Stata block at lines 132–144 to consume data_3/data_4 and produce the Table 6/7 results. Capture a durable Stata log/console record in the configured Results directory. Preserve the supplied samples, variables, estimators, and regression statements.

Validation to perform later:

- Confirm the files appear in producer order and formats: data_1/data_2 are Stata datasets; psm_1st.xpt is XPORT with dataset PSM_1ST and expected renamed variables; data_3/data_4 reopen in Stata. Inspect SAS/Stata logs for stage completion and retain table output. No successful execution is claimed by this assessment.

### A_ZSCORE_CLARIFICATION: Resolve the z-score numerator and field handoff with the authors before changing the calculation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I009
Evidence: E025, E061, E062

Preparation / proposed procedure:

1. Confirm whether the intended z-score numerator is NI+XINT+TXT or OIBDP-DP, and whether the remote z_score_ver_2016_01_02 producer should carry OIBDP and DP into the later local calculation.
2. After author clarification, make only the corresponding formula/field-contract correction at the identified producer and consumer; do not infer a preferred formula from the comments or silently preserve the zero-filled overwrite.

Validation to perform later:

- Before analysis, verify that the selected producer supplies every field referenced by the final expression and that the resulting z_score is computed from the author-confirmed numerator; compare intermediate schema and a bounded row check.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: Mandatory author-prepared/custom files and dated checkpoints are consumed but absent from this release; compatible routes and exact field/history contracts remain unverified. Catalog misses do not prove absent access or licenses.
- I002 [preparation; full_pipeline]: SAS librefs are literal directory placeholders and SAS/Stata handoff paths are Windows C: paths; map these known inputs/outputs to one selected project root before execution.
- I003 [unresolved; full_pipeline]: The SAS startup probe fails during TKELS initialization; SAS runtime, SAS/CONNECT, and WRDS sign-on are unverified. No license absence is inferred.
- I004 [preparation; full_pipeline]: The supplied workflow is interleaved: SAS creates data_1/data_2; Stata consumes them and exports psm_1st.xpt; SAS consumes that XPORT and produces data_3/data_4; final Stata code consumes those files.
- I006 [preparation; full_pipeline]: SAS line 2165 says proc sort data=out=tmr_1_0_1; the extra out= makes DATA= malformed. The tmr_1_0_1 producer is immediately above.
- I007 [preparation; full_pipeline]: SAS lines 1540–1556 open a remote block, then open a second RSUBMIT before closing the first; the a1/z-score producer block needs a matching ENDRSUBMIT boundary before line 1556.
- I008 [preparation; full_pipeline]: Stata labels Tables 2–7 but has no explicit result export target; use ordinary durable batch/console log capture for each staged Stata segment.
- I009 [unresolved; full_pipeline]: The remote z_score formula uses NI+XINT+TXT and keeps those fields but not OIBDP/DP; local code zero-fills OIBDP/DP and overwrites z_score with (OIBDP-DP)/AT. Confirm the intended formula and field contract before changing it.
- R002 [undetermined]: Compustat FUNDA_FNCD companion fields in the SAS keep list.
- R008 [undetermined]: Thomson Reuters 13F S34 holdings used for beginning-of-year institutional ownership.
- R011 [undetermined]: Author IBES GVKEY/ticker link file, read twice by the SAS source.
- R012 [undetermined]: Prepared First Call management forecast issuance data before 2011.
- R013 [undetermined]: Prepared IBES management forecast issuance data for 2011–2014.
- R014 [undetermined]: Markit CDS contracts used to derive first trading date, CDS status, and liquidity.
- R015 [undetermined]: Earlier SDC Global Issues input in the equity-issuance union.
- R016 [undetermined]: Later SDC equity-issue input in the same union.
- R017 [undetermined]: Explicit aud_1_9_ver_2015_11 checkpoint actively reloaded after its save is commented out.
- R018 [undetermined]: Explicit tmp_1_7_ver_2015_11_21 checkpoint actively reloaded after its save is commented out.
- R019 [undetermined]: Prepared DealScan facility/loan dataset used to aggregate lender allocations and covenant counts.
- R020 [undetermined]: Additional bank-level CDS protection and bank-assets input.
- R021 [undetermined]: Corporate Library board independence/blockholding input.
- R022 [undetermined]: Legacy WRDS blockholder input for pre-2002 ownership.
- R023 [undetermined]: Author-prepared TMR PSM baseline file required before the rating and matching-variable joins.
- R024 [undetermined]: Historical S&P/Moody’s credit ratings used for PSM rated/investment-grade variables.
- SW001 [unverified]: SAS 9.4 executable is present, but same-run bounded startup failed during TKELS initialization; runtime and license status remain unverified.
- SW003 [unverified]: The program relies on SIGNON/RSUBMIT for remote WRDS extraction; runtime and connection capability are unverified.
- SW004 [preparation_required]: The exact Stata command psmatch2 is not found in checked adopaths; a repository installation route is documented and no installation was performed.
- SW005 [unverified]: SAS PROC EXPORT targets Stata .dta files by extension, but local DTA export support and licensed component availability on the assigned SAS host have not been verified.

## Review notes

- Evidence/probe checkpoint saved; no author program was executed.
- The identifier file is not analysis data and supports no analysis_only scope.
- Stata XPORT output and SAS XPORT input use the same psm_1st.xpt path with corresponding truncated-name mappings; execution must be staged.
- A separate z-score field/formula ambiguity is retained for author clarification: the remote query keeps NI/XINT/TXT but not OIBDP/DP, while the local step zero-fills OIBDP/DP and overwrites z_score with the EBIT expression. No formula edit is proposed.
- Native, self-written Stata 18 empty-session checks show set memory 4096M is ignored with return code 0 and gen u=uniform()/sort u both return 0 on zero observations. No clean-session repair is warranted; the initial random variable is discarded by the first use, then recreated in the PSM stage.
- D0051 was initially suspected to be a SAS7BDAT/XPORT mismatch from the parser target; direct source review confirms the actual handoff is Stata sasxport export to psm_1st.xpt and SAS XPORT libname/read of IN.PSM_1ST. No mismatch is asserted.
- The SAS export filenames end in .dta but PROC EXPORT omits DBMS=. Official SAS documentation permits DBMS omission when a recognized extension identifies the format and lists DTA as the Stata format; no DBMS source edit is proposed. Local SAS/ACCESS PC Files license/platform support remains unverified and needs future output-format QA.
