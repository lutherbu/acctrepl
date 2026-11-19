# Patch proposal: jar-ed5573cde74b

The Real Effects of FAS 166/167 on Banks' Mortgage Approval and Sale Decisions

DOI: 10.1111/1475-679X.12204

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete author-documented SAS preparation and downstream Stata analysis workflow, including primary tests and appendix branches.

Entry points: `DRX_step1_create_Y9C_vars.sas`, `DRX_step2_get_bankid_from_call_report.sas`, `DRX_step3_get_hmda_data.sas`, `winsorization.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 3/12204 - The-Real-Effects-of-FAS-166-167-on-Banks-Mortgage-Approval-and-Sale-Decisions/drx-datasheet-and-code.zip",
      "sha256": "08f6f224a1aca2327c7f96a1d6fda7916d809eaf6bda4f794e284ab7273d6d13"
    },
    {
      "path": "JAR-Volume 56/Issue 3/12204 - The-Real-Effects-of-FAS-166-167-on-Banks-Mortgage-Approval-and-Sale-Decisions/drx-online-appendix.pdf",
      "sha256": "14eb9d506dc262660340225c4620f2b1d4d2d4332b561da309e3c37d41db7bf9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "ae4cb61956e1cbd57962f04109c9d6b2f913427a6c6441d12c17b1285d316e48"
}
```

## Proposed actions

### ACT001: Provide sec.k1 or its complete extraction program and confirm the annual FR Y-9C fields and history. Reconcile 2003Q4–2014Q4, lags for 2005–2014 and the described 1995–2004 provision benchmark; do not assume an unlisted minimum.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R001, ISS005
Evidence: E006, E009, E010, E013, E050

Preparation / proposed procedure:

1. Supply sec.k1 or its upstream extraction code with schema, identifiers and year conventions.
2. Confirm whether k1 includes 1995–2004 and exactly how the normal-provision mean is restricted and missing banks receive the median.
3. If using public FR Y-9C files, apply only the author-confirmed annual extraction and item mapping.

Validation to perform later:

- Check confirmed history contains every required lag and benchmark period.
- Check the generated sec.data_y9c schema and year-by-year bank counts against author instructions.

### ACT002: Obtain the author hand-collected VIE and OTTI tables or their complete source/variable contracts before constructing them. Local LM10X folders are text discovery candidates, not the prepared tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R002, R003
Evidence: E005, E011, E046

Preparation / proposed procedure:

1. Obtain 2010 VIE values keyed to the same bank identifier/year as sec.k1, including missing-value and public/private bank treatments.
2. Obtain 2008–2009 OTTI values keyed by bank identifier/year, including missing-value treatments.
3. If prepared values are absent, confirm the issuer, filing, section and coding rules before any filing-based work; do not independently reconstruct variables.

Validation to perform later:

- Confirm fields and keys match the Y9C joins.
- Check inputs cover the author-specified banks and years.

### ACT003: Verify institutional CRSP access and obtain the CPI series/table used by the authors. The official product includes CPI files, but annual aggregation and the 2006-base conversion must match the author table.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R004
Evidence: E004, E012, E048, E053

Preparation / proposed procedure:

1. Check institutional CRSP entitlement without inferring a missing license from the catalog search.
2. Obtain the CPI data for required years and confirm annual frequency and the 2006-dollar conversion calculation.
3. Alternatively provide prepared sec.cpi_annual with yr and cpi_annual_convertto_06.

Validation to perform later:

- Compare annual values and conversion factors with an author-prepared table or written specification.

### ACT004: Acquire or provide the 2005–2014 Call Report files used to create the identifier crosswalk, then map their actual fields to the author program's expected RSSD columns. CDR TDF/XBRL is not the XPT format imported by the macro.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R005
Evidence: E015, E016, E020, E051

Preparation / proposed procedure:

1. Obtain author-used XPT files or verify an authorized official CDR format for each required year.
2. Confirm all expected RSSD fields and the year-specific schemas before selecting a conversion route.
3. Keep imported Call Report data and _keep crosswalk outputs in the same configured SAS library.

Validation to perform later:

- Check a bounded header/sample from each year for required identifiers and year fields.
- Confirm the Step 3 agency/respondent joins produce the expected parent RSSDHH values.

### ACT005: Acquire HMDA LAR files for 2005–2014 from the verified National Archives series and prepare the year-specific fixed-width inputs expected by the SAS macros.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R006
Evidence: E018, E019, E049

Preparation / proposed procedure:

1. Download LAR records for 2005–2014 from National Archives Identifier 2456161 and record whether Final or Ultimate files are used.
2. Prepare one file for each 2005–2009 year and p1/p2/p3 partitions for 2010–2014, preserving the fields and order in the supplied input statements.
3. Place the prepared files in the configured HMDA directory.

Validation to perform later:

- Run bounded readability checks for each layout and verify required fields, codes and years.
- Compare parsed year, respondent, agency, geography and outcome fields with the supplied input statements.

### ACT006: Provide the author conforming-limit workbook or confirm a public source and mapping that reproduces all 2005–2014 county-year GSE sheets and FIPS fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R007
Evidence: E024, E025, E052

Preparation / proposed procedure:

1. Locate the author workbook or confirm FHFA county-year products and definitions for every year 2005–2014.
2. Prepare County_Name, FIPS_County_Code, FIPS_State_Code, State, limit and yr in the schema expected by the import and merge.
3. Keep workbook and SAS library paths consistent.

Validation to perform later:

- Check county/state FIPS keys and limits for each year before the conforming_loan join.
- Verify limit units match amount and the code's limit/1000 comparison.

### ACT007: Supply the missing producers and source specifications for per_capita_income, unemploy_rate and hlr, including geographic keys, units, coverage and merge order.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R008, R009, ISS004
Evidence: E029, E030, E047

Preparation / proposed procedure:

1. Identify the input source or upstream table that creates each field and its year/geographic level.
2. Provide transformations and county/MSA crosswalks used to join measures to HMDA records.
3. Confirm whether hlr comes from sec.k1 or a missing bank-data step.

Validation to perform later:

- Check each field exists before the LARS_h2 and ss4 consumers and has required year/geography coverage.
- Compare merged values with author-prepared examples.

### ACT008: Clarify what s1424 represents and supply its producer or confirm the intended input before Y9C lag calculations are prepared.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R011, ISS002
Evidence: E008, E047

Preparation / proposed procedure:

1. Provide the upstream program or dataset producing s1424, including keys, fields, period and directory.
2. If s1424 is a typo, confirm the intended dataset and update its producer and consumer names consistently.

Validation to perform later:

- Confirm the author-confirmed input contains the fields needed to generate lta and lt1rcapr for required years.

### ACT009: Clarify whether LARS_U&year._rssdhh2 is an omitted upstream dataset or an unintended self-read; supply the complete producer/schema if it is required.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS003
Evidence: E023, E025, E047

Preparation / proposed procedure:

1. Compare this release with the complete author script and obtain the missing source step or confirmed intended input.
2. Keep the author-confirmed table name consistent across create, conforming-limit and sampling steps; do not guess an alias.

Validation to perform later:

- Confirm each year 2005–2014 has a produced dataset with fields required by conforming-limit joins and SRS construction.

### ACT010: Resolve SAS startup availability and verify the installed SAS 9.4 runtime. The bounded empty-session probe failed at TKELS initialization; this does not establish a license problem.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW001
Evidence: E001, E045

Preparation / proposed procedure:

1. Diagnose the TKELS launch-service initialization failure without assuming or changing licensing.
2. Once SAS starts, verify its release, native XLSX import support, XPORT input support, and ability to export the required Stata DTA format on the current platform; do not infer an incompatibility from an unspecified author release.

Validation to perform later:

- Run an empty-session SAS startup/version check before using author code or data.

### ACT011: Obtain the Stata estimation programs or complete author analysis recipe for primary and appendix branches before attempting the full workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS001
Evidence: E001, E039, E040, E041, E042

Preparation / proposed procedure:

1. Request Stata scripts or exact estimation instructions, including input/output paths, required variables, model equations, samples and all appendix tests.
2. Confirm whether and how the packaged 973-bank identifier list filters the analysis sample.
3. Do not treat the ID workbook as the missing loan-level analysis data or analysis code.

Validation to perform later:

- Map all primary and appendix results to supplied analysis entry points and confirm each consumes the generated final loan-level dataset.

### ACT012: Create a consistent directory configuration for the three SAS preparation scripts and their cross-language output.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS007
Evidence: E015, E018, E019, E024, E025, E033, E034

Preparation / proposed procedure:

1. Select one root for the sec library, Call Report files, HMDA layouts, conforming-limit workbook and final DTA; map every C:, E:, F: and M: path across all affected producers and consumers.
2. Run Steps 1 and 2 before Step 3; they produce the Y9C and RSSD linkage inputs consumed by Step 3.

Validation to perform later:

- Check every configured read and write path and verify generated tables are in the library later consumers use.
- Verify the final DTA export path matches the future Stata analysis input.

### ACT013: Correct the final rename source alias to match the variable created and merged earlier in Step 3.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS006
Evidence: E032, E034, E047

**Proposed edit:** `DRX_step3_get_hmda_data.sas:982–982`
Source SHA-256: `4052b3d6123ffb716d4f3490a8a55e9404338e524ff707e3715c8be650cb06d6`

The upstream producer, winsor call and final join use secuob_r_win99positive_allyrs; the final rename omits positive.

Current text:
```
	secuob_r_win99posit_allyrs=OffBS_Securitization 
```

Proposed replacement:
```
	secuob_r_win99positive_allyrs=OffBS_Securitization 
```

Preparation / proposed procedure:

1. Apply the one-line alias correction in the author source after approval.

Validation to perform later:

- Inspect the resulting SAS dataset schema to confirm OffBS_Securitization maps from secuob_r_win99positive_allyrs.
- After analysis code is supplied, confirm intended Stata models consume OffBS_Securitization.

### ACT014: Load the supplied wins and wins_bynone macro definitions before the stages that call them, excluding the explicitly labeled b1 examples.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS008
Evidence: E032, E035, E036, E037, E038

Preparation / proposed procedure:

1. In the future SAS driver, load the macro definitions from winsorization.sas before Step 1 and Step 3.
2. Use only definition sections (lines 4–39 and 52–104); do not execute the example calls on b1 at lines 41–43 and 106–107.

Validation to perform later:

- Confirm wins and wins_bynone resolve when called by Step 1 and Step 3 without running the b1 examples.


## Remaining issues and prerequisites

- ISS001 [blocking; full_pipeline]: The data sheet states Stata was used and the appendix describes primary and companion tests, but the package inventory contains no Stata analysis program or final analysis dataset. Full-pipeline analyses cannot be run from this release; the bank-ID list is not an analysis dataset.
- ISS002 [unresolved; full_pipeline]: Step 1 reads and rewrites s1424 to form lta and lt1rcapr, but no earlier producer for s1424 appears in the supplied sources. Its intended role and schema are unknown.
- ISS003 [unresolved; full_pipeline]: The create macros write LARS_U&year._rssdhh, then read LARS_U&year._rssdhh2 from itself; later conforming-limit code requires _rssdhh2. No producer for that table is supplied, so clarify whether an upstream input or omitted step is required.
- ISS004 [unresolved; full_pipeline]: The final LAR keep list requests per_capita_income and unemploy_rate, while the bank table retains hlr; no source/merge or construction for these fields appears in supplied source texts. Their geographic, unit and period contracts are unknown.
- ISS005 [unresolved; full_pipeline]: The Y9C comment describes a 1995–2004 provision benchmark, while the Step 1 input comment states 2003Q4–2014Q4 and code computes means from available k4 rows without a visible 1995–2004 filter. Confirm the intended benchmark window and complete history; do not infer a start year from estimation dates.
- ISS006 [preparation; full_pipeline]: The final rename source alias is truncated relative to the produced and joined secuob_r_win99positive_allyrs variable; the supported one-line correction is linked in ACT013.
- ISS007 [preparation; full_pipeline]: Preparation files use F:, E:, C: and M: paths for libraries, raw files, the limits workbook and export. No author directory-to-workspace mapping is supplied. Producers and consumers need shared paths, and Step 1 plus Step 2 outputs must exist before Step 3.
- ISS008 [preparation; full_pipeline]: Step 1 and Step 3 call the winsorization macros without an explicit include. The supplied file defines them; its b1 lines are explicitly labeled examples and should be excluded from the production macro load.
- R001 [undetermined]: Author-prepared annual FR Y-9C input sec.k1 (source comment: 2003Q4–2014Q4), with reported items used in bank-variable construction; verify required annual rows and benchmark history.
- R002 [undetermined]: Hand-collected 2010 year-end consolidated VIE values keyed to the bank identifier/year and compatible with vie_all_million in sec.hand_collected_vie_2010.
- R003 [undetermined]: Hand-collected other-than-temporary-impairment values for 2008–2009, keyed by bank identifier/year as otti_ni in sec.otti_20082013.
- R004 [undetermined]: Annual CPI conversion factors by year in sec.cpi_annual, including cpi_annual_convertto_06 used to express bank assets in 2006 dollars.
- R005 [undetermined]: Call Report identifier and parent-BHC crosswalk inputs for 2005–2014 joins, including RSSD9001, RSSD9050, RSSD9055, RSSD9348, RSSD9364, RSSD9365, RCON9999 and RSSDHH.
- R006 [public_acquisition_required]: HMDA Loan Application Register data for 2005–2014 in the year-specific fixed-width layouts consumed by the supplied SAS macros.
- R007 [undetermined]: County-year conforming loan limits for 2005–2014 matching GSE_yyyy sheets and the FIPS county/state join.
- R008 [undetermined]: Producer/source for per_capita_income retained in the final loan-level dataset, including geographic key, units and 2005–2014 coverage.
- R009 [undetermined]: Producer/source for unemploy_rate retained in the final loan-level dataset, including geographic key, units and 2005–2014 coverage.
- R011 [undetermined]: The SAS input/intermediate s1424 read during Y9C lag construction; its producer, role, expected schema and history are not supplied.
- SW001 [unverified]: Author code requires SAS; the installed SAS 9.4 command's existing empty-session startup probe failed at TKELS initialization. Current runtime availability is unverified; no license conclusion is drawn.

## Review notes

- Assessment covers the four supplied SAS source files and the author data sheet. The release contains substantive preparation code but no Stata analysis program or final analysis dataset.
- No analysis_only scope is supported: the sample-bank XLSX is an identifier list, while the final loan-level analysis dataset is produced only by SAS code and is not packaged.
- All 55 frozen dependency IDs are reviewed. Additional raw XPT, HMDA fixed-width and table-schema contracts are derived from code; missing producers remain explicit.
- Official-source routes are credited only at supported product level. Catalog misses and unknown route availability are not evidence of no access or no license.
- SAS availability remains unverified after the existing bounded empty-session TKELS startup failure; author code, regressions and datasets were not executed.
