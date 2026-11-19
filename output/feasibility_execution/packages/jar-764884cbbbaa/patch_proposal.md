# Patch proposal: jar-764884cbbbaa

CEO Inside Debt Incentives and Corporate Tax Sheltering

DOI: 10.1111/1475-679X.12169

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Supplied SAS workflow embedded in CHS_Codes.pdf: data construction, tax-aggressiveness measures, CEO inside-debt variables, supporting discretionary-measure regressions and winsorization. The authors describe a broader primary sample and supplemental paper analyses, but the PDF begins from pre-existing SAS library inputs, provides no complete library/upstream setup, and ends before paper-level outcome models. Embedded-code qualifier: the program is in the PDF, not a standalone .sas file.

Entry points: `CHS_Codes.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 4/12169 - CEO-Inside-Debt-Incentives-and-Corporate-Tax-Sheltering/chs-datasheet-and-code.zip",
      "sha256": "baa2a0b50eea0ee08ca566fe49572881c42df1bf3701fa70e13fc9922fca5800"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "7307de08208f6521ff99d621137a1983ae86c749ee94e7c4802b757f89576352"
}
```

## Proposed actions

### ACT_CORE_INPUTS: Obtain the missing tax.aggressive producer, SAS library configuration and matching Compustat/CRSP input specification.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_TAX_AGGRESSIVE, REQ_COMPUSTAT, REQ_CRSP, ISSUE_LIBRARY_SETUP, ISSUE_UPSTREAM_INPUT
Evidence: E_CODE_TAX_AGGRESSIVE, E_PRIMARY_SOURCES, E_SAS_PROGRAM_CLAIM, E_COMP_FUNDAMENTALS_PROBE, E_CRSP_DSF_PROBE, E_PACKAGE_INVENTORY, E_CODE_ETR_WINDOW, E_CODE_ETR_COUNT, E_CODE_ROA1, E_CODE_LAG_ASSETS, E_CRSP_STD_RET_SOURCE, E_CODE_STD_RET

Preparation / proposed procedure:

1. Ask for the author’s exact SAS library assignments and complete upstream program or author-prepared tax.aggressive input manifest; the current PDF code starts from this table and does not produce it.
2. For Compustat, confirm the source table, required fields, identifiers and date coverage for the 2006–2013 sample plus the code’s date-specific trailing 48-month ETR/ROA window (at least four observations per gvkey/fyear group) and adjacent prior-year assets/other lag inputs; ask the authors for the exact earliest required date/year rather than inferring one.
3. For CRSP, confirm the exact source, lpermno/link construction, return measure and return-window definition needed for STD_RET and the data-sheet σ(RET) control, including required daily history; the supplied material does not define this window, so do not infer the tax branch’s 48-month window applies.
4. Obtain non-sensitive input manifests/schema and setup information for tax.aggressive and the Compustat/CRSP table producers; do not reconstruct the research independently.

Validation to perform later:

- Match the complete input schemas, identifiers, author-confirmed date coverage, rolling ETR window/count rule and lagged-asset construction to the supplied code before any separate execution decision.
- Verify the independently specified CRSP return window, source history and link rules needed to form STD_RET; leave them unresolved until the author provides the definition.

### ACT_EXECUCOMP_LISOWSKY: Clarify the author-specific ExecuComp transformations and permitted route for confidential Lisowsky scores.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_EXECUCOMP, REQ_LISOWSKY
Evidence: E_EXECUCOMP_SCOPE, E_CODE_CEO_INPUT, E_CODE_EXEC_AGE, E_CODE_LISOWSKY, E_LISOWSKY_CONFIDENTIAL, E_TEMPLE_COMP_PUBLIC, E_CATALOG_PRIMARY

Preparation / proposed procedure:

1. Request the complete ExecuComp data-preparation program and input manifest for comp.CEOCFOcomp and comp.exeage, including executive keys, inside-debt construction, and age fields.
2. Clarify whether an authorized route exists for the referee-supplied Lisowsky score file or the exact author-prepared gvkey/fyear/tsscore input; do not infer that the confidential data are publicly distributable or recreate the score model.
3. Treat the public Coles et al. compensation dataset only as a candidate for the measures it explicitly contains; confirm whether it matches any author-required inside-debt or age fields before use.

Validation to perform later:

- Verify that the authorized files contain the exact code fields, gvkey/year/execid matching keys and 2006–2013 coverage before merging.

### ACT_HANDCOLLECTED_INPUTS: Obtain the hand-coded source tables and their coding/identifier procedures.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FORTUNE_BESTEMP, REQ_PENSION_FREEZE, REQ_SAY_ON_PAY, REQ_TAX_PENSION, ISSUE_LIBRARY_SETUP
Evidence: E_FORTUNE_SOURCE, E_FORTUNE_ARCHIVE_URLS, E_FORM5500_SOURCE, E_DOL_5500_PUBLIC, E_SEC_VOTING_SOURCE, E_SEC_EDGAR_PUBLIC, E_SEC_FORM8K_PUBLIC, E_CODE_FORTUNE, E_CODE_FREEZE, E_CODE_VOTING, E_CODE_TAX_PENSION, E_SEC_PARSED_ROOT, E_SEC_RAW_ROOT, E_CATALOG_PENSION_FIELDS

Preparation / proposed procedure:

1. Request author manifests and field/code definitions for google.bestemp, comp.pensionfreeze, comp.voting and tax.pension, including the sample firms/plans, years, keys and decision rules used to create each table.
2. For Form 5500 and EDGAR inputs, compare the disclosed author source and identifiers with the public DOL/SEC routes; the existing SEC corpus roots may be considered only after the author filer/filing list and form/section requirements are known.
3. Confirm that the Fortune archive lists supply the ticker_symbol/year/ranking_state structure needed by the code or obtain the author’s permitted mapping table.
4. Ask whether COMP.ACO_PNFNDA is an authorized compatible source for tax.pension and confirm its PBPRO/PPLAO definitions, GVKEY/DATADATE mapping and 2006–2013 date coverage against the author-prepared table; treat the catalog hit as a discovery candidate only, with no assumed equivalence or licensing conclusion.

Validation to perform later:

- Check that each prepared table has the expected keys, sample coverage and code definitions before any separate execution decision; do not run broad filing searches or download data during this assessment.
- If the author identifies COMP.ACO_PNFNDA as a candidate, verify readable rows, fields, item meanings, dates and mapping before treating it as compatible with tax.pension.

### ACT_AUXILIARY_MAPPING: Map documented supplementary data sources to paper analyses and identify their compatible author-prepared input tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_AUXILIARY_ANALYSIS_INPUTS, ISSUE_AUXILIARY_MAP
Evidence: E_SNP_SOURCE, E_COVENANT_SOURCE, E_AUDIT_SOURCE, E_GMI_SOURCE, E_SERP_SOURCE, E_SERP_PROCEDURE, E_RISKMETRICS_SOURCE, E_CATALOG_AUX

Preparation / proposed procedure:

1. Ask the authors which reported analyses require S&P ratings, Ed Owens covenant-violation data, Audit Analytics Tax Footnote fines, GMI/proxy clawback data, SERP cash-out coding and RiskMetrics board measures.
2. For every included branch, obtain the exact prepared table names, field definitions, identifiers, period, source-specific coding and its producing script; do not infer optionality or reconstruct these inputs from product names.
3. Review the local Audit Analytics, S&P ratings and RiskMetrics catalog candidates only against those author-specified fields and periods; the current catalog hits do not establish a compatible route.

Validation to perform later:

- Trace each documented paper analysis to its author code and source tables, retaining separate inputs for distinct branches and confirming all required fields and sample periods.

### ACT_MAIN_MODELS: Obtain the missing paper-level model specifications and output-generation procedure.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_MAIN_ANALYSIS
Evidence: E_CODE_AUX_REG, E_CODE_WINSOR_END, E_SAS_PROGRAM_CLAIM, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the complete final regression code and table/output instructions for the paper’s primary outcome analyses; the supplied PDF code’s PROC REG statements estimate only auxiliary measures and the program ends after winsorization.
2. Confirm which datasets, model specifications, fixed effects, sample restrictions and table branches should consume the generated all panel.

Validation to perform later:

- Map every intended paper table to an actual SAS producer and model statement, with the same specified sample and variable definitions, before a future authorized run.

### ACT_SAS_RUNTIME: Resolve the local SAS startup/entitlement environment before any future author-program execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISSUE_SAS_RUNTIME
Evidence: E_SAS_ENV

Preparation / proposed procedure:

1. Have the SAS administrator confirm whether the 9.4 installation and required TKELS entitlement/startup configuration are available for this session.
2. After a successful environment-only version/startup check, record the actual SAS runtime; the author’s SAS version remains unspecified.

Validation to perform later:

- Verify SAS starts successfully without loading study data or author code, then separately confirm the documented Base SAS procedures and macro support.

### ACT_PDF_CODE_HANDLING: Prepare a lossless executable text copy of the SAS program embedded in the PDF when the complete source is available.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISSUE_MAIN_ANALYSIS
Evidence: E_CODE_TAX_AGGRESSIVE, E_CODE_AUX_REG, E_CODE_WINSOR_END, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. If a standalone runnable copy is needed, extract the embedded SAS text while preserving statements, line continuations, macro boundaries and quote marks, then compare the extracted text against CHS_Codes.pdf.
2. Do not invent or fill missing code from the PDF; obtain the complete author file first if the existing excerpt is incomplete.

Validation to perform later:

- Verify line-by-line that the extracted file matches the PDF text and author-supplied complete program before any separate authorized execution.


## Remaining issues and prerequisites

- ISSUE_LIBRARY_SETUP [unresolved; full_pipeline]: The PDF code assumes pre-existing SAS libraries tax, comp, and google, and reads custom source tables including tax.aggressive, tax.lisowsky, google.bestemp, comp.pensionfreeze, comp.voting, tax.pension, comp.CEOCFOcomp and comp.exeage. No LIBNAME assignments, input files or table-generation setup are supplied.
- ISSUE_UPSTREAM_INPUT [unresolved; full_pipeline]: CHS_Codes.pdf begins by reading tax.aggressive and joins tax.lisowsky, but its code does not construct the Compustat/CRSP annual input or the confidential score table. The data sheet says the SAS file merges Compustat, CRSP and ExecuComp with Lisowsky scores to generate the primary sample; the exact earlier producer and complete input mapping are absent.
- ISSUE_MAIN_ANALYSIS [unresolved; full_pipeline]: The PDF contains genuine SAS DATA/PROC SQL/PROC REG/macro code for deriving inputs and auxiliary discretionary measures, but its program ends after winsorizing dataset all. No complete paper-level outcome regression/output workflow is supplied.
- ISSUE_AUXILIARY_MAP [unresolved; full_pipeline]: The data sheet lists further source datasets used for the study, while the supplied code does not map their inputs to analysis tables or identify alternative/optional branches. Their role cannot be reconstructed from source names alone.
- ISSUE_SAS_RUNTIME [unresolved; full_pipeline]: The assigned environment probe could not initialize SAS 9.4 because the TKELS extension failed to load. The probe explicitly says this does not establish a missing license or unavailable entitlement.
- REQ_TAX_AGGRESSIVE [undetermined]: The prepared annual tax.aggressive SAS panel read at the start of CHS_Codes.pdf, with Compustat/CRSP fields, gvkey/fyear/datadate identifiers and lag inputs needed for the tax-sheltering and control measures. The code forms rolling 48-month ETR/ROA statistics from this panel and requires at least four observations per gvkey/fyear group; the exact earliest input date is not specified.
- REQ_COMPUSTAT [undetermined]: Compustat Fundamentals Annual data used to construct tax.aggressive and the study’s financial-statement controls for the 2006–2013 sample, including the trailing 48-month ETR/ROA window and prior-asset/other lag inputs. The exact earliest required date is not established by the package.
- REQ_CRSP [undetermined]: CRSP stock-return records used to construct stock-return measures, including the data sheet’s σ(RET) measure, merged into the Compustat annual panel for fiscal years 2006–2013. The upstream STD_RET return-window definition and required earliest history are not supplied.
- REQ_EXECUCOMP [undetermined]: ExecuComp compensation and age data needed for author-prepared comp.CEOCFOcomp and comp.exeage tables, including CEO/CFO inside debt, equity measures and executive identifiers for fiscal years 2006–2013.
- REQ_LISOWSKY [undetermined]: The Lisowsky tax-shelter score data joined by gvkey and fyear, including tsscore, used to form the primary sample.
- REQ_FORTUNE_BESTEMP [undetermined]: Fortune Best Companies lists transformed into the google.bestemp table with company ticker, year and rank/standing fields used in the best-employer indicator.
- REQ_PENSION_FREEZE [undetermined]: The author-coded comp.pensionfreeze table with gvkey, year and frozen indicator, derived from Form 5500 filings.
- REQ_SAY_ON_PAY [undetermined]: The author-coded comp.voting records used for the say-on-pay variable, filtered to Advisory Vote to Ratify and linked by ticker and meeting date.
- REQ_TAX_PENSION [undetermined]: The tax.pension table joined by gvkey and datadate, supplying pbpro and pplao for plan_size and plan_asset in the embedded code. A frozen-catalog local Compustat annual-pension candidate lists these fields and keys, but its coverage and compatibility with the author table remain unknown.
- REQ_AUXILIARY_ANALYSIS_INPUTS [undetermined]: Author-documented additional study inputs for S&P bond ratings, private-debt covenant violation probabilities, Audit Analytics tax-footnote IRS fines, GMI/proxy clawback provisions, SERP cash-out provisions, and RiskMetrics board measures; the package does not map these inputs to tables or code branches.
- SW_SAS [unverified]: The authors specify SAS. A local SAS 9.4 executable is present, but the assigned environment probe failed at TKELS initialization and states entitlement cannot be inferred; author SAS version is not stated.

## Review notes

- Expanded checkpoint saved after reading the complete data description sheet and the full code-bearing PDF, the SAS environment probe, and same-run exact-file/resource probes. The PDF contains actual SAS source despite the static report saying no supported code.
- No author SAS program, regression or study dataset was run or downloaded; source catalog and exact-path metadata checks were read-only.
- The full author scope remains unresolved: code inputs and producers are incomplete, final outcome model code is not supplied, and additional documented source datasets are not mapped to code branches. No analysis_only scope is supported because no compatible author-prepared analysis data are packaged.
- Reused exact-file probes came from other sweep_01 item work directories; their JSON hashes, request details, catalog provenance and unchanged file metadata were preserved in this assigned work directory.
- The embedded ETR code requires date-specific trailing 48-month tax/Compustat observations (at least four per gvkey/fyear group) and lagged-asset inputs; exact earliest coverage requires author confirmation. The frozen catalog identifies COMP.ACO_PNFNDA fields PBPRO/PPLAO and GVKEY/DATADATE, but compatibility with tax.pension is unverified. CRSP STD_RET history remains separately undefined.
