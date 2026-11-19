# Patch proposal: jar-71d04669efdd

Coins for Bombs: The Predictive Ability of On-Chain Transfers for Terrorist Attacks

DOI: 10.1111/1475-679X.12430

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete author-documented Bitcoin data collection, event construction, daily aggregation, event-study bootstrap and machine-learning workflow, including the separate supplied XRP transfer-plot branch.

Entry points: `Codes/get_Wallets_Ownership.R`, `Codes/get_Bitcoin_Data.R`, `Codes/get_Onchain_Transfers.R`, `Codes/parse_Wallet.R`, `Codes/get_Notable_Events.R`, `Codes/run_Raw.R`, `Codes/run_Boot.R`, `Codes/run_ML.R`, `Figures/plotXRPtransfers.R`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Separate supplied XRP transfer plotting branch only: read the packaged Figure 3 workbook and produce its long and short date-window plots; this does not reproduce the Bitcoin panel, event study, or machine-learning results.

Entry points: `Figures/plotXRPtransfers.R`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 2/12430 - Coins-for-Bombs-The-Predictive-Ability-of-On-Chain-Transfers-for-Terrorist-Attacks/ajr-datasheet-code-and-identifiers.zip",
      "sha256": "cf4d327d30c6a58d0cfdd962d96b2fb29241752cf4d54f8fdb89bff9528d129e"
    },
    {
      "path": "JAR-Volume 60/Issue 2/12430 - Coins-for-Bombs-The-Predictive-Ability-of-On-Chain-Transfers-for-Terrorist-Attacks/ajr-online-appendix.pdf",
      "sha256": "b9b9d8f022e8e59b79557e5415b034266b6c97a516f9649896e7202e39469bd7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "0b230e13b4b507e4cf10e53f482820874afd554cb65809ca5dd2ab6fc1802a44"
}
```

## Proposed actions

### A_WALLET_NAMES: Confirm the author wallet-name snapshot and its identity coverage across the 2015-2019 study window. WalletExplorer's current official documentation reports that its name database has been largely unchanged since 2016, so its public API is a candidate discovery route rather than a verified substitute for the author's labels.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WALLET_NAMES, I_WALLET_COVERAGE
Evidence: E_WALLET_SCRAPE, E_WALLET_INFO, E_WALLET_API

Preparation / proposed procedure:

1. Obtain the author-documented wallet cohort or label-source snapshot and record its date coverage and category definitions.
2. If using the public WalletExplorer route, confirm the required historical name coverage and the exact page/API fields before using it as an input; do not assume newer source labels replicate the author's list.
3. Keep any address-to-wallet mapping in the working data area and omit address and label records from the assessment output.

Validation to perform later:

- After authorized input preparation, compare the mapped wallet set and study-date coverage with the author specification without publishing underlying address or label records.

### A_RAW_TRANSFERS: Obtain the author's prepared per-wallet transaction CSV contract or a documented producer that creates it. The supplied onchain USER RData and parse_Wallet DF RData have different fields and do not establish the run_Raw CSV input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RAW_TRANSFERS, I_HANDOFFS
Evidence: E_RAW, E_RAW_TX_FIELDS, E_RAW_SENTTO, E_RAW_DATE, E_RAW_FIELDS, E_RAW_COUNTERPARTIES, E_ONCHAIN_SCHEMA, E_PARSE_OUTPUT, E_WALLET_API

Preparation / proposed procedure:

1. Request the prepared CSV schema, its documented producer and date/amount units for wallet, date, received_amount, sent_amount, sent_to, balance, transaction and received_from.
2. Keep get_Onchain_Transfers USER RData and parse_Wallet DF RData as distinct outputs; do not deserialize either file or invent a conversion to the required CSV.
3. Use an author-confirmed prepared CSV route as the primary source if it supplies the required contract; retain raw page/API collection as conditional context.

Validation to perform later:

- After authorized input preparation, inspect only the CSV header, column types and documented date range before running run_Raw; compare the generated summary to the source specification without reconstructing the study independently.

### A_LABELS: Request the documented conversion from the packaged category workbook to the labels.csv ID/TYPE crosswalk. The bounded workbook probe does not establish how category columns map to wallet identities or TYPE values.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LABELS, I_HANDOFFS
Evidence: E_LABEL_PROBE, E_RAW_OUTPUT

Preparation / proposed procedure:

1. Obtain the author crosswalk schema, category mapping and intended conversion steps for labels.xlsx to labels.csv.
2. Convert the workbook only after the ID and TYPE mapping is supported; keep all wallet identifiers and label records out of audit outputs.

Validation to perform later:

- After authorized conversion, confirm labels.csv has ID and TYPE columns and that its source category mapping matches the author's description without exposing row values.

### A_BTC_PRICES: Request the source and producer for the BTC object consumed by run_Raw, including date coverage and quote units.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BTC_PRICES, I_HANDOFFS
Evidence: E_RAW_BTC

Preparation / proposed procedure:

1. Obtain the author's daily price input or documented producer for BTC$Date and BTC$Close, with units, date format and coverage for processed transaction dates.
2. Preserve the source's 3600 fallback for unmatched dates unless the author specifies an exact alternative.

Validation to perform later:

- After authorized input preparation, verify Date/Close coverage and price units against the author's source documentation; do not replace the fallback based on guesswork.

### A_GTD: Acquire the GTD workbook through START's documented 1970-2020 XLSX route after authorized form access, then compare its release and required columns with the author's named 0221dist file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_GTD, I_EVENTS
Evidence: E_GTD_LANDING, E_GTD_FORM, E_EVENT_GTD, E_GTD_DATE, E_GTD_COUNTRY, E_GTD_ATTACK, E_GTD_WEAPON, E_GTD_NATLTY

Preparation / proposed procedure:

1. Use the official START download form and accept its terms through the authorized data-acquisition process; no form was submitted and no workbook payload was requested in this assessment.
2. Save the authorized workbook in the configured event-data directory under the filename expected by get_Notable_Events.R, or document the exact supported path configuration.
3. Compare the acquired release with the author's 0221dist snapshot and confirm the required date, country, nationality, attack-type and weapon-type fields for 2015 through 2019-04-30; do not redistribute raw GTD data.

Validation to perform later:

- After authorized acquisition, use a bounded workbook header/date-range check and record the exact release and fields before event construction.

### A_WIKI_EVENTS: Resolve the raw Wikipedia input, directory, and event-state contracts while preserving the supplied Country-from-Location cleanup and explicit overrides. The Year/Day versus WIKI$Date input, CSV path, WIKI_Notables route, and global DATES versus GTD$DATES state sequence remain unverified.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WIKI_EVENTS, I_EVENTS
Evidence: E_WIKI_WRITE, E_EVENT_WIKI, E_EVENTS, E_EVENT_MATCH, E_EVENT_LOADS, E_EVENT_DATES, E_EVENT_GTD, E_COUNTRY_FROM_LOCATION, E_COUNTRY_NORMALIZATION, E_EVENT_MANUAL_OVERRIDES, E_ML_DATES, E_BOOT_DATES

Preparation / proposed procedure:

1. Preserve the supplied Country-from-Location parsing, alias normalization, and manual overrides. Confirm the author's raw WIKI_NOTABLE_ATTACKS.csv headers/date representation and whether the collector's Year/Day output supplies the cleaner's WIKI$Date input; do not invent a conversion or replacement country mapping.
2. Choose one event working directory and document the matching WIKI_NOTABLE_ATTACKS.csv write/read paths across the collector and cleaner; do not assume equal basenames in different directories identify the same file.
3. Keep the date vectors distinct: get_Notable_Events.R creates global DATES from filtered GTD$Date, and run_ML consumes that global without resetting the environment, so ordered execution in one R session may provide a handoff. run_Boot reloads GTD_Notables.RData and constructs/sorts/prunes a separate DATES vector from GTD$DATES. Confirm that member's producer and the intended event cohort/order, and whether WIKI_Notables.RData is a separately supplied input; do not invent saves, renames, or filters. The supported GDT-to-GTD edit changes only the saved object identifier.

Validation to perform later:

- Before a later authorized run, confirm the raw CSV field/date format and writer/read directories; then statically reconcile the event producer's global DATES with run_ML's same-session use and separately identify the GTD$DATES member consumed after run_Boot reload. Confirm the WIKI_Notables.RData route and preserve the authored event filters/cohort.

### A_EVENT_SAVE_NAME: Correct the supported save-object name mismatch so the event producer saves GTD for the later GTD_Notables.RData load; this does not establish the separate GTD$DATES member or resolve the Wikipedia input and state contracts.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_EVENTS
Evidence: E_EVENT_GTD, E_EVENT_SAVES, E_EVENT_LOADS

**Proposed edit:** `Codes/get_Notable_Events.R:164–164`
Source SHA-256: `97c6fbb505d108ca9472b0cc994dc0edf2fd715c5559a5fbc87b1b2baad96c05`

The event code builds and filters an object named GTD; the save statement uses GDT, which is not the object name used in the supplied code. Saving GTD retains the authored table and filename without changing event definitions.

Current text:
```
save(GDT,file="GTD_Notables.RData")
```

Proposed replacement:
```
save(GTD,file="GTD_Notables.RData")
```

Preparation / proposed procedure:

1. Apply the one-line change in a working copy only after the unresolved event-table and working-directory contracts are documented.

Validation to perform later:

- Statically confirm the saved object name matches the later GTD_Notables.RData load. Separately establish whether the saved GTD contains the GTD$DATES member read by run_Boot; this one-line edit does not create that member.

### A_BOOT_GROUPS: Obtain the five wide daily group CSVs or the author's exact producer, date index, wallet columns and construction details.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BOOT_GROUPS, I_HANDOFFS
Evidence: E_BOOT, E_RAW_OUTPUT

Preparation / proposed procedure:

1. Confirm the input contract and producer for EXCHANGE.csv, MIXER.csv, DARKMARKET.csv, SERVICE.csv and GAMBLING.csv, including row order, date column and naming of wallet series.
2. If the author confirms a route through run_Raw outputs, document the supported pivot/aggregation from per-wallet type-specific files to each group table; do not infer a wide layout from the filenames.

Validation to perform later:

- After author confirmation, verify all five file headers and date alignment against the event-study input contract before bootstrapping.

### A_AGG_PANEL: Request the producer and schema for AGG. The supplied run_Boot source creates ALL from the five group tables but consumes AGG directly; no supported equivalence or producer is shown.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AGG_PANEL, I_HANDOFFS
Evidence: E_BOOT, E_BOOT_AGG, E_BOOT_WINDOW

Preparation / proposed procedure:

1. Obtain the author's AGG panel construction, date indexing, series names, units and relationship to EXCHANGE/MIXER/DARKMARKET/SERVICE/GAMBLING.
2. Keep the source's seed 12345, 50 bootstrap repetitions and 45-day event window; do not rename ALL to AGG or alter the estimator without author evidence.

Validation to perform later:

- After the producer contract is confirmed, compare the AGG row/date and column/series layout with the exact eventstudy call before running it.

### A_ML_USER: Request the complete author-prepared USER.csv and omitted per-user loop/feature producer contract before attempting run_ML.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ML_USER, I_ML, I_HANDOFFS
Evidence: E_ML, E_BTC_OUTPUT, E_ML_SETTINGS, E_ML_FEATURES, E_ML_MODELS

Preparation / proposed procedure:

1. Obtain the USER.csv producer, column names/meanings, joins and the intended scope of columns 4:20; do not convert USER RData or invent feature definitions.
2. Confirm the omitted outer-loop/session context for next() and the intended meaning of the bare SVM line before proposing code changes.
3. Preserve the suspicious-case SIGMA1 filter, event-neighborhood test restriction, final chronological 70 percent split, 10-fold CV, seed 10 and ntree 500 as authored.

Validation to perform later:

- After receiving the complete input and loop contract, verify train/validation columns and chronological ordering, then run the author-specified models only in a separately authorized execution step.

### A_ANALYSIS_SOFTWARE: Prepare the three missing R packages used by the supplied XRP plot. CRAN lists rJava and xlsxjars as xlsx imports and Java as a system requirement; Java is present but the bridge/import packages have not been separately verified.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: SW_XLSX, SW_DATA_TABLE, SW_GGPLOT2
Evidence: E_RPKG, E_PLOT, E_PLOT_PKG, E_XLSX_CRAN, E_AUX

Preparation / proposed procedure:

1. In the chosen R 4.5.0 environment, install the required xlsx, data.table and ggplot2 packages from their official R repositories after authorizing software preparation.
2. Confirm xlsx's rJava/xlsxjars imports initialize with the available Java runtime; do not open, refresh or recalculate the workbook through a GUI.

Validation to perform later:

- Check package availability and the xlsx Java bridge through package metadata and a bounded workbook header read before any plot run.

### A_FULL_R_PACKAGES: Prepare the remaining missing R packages required by the full author workflow in the selected R environment; no package was installed during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_RVEST, SW_STRINGR, SW_RSELENIUM, SW_READXL, SW_PLYR, SW_RANDOMFOREST, SW_CARET, SW_E1071, SW_CATOOLS, SW_PSYCH
Evidence: E_RPKG, E_WALLET_SCRAPE, E_ML_PACKAGES, E_EVENT_GTD, E_SELENIUM

Preparation / proposed procedure:

1. Install rvest, stringr, RSelenium, readxl, plyr, randomForest, caret, e1071, caTools and psych from the authorized R package repository for the selected R 4.5.0 library.
2. Keep the existing nnet installation and Java/Firefox availability; do not upgrade model or scraper dependencies without a compatibility reason.

Validation to perform later:

- Confirm each package and its required functions are available in the selected R library before preparing any author workflow inputs.

### A_EVENTSTUDIES_VERSION: Resolve the eventstudies package release used by the author. The public repository documents stable v1.2.2, but the supplied code does not pin a version.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_EVENTSTUDIES
Evidence: E_RPKG, E_BOOT_PACKAGE, E_BOOT_WINDOW, E_EVENTSTUDIES_REPO

Preparation / proposed procedure:

1. Confirm the author-compatible eventstudies release and its eventstudy signature before selecting a package version; treat stable v1.2.2 as a documented candidate, not a verified author version.
2. Install the confirmed package in the selected R library only after that release check.

Validation to perform later:

- Compare the installed eventstudy formals and return structure with the supplied call before running the bootstrap stage.

### A_FULL_PATHS: Set one documented working-copy data root and per-stage read/write directories after the author input locations are known. Current local-address placeholders and changed working directories do not identify the intended paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PATHS
Evidence: E_RAW, E_BOOT, E_ML, E_ML_PATH

Preparation / proposed procedure:

1. Record the working-copy package root, raw transaction directory, label directory, event-data directory and output directories for run_Raw, get_Notable_Events, run_Boot and run_ML.
2. Align every producer and consumer path for WIKI_NOTABLE_ATTACKS.csv, GTD_Notables.RData, the five group CSVs, AGG, USER.csv and result files; retain distinct objects and schemas.
3. Replace a source path only after its replacement directory is known; do not guess a path from a placeholder or from another user's Windows directory.

Validation to perform later:

- Statically compare each read/write location after the directory map is documented; check output names and consumer paths without launching R code.

### A_SELENIUM_SETUP: Confirm the active Selenium branch's intended role, pre-existing remDr session, browser setup and OS-specific process cleanup before the full acquisition script is run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_ACTIVE_SELENIUM
Evidence: E_SELENIUM, E_TASKKILL, E_RPKG, E_AUX

Preparation / proposed procedure:

1. Ask whether the Selenium block is part of the intended acquisition route despite its '#not run' comment; the executable statements remain active in the file.
2. Confirm how remDr is initialized before remDr$close(), which RSelenium/Firefox/Java versions are supported and what cleanup command is appropriate on the Linux host.
3. Keep the click loop and additional-address capture intact unless the author confirms an alternative; do not launch a browser during this assessment.

Validation to perform later:

- Once the author confirms the setup, review the browser/session and cleanup configuration statically before any authorized launch.

### A_XRP_PATH: Make the supplied plot resolve its packaged Figure 3 workbook when launched from the package root.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: I_XRP_PATH
Evidence: E_PLOT, E_FIG3_PROBE, E_README

**Proposed edit:** `Figures/plotXRPtransfers.R:2–2`
Source SHA-256: `4f401c196a2e3a3b3c49003fda48f8649348262911a23a8a582ff9cad8e3d607`

The source's workbook is packaged under Figures and the script immediately reads its filename relative to the working directory. Running from the package root makes Figures the supported relative directory without changing the data or plot windows.

Current text:
```
setwd("[redacted-path-6c4b9ce0efd6]")
```

Proposed replacement:
```
setwd("Figures")
```

Preparation / proposed procedure:

1. Apply this one-line edit only in a working copy and launch the plot with the package root as the current directory.

Validation to perform later:

- Confirm that Figures/Figure 3 Data.xlsx resolves from the package root and that both authored date windows and plot series remain intact; inspect date coverage before producing figures.

### A_FULL_ORDER: Ordered, conditional full workflow for the supplied programs. It retains each authored branch and names the producer-consumer chains while leaving the unsupported schemas and event handoffs explicit.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_WALLET_NAMES, R_RAW_TRANSFERS, R_LABELS, R_BTC_PRICES, R_WIKI_EVENTS, R_GTD, R_BOOT_GROUPS, R_AGG_PANEL, R_ML_USER, R_XRP, I_HANDOFFS, I_EVENTS, I_ML, I_PATHS, I_ACTIVE_SELENIUM, I_WALLET_COVERAGE, I_XRP_PATH
Evidence: E_README, E_WALLET_SCRAPE, E_WALLET_X, E_BTC_USER, E_BTC_OUTPUT, E_BTC_ADDITIONAL, E_ONCHAIN_SCHEMA, E_PARSE_INPUT, E_PARSE_OUTPUT, E_RAW, E_RAW_OUTPUT, E_RAW_BTC, E_EVENT_GTD, E_EVENT_SAVES, E_EVENT_LOADS, E_EVENT_DATES, E_BOOT, E_BOOT_AGG, E_BOOT_WINDOW, E_ML, E_PLOT, E_FIG3_PROBE, E_COUNTRY_FROM_LOCATION, E_COUNTRY_NORMALIZATION, E_EVENT_MANUAL_OVERRIDES, E_ML_DATES, E_BOOT_DATES

Preparation / proposed procedure:

1. 1. Configure one working-copy root and stage directories only after the author data paths are known; resolve all current local-address placeholders and absolute paths consistently.
2. 2. Run get_Wallets_Ownership.R as the wallet-page acquisition stage: its source writes links.csv and wallet-specific X RData files. The WalletExplorer request/data route and 2015-2019 name coverage remain unverified.
3. 3. Keep the X-based collection branches separate: get_Bitcoin_Data.R reads X RData and saves USER/AdditionalAddresses RData; get_Onchain_Transfers.R also reads X and saves a different USER RData with Date, Value and Balance. parse_Wallet.R separately loads RData containing l and saves DF RData; its matching l producer and compatibility with the other outputs are unresolved.
4. 4. Run_Raw.R can proceed only after the author-compatible per-wallet transaction CSV, labels.csv and BTC object are prepared. It emits type-specific daily exports and SUMMARY_USD.csv; the supplied scrapers do not establish the required transaction CSV or five downstream wide table formats.
5. 5. Prepare the event stage in order: align WIKI_NOTABLE_ATTACKS.csv writer/reader directories and confirm that the collector's Year/Day output is compatible with the cleaner's WIKI$Date input. Retain the supplied Country-from-Location cleanup, aliases, and manual corrections. In a working copy, use the supported GDT-to-GTD save-name edit. Keep later event state separate: get_Notable_Events.R creates global DATES from filtered GTD$Date, which run_ML can consume in the same R session; run_Boot reloads GTD_Notables.RData and reads/sorts/prunes GTD$DATES. Confirm the GTD$DATES member and intended cohort/order, and whether WIKI_Notables.RData is supplied, before continuing; do not invent saves, member renames, or filters.
6. 6. Run_Boot.R consumes EXCHANGE.csv, MIXER.csv, DARKMARKET.csv, SERVICE.csv and GAMBLING.csv plus GTD_Notables.RData and AGG; its locally constructed ALL is not established as AGG. Retain seed 12345, 50 bootstrap repetitions and event.window 45.
7. 7. Run_ML.R consumes USER.csv and GTD_Notables.RData. Obtain its complete feature producer and omitted outer-loop/session context before attempting it; retain the SIGMA1 filter, event-neighborhood test subset, chronological 70 percent split, 10-fold CV, seed 10 and 500-tree setting.
8. 8. Keep Figures/plotXRPtransfers.R as the separate companion branch using Figures/Figure 3 Data.xlsx; after its relative-path and R-package preparation, its two authored plot windows can be checked independently.

Validation to perform later:

- Before a later authorized full run, verify each input filename, data type, header and period against its named consumer, with raw wallet/label records withheld from reports.
- Confirm the event CSV writer/reader path and raw schema, the same-session global DATES handoff to run_ML, the distinct GTD$DATES member consumed by run_Boot, and the WIKI_Notables.RData route before event-study or ML work; confirm group panel/AGG and USER.csv contracts separately.
- Do not deserialize RData objects, download any dataset, launch the Selenium/browser branch, or run author code during this assessment.

### A_XRP_RUN: Run the independent XRP plotting branch after the supported relative-path proposal and missing plot packages are prepared.

Scopes: full_pipeline, analysis_only. Type: run_procedure. Certainty: supported.
Addresses: R_XRP, I_XRP_PATH
Evidence: E_README, E_PLOT, E_FIG3_PROBE, E_PLOT_PKG, E_XLSX_CRAN

Preparation / proposed procedure:

1. From the package root, enter Figures through the proposed relative path and read Figure 3 Data.xlsx with the supplied xlsx reader.
2. Retain the source's Date/Total/In/Out aggregation, long plot window and short plot window; do not substitute or transform the workbook.
3. Keep this companion branch separate from the Bitcoin event-study and ML input chain.

Validation to perform later:

- Check the full workbook date span and required headers after authorized preparation, then compare the two resulting plots to the supplied author figure artifacts.


## Remaining issues and prerequisites

- I_HANDOFFS [unresolved; full_pipeline]: Supplied wallet acquisition paths produce WalletExplorer X.RData, per-wallet AdditionalAddresses, onchain USER.RData, or parse_Wallet DF.RData with different schemas. No supplied stage exports the run_Raw transaction CSV with its complete field contract; the labels workbook does not establish labels.csv; and the source does not identify producers or schemas for the five run_Boot wide group CSVs, AGG, or run_ML USER.csv. Preserve each handoff and do not substitute X, USER, DF or the constructed ALL object for another schema without author evidence.
- I_EVENTS [unresolved; full_pipeline]: The remaining event contracts are unresolved after the supported directory and save-name preparation. The collector's Year/Day output versus the cleaner's raw WIKI$Date input and the CSV writer/read paths across working-directory changes have not been confirmed against the author's cleaned input. The supplied cleaner does derive Country from Location and applies the documented aliases/manual corrections. Event state also depends on execution order: get_Notable_Events.R creates a top-level DATES vector from filtered GTD$Date; run_ML consumes global DATES without resetting the environment, so a same-session handoff is possible. run_Boot instead reloads GTD_Notables.RData, reads the GTD$DATES member, and sorts/prunes that vector inside its loop. Whether the saved GTD object contains that member, the intended cohort/order, and whether WIKI_Notables.RData is a separate supplied input remain unknown. The proposed GDT-to-GTD save-name edit addresses only that supported identifier mismatch. These facts do not establish a separate unconditional execution failure after preparation, so the issue records unresolved closure rather than a confirmed blocker.
- I_ML [unresolved; full_pipeline]: run_ML states the original per-user loops were omitted, reads USER.csv with no compatible full feature producer, and uses columns 4:20 as predictors. The retained next() calls depend on the omitted loop context and the active bare SVM token has no supported intended replacement. Do not invent predictor names, joins, folds, loop bodies or model code.
- I_PATHS [preparation; full_pipeline]: The full workflow mixes placeholder local address paths, changed working directories, and absolute Windows paths in raw/ML scripts. The required data root and per-stage output locations are not provided, so a consistent cross-script directory mapping cannot yet be specified.
- I_ACTIVE_SELENIUM [unresolved; full_pipeline]: An active RSelenium/Firefox branch follows a '#not run' comment and calls remDr$close(), launches Firefox, clicks page controls, and issues Windows taskkill for Java. RSelenium is absent locally, and the Windows cleanup command does not match the Linux environment; this branch must remain statically reviewed until its intended role and compatible session cleanup are confirmed.
- I_WALLET_COVERAGE [unresolved; full_pipeline]: WalletExplorer's official information page says its name database has not been updated since 2016 except for rare cases; compatible 2015-2019 named-wallet attribution and the author's label list are therefore unverified.
- I_XRP_PATH [preparation; full_pipeline, analysis_only]: The XRP plot starts by changing to an absolute Windows Figures directory even though its workbook is packaged at Figures/Figure 3 Data.xlsx. A package-root launch supports a local relative path repair.
- R_WALLET_NAMES [undetermined]: WalletExplorer wallet and address classifications used to seed X.RData and later address-level collection for the author's study window.
- R_RAW_TRANSFERS [undetermined]: Per-wallet transaction CSVs consumed by run_Raw with wallet, date, received_amount, sent_amount, sent_to, balance, transaction and received_from fields. Expected fields: wallet; date; received_amount; sent_amount; sent_to; balance; transaction; received_from. Expected coverage period: Transaction dates used in the full sample; exact start and end dates for this input are not specified in run_Raw.
- R_LABELS [undetermined]: A labels.csv crosswalk with ID and TYPE columns used to classify each wallet before producing type-specific daily exports. Expected fields: ID; TYPE.
- R_BTC_PRICES [undetermined]: A daily BTC price object named BTC with Date and Close fields, used to value the raw transaction rows in USD; no producer or price source is supplied. Expected fields: Date; Close. Expected coverage period: Every wallet transaction date being processed; source coverage and price units are unspecified.
- R_WIKI_EVENTS [undetermined]: Wikipedia event rows used to match notable events to GTD, with downstream Date, Country, Location and Year fields; manual cleaning and adjustments are described but no prepared table is included. Expected fields: Date; Country; Location; Year. Expected coverage period: 2015 to 2019-04-30 in the event workflow, with exact cleaned-page coverage unresolved.
- R_GTD [public_acquisition_required]: The GTD event-level workbook used for the 2015 through 2019-04-30 match and event filters. Expected fields: iyear; imonth; iday; country; country_txt; natlty1_txt; attacktype1_txt; weaptype1_txt; nkill; propextent_txt; ransompaid. Expected coverage period: 2015 through the day before 2019-05-01.
- R_BOOT_GROUPS [undetermined]: Five separate wide daily group CSVs: EXCHANGE.csv, MIXER.csv, DARKMARKET.csv, SERVICE.csv and GAMBLING.csv; their date, wallet-column and row contracts are unspecified.
- R_AGG_PANEL [undetermined]: The AGG daily panel consumed by run_Boot for event records and the eventstudy call; the source separately creates ALL from the five group tables but never defines AGG or shows that ALL is its equivalent.
- R_ML_USER [undetermined]: The prepared USER.csv read by run_ML, including TYPE, DATE, VOLUME, SIGMA1 and the consumed columns 4:20; full feature names, meanings, joins and a compatible producer are not supplied. Expected fields: TYPE; DATE; VOLUME; SIGMA1; columns 4:20 (remaining predictor definitions unspecified).
- SW_RVEST [preparation_required]: Required by the WalletExplorer, blockchain-page and Wikipedia scrapers; missing in the installed-package metadata probe.
- SW_STRINGR [preparation_required]: Required by supplied date and page-text processing; missing in the installed-package metadata probe.
- SW_RSELENIUM [preparation_required]: Required by the active Selenium branch in get_Bitcoin_Data.R; missing in the installed-package metadata probe.
- SW_READXL [preparation_required]: Required to read the GTD workbook in the event stage; missing in the installed-package metadata probe.
- SW_EVENTSTUDIES [preparation_required]: Required for the bootstrap eventstudy call; missing locally. The public repository documents stable v1.2.2, while the exact author release remains unspecified and the function signature should be checked before choosing a version.
- SW_DATA_TABLE [preparation_required]: Required by the supplied plotting and machine-learning scripts; missing in the installed-package metadata probe.
- SW_PLYR [preparation_required]: Attached by run_ML.R; missing in the installed-package metadata probe.
- SW_RANDOMFOREST [preparation_required]: Required by the random-forest model path; missing in the installed-package metadata probe.
- SW_CARET [preparation_required]: Required by the cross-validation/model calls; missing in the installed-package metadata probe.
- SW_E1071 [preparation_required]: Required by the SVM path; missing in the installed-package metadata probe.
- SW_CATOOLS [preparation_required]: Attached by run_ML.R; missing in the installed-package metadata probe.
- SW_PSYCH [preparation_required]: Used for the descriptive summaries in run_ML.R; missing in the installed-package metadata probe.
- SW_XLSX [preparation_required]: Required by the XRP plot's read.xlsx call; missing locally. CRAN lists rJava and xlsxjars as imports and Java as a system requirement.
- SW_GGPLOT2 [preparation_required]: Required for the supplied XRP transfer plots; missing in the installed-package metadata probe.

## Review notes

- Full-pipeline inputs and output schemas remain unresolved for the prepared transaction CSV, labels.csv, BTC price object, five group CSVs, AGG panel and USER.csv feature table; public wallet and Wikipedia routes were not queried for data payloads.
- The exact registered frozen-catalog name/path search found no paper-domain Bitcoin, wallet, blockchain, GTD or terrorism dataset; generic unrelated catalog fields do not establish a compatible route or data absence.
- The separate analysis-only scope uses the supplied XRP plot script and Figure 3 workbook. Its bounded probe confirms the required header names but does not establish full date coverage.
- No author R program was imported, parsed, executed or used to deserialize RData; no dataset payload, API response or form was requested, no browser was launched, and no packages or author source files were changed.
- The separate Figure Table 5 workbook is a supplied data artifact without a supplied entry point that consumes it; it remains contextual and does not extend the executable scope.
- All source edits are proposed fragments in the structured actions and remain unapplied; final readiness and data-status fields are left for the controller finalizer.
