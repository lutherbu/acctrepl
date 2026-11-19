# Patch proposal: jar-e082f62526bd

Detecting Accounting Fraud in Publicly Traded U.S. Firms Using Machine Learning Approach

DOI: 10.1111/1475-679X.12292

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied workflow: transcribe and configure the SAS preparation embedded in the PDF, then run the supplied MATLAB RUSBoost28 script and its reader/evaluation helpers after resolving the SAS-to-MATLAB input contract. Preserve pooled SAS construction and winsorization plus the 2003–2008 RUSBoost analysis.

Entry points: `20191108 SAS coding.pdf`, `20191108 run_RUSBoost28.m`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 1/12292 - Detecting-Accounting-Fraud-in-Publicly-Traded-U-S-Firms-Using-Machine-Learning-Approach/bklyz-datasheet-and-code.zip",
      "sha256": "3987dc123dc53337176c804c77a0ca456b7f3506922dfd8ccf678ac519a9d887"
    },
    {
      "path": "JAR-Volume 58/Issue 1/12292 - Detecting-Accounting-Fraud-in-Publicly-Traded-U-S-Firms-Using-Machine-Learning-Approach/bklyz-online-appendix.pdf",
      "sha256": "fa0cf584a1171dd90f11cf6b2a22edb4613abbf030dca07fd0601559d6cb512b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "878d7cf62aa015af19212f6bd10057e957c667164ea742bbb00bf968dabfe57a"
}
```

## Proposed actions

### resolve_compustat_source: Resolve whether the catalog-listed local annual-fundamentals candidate can supply the author’s industrial SAS input, and use a documented route if it cannot.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: compustat_annual, compustat_panel_producer
Evidence: sas_source, sas_inputs, sas_population, sas_lags, sas_winsor_call, datasheet_sources, catalog_resource, catalog_funda_fields, comp_funda_probe

Preparation / proposed procedure:

1. Treat ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat (COMP.FUNDA) as the first local candidate: the frozen catalog labels it “Merged Fundamental Annual File,” and a bounded one-row probe verifies readability and all 34 source field names used by the SAS code.
2. Confirm the exact author construction/filter that creates fraud.compustatindustrial7815 from its source, including industrial membership, retained fyear 1978–2015 population, and prior consecutive firm-year observations needed for lag features. The supplied PDF reads that table but does not produce it; do not infer compatibility from the matching fields or catalog count.
3. If the local candidate cannot be shown to satisfy the documented source contract, verify current institutional WRDS/Compustat access or request the exact source-table specification. Do not treat the earlier phrase-search miss or unknown entitlement as evidence of unavailable data or licensing.

Validation to perform later:

- Before a future SAS run, verify the actual source table’s product, field types, identifiers, industrial filter and full 1978–2015 retained population; the row_limit=1 probe and its 1961 sample do not establish coverage.
- Confirm pooled 1st/99th percentile winsorization uses all rows retained by the author’s 1978–2015 filter, keeping the datasheet 1991–2014 paper/model window distinct.

### prepare_sas_working_copy: Prepare the PDF-embedded SAS program and package inputs in a separate, batch-usable working tree without modifying the original package.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: sas_setup, sas_base, aaer_firm_year
Evidence: sas_inputs, sas_winsor, sas_winsor_call, sas_output, datasheet_aaer, aaer_probe, aaer_stream

Preparation / proposed procedure:

1. Transcribe the supplied SAS statements and included winsor macro into a working-copy .sas file in their authored order; retain the formulas, filters, lags and 1st/99th pooled winsorization.
2. Set up the fraud library and import the packaged CSV to fraud.aaer_firm_year using its documented columns P_AAER, CIK, YEARA and UNDERSTATEMENT. Assign fraud.compustatindustrial7815 only after the exact Compustat route, fields and period are confirmed.
3. Choose a coherent project working root under [redacted-path-cc809e05bbbb] or relative to the batch working directory; use only relative or [redacted-path-91234f6bc086] and preserve the originals. Confirm host visibility and writability before any separately authorized run.

Validation to perform later:

- Before an authorized SAS run, verify staged input table names/columns and paths and confirm the copied preparation statements match the supplied PDF.
- In a future run, confirm fraud.all is produced with the author-selected variables and that the pooled 1st/99th percentile treatment is applied on the retained source population.

### verify_sas_runtime: Resolve the recorded SAS startup issue and verify the existing SAS Base runtime before any author-code run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sas_runtime, sas_base
Evidence: environment_probe, sas_winsor

Preparation / proposed procedure:

1. Have the managed host/runtime owner verify SAS 9.4 startup and Base procedure availability after the recorded TKELS initialization failure.
2. Do not infer missing entitlement from the startup failure and do not retry SAS as part of this assessment.
3. Use batch mode with a relative or [redacted-path-cc809e05bbbb] working root and the common SAS autoexec only after the environment is independently ready.

Validation to perform later:

- Confirm the intended SAS 9.4 runtime can invoke PROC SQL, PROC SORT and PROC UNIVARIATE in an empty-session check before the package is run.

### resolve_sas_matlab_handoff: Obtain the exact, version-matched SAS-to-MATLAB input contract for the supplied RUSBoost28 branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: sas_matlab_handoff
Evidence: sas_output, matlab_reader, matlab_runner, datasheet_contract, repo_public, repo_readme, repo_filemeta, repo_reader, repo_runner

Preparation / proposed procedure:

1. Ask for the exact prepared uscecchini28.csv version or author crosswalk that feeds the supplied data_reader.m positions 1–37, including the producer and meaning of options and new_p_aaer.
2. Ask how the SAS output fraud.all is exported or mapped to that positional schema; do not assume the SAS KEEP list is the MATLAB file or guess aliases.
3. The current author repository’s data_FraudDetection_JAR2020.csv and data_default reader form a different 32-position, 300-tree, 2003–2014 variant. Do not substitute that workflow for the frozen 3,000-tree, 2003–2008 RUSBoost28 target.
4. If an exact compatible author-prepared input/mapping is supplied, assess it as a distinct analysis-only route in a subsequent scoped review; until then retain this missing handoff in the full pipeline.

Validation to perform later:

- Compare any supported CSV header/order to the frozen reader’s year, firm, sic, insbank, understatement, options, paaer, new_paaer, label and columns 10–37 feature contract before an authorized run.
- Confirm any crosswalk preserves fraud labels, serial-fraud recoding, 28 raw features and the authored training/test years.

### stage_matlab_working_copies: Resolve MATLAB helper filenames in a working copy while preserving original source files and code contents.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: matlab_file_names
Evidence: matlab_reader_function, matlab_eval_function, matlab_eval_call, matlab_reader_csv, matlab_output

Preparation / proposed procedure:

1. Copy the supplied helper contents into working files named data_reader.m and evaluate.m so the MATLAB filenames match their declared functions and the runner’s calls.
2. Stage the script as run_RUSBoost28.m for a conventional invocation and place the resolved author CSV contract in the same analysis working directory, because the runner names uscecchini28.csv relatively.
3. Keep the source package’s dated filenames unchanged and do not alter formulas, samples, estimators, labels or output names.

Validation to perform later:

- From the MATLAB working directory, verify which data_reader and which evaluate resolve to the staged working copies before running the script.
- Confirm the runner can resolve uscecchini28.csv from its current working directory and that its prediction_rusboost28YYYY.csv outputs go to the intended writable results directory.

### verify_matlab_runtime: Verify an existing MATLAB runtime and the exact Statistics and Machine Learning Toolbox functions required by the supplied RUSBoost code.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: matlab, matlab_stats_ml, matlab_runtime
Evidence: matlab_model, matlab_capability_probe

Preparation / proposed procedure:

1. Check whether MATLAB is installed/configured on the managed host and record its version; a PATH miss in the bounded check does not prove system-wide absence.
2. In MATLAB, verify the exact entry points fitensemble, templateTree, predict and perfcurve and the applicable Statistics and Machine Learning Toolbox capability/license.
3. If the runtime or capability is missing, request authorized MATLAB/toolbox access; do not install packages or replace the authored method with Octave, Python or R.

Validation to perform later:

- In the future MATLAB session, record version, which results for fitensemble/templateTree/predict/perfcurve, and applicable toolbox availability before a package run.

### run_full_pipeline_after_prerequisites: Run the supplied SAS preparation and unchanged MATLAB RUSBoost28 branch only after source-table construction, handoff schema, host paths and runtimes are verified.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: compustat_annual, aaer_firm_year, sas_base, matlab, matlab_stats_ml, sas_setup, sas_runtime, sas_matlab_handoff, matlab_file_names, matlab_runtime, compustat_panel_producer
Evidence: sas_source, sas_inputs, sas_population, sas_lags, sas_winsor_call, sas_output, matlab_reader, matlab_runner, matlab_model, matlab_top1, matlab_ndcg, matlab_output, aaer_probe, catalog_resource, comp_funda_probe

Preparation / proposed procedure:

1. In a separate working copy with a host-visible/writable staged project root, use the staged root as the relative runtime working directory; keep executable paths relative or under [redacted-path-cc809e05bbbb], preserve the original dated files, import the packaged AAER CSV, and configure SAS library paths without absolute Dropbox paths.
2. After SAS Base is available and the exact industrial source producer/population is verified, run the transcribed PDF SAS program in batch mode. Preserve the 1978–2015 filter, firm-year lag checks, derived features and pooled 1st/99th winsorization; retain the produced fraud.all table.
3. Before MATLAB, resolve the exact 37-position uscecchini28.csv header/order and the producer/semantics of options and new_p_aaer; verify the export against the frozen reader. Do not run the model with the current repository’s different 32-position/300-tree/2003–2014 variant.
4. After MATLAB and Statistics and Machine Learning Toolbox capabilities are verified, run the staged run_RUSBoost28.m from the analysis working directory with data_reader.m, evaluate.m and the verified uscecchini28.csv alongside it. Preserve rng(0,'twister'), 3,000 RUSBoost iterations, gap=2, training years 1991 through testyear−2, test years 2003–2008, serial-fraud recoding and top-1% evaluation.
5. Capture SAS and MATLAB console output as run logs and retain the six prediction_rusboost28YYYY.csv files produced for 2003–2008.

Validation to perform later:

- Check SAS logs for successful creation of fraud.all and inspect its variables, identifiers and retained fyear population against the documented producer/source contract.
- Verify the exported uscecchini28.csv has a header and the exact 37 positional fields expected by data_reader.m, with the required labels, serial-fraud IDs and 28 raw features.
- Check the MATLAB log contains results for each 2003–2008 test year under the unchanged 3,000-tree settings; confirm six prediction CSVs and their six-column positional order (the supplied dlmwrite call does not write a header): year, firm, new_p_aaer, true label, predicted label, fraud score. Do not execute these future checks during this assessment.


## Remaining issues and prerequisites

- sas_setup [preparation; full_pipeline]: The substantive SAS preparation is embedded in a PDF and begins by reading fraud library tables. No standalone .sas driver, libname/import setup, input file paths, working directory, or output directory is supplied. This is a preparation/configuration gap; the supplied formulas and macro should be preserved in a working copy.
- sas_runtime [unresolved; full_pipeline]: The environment inventory records a SAS 9.4 startup failure during TKELS initialization. Runtime availability is unverified; this is not evidence of a missing license and no additional SAS startup attempt was made.
- sas_matlab_handoff [unresolved; full_pipeline]: The SAS program ends by creating fraud.all after a selected KEEP and a raw Compustat join; no CSV export to the MATLAB input is present. The frozen MATLAB reader requires 37 positional columns: year, firm, sic, insbank, understatement, options, paaer, new_paaer, label, then 28 features. The SAS output code does not establish the options or new_p_aaer columns or a 37-column export order. The current author repository lists data_FraudDetection_JAR2020.csv, whose current reader contract has 32 positions (year, firm, p_aaer, label, 28 features) and whose current runner uses 300 trees and test years 2003–2014; it is not a demonstrated compatible replacement for this supplied RUSBoost28 branch (3,000 trees, 2003–2008, new_p_aaer). Request the exact matching prepared file/version or author field mapping; do not guess aliases or change the target analysis.
- matlab_file_names [preparation; full_pipeline]: The supplied helper files are named 20191108 data_reader.m and 20191108 evaluate.m, but declare functions data_reader and evaluate, which the runner calls by those bare names. Resolve names in a working copy so MATLAB can find the functions; retain original bytes and do not change their contents. The runner itself is a script stored under a date-prefixed name with a space and can also be staged under a conventional working-copy name.
- matlab_runtime [unresolved; full_pipeline]: The MATLAB command was not found on the inherited PATH, and the exact MATLAB Statistics and Machine Learning Toolbox functions required by the supplied branch have not been checked in an available MATLAB session. Actual installation/version/toolbox entitlement remains unknown.
- compustat_panel_producer [unresolved; full_pipeline]: The SAS program reads fraud.compustatindustrial7815 directly, but the supplied PDF does not show how that exact table is produced from the catalog-listed COMP.FUNDA file or how its industrial membership/population is formed. The local COMP.FUNDA candidate has the required variable names and is readable in a one-row probe, but its catalog label and sampled fyear=1961 row do not establish an industrial filter, the retained 1978–2015 panel, or the lag/history and pooled-winsorization population. Keep the local file as a candidate, not a verified substitute or proof of absent licensing.
- compustat_annual [undetermined]: WRDS/Compustat annual industrial firm-year source consumed as fraud.compustatindustrial7815. The actual SAS code requires source variables used in joins, filters, formulas and the 28 raw features. It filters fyear to 1978–2015 before lag construction, then winsorizes the full retained pooled population at the 1st/99th percentiles; the datasheet separately reports fiscal years 1991–2014 for the accounting data in the paper’s current version. Keep these as the supplied construction and later analysis windows, respectively.
- sas_base [unverified]: The embedded SAS workflow uses PROC SQL, PROC SORT, DATA steps, and an included winsor macro calling PROC UNIVARIATE. These procedures do not establish a SAS/STAT dependency. A bounded SAS 9.4 startup probe failed at TKELS initialization, so runnable Base SAS capability is unverified; this does not establish a license barrier.
- matlab [unverified]: The supplied workflow is MATLAB; its release is unspecified in this package. The bounded command lookup did not find matlab on the inherited PATH, so actual installation, version and host availability remain unverified.
- matlab_stats_ml [unverified]: The supplied analysis invokes fitensemble with RUSBoost, templateTree, predict, and perfcurve. The availability of these exact MATLAB entry points and toolbox capability is unverified; Octave or another language is not treated as a substitute.

## Review notes

- The static audit reports no supported code because its parser excludes MATLAB; direct source review confirms three MATLAB files and substantive SAS preparation code embedded in the 335-line PDF. The dependency list in the frozen work item is empty, so the complete source graph was reviewed manually.
- The current author repository is public and lists a 45.6 MB final CSV, but its current reader uses a different 32-column positional contract and its current RUSBoost runner uses 300 trees and tests 2003–2014. This does not establish a compatible analysis-only bypass for the supplied 2019 37-column, 3,000-tree, 2003–2008 branch. No public dataset was downloaded and no raw CSV was fetched.
- The packaged AAER CSV has 1,747 physical newline characters and a streamed SHA-256; this is not claimed as an observation count or proof of full coverage. The existing one-row probe confirms the four expected label-table columns.
- The author appendix contains result summaries for other model families, but the assigned package does not provide their code branches. They remain contextual; target the supplied SAS preparation and RUSBoost28 branch only.
- The initial full-phrase catalog searches missed the abbreviated COMP.FUNDA entry. Follow-up catalog metadata and a bounded one-row probe identify ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat and all 34 SAS source fields; the probe samples fyear=1961 and does not verify industrial filtering, the required 1978–2015 population, or compatibility with fraud.compustatindustrial7815. This is not evidence of absent access or licensing.
- The SAS Base and MATLAB/toolbox checks remain unverified. SAS startup failure at TKELS and a MATLAB PATH miss are not treated as evidence of missing licenses.
- The SAS construction and pooled-winsorization population is 1978–2015; the datasheet reports fiscal years 1991–2014 for the paper data/model period. Treat these as distinct authored windows, not a defect or additional author-intent gate.
