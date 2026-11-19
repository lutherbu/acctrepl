# Patch proposal: jar-ebe858a8463f

Relative Performance Evaluation and Strategic Peer-Harming Disclosures

DOI: 10.1111/1475-679X.12543

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow across Stata peer/disclosure construction and R transcript text analysis. Both native branches, distinct inputs and generated stages are retained; no analysis-only input/code route or standalone model-estimation program is supplied.

Entry points: `BHT JOAR 2024 code (excl. text analysis).do`, `BHT JOAR 2024 text analysis code.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 3/12543 - Relative-Performance-Evaluation-and-Strategic-Peer-Harming-Disclosures/bht-2024-datasheet-and-code.zip",
      "sha256": "caa57e9295e990a2d0bead4a4d75f1c5c755e8bc39fa2aee856485a4db3f4d72"
    },
    {
      "path": "JAR-Volume 62/Issue 3/12543 - Relative-Performance-Evaluation-and-Strategic-Peer-Harming-Disclosures/bht-2024-online-appendix.pdf",
      "sha256": "faca4cf2c406c2f1bc23263730abed51a23eb2b96ecf1897d5c8aaf46dabfcb8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "e2f16c552b61c05699988c86401d2b5481026ab32859973c242897155cfdbd37"
}
```

## Proposed actions

### A_PATH_CONFIGURATION: Map author path roots in a separate runnable copy after compatible inputs are available.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_CONFIGURATION
Evidence: E_STATA_PATH, E_R_PATH, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Keep supplied source bytes intact and work from a separate copy.
2. Set Stata rawdata/data roots and R working directory to the actual author data tree, preserving the expected relative file structure.
3. Keep generated files in a controlled output directory and credentials outside source/configuration.

Validation to perform later:

- Before a later source run, confirm every named path resolves and outputs go to the intended directories.

### A_STATA_COMPUSTAT: Resolve the author Compustat merge input and its PERMNO link field before conversion or substitution.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_COMPUSTAT
Evidence: E_STATA_INPUTS, E_SAS_COMP_FUNDA

Preparation / proposed procedure:

1. Provide CompustatMerged.dta or the author-specified source and preparation steps producing lpermno.
2. Compare identifiers, dates and fundamentals with the author input; local COMP.FUNDA alone does not supply lpermno.

Validation to perform later:

- Verify required columns and full FY >= 2005 coverage with bounded checks before a Stata run.

### A_STATA_CRSP: Prepare the Stata daily CRSP input from an authorized compatible product or supply the exact author file.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_STATA_CRSP_DAILY
Evidence: E_STATA_INPUTS, E_SAS_CRSP_DSF, E_DOC_VINTAGE

Preparation / proposed procedure:

1. Use CRSP_daily_FULL.dta if available; otherwise confirm local CRSP.DSF is the intended underlying source and preserve permno,date,ret,prc,shrout,vol.
2. Verify authored dates, mappings, types and later 3/30-observation windows; the one-row probe establishes fields only.

Validation to perform later:

- Check prepared-file fields and independently verify all required dates and subsequent trading observations before running the source.

### A_STATA_ISS: Prepare the five separate Incentive Lab inputs required by the Stata peer-network stage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_STATA_ISS_COMPANYFY, R_STATA_ISS_GPBAGRANT, R_STATA_ISS_GPBAREL, R_STATA_ISS_PARTICIPANTFY, R_STATA_ISS_GPBARELPEER
Evidence: E_STATA_INPUTS, E_SAS_ISS_COMPANY, E_SAS_ISS_GRANT, E_SAS_ISS_REL, E_SAS_ISS_PARTICIPANT, E_SAS_ISS_PEER

Preparation / proposed procedure:

1. Use exact author .dta files if available; otherwise confirm local ISS candidates are intended sources before conversion to the five author filenames.
2. Preserve each file's merge identifiers/types and verify all five jointly cover FY 2006–2016.

Validation to perform later:

- Check each input's fields/readability and full-year coverage separately; one-row probes do not prove coverage.

### A_STATA_IBES: Supply exact author-prepared IBES link, guidance, estimate and Compustat/CRSP date-link files or their documented preparation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_IBES_CRSP_LINK, R_STATA_CRSP_COMPUSTAT, R_STATA_IBES_GUIDANCE, R_STATA_IBES_ESTIMATES, I_UNPRODUCED_PREPARED_INPUTS
Evidence: E_STATA_IBES, E_SAS_IBES_GUIDANCE, E_SAS_IBES_DETAIL, E_SAS_IBES_STATSUM, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Provide IBES_CRSP_link.dta and CRSP_Compustat_winnowed.dta or author-specified sources and transformations; neither has a producer in this program.
2. Provide IBES_guidance.dta and IBES_estimates_full.dta or exact merge instructions for local detail/summary products, including keys, filters and period.
3. Keep these Stata files separate from the R guidance/ID CSVs.

Validation to perform later:

- Verify fields, key uniqueness, dates and join coverage with bounded checks before a future source run.

### A_R_RPE_FILES: Provide four RPE CSV inputs or an author-supported mapping from local Incentive Lab products.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RPE_COMPANY_CSV, R_RPE_GRANTS_CSV, R_RPE_GOALS_CSV, R_RPE_PEERS_CSV
Evidence: E_R_RPE, E_R_RPE_PEERS, E_SAS_ISS_COMPANY, E_SAS_ISS_GRANT, E_SAS_ISS_REL, E_SAS_ISS_PEER

Preparation / proposed procedure:

1. Obtain exact author CSVs or documented conversions/joins; keep them distinct from the Stata .dta inputs.
2. Confirm CIK/FYEAR/grant/peer IDs, target fields, exact names and FY >= 2006 coverage.
3. Do not infer local GPBAGRANT contains target amount fields or GPBARELPEER provides the R CIK/FYEAR mapping.

Validation to perform later:

- Check each CSV separately and confirm joins preserve the author-defined RPE sample.

### A_R_IBES_FILES: Provide exact R guidance detail and ID CSVs or author-supported conversions from local IBES tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IBES_GUIDANCE_DETAIL_CSV, R_IBES_IDS_CSV
Evidence: E_R_IBES, E_SAS_IBES_GUIDANCE, E_SAS_IBES_IDS

Preparation / proposed procedure:

1. Supply author CSVs or field-mapped exports, including action, actdats, anndats and mod_date for guidance and TICKER/CUSIP for IDs.
2. Confirm WRDS release and fiscal-date/identifier coverage required by the R sample.

Validation to perform later:

- Verify imported column names/date types and CUSIP-to-Compustat fiscal-date join coverage before a future R run.

### A_R_CIQ_IDENTIFIERS: Provide the two author-prepared transcript identifier CSVs and matching release metadata.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CIQ_TRANSCRIPT_LINK, R_CIQ_CIK_CROSSWALK
Evidence: E_R_CIQ_LINK, E_DOC_VINTAGE, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Supply transcript linking and companyid-to-CIK crosswalk files from the author export.
2. Confirm common companyid values, transcript IDs/date types, duplicate handling and coverage against component shards.

Validation to perform later:

- Check both CSV schemas and crosswalk coverage without changing authored row-selection behavior.

### A_R_SIMPLE_PEERS: Locate the author-prepared SIC2 Simple Peers CSV or obtain its production specification.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SIMPLE_PEERS, I_UNPRODUCED_PREPARED_INPUTS
Evidence: E_R_SIMPLE_PEERS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Provide the named Simple Peers CSV with provenance/version or the upstream author program and inputs.
2. Confirm MAX_WITHIN, GVKEY, FYEAR and peer-list fields; do not construct a replacement peer algorithm from paper descriptions.

Validation to perform later:

- Verify readability, fields and FY/GVKEY coverage before use.

### A_CIQ_FULLTEXT: Resolve authorized access to the full Capital IQ transcript component export required by R.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_CIQ_TRANSCRIPT_COMPONENTS, I_SCOPE_CLOSURE
Evidence: E_DOC_DATA, E_DOC_VINTAGE, E_R_TRANSCRIPTS, E_SAS_CIQ_PREVIEW, E_WRDS_METADATA

Preparation / proposed procedure:

1. Use an authorized author-compatible WRDS/Capital IQ export or exact author-prepared twenty-shard dataset.
2. Confirm transcriptid, componentorder, component type and full componenttext; local preview text is insufficient.
3. Preserve the repeated component-09 read as authored and verify shard dates and transcript crosswalk coverage.

Validation to perform later:

- Verify full-text columns and shard/date coverage without requesting payloads during this assessment.

### A_WRDS_TABLES: Prepare an authorized WRDS connection for five separate SQL inputs and verify schemas/history.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_WRDS_COMPA_FUNDA, R_WRDS_CO_INDUSTRY, R_WRDS_CRSP_DSF, R_WRDS_CCM_LOOKUP, R_WRDS_STOCKNAMES
Evidence: E_DOC_DATA, E_WRDS_METADATA, E_R_WRDS_COMP, E_R_WRDS_CRSP, E_R_WRDS_LINKS, E_SAS_COMP_FUNDA, E_SAS_COMP_INDUSTRY, E_SAS_CRSP_DSF, E_SAS_CCM_LINK, E_SAS_STOCKNAMES

Preparation / proposed procedure:

1. The metadata-only listing returned an unverified connection error; it does not establish whether access or a license exists.
2. In the user's authorized environment, verify table names and source-required fields for compa.funda, compa.co_industry, crsp.dsf, ccm_lookup and stocknames.
3. If using local SAS candidates, confirm product, fields and history before adapting data delivery; a name match alone is insufficient.
4. Keep connection configuration outside shared source and keep credential values out of the proposal.

Validation to perform later:

- After authorized setup, verify tables, columns and date/link history using metadata only; no payload query was made.

### A_LM_LEXICON: Prepare the Loughran-McDonald lexicon resource required by the R sentiment branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_LM_LEXICON
Evidence: E_R_TEXTDATA, E_R_PACKAGES, E_TEXTDATA_DOC

Preparation / proposed procedure:

1. After textdata is installed, obtain the lexicon through its documented helper or supported manual-file route and review applicable terms.
2. Keep word/sentiment fields and record the exact release/cache location.

Validation to perform later:

- Confirm local lexicon fields and release before a future text-analysis run.

### A_R_PACKAGES: Install or configure R packages used by the supplied entry point through the user's managed package process.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R_PACKAGES
Evidence: E_R_PACKAGES, E_R_SETUP_STRUCTURE, E_R_PACKAGE_SOURCE, E_R_TEXTDATA, E_QDAP_DOC

Preparation / proposed procedure:

1. Prepare tidyverse, data.table, fixest, lubridate, RPostgres, tidytext, textdata, quanteda, nsyllable, quanteda.textstats, topicmodels, reshape2, SnowballC, psych, sqldf and qdapDictionaries, plus the database interface dependency.
2. No packages were installed during this assessment; record package versions when configured.
3. Check the textdata lexicon cache separately; qdapDictionaries documents GradyAugmented as package data.

Validation to perform later:

- Use installed.packages()/requireNamespace metadata for packages/versions and verify lexicon/package data without executing the author script.

### A_STATA_ADDONS: Configure the three Stata user commands missing from checked ado paths.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_RANGEJOIN, SW_GWTMEAN, SW_WINSOR2
Evidence: E_RANGEJOIN, E_GWTMEAN, E_WINSOR2

Preparation / proposed procedure:

1. Obtain author-compatible rangejoin, _gwtmean (egen wtmean) and winsor2 through the user's approved Stata package process.
2. Add verified source locations to Stata's ado-path; do not substitute a similar command.

Validation to perform later:

- Use Stata metadata checks to confirm which rangejoin, which _gwtmean and which winsor2 resolve before a future source run.

### A_R_DATA_REFERENCE: Clarify the intended sample object used by the transcript filter before proposing a source change.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_R_DATA_REFERENCE
Evidence: E_R_START, E_R_DATA_REF, E_R_DATA_LATER, E_R_NAMESPACE, E_R_SETUP_STRUCTURE

Preparation / proposed procedure:

1. Confirm whether authors expect an external runtime object despite the startup clear; otherwise provide the intended pre-transcript sample definition and CIK filter semantics.
2. Only after clarification, prepare a source-hashed change in a separate working copy; do not guess a replacement or remove the filter.

Validation to perform later:

- In a separately authorized future run, verify the transcript filter uses the intended sample and preserves the author population.

### A_R_CRSP_VOLUME: Clarify the intended provenance and projection of volume fields used after the R CRSP transformation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_R_CRSP_VOLUME_FIELDS
Evidence: E_R_CRSP_PROJECT, E_R_CRSP_CONSUMER, E_R_WRDS_CRSP

Preparation / proposed procedure:

1. Confirm whether the intended source is the queried CRSP vol field or an author-prepared volume object, and specify its firm/peer daily mapping.
2. Do not add guessed aliases or change analysis fields before documenting the intended mapping.

Validation to perform later:

- After clarification, review a source-hashed change in a separate copy and verify documented firm and peer volume measures.

### A_SCOPE_CLOSURE: Resolve remaining mandatory input routes and history evidence before treating the supplied workflow as closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SCOPE_CLOSURE
Evidence: E_PACKAGE_INVENTORY, E_DOC_DATA, E_WRDS_METADATA, E_CATALOG_FIELDS, E_R_TRANSCRIPTS

Preparation / proposed procedure:

1. Use per-input actions to verify author files, authorized WRDS products, full transcript shards and required history.
2. Keep jointly required files/tables separate; one route does not satisfy another input.
3. Retain supplied Stata/R branches and generated stages; add no paper-wide estimator or unsupported workflow.

Validation to perform later:

- Reconcile all 26 frozen edges and additional direct reads, then update closure only from matching route/field/period evidence.


## Remaining issues and prerequisites

- I_PATH_CONFIGURATION [preparation; full_pipeline]: The Stata macros use an author Mac path and R sets an author Windows path. The package inventory contains no corresponding raw or processed data tree; a separate runnable copy needs the actual data root mapped before relative file calls resolve.
- I_UNPRODUCED_PREPARED_INPUTS [unresolved; full_pipeline]: Stata reads CRSP_Compustat_winnowed.dta with no producer in the supplied Stata program; R reads the SIC2 Simple Peers CSV with no producer in either supplied program. Neither file is in the package, so provenance and compatible alternatives remain unknown.
- I_SCOPE_CLOSURE [unresolved; full_pipeline]: Input readiness is undetermined: author datasets are not packaged, local product candidates have only one-row field probes, WRDS metadata discovery failed without establishing current access status, and transcript full-text coverage is unverified. All 26 frozen dependency IDs are reviewed; additional direct reads are captured as separate requirements.
- I_R_DATA_REFERENCE [unresolved; full_pipeline]: The R program clears workspace objects at startup, then transcript_function uses Data$CIK before the later Data creation. A byte-only source scan found no earlier explicit binding, restore, source call or dynamic namespace access after startup clear. An unseen runtime/global object and intended sample-filter semantics remain unknown; no name-resolution trial was performed.
- I_R_CRSP_VOLUME_FIELDS [unresolved; full_pipeline]: The R source projects the CRSP object to GVKEY, DATE and RET, then later selects VOLUME and references DAILY_VOLUME and PEER_DAILY_VOLUME. The intended source and projection for these fields are not identified. Keep this as an unresolved source contract; no R run, parser or namespace trial was used.
- R_STATA_COMPUSTAT [undetermined]: Stata requires rawdata/CompustatMerged.dta with CIK, lpermno, datadate, fyear, gvkey, revt, sich and fiscal-year fields. Code filters fyear >= 2005 and derives the CIK/PERMNO map and firm basics; local COMP.FUNDA lacks lpermno.
- R_STATA_CRSP_DAILY [undetermined]: Stata requires rawdata/CRSP_daily_FULL.dta with permno,date,ret,prc,shrout,vol. It keeps daily rows from 2005 onward, derives firm returns/volume and uses later event/reversal windows; complete history and end date are not bounded.
- R_STATA_ISS_COMPANYFY [undetermined]: Stata requires IncentiveLab2019/CompanyFY.dta with CIK, fiscalyear and fiscal-year end fields.
- R_STATA_ISS_GPBAGRANT [undetermined]: Stata requires IncentiveLab2019/GpbaGrant.dta with CIK,FiscalYear,FiscalMonth,participantid,grantID and performancetype for grant matching.
- R_STATA_ISS_GPBAREL [undetermined]: Stata requires IncentiveLab2019/GpbaRel.dta with grantId,relativeBenchmark and metricType.
- R_STATA_ISS_PARTICIPANTFY [undetermined]: Stata requires IncentiveLab2019/ParticipantFY.dta with CIK,FiscalYear,FiscalMonth,participantid,currentCEO.
- R_STATA_ISS_GPBARELPEER [undetermined]: Stata requires IncentiveLab2019/GpbaRelPeer.dta with grantId and peerCIK.
- R_STATA_IBES_CRSP_LINK [undetermined]: Stata requires rawdata/IBES_CRSP_link.dta with score,ticker,ncusip,permno,datadate,sdate,edate. This author-prepared link file and its producer are not packaged.
- R_STATA_CRSP_COMPUSTAT [undetermined]: Stata also reads rawdata/CRSP_Compustat_winnowed.dta at line 223 for lpermno/date range joining. No producer is present and this direct input is absent from the frozen dependency checklist.
- R_STATA_IBES_GUIDANCE [undetermined]: Stata requires IBES_guidance.dta with ticker, USD/U.S.-firm flags, periodicity, measure, announcement date/time and guidance fields.
- R_STATA_IBES_ESTIMATES [undetermined]: Stata requires author-prepared IBES_estimates_full.dta with EPS forecast summary and actual announcement fields. Local detail and summary products expose complementary split fields; the exact author merge is unspecified.
- R_RPE_COMPANY_CSV [undetermined]: R separately requires Incentive Lab/Company Data.csv with CIK and fiscalYear.
- R_RPE_GRANTS_CSV [undetermined]: R separately requires Grants of Plan-Based Awards Table.csv with grantID,equityTarget,nonEquityTarget,vestHighGrant,CIK and FiscalYear.
- R_RPE_GOALS_CSV [undetermined]: R separately requires Relative Performance Goals Data.csv with grantId,metricType,relativeBenchmark.
- R_RPE_PEERS_CSV [undetermined]: R separately requires Peer Data for Relative Performance Goals.csv with CIK,fiscalYear,peerCIK.
- R_IBES_GUIDANCE_DETAIL_CSV [undetermined]: R requires IBES Guidance - Detail.csv with ticker,action,actdats,anndats,mod_date and measure; it filters action == I and maps dates to fiscal years.
- R_IBES_IDS_CSV [undetermined]: R requires IBES - IDs.csv with TICKER and CUSIP for mapping guidance to Compustat.
- R_CIQ_TRANSCRIPT_LINK [undetermined]: R requires transcript linking table.csv with companyid,transcriptid,mostimportantdateutc, joined with the independent CIK crosswalk.
- R_CIQ_CIK_CROSSWALK [undetermined]: R requires companyid to cik crosswalk.csv with companyid and cik.
- R_SIMPLE_PEERS [undetermined]: R requires author-prepared Simple Peer Selection/Peers/[I = SIC2] Simple Peers.csv with MAX_WITHIN and GVKEY/FYEAR peer-network fields; no producer appears in the supplied programs.
- R_CIQ_TRANSCRIPT_COMPONENTS [undetermined]: R requires the full componenttext and identifiers in component CSV shards 01–20; chunk 09 is read twice as authored. No full-text export is packaged. Transcript source vintage is February 2023; exact call-date coverage is unknown.
- R_WRDS_COMPA_FUNDA [undetermined]: R requires compa.funda fields gvkey,tic,datadate,fyear,cik,cusip,fyr,conm. The SQL has no date filter and supplies fiscal identifiers/dates.
- R_WRDS_CO_INDUSTRY [undetermined]: R separately requires compa.co_industry with gvkey,datadate,sich to construct SIC4/SIC2.
- R_WRDS_CRSP_DSF [undetermined]: R requires crsp.dsf with permno,date,ret,prc,bidlo,askhi,vol for dates > 2000-01-01; no upper bound appears in SQL.
- R_WRDS_CCM_LOOKUP [undetermined]: R requires crsp_a_ccm.ccm_lookup with lpermno and gvkey to map CRSP to Compustat; exact table/mapping history is unverified.
- R_WRDS_STOCKNAMES [undetermined]: R requires crsp_a_stock.stocknames with permno,ticker,cusip,namedt,nameenddt,shrcd for effective identifier/name links.
- R_LM_LEXICON [undetermined]: R sentiment processing requires the Loughran-McDonald word/sentiment lexicon through textdata; the package is missing and no local lexicon cache was verified.
- SW_R_PACKAGES [preparation_required]: Metadata-only inspection found the required packages absent: tidyverse, data.table, fixest, lubridate, RPostgres, DBI, tidytext, textdata, quanteda, nsyllable, quanteda.textstats, topicmodels, reshape2, SnowballC, psych, sqldf and qdapDictionaries. No packages were installed.
- SW_RANGEJOIN [preparation_required]: The Stata program calls rangejoin; the bounded which probe reports it unavailable in checked ado paths.
- SW_GWTMEAN [preparation_required]: The Stata program uses egen wtmean; the actual function entry point _gwtmean was unavailable in checked ado paths.
- SW_WINSOR2 [preparation_required]: The Stata program calls winsor2; the bounded which probe reports it unavailable in checked ado paths.

## Review notes

- Package-specific assessment. Frozen title and DOI copied literally from the work-item output header. The datasheet names CRSP, I/B/E/S, Incentive Lab, Compustat and Capital IQ; WRDS 2019 and transcript February 2023 are provenance, not evidence of current entitlement.
- Both supplied programs total 1,346 cached code lines (521 Stata, 825 R). The complete supplied processing scope is retained. Stata produces baseline, flipped, reversals and targeting files; R writes analysisfile_textcontent.csv. No paper-wide estimator or SAS–Stata architecture was added.
- All 26 frozen dependency IDs are reviewed against actual producers/consumers. Additional direct reads include CRSP_Compustat_winnowed.dta, the Simple Peers CSV, 20 transcript shards and five WRDS SQL tables. Component shard 09 is repeated in source and remains unchanged.
- The four inventory items are the two programs, datasheet and appendix; no data files are packaged. Local SAS probes sampled one row and establish only readability/sample fields, not population, history, release compatibility or authorization. The WRDS metadata failure does not prove lack of data or access.
- R source candidate block lines 10–16 and datasheet candidate block lines 80–82 remain withheld with hashes. The safe R setup summary reports RPostgres and DB interface names only; no argument, credential or candidate value is reproduced or used.
- R Data reference and CRSP volume path remain unresolved. No author program, parser, syntax/name-resolution probe, model/statistical/descriptive or synthetic trial, author edit, data payload request, package installation or outgoing message was performed. Source filter and repeated shard read are preserved.
- The datasheet names Parallels 17.0 and R as historical environment; the supplied programs do not define Parallels' role, so it is recorded as provenance rather than imposed as an execution dependency.
