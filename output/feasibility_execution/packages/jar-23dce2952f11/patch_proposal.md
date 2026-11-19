# Patch proposal: jar-23dce2952f11

Do Weather-Induced Moods Affect the Processing of Earnings News?

DOI: 10.1111/1475-679X.12160

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented empirical workflow for analyst tests (Tables 1–3), market tests (Tables 4–8), and Internet Appendix robustness analyses, including supplied SAS construction and Stata analysis programs and the documented manual/data handoffs.

Entry points: `A1.sas.pdf`, `A2a.sas.pdf`, `A2b.sas.pdf`, `A2c.sas.pdf`, `A3 Analyses.txt.pdf`, `M1.sas.pdf`, `M2a.sas.pdf`, `M2b.sas.pdf`, `M3a Analyses.txt.pdf`, `M3b Analyses.txt.pdf`, `_audit_supplements/dmp-internet-appendix.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 3/12160 - Do-Weather-Induced-Moods-Affect-the-Processing-of-Earnings-News/dehaan-madsen-piotroski-datasheet-and-code.zip",
      "sha256": "e5c549f257af224afc805decf81e826864cd58a664a5468e286e9e02dcf1b6aa"
    },
    {
      "path": "JAR-Volume 55/Issue 3/12160 - Do-Weather-Induced-Moods-Affect-the-Processing-of-Earnings-News/dmp-internet-appendix.pdf",
      "sha256": "37e17dcaf4bdc9c893a955204b067101ca825b482566b8a230cac8215c19f736"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "b3ebd3126278201e5de6426abab0a511b4480f0724c11fb88bacf8a9a6da209f"
}
```

## Proposed actions

### act-commercial: Confirm authorized access to the exact historical Compustat, CRSP and IBES extracts used by the programs, including IBES.RECDDET and dataset.bran2; obtain the files or an author source/extract manifest.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: data-compustat, data-crsp, data-ibes
Evidence: ev-data-licensed, ev-a1-wrds, ev-comp-fundq, ev-crsp-link, ev-ibes-actu

Preparation / proposed procedure:

1. Request exact source tables, date ranges, filters, identifiers and data dictionaries for A2a, A2c and M2a.
2. Confirm whether A1’s SAS/CONNECT downloader is intended to be invoked separately and whether credentials/access are available.
3. Compare full candidate fields and coverage with the program reads.

Validation to perform later:

- Record a complete source manifest and confirm required fields and periods before execution.

### act-weather: Obtain the author-prepared weather TSV or exact instructions to create it from NOAA ISD-Lite and station metadata.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-weather
Evidence: ev-noaa-hourly, ev-data-weather, ev-a2b-weather, ev-a2b-output, ev-m2b-output

Preparation / proposed procedure:

1. Request weather_data_1990-2014.txt or the author’s parsing, station selection, field/unit, missing-value and aggregation specifications.
2. Confirm output variables and period for analyst and NYC branches.

Validation to perform later:

- Compare prepared columns, units and date coverage with both SAS consumers before execution.

### act-zip: Obtain the author’s 2014 ZIP-coordinate source and missing ZIP-to-county/company ZIP producer steps.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-zip-geography
Evidence: ev-zip, ev-a2b-zip, ev-a2c-maps, ev-m2b-input

Preparation / proposed procedure:

1. Request exact ZIP data version and steps producing dataset.zips_final and this.compustat_zips.
2. Document county selection for cross-county ZIPs, coordinate field choice and station assignment.

Validation to perform later:

- Verify ZIP, coordinates and state_county_id fields and join coverage against A2c and M2b.

### act-analyst-location: Obtain the hand-collected dataset.qea_locations and its key/data dictionary; do not reconstruct it from A4 identifiers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-analyst-location
Evidence: ev-a2c-location, ev-a4, ev-readme-inventory

Preparation / proposed procedure:

1. Request estimator, analyst, rdq, ZIP and coordinate fields, date coverage and any collection procedure.
2. Confirm whether the same input feeds the M2a analyst-weather branch.

Validation to perform later:

- Check uniqueness and match coverage on the A2c join keys.

### act-storm: Confirm how dataset.storm_events_final was prepared from NOAA Storm Events, including date/event filtering and county-ID mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-storm
Evidence: ev-noaa-storm, ev-data-weather, ev-a2c-maps, ev-m2a-analyst

Preparation / proposed procedure:

1. Request the prepared intermediate or author extraction and transformation specification.
2. If authors confirm public-source reconstruction, acquire only relevant NOAA records and implement the documented mapping.

Validation to perform later:

- Verify event_type, state_county_id and date coverage for A2c and M2a joins.

### act-french: Obtain the exact 2015 Fama/French breakpoint and daily EW/VW files or confirm historical archive equivalence.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-french
Evidence: ev-french, ev-french-vintage, ev-data-licensed, ev-m2a-ff

Preparation / proposed procedure:

1. Request the two breakpoint and two daily return file vintages named in M2a.
2. Compare dates, weights, breakpoint definitions and fields before substituting current products.

Validation to perform later:

- Verify all four inputs cover the M2a sample and match the expected variables.

### act-macros: Obtain definitions/version and initialization order for proprietary %crsp_day and %event, and confirm required cross-file macro setup.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-macros
Evidence: ev-readme-macros, ev-readme-stages, ev-a2a-link, ev-m2a-weather

Preparation / proposed procedure:

1. Request the macro source or author-confirmed replacement specifications and required SAS include/autocall path.
2. Document which macros are loaded for each analyst and market stage.

Validation to perform later:

- Compare signatures and produced variables with date-alignment and event-window calls before execution.

### act-handoffs: Resolve all generated file/table producers, exact filenames and order across A2a–A2c and M2a–M2b; obtain the intended M3a dataset path. Confirm the %instown macro-call expansion and ordering relative to its subsequent dataset.erc3_data_instown merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-handoffs
Evidence: ev-a2c-export, ev-m2a-analyst, ev-m2a-weather, ev-m2b-input, ev-m2b-output, ev-m3a, ev-a3, ev-m3b

Preparation / proposed procedure:

1. Ask authors to reconcile Analyst_Data_Final vs pull_analyst_pb_data_final and the two NYC weather names.
2. Request the producer for this.compustat_zips and required staging order.
3. Resolve M3a’s YOUR_DIRECTORY.dta and all library/output paths without guessing edits.
4. Confirm that the statement-commented * %instown; invocation is macro-expanded as intended, when it runs, and that dataset.erc3_data_instown exists before the subsequent merge.

Validation to perform later:

- Build a producer-consumer manifest with every required output, producer, consumer and exact path.
- Verify the institutional ownership intermediate is produced with the required CUSIP/datadate match and is merged before market analysis.

### act-appendix: Request appendix programs or exact replication recipes and input mapping for Tables IA1–IA17.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-appendix-code
Evidence: ev-appendix, ev-readme-stages

Preparation / proposed procedure:

1. Request table-to-script mapping, commands, model inputs and any appendix-only data requirements.
2. Identify required ordering relative to the supplied analyst and market branches.

Validation to perform later:

- Confirm requested materials cover all listed appendix tables before marking closure complete.

### act-final-data: Obtain full author-prepared Analyst_Data_Final.dta and Market_Data_Final.dta or complete their documented upstream builds; A4/M4 only identify observations.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: issue-full-data
Evidence: ev-a4, ev-m4, ev-readme-inventory, ev-a3, ev-m3b, ev-inventory

Preparation / proposed procedure:

1. Request full final datasets and dictionaries if upstream inputs are not available through verified compatible routes.
2. Retain A4/M4 only as identifier shells, not analysis inputs.

Validation to perform later:

- Check complete schemas, coverage and joins against A3, M3a and M3b.

### act-software: Resolve SAS 9.4 initialization, verify Stata 18 compatibility with the author’s Stata/MP 13.1 programs, and verify the invoked outreg2 command in the target environment. ftools 2.49.1 is present as a reghdfe dependency, but check the called fast/keepsin behavior and compatibility without executing the author programs.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw-sas, sw-stata, sw-reghdfe, sw-outreg2, sw-ftools
Evidence: ev-readme-software, ev-environment, ev-a3, ev-m3a, ev-m3b

Preparation / proposed procedure:

1. Confirm SAS license/configuration and supported initialization.
2. Check source commands under local Stata and locate/prepare the exact outreg2 command; reghdfe 6.12.3 is already available.
3. Record SAS/CONNECT and WRDS configuration if the A1 downloader is required.
4. Confirm reghdfe 6.12.3 and ftools 2.49.1 support the exact fast/keepsin options in the analysis files and assess Stata-version compatibility by documentation/source review only.

Validation to perform later:

- Record runtime/add-on versions and verify command discovery in the intended environment without changing analysis specifications.
- Record compatibility findings for the invoked reghdfe options; do not run the author regressions during this feasibility assessment.

### act-instown: Confirm authorized, compatible TFN.S34 access/availability and its coverage for the M2a institutional-ownership calculation; retain the exact local catalog candidate without inferring license status from the timeout.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-institutional-ownership
Evidence: ev-m2a-instown-input, ev-m2a-instown-output, ev-tfn-catalog, ev-tfn

Preparation / proposed procedure:

1. Confirm whether the catalog-listed TFN.S34 file is readable in the intended SAS environment and covers the CUSIP/MGRNO/RDATE/FDATE/SHARES inputs from 1985 onward.
2. If the local candidate is not the intended author-era source, request the exact TFN.S34 source product, historical vintage, access route and field dictionary; do not substitute TFN.S12 or TROWN tables without confirmation.
3. Confirm the %instown macro invocation/order produces dataset.erc3_data_instown before its merge into comp.

Validation to perform later:

- Check full required-field availability, read status and reporting-date coverage against M2a; verify output keys and merge order without executing author code.

### act-pdf-source: Prepare verified native-text working copies of the SAS and Stata programs from the supplied PDFs before any future run.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: issue-pdf-source-form
Evidence: ev-inventory, ev-a2a-link, ev-m2a-instown-input, ev-a3, ev-m3a, ev-m3b

Preparation / proposed procedure:

1. Extract each supplied code PDF into separate working .sas or .do text files without changing the source PDFs.
2. Remove printed PDF line-number columns; inspect page breaks, wrapped lines, continuations, macro statements, strings and comments against each original PDF page.
3. Where wrapping or OCR makes intended source ambiguous, recover it from the original author source or request clarification rather than guessing.
4. Preserve the original program order and source references, and keep the extracted copies clearly marked as unverified until the comparison is complete.

Validation to perform later:

- Compare each extracted source against the PDF program line by line/page by page, verify line-number removal and continuations, and record unresolved text ambiguities before considering execution.


## Remaining issues and prerequisites

- issue-macros [unresolved; full_pipeline]: README identifies proprietary MEAD macros %crsp_day and %event as external; these are required for trading-date alignment and return windows. Cross-file macro setup and manual invocation order remain unresolved.
- issue-handoffs [unresolved; full_pipeline]: M2b consumes this.compustat_zips without a supplied producer; M2b writes weather_final_ny_v2 while M2a reads weather_final_ny_v2_20150604; A2c exports Analyst_Data_Final.dta while M2a consumes dataset.pull_analyst_pb_data_final; M3a retains YOUR_DIRECTORY.dta. Exact paths, producers and branch order are unresolved. M2a also defines %instown to read TFN.S34 and create dataset.erc3_data_instown, then merges that output into comp; the * %instown; statement comment does not by itself establish that the SAS macro call is disabled, so its expansion and stage order need confirmation.
- issue-appendix-code [unresolved; full_pipeline]: The Internet Appendix lists Tables IA1–IA17 with additional robustness tests, but the package supplies no corresponding executable analysis scripts or appendix input map.
- issue-full-data [unresolved; full_pipeline]: A4/M4 are identifier-only shell datasets, not the complete Analyst_Data_Final.dta or Market_Data_Final.dta used by the Stata programs. No full final analysis datasets or complete underlying inputs are packaged.
- issue-pdf-source-form [preparation; full_pipeline]: Executable SAS and Stata programs are supplied as PDFs rather than native .sas/.do scripts. Preparing runnable text requires removing printed line numbers and resolving PDF wrapping/page continuations against the original; the extracted text is not yet a verified executable source file.
- data-compustat [undetermined]: Compustat quarterly and annual fundamentals and company/address records consumed by A2a and M2a; exact periods and full coverage are not verified.
- data-crsp [undetermined]: CRSP daily return, price, volume, share, names, CCM links and calendar data used by A2a, A2c and M2a, including the data accessed by %crsp_day and %event. Exact schema and history are unresolved.
- data-ibes [undetermined]: IBES actuals, forecasts, recommendations and target prices plus the historical translation file and RECDDET/BRAN2 handoffs used in A2a, A2c and M2a.
- data-weather [undetermined]: Hourly ISD-Lite cloud, rain, wind and temperature inputs plus station metadata needed to build analyst and NYC weather intermediates; source filename spans 1990–2014.
- data-zip-geography [undetermined]: ZIP-to-coordinate and ZIP-to-state_county_id geography required to assign analyst weather and construct market-company weather locations. Historical version and missing dataset.zips_final/this.compustat_zips producers are unresolved.
- data-analyst-location [undetermined]: Hand-collected analyst office locations in dataset.qea_locations, keyed by estimator, analyst and rdq, needed to map analyst events to ZIP and coordinates. No full location dataset is packaged.
- data-storm [undetermined]: Storm events intermediate dataset.storm_events_final with event_type and state_county_id used by A2c and M2a. Raw source is public, but final producer/filter/mapping are not supplied.
- data-french [undetermined]: Fama/French size/book-to-market breakpoint tables and daily equal- and value-weighted 25-portfolio returns referenced by M2a; exact November 2015 vintage is absent.
- data-institutional-ownership [undetermined]: Thomson Reuters/TFN institutional ownership records required by M2a %instown. The program reads TFN.S34 fields CUSIP, MGRNO, RDATE, FDATE and SHARES, selects RDATE year >= 1985, constructs dataset.erc3_data_instown and merges instown into market observations. Local catalog schema is a promising exact candidate, but the bounded row probe timed out and period/coverage, readability, and author-era compatibility remain unverified.
- sw-sas [unverified]: README specifies SAS Unix 9.4; the local startup probe failed to initialize TKELS, leaving runtime/license status unverified.
- sw-stata [unverified]: Stata 18 is available locally, but the author specifies Stata/MP 13.1 and compatibility has not been checked.
- sw-outreg2 [unverified]: The analysis invokes outreg2, which was not found on checked adopaths; this does not establish absence from all locations.

## Review notes

- Manual source tracing was required because the frozen dependency list is empty and static file-extension counts do not detect SAS/Stata code embedded in the supplied PDF files.
- A4 and M4 are readable, identifier-only shell datasets; their one-row metadata probes do not establish coverage and do not support an analysis-only scope.
- Local catalog probes are bounded one-row metadata candidates only. Missing exact catalog names and probe failures are retained as unverified, not as proof of absence or lack of license.
- No author code, regression, or dataset download was executed. Final execution and output validation remain unverified.
