# Patch proposal: jar-f9eee60ad01a

Payment Practices Transparency and Customer-Supplier Contracting

DOI: 10.1111/1475-679X.12521

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied main-analysis workflow in Code_GMP.do: manual Capital IQ screen preparation, the in-memory construction block, and every supplied Table 2, Table 3, Table 4 Panel A/B, Table 5, and Table 6 branch. The appendix title wording is retained only as contextual version/output comparison; the frozen title and DOI remain unchanged.

Entry points: `Code_GMP.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12521 - Payment-Practices-Transparency-and-Customer-Supplier-Contracting/gmp-datasheet-code-and-identifiers.zip",
      "sha256": "4e7f37135fbd539239d9f24c3044ce53c39b90bf609f8e452740b70e3084291c"
    },
    {
      "path": "JAR-Volume 62/Issue 2/12521 - Payment-Practices-Transparency-and-Customer-Supplier-Contracting/gmp-online-appendix.pdf",
      "sha256": "bc06ce1f8d4d0f9c49650ff96552047aee207aec4259220835dd8cb7b49821d7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "540ca60a6784156b3e96de22622d02ada9a62b54662162bd20c2f5c31c654288"
}
```

## Proposed actions

### A-VERIFY-INPUT-ROUTES: Verify compatible prepared-input or supported source routes against each exact consumer, input fields, period, identifiers, transformations, and joins. Keep jointly required files separate and record author-supported alternatives for the same consumed file without turning them into additional mandatory inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I-UNVERIFIED-INPUTS, R-CAPIQ-PANEL, R-REPRISK-IDENTIFIERS, R-REPRISK-RISK-PANEL, R-COMBINED-AP-AR-UNIQUE, R-COMBINED-AP-AR, R-PPDR-REPORTS, R-SURVEY-RESPONSES
Evidence: EV-CAPIQ-MANUAL, EV-REP-ID-READ, EV-REP-RRI-READ, EV-COMBINED-PANEL-READ, EV-PPDR-READ, EV-SURVEY-READ, EV-UNIQUE-PANEL-READ, EV-WORKFLOW-TRACE, EV-ASSIGNED-INVENTORY, EV-CATALOG-CAPIQ, EV-CATALOG-IQ-ASSETS, EV-CATALOG-IQ-REV, EV-CATALOG-IQ-AR, EV-CATALOG-IQ-STDEBT, EV-CATALOG-REPRISK, EV-CATALOG-REP-HQ, EV-CATALOG-REP-ISIN, EV-CATALOG-REP-RRI, EV-CATALOG-REP-ID, EV-CATALOG-REP-DATE, EV-CATALOG-PPDR, EV-CATALOG-SURVEY, EV-PROBE-REP-ID, EV-PROBE-REP-RRI, EV-PROBE-IDENTIFIERS-LIST, EV-ENVIRONMENT, EV-PPDR-OFFICIAL-GUIDANCE, EV-ANALYSIS-PERIOD

Preparation / proposed procedure:

1. For the initial in-memory Capital IQ panel, obtain or verify the manual UK fiscal-year 2010–2020 screen exports, map the listed identifiers, industry, and financial fields, reshape by EntityID/year, and document the handoff into Code_GMP.do.
2. For RepRisk, verify the identifier table and dated risk observations separately; map country code, RepRisk ID, ISIN, date, and current-RRI fields, and establish coverage for the code-used 2011–2020 sample before matching or normalizing columns.
3. Resolve the line 176 unique ISIN/year AP/AR file as a distinct producer-consumer handoff; confirm whether it is derived from the separately read Combined Annual AP and AR.dta and document the supported one-row-per-key construction if so.
4. For Combined Annual AP and AR.dta, verify the prepared analysis fields, EntityID/year and industry keys, variables used in panel construction, and compatibility with the RepRisk join.
5. For PPDR data.dta, verify the official public reporting records and expected report period/fields, then document the author-described spreadsheet-to-Stata preparation route without fetching the export payload.
6. For SME Large combined response.dta, verify the author-described SoGoSurvey workbook and both SME/Large sheets, append order, question columns, and the resulting combined-file handoff.
7. Keep any candidate Capital IQ or RepRisk catalog tables as unverified until their exact required fields, identifiers, history, and construction are supported; a catalog candidate is not a live-access or compatibility finding.

Validation to perform later:

- Confirm every file read and generated file in the ordered trace has a resolvable portable path and a supported producer.
- Check all required keys, input columns, periods, and row-level uniqueness before any separately authorized execution.

### A-PATH-ROOT-AND-ORDER: Configure a separate isolated host execution working directory for any later authorized run, outside the controller run and frozen assigned generation. Resolve the common ellipsis prefix consistently there while preserving every exact author basename and producer-consumer order; keep missing inputs and producers in their separate unresolved requirements.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-PATH-ROOT
Evidence: EV-PATH-ROOT, EV-WORKFLOW-TRACE, EV-GMP-PRODUCER, EV-PPDR-READ, EV-SURVEY-READ

Preparation / proposed procedure:

1. Place the manual Capital IQ screens and their prepared in-memory panel under the selected working root; carry out the documented UK fiscal-year screen, import, reshape, and EntityID/year merge before the first supplied construction commands.
2. Run the in-memory treatment and industry construction; save IQ_INDUSTRY_GROUP_AP.dta and merge it back before the RepRisk stages.
3. Load q5874d8b8ee069c40.dta, filter the UK identifier rows, and save reprisk identifiers UK only.dta; then load qb72a60cba72fa61f.dta, merge those IDs, construct annual ISIN/year RRI, merge Combined Annual AP and AR unique ISIN year.dta, and save reprisk1.dta.
4. Load Combined Annual AP and AR.dta, merge reprisk1.dta by IQ_INDUSTRY_GROUP, complete the supplied financial-variable construction, and save GMP dataset_f.dta; that generated panel feeds Table 2, Table 5, and Table 6.
5. Run the supplied Table 3 branch with PPDR data.dta, then Table 4 Panel A and Panel B with SME Large combined response.dta, retaining both survey branches and their authored order.
6. Before a later authorized execution, choose a dedicated isolated working directory outside the controller run, frozen generation, and probe/checkpoint trees; map the common ellipsis prefix consistently there, retain exact basenames and producer-consumer order, and capture the Stata session outputs. The seven missing or unverified input/producer contracts remain separate.

Validation to perform later:

- Confirm the dedicated host working directory is separate from controller/frozen paths and that its mapping preserves every supplied basename and branch order without changing variable construction or samples.
- Keep the seven source/input and producer contracts separately unresolved until author-compatible inputs and their required fields/history are documented.
- After any separately authorized run, confirm each generated intermediate exists before its supplied consumer and capture the Table 2, Table 3, Table 4 Panels A/B, Table 5, and Table 6 session outputs.

### A-VERIFY-SOFTWARE: Before a separately authorized attempt, verify the named Excel application is available for the author-described screen preparation and make winsor2 available in the Stata environment. No install or author-code run was performed during this audit.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: I-SOFTWARE-SETUP, S-WINSOR2, S-EXCEL
Evidence: EV-ENVIRONMENT, EV-WINSOR2-CALL, EV-CAPIQ-MANUAL

Preparation / proposed procedure:

1. Verify Microsoft Excel availability for the manual screen import stage described by the authors.
2. Provide the free Stata command winsor2 in the intended Stata adopath; keep Stata 18, reghdfe 6.12.3, and ftools 2.49.1 as the recorded environment metadata.

Validation to perform later:

- Use read-only software metadata to confirm the required application and commands in the intended host environment before any separately authorized execution.


## Remaining issues and prerequisites

- I-UNVERIFIED-INPUTS [unresolved; full_pipeline]: The supplied workflow has seven unresolved source/input contracts: the manual Capital IQ panel, two RepRisk tables, the distinct unique ISIN/year panel at line 176, Combined Annual AP and AR.dta, PPDR data.dta, and the combined survey responses. Candidate local product fields do not establish the required source population, field mappings, history, or producer handoffs.
- I-PATH-ROOT [preparation; full_pipeline]: The source uses a common ellipsis-prefixed path placeholder. Selecting a separate isolated future execution directory and resolving that placeholder consistently while preserving supplied basenames/order is a supported preparation step. No separate unresolved path algorithm or incompatible basename is established. Missing data and producer contracts remain in I-UNVERIFIED-INPUTS.
- I-SOFTWARE-SETUP [preparation; full_pipeline]: winsor2 is required by the supplied Stata program but was not found in checked adopaths, and availability of the Excel application named in the manual input-preparation instructions is unverified.
- R-CAPIQ-PANEL [undetermined]: Manual S&P Global Capital IQ exports for UK firms and fiscal years 2010–2020, with the fields listed in Code_GMP.do, reshaped and merged by EntityID and year before the first in-memory preparation block. The raw exports and their produced panel are absent from this package.
- R-REPRISK-IDENTIFIERS [undetermined]: The RepRisk identifier file read at Code_GMP.do:162 to filter HEADQUARTER_COUNTRY == GB and retain REPRISK_ID for the subsequent join. The consumed file is absent; source schema and population are not yet verified.
- R-REPRISK-RISK-PANEL [undetermined]: The second RepRisk file read at Code_GMP.do:168, with dated ISIN-level CURRENT_RRI observations used to build annual and industry risk measures. The consumed file and its required history/schema are absent or unverified.
- R-COMBINED-AP-AR [undetermined]: The prepared Combined Annual AP and AR.dta input read at Code_GMP.do:181 and joined to RepRisk measures. Its producer, exact field mapping, coverage, and join contract are not supplied.
- R-PPDR-REPORTS [undetermined]: The prepared PPDR data.dta input used in the Table 3 branch. Code comments describe an official payment-practices download and an Excel-to-Stata preparation step; the data file is absent.
- R-SURVEY-RESPONSES [undetermined]: The combined SME and Large survey response file used in both Table 4 panels. The code describes two sheets in a SoGoSurvey workbook and an append step, but neither the workbook nor the prepared .dta is packaged.
- R-COMBINED-AP-AR-UNIQUE [undetermined]: A distinct prepared annual AP/AR file with one row per ISIN/year is read at Code_GMP.do:176 and merged before the RepRisk industry measure is constructed. Its producer and mapping to the separately read Combined Annual AP and AR.dta are not supplied.
- S-WINSOR2 [preparation_required]: The author calls winsor2 in the preparation code. It was not found in the default or separately configured checked Stata adopaths; no installation was attempted.
- S-EXCEL [unverified]: The manual Capital IQ preparation instructions say to open the downloaded screens in Excel. The environment probe does not establish Excel availability.

## Review notes

- The assessment target is the complete supplied Code_GMP.do main-analysis workflow. The frozen title and DOI are preserved exactly. The appendix title says Dynamics while the main code and datasheet say Contracting; this is contextual version/output comparison only, with no mandatory attribution issue or prerequisite.
- The workflow trace records the manual Capital IQ panel, each supplied construction stage, the line 176 unique ISIN/year file, all six frozen dependency IDs, and the supplied Table 2, Table 3, Table 4 Panels A/B, Table 5, and Table 6 consumers. Appendix-only analyses without supplied executable stages remain contextual.
- The datasheet describes Identifiers.dta as an identifier list. Its bounded probe returns EntityID only, and Code_GMP.do does not read it; it is not treated as an analysis panel.
- The three credential/connection scan versions are retained as process artifacts only. The final scan emitted only appendix line 138 and its hash; matching text remains withheld and no source/evidence record or access conclusion uses that line. The broader earlier scan overmatched generic author wording and was corrected without altering source bytes.
- Catalog helper construction failures and the RepRisk V2 metrics timeout are preserved in their original probe records; only successful bounded catalog and data-metadata results are cited as scientific evidence. Catalog misses and one-row probes do not establish entitlement, absence, or historical coverage.
- The official static GOV.UK check confirms public availability of reports through a government service, but not a bulk export contract, field schema, or exact report-period completeness. No data payload, author program, model, regression, or statistical trial was run; no software was installed and no source or data was edited.
- Preflight 001 detected the schema-required closure_complete field and trailing blank-line quote-boundary mismatches in two cached PDF text citations. The exact failed draft, helper, command, and streams are preserved; the scope flag and citation windows were corrected from the registered cached text before finalization.
- A coordinator locator clarification states that the sweep run_root resolves audit/artifact locators only. It is not an execution or data root; any later authorized run uses a separate isolated working directory outside the controller run and frozen generation. The clarification is preserved at probes/root_locator_correction_002/locator_clarification_process_record.json as process guidance, not author-source evidence.
- The prior root wording was corrected before acceptance. The prior finalized assessment/proposal pair, draft, and workflow trace are preserved in probes/root_locator_correction_002; the immutable coordinator checkpoint retains the wider probe history.
