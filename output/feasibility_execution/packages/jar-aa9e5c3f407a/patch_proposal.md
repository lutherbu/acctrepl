# Patch proposal: jar-aa9e5c3f407a

Transmission Effects of ESG Disclosure Regulations through Bank Lending Networks

DOI: 10.1111/1475-679X.12478

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The assessed target is the complete set of four supplied SAS constructor programs and their documented output endpoints: bank-firm, exposure, ESG and controls. Run bank-firm before exposure; ESG and controls are separate supplied branches. The datasheet also records historical Stata/Perl use, but no supplied final consumer, driver or output contract makes those unreleased programs mandatory to run these four constructors. Reproduction of final paper analysis/text results remains an explicit package limitation.

Entry points: `LW_Bank_Firm_Construct.sas`, `LW_Bank_Exposure_Construct.sas`, `LW_Bank_ESG_Construct.sas`, `LW_Bank_Variable_Construct.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 3/12478 - Transmission-Effects-of-ESG-Disclosure-Regulations-through-Bank-Lending-Networks/lw-datasheet-code-and-identifiers.zip",
      "sha256": "0b500857e1c16fe81b730388df558f1a2cda6395e105bf31fcda6841450727cb"
    },
    {
      "path": "JAR-Volume 61/Issue 3/12478 - Transmission-Effects-of-ESG-Disclosure-Regulations-through-Bank-Lending-Networks/lwanginternetappendix.pdf",
      "sha256": "ca761b281a8048b1f6e84a802f72e2241594ae9dc7fc1355ca3c9ea2ec5eeabc"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "1fb6206b6d67d9709d08083d07feab6a0ef2ae0727adfb601377b8da79cb94f8"
}
```

## Proposed actions

### ACT_DEALSCAN_INPUTS: Restore the four author-prepared DealScan project tables and verify their matched fields and coverage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_DEALSCAN
Evidence: SRC_DS_DEALSCAN, SRC_BANKFIRM_DEALSCAN_FACILITY, SRC_BANKFIRM_DEALSCAN_PACKAGE, SRC_BANKFIRM_DEALSCAN_LENDERS, SRC_BANKFIRM_DEALSCAN_COMPANY, CATALOG_LOOKUP_PRODUCTS, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Use the author's authorized project library or supplied prepared extract as the primary route; do not equate the catalog's DEALSCAN.* candidates with the four project.tfn_* inputs without schema and vintage evidence.
2. Confirm facility/package/lender/company identifiers and attributes listed in the four route contracts, including facility dates/amount/exchange rate, borrower/package fields, lead-arranger and lender-role fields, and company country/type/SIC fields.
3. Retain the supplied US syndication filter, 1987–2018 fiscal-year link window, lender-role exclusions, joins and facility maturity expansion; document the exact available history before a separate run.

Validation to perform later:

- After the author-prepared tables are available, compare each bounded schema and documented date coverage with its route contract and record any needed history before invoking the constructors.

### ACT_LINKTABLE_INPUT: Recover the author-prepared borrower-facility LINKTABLE contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_LINKTABLE
Evidence: SRC_BANKFIRM_LINKTABLE, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Obtain the exact project.LINKTABLE input or its data dictionary and producer/matching specification; keep it as the author-prepared primary route.
2. Confirm GVKEY, BCOID, CONAME_H, FACID/FACILITYID, FACSTARTDATE and FIC and document the covered borrower/facility years and key rules; do not substitute an inferred generic link table.

Validation to perform later:

- Once recovered, verify the stated fields, identifier types and date coverage against the bank-firm code before any construction run.

### ACT_COMPUSTAT_INPUTS: Restore both distinct author-prepared Compustat project tables and verify their code-specific contracts, including the later analyst-merge namespace.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_COMPUSTAT
Evidence: SRC_DS_COMPUSTAT, SRC_BANKFIRM_COMPUSTAT, SRC_VARIABLE_CONTROL_SELECT, SRC_VARIABLE_INST_OWNERSHIP, CATALOG_LOOKUP_PRODUCTS, INSPECT_TRACE_003, SRC_VARIABLE_IBES_STAR_JOIN

Preparation / proposed procedure:

1. Recover project.funda1970_2018 and project.funda_1990_2018 from the author's authorized project data route; treat COMP.FUNDA only as a catalog candidate, not as either verified prepared table.
2. Check the link-table contract (GVKEY/CUSIP/CIK/DATADATE/FYEAR/LOC and format/population/consolidation fields) for fiscal years 1987–2018 and DATADATE from 1975 onward; check the controls fields and 1990–2018 / 1975+ filters separately.
3. For ISSUE_PERMNO_PROJECTION, inspect project.funda_1990_2018, project.numanalyst and project.inst_ownership, then determine whether the post-IBES WORK.funda namespace contains the intended PERMNO. Only if it does not, and the exact source contains a compatible key, propose a conditional same-data pass-through; otherwise obtain the author's intended mapping.

Validation to perform later:

- After recovery, verify each Compustat table's fields and date history separately; trace the actual post-IBES WORK.funda namespace and confirm any key repair only against exact source schemas.

### ACT_ASSET4_WORKBOOK: Restore the author-prepared 29-sheet Asset4 workbook and preserve the active import and reshape contract.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_ASSET4
Evidence: SRC_DS_REFINITIV, SRC_ESG_MACRO_IMPORT, SRC_ESG_TRANSPOSE_LOOP, SRC_ESG_MACRO_CALL, SRC_ESG_PROJECT_OUTPUT, CATALOG_LOOKUP_PRODUCTS, CATALOG_LOOKUP_ALIASES, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Restore Asset4_global.xlsx from the author's authorized product/prepared-data route at the configured working-copy input location corresponding to the ordinary author-relative filename.
2. Confirm sheets 1–29, the sheet-1 TYPE/WC06004 identifiers, and the NAME/CODE plus _002–_018 columns on sheets 2–29 expected by the active macro; preserve the SAS import options and annual labels.
3. Keep the loop output and downstream project.ASSET4_GLOBAL / Stata export relationship intact; generic Refinitiv ESG catalog tables are not a replacement for this workbook.

Validation to perform later:

- Before a separate SAS run, inspect the workbook's sheet names, headers and year labels without recalculation or macro execution, and document the actual annual coverage.

### ACT_BANKFOCUS_INPUTS: Restore the two author-prepared BankFocus project tables and verify their field/history contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_BANKFOCUS
Evidence: SRC_DS_BANKFOCUS, SRC_EXPOSURE_BANKFOCUS_OVERVIEW, SRC_EXPOSURE_BANKFOCUS_STOCK, CATALOG_LOOKUP_PRODUCTS, CATALOG_LOOKUP_ALIASES, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Use the author's authorized project library or prepared extract for project.obf_overview and project.obf_stock_info; the frozen catalog's BankFocus/Bureau van Dijk misses are not evidence of no license or access.
2. Verify the overview identifier/listing fields and stock-table employee, market-cap, IPO-year and delisting-year fields, including non-US bank coverage and alignment to the relationship panel.
3. Retain the datasheet's Jan 2020 source vintage as provenance; establish actual field history and population from the prepared files rather than inferring it from catalog labels.

Validation to perform later:

- After recovery, verify both schemas and their joined BVDIDNUM coverage against the author crosswalk and exposure source contract.

### ACT_BANK_CROSSWALK: Restore the exact manually prepared lender-to-BvD crosswalk consumed by the exposure branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_BANK_CROSSWALK
Evidence: SRC_EXPOSURE_MANUAL_BANK_MAP, SRC_DS_DEALSCAN, SRC_DS_BANKFOCUS, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Restore bank_cntry_manual.csv from the author's authorized prepared files and place it at the matching input path in a separate portable working copy; the ordinary author-relative path is configuration, not an access gate.
2. Preserve the author's matching output and verify LENDERID, BANKNAME, GVKEY, BVDIDNUM, BANK_COUNTRY and US fields used by the code; do not independently rematch banks.

Validation to perform later:

- After recovery, check headers, lender/BVD identifiers and match coverage against the exact BankFocus tables before construction.

### ACT_REGULATION_MAPPING: Restore the author-prepared country/year regulation mapping consumed by exposure construction.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_REGULATION_MAP
Evidence: SRC_DS_REGULATIONS, SRC_EXPOSURE_REGULATION_MAP, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Restore Identification.csv from the author's authorized prepared files at the matching working-copy input location.
2. Verify CTRYCODE, YEAR, TREATED and CTRY, the country/year population and the treatment coding used by the constructor; do not regenerate the mapping from the historical source list unless the missing program identifies that work as required.

Validation to perform later:

- After recovery, compare its countries/years/coding to the bank-panel exposure window and preserve the prepared mapping provenance.

### ACT_IBES_INPUT: Restore and verify the author-prepared analyst-following table.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_IBES
Evidence: SRC_DS_IBES, SRC_VARIABLE_IBES, CATALOG_LOOKUP_PRODUCTS, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Recover project.numanalyst or its documented author-prepared equivalent; do not treat general IBES catalog hits as proof of this derived table.
2. Confirm GVKEY, FYEAR and ANALYSTFOLLOW and the 1990–2018 fiscal-year coverage used by the controls constructor.

Validation to perform later:

- After recovery, check the schema, GVKEY/FYEAR key types and coverage against the filtered controls sample before merging.

### ACT_13F_OWNERSHIP: Restore and verify the author-prepared institutional-ownership table used by the controls constructor.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_13F
Evidence: SRC_DS_13F, SRC_VARIABLE_INST_OWNERSHIP, CATALOG_LOOKUP_PRODUCTS, CATALOG_LOOKUP_ALIASES, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Recover project.inst_ownership and its author-prepared mapping from Thomson/Refinitiv 13F holdings; TFN.S34 is a catalog discovery candidate, not proof that it supplies this table's PERMNO/YEAR/IOR schema.
2. Confirm PERMNO, YEAR and IOR fields and annual coverage aligned to controls FYEAR 1990–2018; coordinate the PERMNO key with the unresolved post-IBES WORK.funda namespace contract.

Validation to perform later:

- After recovery, verify the ownership schema, identifier type and annual coverage against the exact controls projection and merge contract.

### ACT_SAS_RUNTIME_SETUP: Prepare a separate SAS working environment for the four constructors without starting SAS in this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: SRC_DS_LANGUAGES, SRC_DS_PROVIDED_PROGRAMS, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Use the machine's documented SAS 9.4 executable/options for a later authorized run; configure the project libref to the chosen portable data root and keep it consistent across the bank-firm and exposure stages.
2. Confirm the installed SAS/ACCESS support needed for DBMS=EXCEL imports and DBMS=STATA exports, plus WORK and distinct output destinations; no SAS process or author program was started here.

Validation to perform later:

- Before any separate run, confirm runtime and required import/export engine availability through a permitted software check and review the portable library/output mapping.

### ACT_DSFUL_HANDOFF: Persist the finalized bank-firm loan table for the exposure constructor using the exact producer/consumer order.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISSUE_DSFUL_HANDOFF
Evidence: SRC_BANKFIRM_WORK_DSFUL, SRC_BANKFIRM_DSFUL_FILTER, SRC_EXPOSURE_DSFUL_INPUT, INSPECT_TRACE_003

Preparation / proposed procedure:

1. With the bank-firm inputs and project libref configured, run LW_Bank_Firm_Construct.sas first and retain its finalized WORK.ds_ful_bank after the non-US-bank filters at line 122.
2. Before running LW_Bank_Exposure_Construct.sas (which clears WORK at its start), copy that same table to project.ds_ful_bank in the same configured project library; do not rebuild or alter its observations.
3. Keep the already persisted project.bank_firm_panel in the same project library for exposure's line-139 consumer.

Validation to perform later:

- Confirm project.ds_ful_bank exposes GVKEY, LENDERID, CYEAR, ENDYEAR, FACILITYAMT and FACILITYID from the finalized producer output and that both producer outputs are visible before exposure starts.

### ACT_PERMNO_CONTRACT: Resolve the final post-IBES controls namespace and ownership key against the exact author-prepared schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_PERMNO_PROJECTION
Evidence: SRC_VARIABLE_CONTROL_SELECT, SRC_VARIABLE_IBES, SRC_VARIABLE_IBES_STAR_JOIN, SRC_VARIABLE_INST_OWNERSHIP, INSPECT_TRACE_003

Preparation / proposed procedure:

1. Inspect the exact schemas for project.funda_1990_2018, project.numanalyst and project.inst_ownership from an authorized prepared-file dictionary or bounded metadata route.
2. Trace the WORK.funda result after the GVKEY/FYEAR SELECT * join to WORK.numanalyst; do not infer its columns from the initial Compustat projection alone.
3. If the post-IBES WORK.funda namespace has a unique compatible PERMNO, retain/use that key. If not, and the exact Compustat source contains the intended key, propose a conditional same-data pass-through; if no compatible key is supported, obtain the author's mapping rather than guessing one.

Validation to perform later:

- Confirm the final post-IBES left table and project.inst_ownership use the same intended identifier with compatible type/meaning and years before the controls constructor is run.

### ACT_REMOVE_UNUSED_SAMPLE_LOAN_SORT: Propose removing only the unproduced, unconsumed sample_loan sort from the separate working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_SAMPLE_LOAN_REFERENCE
Evidence: SRC_EXPOSURE_SAMPLE_LOAN, INSPECT_TRACE_003

**Proposed edit:** `LW_Bank_Exposure_Construct.sas:197–197`
Source SHA-256: `06ed06b706fbb2c44c40802da7558a8faecd9b32501395512245828cc29e2abf`

WORK is cleared at program start; no supplied constructor produces sample_loan and no later statement consumes the sorted output. Removing this single line preserves the supplied constructor endpoints without changing data, samples or measures. The historical reason for the line remains unknown.

Current text:
```
proc sort data = sample_loan;by gvkey year;run;
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. In a separate working copy remove only the line-197 statement shown above; do not add a replacement data read or change any other source line.

Validation to perform later:

- Review the working-copy diff to confirm it contains only the one-line deletion, and confirm by source inspection that no supplied producer or later consumer depends on sample_loan. No author code was run or edit applied in this assessment.

### ACT_PORTABLE_OUTPUTS: Give each supplied Stata export a distinct stable working-copy path and configure shared library/input roots.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_OUTPUT_PATHS
Evidence: SRC_EXPOSURE_EXPORT, SRC_ESG_EXPORT, SRC_VARIABLE_EXPORT, INSPECT_TRACE_003

Preparation / proposed procedure:

1. In the separate working copy set the project libref to one chosen portable data root and configure the three ordinary author-relative input paths to their prepared workbook/CSV locations; this is path setup, not a data-access finding.
2. Replace the three identical relative export destinations with distinct stable names reflecting the produced tables, such as sample_firm.dta, asset4_global.dta and funda_controls.dta, in separate output paths if needed.
3. When the final Stata driver is recovered, map these outputs to its actual import paths without changing samples, variables or estimators.

Validation to perform later:

- Before a separate run, confirm that the three export destinations resolve to distinct files and match the recovered Stata driver's input references.


## Remaining issues and prerequisites

- ISSUE_DSFUL_HANDOFF [preparation; full_pipeline]: The bank-firm constructor creates WORK.ds_ful_bank and then applies the non-US-bank filters; the exposure constructor later reads project.ds_ful_bank after clearing WORK. The consumer's fields are produced in that same finalized table. In the portable working copy, persist that same table to the configured project library after the filter and before starting exposure.
- ISSUE_PERMNO_PROJECTION [unresolved; full_pipeline]: The initial explicit project.funda_1990_2018 SELECT omits PERMNO. However, the code then loads project.numanalyst and performs a left join with SELECT * on GVKEY/FYEAR before the ownership join; that uninspected namespace may add PERMNO. The final post-IBES WORK.funda namespace and same-entity key contract are unknown. Do not claim PERMNO is present or absent, or label the later join defective, until the exact input schemas and constructed namespace are confirmed.
- ISSUE_SAMPLE_LOAN_REFERENCE [preparation; full_pipeline]: Line 197 sorts WORK.sample_loan after WORK is cleared at program entry. No supplied constructor produces it and no later statement consumes or exports the sort result. For the four supplied constructor outputs, this one-line sort has no supported role; its removal in a separate working copy is a same-output cleanup. The original reason for the line remains unknown, but author confirmation or a separate research-data requirement is not needed to preserve the supplied endpoints.
- ISSUE_OUTPUT_PATHS [preparation; full_pipeline]: Exposure, ESG and controls each export a Stata file to the same literal relative path ~.dta, so sequential runs in the same cwd can overwrite earlier outputs. In a portable working copy assign distinct stable names based on the actual produced tables and reconcile their paths with the downstream driver when recovered.
- REQ_DEALSCAN [undetermined]: The bank-firm constructor consumes project.tfn_facility, project.tfn_package, project.tfn_lendershares and project.tfn_company. It filters US syndications, joins facilities/packages/lender-company records, applies lender-role filters, and uses relationship dates and amounts in the bank-firm panel. The frozen catalog has DEALSCAN facility/package/lendershares/company candidates, but they do not verify the schema, vintage, history or equivalence of the author project tables.
- REQ_LINKTABLE [undetermined]: project.LINKTABLE is consumed to link GVKEY, BCOID, borrower name, FACID (renamed FACILITYID), FACSTARTDATE and FIC. The code derives year from FACSTARTDATE and deduplicates by facility/GVKEY. The table's producer, exact matching method and covered borrower/facility history are not specified.
- REQ_COMPUSTAT [undetermined]: Two distinct author project inputs are consumed: project.funda1970_2018 for borrower location/identity matching and project.funda_1990_2018 for controls. Preserve their separate filters and selected fields. The initial controls SELECT omits PERMNO, but a later SELECT * join to the uninspected project.numanalyst namespace may add it; the final controls key/schema contract remains unknown. The frozen catalog returns COMP.FUNDA as a candidate, not as proof of either author-prepared table.
- REQ_ASSET4 [undetermined]: The active IMPORT macro reads Asset4_global.xlsx sheets 1–29; sheets 2–29 are reshaped from year columns and merged by TYPE to sheet 1 identifiers. The generated table is persisted as project.ASSET4_GLOBAL and exported. The workbook and its full sheet, field and historical coverage contract are not in the package.
- REQ_BANKFOCUS [undetermined]: The exposure constructor consumes project.obf_overview and project.obf_stock_info for non-US BankFocus identifiers, listing/exchange attributes, employee and market-cap fields, and IPO/delisting years. The tables and coverage are not in the package.
- REQ_BANK_CROSSWALK [undetermined]: bank_cntry_manual.csv is an actual consumed author-prepared crosswalk linking DealScan lender IDs to BvD identifiers and bank attributes. The CSV is not in the package; its author-relative path is a portable-copy setup matter, while the file's contents and match coverage remain unverified.
- REQ_REGULATION_MAP [undetermined]: Identification.csv is an actual consumed author-prepared country/year regulation mapping. The code imports it, uses country code/year/treatment/country fields and joins it into the bank panel. Its population, coding and year coverage are not supplied.
- REQ_IBES [undetermined]: project.numanalyst supplies analyst-following information merged by GVKEY and FYEAR; ANALYSTFOLLOW is used in the controls. The author-prepared table and its mapping from I/B/E/S, fields and historical coverage are not included. Frozen catalog I/B/E/S hits are candidate source tables only, not this prepared table.
- REQ_13F [undetermined]: project.inst_ownership supplies IOR and is joined to controls on PERMNO and YEAR, where YEAR is matched to FYEAR. The short-name frozen-catalog query finds TFN.S34, labeled Thomson-Reuters 13F Holdings, but does not establish that raw candidate as the author-prepared ownership table or its IOR mapping.
- SW_SAS [unverified]: Required by all four supplied constructors. This assessment did not start SAS; runtime and the DBMS=EXCEL import / DBMS=STATA export engines are not verified here.

## Review notes

- The frozen title matches the supplied datasheet and appendix; no DOI appears in those author documents, so the work-item DOI is retained.
- The assessed target is all four supplied SAS constructors and their native endpoints/branches. The datasheet's Stata/Perl statements describe historical analysis/text methods; no supplied program or specific consumer/output contract makes those unreleased stages mandatory to run the constructors. Their absence and uncertainty about final paper-result reproduction remain explicit context, not an execution barrier or an inferred estimator.
- All 47 frozen dependency IDs remain reviewed across the four constructor branches. D0001 is the active Asset4 workbook read, D0002–D0032 are generated macro tables, and D0033–D0047 preserve the direct BankFocus/crosswalk/regulation, handoff, link, DealScan, Compustat, I/B/E/S and 13F inputs.
- The hash-bound frozen catalog results remain candidates only: DealScan, Compustat, I/B/E/S, Refinitiv ESG candidates and Thomson-Reuters TFN.S34 appear; BankFocus/Bureau van Dijk have no match. These results do not establish present access, license entitlement, exact prepared schemas, compatibility or coverage.
- The actually consumed bank_cntry_manual.csv and Identification.csv mappings, Asset4_global.xlsx workbook and the author project tables remain explicit inputs. Their ordinary author-relative paths are portable-copy setup. Historical GRI report texts, Dyreng segments, World Bank/WGI/ETH and manually matched SEC data stay contextual unless an actual consumer/output contract identifies their role.
- The controls SELECT initially omits PERMNO, but the subsequent SELECT * join to uninspected project.numanalyst precedes the ownership join and may introduce fields. The final post-IBES WORK.funda namespace/key is unknown; no presence, absence or proven defect is asserted. Any same-data pass-through or mapping repair is conditional on the actual schema.
- WORK.sample_loan is sorted once after WORK is cleared, with no supplied producer and no later consumer. Only that line is proposed for removal in a working copy as a supported same-output cleanup; its historical purpose remains unknown without imposing author confirmation or a new dataset requirement.
- The one-row LW_Firm_List.csv probe found a gvkey column but does not establish full data coverage or a constructor input. Existing Stata 18 evidence is retained as environment context, not as a required runtime for the supplied SAS outputs. SAS remains unverified; no SAS process or author program was started.
- Earlier completed draft/pair/read-only snapshot and relevant traces/streams were copied byte-for-byte into the source-QA baseline folder before these corrections. Existing failed catalog-helper, direct-finalizer and preflight histories remain preserved and unreferenced.
- A malformed unquoted datasheet path in the source-location command produced only a path error; no datasheet contents were read. That process record is retained separately and unreferenced.
