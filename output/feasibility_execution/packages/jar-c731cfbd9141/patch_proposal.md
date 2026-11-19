# Patch proposal: jar-c731cfbd9141

The Information Role of the Media in Earnings News?

DOI: 10.1111/1475-679X.12349

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All five supplied Python collection/analysis programs and the SAS data-construction and analysis program, in the documented order, including the manually prepared handoffs they consume.

Entry points: `1CollectMediaCoverage.py`, `2AnalyzeMediaCoverage.py`, `3CollectPressReleases.py`, `4AnalyzePressReleases.py`, `5CompareMediaCoverageAndPressReleases.py`, `Guest_MediaEarnings_FinalDatasetAndAnalyses.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12349 - The-Information-Role-of-the-Media-in-Earnings-News/guest-datasheet-code-and-identifiers.zip",
      "sha256": "27e60c81b89b490966c59712c1efb002d7d697903341b6f849e42fc2b5473f90"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12349 - The-Information-Role-of-the-Media-in-Earnings-News/guest-internet-appendix.pdf",
      "sha256": "24190ef650d28f22917afaf693a9d9ce98d46459461b20caecc6ad4fd12b5904"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "540e2c535d89700fe61753c40870c14fc7b44a9ade4f326133c08e931abd0ee9"
}
```

## Proposed actions

### A-WORKFLOW-CLOSURE: Follow the documented six-entry order and close each producer-to-consumer handoff before assessing any runnable state.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-WORKFLOW-CLOSURE
Evidence: E-ORDERED-WORKFLOW, E-README, E-PY1-FEED, E-PY1-OUTPUT, E-PY2-LEX, E-PY2-OUTPUT, E-PY3-INDEX, E-PY3-CLEANED, E-PY4-LIST, E-PY4-APPEND, E-PY5-INPUT, E-PY5-OUTPUT, E-SAS-LIBS, E-SAS-HANDOFF, E-SAS-GC1, E-SAS-TEXT-JOIN, E-SAS-CHECKPOINTS, E-SAS-CEM-CALL, E-APPENDIX-SUMMARY, E-CATALOG-CORE, E-PY5-WSJ-ROOT

Preparation / proposed procedure:

1. 1. Follow the README entry order: 1CollectMediaCoverage.py → 2AnalyzeMediaCoverage.py → 3CollectPressReleases.py → 4AnalyzePressReleases.py → 5CompareMediaCoverageAndPressReleases.py → Guest_MediaEarnings_FinalDatasetAndAnalyses.sas. The Factiva and SEC producer/analysis branches are independent until the pair-comparison stage. [E-README, E-ORDERED-WORKFLOW]
2. 2. Factiva branch: provide SP1500_feeditpy.csv → Python 1 writes under Factiva Articles/WSJ → Python 2 actively reads Documents/WSJ plus StopWords.txt and LM_negwords.txt → PressCoverage2020safe.txt. Python 5 later actively reads WSJ articles under a third Research/.../Data/Media Coverage/Articles/WSJ root while comparing with CleanedFilings. Map all three roots to a coherent producer/consumer route; also resolve the missing medium/author_names/position fields for the main SAS PressCoverage join. [E-PY1-FEED, E-PY1-OUTPUT, E-PY2-INPUT-ROOT, E-PY2-LEX, E-PY2-OUTPUT, E-PY5-WSJ-ROOT, E-SAS-HANDOFF]
3. 3. SEC branch: pr_edgar.csv → Python 3 requests SEC Archives documents → CleanedFilings. Python 4 contains a commented CleanedFilings-to-PressReleases.txt producer; verify its filenames, order, and schema, then treat enabling/reusing that supplied block as a conditional preparation route. [E-PY3-INDEX, E-PY3-ARCHIVE, E-PY3-CLEANED, E-PY4-LIST]
4. 4. Release analysis: PressReleases.txt → Python 4 → append-mode PressReleasesData.txt → documented delimited import to mydir.PressReleasesData, then join pr_edgar_w8kitems. The current loop starts at row 150001. Reuse complete prior chunks OR, if the complete selected list/order and intended bounds are supported, use the supplied first-run/header block with a supported fresh-run configuration. Do not assume either route or reset counters blindly. [E-PY4-APPEND, E-PY4-OUTPUT, E-SAS-HANDOFF]
5. 5. Pair comparison: MatchPRandPC.csv plus the Factiva article files and CleanedFilings → Python 5 → append-mode AnalyzedMatches.txt → documented delimited import to ta.AnalyzedMatches. The current loop starts at match 311001. Reuse complete prior chunks OR use a supported fresh-run configuration only after full pair-list ordering and intended bounds are established; the pair-list producer remains unresolved. [E-PY5-INPUT, E-PY5-OUTPUT, E-SAS-TEXT-JOIN]
6. 6. SAS source setup and local merges: establish the declared librefs/remote session and in-file macros → consume PressCoverage + sp1500.sp1500 and PressReleasesData + pr_edgar_w8kitems → create gc1 → upload to WRDS. Separately resolve PressCoverage2020: its SAS import is commented out although its later Table 8 consumer is active. [E-SAS-LIBS, E-SAS-GC1, E-SAS-HANDOFF, E-SAS-IMPORT-COMMENT]
7. 7. Continue through SAS's source-ordered WRDS/local construction: Compustat annual and CRSP/Compustat links → CRSP monthly history → IBES summary and SEC forms → RavenPack yearly events → CRSP daily/index returns → MIA and quarterly earnings inputs → IBES detail/ICLINK and membership/ownership merges → prior-volatility and later RavenPack/TAQ branches → dated checkpoints. Confirm the wrds_gc15 date mismatch and actual table/period mappings before treating any branch as closed. [E-SAS-FUNDA-LINK, E-SAS-CRSP-MONTH, E-SAS-IBES-FORMS, E-SAS-RAVEN-DJ, E-SAS-DSF-DSI, E-SAS-MIA, E-SAS-EARNINGS, E-SAS-IBES-ICLINK, E-SAS-SNAPSHOT, E-SAS-MATCHRV, E-SAS-TAQ, E-SAS-RP-LOCAL, E-SAS-RP-EQUITIES, E-SAS-CHECKPOINTS]
8. 8. Retain all supplied analysis branches after data construction: main regressions and figures, CEM matching, active Table 8, and the seven Internet Appendix analyses. Obtain the missing L1-family macro source before closing CEM; do not infer that the main regression substitutes for other supplied branches. [E-SAS-CEM-CALL, E-SAS-PROCS, E-SAS-GRAPH, E-SAS-IMPORT-COMMENT, E-APPENDIX-SUMMARY, E-CEM-MACRO-INVENTORY]
9. Keep the unresolved paths, schema gaps, SEC/match indexes, source products, and checkpoint provenance explicit in the handoff matrix; use the linked ordered trace for the full producer→intermediate→consumer map. [E-ORDERED-WORKFLOW]

Validation to perform later:

- Review the linked ordered trace against the source line citations and confirm each cross-language producer/consumer path, schema, ordering rule, and remaining unknown before any separately authorized execution.
- Verify each of the two append-only programs through either complete existing chunks or a supported full-run configuration with confirmed input ordering and intended bounds; neither alternative is assumed in this assessment.
- Confirm the source order, dated checkpoint names, all included analysis branches, and required macro definitions without dropping stages or changing scientific selection/counters.

### A-WORD-LISTS: Recover the exact author word lists and confirm the historical LM negative-word version used by both analysis programs.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-STOPWORDS, R-LM-NEG
Evidence: E-PY2-LEX, E-LM-PUBLIC

Preparation / proposed procedure:

1. Obtain the author-expanded StopWords.txt or its exact construction rules.
2. Identify the LM release and transformation used to create LM_negwords.txt; compare the official current public candidate only as a version check, not as an assumed substitute.

Validation to perform later:

- Check each list's line format, encoding, version/hash, and the parser's expected tokens before analysis.

### A-FACTIVA-FEED: Resolve the SP1500 feed and map the three distinct WSJ article roots used across collection, analysis, and comparison.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-SP1500-FEED, R-FACTIVA-WSJ, I-FACTIVA-PATH-MISMATCH
Evidence: E-PY1-FEED, E-PY1-OUTPUT, E-PY2-INPUT-ROOT, E-PY5-WSJ-ROOT, E-SAMPLE-IDS, E-ID-WORKBOOK

Preparation / proposed procedure:

1. Identify the exact feed with the ticker/name aliases and start/end membership dates consumed positionally by Python 1.
2. Locate the Factiva WSJ article text and metadata for the study period, then configure a coherent supported producer/consumer remap across all three source roots: Python 1 writes Factiva Articles/WSJ, Python 2 actively reads Documents/WSJ, and Python 5 actively reads Research/.../Data/Media Coverage/Articles/WSJ.
3. Keep the 494-firm workbook separate from the 1,500-company feed and from the article corpus.

Validation to perform later:

- Verify file counts, firm/article identifiers, dates, aliases, and text presence for the intended collection universe; do not infer access denial from an absent local copy.

### A-SEC-COLLECTION: Recover the author SEC index/list workflow and document a compliant public filing retrieval configuration.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-SEC-INDEX, R-SEC-FILINGS, R-PRESSRELEASES-LIST, I-PR-LIST-PRODUCER, I-SEC-REQUEST-POLICY
Evidence: E-PY3-INDEX, E-PY3-ARCHIVE, E-PY3-CLEANED, E-PY4-LIST, E-SEC-PUBLIC, E-SEC-POLICY

Preparation / proposed procedure:

1. Obtain or specify how pr_edgar.csv was assembled and verify its filing/exhibit URL, issuer identifier, date fields, and selected period.
2. The supplied Python 4 commented block can be conditionally reused to create PressReleases.txt from CleanedFilings after verifying file naming, row order, and positional schema; it is not an absent algorithm.
3. Before any separately authorized collection, set an attributable SEC User-Agent and follow current SEC request guidance.

Validation to perform later:

- Compare the complete index and generated PressReleases.txt fields and filing periods with Python 3/4 positional reads; confirm the public archive route covers the selected filings.

### A-MATCH-INDEX: Identify the author producer or exact existing source for MatchPRandPC.csv.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-MATCHPRPC, I-MATCH-LIST-PRODUCER
Evidence: E-PY5-INPUT, E-README

Preparation / proposed procedure:

1. Recover the match-generation rule and the exact pair index joining company, article filename/date, and release filename/date.
2. Preserve its row ordering and row identifiers because Python 5 resumes at a fixed row index.

Validation to perform later:

- Check the index column order, unique pair keys, referenced files, and date alignment against the two source corpora.

### A-PYTHON-SAS-HANDOFFS: Document the actual delimited-text and SAS-dataset conversions and reconcile the distinct article and release schemas.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-PRESSCOVERAGE, R-SP1500-CROSSWALK, R-PRESSRELEASESDATA, R-SEC-W8KITEMS, R-ANALYZEDMATCHES-SAS, R-PRESSCOVERAGE2020-SAS, I-PRESSCOVERAGE-SCHEMA, I-PYTHON-SAS-HANDOFF, I-PRESSCOVERAGE2020-IMPORT
Evidence: E-PY2-OUTPUT, E-SAS-HANDOFF, E-PY4-OUTPUT, E-PY5-OUTPUT, E-SAS-TEXT-JOIN, E-SAS-IMPORT-COMMENT

Preparation / proposed procedure:

1. Obtain the actual PressCoverage and PressReleasesData SAS inputs and their producers or define supported imports from the author's text outputs.
2. Resolve the missing medium/author_names fields for the online/print promotion logic; do not synthesize them from fields the Python analyzer does not produce.
3. For PressCoverage2020, document a delimited import from the Python 2 safe output or recover the intended workbook/import step while preserving the active Table 8 branch.
4. Retain the exact `fname`/nitem/issuer keys used by the SEC metadata join.

Validation to perform later:

- Compare input headers and types to every SAS join/filter; verify that all values used for medium, authors, article/release IDs, dates, and linguistic measures map without silent loss.

### A-WRDS-TABLES: Confirm the named WRDS and RavenPack products, access route, table versions, fields, and historical coverage used by the source code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-COMP-FUNDA, R-CRSP-CCMXPF, R-CRSP-MSF, R-IBES-SUM, R-WRDS-FORMS, R-RAVEN-DJ-YEARS, R-CRSP-DSF, R-CRSP-DSI, R-COMP-FUNDQ, R-IBES-DET, R-COMP-SECM, R-CRSP-MSENAMES, R-RAVEN-EQUITIES
Evidence: E-DATASHEET, E-SAS-FUNDA-LINK, E-SAS-CRSP-MONTH, E-SAS-IBES-FORMS, E-SAS-RAVEN-DJ, E-SAS-DSF-DSI, E-SAS-COMPQ, E-SAS-IBES-ICLINK, E-SAS-CRSP-NAMES, E-SAS-RP-EQUITIES, E-CATALOG-CORE, E-CATALOG-FOLLOWUP

Preparation / proposed procedure:

1. For each exact table, confirm the local or WRDS route and map source fields to code variables over the required event years and pre-event history.
2. Treat catalog rows as candidates until field/period compatibility and access are established.
3. Keep the RavenPack Dow Jones yearly, local rp_dj, and rp_equities year-series as separate inputs unless a documented mapping proves equivalence.

Validation to perform later:

- Check required keys, validity dates, return/price/volume fields, announcement/fiscal dates, and complete table-year coverage against the code's filters and merges.

### A-AUTHOR-PREPARED-INPUTS: Recover the author-prepared supporting datasets and their construction/field specifications.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-MIA-PREPARED, R-ICLINK, R-INSTOWN, R-TAQ-RETAIL, R-RAVEN-DJ-LOCAL
Evidence: E-SAS-MIA, E-SAS-IBES-ICLINK, E-SAS-SNAPSHOT, E-SAS-TAQ, E-SAS-RP-LOCAL, E-CATALOG-CORE, E-CATALOG-FOLLOWUP

Preparation / proposed procedure:

1. Identify the exact MIA, ICLINK, institutional ownership, retail-classified TAQ, and local cleaned RavenPack files or documented producers.
2. For TAQ retail measures, preserve the author classification procedure and its 2006 start/60-day baseline, rather than substituting raw TAQ without a mapping.

Validation to perform later:

- Confirm each prepared table's identifier/date fields, construction version, and study-period coverage before using it in SAS.

### A-RECONCILE-CHECKPOINT: Reconcile the two gc15 checkpoint names and dates from author provenance before changing any SAS path.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-WRDS-SNAPSHOT-MISMATCH
Evidence: E-SAS-SNAPSHOT

Preparation / proposed procedure:

1. Confirm whether the June 2017 snapshot is a required prior state or whether the September 2017 download name is intended for the next join.
2. Preserve the selected snapshot's actual field construction and sample state; do not rename or substitute solely to make the path resolve.

Validation to perform later:

- Trace the confirmed checkpoint producer/consumer names and verify key/date consistency from source metadata before a future SAS run.

### A-RESTORE-CEM-HELPERS: Recover the exact authors' L1, L1_Nest, and L1_Nest_W macro definitions or documented include file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-CEM-MISSING-MACROS
Evidence: E-SAS-CEM-MISSING-CALLS, E-SAS-CEM-NESTED-CALLS, E-SAS-CEM-WEIGHT-CALL, E-CEM-MACRO-INVENTORY

Preparation / proposed procedure:

1. Ask for the source definitions and any documented macro search-path setup used for the matching procedure.
2. Keep the existing CEM call, Sturges binning, treatment/control design, and matching summaries intact.

Validation to perform later:

- Confirm each macro's parameters, input/output names, and generated L1 tables from supplied author source before considering the CEM branch closed.

### A-RESTORE-PRIOR-CHUNKS: Complete the two append-only analyzer outputs through either existing complete chunks or a supported full-run configuration.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I-APPEND-CHUNK-HISTORY
Evidence: E-PY4-APPEND, E-PY5-INPUT, E-PY5-OUTPUT

Preparation / proposed procedure:

1. For each script, first check whether complete prior output chunks and the intended header already exist; if so, preserve and verify their row order, keys, and cumulative state.
2. Alternatively, when the complete selected input/index ordering and intended full bounds are established, use the supplied first-time/header blocks with a supported fresh-run configuration to regenerate the complete output.
3. Python 4 currently starts at row 150001 and Python 5 at match 311001; the suffix-only runs are incomplete by themselves. Do not require original prefix bytes as the only route and do not reset scientific selection/counters blindly.

Validation to perform later:

- Reconcile full row counts, headers, file references, and row keys across prior and continuation chunks before any analysis.

### A-PYTHON-RESOURCES: Verify the Python runtime/distributions, browser driver, Java runtime, Stanford resources, and NLTK data separately.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-PYTHON, S-PYTHON-LIBRARIES, S-FIREFOX-WEBDRIVER, S-JAVA, R-STANFORD-RESOURCES, R-NLTK-RESOURCES
Evidence: E-PY-IMPORTS, E-PY-COLLECTOR-IMPORTS, E-PY3-IMPORTS, E-PY5-IMPORTS, E-PY-BROWSER, E-PY4-RESOURCES, E-ENV

Preparation / proposed procedure:

1. Check package versions and required callable APIs in the intended Python environment without changing the author code's semantics.
2. Verify Firefox/WebDriver configuration, Java 8 compatibility, Stanford NER/POS JARs, the named MUC model, and NLTK tokenizer/tagger/chunker data as distinct resources.
3. Do not install packages or download model resources during this assessment.

Validation to perform later:

- Record exact versions/paths for the interpreter, distributions, browser/driver, Java, JAR/model resources, and NLTK data before a separately authorized run.

### A-SAS-ENVIRONMENT: Resolve the existing SAS environment startup diagnosis and confirm the required remote and procedure capabilities.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-SAS, S-SAS-CONNECT, S-SAS-PROCEDURES
Evidence: E-ENV, E-SAS-LIBS, E-SAS-REMOTE, E-SAS-PROCS, E-SAS-GRAPH

Preparation / proposed procedure:

1. Have the SAS environment owner diagnose the recorded TKELS initialization error; do not infer a licensing denial from it.
2. Separately confirm the SAS version/options, signon/rsubmit/upload/download capability, and availability of the source's EXPAND, SURVEYREG, SURVEYSELECT, SYSLIN, FACTOR, GPLOT, and SGPLOT procedures.

Validation to perform later:

- Record environment/procedure evidence and the WRDS access configuration before any later authorized execution; do not start SAS as part of this static assessment.

### A-DISABLE-OPTIONAL-NOTIFICATIONS: Disable the collection scripts' SMTP notification calls in a working-copy configuration before any future collection.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I-SMTP-NOTIFICATION-SIDE-EFFECT
Evidence: E-PY-NOTIFY-1, E-PY-NOTIFY-3

Preparation / proposed procedure:

1. Configure author-directed notifications off without copying, exposing, or reusing embedded SMTP values.
2. Keep the research collection logic and data-selection rules unchanged.

Validation to perform later:

- Review the working copy to confirm notification calls cannot send email and that no notification credentials remain in the execution configuration.


## Remaining issues and prerequisites

- I-WORKFLOW-CLOSURE [unresolved; full_pipeline]: The supplied six-program workflow has missing collection indexes, lexicons, text corpora, crosswalks, WRDS/author-prepared datasets, continuation history, and Python-to-SAS imports. Frozen catalog metadata and the identifiers-only workbook do not close these inputs.
- I-FACTIVA-PATH-MISMATCH [unresolved; full_pipeline]: Python 1 writes [redacted-path-3a3a93d4bae4] (MIT)\Factiva\Articles\WSJ; Python 2 actively reads [redacted-path-edb00205db97]; Python 5 actively reads [redacted-path-3a3a93d4bae4] (MIT)\Research\007 - Reporters as Analysts\Data\Media Coverage\Articles\WSJ. No supported producer/consumer remap among Python 1, Python 2, and Python 5 is supplied.
- I-PR-LIST-PRODUCER [preparation; full_pipeline]: Python 4 contains a commented block that can create PressReleases.txt from CleanedFilings. It is a potential preparation route, not an absent algorithm; reusing it is conditional on verifying its filenames, row order, and expected list schema.
- I-MATCH-LIST-PRODUCER [unresolved; full_pipeline]: Python 5 reads MatchPRandPC.csv; none of the six supplied programs produces the index or its required article/release pair mapping.
- I-APPEND-CHUNK-HISTORY [unresolved; full_pipeline]: Python 4 resumes at row 150001 and Python 5 at match 311001, appending to outputs with first-time/header blocks commented. Complete earlier chunks/header may be reused, or a supported fresh-run configuration may regenerate complete outputs when full selected input ordering and intended bounds are established. The current suffix runs alone are incomplete; neither alternative is verified, and counters/selections must not be reset blindly.
- I-PRESSCOVERAGE-SCHEMA [unresolved; full_pipeline]: SAS uses medium and author_names to identify online/print promotions, but Python 2's active output header omits medium, author_names, and position. No compatible author producer or field mapping is supplied.
- I-PYTHON-SAS-HANDOFF [unresolved; full_pipeline]: The Python programs write delimited text outputs, while SAS consumes named SAS datasets. The supplied source does not document imports or a schema-preserving conversion for PressCoverage, PressReleasesData, or AnalyzedMatches.
- I-CEM-MISSING-MACROS [unresolved; full_pipeline]: The supplied SAS source calls %L1, %L1_Nest, and %L1_Nest_W, whose definitions or includes are not present in this full file. Downstream L1_0 and L1_i tables therefore have unresolved producers.
- I-WRDS-SNAPSHOT-MISMATCH [unresolved; full_pipeline]: SAS downloads gc15 to mydir.wrds_gc15_20170912 but the next step reads mydir.wrds_gc15_20170621. The earlier checkpoint's provenance and intended date are unknown.
- I-PRESSCOVERAGE2020-IMPORT [unresolved; full_pipeline]: The Excel PROC IMPORT is inside a SAS block comment, but the following PressCoverage2020 consumer and Table 8 analysis are active. Python 2 produces a differently named text file and no import step.
- I-SEC-REQUEST-POLICY [preparation; full_pipeline]: The SEC page requires a declared User-Agent; the supplied urllib request uses urlopen without request headers. A compliant identifier and request pacing need configuration before any separately authorized collection.
- I-SMTP-NOTIFICATION-SIDE-EFFECT [preparation; full_pipeline]: The collection scripts include SMTP notification calls. Notification is operational and not a research input; disable it in a working-copy configuration before any future collection. No email, contact, or network action was performed.
- R-SP1500-FEED [undetermined]: The Factiva collector requires the separate SP1500_feeditpy.csv firm feed with company identifiers, names/aliases, and membership start/end dates; the 494-firm identifiers workbook does not supply this collection feed.
- R-FACTIVA-WSJ [undetermined]: The Factiva chain needs the WSJ articles and metadata downloaded from Factiva, including firm/article identity, dates, and text; no article corpus is included. Python 1 writes [redacted-path-3a3a93d4bae4] (MIT)\Factiva\Articles\WSJ; Python 2 actively reads [redacted-path-edb00205db97]; Python 5 actively reads [redacted-path-3a3a93d4bae4] (MIT)\Research\007 - Reporters as Analysts\Data\Media Coverage\Articles\WSJ.
- R-STOPWORDS [undetermined]: Both media analysis and comparison read the author-specific StopWords.txt, described as expanded generic/date/number stop words plus common English words; no matching file is packaged or generated by supplied code.
- R-LM-NEG [undetermined]: Media analysis and comparison read LM_negwords.txt. The exact list/version used by the authors is not packaged; the current public Loughran–McDonald negative list is only a candidate pending version and extraction confirmation.
- R-SEC-INDEX [undetermined]: The SEC collector needs author-prepared pr_edgar.csv with the filing/exhibit URLs and issuer/date fields accessed by positional columns; no producer for this index is in the six programs or package.
- R-SEC-FILINGS [undetermined]: The collector needs the cited SEC filing archive documents to extract Exhibit 99 press-release text. The filings themselves have a public SEC route, conditional on a complete filing index and compliant request configuration.
- R-PRESSRELEASES-LIST [undetermined]: Python 4 requires PressReleases.txt with issuer/filing/exhibit names for cleaned press releases. A producer block is supplied but commented out, providing a conditional preparation route once its list schema/order is verified.
- R-MATCHPRPC [undetermined]: Python 5 requires the separate MatchPRandPC.csv pair index with gvkey, permco, CIK, company, press-coverage and press-release filenames, and dates; no producer is supplied.
- R-PRESSCOVERAGE [undetermined]: SAS requires the imported mydir.PressCoverage article table with firm/article/date plus medium, author_names, and other article-level fields. Python 2 writes PressCoverage2020safe.txt without medium, author_names, or position and to a distinct path/name.
- R-SP1500-CROSSWALK [undetermined]: SAS joins company_name to sp1500.sp1500 and needs coname, gvkey, and permco. This 1,500-company crosswalk is distinct from the packaged 494-firm identifiers workbook.
- R-PRESSRELEASESDATA [undetermined]: SAS needs mydir.PressReleasesData after Python 4's tab-delimited PressReleasesData.txt is prepared. The supplied first-run/header block is present but commented; a delimited import is also needed, and the current loop emits only the suffix beginning at row 150001.
- R-SEC-W8KITEMS [undetermined]: SAS joins press-release files to SEC 8-K exhibit metadata and uses fname, nitem, nitemno, group, gvkey, CIK, filing date, SEC date, and release date.
- R-COMP-FUNDA [undetermined]: The main construction uses Compustat annual fundamentals, keyed by gvkey and datadate, to select accounting controls around each release.
- R-CRSP-CCMXPF [undetermined]: The construction requires CRSP/Compustat link history to map gvkey to permno over the relevant dates.
- R-CRSP-MSF [undetermined]: SAS needs CRSP monthly stock data from 1998 onward for size, turnover, and prior 12-month return history.
- R-IBES-SUM [undetermined]: The code uses IBES summary analyst consensus (including CUSIP, fiscal period, statistic period, and estimate counts) for event controls.
- R-WRDS-FORMS [undetermined]: SAS reads wrdssec.wrds_forms for historical 8-K form dates and related filing fields.
- R-RAVEN-DJ-YEARS [undetermined]: SAS appends rpna.dj_equities_&year for 2000–2017 and derives historical news coverage around each event.
- R-CRSP-DSF [undetermined]: The construction needs CRSP daily stock returns for pre-release volatility and event return windows, including lead/lag history.
- R-CRSP-DSI [undetermined]: The event return calculation also uses CRSP daily index returns to form market-adjusted buy-and-hold returns.
- R-MIA-PREPARED [undetermined]: The program uploads the separate author-prepared miadata2006to2015.sas7bdat table for market intraperiod analysis; no producer is included.
- R-COMP-FUNDQ [undetermined]: The earnings matching construction uses Compustat quarterly fundamentals and report dates.
- R-IBES-DET [undetermined]: SAS reads IBES detailed analyst estimates to link individual forecasts to earnings announcements.
- R-ICLINK [undetermined]: SAS uploads the author-supplied iclink.sas7bdat to map IBES tickers to Compustat identifiers; no producer is supplied.
- R-COMP-SECM [undetermined]: The program uses Compustat security-level membership history (SPMIM) to identify S&P 1500 firms near event dates.
- R-INSTOWN [undetermined]: The main data build needs the author-prepared instown_1980to2015.sas7bdat ownership history keyed by permno/date.
- R-TAQ-RETAIL [undetermined]: The appendix's retail/institutional volume analysis consumes the author-prepared TAQretail_060708121314.sas7bdat classification data; the SAS source does not produce it.
- R-RAVEN-DJ-LOCAL [undetermined]: The code also consumes a separate local cleaned rp_dj.sas7bdat table for Dow Jones/WSJ news counts.
- R-CRSP-MSENAMES [undetermined]: The SAS code uses CRSP.MSENAMES company-name history for RavenPack issuer mapping.
- R-RAVEN-EQUITIES [undetermined]: SAS uses yearly rpna.rp_equities_&year tables for 2004–2015, distinct from the Dow Jones yearly and local rp_dj inputs.
- R-ANALYZEDMATCHES-SAS [undetermined]: SAS needs ta.AnalyzedMatches.sas7bdat. Python 5 produces AnalyzedMatches.txt and contains a commented first-run/header block, but no active text-to-SAS import is supplied; its current loop appends only matches from 311001 onward.
- R-PRESSCOVERAGE2020-SAS [undetermined]: The Table 8 branch actively reads mydir.PressCoverage2020; its only visible Excel import is inside a block comment, while Python 2 writes a differently named tab-delimited safe file.
- R-STANFORD-RESOURCES [undetermined]: Python 4 requires a Stanford NER JAR, Stanford POS tagger JAR, and the english.muc.7class.distsim.crf.ser.gz model at author paths; these resources are separate from Python distributions and are not packaged.
- R-NLTK-RESOURCES [undetermined]: The Python analyses call NLTK sentence/word tokenization, POS tagging, named-entity chunking, and stopword resources; required NLTK data/model files are separate from installed Python distributions and are unverified.
- S-PYTHON-LIBRARIES [unverified]: The supplied scripts import these distributions. Their versions, callable compatibility, and availability in the selected Python environment are unverified; no package was installed or imported.
- S-FIREFOX-WEBDRIVER [unverified]: The Factiva collector calls webdriver.Firefox(); browser and driver availability/configuration were not probed.
- S-JAVA [unverified]: Python 4 sets a Java 8 executable path for Stanford NER; Java availability/version at that path is unverified.
- S-SAS [unverified]: The environment probe reports the SAS 9.4 executable path but no successful startup: TKELS initialization failed. This is not evidence of a missing license. No SAS retry or author program startup was performed.
- S-SAS-CONNECT [unverified]: The SAS source uses signon, rsubmit, and remote upload/download; the corresponding runtime capability and account configuration are unverified.
- S-SAS-PROCEDURES [unverified]: The code uses procedures including EXPAND, SURVEYREG, SURVEYSELECT, SYSLIN, FACTOR, GPLOT, and SGPLOT; their availability in the supplied SAS environment is unverified.

## Review notes

- Final source-based assessment after complete README/datasheet/appendix and six-program static review. Requirements, issues, software, source evidence, and all 209 frozen dependency IDs are mapped; the ordered workflow trace preserves the documented sequence and unresolved handoffs.
- The 494-firm identifiers workbook is readable as an identifier file, but it is not an analysis panel and does not supply the SP1500 feed, match index, press text, or required SAS tables.
- No author collectors, filing/data retrieval, SMTP, author code/model, SAS session, or regressions ran. Read-only public-source webpage verification is separately represented in the evidence; no filing or research-data retrieval occurred. Further discovery has stopped after the named source and catalog gaps were established.
- Software is recorded by exact source requirement: Python 3.12.14 is available, while package versions, browser/driver, Java, Stanford model/JAR resources, NLTK data, SAS runtime startup, remote-submit access, and required SAS procedures remain unverified.
- The full SAS file invokes three L1-family macros with no corresponding definitions or %INCLUDE statement in the supplied text; the downstream tables are left unresolved rather than assigned invented producers.
- Python 4 and 5 append from fixed suffix starts with disabled first-run/header blocks. Complete prior chunks/header may be reused, or a supported fresh-run configuration may regenerate complete outputs once selected-input ordering and intended bounds are established; neither route is verified, and counters/selections must not be reset blindly.
- SAS's PressCoverage2020 import is within a block comment; its later consumer remains active. Python 2's similarly named text output is a possible ordinary import source, not a verified SAS table.
- SMTP notification calls in the collection scripts are treated as optional side effects. Their values are excluded from evidence quotes and proposals; any future working copy should disable the calls before collection.
- Dependency coverage is grouped by supported disposition and source evidence; every frozen checklist ID D0001–D0209 appears exactly once. Generated SAS intermediates cite source-kind producer evidence, while missing macro outputs and unconnected text-to-SAS inputs remain linked to issues.
- Frozen catalog lookup results are candidate metadata only. No catalog miss is treated as proof of unavailable data or an access barrier; local readability and product compatibility remain unverified unless a bounded probe establishes them.
- Public SEC EDGAR access is recorded separately from the missing author filing index; the current public Loughran–McDonald dictionary is a version candidate rather than an assumed replacement for LM_negwords.txt.
- The disabled Python 4 PressReleases.txt list producer and the Python 4/5 first-run/header blocks are credited as conditional preparation routes; compatibility and full-output completeness remain unverified.
