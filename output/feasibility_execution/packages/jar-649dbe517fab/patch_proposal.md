# Patch proposal: jar-649dbe517fab

Investment Dynamics and Earnings-Return Properties: A Structural Approach

DOI: 10.1111/1475-679X.12253

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | undetermined |

### full_pipeline

Complete author-documented workflow: five MATLAB model simulation variants plus base comparative statics; all four SMM estimation branches; Stata model, Compustat, and Figure 11 companion analyses. It includes the documented manual moments handoff.

Entry points: `Code/00-Master.do`, `Code/01-Models.do`, `Code/02-Compustat.do`, `Code/03-Comparison_Graph.do`, `Code/Models/01-Basic model/Simulation/Code/Simulation.m`, `Code/Models/01-Basic model/Simulation/Code/Predictions.m`, `Code/Models/02-Accrual model/Simulation/Code/Simulation_WorkingCapital.m`, `Code/Models/03-Model 1 (no delay, no adjustment cost)/Simulation/Code/Simulation_NoDelayNoCost.m`, `Code/Models/04-Model 2 (no adjustment cost)/Simulation/Code/Simulation_NoCost.m`, `Code/Models/05-Model 3 (no delay)/Simulation/Code/Simulation_NoDelay.m`, `Code/Models/01-Basic model/Estimation/Code/SMM.m`, `Code/Models/03-Model 1 (no delay, no adjustment cost)/Estimation/Code/SMM_NoDelayNoCost.m`, `Code/Models/04-Model 2 (no adjustment cost)/Estimation/Code/SMM_NoCost.m`, `Code/Models/05-Model 3 (no delay)/Estimation/Code/SMM_NoDelay.m`

Dependency closure: established for this scope.

### analysis_only

Prepared-input model analysis: Code/01-Models.do plus all four supplied SMM branches using the six shipped positional model/statics inputs and each branch’s packaged six-moment vector. Excludes the raw Compustat/CRSP/I/B/E/S construction and tables/figures produced by Code/02-Compustat.do and Code/03-Comparison_Graph.do.

Entry points: `Code/01-Models.do`, `Code/Models/01-Basic model/Estimation/Code/SMM.m`, `Code/Models/03-Model 1 (no delay, no adjustment cost)/Estimation/Code/SMM_NoDelayNoCost.m`, `Code/Models/04-Model 2 (no adjustment cost)/Estimation/Code/SMM_NoCost.m`, `Code/Models/05-Model 3 (no delay)/Estimation/Code/SMM_NoDelay.m`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 3/12253 - Investment-Dynamics-and-Earnings-Return-Properties-A-Structural-Approach/bwdatasheetcodedata.zip",
      "sha256": "7fe1e5e6f053f1c3428b4b6a89005727145d071eb30d2135c5cc9dac70b3fc18"
    },
    {
      "path": "JAR-Volume 57/Issue 3/12253 - Investment-Dynamics-and-Earnings-Return-Properties-A-Structural-Approach/bw-online-appendix.pdf",
      "sha256": "96b1299a6b307baf8ccfd604e5f4f80680f20fdb607f1555a1ddf1ac5247d688"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "1027e1ee4c3dab4ac0bfade936223dcb92c632cf28a1a3502fc0202bbe78e39c"
}
```

## Proposed actions

### ACT001: Create one writable staged working copy that preserves the package hierarchy, set the Stata project-root macro to that copy, and run each MATLAB variant from its own code folder so relative input/output and helper resolution stay within that variant.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: ISS001
Evidence: EV001, EV003, EV004, EV006, EV076, EV077, EV078, EV079, EV080, EV081, EV082

Preparation / proposed procedure:

1. Stage the full extracted package beneath a writable host-visible path while preserving Code, Data, and all model-variant folders.
2. Set the `global directory` value in Code/00-Master.do to the staged package root for the full workflow; for analysis-only, configure the equivalent root expected by Code/01-Models.do. Keep all original subdirectories intact.
3. Before running MATLAB, set the current directory separately to each exact Simulation/Code folder for the five simulation variants and the base Predictions entry point; set it separately to each of the four Estimation/Code folders for SMM.
4. Keep variant helper paths isolated; do not add the entire Models tree to the MATLAB path because same-basename helpers vary by model. Confirm Data/Output and variant Simulation/Data and Estimation/Data output folders are writable.

Validation to perform later:

- Use a bounded source-path audit to confirm every `cd`, `csvread`, `csvwrite`, `use`, and `save` resolves under the staged root and that model variants do not share writable output folders.
- After an authorized future run, inspect expected files at the six Stata-consumed Simulation/Data locations and four variant Estimation/Data locations.

### ACT002: Verify an installed, licensed MATLAB runtime with the required Global Optimization, Parallel Computing, and Statistics and Machine Learning toolboxes. PATH lookup alone did not establish their absence.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: conditional.
Addresses: SW004, SW005, SW006, SW007, ISS003
Evidence: EV025, EV026, EV027, EV028, EV029, EV030, EV043, EV065, EV066, EV067, EV068

Preparation / proposed procedure:

1. Check the intended MATLAB installation and license with its owner or administrator; record MATLAB version and availability of the three required toolboxes.
2. If a required product is absent, arrange a licensed local installation or identify a supported licensed host before attempting the author branches.
3. Confirm local parallel-pool capability for the supplied `gcp`, `parpool`, and `parfor` calls; the author’s hardware recommendation is performance context, not evidence that a remote cluster is mandatory.

Validation to perform later:

- In the selected MATLAB runtime, verify `ga`/`gaoptimset`, `parpool`/`gcp`, `normcdf`, `chi2cdf`, and `regress` resolve from licensed products before an authorized model run.

### ACT003: Resolve the eight omitted author-format empirical inputs and compatibility of available licensed source products. The local catalog and row-limit-one probes show candidates only; they do not establish current entitlement, author-equivalent coverage, historical selection, or the normalized .dta schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ001, REQ002, REQ003, REQ004, REQ005, REQ006, REQ007, REQ008, ISS002
Evidence: EV002, EV010, EV011, EV016, EV017, EV018, EV019, EV020, EV021, EV041, EV045, EV046, EV047, EV048, EV049, EV050, EV051, EV052, EV053, EV054, EV055, EV056, EV057

Preparation / proposed procedure:

1. Confirm whether compatible licensed Compustat, CRSP, and I/B/E/S products or the exact author DTA deliveries are available locally; do not infer missing entitlement from this audit.
2. If source products are available, map them to the eight required Data/Original filenames and document extraction, identifier, field, and date filters before converting into the author’s DTA contract. If not, obtain an authorized access route for the author-defined products rather than substituting another source.
3. For annual Compustat, resolve how the author’s `lpermno` and `sic` were formed: catalogued FUNDA exposes `gvkey` and historical `sich`, while the analysis expects `lpermno` and `sic`. Do not assume the historical SIC fields are semantically interchangeable.
4. Resolve CCM link date, linktype, linkprim, and history selection for annual/quarterly company-security mappings; the local link table is only a candidate.
5. For monthly/daily CRSP, assemble stock, security-history, and market-index products into the exact author files; confirm return/price fields, joins, and date history.
6. For all three I/B/E/S datasets and `iclink`, confirm source variants, linking/history windows, field normalization, and the specified historical coverage before writing the author DTA files.

Validation to perform later:

- Against the author-defined Code/02-Compustat.do reads, verify each staged DTA’s exact fields/types and documented source-period coverage, including the 11 monthly lags, three-month leads, daily adjacent-day/two-day price construction, and 3–95 day forecast window.
- Confirm final fiscal-year samples and the 1984–2014 moment window match the documented construction before running the empirical stage.

### ACT005: Once the path, licensed software, and empirical input contract are resolved, follow the author-documented full workflow in its source order, including the generated-moments copy into all four SMM branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: EV002, EV003, EV004, EV005, EV006, EV009

Preparation / proposed procedure:

1. Prepare and stage all eight author-format Data/Original inputs.
2. From each model variant’s own Simulation/Code directory, run its supplied simulation main file; also run base-model Predictions.m for comparative statics. Keep variant working directories isolated.
3. With generated simulation/statics CSVs and original inputs in place, configure the root and run Code/00-Master.do; it invokes 01-Models.do, 02-Compustat.do, and 03-Comparison_Graph.do.
4. After 02-Compustat.do generates Data/Output/Moments.csv, confirm its six-value numeric schema/order and manually copy this fresh producer output into the four matching Estimation/Code/Moments.csv paths listed in Description.pdf. Preserve the four separately packaged lower-precision vectors for analysis-only use.
5. Run all four supplied SMM entry points from their own model-variant Estimation/Code directories.

Validation to perform later:

- Confirm the expected model DTAs, empirical finaldata.dta, six-moment output, graph/table outputs, and four branch estimates are written in the staged package tree; check all four moment copies have the producer values and documented order. Compare against the paper’s reported outputs only after an authorized run.

### ACT006: For the prepared-input model analysis scope, use the shipped positional simulation/statics CSVs and each packaged branch moment vector, then run the supplied model analysis and four SMM branches.

Scopes: analysis_only. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: EV007, EV012, EV013, EV014, EV015, EV023, EV024, EV042, EV060, EV061, EV062, EV063, EV064, EV072, EV073, EV074, EV075

Preparation / proposed procedure:

1. After configuring the writable project root, run Code/01-Models.do against the six supplied simulation/statics CSVs; its positional imports are already documented by the source.
2. Run SMM.m, SMM_NoDelayNoCost.m, SMM_NoCost.m, and SMM_NoDelay.m from their respective Estimation/Code directories, preserving each packaged Moments.csv input and isolating same-basename helpers.
3. This route skips original empirical-data construction, Code/02-Compustat.do, and the hard-coded Figure 11 companion; it does not claim to reproduce empirical Tables 7/8.

Validation to perform later:

- Confirm the model data, tables, and figures are written under the intended staged variant directories and that each SMM entry reads the corresponding six-value packaged vector.


## Remaining issues and prerequisites

- ISS001 [preparation; full_pipeline, analysis_only]: The Stata master sets global directory to the literal placeholder `...`; Stata paths and MATLAB relative writes depend on starting each variant entry point from its own Simulation/Code or Estimation/Code folder. Same-basename helpers across variants require isolated working paths.
- ISS002 [unresolved; full_pipeline]: The eight raw Compustat/CRSP/I/B/E/S deliveries are omitted from the package. Exact current licensed extracts and compatibility with author DTA fields/history are unverified. Local product candidates are readable, but row-limited probes do not establish full coverage or the author’s normalized files. Historical SIC semantics and CCM link selection/history are specifically unresolved.
- ISS003 [unresolved; full_pipeline, analysis_only]: MATLAB runtime installation/license and the Global Optimization, Parallel Computing, and Statistics and Machine Learning toolboxes are unverified. PATH lookup did not establish absence outside PATH.
- REQ001 [undetermined]: Annual Compustat/CRSP merged accounting file; required by Code/02-Compustat.do as Data/Original/Compu_annual.dta.
- REQ002 [undetermined]: Quarterly Compustat/CRSP file used to correct IBES announcement dates; required by Code/02-Compustat.do as Data/Original/Compu_quarterly.dta.
- REQ003 [undetermined]: Monthly CRSP returns file; required by Code/02-Compustat.do as Data/Original/CRSP_monthly.dta.
- REQ004 [undetermined]: Daily CRSP returns and price file; required by Code/02-Compustat.do as Data/Original/CRSP_daily.dta.
- REQ005 [undetermined]: I/B/E/S unadjusted Detail Actuals; required by Code/02-Compustat.do as Data/Original/IBES_act_unadj.dta.
- REQ006 [undetermined]: I/B/E/S unadjusted Detail History forecasts; required by Code/02-Compustat.do as Data/Original/IBES_fc_unadj.dta.
- REQ007 [undetermined]: I/B/E/S split-adjusted Detail History forecasts and actuals; required by Code/02-Compustat.do as Data/Original/IBES_fcact_adj.dta.
- REQ008 [undetermined]: WRDS I/B/E/S-to-CRSP link table; required by Code/02-Compustat.do as Data/Original/iclink.dta.
- SW004 [unverified]: All simulation and SMM entry points are MATLAB. MATLAB and Octave were not found on PATH; installation, license, and runtime version remain unknown.
- SW005 [unverified]: The SMM branches configure and invoke ga/gaoptimset. Verify the licensed toolbox in the intended MATLAB runtime.
- SW006 [unverified]: The supplied estimation/simulation helpers call parfor, gcp, and parpool; verify local MATLAB parallel capability and license. A separate remote cluster is not established as mandatory.
- SW007 [unverified]: Supplied helpers call normcdf, chi2cdf, regress, nanmean, and nancov; verify the licensed MATLAB statistics toolbox.

## Review notes

- No author programs, simulations, regressions, or optimizers were run. All execution_verified values are computed false.
- The supplied simulation CSVs and derived model DTAs are present; the six CSVs are numeric positional inputs (8 columns, except the nine-column Predictions file), not named-header data. The physical CSV values are not variable names.
- The four packaged SMM moment files are each one no-header row of six values and are valid analysis-only inputs. Data/Output/Moments.csv is the full-workflow Stata producer output with the same six-coordinate schema and slightly higher precision; values are close, not identical. The documented full run regenerates and manually copies its moments; no replacement is proposed.
- The full workflow still requires the eight omitted raw empirical inputs. Readable SAS product candidates and selected fields do not prove current entitlement, full historical coverage, final normalized schema, SIC meaning, or CCM match rules; no absent-license conclusion is drawn.
- Figure 11 comparison values are hard-coded published sample estimates in Code/03-Comparison_Graph.do; its graph rendering does not re-estimate empirical models. Stata fpfitci and lpolyci are built-in twoway plot types, not missing add-ons.
- The author-recommended 12 cores, 5 GB RAM, and 48 hours describe performance context; a remote HPC cluster is not treated as mandatory because the provided code requests a local parallel pool.
