# Patch proposal: jar-ef10959be624

Internalizing Peer Firm Product Market Concerns: Supply Chain Relations and M&A Activity

DOI: 10.1111/1475-679X.12574

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full documented seven-program pipeline: raw SAS preparation, X and Y construction, Part 1 controls/cross-sectional construction, Part 2 patent/tariff construction, final-dataset construction and every main and appendix table/figure branch in the regression program. Full closure remains incomplete while the named producer mappings, version choice, SAS runtime and Part 2/Final interleaving remain unresolved.

Entry points: `0_Get_raw_data.sas`, `1_X_var_construction.do`, `2_ Y_var_construction.sas`, `3_Controls&CS_vars_construction-Part 1.sas`, `3_Controls&CS_vars_construction-Part 2.do`, `4_ Final_dataset_construction.do`, `5_AKR_regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12574 - Internalizing-Peer-Firm-Product-Market-Concerns-Supply-Chain-Relations-and-M-A-Activity/akry-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "7ffeb09a58252276a70b97f67340e0ddb80928848ca1b1ea6bf699ea5591842e"
    },
    {
      "path": "JAR-Volume 63/Issue 2/12574 - Internalizing-Peer-Firm-Product-Market-Concerns-Supply-Chain-Relations-and-M-A-Activity/akry-online-appendix.pdf",
      "sha256": "c7253d07ce7d635e5d040ef94388d02ec6ed97d5c2eb2475134938a69682918f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "730b7f1c5b1837e4d903e24dd0a7fba3f922d0ae7228f3ff0c609fbcea77f8b9"
}
```

## Proposed actions

### A_HANDOFF_CLARIFICATION: Request the exact producer or compatible product mapping for compa_temp.dta and percent_supplier_year.dta; confirm whether Ctmp7_20221121 is a distinct required panel from the supplied Ctmp7_20221217 output; and document the transformation, keys and output location connecting rsi_patent_20221124.dta to the final-suffixed file consumed by Final. Keep the supported same-product stage handoffs as preparation tasks.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_HANDOFF_CLOSURE, R_COMPA_TEMP, R_PERCENT_SUPPLIER_YEAR, R_CTMP7_20221121, R_RSI_PATENT_FINAL
Evidence: E_SRC_PART2_L380, E_SRC_PART2_L443, E_SRC_FINAL_L254, E_SRC_PART2_L189, E_SRC_PART1_L444, E_SRC_PART2_L367, E_SRC_FINAL_L208

Preparation / proposed procedure:

1. Ask for the producer or exact prepared input and field/key/history specification for compa_temp.dta and percent_supplier_year.dta.
2. Confirm the intended Ctmp7 date/version relationship rather than equating the 20221121 and 20221217 products.
3. Confirm the output mapping and required transformation for the Part 2 rsi_patent file and Final's _final consumer.
4. After mapping, stage compatible files and validate their merge keys and fields before running dependent stages.

Validation to perform later:

- Trace each clarified producer to its exact consumer path, fields, keys and period; do not infer that an unlisted file is absent locally.

### A_DATA_R_SEG1208: Resolve the remaining local compatibility checks for R_SEG1208: ../../Data/Datasets/seg1208.dta (local, unverified): The Stata DTA is read by X and Part 2; Y separately reads a SAS7BDAT at Data/Datasets/seg1208.sas7bdat. A compatible single panel can be staged in both forms, but no exact producer or full field/history contract is established. Confirm the exact table/member, required fields sgvkey, cgvkey, srcdate, year, cdatadate, p_salecs and history Supplier/customer histories needed to construct the 1989–2014 analysis panel; exact construction window and coverage remain unresolved.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SEG1208
Evidence: E_SRC_X_L29, E_SRC_Y_L13, E_SRC_PART2_L434, E_SRC_RAW_L234, E_SRC_RAW_L238

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_SEG1208 with bounded metadata.
2. Compare the actual required fields sgvkey, cgvkey, srcdate, year, cdatadate, p_salecs and keys with the source contract.
3. Validate Supplier/customer histories needed to construct the 1989–2014 analysis panel; exact construction window and coverage remain unresolved. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_TNIC3: Acquire the documented R_TNIC3 product from Hoberg–Phillips TNIC3 HHI and Total Similarity author library. Hoberg–Phillips TNIC3 HHI and Total Similarity author library: Official author documentation identifies the firm-year HHI level, TNIC pair-score keys and data products, with overall annual coverage that includes the 1989–2014 analysis period. This supports acquiring the underlying measures and mapping them to the program's gvkey/year/tnic3tsimm/tnic3hhi fields; payload byte or exact header identity is not a route prerequisite. Validate the chosen release and selected-year coverage when staging. Map the source measures to gvkey, year, tnic3tsimm, tnic3hhi; record the selected release and verify Author library documents annual coverage 1989–2023; selected analysis sample 1989–2014. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_TNIC3
Evidence: E_PUB_HP_COVERAGE, E_PUB_HP_PRODUCTS, E_PUB_HHI_LEVEL, E_PUB_TNIC_FIELDS, E_SRC_X_L22, E_SRC_PART2_L538

Preparation / proposed procedure:

1. Acquire only the documented product at Hoberg–Phillips TNIC3 HHI and Total Similarity author library and retain its release metadata.
2. Map the documented measures to gvkey, year, tnic3tsimm, tnic3hhi without changing the author construction.
3. Validate Author library documents annual coverage 1989–2023; selected analysis sample 1989–2014. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_COMPUSTAT_FUNDAMENTALS: Stage the supported local or source-generated R_COMPUSTAT_FUNDAMENTALS product at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat. ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat: The reviewed raw and downstream transformations require gvkey, datadate, fyear, at, sale, csho and prcc_f from COMP.FUNDA; the targeted one-row SAS result confirms those source-consumed fields at this exact catalogued path. The full 1978–2021 population remains a staging coverage validation, not a missing-input gate. No additional unsupported consumed field was identified in the reviewed workflow. Preserve the existing panel construction and validate gvkey, datadate, fyear, at, sale, csho, prcc_f and Source filter 1978–2021; analysis sample 1989–2014. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPUSTAT_FUNDAMENTALS
Evidence: E_SRC_RAW_L18, E_SRC_DATASHEET_L49, E_CAT_FUNDA, E_PROBE_FUNDA

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check gvkey, datadate, fyear, at, sale, csho, prcc_f.
3. Validate Source filter 1978–2021; analysis sample 1989–2014.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_COMPUSTAT_NAMES: Stage the supported local or source-generated R_COMPUSTAT_NAMES product at ${ACCTREPL_SAS_ROOT}/comp/d_na/names.sas7bdat. ${ACCTREPL_SAS_ROOT}/comp/d_na/names.sas7bdat: The exact COMP.NAMES candidate is catalogued and one-row readable with GVKEY, SIC and NAICS, the fields used by the source join. The bounded probe does not establish the file's complete contents. Preserve the existing panel construction and validate gvkey, sic, naics and Static name/code mapping joined to the author Compustat records; full endpoint coverage is not sampled. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPUSTAT_NAMES
Evidence: E_SRC_RAW_L32, E_CAT_NAMES, E_PROBE_NAMES

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/comp/d_na/names.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check gvkey, sic, naics.
3. Validate Static name/code mapping joined to the author Compustat records; full endpoint coverage is not sampled.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_CRSP_CCM_LINK: Stage the supported local or source-generated R_CRSP_CCM_LINK product at ${ACCTREPL_SAS_ROOT}/crsp/a_ccm/ccmxpf_linktable.sas7bdat. ${ACCTREPL_SAS_ROOT}/crsp/a_ccm/ccmxpf_linktable.sas7bdat: The catalog identifies CRSP.CCMXPF_LINKTABLE as a link-history file and its exact path is one-row readable with GVKEY, PERMNO, link type and interval fields used by the source. Preserve the existing panel construction and validate gvkey, lpermno, linktype, linkdt, linkenddt and Link intervals needed for the author's 1978–2021 construction records; full endpoint coverage is not sampled. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_CCM_LINK
Evidence: E_SRC_RAW_L67, E_SRC_DATASHEET_L55, E_CAT_CCM, E_PROBE_CCM

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/crsp/a_ccm/ccmxpf_linktable.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check gvkey, lpermno, linktype, linkdt, linkenddt.
3. Validate Link intervals needed for the author's 1978–2021 construction records; full endpoint coverage is not sampled.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_CRSP_DSENAMES: Stage the supported local or source-generated R_CRSP_DSENAMES product at ${ACCTREPL_SAS_ROOT}/crsp/a_stock/dsenames.sas7bdat. ${ACCTREPL_SAS_ROOT}/crsp/a_stock/dsenames.sas7bdat: The exact CRSP.DSENAMES candidate is catalogued and one-row readable with PERMNO, name interval, SICCD and NAICS columns. The author also reads a Data/Datasets SAS copy, which must be staged from this compatible product. Preserve the existing panel construction and validate PERMNO, NAMEDT, NAMEENDT, SICCD, NAICS and Historical name intervals required by the author construction; the bounded sample does not establish all endpoints. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_DSENAMES
Evidence: E_SRC_RAW_L75, E_SRC_RAW_L312, E_SRC_Y_L15, E_SRC_DATASHEET_L55, E_CAT_DSENAMES, E_PROBE_DSENAMES

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/crsp/a_stock/dsenames.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check PERMNO, NAMEDT, NAMEENDT, SICCD, NAICS.
3. Validate Historical name intervals required by the author construction; the bounded sample does not establish all endpoints.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_COMPSEG_CUSTOMER: Stage the supported local or source-generated R_COMPSEG_CUSTOMER product at ${ACCTREPL_SAS_ROOT}/comp/d_seghist/wrds_seg_customer.sas7bdat. ${ACCTREPL_SAS_ROOT}/comp/d_seghist/wrds_seg_customer.sas7bdat: The exact COMPSEGD.WRDS_SEG_CUSTOMER path is catalogued and one-row readable with GVKEY, customer ID/name/type, customer sales and source date fields consumed by the raw stage. Preserve the existing panel construction and validate gvkey, cid, cnms, ctype, salecs, srcdate and Source stages use segment history including 1976–2019; full population and endpoints are not sampled. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPSEG_CUSTOMER
Evidence: E_SRC_RAW_L92, E_SRC_DATASHEET_L61, E_CAT_SEGMENT, E_PROBE_SEGMENT

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/comp/d_seghist/wrds_seg_customer.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check gvkey, cid, cnms, ctype, salecs, srcdate.
3. Validate Source stages use segment history including 1976–2019; full population and endpoints are not sampled.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SEGLINK: Stage the supported local or source-generated R_SEGLINK product at ${ACCTREPL_SAS_ROOT}/wrdsapps/linking/seglink/seglink.sas7bdat -> ../../Data/Datasets/seglink.sas7bdat. ${ACCTREPL_SAS_ROOT}/wrdsapps/linking/seglink/seglink.sas7bdat -> ../../Data/Datasets/seglink.sas7bdat: The reviewed segment-link operations use gvkey, cid, srcdate, cgvkey and ccusip. The exact local WRDSAPPS.SEGLINK candidate is one-row readable and contains those required fields; stage this compatible SAS product at the author path. Validate source-period coverage through 2019 during staging. No extra unsupported consumed field or requirement for the author's exact copied bytes was identified. Preserve the existing panel construction and validate gvkey, cid, srcdate, cgvkey, ccusip and Segment links used through 2019 by the source; validate historical coverage during staging. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_SEGLINK
Evidence: E_SRC_RAW_L131, E_SRC_PART1_L564, E_SRC_DATASHEET_L61, E_CAT_SEGLINK, E_PROBE_SEGLINK

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/wrdsapps/linking/seglink/seglink.sas7bdat -> ../../Data/Datasets/seglink.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check gvkey, cid, srcdate, cgvkey, ccusip.
3. Validate Segment links used through 2019 by the source; validate historical coverage during staging.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SEG20221120_SAS: Stage the raw-produced seg20221120 segment panel in the SAS library consumed by Part 1, retaining its source-defined construction from seg8. Check the consumer fields and relevant source-period coverage as part of that generated-output handoff.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GENERATED_HANDOFF_STAGING
Evidence: E_SRC_PART1_L971, E_SRC_RAW_L234, E_SRC_RAW_L237, E_SRC_RAW_L238

Preparation / proposed procedure:

1. Stage or persist the raw-produced seg20221120 SAS table at the Part 1 Data/Datasets location.
2. Preserve the source construction and check sgvkey, cgvkey, srcdate, year and csale after generation.
3. Validate the relevant historical coverage while staging the generated panel.

Validation to perform later:

- Validate the generated and staged output against the source-defined consumer fields and relevant historical windows; do not execute author programs as part of this preparation action.

### A_DATA_R_SDC_MNA_DETAILS: Resolve the remaining local compatibility checks for R_SDC_MNA_DETAILS: ../../Data/Datasets/mna_details.sas7bdat (local, unverified): The source names this SDC extract independently. No bounded exact-file probe or matching catalog record establishes its local fields or availability. Confirm the exact table/member, required fields MASTER_DEAL_NO, ACUSIP, TUP, DATEANN, DATEEFF, DATEWITH, FORM, STATUS and history Raw stage filters announcement years 1989–2019.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SDC_MNA_DETAILS
Evidence: E_SRC_RAW_L248, E_SRC_DATASHEET_L66

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_SDC_MNA_DETAILS with bounded metadata.
2. Compare the actual required fields MASTER_DEAL_NO, ACUSIP, TUP, DATEANN, DATEEFF, DATEWITH, FORM, STATUS and keys with the source contract.
3. Validate Raw stage filters announcement years 1989–2019. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SDC_MNA: Resolve the remaining local compatibility checks for R_SDC_MNA: ../../Data/Datasets/mna.sas7bdat (local, unverified): The source reads this second author-named SDC extract. No bounded local file/table check establishes its complete fields or its equivalence to mna_details. Confirm the exact table/member, required fields MASTER_DEAL_NO, ACUSIP, TUP, DATEANN, DATEEFF, DATEWITH, FORM, STATUS and history Raw stage filters announcement years 1989–2019.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SDC_MNA
Evidence: E_SRC_RAW_L264, E_SRC_DATASHEET_L66

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_SDC_MNA with bounded metadata.
2. Compare the actual required fields MASTER_DEAL_NO, ACUSIP, TUP, DATEANN, DATEEFF, DATEWITH, FORM, STATUS and keys with the source contract.
3. Validate Raw stage filters announcement years 1989–2019. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_PERMNONCUSIP: Resolve the remaining local compatibility checks for R_PERMNONCUSIP: ../../Data/Datasets/permnoncusip.sas7bdat (local, unverified): The source also names PERM.PERMNONCUSIP. A targeted frozen-catalog lookup did not find a matching leaf, which does not establish absence, entitlement or access status. Confirm the exact table/member, required fields ncusip, permno and history Mapping periods used by the transaction and 13F branches; full coverage unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_PERMNONCUSIP
Evidence: E_SRC_RAW_L292, E_SRC_RAW_L460, E_SRC_DATASHEET_L55, E_CAT_PERMNONCUSIP

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_PERMNONCUSIP with bounded metadata.
2. Compare the actual required fields ncusip, permno and keys with the source contract.
3. Validate Mapping periods used by the transaction and 13F branches; full coverage unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_TFN_S34: Resolve the remaining local compatibility checks for R_TFN_S34: ${ACCTREPL_SAS_ROOT}/tfn/s34/s34.sas7bdat (local, unverified): TFN.S34 is catalogued; the mandated Python row_limit=1 probe timed out at 15 seconds. This is a read limitation and does not establish absence or access status. Confirm the exact table/member, required fields CUSIP, MGRNO, RDATE, SHARES, MGRNAME, STKNAME, TICKER and history Holdings from 1987 onward are referenced; required full history remains unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_TFN_S34
Evidence: E_SRC_RAW_L451, E_SRC_DATASHEET_L73, E_CAT_S34, E_PROBE_S34

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_TFN_S34 with bounded metadata.
2. Compare the actual required fields CUSIP, MGRNO, RDATE, SHARES, MGRNAME, STKNAME, TICKER and keys with the source contract.
3. Validate Holdings from 1987 onward are referenced; required full history remains unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_PERM_II2: Resolve whether the upstream WORK.ii2 construction is the same logical holdings table consumed as PERM.ii2. The saved source lines do not establish the persistence/member mapping or full field/key/history contract, so retain PERM.II2 as a separate unverified requirement until that identity is supported. Do not infer equivalence from a basename or the consumer read alone.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_PERM_II2
Evidence: E_SRC_RAW_L476, E_SRC_RAW_L487

Preparation / proposed procedure:

1. Use an explicit source-defined producer-to-persistent-member mapping to establish whether WORK.ii2 supplies PERM.ii2; keep them distinct unless that identity is supported.
2. After identity is established, compare the actual required fields, keys and historical coverage with the consumer contract.
3. Retain unresolved any field, key, history or construction detail not supported by the existing source contract.

Validation to perform later:

- Require producer-to-consumer product identity plus compatible field, key and historical-mapping evidence before crediting a PERM.II2 candidate; do not use filename similarity as proof.

### A_DATA_R_CRSP_MSF: Stage the supported local or source-generated R_CRSP_MSF product at ${ACCTREPL_SAS_ROOT}/crsp/a_stock/msf.sas7bdat. ${ACCTREPL_SAS_ROOT}/crsp/a_stock/msf.sas7bdat: The exact catalogued CRSP.MSF product and path are supported by a successful one-row read with the consumed PERMNO, DATE and SHROUT fields. Full population/history is not measured by that bounded probe and remains ordinary coverage validation, not a missing-input gate. Preserve the existing panel construction and validate PERMNO, DATE, SHROUT and Monthly rows for the holdings dates consumed by the author workflow; validate coverage during staging. during preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_MSF
Evidence: E_SRC_RAW_L476, E_SRC_DATASHEET_L55, E_CAT_MSF, E_PROBE_MSF

Preparation / proposed procedure:

1. Stage or convert the supported product at ${ACCTREPL_SAS_ROOT}/crsp/a_stock/msf.sas7bdat into the author-consumed format and library path.
2. Preserve the source-defined construction and check PERMNO, DATE, SHROUT.
3. Validate Monthly rows for the holdings dates consumed by the author workflow; validate coverage during staging.; treat whole-population checks as staging validation when the route itself is supported.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_COMPA78_DTA: Convert or stage the raw-produced Compustat 20220410 panel in the Stata DTA form consumed by X and Part 2. This is a format/path handoff for one generated panel, not a separate Compustat input.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GENERATED_HANDOFF_STAGING
Evidence: E_SRC_RAW_L88, E_SRC_X_L7, E_SRC_PART2_L116

Preparation / proposed procedure:

1. Stage the raw-produced 20220410 Compustat panel at the configured Stata DTA path.
2. Preserve its source-defined construction and check gvkey, datadate, fyear, at, sale, csho, prcc_f, year and lpermno after conversion.
3. Validate the relevant source and consumer periods as part of the conversion.

Validation to perform later:

- Validate the generated and staged output against the source-defined consumer fields and relevant historical windows; do not execute author programs as part of this preparation action.

### A_DATA_R_COMPA78_20_SAS: Persist the raw-produced Compustat 20220410 panel in the SAS library consumed by Y. This is the SAS handoff for the same generated Compustat product.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GENERATED_HANDOFF_STAGING
Evidence: E_SRC_RAW_L88, E_SRC_RAW_L179, E_SRC_Y_L33

Preparation / proposed procedure:

1. Stage or persist the raw-produced Compustat panel in the Y-consumed SAS library.
2. Preserve the source-defined construction and check gvkey, datadate, lpermno, year and sic after staging.
3. Validate the historical firm-years used in Y as transformation coverage.

Validation to perform later:

- Validate the generated and staged output against the source-defined consumer fields and relevant historical windows; do not execute author programs as part of this preparation action.

### A_DATA_R_SAMPLE_MNA_SAS: Stage the one raw-produced sample_mna_20221217 transaction panel in both SAS and Stata forms for Y/Part 1 and Part 2. The two formats are a single generated product handoff, not separate M&A inputs.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GENERATED_HANDOFF_STAGING
Evidence: E_SRC_RAW_L428, E_SRC_Y_L122, E_SRC_PART1_L494, E_SRC_PART2_L387, E_SRC_PART2_L1

Preparation / proposed procedure:

1. Stage the raw-produced sample_mna_20221217 panel in the SAS library consumed by Y and Part 1.
2. Convert or stage the same panel in the Stata DTA form consumed by Part 2.
3. Preserve the source-defined construction and validate gvkey, counterparty_gvkey, dateann, status, year and the 1989–2019 transaction window.

Validation to perform later:

- Validate the generated and staged output against the source-defined consumer fields and relevant historical windows; do not execute author programs as part of this preparation action.

### A_DATA_R_KPSS_2019: Acquire the documented R_KPSS_2019 product from KPSS author repository current patent-level release KPSS_2025.csv. KPSS author repository current patent-level release KPSS_2025.csv: Repository documentation identifies patent_num, PERMNO, issue/filing dates, real innovation value and citation fields over 1926–2025. This current compatible product is not the author-named 2019 vintage; value revision is retained as a separate fidelity issue. Map the source measures to patent_num, permno, issue_date, filing_date, xi_real, cites; record the selected release and verify Patent years required by the source's patent windows; current documented panel spans 1926–2025. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_KPSS_2019
Evidence: E_PUB_KPSS_PERIOD, E_PUB_KPSS_XI, E_PUB_KPSS_DATES, E_SRC_PART1_L266

Preparation / proposed procedure:

1. Acquire only the documented product at KPSS author repository current patent-level release KPSS_2025.csv and retain its release metadata.
2. Map the documented measures to patent_num, permno, issue_date, filing_date, xi_real, cites without changing the author construction.
3. Validate Patent years required by the source's patent windows; current documented panel spans 1926–2025. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_EDGAR_PC: Resolve the remaining local compatibility checks for R_EDGAR_PC: ../../Data/Datasets/edgar_pc_0404.xlsx (local, unverified): The source imports this author workbook. Its exact sheet headers, filing population, text cleaning and merge keys were not established by the assigned bounded probes. ${ACCTREPL_SEC_PARSED} (local, unverified): The approved bounded check confirms only that the parsed SEC root is a directory. It does not establish section, filing, cleaning, date or join-key compatibility with the author workbook; no listing or reconstruction was done. Confirm the exact table/member, required fields (not specified) and history Filing records needed by the author supplier/customer panel; workbook coverage and cleaning remain unverified.; SEC filing population and author text-construction window are unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_EDGAR_PC
Evidence: E_SRC_PART1_L427, E_PROBE_SEC_RAW, E_PROBE_SEC_PARSED

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_EDGAR_PC with bounded metadata.
2. Compare the actual required fields (not specified) and keys with the source contract.
3. Validate Filing records needed by the author supplier/customer panel; workbook coverage and cleaning remain unverified.; SEC filing population and author text-construction window are unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SC6_SIC3: Persist the SC6_sic3 relationship table produced by Y in the SAS library consumed by Part 1. This is a generated same-product library handoff.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GENERATED_HANDOFF_STAGING
Evidence: E_SRC_Y_L91, E_SRC_PART1_L765

Preparation / proposed procedure:

1. Stage or persist the Y-produced SC6_sic3 table in the Part 1 Data library.
2. Preserve the Y source construction and check sgvkey, cgvkey, rgvkey, rsgvkey, year, srcdate, csic3 and rsic3 after staging.
3. Validate relationship-window coverage as transformation validation.

Validation to perform later:

- Validate the generated and staged output against the source-defined consumer fields and relevant historical windows; do not execute author programs as part of this preparation action.

### A_DATA_R_II5: Resolve the specific source or construction for R_II5: ../../Data/Datasets/ii5.sas7bdat (local, unverified): Part 1 reads data.ii5, but no supplied stage writes this exact member or documents an ii4-to-ii5 mapping. Request or identify a compatible producer/source and field, key and history definition for CUSIP, MGRNO, RDATE, instown, MGRNAME; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_II5
Evidence: E_SRC_RAW_L487, E_SRC_PART1_L834

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_II5 at the listed route(s).
2. If it exists, map CUSIP, MGRNO, RDATE, instown, MGRNAME and Ownership rows matched to customer/rival dates over the source period; producer and history are unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_FIN_MNA: Resolve the specific source or construction for R_FIN_MNA: ../../Data/Datasets/Fin_mna_20221219.csv (local, unverified): The named author CSV must provide institution identities, event dates and manager identifiers; Part 1 renames those input fields, but no bounded local metadata check establishes its full headers or coverage. He and Huang AEA-hosted merger appendix (public, unverified): The appendix is a candidate source for the merger event list, but does not establish the manager-number fields required by the author program or a mapping to its list. Request or identify a compatible producer/source and field, key and history definition for Target_Name, Acquiror_Name, Target_Mgrno, Acquirer_Mgrno, Announcement_Date, acquirer name, target name, announcement date, effective date; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FIN_MNA
Evidence: E_SRC_PART1_L879, E_SRC_PART1_L887, E_SRC_PART1_L888, E_PUB_HEHUANG

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_FIN_MNA at the listed route(s).
2. If it exists, map Target_Name, Acquiror_Name, Target_Mgrno, Acquirer_Mgrno, Announcement_Date, acquirer name, target name, announcement date, effective date and The source's institutional merger events are referenced over 1983–2011; exact file coverage remains unverified.; Candidate event list only; mapping to the author manager IDs remains unverified. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_JV_ALLIANCE: Resolve the remaining local compatibility checks for R_JV_ALLIANCE: ../../Data/Datasets/jv_alliance_allyear.dta (local, unverified): The SAS program imports this local DTA and expands CUSIP/year relationships. No file-level metadata probe establishes exact identifiers, year ranges or coverage. Confirm the exact table/member, required fields CUSIP, begin_year, end_year and history Years overlapping the supplier panel; event and join coverage unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_JV_ALLIANCE
Evidence: E_SRC_PART1_L1008

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_JV_ALLIANCE with bounded metadata.
2. Compare the actual required fields CUSIP, begin_year, end_year and keys with the source contract.
3. Validate Years overlapping the supplier panel; event and join coverage unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SWITCH: Resolve the remaining local compatibility checks for R_SWITCH: ../../Data/Datasets/switch_0330.sas7bdat (local, unverified): Part 1 consumes this prepared panel; none of the seven supplied programs writes the exact member. Confirm the exact table/member, required fields sgvkey, srcdate, acquirer_1, target_1 and history Supplier-year switch panel over the author sample; complete period and definition unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SWITCH
Evidence: E_SRC_PART1_L1235

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_SWITCH with bounded metadata.
2. Compare the actual required fields sgvkey, srcdate, acquirer_1, target_1 and keys with the source contract.
3. Validate Supplier-year switch panel over the author sample; complete period and definition unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SWITCH_SIC3: Resolve the remaining local compatibility checks for R_SWITCH_SIC3: ../../Data/Datasets/switch_0330_sic3.sas7bdat (local, unverified): Part 1 reads a separate SIC3-level switch member; no supplied stage produces the exact input. Confirm the exact table/member, required fields sgvkey, srcdate, sum_switch, wanted_acquirer_1, wanted_target_1 and history Supplier-year/SIC3 panel over the author sample; complete period and definition unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SWITCH_SIC3
Evidence: E_SRC_PART1_L1244

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_SWITCH_SIC3 with bounded metadata.
2. Compare the actual required fields sgvkey, srcdate, sum_switch, wanted_acquirer_1, wanted_target_1 and keys with the source contract.
3. Validate Supplier-year/SIC3 panel over the author sample; complete period and definition unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_PATENT_CPC_LINK: Resolve the specific source or construction for R_PATENT_CPC_LINK: KPSS repository current patent/CPC match product (public, unverified): Current public repository documentation supports a patent-level data route, but the exact patent-to-CPC group file, header mapping and author cpc_group_id aggregation are not verified without payload inspection. Request or identify a compatible producer/source and field, key and history definition for patent_num, cpc, cpc_group_id; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PATENT_CPC_LINK
Evidence: E_SRC_PART2_L126, E_PUB_KPSS_PERIOD, E_PUB_KPSS_DATES

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_PATENT_CPC_LINK at the listed route(s).
2. If it exists, map patent_num, cpc, cpc_group_id and Patent/CPC records across the construction years; exact grouping and coverage remain unverified. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_PATENT_GRANT_DATE: Acquire the documented R_PATENT_GRANT_DATE product from KPSS author repository current patent-level release KPSS_2025.csv. KPSS author repository current patent-level release KPSS_2025.csv: The documented public panel provides patent_num and issue_date; the source's id/date names can be supplied through a simple rename and date-format conversion without changing the patent construction. Map the source measures to patent_num, issue_date; record the selected release and verify Patent issue dates cover the historical years required by the source construction. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_PATENT_GRANT_DATE
Evidence: E_SRC_PART2_L136, E_PUB_KPSS_PERIOD, E_PUB_KPSS_DATES

Preparation / proposed procedure:

1. Acquire only the documented product at KPSS author repository current patent-level release KPSS_2025.csv and retain its release metadata.
2. Map the documented measures to patent_num, issue_date without changing the author construction.
3. Validate Patent issue dates cover the historical years required by the source construction. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_CTMP7_20221121: Resolve the specific source or construction for R_CTMP7_20221121: $path/Ctmp7_20221121.dta (local, unverified): Part 2 requires the 20221121 DTA. Part 1 emits the differently named and dated Ctmp7_20221217 files; no source proves the two vintages or schemas interchangeable. Request or identify a compatible producer/source and field, key and history definition for spermno, cpermno, sgvkey, cgvkey, srcdate, year, r_p_salecs_3_1, p_salecs; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CTMP7_20221121
Evidence: E_SRC_PART2_L189, E_SRC_PART1_L443, E_SRC_PART1_L444, E_SRC_FINAL_L152

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_CTMP7_20221121 at the listed route(s).
2. If it exists, map spermno, cpermno, sgvkey, cgvkey, srcdate, year, r_p_salecs_3_1, p_salecs and Supplier/customer-year rows for patent and tariff construction; exact vintage and coverage unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_COMPA_TEMP: Resolve the specific source or construction for R_COMPA_TEMP: $path2/temp/compa_temp.dta (local, unverified): The frozen dependency index points to a blank parser line; a bounded adjacent safe-source view locates the actual consumer at Part 2 line 380. No supplied producer for this exact DTA is established. Request or identify a compatible producer/source and field, key and history definition for gvkey, datadate, sic1; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPA_TEMP
Evidence: E_SRC_PART2_L380, E_SRC_X_L7

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_COMPA_TEMP at the listed route(s).
2. If it exists, map gvkey, datadate, sic1 and Customer firm-date history aligned to the supplier panel; producer and required history are unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_MNA_WLINKS_SIC: Resolve the remaining local compatibility checks for R_MNA_WLINKS_SIC: $path/mna_wlinks_sic.dta (local, unverified): Y creates temp.mna_wlinks as a SAS table, while Part 2 reads mna_wlinks_sic.dta from the Data root. The distinct name, format and path are not shown to be an exact alias. Confirm the exact table/member, required fields gvkey, counterparty_gvkey, year, DATEANN, unwanted and history M&A event years matching the 1989–2014 panel; exact construction and coverage unverified.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_MNA_WLINKS_SIC
Evidence: E_SRC_Y_L149, E_SRC_PART2_L598, E_SRC_PART2_L1

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_MNA_WLINKS_SIC with bounded metadata.
2. Compare the actual required fields gvkey, counterparty_gvkey, year, DATEANN, unwanted and keys with the source contract.
3. Validate M&A event years matching the 1989–2014 panel; exact construction and coverage unverified. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_CUST_RIVAL_SCORE: Resolve the remaining local compatibility checks for R_CUST_RIVAL_SCORE: $path/cust_rival_yr_score.dta (local, unverified): Part 2 consumes this author-named DTA, but no producer or exact compatible local/public source mapping appears in the supplied sequence. Confirm the exact table/member, required fields rgvkey, year and history Customer-rival firm-years over the construction period; population and history unresolved.; a catalog candidate or timeout alone does not establish availability or absence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CUST_RIVAL_SCORE
Evidence: E_SRC_PART2_L642, E_SRC_PART2_L1

Preparation / proposed procedure:

1. Check only the exact registered local candidate for R_CUST_RIVAL_SCORE with bounded metadata.
2. Compare the actual required fields rgvkey, year and keys with the source contract.
3. Validate Customer-rival firm-years over the construction period; population and history unresolved. during staging; keep any specific mismatch unresolved.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_TARIFF_SIC87: Acquire the documented R_TARIFF_SIC87 product from Yale/Peter Schott SIC87 U.S. trade data, documented Stata products. Yale/Peter Schott SIC87 U.S. trade data, documented Stata products: Yale author documentation supports SIC87 trade by year, imports, customs values, CIF charges and duties over 1972–2005. The source applies its stated SIC3/year aggregation; a byte-identical author filename is not required. Map the source measures to sic, year, customs value, CIF value, duties; record the selected release and verify Source uses 1989–2005; documented underlying product spans 1972–2005. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_TARIFF_SIC87
Evidence: E_SRC_PART2_L717, E_SRC_PART2_L720, E_SRC_PART2_L726, E_PUB_TARIFF_PRODUCT, E_PUB_TARIFF_COSTS, E_PUB_TARIFF_LAYOUT, E_PUB_TARIFF_DUTIES

Preparation / proposed procedure:

1. Acquire only the documented product at Yale/Peter Schott SIC87 U.S. trade data, documented Stata products and retain its release metadata.
2. Map the documented measures to sic, year, customs value, CIF value, duties without changing the author construction.
3. Validate Source uses 1989–2005; documented underlying product spans 1972–2005. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_ALP_CPC_NAICS_1997: Resolve the specific source or construction for R_ALP_CPC_NAICS_1997: ALP author CPC crosswalk page, NAICS 1997 product family (public, unverified): The author page documents CPC-to-NAICS crosswalks and the 1997 vintage. Exact target file headers and probability weights still need a bounded metadata check before applying the source's weighting step. Request or identify a compatible producer/source and field, key and history definition for cpc4, naics97_4, probability_weight; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ALP_CPC_NAICS_1997
Evidence: E_SRC_PART2_L11, E_PUB_ALP_NAICS, E_PUB_ALP_CPC

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_ALP_CPC_NAICS_1997 at the listed route(s).
2. If it exists, map cpc4, naics97_4, probability_weight and NAICS 1997 crosswalk; page identifies CPC crosswalk version 2209. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_ALP_CPC_NAICS_2002: Resolve the specific source or construction for R_ALP_CPC_NAICS_2002: ALP author CPC crosswalk page, NAICS 2002 product family (public, unverified): The author page documents CPC-to-NAICS crosswalks and the 2002 vintage. Exact target file headers and probability weights still need a bounded metadata check before applying the source's weighting step. Request or identify a compatible producer/source and field, key and history definition for cpc4, naics02_4, probability_weight; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ALP_CPC_NAICS_2002
Evidence: E_SRC_PART2_L26, E_PUB_ALP_NAICS, E_PUB_ALP_CPC

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_ALP_CPC_NAICS_2002 at the listed route(s).
2. If it exists, map cpc4, naics02_4, probability_weight and NAICS 2002 crosswalk; page identifies CPC crosswalk version 2209. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_ALP_CPC_NAICS_2007: Resolve the specific source or construction for R_ALP_CPC_NAICS_2007: ALP author CPC crosswalk page, NAICS 2007 product family (public, unverified): The author page documents CPC-to-NAICS crosswalks and the 2007 vintage. Exact target file headers and probability weights still need a bounded metadata check before applying the source's weighting step. Request or identify a compatible producer/source and field, key and history definition for cpc4, naics07_4, probability_weight; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ALP_CPC_NAICS_2007
Evidence: E_SRC_PART2_L41, E_PUB_ALP_NAICS, E_PUB_ALP_CPC

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_ALP_CPC_NAICS_2007 at the listed route(s).
2. If it exists, map cpc4, naics07_4, probability_weight and NAICS 2007 crosswalk; page identifies CPC crosswalk version 2209. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_KPSS_2020: Acquire the documented R_KPSS_2020 product from KPSS author repository current patent-level release KPSS_2025.csv. KPSS author repository current patent-level release KPSS_2025.csv: The current documented public panel provides patent IDs, PERMNO, issue dates and real-value fields over historical years used by this stage. Updated values can differ from the author-named 2020 file; the authored patent count and weighting logic are retained. Map the source measures to patent_num, permno, issue_date, xi_real; record the selected release and verify Historical patent years used in the construction; current documented release spans 1926–2025. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_KPSS_2020
Evidence: E_SRC_PART2_L155, E_PUB_KPSS_PERIOD, E_PUB_KPSS_XI, E_PUB_KPSS_DATES

Preparation / proposed procedure:

1. Acquire only the documented product at KPSS author repository current patent-level release KPSS_2025.csv and retain its release metadata.
2. Map the documented measures to patent_num, permno, issue_date, xi_real without changing the author construction.
3. Validate Historical patent years used in the construction; current documented release spans 1926–2025. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_FLUIDITY: Acquire the documented R_FLUIDITY product from Hoberg–Phillips Product Market Fluidity author data library. Hoberg–Phillips Product Market Fluidity author data library: Author documentation identifies the firm-year prodmktfluid measure and its GVKEY/year Compustat key. The route supports the source's documented text import and merge role. Map the source measures to gvkey, year, prodmktfluid; record the selected release and verify Author page documents overall coverage 1989–2023; source analysis sample 1989–2014. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_FLUIDITY
Evidence: E_SRC_PART2_L490, E_SRC_PART2_L497, E_PUB_HP_COVERAGE, E_PUB_FLUIDITY_FIELD

Preparation / proposed procedure:

1. Acquire only the documented product at Hoberg–Phillips Product Market Fluidity author data library and retain its release metadata.
2. Map the documented measures to gvkey, year, prodmktfluid without changing the author construction.
3. Validate Author page documents overall coverage 1989–2023; source analysis sample 1989–2014. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_VTNIC_BASIC10: Acquire the documented R_VTNIC_BASIC10 product from Fresard–Hoberg–Phillips VTNIC Basic 10% pairwise network. Fresard–Hoberg–Phillips VTNIC Basic 10% pairwise network: Author documentation describes the selected 10-percent pair-year directed network with GVKEY pair keys and vertscore, and annual coverage 1989–2021. Preserve the author-selected product and direction. Map the source measures to gvkey1, gvkey2, year, vertscore; record the selected release and verify Documented product spans 1989–2021; source sample is 1989–2014. during staging.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_VTNIC_BASIC10
Evidence: E_SRC_PART2_L594, E_SRC_PART2_L604, E_PUB_VTNIC_COVERAGE, E_PUB_VTNIC_10, E_PUB_VTNIC_FIELDS

Preparation / proposed procedure:

1. Acquire only the documented product at Fresard–Hoberg–Phillips VTNIC Basic 10% pairwise network and retain its release metadata.
2. Map the documented measures to gvkey1, gvkey2, year, vertscore without changing the author construction.
3. Validate Documented product spans 1989–2021; source sample is 1989–2014. before any author program is attempted.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_RSI_PATENT_FINAL: Resolve the specific source or construction for R_RSI_PATENT_FINAL: $path2/rsi_patent_20221124_final.dta (local, unverified): Part 2 creates rsi_patent_20221124.dta under its temp root, while Final reads this separate final-suffixed name under path2. A same-data path/filename staging step is plausible, but exact keys and schema are not established by the supplied output/consumer contract. Request or identify a compatible producer/source and field, key and history definition for sgvkey, srcdate, s_same_naics_patents_m; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RSI_PATENT_FINAL
Evidence: E_SRC_PART2_L367, E_SRC_FINAL_L208, E_SRC_PART2_L2, E_SRC_FINAL_L4

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_RSI_PATENT_FINAL at the listed route(s).
2. If it exists, map sgvkey, srcdate, s_same_naics_patents_m and Supplier-year rows aligned to the final sample; alias and coverage remain unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_PERCENT_SUPPLIER_YEAR: Resolve the specific source or construction for R_PERCENT_SUPPLIER_YEAR: $path2/percent_supplier_year.dta (local, unverified): The final stage reads this author-named DTA, but the supplied pipeline contains no producer or data-source definition for it. Request or identify a compatible producer/source and field, key and history definition for sgvkey, srcdate; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PERCENT_SUPPLIER_YEAR
Evidence: E_SRC_FINAL_L254, E_SRC_FINAL_L4

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_PERCENT_SUPPLIER_YEAR at the listed route(s).
2. If it exists, map sgvkey, srcdate and Supplier-year panel matching the final sample; field definition and history unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SAMPLE1217_5: Resolve the specific source or construction for R_SAMPLE1217_5: $path2/sample1217_5.dta (local, unverified): The supplied regression program consumes this distinct panel; the supplied final-data stage writes sample1217_4 but does not produce the exact sample1217_5 file. Request or identify a compatible producer/source and field, key and history definition for sgvkey, year, delta1_ws_tss_p_salecs_ln1, d_wanted3_3_sic3; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SAMPLE1217_5
Evidence: E_SRC_REG_L260, E_SRC_REG_L8

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_SAMPLE1217_5 at the listed route(s).
2. If it exists, map sgvkey, year, delta1_ws_tss_p_salecs_ln1, d_wanted3_3_sic3 and Exact sample construction and history are unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_SAMPLE0924_4_IND: Resolve the specific source or construction for R_SAMPLE0924_4_IND: $path2/sample0924_4_ind (local, unverified): The regression block reads this distinct sample, which the supplied final-data stage does not produce at the exact named path. Request or identify a compatible producer/source and field, key and history definition for sgvkey, year, csic3, log_wanted_3_csic3, ws_tss_p_salecs, sum_score; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SAMPLE0924_4_IND
Evidence: E_SRC_REG_L291, E_SRC_REG_L300, E_SRC_REG_L3

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_SAMPLE0924_4_IND at the listed route(s).
2. If it exists, map sgvkey, year, csic3, log_wanted_3_csic3, ws_tss_p_salecs, sum_score and Exact sample construction and history remain unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_TABLEA11_SAMPLE: Resolve the specific source or construction for R_TABLEA11_SAMPLE: $path2/tablea11sample20230105_4.dta (local, unverified): Part 5 consumes this named appendix sample; no producer appears in the supplied final-data source. Request or identify a compatible producer/source and field, key and history definition for sgvkey, year, log_wanted_3_sic3, cust_treat3, post; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TABLEA11_SAMPLE
Evidence: E_SRC_REG_L329, E_SRC_REG_L3

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_TABLEA11_SAMPLE at the listed route(s).
2. If it exists, map sgvkey, year, log_wanted_3_sic3, cust_treat3, post and Exact appendix sample construction and history unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_TABLEA12_SAMPLE: Resolve the specific source or construction for R_TABLEA12_SAMPLE: $path2/tablea12sample20221217_4.dta (local, unverified): Part 5 consumes this named appendix sample; no producer appears in the supplied final-data source. Request or identify a compatible producer/source and field, key and history definition for sgvkey, year, std_log_wanted_3_sic3, cust_treat2_1, post; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TABLEA12_SAMPLE
Evidence: E_SRC_REG_L336, E_SRC_REG_L3

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_TABLEA12_SAMPLE at the listed route(s).
2. If it exists, map sgvkey, year, std_log_wanted_3_sic3, cust_treat2_1, post and Exact appendix sample construction and history unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_DATA_R_TABLEA13_SAMPLE: Resolve the specific source or construction for R_TABLEA13_SAMPLE: $path2/tablea13sample20221229_4.dta (local, unverified): Part 5 consumes this named appendix sample; no producer appears in the supplied final-data source. Request or identify a compatible producer/source and field, key and history definition for sgvkey, year, log_wanted_3_sic3, cust_treat2, post, std_supplier_tss; do not infer absence or licensing from an unverified route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TABLEA13_SAMPLE
Evidence: E_SRC_REG_L342, E_SRC_REG_L3

Preparation / proposed procedure:

1. Confirm whether a compatible prepared product or producer exists for R_TABLEA13_SAMPLE at the listed route(s).
2. If it exists, map sgvkey, year, log_wanted_3_sic3, cust_treat2, post, std_supplier_tss and Exact appendix sample construction and history unresolved. to the author construction.
3. If no compatible route is identified, request the exact input or full producer/definition from the package owner; do not substitute another panel or reconstruct it independently.

Validation to perform later:

- Use bounded metadata and field/key checks against the supported route. Preserve the author variables, windows and construction; do not run author code as part of this preparation action.

### A_RUN_ORDER_CYCLE: Use a controlled interleaved run procedure for the Part 2/Final cycle: run Part 2 through the pre-sample1217 work, run Final through the sample1217 producer at line 36, resume Part 2 at its sample1217 consumer at line 616 through its remaining construction, then resume Final from line 43. Preserve the supplied analyses and validate the handoff before the regression stage.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PART2_PART4_CYCLE
Evidence: E_SRC_PART2_L616, E_SRC_FINAL_L36, E_SRC_FINAL_L43, E_DEP_INDEX

Preparation / proposed procedure:

1. Create controlled stage segments at the source-supported cut points without changing formulas or samples.
2. Run Part 2 through the work preceding its sample1217 read.
3. Run Final through the sample1217 producer, then resume Part 2 at the sample1217 consumer and complete its remaining output.
4. Resume Final from line 43 and validate the staged merge keys and expected outputs before regression.

Validation to perform later:

- Confirm each consumer runs only after its exact producer and compare the produced fields/keys with the next source stage; no programs were run for this assessment.

### A_APPENDIX_INPUTS: Request the five distinct prepared regression/appendix inputs or their complete author construction steps, field definitions, keys and periods. Keep each appendix sample separate from sample1217_4 and from the other dated samples.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_APPENDIX_REGRESSION_INPUTS, R_SAMPLE1217_5, R_SAMPLE0924_4_IND, R_TABLEA11_SAMPLE, R_TABLEA12_SAMPLE, R_TABLEA13_SAMPLE
Evidence: E_SRC_REG_L260, E_SRC_REG_L291, E_SRC_REG_L329, E_SRC_REG_L336, E_SRC_REG_L342, E_SRC_FINAL_L239

Preparation / proposed procedure:

1. Ask for each exact regression input and its producer, key fields, period and intended sample definition.
2. If supplied, stage each file under the exact $path2 name consumed by the regression program.
3. Validate each product separately; do not replace an appendix or sample variant with the main sample.

Validation to perform later:

- Confirm all five exact products and their source-defined fields/periods before the regression stage.

### A_SOFTWARE_SETUP: Confirm a configured SAS runtime for the SAS stages and install or configure the missing Stata 18 command entry points asgen, winsor2 and rangejoin. Keep the available Stata commands and the _gnvals provider as recorded. No package installation or author-code trial is included here.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_ASGEN, SW_WINSOR2, SW_RANGEJOIN, I_SAS_RUNTIME_UNVERIFIED
Evidence: E_ENVIRONMENT, E_PROBE_S34, E_SW_ASGEN, E_SW_WINSOR2, E_SW_RANGEJOIN, E_SW_GNVALS, E_SW_UNIQUE, E_SW_REGHDFE, E_SW_ESTPOST, E_SW_ESTTAB, E_SW_ESTADD, E_SW_COEFPLOT

Preparation / proposed procedure:

1. Confirm SAS 9.4 runtime availability/configuration for the supplied SAS programs; do not treat the S34 timeout as absence evidence.
2. Install or configure asgen, winsor2 and rangejoin in Stata 18 through the site's normal software setup process.
3. After setup, check only the exact command entry points and retain the resulting software version metadata.

Validation to perform later:

- Confirm required runtime and command entry points using version/which metadata checks only; do not trial author functions or run author programs during setup assessment.

### A_KPSS_VERSION_CLARIFICATION: Stage the verified documented KPSS_2025 route for the required patent fields and years, recording the selected release. Compare its values with the author-named 2019/2020 vintage when a comparison reference is available, and report value revisions as a reproduction-fidelity check; do not make historical-byte identity a precondition for compatible acquisition or alter patent construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_KPSS_UPDATED_VALUES, R_KPSS_2019, R_KPSS_2020
Evidence: E_PUB_KPSS_PERIOD, E_PUB_KPSS_XI, E_PUB_KPSS_DATES, E_SRC_PART1_L266, E_SRC_PART2_L155

Preparation / proposed procedure:

1. Record the documented KPSS_2025 release selected for the author-named 2019 and 2020 stages.
2. Stage the documented patent identifiers, PERMNO, dates, citation and innovation fields without changing source-defined filters, counts or weights.
3. Compare value-level fidelity with the intended historical vintages when reference values are available; report any revisions without silently substituting values or changing construction.

Validation to perform later:

- Check that the selected documented release covers the source-required fields and patent periods. Treat vintage/value comparison as later reproduction validation, not as a gate to the already-supported compatible acquisition route.

### A_FULL_PIPELINE_RUN: After compatible inputs and software are prepared, attempt the complete seven-program scope in source order, including the interleaved Part 2/Final stages and all supplied regression appendix branches. Preserve all author transformations, variables, windows and analyses.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_HANDOFF_CLOSURE, I_PART2_PART4_CYCLE, I_APPENDIX_REGRESSION_INPUTS, I_SAS_RUNTIME_UNVERIFIED, I_KPSS_UPDATED_VALUES
Evidence: E_README_SCOPE, E_DEP_INDEX, E_SRC_RAW_L18, E_SRC_X_L7, E_SRC_Y_L13, E_SRC_PART1_L10, E_SRC_PART2_L1, E_SRC_FINAL_L3, E_SRC_REG_L8, E_SRC_FINAL_L36, E_SRC_PART2_L616, E_SRC_REG_L260

Preparation / proposed procedure:

1. Stage verified compatible routes; resolve the specifically unknown producers and runtime, and record KPSS vintage/value fidelity as preparation validation where needed.
2. Run the raw SAS stage, then X and Y construction, then Part 1; retain the required shared outputs.
3. Follow the Part 2/Final interleaving in A_RUN_ORDER_CYCLE and validate each producer-consumer handoff.
4. Run the regression program for the main and appendix analyses only after all corresponding prepared samples are supplied.

Validation to perform later:

- Check required inputs, software and exact handoff order before each stage; then compare output fields, keys, sample windows and reported analyses with the author materials. This procedure was not executed during the assessment.


## Remaining issues and prerequisites

- I_HANDOFF_CLOSURE [unresolved; full_pipeline]: Several later inputs still have unresolved producers or exact product mappings: Part 2 consumes compa_temp.dta at two stages with no supplied producer; Part 4 consumes percent_supplier_year.dta with no supplied producer; Part 2 requests Ctmp7_20221121.dta while Part 1 exports Ctmp7_20221217.dta; and Part 2 produces rsi_patent_20221124.dta while Final consumes rsi_patent_20221124_final.dta. Keep these as specific unresolved handoffs pending an author mapping or compatible producer. The raw-produced same-name compa78_20_20220410, seg20221120, sample_mna_20221217 and SC6_sic3 products have supported format/library staging routes and are not separate missing-data requirements.
- I_PART2_PART4_CYCLE [unresolved; full_pipeline]: Part 2 reads $path2/temp/sample1217.dta after the point where Final creates that sample, while Final also continues to use the Part 2 outputs. The source supports an interleaved order: run Part 2 through its pre-sample1217 section, run Final through its sample1217 producer, resume Part 2 after the sample1217 read through its remaining construction, then resume Final from line 43. Do not run either complete script in a single linear pass until this split is implemented and validated.
- I_APPENDIX_REGRESSION_INPUTS [unresolved; full_pipeline]: The regression program consumes sample1217_5.dta, sample0924_4_ind, tablea11sample20230105_4.dta, tablea12sample20221217_4.dta and tablea13sample20221229_4.dta. The supplied Final program produces sample1217_4.dta but does not establish producers for these distinct regression inputs. Preserve the appendix analyses and request their prepared files or complete construction steps; do not substitute the main sample or infer these files are absent locally.
- I_SAS_RUNTIME_UNVERIFIED [unresolved; full_pipeline]: The complete workflow includes SAS preparation and construction stages, but the fixed-typed environment result leaves SAS unverified. The bounded TFN.S34 read timed out and does not establish SAS absence or dataset absence. Confirm a configured SAS runtime before attempting the SAS stages; no software was installed and no author program was run.
- I_KPSS_UPDATED_VALUES [preparation; full_pipeline]: The documented KPSS_2025 public product supplies the required patent identifiers, dates, citation and innovation fields over the historical years used by Part 1 and Part 2, so acquisition and staging are supported. Its values may differ from the author-named 2019/2020 vintages. Record the selected release and compare value-level fidelity with the intended historical vintage when that reference is available; report any revisions without changing the authored filters, counts, weights or construction. Treat this as reproduction validation/preparation, not an unresolved acquisition or execution barrier. No specific missing required field or patent period is established by the saved documentation.
- I_GENERATED_HANDOFF_STAGING [preparation; full_pipeline]: Prepare the source-generated Compustat 20220410 panel in the Stata DTA and persistent SAS forms, the raw-produced seg20221120 SAS handoff, the single sample_mna_20221217 panel in SAS and DTA forms, and the Y-produced SC6_sic3 handoff for their named downstream consumers. The supplied producer and consumer lines support these same-product edges. Format conversion and library/root staging are preparation tasks rather than separate external-data requirements; validate the source-defined consumer fields and relevant periods as part of those transformations.
- R_SEG1208 [undetermined]: Prebuilt supplier–customer-year panel consumed by X, Y and Part 2 in different language/file-format stages. The raw program creates differently named segment intermediates; it does not establish this exact seg1208 panel, its schema or a supported alias.
- R_TNIC3 [public_acquisition_required]: Hoberg–Phillips TNIC3 similarity and HHI firm-year measures used by X and Part 2 to construct supplier/customer similarity and concentration variables.
- R_SDC_MNA_DETAILS [undetermined]: First SDC deal-level table read by the raw stage to construct transaction identifiers and event dates.
- R_SDC_MNA [undetermined]: Second independently consumed SDC deal-level table; it is distinct from mna_details until a supported source contract proves otherwise.
- R_PERMNONCUSIP [undetermined]: CUSIP-to-PERMNO mapping referenced separately in the M&A and institutional ownership branches.
- R_TFN_S34 [undetermined]: Thomson/Refinitiv S34 13F holdings rows used to create the institutional holdings panel.
- R_PERM_II2 [undetermined]: Persistent PERM.II2 holdings table consumed in the institutional-ownership branch. The saved source contract shows the PERM.II2 consumer and a separate DATA.II4 output from ii4, but does not establish that the upstream WORK.ii2 construction is persisted as this same product or prove its complete field/key/history contract. Keep this as a distinct requirement pending an explicit producer-to-consumer product mapping; do not infer identity from the basename.
- R_KPSS_2019 [public_acquisition_required]: Patent-level KPSS data consumed by Part 1 for patent identifiers, issue/filing dates, citation counts and innovation values.
- R_EDGAR_PC [undetermined]: Author-prepared SEC filing redaction/trade-secret input merged to supplier–customer rows in Part 1.
- R_II5 [undetermined]: Persistent 13F ownership panel ii5 consumed by Part 1; the raw program's visible output is ii4, not ii5.
- R_FIN_MNA [undetermined]: Institutional financial-merger list used in Part 1 to identify treatment events and manager numbers.
- R_JV_ALLIANCE [undetermined]: Author-prepared joint-venture/alliance event file imported by Part 1 to build supplier/customer RSI measures.
- R_SWITCH [undetermined]: Prepared supplier/customer switch panel merged into Part 1 by supplier and source date.
- R_SWITCH_SIC3 [undetermined]: Distinct prepared SIC3 customer-switch panel merged separately into Part 1.
- R_PATENT_CPC_LINK [undetermined]: Patent-to-CPC grouping link used by Part 2 to construct patent-based supplier/customer relatedness.
- R_PATENT_GRANT_DATE [public_acquisition_required]: Patent issue/grant-date table joined to the patent/CPC input by patent identifier.
- R_CTMP7_20221121 [undetermined]: Earlier CTMP7 supplier–customer-year panel required by Part 2 for patent and tariff construction.
- R_COMPA_TEMP [undetermined]: Compustat firm-date table compa_temp.dta read by Part 2 to attach customer SIC information.
- R_MNA_WLINKS_SIC [undetermined]: Stata M&A-with-links-SIC DTA consumed by the Part 2 vertical-M&A branch.
- R_CUST_RIVAL_SCORE [undetermined]: Prepared customer-rival-year scores consumed by Part 2 to build rival-weighted customer competition measures.
- R_TARIFF_SIC87 [public_acquisition_required]: SIC87 import values, CIF charges and duties used to construct SIC3-year tariff cuts and post indicators.
- R_ALP_CPC_NAICS_1997 [undetermined]: CPC4-to-1997-NAICS probabilistic crosswalk used before 2002 in Part 2 patent construction.
- R_ALP_CPC_NAICS_2002 [undetermined]: CPC4-to-2002-NAICS probabilistic crosswalk used for patent construction from 2002 through 2006.
- R_ALP_CPC_NAICS_2007 [undetermined]: CPC4-to-2007-NAICS probabilistic crosswalk used from 2007 onward in Part 2 patent construction.
- R_KPSS_2020 [public_acquisition_required]: Patent-level KPSS input used in Part 2 to count grants by firm/year and CPC class.
- R_FLUIDITY [public_acquisition_required]: Hoberg–Phillips firm-year product-market fluidity measure used to construct customer-industry controls.
- R_VTNIC_BASIC10 [public_acquisition_required]: Directed 10-percent-granularity firm-pair vertical-relatedness network used in the Part 2 vertical-M&A branch.
- R_RSI_PATENT_FINAL [undetermined]: Final patent-relatedness DTA merged by the final dataset stage.
- R_PERCENT_SUPPLIER_YEAR [undetermined]: Supplier-year percentage control merged in Final construction; no producer is present in the seven supplied programs.
- R_SAMPLE1217_5 [undetermined]: Separate sample1217_5 panel consumed by the Table 7 Panel B regression block.
- R_SAMPLE0924_4_IND [undetermined]: Separate industry-level panel consumed by Table A1.
- R_TABLEA11_SAMPLE [undetermined]: Table A3 column 1 regression sample, a distinct appendix input.
- R_TABLEA12_SAMPLE [undetermined]: Table A3 column 2 regression sample, distinct from the other appendix samples.
- R_TABLEA13_SAMPLE [undetermined]: Table A3 column 3 regression sample, distinct from the other appendix samples.
- SW_SAS [unverified]: SAS is required by the raw and Y and Part 1 programs; the fixed typed environment result leaves SAS unverified. The TFN.S34 one row metadata timeout is a read limitation, not a software availability result.
- SW_ASGEN [preparation_required]: The actual Stata 18 which check found no asgen command entry point. Install or configure the required add on before attempting the author programs; no installation or function trial was performed.
- SW_WINSOR2 [preparation_required]: The actual Stata 18 which check found no winsor2 command entry point. Install or configure the required add on before attempting the author programs; no installation or function trial was performed.
- SW_RANGEJOIN [preparation_required]: The actual Stata 18 which check found no rangejoin command entry point. Install or configure the required add on before attempting the author programs; no installation or function trial was performed.

## Review notes

- The assessed target is the complete seven-program full_pipeline: raw SAS preparation, X and Y construction, Part 1 and Part 2 controls/patent work, Final construction and all supplied regression branches. No separate analysis_only scope is supported by a complete author-prepared analysis-data route.
- All 86 frozen dependency IDs are covered in grouped logical-contract reviews. The raw-produced Compustat, seg20221120, single sample_mna_20221217 and Y-produced SC6_sic3 products have generated dispositions with no data-requirement targets; their format/library staging is captured as a preparation issue and action. The two sample_mna formats are one logical panel. Ctmp7_20221121 and Ctmp7_20221217 remain distinct dated products; the RSI patent suffix mapping remains unresolved.
- Full readiness remains undetermined because compa_temp.dta and percent_supplier_year.dta have no supplied producer, the Ctmp7 and RSI-patent outputs need exact mapping, five appendix/regression inputs have no supplied producer, and Part 2/Final require an interleaved order. The SAS runtime is unverified and asgen, winsor2 and rangejoin need setup. Each gap has a linked action.
- Resource evidence uses a few targeted frozen-catalog and bounded metadata checks. One-row field success supports compatible local candidates; unsampled history/population is retained as later validation rather than evidence of absence. The TNIC3 author documentation supports the public measure/key route without requiring payload-byte or exact-header identity. KPSS_2025 is a compatible documented public route; vintage/value fidelity comparison is preparation validation, while no specific required field or historical period is shown missing.
- The Stata environment result reports Stata 18; SAS remains unverified. Direct Stata entry-point checks support the available commands and _gnvals provider; missing command entry points are preparation tasks. No installations, author-program runs, dataset/model/formula trials, data/model/archive payload downloads, or original-source edits were performed.
- Author logs and raw environment, authentication, connection and diagnostic fields remained opaque. Source lines were displayed only through the byte-first screened reader; withheld source ranges are not treated as absent code or inputs. No protected common README connection-detail source was accessed.
