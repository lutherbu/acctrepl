# Patch proposal: jar-2b265016c6ae

Disclosure Regulation in the Commercial Banking Industry: Lessons from the National Banking Era

DOI: 10.1111/1475-679X.12193

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied main Stata workflow: sample preparation, merges, published Tables 2–11 and Figure 4. The online appendix also reports IA1, IA2, IA4 and IA5 results, but no code for those supplementary analyses is supplied; see unresolved issue I003.

Entry points: `Granja Disclosure.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12193 - Disclosure-Regulation-in-the-Commercial-Banking-Industry-Lessons-from-the-National-Banking-Era/granja-datasheet-and-code.zip",
      "sha256": "16c797249f4255ac2a28bf5f3a28d47c3a58aed4fc55d59c9ab675e58b90fc92"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12193 - Disclosure-Regulation-in-the-Commercial-Banking-Industry-Lessons-from-the-National-Banking-Era/granja-onlineappendix.pdf",
      "sha256": "1ad6cbbd5efa76553447212133954d08956c43c891630237c0a2b113f9496847"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "9f6848f3979fb2f48a3b9cfd3d746c6a4066fe602c33ddeeac0ba144a420aa9c"
}
```

## Proposed actions

### A001: Point B.2 to its county-level and referenda inputs in their producer directory, preserving the separate state-level Gini.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I001
Evidence: E003, E059, E060, E061, E062, E064, E065, E066

**Proposed edit:** `Granja Disclosure.do:1750–1760`
Source SHA-256: `430f96d395cfa7132667b9a98d190eca7702d1c0b604c54ff1e4a1f3c670e80c`

A.17/A.18/A.19 save the county Gini and referenda inputs relative to Source Data. B.1 changes the current directory to cleaned files before B.2, where the old unqualified gini resolves the distinct state-level cleaned files/gini and the other three names do not resolve to their producers. Explicit paths load the county file without overwriting the state Gini; sample_ref remains saved in cleaned files.

Current text:
```
use gini, clear 
merge 1:1 county state using electionres
drop if _merge==2
drop _merge

merge 1:1 county state using pres_res
drop if _merge==2
drop _merge

merge 1:1 county state using bankspercounty
drop _merge
```

Proposed replacement:
```
use "$dropbox/Source Data/gini", clear 
merge 1:1 county state using "$dropbox/Source Data/electionres"
drop if _merge==2
drop _merge

merge 1:1 county state using "$dropbox/Source Data/pres_res"
drop if _merge==2
drop _merge

merge 1:1 county state using "$dropbox/Source Data/bankspercounty"
drop _merge
```

Preparation / proposed procedure:

1. Set global dropbox to the delivered project root that contains the author Source Data and cleaned files folders.
2. Apply the anchored B.2 path edit so it loads county-level gini, electionres, pres_res and final bankspercounty from Source Data, while preserving cleaned files/gini as the separate state-level output.
3. Keep sample_ref in cleaned files, where B.2 already runs and the later analysis expects its generated intermediate.

Validation to perform later:

- Before any authorized rerun, confirm the state-level Gini remains at cleaned files/gini and the county-level Gini remains at Source Data/gini with county/state keys.
- Confirm electionres, pres_res and the final appended bankspercounty are present in Source Data and that B.2 reads those exact producer outputs.
- After all inputs and software are available, inspect sample_ref geography and merge results before interpreting the referenda estimates.

### A002: Request the missing year, state, bank-type and geography reference files with an input manifest.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R001, R002, R003, R004, R023, R024, I002
Evidence: E018, E024, E042, E043, E054, E065, E067, E068

Preparation / proposed procedure:

1. Request base.dta, stabr.dta, banktypes.dta, states.dta, state codes.dta and US_FIPS_Codes.dta, plus each file’s source, version, variable definitions and expected key uniqueness.
2. Confirm the exact fields needed by the code: base year; state/stabr mapping; banktypes c1; states stabr/cont; and the state/FIPS crosswalk fields.
3. Place state codes.dta and US_FIPS_Codes.dta in the author’s cleaned files folder used by the B.3/B.4 relative reads, or obtain author confirmation and make the corresponding paths explicit; keep the other files at the source paths recorded in their requirements.

Validation to perform later:

- Use Stata describe on each delivered file and compare its keys to the merge/cross statements in sections A.0/A.6/B.3/B.4.
- Confirm the author input manifest accounts for each direct read, that state codes and US_FIPS_Codes resolve from cleaned files at B.3/B.4, and that the county FIPS/state keys are compatible.

### A003: Obtain the three author-prepared annual bank-count matrices and their periods.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R005
Evidence: E005, E019, E054

Preparation / proposed procedure:

1. Request number_of_banks, number_of_banks_pri and number_of_banks_nat with the source page, count definition, bank-type coverage and date range.
2. Confirm c1 is the year and that the state columns span the values used by the rename/reshape statement.

Validation to perform later:

- After receipt, inspect the fields and year range, then verify the reshaped state/type/year keys before merging with baseline.
- Check that the count series’ handoff to Grossman is consistent with the separately clarified 1909 boundary.

### A004: Obtain the exact author treatment dates and reporting/examination status matrices.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R006
Evidence: E005, E006, E024, E025, E044

Preparation / proposed procedure:

1. Request reportdate.dta and stfinstat.dta, natfinstat.dta, stexam.dta and natexam.dta, with the source year/date, code definitions and state/bank-type identifiers.
2. Ask the author to specify the year range and whether the status matrices are raw inputs or outputs of an unprovided preparation step.

Validation to perform later:

- Describe each file and verify reportdate stabr/report/examination fields and the matrix year/state columns.
- Confirm the available history supports the code’s five annual leads and lags and the survival setup origin at 1876; do not infer missing boundary years from Table 3’s year filter.

### A005: Request the Haines census files or an exact ICPSR 2896 part-to-field mapping.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R007
Evidence: E006, E022, E023, E034, P001, P002

Preparation / proposed procedure:

1. Request the author-prepared 1870.dta through 1920.dta files and census1890.dta, or the exact ICPSR 2896 part/file/version and transformation notes that reproduce their used fields.
2. Identify the year-specific farm-bin, manufacturing, total/urban/black population, county/state/name and area fields expected by the formulas in sections A.4, A.5 and A.18.
3. Preserve the author’s specified census-year inputs and geography; do not retabulate historical sources independently while the author mapping remains unknown.

Validation to perform later:

- Verify each delivered file’s year and geography level and inspect the year-specific expected columns before the A.4/A.5/A.18 transformations.
- Confirm the decennial coverage by state/county and the interpolation input boundaries before relying on annual outputs.

### A006: Obtain the author’s state population and urban-population extracts or their exact NHGIS selections.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R008
Evidence: E006, E020, E021, P006

Preparation / proposed procedure:

1. Request Population.xlsx and Urbanpop.xlsx as used by the author, including the original NHGIS extract/table IDs, selected years and header mapping.
2. If a replacement NHGIS extract is proposed, first confirm that it supplies the code’s imported State, Year, TotalPoulation and urbpop fields, including the author’s state/territory handling.

Validation to perform later:

- Inspect the workbook sheet names and headers and verify state/year coverage for all decennial inputs used by the code.
- Confirm the input series can support the author’s spline interpolation and territory adjustments before running A.2/A.3.

### A007: Obtain the author’s Flood balance-sheet input or a verified file-to-field mapping for ICPSR 2393.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R009
Evidence: E007, E026, P003, P004

Preparation / proposed procedure:

1. Request aggbsdata.dta with the source version, field definitions, units and year coverage.
2. If the ICPSR 2393 product is used instead, confirm the exact source fields corresponding to st/year and each a_/n_ balance-sheet variable before applying the code’s state = all-bank minus national transformation.

Validation to perform later:

- Describe the delivered source and verify state/year identifiers, units and every balance-sheet field used in the A.8 reshape.
- Confirm the source covers every year represented by baseline for which the code merges balance-sheet data; the author’s input period and sample coverage must be reconciled.

### A008: Obtain the hand-collected interest-rate input and its 1900 report transcription notes.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R010
Evidence: E008, E027, P007

Preparation / proposed procedure:

1. Request data_on_deposit_loans_and_rates.dta with c1–c12 mappings, encoding notes and the underlying table/page references.
2. The author identifies 1889, 1894 and 1899 loan/deposit rate observations from the 1900 Comptroller report; retain the prepared observations instead of rebuilding the transcription from PDFs.

Validation to perform later:

- Inspect c1–c12 and confirm the code’s date, bank type, state, amount and interest-rate conversions are compatible.
- Verify the expected years and state/bank-type keys before the rates file is merged into sample.

### A009: Reconcile the failure-source descriptions and obtain both author-prepared failure inputs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R011, R012, I004
Evidence: E004, E015, E028, E029, E045

Preparation / proposed procedure:

1. Request total.dta and national.dta with source, date range, bank-type coverage, field definitions and collection/transcription notes.
2. Ask the author to reconcile the datasheet’s Comptroller source description for failures by type/state/year with the do-file’s Bradstreet-labelled state/private stage and separate Comptroller national stage.
3. Confirm whether the private-bank failure series is represented in the prepared files and how missing rows are intended to enter nfail; do not independently replace the code’s missing-to-zero operation.

Validation to perform later:

- Verify that the delivered files cover the author-documented 1892–1913 range and support the intended State/Private/National annual keys.
- Confirm the output of each failure transformation before using it in the failure-rate denominator/numerator.

### A010: Obtain the Grossman file and resolve the 1909 count-source boundary.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R013, I005
Evidence: E009, E030, E045, P008

Preparation / proposed procedure:

1. Request doubleliab.dta, its issue/archive file identity, variable definitions and source period.
2. Ask the author whether Grossman counts replace the main bank-count series starting in 1909, as code condition year>1908 does, or only after 1909, as the datasheet says.
3. Keep the year>1908 expression unchanged until the intended 1909 treatment is confirmed.

Validation to perform later:

- Verify m3/year/state and bank-count fields, and document the chosen coverage at 1909 before combining the file with nbank.
- If a future source edit is needed, use the author-confirmed intended boundary and validate the resulting state/type/year counts in an authorized run.

### A011: Obtain the two author-prepared state policy timing inputs.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R014, R015
Evidence: E010, E031

Preparation / proposed procedure:

1. Request sba.xlsx and reserve.xlsx with source version, adoption-year definitions, state identifiers and any carry-forward coding rules.
2. Keep the Mitchener–Jaremski banking-authority series separate from the Rodkey reserve-requirement series.

Validation to perform later:

- Inspect expected State/Year and stabr/year fields and verify the code’s retained 1865–1914 sba period.
- Confirm reserve adoption dates and state abbreviations align to the baseline panel before merging.

### A012: Obtain the county-population workbook and confirm whether its unused preparation stage is intended in the full do-file.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R016
Evidence: E014, E032, P006

Preparation / proposed procedure:

1. Request countypop.xlsx with its NHGIS source tables, years, county/state identifiers and population field definitions.
2. Ask the author whether A.16 and its ctypop.dta output are intentionally required even though no later command consumes ctypop; keep the stage in the target workflow unless the author confirms its disposition.

Validation to perform later:

- Inspect county/state/year/pop fields and confirm which input years bracket the intended 1887 interpolation.
- Check that the delivered workbook supports A.16 without treating this file as a substitute for the distinct NHGIS county CSV series used in B.3.

### A013: Obtain the two-sheet 1888 election-return workbook and collection notes.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R017
Evidence: E011, E033

Preparation / proposed procedure:

1. Request Election Returns.xls with Referendum and Presidentials sheets, source/archive notes and county/state identifiers.
2. Preserve the author’s Illinois and Michigan historical returns rather than re-collecting microfilm or manuals.

Validation to perform later:

- Verify both sheet names and the vote columns expected by A.17, including county name variants and state labels.
- Confirm the workbook covers the 1888 referendum and presidential returns before producing electionres and pres_res.

### A014: Obtain the author’s Illinois and Michigan 1887 bank-list inputs.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R018
Evidence: E012, E035

Preparation / proposed procedure:

1. Request illinois1887.dta and michigan1887.dta with the Almanac transcription and bank-type coding notes.
2. Confirm the c1–c9 field order used by the code or provide the exact author-prepared Stata inputs.

Validation to perform later:

- Inspect county/place/banktype and bank identifiers and verify the code’s county/type counts and the reported Cook/Wayne corrections.
- Confirm the State/Private/National groupings before merging bankspercounty into sample_ref.

### A015: Obtain Jaremski’s decennial county bank-count workbook and identifier definitions.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R019
Evidence: E013, E036

Preparation / proposed procedure:

1. Request BanksByCounty1870-1910.xlsx with the original 2014 delivery, count definitions and county FIPS coding notes.
2. Confirm state, yr, countycode and bank-type count columns match the code’s renames and later merge keys.

Validation to perform later:

- Verify year values are 1870, 1880, 1890, 1900 and 1910 and inspect county-code formatting before joining to county pairs.
- Confirm countState–countTrust fields used by the contiguous-county branch are available.

### A016: Verify the ICPSR 9835 delivery and text layout before using the author import recipe.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R020
Evidence: E014, E037, P005

Preparation / proposed procedure:

1. Obtain the author’s 09835-0001-Data.txt or identify the exact ICPSR 9835 part, format and codebook corresponding to that filename.
2. Confirm the v1–v43 positions, FIPS fields, relationship field and name continuations imported by the space-delimited Stata command.

Validation to perform later:

- Check the delivered file’s layout against the v1–v43 reads and verify the code’s cross-state filtering and county-pair keys.
- Confirm that the 1991 county relationships and FIPS identifiers match the subsequent state/county joins.

### A017: Obtain the author’s 2014 NHGIS county extracts or exact current-compatible table/column mapping.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R021
Evidence: E014, E038, P006

Preparation / proposed procedure:

1. Request the five nhgis0012_csv year files or the exact NHGIS table/extract IDs, download date, variable mapping and county-code harmonization notes.
2. Do not assume a current NHGIS export can replace the legacy headers or the author’s county boundary corrections without confirmation.

Validation to perform later:

- Verify gisjoin, county, state, statea, countya and the census-specific population/urban columns before the code’s transformations.
- Confirm county-year coverage for 1870–1910 and the annual interpolation inputs before constructing contiguous_county.

### A018: Obtain both 1893 failure files and their Almanac matching specification.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R022
Evidence: E015, E039, E043

Preparation / proposed procedure:

1. Request failures1893.xls and cleaned files/1893.dta with the Sr matching key, FIPS assignment, bank-type definitions and exclusions.
2. Confirm the author’s rule for dropping unmatched bank entries and ensure the file pair retains the 1893 county/type sample inputs.

Validation to perform later:

- Verify the 1:1 Sr merge key is unique and inspect the expected FIPSState/FIPSCounty/No/PrivateBank fields.
- Confirm the generated failure counts align to the state/county crosswalk before building failures1893sample.

### A019: Supply and configure the exact Stata add-on commands used by the program.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S002, S003, S004
Evidence: E046, E047, E049, E055, E056

Preparation / proposed procedure:

1. Obtain compatible ado packages that provide the invoked commands csipolate, outreg2 and winsor2, record their source/version and configure the Stata adopath.
2. The Stata 18 executable is present; the bounded probes did not find these add-on commands in the checked paths.

Validation to perform later:

- In a later authorized software check, run which csipolate, which outreg2 and which winsor2 under the intended Stata 18 configuration.
- Confirm the interpolation command and table/winsorization commands are resolved before attempting the author do-file.

### A020: Clarify whether appendix analyses are in scope and request their missing programs/specifications if needed.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I003
Evidence: E001, E050, E051, E052, E053, E054

Preparation / proposed procedure:

1. Ask whether the target includes the online appendix IA1, IA2, IA4 and IA5 results in addition to the datasheet’s Tables 2–11 and Figure 4.
2. If they are in scope, request their separate entry point(s), data inputs and construction notes; do not infer formulas or rebuild appendix results from the PDF tables alone.

Validation to perform later:

- Map each requested appendix output to a supplied program and its input requirements before including it in the complete workflow.
- If the author confirms appendix regeneration is outside the package target, retain that scope limit in the assessment rather than treating the result PDF as executable evidence.


## Remaining issues and prerequisites

- I001 [preparation; full_pipeline]: The program starts in Source Data (line 23), where A.17/A.18/A.19 save electionres, pres_res, county-level gini and the final bankspercounty. A.4 separately saves a state-level gini to cleaned files/gini. B.1 changes the working directory to cleaned files at line 1677; B.2 then loads unqualified gini and merges the three unqualified Source Data outputs. As written, B.2 resolves the state-level Gini rather than the county-level output and does not resolve its three producer outputs from their saved folder, so the referenda sample cannot be assembled as intended without explicit producer/consumer paths. Preserve both Gini files.
- I002 [unresolved; full_pipeline]: Several consumed raw/reference files have no producer or source schema in this do-file or datasheet (including base, stabr, banktypes, states, state codes, US_FIPS_Codes, treatment matrices and the pre-cleaned 1893 match file). For state codes and US_FIPS_Codes, the consumers run from cleaned files after B.1 changes the working directory; their author locations and schemas remain unconfirmed. Their files are represented as requirements, but compatibility and closure remain unresolved until the author supplies the exact inputs and schemas.
- I003 [unresolved; full_pipeline]: The supplied online appendix reports IA1, IA2, IA4 and IA5 analyses, but this archive supplies no companion program for those results. The datasheet defines the do-file output as the main Tables 2–11 and Figure 4; if appendix regeneration is in scope, its entry point and input specification are unresolved.
- I004 [unresolved; full_pipeline]: The datasheet attributes failures by bank type/state/year for 1892–1913 to Comptroller reports, while the supplied code cleans a state/private failure input labelled Bradstreet’s and a separate national-bank input from Comptroller reports. Reconcile the intended source coverage and identify the author-prepared state/private input before using either history as the execution target.
- I005 [unresolved; full_pipeline]: The datasheet says Grossman supplements bank counts beyond 1909, while the code replaces the main nbank field with Grossman nb for year>1908, which includes 1909. Confirm the intended 1909 source boundary before treating the count series as compatible.
- R001 [undetermined]: The script starts from an unproduced base.dta year panel (use base) before crossing it with state and bank-type keys. The input needs at least the year field; its years and source are not documented.
- R002 [undetermined]: The unproduced stabr.dta lookup is used in the baseline cross and to join state/private failure records to state abbreviations. The code requires state and abbreviation keys but provides no file producer or provenance.
- R003 [undetermined]: The unproduced banktypes.dta cross table is joined to baseline; the code renames c1 to banktype and drops c2/c3.
- R004 [undetermined]: The unproduced states.dta file is merged to reportdate and contributes the cont indicator used to create adoption_pair.dta.
- R005 [undetermined]: Annual bank-count inputs number_of_banks, number_of_banks_pri and number_of_banks_nat are appended and reshaped from year (c1) and state columns (alabama through wyoming). The datasheet attributes these hand-collected counts to Barnett and Cooke (1910); the exact range is not stated.
- R006 [undetermined]: The treatment inputs reportdate.dta, stfinstat.dta, natfinstat.dta, stexam.dta and natexam.dta are read without any in-script producer. The code expects reportdate fields stabr/report/examination plus annual bank-type/state matrices; the datasheet attributes adoption timing to Barnett and Cooke (1910).
- R007 [undetermined]: Census input files 1870.dta through 1920.dta and census1890.dta feed state-level farm-size Gini, manufacturing, black-population measures and an 1890 county Gini branch. The code expects census-specific farm bins, geography/name and population/race fields (for example farm02/farm1019, mfgout, cotot/negtot, negmtot/negftot); exact mapping differs by year. The datasheet identifies Haines ICPSR 2896 for the state decennial data, but does not specify which ICPSR parts correspond to each file or the county census1890 input.
- R008 [undetermined]: Population.xlsx and Urbanpop.xlsx are unproduced NHGIS state workbooks. The code expects State, Year and TotalPoulation (as spelled in the program) in Population.xlsx, and State, Year and urbpop in Urbanpop.xlsx, then cubic-spline interpolates annual total/urban population.
- R009 [undetermined]: aggbsdata.dta is the unproduced annual state/national bank balance-sheet input. The code expects st/year plus a_* and n_* fields for cash, loans, real estate, investments, securities, deposits, interbank deposits, time/demand deposits, borrowing, banknotes, assets, liabilities, capital and surplus; state values are computed as a_ minus n_.
- R010 [undetermined]: data_on_deposit_loans_and_rates.dta is an unproduced hand-collected input. The code reads c1–c12 as date, bank_type, state, bank/loan/deposit counts and amounts plus interest rates; the datasheet says these rates cover 1889, 1894 and 1899 and were transcribed from the 1900 Comptroller annual report.
- R011 [undetermined]: total.dta is the unproduced hand-collected Bradstreet failure input. The supplied preparation code expects states_, no__state, assets_state and liabilities_state (then derives state failure count, assets/liabilities and leverage); its header names state, savings and private banks, while the datasheet’s source description does not clarify this branch’s type coverage.
- R012 [undetermined]: national.dta is the unproduced Comptroller-derived national-bank failure input. Code expects name, city, state, date_closed and estimated-good/doubtful/worthless, collections and claims fields; it derives annual state failures/leverage and drops 1914. The source dataset is not included.
- R013 [undetermined]: doubleliab.dta is the unproduced Grossman (2001) source. The code uses m3/year/state and state/national bank-count and failure/assets fields, constructs the dl file and also uses Grossman nb to replace nbank for year>1908. The exact issue archive file, columns and source period are not available in this release.
- R014 [undetermined]: sba.xlsx is the unproduced state banking-authority adoption input. The code expects State and Year and constructs sba, keeping 1865–1914; the author attributes adoption years to Mitchener and Jaremski (2015).
- R015 [undetermined]: reserve.xlsx is the unproduced state reserve-requirement adoption input. The code expects stabr/year and carries the reserve indicator forward; the author attributes years to Rodkey (1934).
- R016 [undetermined]: countypop.xlsx is read unconditionally in A.16 and saves ctypop.dta after interpolating county population. The stage title is 1887 population for Illinois/Michigan; no later code reads ctypop, but the supplied full do-file requires the workbook to pass this stage. The author identifies NHGIS as the county-population source.
- R017 [undetermined]: Election Returns.xls is an unproduced two-sheet workbook for Illinois/Michigan 1888 referendum and presidential county votes. The code expects county, yesvote/novote/totalvote in Referendum and State/County/Republican/Democrat/Progressive/Labor in Presidentials.
- R018 [undetermined]: illinois1887 and michigan1887 are unproduced manually transcribed bank lists used to form county/type counts for 1887. Code renames c1–c9 into place, county, bankname, banktype, officers and capital/surplus/profit fields, then counts banks by county and type.
- R019 [undetermined]: BanksByCounty1870-1910.xlsx is the unproduced Jaremski county bank-count file used in the contiguous-county branch; code expects state, yr, countycode and bank-type count columns such as countState–countTrust.
- R020 [undetermined]: 09835-0001-Data.txt is the unproduced ICPSR 9835 contiguous-county text source. Code imports space-delimited columns, reconstructs county names/FIPS keys, and filters cross-state pairs for the border analyses.
- R021 [undetermined]: The NHGIS county extracts nhgis0012_csv/{1870,1880,1890,1900,1910}_county.csv are unproduced. The code expects legacy fields gisjoin/county/state/statea/countya plus census-specific population and urban-population source columns, harmonizes county codes, then interpolates yearly population.
- R022 [undetermined]: The 1893 border-analysis branch requires failures1893.xls and an unproduced cleaned-files/1893 match table on Sr. The code uses state, bank type, Assets, Sr, Name, FIPSState/FIPSCounty, No and PrivateBank to produce failure counts by county/type; it explicitly drops banks that cannot be matched to the Almanac.
- R023 [undetermined]: state codes.dta is an unproduced reference file consumed by both B.3 and B.4. Those branches run after B.1 changes the current directory to cleaned files, so the effective literal path is $dropbox/cleaned files/state codes.dta. Its required columns, provenance and producer remain undocumented.
- R024 [undetermined]: US_FIPS_Codes.dta is an unproduced county reference file consumed by B.4 after B.1 changes the current directory to cleaned files. The code expects state/FIPSState/FIPSCounty identifiers, but no source or version is documented.
- S002 [preparation_required]: The exact invoked csipolate command is not found in the checked Stata 18 adopath; it is used to interpolate population, Gini, black-population and county series.
- S003 [preparation_required]: outreg2 is not found in the checked Stata adopaths; the author calls it to write multiple table outputs.
- S004 [preparation_required]: winsor2 is not found in the checked Stata adopaths; the author uses it in the Table 4 winsorized robustness specification.

## Review notes

- No analysis_only scope is supported: sample, sample_ref, failures1893sample and contiguous_county are generated inside the same do-file, and the package contains no separate prepared analysis dataset or compatible analysis entry route.
- Dependency order is A sample preparation then B.1 sample, B.2 sample_ref, B.3 contiguous_county and B.4 failures1893sample, followed by C regressions. B.1 changes the working directory to cleaned files; B.2 therefore resolves unqualified names there. The county Gini, electionres, pres_res and final bankspercounty are written earlier relative to Source Data, while the separate state Gini is written to cleaned files/gini. The B.2 referenda branch needs explicit Source Data paths for its producer outputs; later Table 10 Panel B, Table 7 and Table 8 Panel B consume sample_ref, failures1893sample and contiguous_county respectively.
- The state census inputs are decennial 1870–1920 and code applies csipolate after tsfill to build annual population, Gini/manufacturing and black-population series. County population inputs are decennial 1870–1910 and are interpolated to annual county series; the separate countypop.xlsx A.16 branch targets 1887 but saves ctypop that is never read later.
- The estimation sample’s exact start/end is not identified because base.dta is absent. Table 3 alone filters year>1895; other regressions use the broader assembled sample. Event-time indicators use five annual leads and five lags, the survival setup has origin(year==1876), and the winsor2 frate step has no year filter; the required source history and whole-input population therefore cannot be inferred from Table 3’s filter.
- The datasheet’s historical source notes are provenance, not a requirement to repeat manual collection. For absent author-prepared files, actions request the exact prepared inputs/schema; public product pages remain candidate routes until file fields, identifiers, formatting and coverage are confirmed.
- The dependency checklist is fully reviewed below. Frozen entries that read outputs written earlier in this same do-file are marked generated with the producer line evidence; additional direct raw reads omitted by the parser are represented as separate requirements R002–R004, R006, R023 and R024 plus the missing 1893 match file in R022. The state codes crosswalk and US_FIPS_Codes are read from cleaned files by B.3/B.4 because the main branch already changed the current directory there; their provenance and schemas remain unresolved.
- The B.2 path correction is proposed only; it preserves state-level cleaned files/gini and routes county-level Source Data/gini plus the three referenda outputs from their actual producer directory. No author source file was edited or executed.
