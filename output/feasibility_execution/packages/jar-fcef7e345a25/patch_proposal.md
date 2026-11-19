# Patch proposal: jar-fcef7e345a25

Renewable Governance: Good for the Environment?

DOI: 10.1111/1475-679X.12462

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Run the supplied DLRTW Stata preparation workflow through its actual Step 16 output, stata/datasets/sample-7-17-21. This target includes the lead-score construction, non-US Orbis branch, governance merges and winsorization; the code does not supply a final paper regression stage.

Entry points: `DLRTW_code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12462 - Renewable-Governance-Good-for-the-Environment/dlrtw-datasheet-code-and-identifiers.zip",
      "sha256": "7796716372f28fdd0f10a5b6b296090ac7b835a7c29d5b3e321fe0fdb02aff65"
    },
    {
      "path": "JAR-Volume 61/Issue 1/12462 - Renewable-Governance-Good-for-the-Environment/dlrtw-online-appendix.pdf",
      "sha256": "76336f0e1a6f4ef8d021ab362b5becacba7d8e9aa051cc1fb4c3da73df290d73"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "1db418546496e630a6ca314f82001070b5332c9165ba5d9a74d62d0826776f95"
}
```

## Proposed actions

### A_CORE_DATA: Locate compatible author-prepared files or specific source products for the 24 independent code inputs, preserving their distinct vendor/source roles. Verify the field, identifier, time-period and non-US population contracts against the supplied code; do not treat the packaged identifier list or product descriptions as an analysis panel, and do not turn a prepared route and its raw source into duplicate mandatory requirements.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HEADER, R_WORLDSCOPE, R_ASSET4_ENV, R_FACTSET, R_ORBIS_ANNUAL, R_ORBIS_RFS, I_INPUT_CLOSURE, R_ASSET4_GOV1, R_ASSET4_GOV2, R_DATASTREAM, R_COUNTRY_STATIC, R_SECREG, R_COUNTRY_GOVERN, R_ESG_RULES, R_BOARDEx_PANEL, R_CROSSLIST_US, R_CROSSLIST_ADR, R_GENDER_QUOTA, R_FAMILY_CHECK, R_SASB_MATERIALITY, R_ASSET4_GOV_2019, R_ASSET4_GSCORE_2013, R_ASSET4_GSCORE_2017, R_ASSET4_SUSGOV
Evidence: E_DOC_SOURCES, E_DOC_VINTAGES, E_CODE_STEPS, E_WORK_ITEM, E_SAMPLE_PROBE, E_WORKFLOW_TRACE, E_CODE_TOC, E_CATALOG_LOOKUPS, E_CATALOG_PRODUCTS, E_CATALOG_FIT, E_PUB_LSEG_FUNDAMENTALS, E_PUB_LSEG_ESG, E_PUB_FACTSET, E_PUB_ORBIS, E_PUB_DATASTREAM, E_PUB_SASB, E_PUB_GFB, E_PUB_SP_GLOBAL

Preparation / proposed procedure:

1. Use the assigned frozen catalog and official static documentation for named products; treat catalog hits and product pages as candidates, not proof of entitlement or author-field compatibility.
2. Match the Worldscope crosswalk, fiscal-year panel and annual ASSET4 score series, preserving the non-US Worldscope branch, missing-fyr year-end assumption and one-year F. outcome construction.
3. Retain both prepared Orbis branches: the updated panel matched from 2009 onward over four ISIN and four SEDOL identifiers, and the RFS2013 non-US panel used through 2008; preserve the BvDIDNumber–uonamenew and tFam–tOther variable-order source ranges until their full source schema is known.
4. Retain the author-prepared FactSet quarterly ownership series, ASSET4 governance line items, Datastream free-float panel, country/regulatory sources, cross-listing histories, gender quotas, manual family flag and SASB materiality scores as separate inputs.
5. Resolve the omitted BoardEx producer/panel and verify Step 14 SP-ES prepared-panel keys and scores; treat the SP-ES filename date as provenance unless substantive source incompatibility is demonstrated.

Validation to perform later:

- After an authorized input handoff, inspect bounded source headers and confirm every exact join key, required target field, country/entity mapping, and period needed by the code; do not infer full history or population coverage from a sampled row.
- Confirm the prepared input set contains non-US firms and histories needed to generate the exact Step 16 target `stata/datasets/sample-7-17-21`; do not add a final regression stage absent from the supplied code.

### A_BOARD_PRODUCER: Obtain the omitted BoardEx panel producer or a compatible prepared panel, plus its field, identifier and history mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_BOARD_PRODUCER
Evidence: E_CODE_BOARD, E_DOC_VINTAGES, E_PROBE_BOARDEX_NA_CANDIDATE, E_CATALOG_PRODUCTS, E_PUB_BOARDEX

Preparation / proposed procedure:

1. Obtain the omitted author producer/specification or a compatible prepared BoardEx panel; the current North American summary candidate is not a substitute for the target non-US panel.
2. Document how regional BoardEx source records map into boardex_companyid/year and the downstream board/gender/governance variables used in Step 13.

Validation to perform later:

- Confirm the staged panel preserves the author's non-US firm/year coverage and supplies the exact boardex_companyid/year join plus all downstream consumed fields.

### A_PROJECT_ROOT: Stage the authored project tree with distinct Data/ and data/ directories, set the batch working directory to that tree, and replace the laptop-only cd line in a working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PROJECT_ROOT
Evidence: E_CODE_ROOT, E_CODE_STEPS, E_WORKFLOW_TRACE_SAVED

**Proposed edit:** `DLRTW_code.do:33–33`
Source SHA-256: `49256f022fe265072ece4a9e58dade63abb7db19c8ed93bb1d1ac3f4da2aec2f`

The hard-coded author laptop directory is not portable; retain the authored relative data/output paths and make the wrapper choose their project root.

Current text:
```
cd "[redacted-path-d6e9e2dc148a]"  /// Mitch Laptop
```

Proposed replacement:
```
* Runtime working directory is set by the batch wrapper to the staged project root.
```

Preparation / proposed procedure:

1. Place the package copy and required input trees under a host-visible relative or [redacted-path-e16a5c9c81a0] root.
2. Preserve case-sensitive directory distinctions: code reads both data/asset4 and Data/ASSET4.
3. Run the Stata batch wrapper from the staged project root.

Validation to perform later:

- Before any separately authorized run, confirm the wrapper working directory and relative paths resolve to the staged input tree and output tree.

### A_SP_ES_CONTRACT: Locate the author-prepared SAM S&P Global panel or a compatible source route, then verify its firm/year keys, score fields, population and source-to-score mapping without requiring the historical file bytes solely because of the 2020 filename.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SP_ES, I_SP_ES_CONTRACT
Evidence: E_CODE_SP_ES, E_DOC_SP_ES, E_DOC_SASB_SP, E_CATALOG_LOOKUPS, E_PUB_SP_GLOBAL

Preparation / proposed procedure:

1. Locate the author-prepared SAM S&P Global panel or a documented compatible delivery; use a prepared panel as the primary route if it satisfies the code's variables.
2. Verify entity_key/year keys, E_SPGlobal/S_SPGlobal names and meanings, firm/year coverage, and score-source mapping. Keep the 2020 filename date as provenance; do not require byte-identical vintage absent a substantive compatibility reason.

Validation to perform later:

- After separately authorized acquisition, verify the bounded source columns and entity_key/year mapping; compare coverage and score definitions with the documented use.

### A_MMERGE_SETUP: Make the exact Stata command mmerge available through a documented compatible ado implementation before an authorized author-code run; no package source or substitute semantics are selected from this audit.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_MMERGE, S_MMERGE
Evidence: E_STATA_MMERGE, E_CODE_STEPS, E_CODE_WORLD_MERGE

Preparation / proposed procedure:

1. Locate the authors' compatible mmerge implementation or another explicitly approved implementation with the same entity/year merge semantics, and place it on the Stata ado path.

Validation to perform later:

- Re-run only the self-written `which mmerge` check and record the resolved command path/version; keep all author Stata code unexecuted until data and setup are separately authorized.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The frozen inventory contains the datasheet, DLRTW_code.do, an identifier list and online appendix, but not the 24 project-relative inputs read by the supplied 16-stage code. The identifier-list probe is a dscode-only file-metadata sample, not an analysis panel. Frozen catalog checks found a readable Worldscope annual candidate and current ASSET4/BoardEx tables, but no author-file/field/history mapping; product-page checks are descriptive only. Orbis prepared panels, FactSet ownership, Datastream free-float panel, country sources, governance line items, family/SASB/cross-list files and SP-ES panel remain unverified. Catalog misses are not evidence of absent entitlements or data.
- I_BOARD_PRODUCER [unresolved; full_pipeline]: Step 8 consumes stata/datasets/boardex_panel27august_all, but no supplied step constructs that panel. The frozen catalog has regional BoardEx source families and a readable North American organization-summary candidate; its CompanyID/BoardID/AnnualReportDate/GenderRatio schema does not provide the author panel producer, non-US coverage, boardex_companyid mapping or the full Step 16 board/governance fields.
- I_PROJECT_ROOT [preparation; full_pipeline]: The code changes directory to the author laptop path before using relative data and output paths. A staged project root and coherent host-visible directory tree are required.
- I_SP_ES_CONTRACT [unresolved; full_pipeline]: Step 14 consumes stata/datasets/SP-ES-2020-11-27, but the supplied code has no producer and the frozen catalog has no matching prepared panel. The datasheet identifies SAM S&P Global as the alternative E/S source; current product documentation does not establish the prepared panel's entity_key/year coverage or E_SPGlobal/S_SPGlobal mapping. The 2020 filename/date is provenance only, not a byte-identical vintage requirement.
- I_MMERGE [preparation; full_pipeline]: The supplied code invokes mmerge for entity/year and identifier joins. The bounded Stata 18 `which mmerge` probe returned 111, so the exact command is not currently available on Stata's ado path. A compatible documented mmerge implementation or approved equivalent with the same merge behavior is needed before a future authorized run.
- R_HEADER [undetermined]: ASSET4 header/crosswalk input. Author code path: data/header/Header_15feb18.csv. The required file/compatible source and exact fields or history remain unverified. Author code path: data/header/Header_15feb18.csv. Required key/field and history contract: Firm identifier crosswalk for joining Worldscope to asset vendor, FactSet, BoardEx and sequential ISIN/SEDOL keys; historical validity and cardinalities are not specified. The code also orders the source range from worldscopepermid through samefirm, so its original fields/order must be retained; expansion and historical mapping remain unverified. The code also orders the source range from worldscopepermid through samefirm, so its original fields/order must be retained; expansion and historical mapping remain unverified.
- R_WORLDSCOPE [undetermined]: Worldscope annual firm panel, retaining non-US firms and required 2000 onward construction history. Author code path: data/worldscope/worldscope-1-19-2018. The required file/compatible source and exact fields or history remain unverified. Author code path: data/worldscope/worldscope-1-19-2018. Required key/field and history contract: The author code retains non-US firms, starts panel construction at year 2000, derives quarter from fyr with a missing-fyr year-end assumption, and later requires financial-control fields. Exact numeric Worldscope item-to-Stata-field mapping remains unverified.
- R_ASSET4_ENV [undetermined]: ASSET4 environmental score panel used to construct next-year outcome measures. Author code path: data/asset4/ES_scores_18-08-07.dta. The required file/compatible source and exact fields or history remain unverified. Author code path: data/asset4/ES_scores_18-08-07.dta. Required key/field and history contract: The code drops missing ENVSCORE, deduplicates by company/year, constructs overall scores from enviro_score fields, and creates F. one-annual-panel-row leads for e1_lead–e5_lead and material/ER/RR/PI outcomes. The retained sample later requires e1_lead/e2_lead; no additional boundary-row requirement is inferred.
- R_FACTSET [undetermined]: FactSet institutional ownership panel joined by FactSet entity ID and quarter. Author code path: data/factset/holdings_by_firm_msci_Hannes_13Nov2017. The required file/compatible source and exact fields or history remain unverified. Author code path: data/factset/holdings_by_firm_msci_Hannes_13Nov2017. Required key/field and history contract: The code parses quarter as YYYYQQ, derives year and a quarter number, builds yq and merges by factset_entity_id/yq; preserve the 2017 prepared ownership series and non-US coverage. The source file must preserve the Stata variable-order range `io- yq`; exact intervening fields are not listed by the code and must not be guessed. The source file must preserve the Stata variable-order range `io- yq`; exact intervening fields are not listed by the code and must not be guessed.
- R_ORBIS_ANNUAL [undetermined]: Orbis annual panel used for firm-year observations from 2009 onward. Author code path: data/orbis/orbis_annualpanel. The required file/compatible source and exact fields or history remain unverified. Author code path: data/orbis/orbis_annualpanel. Required key/field and history contract: The updated panel is used for year>=2009 and sequentially matched on four ISIN and four SEDOL slots. Code keeps Stata variable-order ranges BvDIDNumber–uonamenew and tFam–tOther; preserve those source fields/order until the full schema is known.
- R_ORBIS_RFS [undetermined]: Earlier Orbis non-US panel used for 2005–2008 firm-year observations. Author code path: data/orbis/RFS2013_2005to2009_nonUSfirms. The required file/compatible source and exact fields or history remain unverified. Author code path: data/orbis/RFS2013_2005to2009_nonUSfirms. Required key/field and history contract: Prepared RFS2013 non-US source is used through year 2008, matched sequentially to three ISIN slots and four SEDOL slots; code drops country. Preserve the 2005–2008 non-US branch and its key conventions.
- R_ASSET4_GOV1 [undetermined]: ASSET4 governance line-item panel 1. Author code path: data/asset4/gov-line-items. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/asset4/gov-line-items. Required key/field and history contract: One of two ASSET4 line-item source files, deduplicated on asset4companyid/yq. After both line-item joins, the combined panel explicitly uses CGVSCORE, QCGSRDP022/023/024/025/026/033/059, QCGSRO01V/02V/05V, QCGBSDP060, QCGBSO03V/05V/06V/07V/08V/09V, QCGSRDP045/046/048/049 and QCGSRO03V; the split between the two source files is not specified.
- R_ASSET4_GOV2 [undetermined]: ASSET4 governance line-item panel 2. Author code path: data/asset4/gov-line-items-2. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/asset4/gov-line-items-2. Required key/field and history contract: Second ASSET4 line-item source file, deduplicated on asset4companyid/yq and combined with the first. The combined-panel fields consumed after both joins are listed in the companion R_ASSET4_GOV1 contract; do not assume which file contributes each field.
- R_DATASTREAM [undetermined]: Datastream free-float and ownership panel. Author code path: data/datastream/free-float-items-9-22-18. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/datastream/free-float-items-9-22-18. Required key/field and history contract: The prepared free-float-items panel is joined on asset4companyid/yq. Its exact source fields and relationship to downstream variables remain unverified; no inferred chs/ownership field mapping is assigned to this file.
- R_COUNTRY_STATIC [undetermined]: Country-level static data. Author code path: data/country data/country-level-data-static. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/country data/country-level-data-static. Required key/field and history contract: Country-level static file is joined by ccode. Preserve all source variables; the code's later derived countrycode is grouped from ccode.
- R_SECREG [undetermined]: Country-level securities regulation data. Author code path: data/country data/secreg. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/country data/secreg. Required key/field and history contract: Country securities-regulation file is joined by ccode and drops wb_country_name. The remaining retained fields/definitions are not spelled out in code and must be preserved in the author input.
- R_COUNTRY_GOVERN [undetermined]: Country governance data. Author code path: data/country data/govern. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/country data/govern. Required key/field and history contract: Country governance file is joined by ccode; preserve its full source fields and country coverage because the supplied code does not enumerate the full retained schema.
- R_ESG_RULES [undetermined]: Country ESG disclosure rules. Author code path: data/country data/esg-disclosure-rules-new. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/country data/esg-disclosure-rules-new. Required key/field and history contract: Country ESG disclosure/stewardship file is joined on ccode; code constructs mandatory_disc and stewardship using the two named year fields.
- R_BOARDEx_PANEL [undetermined]: BoardEx annual company panel used at Step 8. Author code path: stata/datasets/boardex_panel27august_all. Required field, identifier, period and construction compatibility remain unverified. Author code path: stata/datasets/boardex_panel27august_all. Required key/field and history contract: Step 8 joins the omitted prepared panel on boardex_companyid/year. These are downstream BoardEx/governance fields consumed later; the panel producer, source-ID mapping, non-US regional coverage and exact source-to-panel schema are missing.
- R_CROSSLIST_US [undetermined]: US exchange-traded/cross-listing input. Author code path: data/cross-listing/US-exchange-traded. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/cross-listing/US-exchange-traded. Required key/field and history contract: This prepared list is joined by entity_key and converted to annual ADR status using effective/inactive dates, with explicit 2015-to-2016 end-date cases. Preserve historical dates and source company identity.
- R_CROSSLIST_ADR [undetermined]: ADR exchange-traded input. Author code path: data/cross-listing/ADR-exchange-traded. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/cross-listing/ADR-exchange-traded. Required key/field and history contract: Second prepared ADR list is joined by entity_key and its period fields extend the same annual ADR flag. Exact date-vintage and issuer-to-entity mapping remain unverified.
- R_GENDER_QUOTA [undetermined]: Country gender-quota workbook. Author code path: data/country data/genderquota.xlsx. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/country data/genderquota.xlsx. Required key/field and history contract: Excel Sheet1 is imported with first row as headers, rows without ccode are removed, and europe is dropped before the ccode merge. Preserve the remaining columns and country history as authored. The code explicitly drops the imported europe column after removing empty ccode rows. The code explicitly drops the imported europe column after removing empty ccode rows.
- R_FAMILY_CHECK [undetermined]: Global Family Business Index top-100 family-firm list. Author code path: data/family firms/FamilyCheck4June.csv. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/family firms/FamilyCheck4June.csv. Required key/field and history contract: CSV is filtered to familygbiftop00==1 and one row per entity_key; this manual top-100 flag is then used with Orbis uotypenew and ASSET4 voting fields in the Step 16 family classification.
- R_SASB_MATERIALITY [undetermined]: SASB Materiality E-score panel. Author code path: data/SASB Materiality/SASB-Materiality-E-Scores-3-13-18. Required field, identifier, period and construction compatibility remain unverified. Author code path: data/SASB Materiality/SASB-Materiality-E-Scores-3-13-18. Required key/field and history contract: Prepared 2018 SASB Materiality E-score file is normalized to asset4companyid/yq_asset4 and joined at that cadence. Retain its full score schema; exact score-column names are not referenced by the supplied code.
- R_ASSET4_GOV_2019 [undetermined]: ASSET4 governance measures dated 2019. Author code path: Data/ASSET4/gov-measures-8-30-19. Required field, identifier, period and construction compatibility remain unverified. Author code path: Data/ASSET4/gov-measures-8-30-19. Required key/field and history contract: Joined on dscode/yq with three additional ASSET4 G-score/governance inputs. The combined downstream panel explicitly uses pctindependent, perc_indep_board_strict, per_indep_board, ceochairdual, CEO_chairman_dual, pctwomen, has_female_dir, gov_score_exVS_V2, boardsize, totdirectors, boardsize_stulz, dir_ann_ind_elected, dir_ind_elected, indep_audit_comm and one_share_one_vote; exact source-field split across four ASSET4 files is unresolved.
- R_ASSET4_GSCORE_2013 [undetermined]: ASSET4 G-score panel dated 2013. Author code path: Data/ASSET4/G-score-2013. Required field, identifier, period and construction compatibility remain unverified. Author code path: Data/ASSET4/G-score-2013. Required key/field and history contract: Older prepared G-score source is joined by dscode/yq. Preserve its field schema because the supplied program does not enumerate the file's contributing variables.
- R_ASSET4_GSCORE_2017 [undetermined]: ASSET4 G-score panel dated 2017. Author code path: Data/ASSET4/G-score-2017. Required field, identifier, period and construction compatibility remain unverified. Author code path: Data/ASSET4/G-score-2017. Required key/field and history contract: Prepared G-score source is joined by dscode/yq. Preserve its field schema because the supplied program does not enumerate the file's contributing variables.
- R_ASSET4_SUSGOV [undetermined]: ASSET4 sustainability/governance item panel. Author code path: Data/ASSET4/sustainability-gov-items-2021-07-17. Required field, identifier, period and construction compatibility remain unverified. Author code path: Data/ASSET4/sustainability-gov-items-2021-07-17. Required key/field and history contract: Prepared sustainability governance source is joined by dscode/yq. Preserve its field schema because the supplied program does not enumerate the file's contributing variables.
- R_SP_ES [undetermined]: Prepared alternative E/S measure panel identified by SAM S&P Global source provenance. Author code path: stata/datasets/SP-ES-2020-11-27. Required field, identifier, period and construction compatibility remain unverified. Author code path: stata/datasets/SP-ES-2020-11-27. Required key/field and history contract: Step 14 joins the prepared alternative score panel by entity_key/year and derives lnE_SPGlobal and lnS_SPGlobal. A compatible prepared panel is primary; the 2020 filename is provenance only, not a requirement for byte-identical data.
- S_MMERGE [preparation_required]: Stata 18 is available, but its exact `which mmerge` check returned rc 111; provide/locate a compatible implementation before an author-code run. No install or alternative merge behavior is assumed.

## Review notes

- The selected scope is the supplied 16-stage Stata preparation workflow through its actual Step 16 save, `stata/datasets/sample-7-17-21`. The Step 5 regress/predict operation constructs cgv_resid for governance preparation; no final paper regression is supplied or added.
- The code's sample filter starts at year>=2004 and has no supplied upper year cap. The appendix's 2004–2015 table period is retained as paper-output context, not used to impose an unprovided sample limit. The one-year ASSET4 F. lead and its annual panel-row construction remain explicit in the input contract.
- All 24 project-relative author input reads remain separate requirements. The packaged Sample_firms_30Sep2022.dta is an identifier list with dscode metadata, not an analysis panel. Preserve the case-sensitive `data/asset4` and `Data/ASSET4` input trees and the separate non-US Worldscope, FactSet, Orbis/RFS, BoardEx and prepared-score source families.
- The frozen product catalog and official static product pages were checked for each named product family. The catalog contains a readable Worldscope annual candidate and readable current ASSET4 summary/BoardEx North American candidates; their author-field mapping, non-US/history coverage and prepared-panel construction are unresolved. Catalog misses and public product descriptions do not prove absent data or entitlement; all such routes remain unverified.
- Stata 18 and the exact `winsor` command are available by bounded self-written version/which probes. The exact `mmerge` lookup returned rc 111 and is recorded as a software setup prerequisite. No author Stata code, data transformation, SAS process, regression, solver, installation or synthetic trial was run.
- Preservation history: the first draft-stage-2 helper source and its captured traceback are preserved byte-exact under probes/. The Citi home-page open timed out; its exact official static directory subpage was inspected separately, while transfer volume remains unknown. Four preflight errors were returned before the final corrected preflight passed; the displayed tool-response text is recorded in probes/preflight_retry_history.json. The first three failed preflight source versions and separate child streams were not retained and are not reconstructed; the later failed source snapshot is preserved there.
