# Patch proposal: jar-5d4cbc05d575

How Is Earnings News Transmitted to Stock Prices?

DOI: 10.1111/1475-679X.12394

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete author-documented data-preparation workflow supplied with this release: IBES earnings dates/surprises, RavenPack event/revision extraction and handoff, TRTH trades and quotes processing, and the separately documented Nasdaq ITCH hidden-order branch. The release supplies no paper-wide regression or table driver. The TRTH functions require a missing server-side dispatcher.

Entry points: `earnings_news_jar-main/IBES/IBES_Data_Processing_JAR.ipynb`, `earnings_news_jar-main/Ravenpack/RavenPack.ipynb`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12394 - How-Is-Earnings-News-Transmitted-to-Stock-Prices/gm-datasheet-code-and-identifiers.zip",
      "sha256": "588ba630d0dab04b1797315445fed3010bd3f18aebd2fd2dd873f3bf04421462"
    },
    {
      "path": "JAR-Volume 60/Issue 1/12394 - How-Is-Earnings-News-Transmitted-to-Stock-Prices/gm-internet-appendix.pdf",
      "sha256": "3ebae1086070cd33a640eb68e07a2d720fbf43d78de3dc88a01f1bfa4bc9e106"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "b0cb55322557ba6e8c890637e2ec795aa9602ba8a1c0fb10d7cf1e1fb1a5c00e"
}
```

## Proposed actions

### A_EVENT_HANDOFF: Obtain the author-prepared merged earnings/event file or its complete producing workflow and data contract before dispatching the TRTH event stages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EVENT_TABLE, I_EVENT_TABLE
Evidence: E_EVENT_READ, E_RAVENPACK_EXAMPLE

Preparation / proposed procedure:

1. Identify the producer and schema for Earnings_Announcements_MergedTRTH_2011_2015.csv, including the CUSIP joins, date/time fields, timezone convention, PERMNO, #RIC and exchange mapping.
2. Confirm that the event list covers the target 2011-2015 period and is compatible with the arguments consumed by the trade and quote event functions.
3. Preserve the supplied RavenPack UTC-to-US/Eastern conversion and after-hours/first-relevant-news selection rules; do not infer an unprovided event merge.

Validation to perform later:

- After the exact author input or producer is supplied, compare its documented columns and date/identifier semantics with the direct #RIC read and event-function arguments.

### A_AUTHOR_IBES_DATA: Confirm a compatible route to the author-named IBES, CRSP, Compustat–CRSP quarterly, and four Compustat index-history inputs, preserving the joins and history consumed by the notebook.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_IBES_LINK, R_IBES_DETAIL, R_CRSP_DSF, R_COMPQ_PREPARED, R_SP500, R_SP400, R_SP600, R_SP1500
Evidence: E_IBES_LINK, E_IBES_DETAIL, E_IBES_WINDOW, E_CRSP_FACTOR, E_CRSP_LAG_PRICE, E_COMPQ_FILTERS, E_COMPQ_LAGS, E_SP_FIELDS, E_SP_FILES, E_CATALOG_SAS_METADATA, E_CATALOG_LOOKUPS

Preparation / proposed procedure:

1. Use the exact author-prepared paths when available; confirm IBES ticker/PERMNO validity dates and the date-adjusted actual-report window, including all retained estimates 1–90 calendar days before report dates.
2. For CRSP, preserve the author-named security/exchange population, CFACSHR joins at estimate/report dates, the event PRC and the fifth prior PERMNO trading observation. The one-row DSF candidate establishes field names only.
3. For the quarterly input, confirm the prepared COMP/CRSP join contains LPERMNO, GVKEY, rdq, fiscal-date and required accounting/EPS/share inputs plus ggroup/gind/gsector/gsubind. Preserve one prior fiscal year at the same GVKEY/fqtr for each lag.
4. Obtain all four separate gvkey/from/thru histories (sp500.csv, sp400.csv, sp600.csv, sp1500.csv); do not substitute the PERMNO-based CRSP S&P500 list.
5. Treat FUNDQ, CCMXPF_LNKHIST and CO_HGIC as conditional joint reconstruction candidates only; the one-row probes do not establish population, coverage or the author’s merged-file construction.

Validation to perform later:

- After a compatible author-prepared route is identified, compare actual source columns and date/identifier intervals with the cited notebook reads and joins; confirm target 2011–2015 events and the specified 90-day/five-trading-day/one-fiscal-year history.

### A_RAVENPACK_EVENT: Obtain the compatible RavenPack history and the missing merged TRTH event input or its complete producer and schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RAVENPACK_RAW, R_EVENT_TABLE, I_EVENT_TABLE
Evidence: E_RAVENPACK_2011, E_RAVENPACK_FILTER, E_DATASHEET_WORKFLOW, E_EVENT_READ

Preparation / proposed procedure:

1. Confirm the needed RavenPack news history and fields for earnings and analyst revisions; the notebook demonstrates one 2011 example and converts UTC to US/Eastern.
2. Identify the producer of Earnings_Announcements_MergedTRTH_2011_2015.csv and the CUSIP join with IBES. The shown RavenPack selection does not select or identify its CUSIP input, so do not infer the join.
3. Specify the event file’s #RIC, PERMNO, earnings/IBES dates, event timestamp, exchange and other fields needed by the quote reader and event task tuples, including timezone convention and 2011–2015 coverage.
4. Preserve the documented after-hours earnings selection and first relevance-100 news rule where the actual producer confirms it.

Validation to perform later:

- Compare the supplied event file or producer outputs to the direct #RIC read and the five-field event task contracts before dispatching any TRTH processing.

### A_TRTH_ACCESS_AND_ORDER: Confirm exact TRTH TAS data/sidecars and obtain the omitted task drivers while preserving every authored processing branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TRTH_TRADES, R_TRTH_QUOTES, I_TRTH_ORCHESTRATION
Evidence: E_README_TRTH, E_TRADE_FIELDS, E_TRADE_CHECKSUM, E_TRADE_ALIGN_NEIGHBOR, E_QUOTES_FIELDS_CHECKSUM, E_QUOTES_CHECKSUM_COLUMNS, E_QUOTES_WINDOW, E_TRADE_TASK, E_TRADE_RETURN, E_QUOTES_RETURN

Preparation / proposed procedure:

1. Confirm an accessible historical TRTH/SIRCA TAS route, its field format and all matching daily .md5sum sidecars. Preserve the actual qualifier and checksum checks.
2. For trades, run the documented chain in order: ExtractTrades → ClassifyTrades → AlignDates → ExtractTradesAroundEarnings → ExtractTradesEarningsDescriptiveStats, ExtractTradesAfterEarningsResample, and ExtractTradesAfterNewsBeforeOpen. Keep the next UTC-day files needed to reconstruct ET dates.
3. For quotes, keep the separate chain: ExtractQuotes → ExtractQuotesAroundEarnings → ExtractQuotesAfterEarningsResample. Preserve Quote Time/Time[G]/GMT Offset/Qualifiers and the one-before/two-after business-day window.
4. Obtain the server-side exchange/month/day and event-task loops; bind the required event tuple/global task and collect/write the returned per-event objects. Do not call each function as an independent batch driver.
5. TAQ is only an author-described conditional alternative for TRTH trades/NBBO. If selected, use the documented after-hours trade, manual NBBO construction, quote-retention and spread-handling modifications; it is not an additional AND input and cannot replace ITCH.

Validation to perform later:

- Once source and event routes plus drivers are supplied, statically compare each stage’s output columns, qualifier flags, date alignment and event identifiers with the next consumer before any separately authorized run.

### A_ITCH_ACCESS_AND_ID_MAP: Resolve the ITCH message route, the role of the supplied final-sample identifiers, and the author-specific symbol-selection/MeatPy contract.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ITCH_RAW, R_ITCH_IDS, I_ITCH_BRANCH
Evidence: E_DATASHEET_ITCH_IDS, E_DATASHEET_WORKFLOW, E_SAMPLE_IDS, E_PACKAGED_PROBE, E_README_ITCH, E_PUBLIC_NASDAQ_POLICY, E_PUBLIC_MEATPY_DOCS

Preparation / proposed procedure:

1. Confirm current Academic Waiver eligibility/access, the authors’ exact ITCH protocol version, relevant after-hours messages, and the permitted route for the target event history; the 2021 policy’s annual reapplication is not proof of current access.
2. Start from the supplied final-sample PERMNO/TRTH RIC list. Clarify how the authors’ ITCH/MeatPy route obtains Nasdaq instrument symbols and event tasks, including whether the datasheet’s separate-list statement refers to that supplied file or another product. Do not assert a distinct CSV or derive symbols from PERMNO/#RIC.
3. Obtain the author-used MeatPy release or documented processing code and define the hidden-order outputs. Do not substitute TRTH or TAQ for this branch.

Validation to perform later:

- Confirm the actual ITCH symbol fields, event-selection/task mapping, message-date coverage, protocol version and hidden-order outputs against the author-specified route before selecting a future runtime.

### A_PANDAS_NOTEBOOK_COMPAT: Verify the installed pandas release signature and anchor any required 12-call repair to stable notebook cell identities.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PANDAS_DROP
Evidence: E_PANDAS_DROP_SOURCE, E_PANDAS_DROP_INVENTORY, E_PUBLIC_PANDAS_DROP

Preparation / proposed procedure:

1. The frozen location map reports null cell IDs. Create or obtain a working copy with stable code-cell boundaries before proposing notebook cell edits; do not fabricate cell IDs.
2. First verify the DataFrame.drop signature for installed pandas 3.0.6 from version-specific official documentation. The saved mutable stable-page quote is historical and does not establish 3.0.6 behavior. If the installed release requires keyword-only axis, change the positional 1 to keyword axis=1 in each of the 12 inventoried calls, preserving drop targets, inplace flags, order and scientific definitions.
3. Retain the original notebook and its hash; do not apply edits during this assessment.

Validation to perform later:

- After cell identities are established, compare the installed pandas metadata with its version-pinned official signature; apply the repair only if that signature requires it, then compare each conditional change against the inventory. Any runtime validation belongs to a later authorized run.

### A_PYTHON_RUNTIME: Resolve the Python 2/3 source compatibility plan for the TRTH functions.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PYTHON2, I_PYTHON2_RUNTIME
Evidence: E_README_TRTH, E_SOFTWARE_METADATA, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Confirm whether an authorized compatible Python 2 runtime will be used or whether the author’s exact modules can be ported to the available Python 3 runtime.
2. Record compatible pandas/NumPy/runtime versions for each source file and preserve all trade and quote branches. No installation or author-code compatibility trial occurred during this audit.

Validation to perform later:

- Review the chosen runtime plan and statically reconcile imports and APIs against the cited versions before a later authorized execution.

### A_HDF5_BACKEND: Set up an HDF5 writer backend compatible with the notebook’s pandas.to_hdf call.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_PYTABLES, I_HDF5_BACKEND
Evidence: E_IBES_H5, E_SOFTWARE_METADATA, E_PUBLIC_PANDAS_HDF5

Preparation / proposed procedure:

1. Install/configure a PyTables version compatible with the selected pandas/Python environment before writing Earnings_Announcements_and_Surprises.h5; preserve key=panel. No package was installed during this assessment.

Validation to perform later:

- After setup, confirm package metadata and the documented pandas HDF5 backend are consistent; writing the study output requires a later authorized run.

### A_MEATPY_SETUP: Select an author-compatible MeatPy release for the separately documented ITCH branch.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_MEATPY
Evidence: E_README_ITCH, E_SOFTWARE_METADATA, E_PUBLIC_MEATPY_REPO, E_PUBLIC_MEATPY_DOCS

Preparation / proposed procedure:

1. Resolve the authors’ ITCH protocol version and expected outputs first; then choose a compatible MeatPy release or author-supplied version. The current repository is public and current docs say ITCH 5.0 only, but no code was downloaded or installed.

Validation to perform later:

- Compare the selected MeatPy release’s stated ITCH version with the author’s data and output contracts before a later authorized run.

### A_IMPORT_OS_FIX: Correct the static os import typo in the trade descriptive-statistics module in a working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_TRADES_IMPORT
Evidence: E_TRADES_BAD_IMPORT, E_TRADES_OS_USE

**Proposed edit:** `earnings_news_jar-main/TRTH/Trades/ExtractTradesEarningsDescriptiveStats.py:14–14`
Source SHA-256: `60956a0a97c93ceb5e403c94fafe8bb392fee633c89a88a4cac2f51008f58afa`

The source later calls os.path.isfile but the shown import is oss; this one-line correction provides the referenced os module.

Current text:
```
import oss
```

Proposed replacement:
```
import os
```

Preparation / proposed procedure:

1. Apply the one-line change only to a separate working copy after confirming its source hash; preserve all other code and output definitions.

Validation to perform later:

- Check the working-copy diff against the source hash and confirm the os.path reference is paired with import os without executing the module.

### A_TRTH_PATH_LOCALE: Configure consistent host paths and the ClassifyTrades locale in a working copy.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_TRTH_RUNTIME_CONFIG
Evidence: E_TRTH_DRIVE_ROOTS, E_TRTH_LOCALE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Map every source and output root across the trade and quote modules from Windows M:, X:, and Y: drives to accessible host directories, keeping each producer output aligned with its next consumer input.
2. Determine a supported locale setting for the processing host and configure it consistently; availability of locale value us remains unknown.
3. Keep output folders writable and keep original code unchanged. No path or locale trial was run.

Validation to perform later:

- Review every mapped path against the ordered trade/quote producer-consumer chain and confirm the selected locale is documented for the chosen environment before a later authorized run.


## Remaining issues and prerequisites

- I_EVENT_TABLE [unresolved; full_pipeline]: The required Earnings_Announcements_MergedTRTH_2011_2015.csv is absent from this package and has no supplied producer. RavenPack.ipynb shows one 2011 example and filters news, but does not export or implement the documented CUSIP merge with IBES. The event-table schema, CUSIP/identifier mapping, timezone treatment, date fields and full 2011-2015 coverage remain unknown.
- I_TRTH_ORCHESTRATION [unresolved; full_pipeline]: The README says the server-specific loops are omitted and only cleaning/processing functions are supplied. Event functions take parameters or return objects; ExtractTradesAroundEarnings.py overwrites its five parameters from an unprovided task global. No exchange/month/day loops, event-task producer, output collector, or caller binding is provided. These specific driver and event-list contracts must be supplied or resolved before the complete TRTH branch can be dispatched.
- I_PANDAS_DROP [unresolved; full_pipeline]: Installed pandas metadata reports version 3.0.6 and the IBES notebook has 12 positional axis arguments. A saved observation from a mutable stable documentation URL showed axis as keyword-only, but the page release was not pinned; it does not establish a mismatch with installed 3.0.6. Notebook cell IDs are also absent, so any repair remains conditional on version-specific documentation and stable cell mapping. No calls were executed.
- I_PYTHON2_RUNTIME [unresolved; full_pipeline]: Python 2 is not found on PATH, but the README identifies several TRTH modules as Python 2 format and others as Python 3. A compatible runtime or reviewed port is needed; no author source was executed, and Python 3 compatibility beyond the specific static checks is unknown.
- I_HDF5_BACKEND [preparation; full_pipeline]: The IBES notebook writes Earnings_Announcements_and_Surprises.h5 with pandas.to_hdf, but PyTables is not present in installed package metadata. A compatible writer backend must be set up before that generated output can be written.
- I_TRADES_IMPORT [preparation; full_pipeline]: ExtractTradesEarningsDescriptiveStats.py imports oss but later references os.path.isfile; the shown source has no os import. A working-copy correction is directly supported.
- I_TRTH_RUNTIME_CONFIG [unresolved; full_pipeline]: TRTH modules contain Windows M:, X:, and Y: roots and ClassifyTrades.py calls locale.setlocale(locale.LC_ALL, "us"). Their mappings, locale availability, and write targets are unresolved in this environment; no syntax or locale trial was run.
- I_ITCH_BRANCH [unresolved; full_pipeline]: The selected scope includes the separately documented Nasdaq ITCH hidden-order branch, but no ITCH input message files or processing code are packaged. The datasheet says instrument lists are provided separately, while the README identifies the packaged PERMNO/TRTH RIC file as final-sample identifiers; the sources do not establish whether that file feeds ITCH selection or whether another list/mapping is used. The compatible Nasdaq-symbol/event-task contract, author-used ITCH protocol version and hidden-order outputs remain unresolved. TRTH or conditional TAQ does not replace this branch.
- R_IBES_LINK [undetermined]: IBES ticker-to-PERMNO link history used to attach PERMNO with start/end validity dates to IBES estimates and announcement timestamps.
- R_EVENT_TABLE [undetermined]: Merged earnings-announcement event file required by the TRTH quote extractor; it supplies #RIC selection and is the documented handoff to event-specific trade/quote routines. Its producer, fields beyond the direct #RIC read, joins, and date/timestamp contract are unresolved.
- R_IBES_DETAIL [undetermined]: Historical IBES detail estimates and actuals used with the date-valid ticker-PERMNO link. The notebook selects ticker, CUSIP, official ticker, analyst, forecast, revision, announcement and actual fields; it retains forecasts 1–90 calendar days before the weekend-adjusted actual report date. The filename spans 1970–2019, but the notebook has an upper FPEDATS cutoff only; target sample years are described as 2011–2015.
- R_CRSP_DSF [undetermined]: Author-prepared CRSP daily history for the named security codes 10/11 and exchange codes 1/2/3. The IBES notebook joins CFACSHR at forecast and adjusted report dates, split-adjusts analyst estimates, then uses event-date PRC and the fifth prior PERMNO trading observation. Retained announcements target 2011–2015, but the named file spans 1970–2019 and the notebook states no lower bound; preserve the 90-day forecast history and five prior observations.
- R_COMPQ_PREPARED [undetermined]: The author-named Compustat-CRSP merged quarterly file supplies current-quarter GVKEY/LPERMNO and fiscal fields, rdq, accounting/share/EPS inputs, and ggroup/gind/gsector/gsubind. The notebook constructs fqenddt, filters Compustat flags, joins PERMNO to LPERMNO, and creates seven same-GVKEY/same-fqtr lags from fyearq−1. Its filename spans 1961–2019; at minimum one preceding fiscal year is needed for lag inputs. Local FUNDQ, CCM link-history, and GIC-history files are only conditional joint reconstruction candidates, not separate mandatory requirements or a verified substitute.
- R_SP500 [undetermined]: The separate Compustat SP500 constituent history used to assign its own S&P index indicator to each quarterly earnings observation. This file must retain the GVKEY effective-date intervals; it is not interchangeable with another index history.
- R_SP400 [undetermined]: The separate Compustat SP400 constituent history used to assign its own S&P index indicator to each quarterly earnings observation. This file must retain the GVKEY effective-date intervals; it is not interchangeable with another index history.
- R_SP600 [undetermined]: The separate Compustat SP600 constituent history used to assign its own S&P index indicator to each quarterly earnings observation. This file must retain the GVKEY effective-date intervals; it is not interchangeable with another index history.
- R_SP1500 [undetermined]: The separate Compustat SP1500 constituent history used to assign its own S&P index indicator to each quarterly earnings observation. This file must retain the GVKEY effective-date intervals; it is not interchangeable with another index history.
- R_RAVENPACK_RAW [undetermined]: RavenPack equity news needed for earnings-announcement timestamps and analyst-revision news. The supplied notebook reads one 2011 example, converts TIMESTAMP_UTC from UTC to US/Eastern, then selects analyst-rating and earnings-per-share categories. The datasheet states RavenPack earnings are merged with IBES by CUSIP, but the sample notebook does not show that merge/export or select a CUSIP field; history, identifier crosswalk and producer for the named merged TRTH event CSV remain unresolved.
- R_TRTH_TRADES [undetermined]: High-frequency TRTH TAS trade messages for the target earnings events, including every source file and its real .md5sum companion. The extractor requires #RIC, Date[G], Time[G], GMT Offset, Type, Ex/Cntrb.ID, Price, Volume, Market VWAP, Qualifiers, Seq. No., Exch Time, and Trd/Qte Date. The trade chain is ExtractTrades → ClassifyTrades (qualifier flags) → AlignDates (current and next UTC day reconciled to ET Date) → ExtractTradesAroundEarnings (one business day before min(event dates) through one after max) → all three descriptive-stats, post-earnings-resample, and before-open consumers. Event-source days, history, checksums and server task/loop coverage are unverified.
- R_TRTH_QUOTES [undetermined]: High-frequency TRTH TAS quote messages with real per-file .md5sum companions and the event table used to select RICs. The extractor reads #RIC, Date[G], Time[G], GMT Offset, Type, Buyer ID, Bid Price/Size, Seller ID/Ask Price/Size, Qualifiers, and Quote Time. The quote chain is ExtractQuotes → ExtractQuotesAroundEarnings (qualifier/timestamp reconciliation; current and neighbor-day history as requested by event date windows) → ExtractQuotesAfterEarningsResample (announcement/open 1-second and 1-minute outputs). It spans one business day before the earliest event date through two business days after the latest; exact coverage and timezone/qualifier producer contract remain unverified.
- R_ITCH_RAW [undetermined]: Separate Nasdaq ITCH after-hours messages around earnings, used to extract trades and hidden-order information with MeatPy. The datasheet identifies a Nasdaq instrument list, but this package has no ITCH input files, parser/processing code or specified protocol version. This branch is retained independently from the TRTH/TAQ routes.
- R_ITCH_IDS [undetermined]: Instrument selection/mapping needed to select Nasdaq ITCH messages for the final-sample earnings events. The datasheet says instrument lists are provided separately for the documented data products, and the README identifies the packaged PERMNO/TRTH RIC CSV as final-sample identifiers. The sources do not specify whether that file feeds ITCH/MeatPy selection, whether another list is used, or how compatible Nasdaq symbols and event tasks are obtained; no additional CSV or derivation is assumed.
- SW_PYTABLES [preparation_required]: Not found in installed package metadata. The IBES notebook writes HDF5 through pandas.to_hdf, whose documented backend uses PyTables; select a compatible installation/version before future authorized execution.
- SW_PYTHON2 [preparation_required]: Not found on PATH. The README says several TRTH sources are in Python 2 format and others Python 3; determine a supported runtime or reviewed port while preserving each stage.
- SW_MEATPY [preparation_required]: Not found in installed package metadata. The README links the public MeatPy repository for the ITCH branch; current docs identify version 0.0.3 and ITCH 5.0 support, but the authors’ historical ITCH version and compatible release are unspecified.

## Review notes

- Scope covers the supplied IBES and RavenPack notebook containers, all documented TRTH trade and quote stages, and the separately documented Nasdaq ITCH branch. No paper-wide regression/table program is supplied, and the packaged PERMNO/TRTH CSV is an identifier list rather than analysis data; no analysis_only scope is supported.
- All required source/history and event handoffs are represented, including the two frozen dependency IDs. The Compustat–CRSP quarterly table is the primary author input; FUNDQ, CCMXPF_LNKHIST, and CO_HGIC are conditional joint reconstruction candidates only. Four S&P membership histories remain separate inputs.
- TRTH order, checksums, qualifier handling, UTC-to-ET neighbor-day alignment, event windows, returned-object consumers, and separate TAQ/ITCH branches are traced in probes/workflow_trace.json. TAQ is a conditional TRTH trade/NBBO alternative with after-hours changes; it does not replace ITCH.
- Bounded catalog checks and one-row SAS metadata describe candidates only, not coverage or entitlement. Software checks read runtime/package metadata only. No author code was executed, imported, compiled or edited; no source data beyond the pre-existing bounded packaged probe and five permitted SAS one-row metadata reads was processed.
