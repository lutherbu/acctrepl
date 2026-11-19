# Patch proposal: jar-d0202c985a7f

Racial Diversity Exposure and Firm Responses Following the Murder of George Floyd

DOI: 10.1111/1475-679X.12484

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented Stata/Python/SAS processing, manually labeled conference-call classifier, event-return, and table-reproduction workflow. The 25 listed drivers are standalone entry points; import-only regex/components/utils modules remain required closure sources.

Entry points: `processing/cleaning_merging_datasets.do`, `processing/conference_calls/1_identify_diversity_disclosures_in_conference_calls.py`, `processing/conference_calls/2_calculate_sentiment_in_conference_calls.py`, `processing/conference_calls/3_conference_call_level.py`, `processing/conference_calls/4_machine_learning_initiatives/modeling_initiatives.ipynb`, `processing/conference_calls/5_merge_datasets_conference_call_level.py`, `processing/conference_calls/6_diversity_disclosure_over_time.py`, `processing/conference_calls/7_identify_race_gender_disclosures.py`, `processing/press_releases/1_processing_press_releases.py`, `processing/press_releases/2_parse_press_releases.py`, `processing/returns_around_conference_call_dates.py`, `processing/returns_around_director_appointment_announcements.py`, `processing/returns_for_event_study_press_releases.sas`, `tables/table_01.py`, `tables/table_02.do`, `tables/table_03_04.do`, `tables/table_05.py`, `tables/table_06.do`, `tables/table_07.do`, `tables/table_08.do`, `tables/table_09.do`, `tables/table_10.do`, `tables/table_11.do`, `tables/table_12.do`, `tables/table_13.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 3/12484 - Racial-Diversity-Exposure-and-Firm-Responses-Following-the-Murder-of-George-Floyd/bcdr-datasheet-code-and-identifiers.zip",
      "sha256": "378e1cf711d763de552a52276b3d79ede538b21180fcf750ffa886fcae5c2638"
    },
    {
      "path": "JAR-Volume 61/Issue 3/12484 - Racial-Diversity-Exposure-and-Firm-Responses-Following-the-Murder-of-George-Floyd/bcdr-online-appendix.pdf",
      "sha256": "ad9ac3f1ded349b2d45def3bb20a8a4f9d8f2dd017bcfc74dd91497cba7237e1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a4d0212134ffb8be431dcf4c1408358d61ef044b24512d83d6c84e512c9ed2a0"
}
```

## Proposed actions

### ACT_VENDOR_INPUTS: Stage or obtain source-compatible vendor inputs through the permitted institutional/provider routes, recording product/version and needed fields/coverage. Author filename dates are provenance; exact original export bytes are not required when a compatible product satisfies the source contract.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_ISSDD, REQ_AUDIT_ANALYTICS, REQ_TR_AGGREGATE, REQ_TR_S34, REQ_FACTIVA, REQ_RAVENPACK, REQ_BLOOMBERG_SP, ISSUE_ISS_VINTAGE
Evidence: E0106, E0109, E0110, E0112, E0113, E0116, E0211

Preparation / proposed procedure:

1. Identify an authorized route for each vendor product and record source product/release separately from the purchase or download date.
2. Stage compatible products under the configured raw-data tree, preserving source identifiers, fields, units, and historical coverage required by the workflow.
3. For ISSDD, map the master’s 2021-10-01 filename macro to the corresponding release/file convention; treat the February 2022 purchase date as separate provenance.

Validation to perform later:

- Check exact product schema and period coverage used by the corresponding author stage; do not infer access or a barrier from catalog matches/misses.
- Confirm the ISSDD macro/file mapping and monthly coverage without treating purchase timing as a release-date contradiction.

### ACT_DATA_ROUTE_RESOLUTION: For each input, select one source-supported primary route: stage a compatible author-prepared dataset or construct it from the needed raw inputs with the included producer workflow. These routes are alternatives; do not require both or invent missing labels, external interfaces, or archive outputs.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISSUE_INCOMPLETE_DATA_INVENTORY
Evidence: E0210, E0001, E0002

Preparation / proposed procedure:

1. For every frozen dependency, document whether a compatible prepared dataset is supplied or whether the included workflow can produce it from staged raw sources.
2. Use the author-prepared route when its fields, identifiers, period, and provenance match the source contract; otherwise use the documented raw reconstruction route when all required producer inputs are available.
3. List missing raw inputs and separately unresolved author-prepared outputs such as the legacy match and manually edited labels.

Validation to perform later:

- Confirm one complete compatible upstream path per required dataset by checking source-supported fields, keys, periods, and producer-consumer filenames before any full run.

### ACT_LEGACY_MATCH: Resolve the author-cited 2021-09-17 prepared match dataset and its producer/schema contract before the combined director-matching stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_AA_LEGACY_MATCH, ISSUE_LEGACY_AA_MATCH
Evidence: E0154, E0155, E0210

Preparation / proposed procedure:

1. Locate the exact archive input named in the source or obtain the matching prepared data/source specification from the authors.
2. Record keys, field meanings, period, file format, and compatibility with the current master output.
3. Do not rebuild or replace the legacy match unless its author-prescribed construction is supplied.

Validation to perform later:

- Compare the documented key/field contract with the current combined-match consumer and confirm no observation or analysis specification changes.

### ACT_PUBLIC_INPUTS: Acquire or prepare the author-documented public inputs and compatible prepared extracts where source fields, observation vintages, and construction match the included workflow.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_BLS_INPUTS, REQ_CENSUS_2019, REQ_CENSUS_2021, REQ_EDGAR_FORM8K, REQ_B2C, REQ_ZIP_CODES, REQ_CONFERENCE_CALL_CORPUS
Evidence: E0100, E0101, E0105, E0111, E0114, E0115, E0131, E0133, E0134, E0160, E0161, E0216, E0217, E0264, E0265, E0266, E0268, E0269

Preparation / proposed procedure:

1. For each listed product, verify the exact requested years, fields, identifiers, and preparation procedure against its author source lines.
2. Obtain the BLS staff-provided 2020 data and exact Census 2019/2021 files if the current public pages do not provide compatible author vintages.
3. Obtain the author transcript metadata and parsed interaction tree as a compatible corpus; use only an authorized delivery method.

Validation to perform later:

- Before execution, verify all required periods and keys against the author code and the cited data product.
- For Census, confirm that the exact 2019 and 2021 inputs are compatible with the merge keys and population estimate columns.
- For EDGAR, confirm the annual CSV fields and 5.02 item field used by the master.

### ACT_LOCAL_FINANCIAL_DATA: Use the catalog entries as product candidates, then stage any current compatible Compustat/CCM/CRSP/IBES data that meets the source-used fields and historical windows. Snapshot dates in author filenames are provenance, not original-byte requirements.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_COMPUSTAT, REQ_CCM_LINKS, REQ_CRSP_INDEX, REQ_CRSP_PORTFOLIO_RETURNS, REQ_IBES_SURPRISE, REQ_CRSP_DAILY, REQ_CRSP_CALL_CALENDAR, REQ_CRSP_DSF_EVENT
Evidence: E0102, E0103, E0104, E0108, E0138, E0139, E0140, E0141, E0142, E0143, E0211

Preparation / proposed procedure:

1. For Compustat, preserve the annual firm-year filters/keys and enough source history for the GVKEY-specific minimum-FYEAR age measure; the lower year bound remains unspecified.
2. For CCM, preserve the source-used link flags and LINKDT/LINKENDDT intervals over all downstream firm/event dates; the first/last required link year remains unspecified.
3. For CRSP, stage the distinct firm-date/CUSIP, date-calendar, stock-event, index, and portfolio-return roles with the source-used keys and event windows; exact first/last event dates remain unknown.
4. For IBES, preserve EPS/QTR and OFTIC/ANNDATS/PYEAR/PMON alignment and the source-used surprise fields; the full year range of the quantile reference set remains unspecified.
5. Use a compatible current product if its fields and history satisfy those contracts; otherwise retain the input route as unverified and document the exact remaining coverage gap.

Validation to perform later:

- Check the source-defined filters, keys, date intervals, and full required history for each product separately; record unknown bounds rather than substituting filename snapshot dates.
- Do not infer exact-source availability from catalog metadata alone or require original author snapshot bytes when a compatible route meets the source contract.

### ACT_AYS_INPUTS: Obtain the author’s licensed As You Sow quarterly data and dictionaries/weights through the documented permitted route, and retain the author’s no-analysis-restriction statement with provenance.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_AS_YOU_SOW
Evidence: E0117, E0118, E0147, E0148, E0149

Preparation / proposed procedure:

1. Confirm which author-provided file set matches the three raw imports in the Stata master.
2. Stage the exact quarterly data and both dictionaries/weights at the configured raw-data path.
3. Record delivery date, period, company identifiers, quarter keys, and score fields.

Validation to perform later:

- Confirm the author-defined RJI/DEI variables, quarter keys, and score-field definitions match the downstream merge and table inputs.

### ACT_LM_DICTIONARIES: Stage the named positive and negative Loughran–McDonald dictionary files at the source-used relative paths, and retain their content/version as an unresolved input contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_LM_DICTIONARIES
Evidence: E0162, E0163, E0187, E0188, E0267

Preparation / proposed procedure:

1. Locate compatible dictionary content and record its source/version and word-list format.
2. Use ACT_PATH_MANIFEST to bind the known project root so the parser’s existing DIR/dictionaries/LM paths resolve.
3. Keep dictionary content/version separate from NLTK tokenizer-resource and module-interface questions.

Validation to perform later:

- Confirm the two named files are present at the configured paths and their content/version matches the intended source; no substitute word list is introduced.

### ACT_MANUAL_LABELS: Obtain the final author-edited annotation workbook, label definitions, and exact columns/order needed for the training notebook.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MANUAL_LABELS, ISSUE_MANUAL_LABELS
Evidence: E0164, E0165, E0166, E0167, E0170, E0171

Preparation / proposed procedure:

1. Request the annotated 1,000-sentence workbook and the author’s instructions for initiatives and past_actions.
2. Confirm whether the full sentence-list CSV also needs manual fields, or only the sample workbook.
3. Preserve the author’s labels; do not synthesize or infer labels.

Validation to perform later:

- Verify the notebook input workbook contains both required fields and expected text column before training.
- Record annotation definitions and the sample selection seed/size from the shipped stage.

### ACT_ROBERTA_ASSET: Acquire the public FacebookAI/roberta-base checkpoint and tokenizer at a recorded revision compatible with the author’s roberta-base alias; do not substitute an unverified fine-tuned checkpoint.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_ROBERTA_BASE
Evidence: E0169, E0218

Preparation / proposed procedure:

1. Record the exact repository revision and hashes for tokenizer/config/weights.
2. Stage the resource in the supported Transformers cache or a configured local model path.
3. Do not load, deserialize, train, or infer during this audit.

Validation to perform later:

- Confirm the selected tokenizer and base model correspond to the same recorded revision and expected model interface before authorized training.
- Record the cache path and checkpoint provenance.

### ACT_STATA_ADO: Prepare the exact Stata ado commands that the source invokes and set the author-configured PLUS/PERSONAL paths to a verified directory containing them.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_STATA_MISSING_ADO
Evidence: E0122, E0213

Preparation / proposed procedure:

1. Resolve the exact versions of leftalign, groups, geodist, winsor2, and matchit from an approved installation source.
2. Stage the commands under the configured Stata ado tree; preserve access to estout commands already found in the current environment.
3. Do not install packages during this assessment.

Validation to perform later:

- Run exact `which` checks in the final configured Stata environment for all invoked commands before author execution.
- Confirm the master path macros do not shadow the verified ado tree.

### ACT_PYTHON_STACK: Prepare a PyTorch/Transformers/PyTorch Lightning/tokenizer stack compatible with the author notebook’s legacy API and explicitly configured GPU runtime; retain the authored model and training settings.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_TORCH_STACK, ISSUE_MODEL_RUNTIME
Evidence: E0213, E0169, E0172, E0174

Preparation / proposed procedure:

1. Record the target PyTorch Lightning version and verify that its Trainer API supports the notebook arguments gpus=1 and num_nodes=0.
2. Provide one GPU-capable runtime if available/authorized; hardware availability is currently unverified.
3. Preserve max_epochs=200, the author callback, labels, model definitions, and tokenizer/model pairing; do not install packages during this assessment.

Validation to perform later:

- Check runtime/API compatibility and required GPU availability before any future authorized model training; package metadata alone does not establish either.

### ACT_NLTK_DATA: Resolve the NLTK sentence-tokenizer data resources required by the conference-call and press-release stages.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_NLTK_DATA, ISSUE_NLTK_RESOURCES
Evidence: E0160, E0185

Preparation / proposed procedure:

1. Determine the correct NLTK tokenizer data package for the target NLTK version.
2. Stage the approved resource in the runtime data path without running the author pipeline.

Validation to perform later:

- Confirm the configured tokenizer resource is available in the target runtime before authorized text processing.

### ACT_NOTEBOOK_ENGINE: Provide a notebook-capable runtime that preserves the author notebook’s cell order, current working directory, and configured output paths.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_JUPYTER
Evidence: E0170, E0174, E0210

Preparation / proposed procedure:

1. Select an available notebook engine compatible with the required Python/PyTorch Lightning stack.
2. Configure the staging paths and output directory used by the model workflow.

Validation to perform later:

- Check the notebook engine preserves the documented cell order and current-working-directory path contract before any authorized training run.

### ACT_SAS_RUNTIME: Resolve the SAS 9.4 batch setup using an authorized, secret-safe configuration and verify the expected imported tables and paths without exposing credentials.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISSUE_SAS_RUNTIME_CONFIG
Evidence: E0194, E0195, E0214, E0215

Preparation / proposed procedure:

1. Confirm the intended SAS runtime and data libraries using a secure local configuration supplied by the environment owner.
2. Keep credentials outside source files and logs.
3. Confirm the required [redacted-path-f6852803d934] are mapped into the target batch staging environment.

Validation to perform later:

- Verify the SAS entrypoint is available and the named source tables/paths are resolved using metadata-only checks before a future author run.
- Do not use the connection block as evidence of current data access.

### ACT_PATH_MANIFEST: Create a staging path manifest for author placeholders and cross-language handoffs while preserving the original file contents and variable definitions.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_PATH_CONFIGURATION, ISSUE_PRESS_DIR
Evidence: E0121, E0122, E0177, E0179, E0189, E0190, E0191, E0192, E0156

Preparation / proposed procedure:

1. Choose a controlled staging root compatible with the author host setup and populate YOUR_PATH/YOUR_DIRECTORY values consistently.
2. Map the Python [redacted-path-17bc19b2c3b1] and [redacted-path-5bc3db00de98] roots so the stage-5 all-call output is available to stage 6 and to the table/master consumers.
3. Map the press parser’s textual attributes and to-match file to the directories the Stata master reads.
4. Map Python returns outputs to the Stata/table paths, preserving file names, identifiers, fields, and dates.
5. Keep the main Stata ado paths available after its sysdir statements.
6. Bind the press parser DIR name to the project root for its existing relative dictionaries/LM paths; this is path setup, distinct from obtaining dictionary content.

Validation to perform later:

- Check every producer and consumer path pair in the author source text and confirm matching output schema/keys before a full run.
- Do not change analyses or synthesize missing outputs.
- Check the known project-root mapping resolves the named relative paths without changing dictionary contents.

### ACT_SAS_HANDOFF: Stage the same SAS-produced event-return dataset under the Stata consumer’s configured path/name after confirming the source-supported event and return fields.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_SAS_EVENT_HANDOFF
Evidence: E0151, E0152, E0153, E0193, E0194, E0195, E0196

Preparation / proposed procedure:

1. Map SAS input [redacted-path-8e7b77b1bb51] Merge Factiva and Link Table to the Stata-generated event-link file.
2. Map the SAS work.es4 output to the Stata path/name for the 2022-10-08 sample without changing the event or return transformations.
3. Preserve the output columns carried by SAS (an, permno, publication date, d, ret, decret, and market-return fields).
4. Confirm that the dated stock/index/portfolio inputs match the author event period.

Validation to perform later:

- Check the output file contains the event accession key, event day, and return columns expected by Stata; check date coverage and unique event/day structure with bounded metadata before any full analysis.

### ACT_IMPORT_NAMESPACE: Resolve the author’s Python import namespace contract for diversity_regex, commons.components, commons.utils, and DenseLayer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_LOCAL_PYTHON_NAMESPACES
Evidence: E0172, E0173, E0183, E0184, E0210

Preparation / proposed procedure:

1. Locate the exact external author module package/version or documented path setup that provides the imported names.
2. Confirm the supplied helper files are intentionally mapped into those namespaces.
3. Do not invent a DenseLayer implementation or infer absence from this package inventory.

Validation to perform later:

- Verify the documented module exports and class inheritance contract in the target environment before running the notebook or regex stages.

### ACT_TQDM_IMPORTS: Add the missing tqdm import in the two standalone table scripts; no calculations or table definitions change.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_TQDM_IMPORTS
Evidence: E0198, E0199, E0200, E0201, E0203, E0213

**Proposed edit:** `tables/table_01.py:1–1`
Source SHA-256: `db2ef7dcdd07fde4778c1bd42e2eb87eda316618c15a0518303606268da4053e`

The standalone table calls tqdm but its import section does not import that name.

Current text:
```
import pandas as pd
```

Proposed replacement:
```
import pandas as pd
from tqdm import tqdm
```

**Proposed edit:** `tables/table_05.py:2–2`
Source SHA-256: `52face98d5d1f70b7dfbea95460bd58ff6d1b78292b46342f8fc78f02e28432f`

The standalone table calls tqdm but its import section does not import that name.

Current text:
```
import os
```

Proposed replacement:
```
import os
from tqdm import tqdm
```

Preparation / proposed procedure:

1. Apply the two one-line import edits below after reviewing their frozen hashes.

Validation to perform later:

- Confirm the imported name is available from the staged tqdm distribution; execute the table scripts only after all data are staged and an execution step is authorized.

### ACT_SAS_PERIOD_MAP: Confirm the exact date/vintage compatibility of the SAS event-return inputs and its Stata-named 2022-10-08 consumer file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_SAS_EVENT_HANDOFF
Evidence: E0152, E0193, E0195, E0197

Preparation / proposed procedure:

1. Compare the named CRSP files and event-link sample to the expected event period and return columns.
2. If the source contract supports it, stage the same es4 output by path/name only; do not invent a replacement transformation.

Validation to perform later:

- Confirm the Stata event-window input dates, event identifiers, event-day index, ret, and decret fields match the SAS producer schema.

### ACT_CHECKPOINT_PATH_SETUP: Configure the training-stage output root so the same-run generated checkpoint is staged under the notebook’s known consumer path, lightning_logs/initiatives/checkpoints.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_CHECKPOINT_PATH
Evidence: E0174, E0175, E0176

Preparation / proposed procedure:

1. Set the notebook working directory and Lightning output root so the training callback writes to the existing lightning_logs/initiatives/checkpoints path consumed later.
2. Keep the produced checkpoint and declared tokenizer/model definitions with the same manual-label training run.

Validation to perform later:

- Confirm the configured producer output is the same directory read by the notebook’s downstream load cell and retain the val_loss/mode=min callback.

### ACT_CHECKPOINT_SELECTION: Resolve only the checkpoint-selection ambiguity when the declared directory contains multiple .ckpt files or framework-versioned subdirectories; preserve the author’s val_loss minimum criterion and model/label version.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_CHECKPOINT_SELECTION
Evidence: E0171, E0174, E0175, E0176, E0243

Preparation / proposed procedure:

1. Keep ModelCheckpoint(monitor=val_loss, mode=min) and the authored training/checkpoint files.
2. If the consumer directory has multiple candidates, record the exact same-run file selected by the source’s os.listdir(...).pop() behavior and whether it corresponds to the callback’s minimum.
3. Preserve the model definitions, tokenizer revision, and manually edited labels that produced the selected checkpoint; do not introduce a guessed selector.

Validation to perform later:

- Before future authorized inference, verify the loaded file is the same-run checkpoint selected under the source-defined callback and the directory-selection behavior is unambiguous.


## Remaining issues and prerequisites

- ISSUE_INCOMPLETE_DATA_INVENTORY [unresolved; full_pipeline]: The assigned inventory has ten data-identifier CSVs, two documents, and 28 code containers, but no author-prepared full analysis datasets or raw source snapshots. The product-specific routes are therefore unverified.
- ISSUE_ISS_VINTAGE [unresolved; full_pipeline]: The datasheet records an ISSDD purchase in February 2022, while the master’s filename macro is 2021-10-01. These dates describe purchase timing and a source-file key, not contradictory release dates. The macro-to-release mapping, exact monthly fields, and coverage remain unverified.
- ISSUE_LEGACY_AA_MATCH [unresolved; full_pipeline]: The current master merges against a prepared 2021-09-17 archive match file referenced in the source but not produced by the assigned workflow or included in the assigned inventory. Its schema and compatibility remain unknown.
- ISSUE_PATH_CONFIGURATION [preparation; full_pipeline]: The main Stata and table files use YOUR_PATH/YOUR_DIRECTORY macros and reset Stata ado directories; Python stages use [redacted-path-17bc19b2c3b1] and [redacted-path-b4e6409b103a] files also use different directory roots (including the press-release text file, matching CSV, all-call exposure CSV, and return datasets).
- ISSUE_SAS_EVENT_HANDOFF [preparation; full_pipeline]: The SAS bridge creates a work.es4 event-window dataset with event and return fields, then exports it to a Windows es4.dta path; Stata expects a differently named file under its configured intermediate tree. Align the same supported producer/consumer dataset by staging path/name and confirm period/fields before running.
- ISSUE_SAS_RUNTIME_CONFIG [unresolved; full_pipeline]: The SAS source contains an opaque connection/setup block withheld by the secret-safe scan. Its connection behavior and required table availability were not assessed, and the existing SAS environment record is unverified.
- ISSUE_LOCAL_PYTHON_NAMESPACES [unresolved; full_pipeline]: Drivers import diversity_regex while the supplied regex helper is named 0_racial_diversity_regex.py. The notebook imports commons.components and commons.utils, while the provided component inherits DenseLayer without a local import/definition. These names may be supplied by an external author namespace, so availability is not inferred; exact module/source/version/export contracts are unresolved.
- ISSUE_PRESS_DIR [preparation; full_pipeline]: The press parser refers to DIR when resolving its already named relative dictionaries/LM paths. Bind DIR to the project root during ordinary path setup; the dictionary files and their content/version remain a separate input requirement.
- ISSUE_MANUAL_LABELS [unresolved; full_pipeline]: The stage writes blank labels and the random 1,000-row workbook is selected with sentence and initiatives fields, while the notebook later expects both initiatives and past_actions. The author-edited label file, annotation instructions, and final schema are not supplied.
- ISSUE_CHECKPOINT_PATH [preparation; full_pipeline]: The notebook’s training output must be staged where its later cell looks for checkpoints: lightning_logs/initiatives/checkpoints. This is a known path/root setup; the callback uses val_loss with mode=min. File-selection semantics when multiple checkpoints exist are tracked separately.
- ISSUE_TQDM_IMPORTS [preparation; full_pipeline]: The two standalone Python table scripts call tqdm but their complete import sections do not import tqdm. The distribution is present, but a direct script run has no documented external namespace setup for this name.
- ISSUE_NLTK_RESOURCES [unresolved; full_pipeline]: The Python code calls NLTK sentence tokenization; the matching punkt/punkt_tab resources are not covered by package metadata and were not inspected.
- ISSUE_MODEL_RUNTIME [unresolved; full_pipeline]: The notebook configures Lightning Trainer with gpus=1, num_nodes=0, and max_epochs=200. GPU availability and compatibility of these legacy arguments with the installed PyTorch Lightning API are unverified; preserve the authored settings until compatibility is established.
- ISSUE_CHECKPOINT_SELECTION [unresolved; full_pipeline]: The notebook searches lightning_logs/initiatives/checkpoints and takes one .ckpt entry through os.listdir(...).pop(). The callback monitors val_loss with mode=min, but behavior with multiple/default-versioned checkpoint files and correspondence to the selected minimum is not specified. Preserve the same model definitions and manual labels; do not guess a selector.
- REQ_ISSDD [undetermined]: Monthly ISS Director & Executive Diversity history requested through the Stata master’s 2021-10-01 file-date macro; the February 2022 purchase date is provenance, not a conflicting release date.
- REQ_AUDIT_ANALYTICS [undetermined]: Audit Analytics Director and Officer Changes fields used to merge director actions with ISS person/company records and event filings.
- REQ_AA_LEGACY_MATCH [undetermined]: The older 2021-09-17 prepared ISS–Audit Analytics match dataset explicitly merged with the current match.
- REQ_BLS_INPUTS [undetermined]: BLS employment inputs and industry/NAICS crosswalk workbooks required to construct employment diversity measures; includes 2019 public data, a BLS-staff 2020 file, and 2021 forward-filled values.
- REQ_CENSUS_2019 [undetermined]: The 2019 Census state population-by-characteristics file used with the 2021 estimate file to build state race/ethnicity shares.
- REQ_CENSUS_2021 [undetermined]: The 2021 Census state population-by-characteristics file used in the same author construction.
- REQ_EDGAR_FORM8K [undetermined]: Author-derived 2014–2021 Form 8-K CSVs with accession, form type, items, CIK, company name, filing date, and period fields; the master keeps filings whose items contain 5.02.
- REQ_COMPUSTAT [undetermined]: Annual Compustat records filtered to domestic, consolidated, standardized USD industrial statements; firm-year accounting, R&D, size, and age controls use GVKEY/FYEAR and DATADATE.
- REQ_CCM_LINKS [undetermined]: CRSP–Compustat link rows used by Stata to join tickers, firms, CUSIPs, securities, and event/firm dates through effective link intervals.
- REQ_CRSP_DAILY [undetermined]: 2021-11-02 CRSPQ daily source used in Stata for security/date/CUSIP matching, latest-date-per-CUSIP selection, and daily date calendars.
- REQ_CRSP_INDEX [undetermined]: Daily CRSP market-index calendar and VWRETD/EWRETD series joined to SAS event dates.
- REQ_CRSP_PORTFOLIO_RETURNS [undetermined]: Prepared CRSP event-study portfolio records keyed by PERMNO/DATE and joined with CAPN, RET, and DECRET in SAS.
- REQ_IBES_SURPRISE [undetermined]: Quarterly EPS Surprise History rows aligned by official ticker and announcement date to construct the author’s standardized unexpected-earnings score.
- REQ_TR_AGGREGATE [undetermined]: Quarterly Thomson Reuters aggregate ownership observations used to construct CUSIP/report-date concentration and ownership-percentage controls.
- REQ_TR_S34 [undetermined]: Quarterly Thomson Reuters s34 institutional holdings used to compute CUSIP/report-date ownership shares and Big Three indicators from manager-level filings.
- REQ_BLOOMBERG_SP [undetermined]: Bloomberg S&P 500/400/600 membership identifiers used to add index membership around firm-year dates.
- REQ_B2C [undetermined]: The Delgado/Mills B2C industry categorization file used in firm classification.
- REQ_ZIP_CODES [undetermined]: The Zip Codes.com Deluxe zip-code database used to map ISS firm headquarters to state, city, county, and coordinates.
- REQ_AS_YOU_SOW [undetermined]: The As You Sow quarterly RJI/DEI data and associated data dictionaries/weights used in table and firm-response construction.
- REQ_FACTIVA [undetermined]: The Factiva press-release corpus snapshot (Rice Snapshot 8-18-22) used for textual and event-link measures.
- REQ_RAVENPACK [undetermined]: The RavenPack press-release file dated 2022-09-02 used with the Factiva material.
- REQ_CONFERENCE_CALL_CORPUS [undetermined]: Seeking Alpha transcript metadata and parsed interaction files used by the conference-call pipeline. The metadata CSV is not itself the full transcript/interactions corpus.
- REQ_LM_DICTIONARIES [undetermined]: The positive and negative Loughran–McDonald dictionaries read by the conference-call sentiment and press-release parsing stages.
- REQ_MANUAL_LABELS [undetermined]: Manually curated initiative and past-action training labels for the 1,000 sampled transcript sentences, with the exact author label definitions and final workbook schema.
- REQ_ROBERTA_BASE [public_acquisition_required]: Public pretrained RoBERTa base weights and tokenizer referenced by the author’s model workflow.
- REQ_CRSP_CALL_CALENDAR [undetermined]: 2022-04-15 CRSP daily date keys used to form the conference-call trading-day calendar.
- REQ_CRSP_DSF_EVENT [undetermined]: 2022-10-07 CRSP daily-stock file used by the SAS event study, keyed to event securities and dates.
- SW_TORCH_STACK [preparation_required]: The target Python metadata did not find torch, transformers, pytorch-lightning, or tokenizers. Separately, the notebook requests gpus=1, num_nodes=0, max_epochs=200 through a legacy Lightning Trainer API; GPU and API compatibility are unverified. No package was installed.
- SW_NLTK_DATA [unverified]: The code uses NLTK sentence tokenization, but the required tokenizer data resources were not inspected or tested.
- SW_JUPYTER [unverified]: A substantive notebook is a required stage; notebook engine availability and execution semantics were not checked.
- SW_STATA_MISSING_ADO [preparation_required]: Exact `which` metadata lookups did not find these commands in the default or pre-recorded shared ado paths. The master later resets PLUS/PERSONAL/OLDPLACE to placeholders.
- SW_SAS [unverified]: The existing environment record marks the SAS entrypoint unverified after a nonzero metadata startup attempt; this assessment did not start SAS or inspect the failure stream.

## Review notes

- Assessment covers only this assigned package and the complete supplied Stata, Python, SAS, and table workflow. No author code, model, data payload, or SAS program was executed; model files were not downloaded or deserialized.
- The 40-item frozen inventory is the count authority. Its ten data items are data-identifier CSVs; they do not verify full analysis datasets, periods, access, or author-prepared inputs.
- The source reader withheld complete connection/auth candidate blocks. No credentials or endpoint requests were printed, used, or attempted.
- The frozen catalog is metadata only. Matching common product tables are candidates; catalog misses do not establish absence, license barriers, or incompatibility.
- RoBERTa has a public compatible model/tokenizer repository candidate, but no pinned revision, weights, tokenizer files, or trained checkpoint were acquired. The manual label and external commons/DenseLayer interfaces remain unresolved.
- The finalizer will compute scope data/readiness fields and keep execution_verified false; closure remains incomplete until named data routes, software setup, and external interfaces are resolved.
- The datasheet mentions a Google Trends download (E0107), but no supplied driver, table input, or output contract identifies it as part of the full supplied workflow. It is retained as source-history context only; no replacement series or mandatory input is inferred. The exact catalog alias check (E0212) is discovery metadata, not evidence of absence.
