# Patch proposal: jar-37fbcadcb991

Do governments hide resources from unions? The influence of public sector unions on reported discretionary fund balance ratios

DOI: 10.1111/1475-679X.12497

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied-code target consists of the three named SAS programs and their actual inputs, producer-consumer handoffs, branches and execution order. The datasheet separately records historical SAS 9.3 construction and Stata 16 paper-regression use; the delivered code folder is described as these three SAS programs. This assessment covers the supplied SAS variant and does not claim publication-wide estimation or full-paper results reproduction.

Entry points: `GJK_main results.sas`, `GJK Table 5.sas`, `GJK Table 6.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12497 - Do-governments-hide-resources-from-unions-The-influence-of-public-sector-unions-on-reported-discretionary-fund/gjk-datasheet-code-and-identifiers.zip",
      "sha256": "8643ccad345d61619972547e09669506f991874bcde798cd075320101ee07e11"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12497 - Do-governments-hide-resources-from-unions-The-influence-of-public-sector-unions-on-reported-discretionary-fund/gjk-online-appendix.pdf",
      "sha256": "601f2a1ede80e8cde5ecc43b0641c5dea10f8b5e81693f1f1319d6ed034f7bf1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "9f5b85fdcb33a3ffa038a5565b4af47cf5497f1dcb217aedf3c95921eb6b5181"
}
```

## Proposed actions

### ACT_SAS_LIBRARY_SETUP: Prepare a working copy with a host-visible UNION library mapping and a coherent current directory for the relative CSV inputs; preserve the authored source layout and use host-supported relative or [redacted-path-0d408e0af1c4] roots. The main program comment equates UNION_11092017 with generated UNION_DATA8; configure the exact alias as preparation in the intended library rather than treating it as a separate empirical source.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_SAS_LIBRARY_CONTEXT
Evidence: EV_SCAN, EV_TRACE, EV_MAIN_ALIAS

Preparation / proposed procedure:

1. Stage the author-provided CSV/SAS inputs in a host-visible directory matching the source's relative-name expectations.
2. Configure UNION for the compatible author-data root; do not put the Dropbox workspace path into executable host configuration.
3. Run the supplied main SAS program before its consumers and retain all author files and output tables.
4. Expose UNION_11092017 as the documented UNION_DATA8 alias in the intended library while preserving the exact consumer name; confirm this mapping from author setup instructions before a run.

Validation to perform later:

- After a separately authorized run, verify each referenced input and required output table by its exact name, schema and key coverage.

### ACT_GFOA_ACQUIRE: Locate an authorized GFOA Financial Indicators route or obtain the author-compatible annual files and current access terms; the prior purchase history is not proof of present access.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_GFOA_FI
Evidence: EV_DS_GFOA, EV_DS_EXTRA_GFOA, EV_T5_GFOA_NOTE, EV_CAT_GFOA, EV_CAT_FI_NAME, EV_CAT_FINANCIAL_INDICATORS

Preparation / proposed procedure:

1. Identify the actual 2003–2015 annual source files and document their field/identifier changes by vintage.
2. Keep the CSV files used by the main program distinct from the SAS tables used by Table 5 and Table 6.
3. Record that exact GFOA and annual-alias catalog searches found no compatible local leaf; this does not establish current access or a license barrier. Keep the authored annual/vintage inputs distinct.

Validation to perform later:

- Check required fields, identifiers, year coverage and mappings before preparing the author's consumed tables.

### ACT_ICMA_LINK_ACQUIRE: Obtain the purchased ICMA link table and the missing definitions/producers for UNION.MATCH and UNION.MATCH3, preserving their distinct identifier and geography schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ICMA_LINK, ISS_MAIN_MATCH_HANDOFF
Evidence: EV_DS_ICMA_LINK, EV_MAIN_MATCH, EV_T5_MATCH3, EV_CAT_ICMA_LINK, EV_CATALOG_LOOKUP_LEDGER

Preparation / proposed procedure:

1. Map the supplied qry_lg_demographics_match CSV to the exact UNION.MATCH and UNION.MATCH3 fields and explain any separate preparations.
2. Do not equate IMISID, ID/ID2, UJURIS2, FIPS and census_id without a documented transformation.
3. Record the exact ICMA/CSV catalog misses and retain UNION.MATCH and UNION.MATCH3 as separate unresolved prepared-table handoffs until the author mappings and schema/history are supplied.

Validation to perform later:

- Confirm that all main/Table 5 join keys are present, typed and covered for the authored municipality-years.

### ACT_ICMA_UNION_ACQUIRE: Obtain the authorized ICMA 1999 labor-management survey input and the author's producer/source history for the separate UNION.UNIONS3 table; preserve its relationship to unions3.csv as unresolved until the exact mapping is supplied.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_ICMA_UNION, ISS_MAIN_UNIONS3_HANDOFF
Evidence: EV_DS_ICMA_UNION, EV_MAIN_UNION_CSV, EV_MAIN_UNIONS3, EV_CAT_ICMA_UNION, EV_CAT_LABOR_ALIAS, EV_CAT_UNION_ALIAS

Preparation / proposed procedure:

1. Keep the supplied unions3.csv import to WORK.UNION1 and the later UNION.UNIONS3 read as distinct source contracts.
2. Request the source history, producer, fields and identifier mapping for UNION.UNIONS3; do not infer that WORK.UNION1 creates it.
3. Retain the exact unions3 catalog miss and unrelated labor/union alias leaves as discovery only; do not substitute those products for either author input.

Validation to perform later:

- Verify the union presence/workforce fields and identifier coverage for each supported input separately, then document any author-supplied mapping between WORK.UNION1 and UNION.UNIONS3 without changing the authored definitions.

### ACT_CENSUS_ACQUIRE: Identify the official Census product and required county measures/vintages, then obtain the public data needed to construct UNION.DEM with the authors' FIPS/year mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_CENSUS_DEMOGRAPHICS
Evidence: EV_DS_CENSUS, EV_MAIN_DEM, EV_CAT_CENSUS, EV_STATIC_CENSUS

Preparation / proposed procedure:

1. Use a bounded official product/documentation check; do not request a dataset payload during this assessment.
2. Preserve the distinction between the datasheet's county demographic inputs and the separate Ohio Census economics table.
3. The exact Census catalog query had no selected leaves and two direct official static documentation opens were inaccessible via the web tool; retain product, vintage, fields, and FIPS history as unresolved without inferring a public-data barrier.

Validation to perform later:

- Check fields, FIPS representation, geography, periods and join coverage against the actual UNION.DEM consumer.

### ACT_COUNTY_SOURCE_CLARIFY: Identify the product, field definitions, geographic level and history for the exact UNION.COUNTY columns used to derive county macro controls.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COUNTY_MACRO
Evidence: EV_MAIN_COUNTY, EV_CAT_COUNTY

Preparation / proposed procedure:

1. Search the assigned frozen catalog by the exact table/product labels and record only selected candidate leaves.
2. Do not substitute a source based only on a similar column label.
3. The bounded county search returned unrelated selected leaves; do not treat similar names as UNION.COUNTY or as evidence of required fields/history.

Validation to perform later:

- Confirm FIPS and year keys, required source columns and their definitions against the authored derivations.

### ACT_OHIO_BALANCE_PREPARE: Obtain the author-prepared mixed GFOA/manual Ohio fund-balance table or its exact preparation mapping, then preserve the CAFR flag and balance fields used by Table 6.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_OHIO_FUND_BALANCE
Evidence: EV_T6_BALANCE_INPUT, EV_DS_HAND_CAFR, EV_CAT_OHIO_BALANCE, EV_STATIC_OHIO

Preparation / proposed procedure:

1. Identify the municipality-year observations missing GFOA data and the public statement sources the authors hand-coded.
2. Do not force both underlying source branches into a single alternative when preparing the mixed table.
3. The exact fund_balance_oh alias lookup had no selected leaf; the general Ohio Auditor static fetch returned 502 and no city list was supplied. Keep both source-history and route verification open.

Validation to perform later:

- Verify the Table 6 field definitions, source population and sample-period coverage before the hand/GFOA split.

### ACT_SERB_CONTRACT_ACQUIRE: Use the official SERB archive as the candidate public source for Ohio agreement documents, then construct the author-prepared contract table only after its exact municipality/year and date-coding contract is known.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_OHIO_UNION_CONTRACTS
Evidence: EV_DS_OHIO_CONTRACT, EV_T6_CONTRACT_INPUT, EV_STATIC_SERB, EV_CAT_OHIO_CONTRACT

Preparation / proposed procedure:

1. Perform a bounded official static-page check of the author-named archive; do not follow payload links or download documents during this assessment.
2. Preserve employer identifiers, start/end dates, overlapping contracts and the code's two-year reporting lag.
3. The direct author-named SERB static URL returned 404. Confirm the current official archive location and its required municipality/year coverage from an author-provided source; this failure is not a restriction finding.

Validation to perform later:

- Compare archive coverage and identifiers with the expected contract-year table before constructing treatment flags.

### ACT_OHIO_CENSUS_ACQUIRE: Identify the public product and source history for UNION.OHIO_CENSUS_ECON, then verify the exact city/year and entity-name keys required by the Table 6 join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_OHIO_CENSUS_ECON
Evidence: EV_T6_CENSUS_INPUT, EV_T6_ENTITY4, EV_T6_ENTITY5, EV_CAT_OHIO_CENSUS, EV_STATIC_CENSUS

Preparation / proposed procedure:

1. Keep the source geography and city-name crosswalk unresolved until its actual input contract is documented.
2. The exact Ohio Census table alias had no selected catalog leaf, and static Census documentation fetches were inaccessible; do not infer the product or the entity4/entity5 crosswalk.

Validation to perform later:

- Check the expected geography/year rows and both sides of the authored entity-name join.

### ACT_T6_HANDOFFS: Resolve the exact missing producer and key contract for the Table 6 sample and final fund-balance chain before attempting that branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_T5_TO_T6_SAMPLE_HANDOFF, ISS_T6_NEW7_HANDOFF, ISS_T6_ENTITY_KEY
Evidence: EV_T5_FINAL, EV_T6_FI_INPUT, EV_T6_NEW5, EV_T6_NEW7, EV_T6_ENTITY4, EV_T6_ENTITY5

Preparation / proposed procedure:

1. Identify the supported producer for UNION.FI_0515_WITHFIPS3 and establish whether any conversion from UNION.FI_0415_WITHFIPS3 is intended.
2. Identify the producer for UNION.FUND_BALANCE_ALL2_NEW7 after NEW5 and explain the entity5/entity4 join-key mapping.
3. Do not guess that 0415 equals 0515, NEW5 equals NEW7, or entity4 equals entity5.

Validation to perform later:

- Verify each named producer, consumer, schema and join key from a complete author-supplied source before the Table 6 run.

### ACT_OPEN_COMMENT_REVIEW: Clarify whether the main source tail from line 752 to EOF is intentionally commented and whether a closing delimiter or separate executable branch was omitted.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_MAIN_OPEN_COMMENT
Evidence: EV_MAIN_TAIL, EV_SAS_COMMENT_REF

Preparation / proposed procedure:

1. Retain D0100–D0116 as inactive comment content in the current submitted workflow.
2. Do not activate or edit the masked tail until its intended status and complete boundaries are supported.
3. The official SAS reference confirms block comments are non-nested; retain the structural boundary 752–848 and the unresolved runtime effect without exposing the masked connection statement or running SAS.

Validation to perform later:

- After clarification and a separately authorized run, confirm the intended active input/output branch without using this review as a syntax test.

### ACT_SAS_RUNTIME_SETUP: Establish a supported SAS batch runtime/environment for the author-specified SAS workflow; the inherited startup failure is retained without inferring absent entitlement.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISS_SAS_RUNTIME_STATUS
Evidence: EV_DS_SOFTWARE, EV_ENVIRONMENT

Preparation / proposed procedure:

1. Use the authorized SAS runtime and host wrapper after the library/data paths are configured.
2. Do not rerun startup or invoke SAS as part of this static assessment.

Validation to perform later:

- A separately authorized preparation check should establish the SAS version and batch environment before running author code.

### ACT_RUN_PROCEDURE: The source-first order for this supplied variant is GJK_main results.sas, followed by its Table 5 synthetic-control preparation and the separate Table 6 Ohio contract preparation. The datasheet's Stata 16 regression use is retained as historical provenance; this target does not claim to reproduce publication-wide estimation results.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: EV_DS_PROGRAMS, EV_TRACE, EV_T5_FINAL, EV_T6_FI_INPUT

Preparation / proposed procedure:

1. After required data, SAS runtime and library setup, run GJK_main results.sas to produce its documented UNION tables and resolve the separate MATCH, UNION.UNIONS3 and other prepared-input mappings.
2. Run GJK Table 5.sas after its UNION_DATA8, MATCH3, DEM2 and annual GFOA inputs are available.
3. Run GJK Table 6.sas only after its distinct FI_0515 input, NEW7 producer and entity5 key contract are resolved.
4. Treat the datasheet's Stata 16 regressions and winsorization description as publication-level method provenance outside the supplied three-SAS code target; do not infer code or claim those estimates were reproduced.

Validation to perform later:

- For the supplied SAS variant, validate each program's exact authored inputs, table names, keys, schemas and periods after a separately authorized run; this static assessment does not verify execution or publication-wide regression outputs.


## Remaining issues and prerequisites

- ISS_SAS_LIBRARY_CONTEXT [preparation; full_pipeline]: The main and Table 5 programs contain a masked library-connection statement and the frozen inputs name a Windows [redacted-path-d361da812cfa] root; Table 6 has no visible library setup. A host-visible UNION mapping and working directory for relative CSV inputs must be configured before the supplied procedure can be attempted.
- ISS_MAIN_MATCH_HANDOFF [unresolved; full_pipeline]: The main program imports qry_lg_demographics_match.csv into ICMAFIPS but separately reads UNION.MATCH; Table 5 later reads UNION.MATCH3. No supplied producer creates these prepared SAS tables or maps their ID, jurisdiction/state and FIPS fields from the CSV. The author comments identify a relationship but do not supply the transformations/schema contract.
- ISS_T5_TO_T6_SAMPLE_HANDOFF [unresolved; full_pipeline]: Table 5 produces UNION.FI_0415_WITHFIPS3 for its 2004–2015 sample. Table 6 reads UNION.FI_0515_WITHFIPS3 (2005–2015 by name); no supplied producer or explicit same-schema transformation for that distinct table is present.
- ISS_T6_NEW7_HANDOFF [unresolved; full_pipeline]: Table 6 creates UNION.FUND_BALANCE_ALL2_NEW5 after joining Ohio economic controls, then reads/sorts UNION.FUND_BALANCE_ALL2_NEW7 and writes NEW8. No supplied producer for NEW7 appears in the complete source file.
- ISS_T6_ENTITY_KEY [unresolved; full_pipeline]: The Ohio Census transform creates entity4, while the later Table 6 join consumes entity5 from the fund-balance side. The supplied code does not define entity5 or document its mapping to entity4; do not assume the names are interchangeable.
- ISS_MAIN_OPEN_COMMENT [unresolved; full_pipeline]: The source-structure record shows a block comment opening at GJK_main results.sas line 752 and still open at EOF line 848. Frozen read edges D0100–D0116 fall in that inactive span and are excluded from active inputs. Runtime handling of the unterminated comment is untested; no SAS parser/runtime was invoked.
- ISS_SAS_RUNTIME_STATUS [unresolved; full_pipeline]: SAS is required by all three supplied programs, but the only inherited runtime evidence is an unsuccessful SAS initialization probe for the SAS 9.4 path. This does not show the author programs ran, prove software absent, or establish a license restriction.
- ISS_MAIN_UNIONS3_HANDOFF [unresolved; full_pipeline]: The main source imports unions3.csv into WORK.UNION1 (lines 282–285), then separately reads UNION.UNIONS3 to create UNION.UNIONS4 (lines 547–584). No supplied statement maps WORK.UNION1 to UNION.UNIONS3. The prepared table's source history and schema are unknown; do not assume the CSV and SAS table are the same input or that one produces the other.
- REQ_GFOA_FI [undetermined]: GFOA financial-indicator annual files for general/governmental fund balances and controls: 2003–2007 in the main sample, 2004–2015 in the supplied synthetic-control preparation, and the 2005–2015 Ohio subset name used by Table 6. Preserve each authored vintage/schema and its distinct CSV/SAS inputs.
- REQ_ICMA_LINK [undetermined]: ICMA municipality linking data used for IMISID, municipality/county/state, FIPS and jurisdiction matching. The main source reads qry_lg_demographics_match.csv, then separately consumes UNION.MATCH and Table 5 consumes UNION.MATCH3; the supplied programs do not show the latter two producers or their mappings.
- REQ_ICMA_UNION [undetermined]: The datasheet identifies the ICMA 1999 labor-management survey. The main source reads unions3.csv into WORK.UNION1 and separately reads UNION.UNIONS3 to create UNION.UNIONS4; the supplied code does not establish their source-history or producer mapping. Retain the CSV source requirement and the UNION.UNIONS3 handoff as distinct unresolved inputs.
- REQ_CENSUS_DEMOGRAPHICS [undetermined]: County-level demographic inputs described for entropy balancing and consumed through UNION.DEM/UNION.DEM2, keyed to FIPS/census identifiers. Required measures and history need to be reconciled with the actual imported table.
- REQ_COUNTY_MACRO [undetermined]: UNION.COUNTY fields B7_CLF05, B7_BUS06, B13_GVE03, B13_POP01, B13_GVE04 and B8_PIE22 are consumed to derive county unemployment, employment growth, public employment/full-time and government wage controls, then merged by FIPS. The source product, field definitions and year/geography coverage are unspecified.
- REQ_OHIO_FUND_BALANCE [undetermined]: The Ohio Table 6 input UNION.FUND_BALANCE_OH contains GFOA-covered and hand-collected city-year balance observations selected by Have_CAFR_data and transformed into both fund-balance ratios. The exact compiled table and the non-GFOA report coverage/definitions are not supplied.
- REQ_OHIO_UNION_CONTRACTS [undetermined]: Ohio municipality collective-bargaining contract records used to derive employer, start/end dates, contract duration and treatment timing, with a two-year lag in the Table 6 join.
- REQ_OHIO_CENSUS_ECON [undetermined]: The Table 6 UNION.OHIO_CENSUS_ECON input is transformed to city names, one-year lagged unemployment and median household income, then joined to the fund-balance dataset. The code does not identify the product/vintage or explain the entity-name join mapping.
- SW_SAS [unverified]: The datasheet specifies SAS 9.3 for data cleaning/construction. The pre-existing environment probe records a SAS 9.4 executable path but an initialization failure; it does not establish version compatibility, a license barrier or author-package execution.

## Review notes

- The source-first checkpoint and ordered trace were saved before resource searches. The earlier populated draft, trace and successful output pair are archived byte-for-byte before this scope correction.
- The frozen output title is retained. The datasheet's 'financial reporting choices' wording and the online appendix's 'reported discretionary fund balance ratios' wording are treated as title variation; no identity conflict is supported.
- The supplied identifier XLSX probe read only one row with the imisid field and unverified coverage. It is not an analysis-ready dataset and does not justify an analysis_only scope; the target retains all three supplied SAS programs and their distinct branches.
- The authors report purchasing GFOA and ICMA data and also state that the paper does not use proprietary data. These statements are retained together; current source terms, access and entitlement are unknown, and catalog misses do not establish a barrier.
- Sixteen bounded assigned frozen catalog queries are indexed with selected leaf counts and hashes. Exact aliases were empty; broader matches were unrelated. Missing original argv/cwd/returncode metadata is explicitly left unrecorded rather than reconstructed. Catalog evidence does not prove live availability or license status.
- The author-named SERB page returned 404, two direct Census documentation pages were inaccessible via the web tool, and the Ohio Auditor homepage returned 502. These failures are inconclusive; no public-source access or licensing barrier is inferred. The datasheet's 2020-10-24 collection-completion date is not a current acquisition date.
- All 116 frozen dependency IDs are covered once. GFOA and ICMA source histories, Census and county inputs, all Table 6 inputs, generated intermediates, the documented UNION_11092017 alias setup, and D0100–D0116 inactive comment dependencies are preserved explicitly.
- Table 6 still has distinct FI_0515 versus FI_0415 names, an unproduced NEW7 read after NEW5, and an entity5/entity4 join-key gap. No equivalence or missing producer was invented. MATCH and MATCH3 remain separate unresolved prepared-table handoffs.
- The datasheet reports SAS 9.3 construction and Stata 16 paper-regression use and describes winsorization/outlier handling. Its code-folder description identifies the three named SAS programs; no active Stata operational entry point is supplied. The absent Stata estimation code is a transparent release limitation, not an additional required stage for this supplied variant, and no claim of publication-wide estimation or full-paper results reproduction is made.
- The inherited SAS 9.4 initialization failure and local Stata 18 availability are environment metadata only. SAS 9.3 and Stata 16 remain historical author provenance; Stata 18 is not a runtime prerequisite for this three-SAS target, and SAS runtime remains unverified.
- The structural reader locates a block comment opening at main-source line 752 that remains open at EOF line 848. D0100–D0116 are treated as comment content under this source, while runtime handling of the unmatched comment remains untested; all candidate connection/authentication statements and values stay masked.
- The main source reads unions3.csv into WORK.UNION1 and later unconditionally reads UNION.UNIONS3. No supplied producer maps the CSV import to that prepared table; D0072 and D0081 remain separate as input requirement and unresolved producer handoff.
