# Patch proposal: jar-9427f873f5aa

The Role of Disclosure and Information Intermediaries in an Unregulated Capital Market: Evidence from Initial Coin Offerings

DOI: 10.1111/1475-679X.12404

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied SAS assembly, its documented manual SAS-to-Stata data handoff, Stata variable creation, and all main-results regressions in the supplied Stata driver.

Entry points: `BDEM_1_Data_Assembly_SAS.sas`, `BDEM_2_Add_Var_Creation_STATA.do`, `BDEM_3_Main_Tables_STATA.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12404 - The-Role-of-Disclosure-and-Information-Intermediaries-in-an-Unregulated-Capital-Market-Evidence-from-Initial-C/bdem-datasheet-code-and-identifiers.zip",
      "sha256": "34fb24e60701ad539cd43351be230def3c1bc1238d77e90e0c61097d256d2fd8"
    },
    {
      "path": "JAR-Volume 60/Issue 1/12404 - The-Role-of-Disclosure-and-Information-Intermediaries-in-an-Unregulated-Capital-Market-Evidence-from-Initial-C/bdem-online-appendix.pdf",
      "sha256": "94226cef51fa8da332028630377c2e6e9f722a557d6325897da8b36a78ecc7fb"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "dcd8f66820a0c81a0cc80ca2a287bf670ed7cfc748635f2e8076a4b8d509ce83"
}
```

## Proposed actions

### ACT-OBTAIN-CMC-PANEL: Obtain the author-prepared daily CoinMarketCap panel or verify a compatible route from the documented historical source.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-CMC-DAILY
Evidence: E-DOC-DATA-SOURCES, E-SAS-CMC-NAMES, E-SAS-CMC-WINDOW, E-CAT-CMC

Preparation / proposed procedure:

1. Locate the author-prepared `rawdata.coinmarketcap` snapshot or document a compatible public/manual source for url, date, open, close, volume and market_cap.
2. Confirm the two documented source vintages, token identifier mapping and daily history needed for the supplied April 2014–October 2018 sample, including the source's April 2013–October 2018 snapshot range.
3. Preserve actual missing lead/lag and rolling-window boundaries; do not fill observations or extend the paper's dates without evidence.

Validation to perform later:

- Compare the delivered fields, token keys and date coverage with the supplied SAS reads and required authored history before running SAS.

### ACT-OBTAIN-NAMES-CROSSWALK: Obtain the author-created Names cross-source linkage table and confirm its distinct key mappings.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-NAMES-LINK
Evidence: E-SAS-RAW-SOURCES, E-SAS-NAMES-KEYS, E-SAS-CMC-NAMES, E-DOC-WORKFLOW

Preparation / proposed procedure:

1. Provide the exact SAS `rawdata.names` input and identify `combined_name`, `combined_drop`, `url_cmc` and each source-specific name/date field, including the `secid` and `icoid` columns referenced by DROP.
2. Confirm uniqueness of the author-specified combined-name key and mapping of CMC URLs to each aggregator, rating and whitepaper name key; do not substitute the 2,113-name workbook for this linkage table.

Validation to perform later:

- Review bounded schema metadata for all referenced raw columns and document the author key/crosswalk provenance before SAS assembly.

### ACT-OBTAIN-RATED-ICO-SNAPSHOTS: Obtain the five distinct author-prepared ICO source snapshots with their own keys and fields.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-ICOBENCH, REQ-ICORATING, REQ-SMITH-CROWN, REQ-TOKENDATA, REQ-COINSCHEDULE
Evidence: E-SAS-RATED-JOINS, E-SAS-CROSS-SOURCE-FIELDS, E-CAT-ICOBENCH, E-CAT-ICORATING, E-CAT-SMITH-CROWN, E-CAT-TOKENDATA, E-CAT-COINSCHEDULE

Preparation / proposed procedure:

1. Provide separate `rawdata.icobench`, `rawdata.icorating_fixed`, `rawdata.smithandcrown`, `rawdata.tokendata_201811` and `rawdata.coinschedule_201811` inputs; preserve each source's own name key and do not merge source tables together as substitutes.
2. For each file, confirm the code-used fields in its requirement contract, the snapshot/vintage, row unit and coverage through the author's ICO sample.
3. Resolve the documented header-versus-code member-name differences for ICORating, TokenData and CoinSchedule through the linked alias issue before assigning SAS members.

Validation to perform later:

- Compare each bounded field inventory with its matching SQL join and downstream field use; check source keys and coverage separately.

### ACT-OBTAIN-BENCHY: Obtain the separate Benchy algorithm-rating and analyst-information table.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-BENCHY
Evidence: E-SAS-RAW-SOURCES, E-SAS-BENCHY-JOIN, E-SAS-BENCHY-CONSUMPTION, E-INVENTORY

Preparation / proposed procedure:

1. Provide the `rawdata.benchy` snapshot joined by `name_icobench`, including every field required by the supplied main outcome and control definitions.
2. Record the actual data vintage and ICO coverage; retain Benchy fields separately from ICOBench's other ratings and raw table.

Validation to perform later:

- Compare bounded metadata for the named rating, analyst, team and disclosure columns with the supplied SAS/Stata consumers.

### ACT-OBTAIN-RATED-WPC: Obtain the coauthor-coded rated-ICO whitepaper table and resolve its header member alias.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-WPC-RATED
Evidence: E-SAS-RAW-SOURCES, E-SAS-WPC-JOIN, E-SAS-WPC-FIELDS, E-CAT-WHITEPAPER, E-INVENTORY

Preparation / proposed procedure:

1. Provide the author-coded rated-ICO `rawdata.wpc_allvars` input or identify the exact delivered member corresponding to the header's `rawdata.wpc_allvars_20190320`.
2. Confirm the `combined_name` join and the exact whitepaper disclosure/source columns; retain the supplied filter for missing `div_dist` and subsequent WPC_ renames.

Validation to perform later:

- Review bounded schema metadata and confirm the table's coded ICO population and name key without recoding or rebuilding the whitepaper dataset.

### ACT-OBTAIN-DATASTREAM-SERIES: Confirm the commercial Datastream BTC/ETH series or obtain the authors' prepared return and level tables.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ-DATASTREAM-RET, REQ-DATASTREAM-LEVEL
Evidence: E-DOC-DATA-SOURCES, E-SAS-EXCHANGE-INPUTS, E-CATALOG, E-CAT-DATASTREAM, E-CAT-EXCHANGE-RATE, E-CAT-EXCHANGE-RET, E-CAT-EXCHANGE-LEVEL

Preparation / proposed procedure:

1. Confirm authorized access to the author's Datastream BTC/ETH USD series or request exact author-prepared `rawdata.exchange_ret` and `rawdata.exchange_level` inputs.
2. For the return and level tables separately, document series identifiers, units, date field, daily coverage and the construction that produces `date/eth/btc`; do not treat the catalogued equity Datastream tables or generic monthly currency rates as substitutes.
3. Retain the supplied 180-day forward returns and 90-day past BTC momentum, and preserve unavailable edge periods.

Validation to perform later:

- Compare the two datasets' one-row field metadata, documented series definitions and date coverage against the distinct SAS joins and windows.

### ACT-OBTAIN-UNRATED-INPUTS: Obtain the corrected unrated-ICO data and the three separate filename/name keyed supplemental tables.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-ICODATA-CORRECTED, REQ-UNRATED-PAGECOUNT, REQ-UNRATED-WEBSITES, REQ-UNRATED-FOG
Evidence: E-SAS-UNRATED, E-SAS-ICODATA-FIELDS, E-SAS-ICODATA-SUPPLEMENTS, E-SAS-ADDITIONAL-INPUTS, E-CAT-PAGECOUNT, E-CAT-WEBSITES, E-CAT-FOG

Preparation / proposed procedure:

1. Provide the author-created `icodata_merged_corrected` input with its exact producer, manual coding provenance, duplicate rules, field schema and date/industry/country mappings.
2. Provide separate `ico.unrated_page_count_data`, `ico.websites` and `ico.unrated_fog` tables with `nc_whiteper_pdf_filename/pages`, `combined_name/active` and `pdf_name/fogscore/wordcount` fields respectively.
3. Preserve the source's exact `nc_whiteper_pdf_filename` spelling and filename joins; do not infer a corrected input from the final SAS output or independently rebuild the table.

Validation to perform later:

- Compare bounded metadata and the documented author source mappings for each distinct input; verify join-key fields and history before a separately authorized SAS run.

### ACT-CONFIRM-SAS-AND-EXPAND: Confirm a usable SAS runtime and PROC EXPAND availability in the intended execution environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, SW-SAS-ETS
Evidence: E-ENV-SOFTWARE, E-PUBLIC-SAS-EXPAND, E-SAS-CMC-WINDOW

Preparation / proposed procedure:

1. In an authorized host-visible SAS environment, confirm SAS 9.4 startup and SAS/ETS availability for PROC EXPAND; the recorded TKELS failure does not prove missing entitlement.
2. Retain the supplied PROC SORT, PROC SQL, PROC EXPAND and PROC UNIVARIATE procedures.

Validation to perform later:

- Before an authorized full run, confirm the runtime and required PROC EXPAND component with software metadata.

### ACT-CONFIGURE-LIBREFS: Assign the supplied `rawdata` and `ico` library references to the chosen host-visible input roots.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS-LIBREFS
Evidence: E-SAS-RAW-SOURCES, E-SAS-ADDITIONAL-INPUTS

Preparation / proposed procedure:

1. Choose coherent host-visible roots for the actual author input files and assign `rawdata` and `ico` in the run configuration or autoexec; leave the supplied program unchanged.

Validation to perform later:

- Confirm that the named SAS members resolve from the selected roots after the input files and schemas have been supplied.

### ACT-RESOLVE-COINMARKETCAP6: Obtain the missing coinmarketcap6 producer and exact input/output schema without guessing its relation to coinmarketcap5b.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-COINMARKETCAP6
Evidence: E-SAS-MISSING-STAGES, E-TRACE-EXPANDED

Preparation / proposed procedure:

1. Ask for the supplied coinmarketcap6 transformation or a source-supported explanation of the exact member, schema and period consumed by the join.
2. Preserve the known coinmarketcap5b output and do not alias it to coinmarketcap6 without evidence.

Validation to perform later:

- Trace the documented producer's fields, keys and daily-history output into the existing coinmarketcap7 join before any future run.

### ACT-RESOLVE-ICODATA-PRODUCER: Obtain the source-supported producer and data contract for icodata_merged_corrected.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-ICODATA-PRODUCER
Evidence: E-SAS-UNRATED, E-SAS-ICODATA-FIELDS, E-SAS-ICODATA-SUPPLEMENTS

Preparation / proposed procedure:

1. Request the exact corrected table or its producer, input sources, hand coding, field schema, duplicate decisions and join/date provenance.
2. Do not reconstruct the corrected data from the 2,113-name identifier workbook or infer its values from the final dataset.

Validation to perform later:

- Compare the author-provided schema and provenance against the exact required NC_ columns and subsequent SAS coalesces.

### ACT-RESOLVE-AUTHOR-TABLE-ALIASES: Resolve the table member names that differ between the SAS header and active joins.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-AUTHOR-TABLE-ALIASES
Evidence: E-SAS-RAW-SOURCES, E-SAS-RATED-JOINS, E-SAS-WPC-JOIN

Preparation / proposed procedure:

1. Ask the authors to identify the exact member names for the ICORating, TokenData, CoinSchedule and rated whitepaper snapshots referenced in the header and in the active executable statements.
2. Use the confirmed delivered SAS members in the host library configuration; do not create aliases or rename tables based on suffix similarity.

Validation to perform later:

- Confirm each selected member's source identity, fields and join key against the corresponding active SQL statement.

### ACT-CONFIGURE-DTA-HANDOFF: Prepare the documented manual same-basename SAS-to-Stata conversion and shared relative working directory.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS-DTA-HANDOFF
Evidence: E-SAS-FINAL-OUTPUT, E-STATA2-INPUT, E-STATA2-SAVE, E-STATA3-MAIN, E-TRACE-EXPANDED

Preparation / proposed procedure:

1. Use the actual program-created WORK.dataset_merged_all_test member for the documented manual SAS-to-Stata DTA conversion; the closing comment's ICO prefix is not treated as a separate dataset.
2. Stage the converted file as dataset_merged_all_test.dta in a configured Stata project directory, then use that same directory or coherent relative paths for Stata2's dataset_for_analysis.dta output and Stata3 input.

Validation to perform later:

- After the genuine input/schema contracts are met, compare the converted DTA fields and values with the SAS output and confirm the two same-basename Stata handoffs from the configured paths.

### ACT-SETUP-WINSOR2: Make the documented winsor2 command available in the configured Stata adopath before a future attempt.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-WINSOR2
Evidence: E-ENV-SOFTWARE, E-PUBLIC-WINSOR2, E-STATA3-OUTPUTS

Preparation / proposed procedure:

1. In the authorized Stata environment, expose the documented winsor2 package and check its help/which metadata; preserve the supplied `cuts(0 99)` command.

Validation to perform later:

- Confirm the installed package location and documented options using metadata before any future estimator run.


## Remaining issues and prerequisites

- ISS-COINMARKETCAP6 [unresolved; full_pipeline]: SAS Step 2 reads coinmarketcap6, but the supplied SAS source creates coinmarketcap5b and contains no producer for coinmarketcap6. The exact missing transformation/schema handoff must be supplied or clarified; do not substitute another table or infer an alias.
- ISS-ICODATA-PRODUCER [unresolved; full_pipeline]: SAS Step 7 reads icodata_merged_corrected without a supplied producer. Its construction, source mapping, joins, duplicate handling, schema, and required manual coding/cleaning need an author-supported route.
- ISS-LIBREFS [preparation; full_pipeline]: The supplied SAS program uses rawdata and ico librefs without assigning their roots. Choose coherent host-visible input roots and configure both librefs in the run environment; this is ordinary setup once the actual input files and schemas are known.
- ISS-DTA-HANDOFF [preparation; full_pipeline]: The supplied SAS program creates the unqualified WORK.dataset_merged_all_test member and documents a manual conversion to a same-basename Stata file. Configure that conversion and a coherent Stata working directory as routine preparation; the comment's ICO prefix is not treated as evidence for a separate dataset.
- ISS-AUTHOR-TABLE-ALIASES [unresolved; full_pipeline]: The SAS header lists rawdata.icorating, rawdata.tokendata, rawdata.coinschedule and rawdata.wpc_allvars_20190320, while executable joins read icorating_fixed, tokendata_201811, coinschedule_201811 and wpc_allvars. Do not assume these different SAS members are aliases; an author-supported mapping or the exact delivered member names are needed.
- REQ-NAMES-LINK [undetermined]: Author-created cross-source ICO name-linking table rawdata.names, used to align CoinMarketCap tokens with the ICO aggregator, rating, and whitepaper source names.
- REQ-CMC-DAILY [undetermined]: Daily CoinMarketCap token market panel needed for the SAS price, volume, market-cap, listing, lead/lag return, and liquidity construction.
- REQ-ICODATA-CORRECTED [undetermined]: Unrated-ICO corrected/crosswalked data table icodata_merged_corrected consumed by SAS Step 7; its producer, schema, and hand-collected field contract are not supplied.
- REQ-ICOBENCH [undetermined]: Author-prepared ICOBench ICO-information snapshot joined into the main ICO panel.
- REQ-ICORATING [undetermined]: Author-prepared ICORating snapshot joined separately by its ICORating name key.
- REQ-SMITH-CROWN [undetermined]: Author-prepared Smith & Crown ICO-information snapshot, including source-code, US-bar and founder-ID fields.
- REQ-TOKENDATA [undetermined]: Author-prepared TokenData November 2018 ICO snapshot joined by TokenData project name.
- REQ-COINSCHEDULE [undetermined]: Author-prepared CoinSchedule November 2018 ICO snapshot joined by CoinSchedule project name.
- REQ-BENCHY [undetermined]: Separate ICOBench Benchy algorithm-rating and analyst-information snapshot joined by name_icobench.
- REQ-WPC-RATED [undetermined]: Coauthor-coded rated-ICO whitepaper table, joined to the main panel by combined_name and used to create WPC-prefixed controls.
- REQ-DATASTREAM-RET [undetermined]: Daily author-prepared BTC and ETH USD return series consumed to create six-month forward returns and past BTC momentum.
- REQ-DATASTREAM-LEVEL [undetermined]: Separate daily BTC and ETH USD level series joined at ICO end dates and daily observation dates.
- REQ-UNRATED-PAGECOUNT [undetermined]: Page-count lookup for unrated whitepapers by the supplied filename join key.
- REQ-UNRATED-WEBSITES [undetermined]: Website activity table for the unrated-ICO collection, joined by combined_name and coalesced with existing activity coding.
- REQ-UNRATED-FOG [undetermined]: Fog-score and word-count table for unrated ICO whitepapers, joined by PDF filename and coalesced into the final disclosure measures.
- SW-SAS [unverified]: The assigned environment record shows the SAS runtime startup failing during TKELS initialization; runtime version, SAS availability and entitlement remain unverified.
- SW-SAS-ETS [unverified]: The supplied SAS program actively invokes PROC EXPAND, documented in the SAS/ETS guide; local component availability is not established.
- SW-WINSOR2 [preparation_required]: Not found in either checked adopath. The package supports Stata versions beginning at 8 according to its package record, but its authored cuts(0 99) call must be checked against installed help after authorized setup.

## Review notes

- Final review note: the scope covers the supplied SAS assembly, its manual SAS-to-Stata conversion, Stata variable creation, and all supplied main-results models. All 14 frozen external input dependencies are separate requirements; D0015 and D0016 are generated handoffs. Listed prepared and public/manual data routes remain unverified without compatible data probes; Datastream BTC/ETH inputs are commercial, with no access barrier inferred. SAS/TKELS startup remains unverified; winsor2 requires setup. SAS `if close>0.001 then;` is a valid null-action IF followed by a separate unconditional assignment under the cited SAS syntax; preserve the source and note that the `$0.001` minimum-price comment does not condition the following assignment as publication-fidelity context, not an execution prerequisite. Preserve CMC/Datastream date windows, Stata seed/fixed effects/singleton settings, and the distinct 3,349 attempted versus 2,113 final-identifier populations. Missing coinmarketcap6 and icodata_merged_corrected producers and raw table member aliases remain unresolved. Libref roots and same-basename manual DTA conversion are routine configuration once real input schemas are supplied; the ICO comment prefix does not imply another dataset. No author edits or independent empirical fixes are proposed.
