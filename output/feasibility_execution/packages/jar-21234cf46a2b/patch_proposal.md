# Patch proposal: jar-21234cf46a2b

Predicting Future Earnings Changes Using Machine Learning and Detailed Financial Data

DOI: 10.1111/1475-679X.12429

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied R workflow embedded in CCDL Code 20220212.pdf: SEC XBRL tag and point-in-time preparation, Compustat OP and DuPont preparation, finalMatrix construction, and the supplied SGB/RF prediction and return evaluation branch. The source is a PDF container rather than a standalone driver; its input schemas and cross-stage handoffs remain incomplete.

Entry points: `CCDL Code 20220212.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 2/12429 - Predicting-Future-Earnings-Changes-Using-Machine-Learning-and-Detailed-Financial-Data/ccdl-datasheet-code-and-identifiers.zip",
      "sha256": "87ef2427b60a6117eed14800023857855cab2a71ace8bdf7380ebd47fd616ee1"
    },
    {
      "path": "JAR-Volume 60/Issue 2/12429 - Predicting-Future-Earnings-Changes-Using-Machine-Learning-and-Detailed-Financial-Data/ccdl-online-appendix.pdf",
      "sha256": "108735809de1d6ae1e5204e768be01dc399907fdb377136f73727a1a5d88ef2f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "39e31ea0af4f61fda233d181e32597544cc6cc570a38b397a065b9ce56622dcc"
}
```

## Proposed actions

### act-extract-code: Extract the substantive R program from the PDF into a working-copy source, preserve the authored section order, and apply only visually supported PDF reflow/comment restoration. Keep the PDF unchanged and leave the scientific definitions and unknown handoffs unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: iss-pdf-code
Evidence: ev-pdf-visual-review, ev-sec-sub, ev-op-input, ev-model-input

Preparation / proposed procedure:

1. Create a versioned working-copy extraction of the R blocks from CCDL Code 20220212.pdf; preserve their original order and indentation.
2. Using the page images on pages 8, 11, 14 and 15, reflow the visible cni plus term, regex anchor and long-minus expressions, and restore the visually continuous comment markers for 2012, K/A and the 2012–2018 line.
3. Do not edit the binary PDF, change model formulas or parameters, or infer any missing producer or data mapping.
4. Keep /XBRL/sub, /XBRL/num and /XBRL/tag staging separate from the working directory; configure coherent runtime roots for the PDF's absolute SEC paths and relative CSV paths.

Validation to perform later:

- Before a future authorized execution, compare the working-copy extraction line by line with the PDF page images; do not parse, compile or execute it during this assessment.

### act-resolve-input-contracts: Obtain producer locations, exact headers, key types, date conventions and history for each named prepared CSV before selecting a compatible author-prepared or raw construction route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-input-handoffs
Evidence: ev-op-input, ev-np-input, ev-ibes-proforma, ev-ibes-forecast, ev-crsp-merge, ev-frozen-catalog-candidates

Preparation / proposed procedure:

1. Request the source files or export specifications for compustat_op.csv, compustat_np.csv, ibes_pro_forma.csv, af.csv and crsp.csv, including the producer, keys, field definitions and date/history contract for each.
2. Treat catalogued Compustat, CRSP and I/B/E/S products as candidates only until exact output compatibility is established; do not impose an independent reconstruction where a matching author-prepared CSV is supplied.
3. Retain separate alternatives only when each delivers the same author input; do not make all raw vendors and prepared CSVs mandatory together.

Validation to perform later:

- After the author contracts are obtained, statically compare each input header and key/date definition with the source reads and downstream merges.

### act-stage-sec-input: Use the verified official public SEC Financial Statement Data Sets route for the author period and stage the files for the existing R input layout.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req-sec-xbrl
Evidence: ev-public-sec-fsd, ev-public-sec-fsd-spec, ev-datasheet-period, ev-sec-sub, ev-sec-num, ev-sec-tag

Preparation / proposed procedure:

1. Acquire the public quarterly Financial Statement Data Sets covering 2012 Q2 through 2018 Q1 from the SEC page, then extract the SUB, NUM and TAG tables into the authored /XBRL/sub, /XBRL/num and /XBRL/tag year folders.
2. Record which SEC release is used; the current official page notes a December 2024 historical reprocessing and an added NUM segments field, so keep content-fidelity comparison with the author vintage separate from product access.
3. Do not fetch the SEC archives during this assessment.

Validation to perform later:

- After authorized acquisition, compare SEC table headers, sample-quarter coverage and required file staging with the authored reads before any code execution.

### act-compustat-contracts: Resolve the OP and DuPont input contracts and their distinct Compustat/security-link requirements without guessing a fiscal-year-to-period mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-comp-op, req-comp-np, iss-input-handoffs, iss-compustat-period-keys
Evidence: ev-code-op-index, ev-op-input, ev-op-output, ev-np-input, ev-np-output, ev-op-period-merge, ev-np-period-merge, ev-frozen-catalog-candidates, ev-public-compustat-product

Preparation / proposed procedure:

1. Obtain the intended compustat_op.csv and compustat_np.csv headers, source vintages, field definitions, CIK/LPERMNO linkage and producer code or prepared-export documentation.
2. Ask how the producer's fyear key is represented as the period key expected by finalMatrix, and confirm the prior/following fiscal-year history needed by the supplied lag/lead calculations.
3. If a raw route is selected, check the frozen COMP.FUNDA and CCMXPF link-table candidates against the exact source fields and construction contract; catalog discovery alone does not establish readability or coverage.

Validation to perform later:

- Compare the actual prepared-file keys and output variable lists with the shown cik/fyear producer exports and cik/period matrix joins; preserve unresolved differences until the author defines them.

### act-ibes-contracts: Obtain the two separate I/B/E/S export contracts, including the pro forma earnings adjustment and the analyst forecast's point-in-time measure.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-ibes-proforma, req-ibes-forecast, iss-input-handoffs, iss-ticker-and-matrix-fields
Evidence: ev-datasheet-ibes-sources, ev-ibes-proforma, ev-ibes-matrix-merge, ev-ibes-forecast, ev-af-period-merge, ev-frozen-catalog-candidates, ev-public-ibes-product

Preparation / proposed procedure:

1. Request headers and producers for ibes_pro_forma.csv and af.csv separately, with TICKER and date keys, measure definitions, historical/as-of timing and any drift-adjustment steps.
2. Confirm where TICKER is added to mtrx and how it is linked to SEC CIK and period; do not infer an earnings-direction proxy or select an I/B/E/S table from similar labels alone.
3. Use ACTU_XEPSUS and STATSUMU_XEPSUS only as frozen-catalog candidates until their measure/period contracts are shown to produce the exact respective author exports.

Validation to perform later:

- Compare the resulting author input headers and point-in-time keys with the TICKER/period and TICKER/forecast_period merges and the later inc_eps/af use.

### act-crsp-sar-contract: Define the author-prepared CRSP return export and the meaning and construction history of the consumed sar field.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-crsp-returns, iss-input-handoffs, iss-ticker-and-matrix-fields
Evidence: ev-datasheet-ibes-sources, ev-crsp-merge, ev-crsp-period-merge, ev-matrix-final-fields, ev-public-crsp-product, ev-frozen-catalog-candidates, ev-doc-languages

Preparation / proposed procedure:

1. Request crsp.csv headers, CIK/security linking, return date and formation window, and the precise size-adjusted sar and transaction-cost definitions used by the authors.
2. Treat CRSP.MSF and CCMXPF_LINKTABLE as candidate raw products; verify any return and identifier construction against the author's prepared export contract before selecting it.
3. The datasheet's historical statement that SAS was used for transaction-cost estimation does not add a SAS driver to the supplied R workflow, which consumes sar from crsp.csv; do not invent a live SAS stage.

Validation to perform later:

- Compare the author export keys and sar definition with the cik/period merge and every downstream return use; keep data vintage and field/history gaps explicit.

### act-xbrl-tag-contract: Clarify how dynamic XBRL tag columns and both taxonomy tag/datatype fields are meant to be produced for the matrix stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-xbrl-tag-matrix
Evidence: ev-tags-output, ev-mtrx-base-fields, ev-tag-loop-condition, ev-common-tags-written, ev-common-tags-read, ev-taxonomy-datatype

Preparation / proposed procedure:

1. Request the intended common_standard_tags.csv header/schema and the producer contract for the tag columns consumed as Assets_0/1 and other current/prior predictors.
2. Confirm whether the six-field mtrx initialization and conditional assignment loop are complete as supplied or whether a producer/normalization block is omitted.
3. Do not invent a datatype join, tag-expansion mechanism or asset proxy.

Validation to perform later:

- Once specified, statically trace the tag and datatype fields from their producer through scaling and finalMatrix selection.

### act-r-package-setup: Prepare the missing R package dependencies after recovering the authors' package versions or a documented compatible set; no packages were installed during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw-dplyr, sw-lubridate, sw-plm, sw-zoo, sw-data-table, sw-sparkr, sw-gbm, sw-randomforest, sw-caret, sw-proc, sw-tidyverse, sw-verification
Evidence: ev-code-package-prep, ev-code-package-model, ev-r-package-metadata

Preparation / proposed procedure:

1. Record the author's R/package versions if available; the current environment metadata shows R 4.5.0 but does not establish the author's versions or compatibility.
2. Prepare dplyr, lubridate, plm, zoo, data.table, SparkR, gbm, randomForest, caret, pROC, tidyverse and verification in the intended R library only after the version/source contract is known.
3. Do not assume a Spark cluster or separate service call: SparkR is imported, but the visible code does not show a Spark operation.
4. Do not install packages during this assessment.

Validation to perform later:

- Before any future authorized run, inspect R/package versions and confirm the called package functions are provided by the selected versions; do not run the model or author program as a dependency check.

### act-task-array-contract: Resolve the model task identifier range and comparison-model producer while keeping the local driver choice routine.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-analysis-driver
Evidence: ev-slurm, ev-model-input, ev-model-compare, ev-pdf-visual-review

Preparation / proposed procedure:

1. Request the intended SLURM_ARRAY_TASK_ID values and the mapping from each task value to the accession-string subsets selected by the regex split.
2. Ask for the producer and expected schema of compare, including adsh and pred_prob_compare, or confirm the supplied comparison block is outside the target branch.
3. A local wrapper can supply a confirmed task value; SLURM itself is not established as a mandatory runtime dependency.

Validation to perform later:

- After task values and compare schema are documented, statically confirm the selected training, validation and testing partitions and the comparison merge keys without running an estimator.

### act-model-output-contract: Clarify the bootstrap and hedge-result objects consumed by the supplied return/AUC summary without changing the authored 10,000 resamples.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-model-output-contract
Evidence: ev-model-bootstrap-init, ev-model-random-dist, ev-model-bootstrap-consumer, ev-pdf-visual-review

Preparation / proposed procedure:

1. Request the intended bootstrap object and field names, the calculation that aggregates yearly bootstrap returns, and the producer for final$hedge_55_sar and final$hedge_64_sar.
2. Confirm whether these are outputs from other task/model blocks or omitted code; keep the current random_dist/bootstrap and mean_bootstrap/hedge inconsistencies unresolved until documented.
3. Retain seed 10 and 10,000 bootstrap iterations when specifying the intended output contract.

Validation to perform later:

- After clarification, trace each written object/column to the exact downstream expression without performing any bootstrap or return calculation.

### act-model-formula-contract: Confirm the intended predictor exclusion terms in the GBM and random-forest formulas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-model-formula-exclusions
Evidence: ev-model-formula, ev-matrix-final-fields

Preparation / proposed procedure:

1. Ask whether op_var and np_var in the formula are meant to name data columns, exclude a block of predictor columns, or represent another documented construction.
2. Keep all generated OP/NP predictor fields and the authored model formula unchanged until the author clarifies the intended feature set.

Validation to perform later:

- Statically compare the clarified formula terms with actual finalMatrix column names before any separately authorized model run.

### act-ordered-run-procedure: Document the supported producer-to-consumer order for the full supplied workflow. This is a future procedure only; source contracts and model handoffs must be resolved first.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: iss-analysis-driver, iss-input-handoffs, iss-xbrl-tag-matrix, iss-pdf-code
Evidence: ev-sec-sub, ev-sec-num, ev-sec-tag, ev-tags-output, ev-pit-output, ev-op-input, ev-op-output, ev-np-input, ev-np-output, ev-ibes-matrix-merge, ev-af-period-merge, ev-crsp-period-merge, ev-finalmatrix, ev-model-input, ev-slurm

Preparation / proposed procedure:

1. Choose a coherent working directory for the extracted R source and its relative CSV inputs/outputs; stage official SEC SUB, NUM and TAG inputs at the authored /XBRL paths and year folders.
2. Run the supplied SEC tag preparation block to produce common_standard_tags.csv, then the point-in-time block to produce point_in_time.csv.
3. Using the specified author-prepared Compustat input files, run OP preparation to produce op_var.csv and DuPont preparation to produce np_var.csv; preserve each block's fiscal lag/lead calculations.
4. After all prepared-file schemas, TICKER/CIK mappings and dates are confirmed, build finalMatrix.csv from the SEC inputs, common_standard_tags.csv, point_in_time.csv, op_var.csv, np_var.csv, ibes_pro_forma.csv, af.csv and crsp.csv.
5. Only after task values, formula terms, model output objects and compare are resolved, run the supplied model branch against finalMatrix.csv. Preserve the documented grids, seeds 135 and 10, 10,000 bootstrap iterations, and the code's ntree=500 unchanged. If comparing with Appendix Table A13, record its reported 1,000 trees as an optional output-fidelity difference; that comparison is not a prerequisite to running the supplied code.
6. Do not execute any author code as part of this assessment; a future execution requires separate authorization and all unresolved contracts addressed first.

Validation to perform later:

- Before a separately authorized execution, verify every named producer output and its headers/keys against the next consumer in the order above; do not create trial data or run statistical procedures to establish compatibility.


## Remaining issues and prerequisites

- iss-pdf-code [preparation; full_pipeline]: The substantive R program is embedded in a 16-page PDF rather than supplied as a standalone driver. Static visual review supports working-copy extraction, comment restoration for visually wrapped comment continuations, and reflow of the visible expression/regex wraps on pages 8, 11, 14 and 15; it does not support changing formulas, estimator settings or unknown input contracts.
- iss-input-handoffs [unresolved; full_pipeline]: The code consumes compustat_op.csv, compustat_np.csv, ibes_pro_forma.csv, af.csv and crsp.csv, but the release contains no producers or complete field/date/identifier contracts for these prepared inputs. Frozen catalog candidates are discovery only; author-prepared inputs and compatible raw construction are both unverified.
- iss-analysis-driver [unresolved; full_pipeline]: The model block requires finalMatrix.csv and reads SLURM_ARRAY_TASK_ID, but the task range and accession-string split contract are not supplied. The final comparison also merges an object named compare with no producer in the supplied PDF. A local wrapper could set the task variable, but its values and the comparison-model handoff remain unknown.
- iss-xbrl-tag-matrix [unresolved; full_pipeline]: The visible matrix starts with six base fields and the tag loop only assigns when the constructed tag name already exists, so the shown block does not create those dynamic tag columns. Separately, common_standard_tags.csv is written headerless with one tag vector, while its consumer refers to tax$tag and tax$datatype. The intended tag-column and datatype producer contract needs clarification.
- iss-compustat-period-keys [unresolved; full_pipeline]: The OP and NP producers export cik and fyear, but finalMatrix joins each export by cik and period. The source does not define a fyear-to-period representation or confirm why output keys and join keys differ. Do not invent a year-to-date mapping.
- iss-ticker-and-matrix-fields [unresolved; full_pipeline]: mtrx is visibly initialized without TICKER, yet joins use TICKER. The block also requires Assets_0 and Assets_1 and retains inc_eps, af and sar, whose producer/column contracts are not fully shown. Request export headers and the CIK-to-TICKER, period and dependent-variable definitions; do not invent an earnings proxy or return definition.
- iss-model-output-contract [unresolved; full_pipeline]: The bootstrap block initializes bootstrap with bootstrap_55_sar and bootstrap_64_sar, writes into random_dist, then reads mean_bootstrap_55_sar/64_sar and final$hedge_55_sar/64_sar fields not created in the visible code. Clarify the intended object names, aggregation producer and hedge-field producer without changing the 10,000-iteration analysis.
- iss-model-formula-exclusions [unresolved; full_pipeline]: The model formula subtracts op_var and np_var by name, while the matrix code uses objects with those names as character vectors of predictor columns. The intended formula exclusion semantics and surviving feature set are not specified; preserve the authored formula pending clarification.
- req-sec-xbrl [public_acquisition_required]: Public SEC Financial Statement Data Sets are the matching source family for the code's SUB, NUM and TAG reads. The author datasheet uses filings from 2012 Q2 through 2018 Q1; code filters fiscal and GAAP consolidated filings and consumes submission, number and tag fields. The current SEC archive is publicly listed for the sample years, but its December 2024 historical reprocessing can change contents relative to the author's vintage.
- req-comp-op [undetermined]: The supplied OP block reads the absent author-prepared compustat_op.csv using GVKEY and fyear panel keys, creates OP predictors with annual lags, and writes op_var.csv with cik and fyear. The final matrix later expects a cik/period join, so source fields, CIK mapping, fiscal-year mapping and lag history need the author's export contract.
- req-comp-np [undetermined]: The supplied DuPont block reads the absent author-prepared compustat_np.csv, indexes it by LPERMNO and fyear, uses lag and lead values, and writes np_var.csv with cik and fyear. Required raw fields, CIK/security links, annual timing and the final cik/period mapping are unspecified.
- req-ibes-proforma [undetermined]: The matrix block reads the absent ibes_pro_forma.csv and merges it by TICKER and SEC period; later it retains inc_eps for classification. The author describes drift-adjusted pro forma earnings, but the export's fields, adjustment construction, filing/as-of date and ticker crosswalk are not supplied.
- req-ibes-forecast [undetermined]: The matrix block reads the absent af.csv, computes forecast_period as SEC period plus twelve months and merges by TICKER and forecast_period; finalMatrix retains a field named af. The forecast definition, as-of date and export fields are not supplied.
- req-crsp-returns [undetermined]: The matrix reads the absent crsp.csv and merges by cik and period; later code consumes sar as the size-adjusted return field. The CRSP return construction, CIK/security link, formation timing, size adjustment and any transaction-cost treatment are not defined by this export contract.
- sw-dplyr [preparation_required]: Imported in the point-in-time, matrix and model sections; absent from the inspected default R libraries.
- sw-lubridate [preparation_required]: Imported by preparation code for month arithmetic; absent from the inspected default R libraries.
- sw-plm [preparation_required]: Used for panel indexing and lag/lead operations in OP and DuPont preparation; absent from the inspected default R libraries.
- sw-zoo [preparation_required]: Imported by matrix preparation for as.yearmon; absent from the inspected default R libraries.
- sw-data-table [preparation_required]: Imported by matrix preparation for data.table operations; absent from the inspected default R libraries.
- sw-sparkr [preparation_required]: Explicitly imported in matrix preparation but absent from the inspected default R libraries. The visible code does not establish a separate Spark service call.
- sw-gbm [preparation_required]: Required for the supplied caret GBM branch and the permutation importance call; absent from the inspected default R libraries.
- sw-randomforest [preparation_required]: Required for the supplied random-forest branch; absent from the inspected default R libraries.
- sw-caret [preparation_required]: Required for train, trainControl, and the supplied GBM/RF branches; absent from the inspected default R libraries.
- sw-proc [preparation_required]: Required for roc and roc.test in the model comparison branch; absent from the inspected default R libraries.
- sw-tidyverse [preparation_required]: Explicitly imported in the model section; absent from the inspected default R libraries.
- sw-verification [preparation_required]: Required by verification::roc.area; absent from the inspected default R libraries.

## Review notes

- The static audit reports no supported code, but the cached 881-line code PDF contains substantive SEC tag and point-in-time preparation, Compustat OP/DuPont construction, matrix preparation, and GBM/random-forest analysis blocks. The supplied program is credited as code; it is not a standalone executable driver.
- The assessed target is the full supplied R workflow. No analysis-only route is supported because no compatible finalMatrix.csv or other author-prepared analysis input is provided. Generated files common_standard_tags.csv, point_in_time.csv, op_var.csv and np_var.csv remain in the documented producer order; missing CSV producers, schemas and joins remain explicit gaps.
- Current SEC Financial Statement Data Sets provide a public route for the documented filing period and SUB/NUM/TAG family. The current official page notes that historical data were reprocessed in December 2024, so version/output fidelity remains separate from public access.
- Frozen catalog hits for Compustat, CRSP and I/B/E/S are candidate metadata only. No commercial dataset route is marked blocked or verified; no license, entitlement, field/history match or author export was established. No datasets were downloaded.
- R 4.5.0 is present in the existing environment metadata, while the twelve code-imported or namespaced R packages were absent in the recorded package metadata. No package installation or author code import occurred.
- The datasheet mentions historical SAS transaction-cost estimation, but the supplied entry program is R and consumes sar from crsp.csv; this assessment does not add an invented live SAS driver or SAS software prerequisite.
- One bounded SAS metadata process was launched under the earlier scope interpretation and returned 1 during TKELS initialization. The saved command/result record has no log or listing hashes. Whether the autoexec or submitted SAS source ran, or whether any study rows were accessed, is unknown; this attempt is excluded from scientific data-route and runtime-readiness evidence. See probes/sas_metadata_custody_clarification_20261110.json.
- No R author program, estimator, model, syntax trial, data transformation or descriptive/statistical analysis was run. The identifier file adsh.txt was not read; the datasheet identifies it as an identifier file. The source/page inspection and metadata records do not establish complete empirical data coverage.
- For output-fidelity context, the supplied code sets randomForest ntree=500 while Online Appendix Table A13 reports 1,000 trees for 2015–2018. Preserve ntree=500 for the assessed supplied-code target; comparing these settings is optional future fidelity work and not a prerequisite clarification for attempting that code.
