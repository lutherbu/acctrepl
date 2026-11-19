# Patch proposal: jar-1c2379de3d78

Buy-Side Analysts and Earnings Conference Calls

DOI: 10.1111/1475-679X.12180

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: embedded Python parser, manual Excel affiliation cleaning/classification, SAS variable-preparation script and the documented downstream analysis outputs. The inputs, producers and analysis stage are not closed by this release.

Entry points: `qa_parse.docx`, `jwz2_201707.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 3/12180 - Buy-Side-Analysts-and-Earnings-Conference-Calls/jwz-datasheet-and-code.zip",
      "sha256": "a769f83951f243c81539c316cb173d7326e4c500b04df652b4624e9145a0b189"
    },
    {
      "path": "JAR-Volume 56/Issue 3/12180 - Buy-Side-Analysts-and-Earnings-Conference-Calls/online-appendixjung.pdf",
      "sha256": "8a7118b7fab630ffec972e91b75ffb7db272f03989c6b3814927b091f673acaf"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "5267b65ea3217164a67176028f462f4ba122aacd27f6795575e8c57421c7fd0e"
}
```

## Proposed actions

### A001: Verify permitted StreetEvents transcript access and obtain the author-compatible raw text population.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R001
Evidence: E_RAW_TRANSCRIPTS, E_TRANSCRIPT_FIELDS, E_STREETEVENTS_CONTRACT, E_AUTHORS_SHARE_CONDITION

Preparation / proposed procedure:

1. Confirm whether the researcher has an active agreement that permits access to the required StreetEvents transcript product and whether the authors can share the derived analyst list under that agreement.
2. Obtain or identify the authorized transcript text files and confirm their ticker/date/time, participant, affiliation, remarks and Q&A contents.
3. Document the complete sample coverage; do not infer it from the 2009 acquisition year or the tone-join filter alone.

Validation to perform later:

- Record the exact product/access contract and allowed handling of raw transcripts and the derived analyst list.
- Check representative authorized files against the parser’s expected delimiter/section structure and documented fields.
- Confirm full transcript date coverage against the author’s intended sample before parsing.

### A002: Supply the parser’s lexicons and establish its exact runtime/module contract.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: R002, S002, S003
Evidence: E_PYTHON_IMPORTS, E_PYTHON_LEXICONS, E_PYTHON_CWD, E_PYTHON2_SYNTAX, E_PY2_PROBE, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Provide the exact `positive` and `negative` lexicon files or their authorized source and state the working directory from which the parser is invoked.
2. Provide or identify the compatible Python 2 runtime, or a reviewed compatibility port that preserves the parser’s behavior.
3. Identify the distribution/source and version that supplies `stemmer.PorterStemmer` with the API used by this code; do not substitute NLTK or another stemmer without author validation.

Validation to perform later:

- Before any authorized run, verify the selected runtime parses the supplied source and resolves the exact stemmer import without modifying the author code.
- Confirm both lexicon files are readable from the documented working directory.
- On authorized representative text, validate the output header and one parser result against the author’s expected fields.

### A003: Resolve the parser → manual Excel → SAS table handoff and provide author-prepared intermediate files or a complete field-level recipe.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R003, R004, R005, I001
Evidence: E_PARSER_HANDOFF, E_PYTHON_CSV, E_MANUAL_EXCEL, E_CLEANDATA_MATCH, E_TONE_INPUT, E_13F_CLASSIFICATION, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the exact `cleandata`, `match` and `qa_parse_confqa_mjj2` data products (or the sanctioned producer/export procedure) and their codebooks.
2. Document how parser CSV fields map to SAS names/types, how `CCDATE`, `SET`, analyst/affiliation keys and AMASKCD/EMASKCD are produced, and which data file carries SICH/SIC2/SIC3/QTR/SHROUT90.
3. Document the manual affiliation normalization, buy-side/sell-side exclusion and MGRNO matching decisions, preserving the author’s original classification process.
4. Confirm the resulting tables share the exact keys used by the SAS joins and that the tone table uses the filtered 2002-04-01 to 2009-03-31 period.

Validation to perform later:

- Compare delivered variable names, types, keys and row/date coverage to the SAS input contracts at lines 12–24 and 50–61.
- Confirm the parser CSV-to-SAS conversion preserves identifiers, dates, times and every required tone/participant field.
- Check the author-provided manual cleaning decisions and exclusions against the documented workflow; do not independently relabel firms.

### A004: Resolve 13F access and the author-specific manager matching and portfolio-table producers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R006, R007, R008, I003
Evidence: E_13F_CLASSIFICATION, E_TFN_READS, E_CATALOG_TFN, E_TFN_S34_PROBE, E_STREETEVENTS_CONTRACT

Preparation / proposed procedure:

1. Confirm the exact Thomson Reuters 13F product/release and the permitted route for the researcher; the local TFN.S34 catalog candidate timed out and remains unverified.
2. Request author-prepared `portvalue` and `pctofport2000` tables or the original producers/data dictionary, including their MGRNO mapping, quarterly date construction, firm universe, shares/value calculations and `NUMFIRMS` definition.
3. Preserve the distinct t0/t1 quarter-end joins in the SAS program and confirm required boundary quarters for all call dates.

Validation to perform later:

- For a future authorized read, verify the required identifiers and output fields against the author-provided tables or producer outputs.
- Validate quarter-end coverage immediately before/after each included call without treating one sampled row as full history.
- Confirm any locally available TFN source can lawfully support the author’s exact products and construction before mapping it into the workflow.

### A005: Resolve ticker history inputs and the SAS CRSP libref mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R009, R010, I002
Evidence: E_CRSP_SYMBOL_MAP, E_CATALOG_CRSP, E_CRSP_STOCKNAMES_PROBE, E_SAS_LIBNAMES

Preparation / proposed procedure:

1. Use the verified local CRSP.STOCKNAMES candidate for the `stocknames` fallback only after mapping the `crsp` libref to the local catalog path.
2. Ask the author to confirm whether CRSP.STOCKNAMES TICKER/NAMEDT/NAMEENDDT is semantically equivalent to the `dsfhdr` HTSYMBOL/BEGDAT/ENDDAT contract; if not, obtain the exact author-compatible header table.
3. Confirm any mapping preserves effective-date semantics and avoids changing the primary/fallback match order.

Validation to perform later:

- Validate the local stock-name table fields and full date coverage before use; the existing probe read only one row.
- Compare the author-confirmed header-field definitions and call-date matching behavior before proposing a source mapping.
- Check future PERMNO match coverage and duplicate/overlapping effective-date records on authorized data.

### A006: Obtain the JWZ1 regdata producer or a compatible author-prepared regdata input.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R011, I004
Evidence: E_JWZ_REGDATA, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the JWZ1 program/version and its `regdata.sas7bdat` output or the author-prepared input with its codebook.
2. Confirm definitions, identifier types and coverage for all joined analyst-coverage, call-count, NAN/QNAN, LMVQ, BTMQ and GVKEY fields.
3. Preserve the exact TICKER/CCDATE/TIME join used by the supplied SAS script.

Validation to perform later:

- Verify every selected `regdata` field and join key against the supplied SAS select list.
- Confirm call-date history/population coverage for the author’s full sample and that the author version is the one consumed by JWZ2.

### A007: Resolve the IBES custom-table producers and the external IBES libref.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R012, R013, I005, I002
Evidence: E_IBES_READS, E_CATALOG_IBES, E_PACKAGE_INVENTORY, E_SAS_LIBNAMES

Preparation / proposed procedure:

1. Request the `ibes.enews` and `ibes.dispersion` author-prepared tables or their original construction code and exact data dictionaries.
2. Identify the I/B/E/S product tables, release, measure/forecast selection, PERMNO mapping and date rules used to construct ENEWS and DISPERSION.
3. Confirm the SAS `ibes` libref and library startup configuration; the frozen catalog’s raw/detail products are discovery candidates, not direct substitutes.

Validation to perform later:

- Verify that ENEWS, PERMNO, ANNDATS_ACT, FPEDATS and DISPERSION fields match the SAS joins with correct date types and coverage.
- Check announcement and forecast-period windows against calls on authorized full data.
- Confirm the IBES libref resolves to the exact intended product version before any future author-code execution.

### A008: Obtain the author-specific NII exclude input and producer contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R014, I006
Evidence: E_NII_INPUT, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request `nii_exclude.sas7bdat`, its codebook, and the author’s preparation script or complete cited provenance.
2. Confirm the meaning/units of PIO0/PIO1, NII0/NII1 and SHROUT1, plus the source interval fields RDATE0/RDATE1 and the call-date population covered.
3. Do not infer a substitute from TFN holdings or other files without author documentation.

Validation to perform later:

- Verify the file’s TICKER and interval keys plus all selected variables against the SAS query.
- Validate coverage for all intended calls and clarify interval endpoints before using the input.

### A009: Obtain the custom CRSP quarterly firm-age producer or the author-prepared table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R015, I007
Evidence: E_CRSP_AGE, E_CATALOG_CUSTOM_NAMES, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the exact `crspdcqtr_winsor` table/codebook or its producer and winsorization specification.
2. Confirm definitions and units for PERMNO, CDATADATE and FIRMAGEMONTH, the date interval used by the join, and full sample coverage.
3. Do not replace this custom quarter-level table with raw daily CRSP based only on the filename.

Validation to perform later:

- Check the prepared table’s fields, types, quarter dates and FIRMAGEMONTH values against the author’s specification.
- Validate that a qualifying CDATADATE exists for each included event under the code’s strict date condition.

### A010: Map the verified local CRSP daily file to the `crsp.crspd` name expected by the SAS program.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R016, I002
Evidence: E_CRSP_DAILY_PRICE, E_CATALOG_CRSP, E_CRSP_DSF_PROBE, E_SAS_LIBNAMES

Preparation / proposed procedure:

1. Configure the authorized SAS library/data view so the local catalog-listed CRSP.DSF fields PERMNO, DATE and PRC are exposed as the `crsp.crspd` input, preserving the original CRSP fields.
2. Do not change the author source code until the chosen libref/table mapping is checked across every dependent call.

Validation to perform later:

- Verify the mapped dataset resolves the exact PERMNO, DATE and PRC fields with compatible types.
- Check full call-date coverage and PRC availability on each event date before any analysis attempt.

### A011: Configure the Compustat short-interest libref against the verified local table and confirm month coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R017, I002
Evidence: E_SHORT_INTEREST, E_CATALOG_COMP, E_COMP_SHORTINT_PROBE, E_SAS_LIBNAMES

Preparation / proposed procedure:

1. Set up the SAS `comp` libref using the authorized catalog-listed COMP.SEC_SHORTINT location or an equivalent site-managed mapping; the source program does not define this libref.
2. Preserve the code’s 2001–2009 source filter and month-before/month-after joins while confirming whether edge calls require months outside that filter.

Validation to perform later:

- Verify GVKEY, DATADATE and SHORTINTADJ types and full 2001–2009 date coverage on authorized data.
- Confirm intended call-date boundaries and whether December 2000/January 2010 rows are needed before accepting the generated zeros at boundary events.

### A012: Resolve the origin, timing and units of SHROUT90 before using short-interest percentages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I008
Evidence: E_SHROUT90, E_CLEANDATA_MATCH

Preparation / proposed procedure:

1. Ask the author which consumed input carries SHROUT90, its construction date relative to each call and its units/scaling.
2. If SHROUT90 comes from an upstream dataset, obtain that dataset’s schema and producer; do not infer it from SHROUT1 or from CRSP daily shares.

Validation to perform later:

- Verify SHROUT90 is populated with the intended denominator and scale for the author’s calls before evaluating PCTSHORT_BEFORE/AFTER.
- Confirm any missing values and boundary handling against author documentation.

### A013: Obtain the missing analysis stage and identify a durable handoff from SAS preparation to the reported appendix tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I009
Evidence: E_SAS_OUTPUT, E_APP_A1, E_APP_A2, E_APP_A3, E_APP_A4, E_APP_A5, E_APP_A6, E_KEYLIST_PROBE, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the regression/analysis programs and required run order for Tables A1–A6, plus any additional main-paper analysis entry points.
2. Clarify whether `addconc` is the final intended analysis dataset or one intermediate, and specify the permanent output path/schema consumed by each analysis.
3. Do not create an analysis-only scope from `jargvkey.xlsx`; its bounded probe observes only the `gvkey` column, not full analysis inputs or analysis code.

Validation to perform later:

- Map every author-documented reported table/figure to a supplied entry point and input dataset before declaring closure.
- After an authorized run, verify the permanent preparation output exists with the fields expected by the actual downstream analysis programs and compare table outputs under the author’s specification.

### A014: Resolve the existing SAS startup failure with the environment owner before any author-code execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S001, I010
Evidence: E_ENV_PROBE

Preparation / proposed procedure:

1. Have the SAS environment owner diagnose the recorded TKELS initialization failure and confirm the installed release/entitlement through approved administrative channels.
2. Do not infer that the SAS license is absent from this failure and do not retry startup as part of this static assessment.

Validation to perform later:

- After the environment owner resolves the issue, run a separately authorized no-data SAS smoke check and record the actual release and successful startup before considering the supplied SAS program.

### A015: Document every SAS libref, working directory and path mapping required by the supplied program.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I002
Evidence: E_SAS_LIBNAMES, E_IBES_READS, E_SHORT_INTEREST, E_PYTHON_CWD

Preparation / proposed procedure:

1. Request or provide the author’s intended autoexec/setup, including IBES and COMP librefs, local mapping of the author’s absolute paths, and the process current directory used by parser lexicons/output.
2. Keep directory identity explicit for same-basename files and confirm all mappings point to the intended dataset versions.

Validation to perform later:

- Before any authorized run, list and verify each required libref/table and parser working-directory asset against the exact prepared-input contracts.
- Check all affected producers and consumers together before proposing any path edit.

### A016: Obtain the manual workbook and procedure, then validate generic spreadsheet editing and export compatibility with the SAS handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I011
Evidence: E_MANUAL_EXCEL, E_SPREADSHEET_PROOF, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Obtain the actual manual cleaning workbook and step-by-step procedure; neither is included in the released package.
2. Use a copy of the workbook with the available LibreOffice Calc editor for generic table sorting, visual review and editing; exact Microsoft Excel identity or author permission is not a prerequisite for those operations.
3. Validate generic import/export behavior against the SAS handoff fields, date/time types, participant identifiers and manual classification outputs.
4. Ask the authors for clarification only if the workbook relies on genuinely Excel-specific features or if the manual decision/input contract remains undocumented.

Validation to perform later:

- Confirm the supplied workbook opens and generic edits/export preserve relevant values, sheets and required data types.
- Compare exported headers, date/time fields and join keys to the `cleandata`, `match` and tone-table SAS input contracts before proceeding.
- Record any specific Excel-only feature or unresolved manual classification rule that prevents a compatible editor workflow.

### A017: Obtain the I/B/E/S brokerage-code-to-name crosswalk and confirm the documented alternative branch used for manual sell-side exclusions.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R018, I012
Evidence: E_BROKER_CODES, E_BROKER_MAP_AUTHOR, E_CATALOG_IBES

Preparation / proposed procedure:

1. Request the author-provided code-to-full-name map, or confirm which documented alternative is used: detail EPS ESTIMATOR or detailed recommendation ESTIMID.
2. Record the exact I/B/E/S table/version and the mapping needed to translate selected codes into brokerage names, including inactive/defunct brokerages when applicable.
3. Keep this sell-side exclusion crosswalk separate from the 13F MGRNO matching and from the custom ENEWS/DISPERSION input products.

Validation to perform later:

- Verify all codes in the manual affiliation screen map to the intended brokerage names and preserve the author’s exclusions.
- Confirm the chosen ESTIMATOR or ESTIMID branch and crosswalk coverage with the authors before completing the Excel classification.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The parser writes `qa_parse.csv` with lowercase transcript/tone columns, while SAS separately reads `home.cleandata`, `home.match` and `jwzhome.qa_parse_confqa_mjj2`. The datasheet says affiliation cleaning/classification was manual and provides no cleaning code. The producer-to-consumer mapping, import rules, manual decisions and schemas are not documented; the parser output does not establish AMASKCD/EMASKCD, SICH/QTR, SHROUT90 or the author-specific SAS tables.
- I002 [unresolved; full_pipeline]: The script defines CRSP, TFN, JWZ, JWZHOME and HOME librefs at author-specific absolute paths. It reads `ibes.enews`, `ibes.dispersion` and `comp.sec_shortint` without defining IBES or COMP in this source; an external autoexec/site setup may exist but is not supplied. Current working directory and runtime libref mapping therefore remain unresolved.
- I003 [unresolved; full_pipeline]: The supplied code consumes custom `tfn.portvalue` and `tfn.pctofport2000`, while the datasheet says 13F affiliation matching is manual. No producer, exact 13F version/fields, manager-to-MGRNO procedures, aggregation formulas, quarter-end coverage or derived-file contract is supplied. The local TFN.S34 catalog candidate probe timed out and is not evidence of absent access.
- I004 [unresolved; full_pipeline]: The SAS source labels the `jwz.regdata` join as “ADD VARIABLES FROM JWZ1” but no JWZ1 program, data file or generation specification is included. Required fields and call-key join are visible; their producers, field definitions and period remain unknown.
- I005 [unresolved; full_pipeline]: `ibes.enews` and `ibes.dispersion` are required custom tables with different event-window joins. The frozen catalog lists I/B/E/S detail/actuals/summary source families but not exact aliases or producers; the code does not define the IBES libref or explain their construction. No raw product is assumed to substitute directly.
- I006 [unresolved; full_pipeline]: The code reads `home.nii_exclude` with custom interval and NII/portfolio fields; no producer, source mapping or data dictionary is supplied.
- I007 [unresolved; full_pipeline]: The code reads custom `crspdcqtr_winsor` and joins on PERMNO/CDATADATE to obtain FIRMAGEMONTH, but the quarter-level source and construction/winsorization are not supplied. Do not infer a formula from the custom filename or substitute raw daily CRSP.
- I008 [unresolved; full_pipeline]: The SAS script uses SHROUT90 in both short-interest percentage denominators but does not assign it in this file. It could be carried by `home.cleandata` or an upstream input; because those schemas are unavailable, its producer, timing and units are unresolved rather than proven absent.
- I009 [unresolved; full_pipeline]: The online appendix reports Tables A1–A6, but the supplied code ends after building `addconc`; it contains no regression program or permanent output/export for the constructed dataset. No analysis-only scope is supported by the GVKEY-only spreadsheet probe.
- I010 [unresolved; full_pipeline]: The already-supplied environment artifact reports that the SAS executable could not initialize TKELS. This establishes an environment startup failure in that probe only; it does not establish absent license/entitlement, and no new startup attempts were made.
- I011 [unresolved; full_pipeline]: The authors describe manual cleaning/classification in an Excel file, but the actual working workbook, detailed manual decisions, target output schema and import/export conventions are absent. LibreOffice Calc 25.2.3.2 is available as a candidate editor; compatibility with that missing workbook and handoff has not been validated. A compatible editor can handle generic spreadsheet operations without author permission or exact Excel identity; clarification is needed only for genuinely Excel-specific behavior or undocumented input contracts.
- I012 [unresolved; full_pipeline]: The manual buy-side classification step requires excluding sell-side firms using an I/B/E/S brokerage-code-to-name map. The datasheet documents either ESTIMATOR from detail EPS or ESTIMID from detail recommendations and offers a code-to-name file from the authors; neither the map nor chosen branch is included. This crosswalk is distinct from the 13F MGRNO firm match and from the derived ENEWS/DISPERSION tables.
- R001 [undetermined]: Raw StreetEvents transcript text read by the embedded parser; required fields include issuer/ticker/date/time, participants and affiliations, and prepared remarks/Q&A text. The full population date range is not stated; 2009 is the acquisition year, while the SAS tone join is filtered to 2002-04-01 through 2009-03-31.
- R002 [undetermined]: The parser requires positive and negative word-list files named `positive` and `negative`, read from the process current directory, plus a compatible `stemmer.PorterStemmer` module.
- R003 [undetermined]: Author-prepared `home.cleandata.sas7bdat` consumed as the core participant/call dataset. The code requires at least AMASKCD, EMASKCD, FILE_NAME, TICKER, CCDATE, TIME, ANALYST, AFFILIATION, SET and downstream industry/quarter/denominator fields; the input schema is not supplied.
- R004 [undetermined]: Author-prepared `home.match.sas7bdat` joined on FILE_NAME, TICKER, CCDATE, TIME, ANALYST and AFFILIATION to supply MGRNO. The authors describe manual affiliation classification against Thomson Reuters 13F and say they may share the derived list with researchers who hold the source agreement.
- R005 [undetermined]: Author-prepared `jwzhome.qa_parse_confqa_mjj2.sas7bdat` tone/word-count table joined to call participants by six event/participant keys. Required output fields include DIALOGUES, ANALYST_WORDS/POS/NEG, CEO_WORDS/POS/NEG and CFO_WORDS/POS/NEG; its producer and CSV-to-SAS mapping are not supplied.
- R006 [undetermined]: Thomson Reuters 13F source data used by the authors to classify buy-side affiliations and retained MGRNO, and to construct portfolio holdings inputs. The author documentation describes manual use of the 13F database; exact data product/version and population history are not specified.
- R007 [undetermined]: Custom `tfn.portvalue.sas7bdat` table joined to buy-side MGRNO at quarter-end dates before and after each call; the SAS code expects NUMFIRMS and PORTVALUE. No producer or full date coverage contract is supplied.
- R008 [undetermined]: Custom `tfn.pctofport2000.sas7bdat` table joined by ticker, MGRNO and quarter-end RDATE to supply holdings/share/price/value/portfolio-share variables. No producer or construction details are supplied.
- R009 [undetermined]: CRSP ticker-to-PERMNO header history consumed as `crsp.dsfhdr`, with HTSYMBOL, BEGDAT and ENDDAT used for date-effective matching. The frozen local catalog has a stock-name candidate with differently named fields, but equivalence is unverified.
- R011 [undetermined]: Custom `jwz.regdata.sas7bdat` attributed in code to JWZ1 and joined on TICKER, CCDATE and TIME. It supplies analyst coverage variables, NUMCALLERS, NAN/QNAN, LMVQ, BTMQ and GVKEY; no producer or source-history contract is supplied.
- R012 [undetermined]: Custom `ibes.enews` table joined by PERMNO and actual announcement date within one day of conference call. The exact ENEWS construction, required I/B/E/S source file, dates and libref are unspecified.
- R013 [undetermined]: Custom `ibes.dispersion` table joined by PERMNO and FPEDATS with FPEDATS < call date < FPEDATS+90. The dispersion construction and source fields/period are not specified.
- R014 [undetermined]: Custom `home.nii_exclude.sas7bdat` table joined by TICKER over RDATE0 < CCDATE < RDATE1 to provide PIO0/PIO1, NII0/NII1 and SHROUT1. Its construction, identifiers and period are unknown.
- R015 [undetermined]: Custom `crsp.crspdcqtr_winsor.sas7bdat` table joined by PERMNO and a quarter date to provide FIRMAGEMONTH. The underlying construction/winsorization and required historical range are not supplied.
- R018 [undetermined]: Manual exclusion of sell-side broker affiliations requires a code-to-full-brokerage-name mapping. The datasheet documents two alternative code branches—ESTIMATOR from the detail EPS file or ESTIMID from the detail recommendation file—and says a researcher mapping file is available from the authors upon request. The branch used, historical codes and mapping file are not supplied.
- S001 [unverified]: Required for `jwz2_201707.sas`. The supplied environment artifact records an attempted SAS 9.4 path but failure to initialize TKELS; no version, license state or author-code compatibility was established.
- S002 [preparation_required]: The embedded parser uses Python 2 syntax (`print doc`); neither `python2` nor `python2.7` was found on PATH. The available Python 3.12.14 runtime does not establish compatibility with the supplied script.
- S003 [unverified]: The parser imports this exact module/API and calls PorterStemmer.stem(word, start, end); the module is not listed in the package inventory and its environment availability/version was not checked. Do not substitute another stemmer without author confirmation.

## Review notes

- No analysis_only scope is declared: the supplied code lacks the regression stage, and the bounded spreadsheet probe observes only a GVKEY identifier column rather than compatible analysis data.
- The appendix documents Tables A1–A6. The only SAS program constructs WORK datasets and ends after `addconc`; no permanent final-data export or regression program is supplied.
- The parser’s current directory matters: transcript source directory/output defaults and the relative positive/negative lexicon reads are separate contracts.
- One-row probes verify readability/fields only, not complete row populations, source coverage, sample history, license status or cross-source match rates.
- The tone table filter is 2002-04-01 through 2009-03-31. Short interest is filtered to 2001–2009 but joins the preceding and following calendar months; required boundary coverage must be checked without transferring one input’s window to all sources.
- CRSP.DSF and CRSP.STOCKNAMES plus COMP.SEC_SHORTINT are verified local field-compatible routes by bounded probes. Their full date coverage and the SAS libref mappings remain open preparation checks.
- The Thomson 13F local probe timed out and is retained as unverified. Catalog misses, this probe failure and the author’s redistribution restriction do not establish absent license or universal access barriers.
- The datasheet refers to `jwz2_201717.sas`, while the supplied entry file is `jwz2_201707.sas`; the assessment uses the supplied file and leaves the naming discrepancy for clarification if needed.
- LibreOffice Calc 25.2.3.2 is available for generic spreadsheet operations. Compatibility with the missing author workbook and SAS import/export schema still needs validation; the missing `excel` PATH command does not prove a license or GUI is absent, and exact Excel identity is not a prerequisite.
- The manual I/B/E/S broker-name crosswalk is a separate requirement from the 13F MGRNO match and from ENEWS/DISPERSION. The authors document either ESTIMATOR (detail EPS) or ESTIMID (detail recommendation) and an author-supplied mapping file; these routes remain unverified.
