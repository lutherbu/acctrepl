# Patch proposal: jar-da2ecdd2accb

Incorrect Inferences when using Residuals as Dependent Variables

DOI: 10.1111/1475-679X.12195

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-provided simulation and four SAS accounting-application workflows, with accruals produced before the three dependent accounting analyses.

Entry points: `Codes/Accounting Settings/accruals_data_code.sas`, `Codes/Accounting Settings/discretionary_book_tax_differences_data_code.sas`, `Codes/Accounting Settings/discretionary_expenditures_data_code.sas`, `Codes/Accounting Settings/investment_data_code.sas`, `Codes/Simulation/Simulation_20170904.m`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 3/12195 - Incorrect-Inferences-when-using-Residuals-as-Dependent-Variables/chm-datasheet-and-code.zip",
      "sha256": "01123f1122f0a552000795d3eadb036040fe0aebe7038c6c3ced01a6d2bb1338"
    },
    {
      "path": "JAR-Volume 56/Issue 3/12195 - Incorrect-Inferences-when-using-Residuals-as-Dependent-Variables/chm-online-appendix.pdf",
      "sha256": "c298b2d2738b835971916a0f1d0f25b25cc2cf6fe1b04d2562d86001a8bdba25"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "4ac5a0cf17404b02bebb3d33fe34579baea88a123fad7c4a4c7a29db8652051b"
}
```

## Proposed actions

### A_DATA_AND_FIELDS: Establish compatible source fields and history for the four distinct author-named Compustat annual extracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ACCRUALS, R_DTAX, R_EXP, R_INV, I_DATA_FIELDS
Evidence: E_DS_SOURCE, E_DS_PERIODS, E_LOCAL_FUNDA, E_FUNDA_CATALOG, E_ACC_FILTER_FIELDS

Preparation / proposed procedure:

1. Confirm whether local COMP.FUNDA can serve as the underlying annual product for these extracts, and whether `sich` is the intended source for the code variable `sic`.
2. Obtain the author field definitions/construction for `seo` and `small_loss` in the accrual extract; retain author-provided values or documented transformation rather than fabricating them.
3. Confirm the required annual history for each 1996–2015 target and prepare the four SAS inputs under the names read by the programs after compatibility is established.
4. Use a compatible local source route if fields, identifiers, dates, and necessary history are confirmed; byte-identical 2016 downloads are not required solely by filename.

Validation to perform later:

- Use bounded readable-column probes before a future authorized run; then verify required dates/joins and the resulting sample against author specifications during an authorized execution.

### A_PATHS_ORDER: Configure all SAS input, library, macro include and export paths consistently and preserve the proven producer-consumer order.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_PATHS, SAS_WT
Evidence: E_ACC_LIBPATH, E_DTAX_LIBPATH, E_EXP_LIBPATH, E_INV_LIBPATH, E_ACC_INCLUDE, E_DTAX_INCLUDE, E_EXP_INCLUDE, E_INV_INCLUDE, E_ACC_PRODUCER, E_DTAX_ACC_JOIN, E_EXP_ACC_JOIN, E_INV_ACC_JOIN

Preparation / proposed procedure:

1. Map each author-named Compustat extract to its `ddrive` SAS input library.
2. Set `ddrive2` to the same writable local library in all four programs so the accrual program can create `disc_accruals` and the three dependent programs can read it.
3. Point all four WT macro include calls to `Codes/Accounting Settings/winsorization_macro_code.sas`, preserving the existing `%wt` arguments.
4. Configure each DTA export destination in a writable output directory.
5. Run accruals first; then run DTAX, discretionary expenditures, and investment, each after the common `disc_accruals` producer is available.

Validation to perform later:

- After a future authorized execution, confirm the SAS intermediate is created in the shared library before the three consumers read it and that all four DTA exports complete.

### A_SAS_RUNTIME_AND_EXPORT: Resolve SAS runtime initialization and verify the required SAS/ACCESS export capability before running any author program.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SAS, SAS_ACCESS_PCFILES
Evidence: E_ENV_SAS, E_SAS_ACCESS_LICENSE, E_SAS_DTA_FORMAT, E_SAS_EXPORT_ACC

Preparation / proposed procedure:

1. Diagnose the TKELS extension startup failure on the listed SAS 9.4 TS1M8 installation; do not infer missing licensing from the startup probe.
2. Once SAS initializes, verify the installed SAS/ACCESS Interface for PC Files component and its supported DTA export identifier under the local runtime.

Validation to perform later:

- Use a future bounded SAS version/component query; after authorization, validate the author PROC EXPORT DBMS=STATA call against the resulting `.dta` output.

### A_MATLAB_RUNTIME: Confirm the MATLAB executable/version and the required regression functions and toolbox.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: MATLAB, MATLAB_STATS
Evidence: E_MATLAB_PROBE, E_MATLAB_FUNCS, E_MATHWORKS_TOOLBOX, E_MATHWORKS_REGRESS, E_MATHWORKS_REGSTATS

Preparation / proposed procedure:

1. Confirm the authorized MATLAB executable path and runtime version; the PATH query alone does not establish that MATLAB is absent or unlicensed.
2. Verify `regress` and `regstats` resolve from MATLAB Statistics and Machine Learning Toolbox before any simulation run.

Validation to perform later:

- Use read-only `which regress` and `which regstats` checks under the selected MATLAB runtime; no simulation is run in this assessment.

### A_SIM_A2: Create a separate Figure A2 MATLAB variant using the documented positive-correlation parameter setting; retain the supplied zero-correlation baseline unchanged.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SIM_SCENARIO
Evidence: E_SIM_SCENARIO, E_SIM_FIG_A2

**Proposed edit:** `Codes/Simulation/Simulation_20170904.m:7–7`
Source SHA-256: `bb8ca4715f7d8fb94a43b27306aeb9706c28312f73495ed72c391271203530de`

The online appendix specifies R13 squared = 0.20 for Figure A2.

Current text:
```
R13_sqr = 0;   
```

Proposed replacement:
```
R13_sqr = 0.20;
```

**Proposed edit:** `Codes/Simulation/Simulation_20170904.m:11–11`
Source SHA-256: `bb8ca4715f7d8fb94a43b27306aeb9706c28312f73495ed72c391271203530de`

The zero override forces the correlation to zero; commenting it leaves the existing positive square-root n4 for the documented all-positive A2 case.

Current text:
```
n4 = 0;
```

Proposed replacement:
```
% n4 = 0;
```

Preparation / proposed procedure:

1. Apply these edits only to a separate A2-specific copy/variant; do not change the baseline or combine this variant with A3 settings.

Validation to perform later:

- In a future authorized run, inspect the stored corx1x2, corx1x3 and corx2x3 arrays and verify all three signs are positive and the x1/x3 squared correlation is 0.20.

### A_SIM_A3: Create a separate Figure A3 MATLAB variant using the documented negative x1/x3 correlation; retain the supplied zero-correlation baseline unchanged.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SIM_SCENARIO
Evidence: E_SIM_SCENARIO, E_SIM_FIG_A3

**Proposed edit:** `Codes/Simulation/Simulation_20170904.m:7–7`
Source SHA-256: `bb8ca4715f7d8fb94a43b27306aeb9706c28312f73495ed72c391271203530de`

The online appendix specifies R13 squared = 0.20 for Figure A3.

Current text:
```
R13_sqr = 0;   
```

Proposed replacement:
```
R13_sqr = 0.20;
```

**Proposed edit:** `Codes/Simulation/Simulation_20170904.m:10–10`
Source SHA-256: `bb8ca4715f7d8fb94a43b27306aeb9706c28312f73495ed72c391271203530de`

The appendix specifies a negative x1/x3 correlation for Figure A3; use the negative sign of the supplied n4 square root.

Current text:
```
n4 = sqrt(n4_sqr);
```

Proposed replacement:
```
n4 = -sqrt(n4_sqr);
```

**Proposed edit:** `Codes/Simulation/Simulation_20170904.m:11–11`
Source SHA-256: `bb8ca4715f7d8fb94a43b27306aeb9706c28312f73495ed72c391271203530de`

The zero override forces the correlation to zero and would supersede the documented negative n4 setting.

Current text:
```
n4 = 0;
```

Proposed replacement:
```
% n4 = 0;
```

Preparation / proposed procedure:

1. Apply these edits only to an A3-specific copy/variant; keep the baseline and A2 variant separate.
2. Retain the existing positive n1/n3 constructions; do not change the estimator or other parameters.

Validation to perform later:

- In a future authorized run, inspect corx1x2, corx1x3 and corx2x3 over the full grid; verify x1/x3 is negative with squared magnitude 0.20 and the other pairwise correlations are positive.

### A_SIM_REPEATABILITY: Record random-stream behavior or an accepted tolerance when comparing exact simulation values; this is future output QA, not a prerequisite to attempt the supplied script.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_SIM_RANDOM
Evidence: E_SIM_RANDOM, E_SIM_RESULTS

Preparation / proposed procedure:

1. Before a future authorized run, record the MATLAB runtime version and default random-stream behavior.
2. For exact numerical comparison, use an author-specified seed or tolerance; do not invent a seed in this assessment.

Validation to perform later:

- Check that the 20 repetitions and reported mean arrays are comparable under the recorded random-stream/tolerance contract.

### A_SIM_OUTPUT: Clarify the documented figure-output and packaged Heat Map workbook contract; the supplied code only leaves simulation arrays in the MATLAB workspace.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SIM_OUTPUT, I_HEATMAP_ROLE
Evidence: E_SIM_RESULTS, E_SIM_FIG_A1, E_SIM_FIG_A2, E_SIM_FIG_A3, E_HEATMAPS, E_WORKFLOW_SCAN

Preparation / proposed procedure:

1. Identify the output/plotting steps that turn the computed arrays into Figures A1–A3.
2. Confirm whether the packaged Heat Map workbooks are completed results, plot inputs/templates, or unrelated supporting material.
3. If manual plotting or spreadsheet editing is required, document the exact application and procedure before adding it to the run workflow.

Validation to perform later:

- After the missing output instructions are supplied and execution is authorized, compare generated figure files or matrices to the named appendix outputs.


## Remaining issues and prerequisites

- I_PATHS [preparation; full_pipeline]: The four SAS programs hard-code [redacted-path-bdc8701c251b] and [redacted-path-c84ddf6964b0] input, output and macro paths. The accrual producer writes ddrive2.disc_accruals under [redacted-path-f60c30d6fabc], while the three downstream programs point ddrive2 at [redacted-path-ef97545ba2f3]; for a single sequential local run, all consumers must read the same generated table from the producer’s configured output library. The packaged WT macro must also replace each external include path.
- I_DATA_FIELDS [unresolved; full_pipeline]: The local COMP.FUNDA candidate has `sich` rather than the exact `sic` used by all four programs; the accrual program additionally tests `seo` and `small_loss` for missing values without constructing them, and these exact columns are absent from the candidate. Confirm the author extract fields and whether `sich` is the intended source for `sic`; do not guess a mapping or manufacture the two additional fields. The author-named historical extracts could have a different schema.
- I_SIM_SCENARIO [preparation; full_pipeline]: The supplied MATLAB settings force n4=0, so the script does not reach the documented nonzero-correlation cases. The appendix specifies Figure A2 at R13^2=0.20 with all pairwise correlations positive, and Figure A3 at R13^2=0.20 with x1/x3 negative and the other correlations positive. Configure these as separate variants while preserving the current zero-correlation baseline; the target parameters are documented and do not require author clarification.
- I_SIM_RANDOM [preparation; full_pipeline]: The simulation uses randn for noise and generated regressors but has no explicit rng seed. The code remains attemptable; for exact numerical comparison, record the runtime default/seed behavior or use a documented tolerance. The supplied procedure gives no seed.
- I_SIM_OUTPUT [unresolved; full_pipeline]: The MATLAB script computes workspace arrays and mean matrices but contains no plot/save/export routine in the supplied 97 lines. The online appendix identifies simulation Figures A1–A3. Request the intended plotting/export steps and map the arrays to the reported figure outputs.
- I_HEATMAP_ROLE [unresolved; full_pipeline]: Three packaged Heat Map workbooks contain bounded-preview triangular matrices labeled by fyear with numeric entries, but no supplied code reads them and the datasheet/appendix do not describe their production or use. Clarify whether these are final result artifacts, plot inputs/templates, or unrelated support files; do not treat them as mandatory raw inputs without that contract.
- R_ACCRUALS [undetermined]: Author-named COMPUSTAT–Capital IQ North America Fundamentals Annual extract accruals_annual_09_2016.sas7bdat. The SAS code consumes gvkey, datadate, fyear, sic, at, seq, rect, revt, che, dlc, dltt, ni, csho, prcc_f, ib, ibc, oancf, ppent, au, seo and small_loss. Its 1996–2015 target rows use a preceding annual observation through a 350–380-day join; exact source coverage and the seo/small_loss fields remain unverified. A local COMP.FUNDA candidate is readable but does not establish the author field contract or full coverage; see I_DATA_FIELDS.
- R_DTAX [undetermined]: Author-named COMPUSTAT–Capital IQ North America Fundamentals Annual extract dtax_11_2016.sas7bdat. SAS consumes gvkey, datadate, fyear, sic, at, tlcf, xrd, pifo, txfo, intan, mii, esub, txs, txdi, txfed, txt, pi, csho, prcc_f, dltt, dlc and capx, with prior-year construction for permdiff_lag. The code also consumes the generated accrual residual from R_ACCRUALS. A local COMP.FUNDA candidate is readable but does not establish the author field contract or full coverage; see I_DATA_FIELDS.
- R_EXP [undetermined]: Author-named COMPUSTAT–Capital IQ North America Fundamentals Annual extract disc_exp_11_2016.sas7bdat. SAS consumes gvkey, datadate, fyear, sic, at, seq, rect, revt, che, dlc, dltt, ni, csho, prcc_f, lt, act, lct, re, tlcf, xrd, xad, ib, oancf, au and xsga; it also joins the generated accrual residual from R_ACCRUALS. A prior annual observation is required for the 350–380-day lag join. A local COMP.FUNDA candidate is readable but does not establish the author field contract or full coverage; see I_DATA_FIELDS.
- R_INV [undetermined]: Author-named COMPUSTAT–Capital IQ North America Fundamentals Annual extract invest_11_2016.sas7bdat. SAS consumes gvkey, datadate, fyear, sic, at, revt, che, ppent, dlc, dltt, ib, csho, prcc_f, xrd, capx, aqc and sppe, with one- and two-year annual joins; it also joins a prior-year residual produced by R_ACCRUALS. A local COMP.FUNDA candidate is readable but does not establish the author field contract or full coverage; see I_DATA_FIELDS.
- SAS [preparation_required]: Host inventory lists SAS 9.4 TS1M8, but the frozen bounded runtime probe failed before confirming a usable version because SAS could not initialize TKELS. Diagnose runtime initialization first; this does not establish a license problem. Author release is unspecified.
- SAS_WT [preparation_required]: Packaged WT macro source matches the four calls, but each call has an author-machine Windows include path; configure each include to the packaged source. No macro execution was done.
- SAS_ACCESS_PCFILES [unverified]: All four scripts export Stata .dta files with PROC EXPORT DBMS=STATA. Official SAS docs identify DTA as Stata output and say the source availability depends on the site's SAS/ACCESS Interface for PC Files license. Local component/entitlement was not checked because SAS could not initialize; no license absence is inferred.
- MATLAB [unverified]: Author requires MATLAB. Bounded command -v matlab found no executable on PATH; no installation location, runtime version or entitlement was established.
- MATLAB_STATS [unverified]: The simulation calls MATLAB regress and regstats, which MathWorks documents in its Statistics and Machine Learning Toolbox materials. Local function/toolbox availability could not be checked without a MATLAB executable on PATH.

## Review notes

- Initial partial checkpoint saved after reading the datasheet, simulation procedure and all four accounting SAS programs, winsorization macro and MATLAB simulation code; local resource/catalog checks and packaged workbook probes are still pending.
- The simulation script generates regressors/noise from specified parameters and random draws; no empirical dataset is identified as its input. The empirical raw-source requirements are the four annual Compustat extracts consumed by the SAS programs.
- The supplied sample-identifiers workbook and Heat Map workbooks are not yet classified; inspect their bounded metadata and relation to the documented workflows before finalizing.
- The three downstream SAS accounting scripts consume the disc_accruals intermediate generated by the accruals script; the target order is not a flat alphabetical sequence.
- Expanded checkpoint: local COMP.FUNDA is row-limit-1 readable and contains common Compustat annual fields, but exact sic is instead sich, and the local catalog lacks seo and small_loss read by accruals. The author-named dated extracts are not packaged; identifiers workbook is not analysis data.
- Expanded checkpoint: SAS exports Stata .dta products, requiring SAS/ACCESS Interface for PC Files under the official PROC EXPORT documentation; local component/license remains unchecked. Packaged WT macro matches calls but paths need configuration.
- Expanded checkpoint: MATLAB executable is not on PATH; MATLAB regress/regstats and toolbox availability are unverified. Simulation has no empirical file input.
- Full pipeline is the sole supported scope: the SAS code creates application variables and runs the two-stage/one-step regressions from raw author-named inputs. The MATLAB program is a synthetic simulation and has no empirical dataset input. No hypothetical analysis-only scope is supported because no compatible author-prepared analysis dataset or consumer program is supplied.
- Order and handoff: accruals writes ddrive2.disc_accruals; DTAX and discretionary expenditures join it on gvkey/datadate; investment joins a prior-date residual. The accrual ddrive2 path is [redacted-path-c84ddf6964b0] while the three consumers point to [redacted-path-bdc8701c251b], so local path configuration must unify them.
- SAS output contracts: each program creates WORK.RESID and WORK.RESID2 with residual r and predicted fv, compares two-step and one-step PROC REG models, merges r into DATA8, then exports a named .dta. The export is produced but no supplied Stata consumer exists; the datasheet names SAS for the application regressions.
- The sample-identifiers workbook is an optional reference with datadate/cusip identifiers, not an analysis input; it is not read by code and no CUSIP-to-GVKEY crosswalk/manual GUI stage is provided. Do not make it a mandatory raw input.
- Heat Map workbooks are bounded-preview triangular matrices; code does not read them. Their report/output or manual plotting role is unresolved, so spreadsheet software is not added as a confirmed runtime requirement.
- No author URL for data or code acquisition appears in the supplied datasheet/code. No public Compustat acquisition route or missing entitlement is inferred.
- No author programs, regressions, or simulations were executed; no source files were edited; execution_verified remains false.
- Investment-history QA is derivable from source: the investment script merges a residual at a preceding date and drops missing residuals; the accrual producer is restricted to fyear 1996–2015. Future execution should record the retained investment date range, but this is not an extra author-clarification gate.
- Investment code references `constant` only when constructing fy_constant interactions that are not included in the displayed PROC REG model. Under a local source without `constant`, this is an output-schema QA note; no author clarification or code repair is required to attempt the supplied regression.
- The MATLAB script has no explicit rng seed. This limits exact stochastic-output comparison unless a runtime default or tolerance is recorded; it does not prevent attempting the supplied simulation.
- Appendix settings are known: Figure A2 uses R13^2=0.20 with all pairwise correlations positive; Figure A3 uses R13^2=0.20 and a negative x1/x3 correlation with the others positive. The supplied script overrides n4 to zero. Two separate, supported scenario-specific parameter variants are proposed; no author clarification is required for these documented settings.
- The missing RNG seed is a repeatability/tolerance issue only; it does not prevent attempting the MATLAB simulation. The figure export and Heat Map workbook role remain unresolved because no supplied code maps workspace arrays to the published figures.
