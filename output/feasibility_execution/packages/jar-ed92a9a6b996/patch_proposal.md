# Patch proposal: jar-ed92a9a6b996

Voice of the Customers: Local Trust Culture and Consumer Complaints to the CFPB

DOI: 10.1111/1475-679X.12364

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete supplied workflow: preparation in input data.do, Tables 1–6 in JAR_T1 to T6.do, and the independent Tables 7–8 companion JAR_T7&8.do.

Entry points: `input data.do`, `JAR_T1 to T6.do`, `JAR_T7&8.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Independent supplied Tables 7–8 analysis in JAR_T7&8.do using the author-prepared bankfees.dta input.

Entry points: `JAR_T7&8.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12364 - Voice-of-the-Customers-Local-Trust-Culture-and-Consumer-Complaints-to-the-CFPB/hjp-datasheet-code-and-identifiers.zip",
      "sha256": "12d9ff81d8c0d4687eedc949d814669531d4c354e968adbb4f822e46661ddc8c"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12364 - Voice-of-the-Customers-Local-Trust-Culture-and-Consumer-Complaints-to-the-CFPB/hjp-online-appendix.pdf",
      "sha256": "d62c1760be670dc910e706f743fa76a3e63f5afce21f24a9f5c0a92a1b9ea56a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "cf541f0ebb993d9e1ef192b80284e19004b15442e4df8424a4e1cacb21d15e13"
}
```

## Proposed actions

### A001: In a copied working version of JAR_T7&8.do, change line 1 to read the packaged bankfees.dta by a package-root-relative path.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: I002
Evidence: E002, E025

**Proposed edit:** `JAR_T7&8.do:1–1`
Source SHA-256: `c08ab30aaa2f2503a56f10e592cfc200722871315a64cdf8594bdc0f0d152d50`

The code's placeholder path does not match the supplied package layout; bankfees.dta is present at the package root with the fields read by this companion analysis.

Current text:
```
use "...\Data and code for publication\bankfees.dta", clear
```

Proposed replacement:
```
use "bankfees.dta", clear
```

Preparation / proposed procedure:

1. Apply the proposed edit only in an isolated writable copy of the package; keep the frozen source and data files unchanged.
2. Launch the companion from that copy's package-root working directory, where the relative bankfees.dta path resolves.

Validation to perform later:

- Confirm that bankfees.dta in the working copy is the supplied prepared file and retains all 11 fields used by JAR_T7&8.do.
- After separately authorizing execution, run stata -b do "JAR_T7&8.do" from the isolated package-root working directory and review the batch log; no run is made in this assessment.

### A002: Clarify whether the existing institutional NORC contract provides an already-authorized route to the exact GSS2010 and GSSpanel inputs consumed by the supplied branches, and identify their authorized local location and field/period coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R015, R016, I001
Evidence: E001, E004, E005, E006, E034

Preparation / proposed procedure:

1. Use only an existing authorized institutional route and custodian; do not contact NORC, check eligibility, submit forms, or request a new contract as part of this assessment.
2. If already available, provide the authorized file location and verify that GSS2010 and GSSpanel remain separate inputs with the fields and periods required by the cited branches.

Validation to perform later:

- Use a bounded metadata check to confirm required variables and identifiers for each authorized file without loading or executing author code.
- Keep the full pipeline unresolved if no existing authorized route is confirmed.

### A003: Clarify the source, version, coverage, and approved local delivery route for the raw CFPB complaint file, state bank-share file, and city bank-share file consumed by input data.do; these are three distinct products.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R017, R018, R019
Evidence: E007, E034, E035

Preparation / proposed procedure:

1. Identify the exact input file for each requirement and provide its authorized path, record unit, required fields, geography, and year coverage.
2. For the complaint input, resolve the source and construction of the WF field required downstream before deciding how the preparation output should be formed.
3. For each bank-share input, confirm its distinct expected schema and the supplied code's filters and aggregation contract; do not substitute one product for another.

Validation to perform later:

- After the exact files are authorized and available, use bounded metadata probes to compare source columns and period against the code contracts; preserve unverified coverage if only samples are checked.

### A004: Resolve the distinct raw metro-year banked source and census2010_city_ms geography input, and specify separate input/output locations for every preparation branch that reuses the banked_metro basename.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R020, R021, I006
Evidence: E008, E009, E014, E024, E034, E035

Preparation / proposed procedure:

1. Provide the authorized raw metro_number/year/banked input and the matching city geography table with cbsa10, state/placea mapping, population, and percapitainc fields.
2. Document which branch reads each raw file and where its normalized output is written; keep raw banked_metro separate from the packaged normalized city-year banked_metro.dta.
3. Specify the reset or branch-specific working-directory contract for repeated preparation reads so a normalized save cannot replace a raw source needed by a later block.

Validation to perform later:

- With authorized inputs, use bounded probes to compare the raw and normalized schemas and verify each branch's intended read and output locations before running preparation code.

### A005: Identify separate authorized sources and versions for bank_share_st_update.dta and bank_assets_2011.dta, including the source columns used by the preparation branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R022, R023
Evidence: E010, E034, E035

Preparation / proposed procedure:

1. Provide the exact source locations, field names, record units, and coverage for the state bank-share update and bank asset input.
2. Keep the two inputs distinct and do not infer either from the packaged bank_st or bank_city analysis tables.

Validation to perform later:

- After authorized availability is established, compare bounded metadata with the authored source-column contracts before preparing bank_data_st or noncomplaints_city.

### A006: Identify the distinct authorized sources for statetrust10.dta, citytrust10.dta, and citytrust2010.dta and preserve their separate contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R024, R025, R028
Evidence: E034, E035

Preparation / proposed procedure:

1. For each file, provide the authorized path, native trust variable, geographic identifiers, and period expected by the corresponding source block.
2. Confirm whether the state and two city trust inputs are separate author-prepared products; do not treat one same-purpose-looking basename as a substitute for another.

Validation to perform later:

- After authorized availability is confirmed, compare bounded metadata for each file with the distinct state or city merge keys and trust fields used by input data.do.

### A007: Resolve the separate Table 6 column 5 city bank-share source and prejoined complaint-city-trust input, including the missing provenance for the latter.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R026, R027
Evidence: E013, E034, E035

Preparation / proposed procedure:

1. Provide the exact authorized bank_share_city.dta source and confirm its fields, geography, record unit, and coverage, distinct from bank_share_city_07302018.dta.
2. Provide the exact authorized Complaints_city_trust2010.dta input or its supplied producer, and document how its complaint and trust columns were formed; do not infer that input from complaints_city.dta or citytrust10.dta.

Validation to perform later:

- Use bounded metadata and source review to verify each input against the fields and merge keys actually read by the column 5 branch before any execution.

### A008: Clarify the intended source or producer for banked2011.dta consumed by Table 3 Panel A; the earlier banked tempfile is not evidence that this distinct name exists.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I003
Evidence: E015, E016, E034, E035

Preparation / proposed procedure:

1. Provide banked2011.dta or identify the exact authored producer and its output directory, fields, and year coverage.
2. Do not rename the earlier tempfile or equate it to banked2011 without an author-supported handoff.

Validation to perform later:

- Once the source contract is established, confirm that its fields and 2011 observation coverage satisfy the Table 3 Panel A read.

### A009: Resolve the missing producer and exact schema for bank_data_city.dta read by the Table 6 city preparation block.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I005
Evidence: E012, E034, E035

Preparation / proposed procedure:

1. Identify the authored producer or provide the authorized bank_data_city input with its actual source columns, geography, record unit, and coverage.
2. Keep bank_data_city separate from the packaged final bank_city.dta; the final analysis panel does not establish the missing preparation input.

Validation to perform later:

- Trace the confirmed producer output to the exact input data.do read and verify its merge and grouping fields with bounded metadata before execution.

### A010: Resolve how the Table 4 WF flag is supplied to the full-preparation branch before treating its complaints.dta output as the Table 4 input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I007
Evidence: E007, E029, E035, E038

Preparation / proposed procedure:

1. Confirm the authorized raw complaint source and exact WF field definition or the intended producer for that field.
2. Only after its source and definition are established, prepare a working-copy change that preserves WF through the complaints output or uses the documented producer; do not guess a new classification.
3. Keep the packaged direct-analysis complaints.dta with WF intact and separate from any regenerated preparation output.

Validation to perform later:

- After the documented preparation route is resolved, verify that the output consumed by Table 4 contains WF and the expected complaint fields before running that branch.

### A011: Resolve whether the Table 3 Panel B percapitainc reference is intended to map to a distinct source column or to the packaged census_st percapinc field before making any code or data change.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R013, I008
Evidence: E018, E028, E035

Preparation / proposed procedure:

1. Confirm the authored source-column mapping and expected units/period for Table 3 Panel B, or provide the intended compatible census_st input.
2. Do not rename percapinc to percapitainc or define a new measure without that confirmation.

Validation to perform later:

- After the mapping is confirmed, compare the actual input fields and values' stated units with both the Table 3 Panel B read and Table 4's percapinc use.

### A012: When the complete compatible inputs are available, validate merge keys and required history while preserving each authored merge statement, _merge handling, PR override, sample filter, one-year complaint lead, and forward-fill operation.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I009
Evidence: E017, E018, E025, E028, E035

Preparation / proposed procedure:

1. Before execution, inspect duplicate counts on the actual authored merge keys and confirm the record units and date/year fields of each participating input.
2. Check the coverage needed by each supplied branch, including the complaint-year shift and the years added/filled around tsfill; do not infer a 1:1 merge or extend the authors' analysis sample.
3. Record the results and retain the original merge cardinality syntax and all authored filters and branch-specific sample rules.

Validation to perform later:

- Only after compatible full inputs are available, validate the key counts, period bounds, and post-merge _merge/sample counts against the supplied source without invoking estimators during this audit.

### A013: Set up isolated writable working copies and a documented branch-specific current-directory plan for the bare-basename Stata programs; retain raw and prepared files separately and do not launch the monolithic preparation chain until its repeated-input reset contract is resolved.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I004
Evidence: E007, E008, E009, E014, E035, E037

Preparation / proposed procedure:

1. Copy the supplied sources and any authorized inputs into isolated working directories; preserve the frozen package files and keep the original package read-only.
2. Because the scripts use bare basenames, document the current directory for each preparation branch and analysis entry point, including where each output will be written.
3. Keep raw banked_metro in a separate location from the normalized city-year banked_metro output and do not execute the full preparation chain in one shared directory until the source-supported reset or branch-specific input contract is known.
4. After all required source and handoff contracts are resolved, produce and validate the intended preparation outputs before running JAR_T1 to T6.do with its compatible inputs; run JAR_T7&8.do independently from the package-root working copy described in A001.
5. Preserve Stata's observed varabbrev on setting so the post-rename company prefix can resolve to companycpb; do not add a second company field or change the authored grouping.

Validation to perform later:

- Before any authorized run, verify that every bare input resolves in the documented branch directory, every write lands in that branch's working copy, and the package's frozen inputs remain unchanged.
- Keep the full workflow unresolved until the repeated raw/prepared banked_metro reads, required producers, and branch output paths are all accounted for.

### A014: Make the author-required carryforward and cluster2 commands available from an approved Stata adopath before attempting Table 3 Panel B, then verify the exact command entry points.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S002, S003
Evidence: E017, E036

Preparation / proposed procedure:

1. Obtain or identify only an author-compatible, institution-approved copy of carryforward and cluster2 and configure its location on the Stata adopath; no package is installed during this assessment.
2. Preserve the authored carry-forward call and cluster2 specification.

Validation to perform later:

- From the intended Stata environment, run which carryforward and which cluster2 and confirm each resolves to the approved ado file before any authorized analysis run.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The full supplied Tables 3 and 4 workflow consumes confidential GSS2010 and GSSpanel data. The package inventory lists only GSSstate.dta, which the README describes as a state list, so the necessary prepared GSS analysis inputs are absent from this package and require an authorized compatible route or clarification.
- I002 [preparation; full_pipeline, analysis_only]: JAR_T7&8.do line 1 contains a placeholder path through Data and code for publication, while the actual packaged bankfees.dta is at the package root. Use a relative bankfees.dta path from an isolated working copy of that root.
- I003 [unresolved; full_pipeline]: Table 3 Panel A reads banked2011 at JAR_T1 to T6.do line 74. The earlier Table 2 block creates a tempfile named banked, not a file or alias named banked2011; no supplied producer or package file closes this handoff.
- I004 [preparation; full_pipeline]: All supplied programs use bare basenames without a cd command. input data.do writes with save ..., replace into the launch-time current directory, including names that are also packaged inputs. Run only in an isolated writable working copy and configure a coherent current directory per branch; do not overwrite the frozen package data.
- I005 [unresolved; full_pipeline]: The supplied Table 6 city preparation merges bank_data_city at input data.do line 247, but no producer for that intermediate appears in the supplied preparation program and no bank_data_city file appears in the frozen package inventory. It is not the same as the packaged final bank_city.dta.
- I006 [unresolved; full_pipeline]: input data.do repeatedly uses banked_metro as a raw metro_number/year/banked source, then saves the normalized state/placea/year/avg_banked result back under banked_metro. In a shared current directory this replaces the raw source before later blocks reopen it. The packaged same-name file matches only the normalized output schema; preserve separate raw and prepared locations and obtain the intended reset/branch contract.
- I007 [unresolved; full_pipeline]: input data.do creates complaints.dta from Consumer_complaints_all but its keep list omits WF. The Table 4 state branch in JAR_T1 to T6.do reads WF from complaints.dta, while the packaged direct-analysis complaints table contains WF. Keep the prepared package table separate and clarify how the prep branch is meant to supply WF before treating its output as the Table 4 input.
- I008 [unresolved; full_pipeline]: The packaged census_st.dta exposes percapinc, which matches Table 4, but Table 3 Panel B reads percapitainc after merging that table. No rename or derived variable bridges the names. Confirm the intended source-column mapping before editing or running that branch.
- I009 [unresolved; full_pipeline]: The supplied merge statements retain legacy key syntax and branch-specific _merge/drop/PR overrides, but one-row metadata cannot establish key uniqueness or full periods. Preserve each authored key, filter and sample rule; do not infer 1:1 cardinality or extend date ranges. Validate key counts and required date coverage only when the complete input data are available.
- R013 [undetermined]: Prepared state-year census income input used by Tables 3 and 4.
- R015 [undetermined]: Confidential state-level GSS 2010 data consumed by Table 3 Panel A; the supplied GSSstate file is only a state list.
- R016 [undetermined]: Confidential state-year GSS panel consumed by Table 3 Panel B and Table 4 Panel A.
- R017 [undetermined]: Raw CFPB complaint file read by the supplied input data.do preparation block to create complaints.dta; the code expects date_received/state/company_response_to_consumer/product/sub_product/company/zip_code/complaint_id/gvkey.
- R018 [undetermined]: Bank-share state-year source read by input data.do to create shock_st.dta; the code expects level/rssdid/year/stalpbr.
- R019 [undetermined]: Bank-share city-year source used to create shock_city and the noncomplaint city branch; the code expects level/rssdid/year/state/placea/td_city/hhi_share/companycpb/nbranch.
- R020 [undetermined]: Raw metro-year banked-population source needed by the input data.do branches that join metro_number to census2010_city_ms; this is a distinct contract from the packaged normalized city-year banked_metro table.
- R021 [undetermined]: City geography/demographic lookup census2010_city_ms.dta used to map cbsa10 into state/placea and to supply pop/percapitainc; it is not in the frozen package inventory.
- R022 [undetermined]: Bank-state share update input used to construct bank_data_st.dta; the code expects level/td_st/nbranch/hhi_share/companycpb/stalpbr.
- R023 [undetermined]: Bank asset input bank_assets_2011.dta read in the noncomplaint city branch and Table 6 column 5 branch; code uses rssdid/assets.
- R024 [undetermined]: State-level trust input statetrust10.dta used by input data.do before creating the prepared bank_st panel; code uses state and retains wtrust1.
- R025 [undetermined]: City-level trust input citytrust10.dta used to construct bank_city and trust_st; code uses state/placea/wtrust1.
- R026 [undetermined]: Separate bank-share city input bank_share_city.dta used in the supplied Table 6 column 5 branch; the code expects level/companycpb/state/placea/td_city/nbranch/hhi_share. It is not the distinct bank_share_city_07302018.dta input.
- R027 [undetermined]: Prejoined complaint-city-trust input Complaints_city_trust2010.dta used in the supplied Table 6 column 5 branch; code reads date_received/company_response_to_consumer/consumer_disputed_/company/state/placea/wtrust1. No producer is supplied in this package.
- R028 [undetermined]: Separate city trust input citytrust2010.dta used in the noncomplaint city branch; code merges on state/placea and reads wtrust1. It is distinct from citytrust10.dta.
- S002 [preparation_required]: The exact carryforward command is used in Table 3 Panel B and was not found with Stata 18 on either the default or checked shared adopath (which return code 111). Make an approved version available on the execution adopath, then verify it with which carryforward; do not change the authored carry-forward operation.
- S003 [preparation_required]: The exact cluster2 command is used in Table 3 Panel B and was not found with Stata 18 on either the default or checked shared adopath (which return code 111). Make an approved version available on the execution adopath, then verify it with which cluster2; preserve the authored clustering specification.

## Review notes

- No author program, study dataset, or estimator was executed. Software checks were limited to Stata version/which/query metadata; packaged-data inspections used the assigned bounded one-row probes.
- The independent analysis-only scope is supported by the supplied JAR_T7&8.do and packaged bankfees.dta, whose bounded probe contains all 11 consumed fields; the README describes 2002–2006 and 2011–2015 coverage, while the one-row probe does not establish complete historical coverage. No analysis was run.
- The full pipeline remains unresolved because the prepared GSS2010/GSSpanel inputs and multiple raw preparation contracts or producers are absent or unverified. No NORC contact, eligibility check, form, contract request, or data acquisition was made.
- Authored merge keys, merge syntax, filters, sample overrides, the one-year complaint lead, tsfill, and banked carry-forward are retained as written. No 1:1 cardinality, broader period, or new variable definition is inferred.
- Stata 18 reports varabbrev on, making company a valid unique prefix of companycpb after the supplied rename in the observed source state; no company-field repair is proposed. The earlier incomplete varabbrev query and its corrected metadata check are both preserved in probes.
- The normalized packaged banked_metro.dta is a supported direct-analysis input, but it does not satisfy the raw metro_number/year/banked contract; raw and normalized locations and repeated branch resets remain unresolved.
