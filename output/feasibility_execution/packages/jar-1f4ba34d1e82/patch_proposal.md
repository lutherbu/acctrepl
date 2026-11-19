# Patch proposal: jar-1f4ba34d1e82

Does Public Firms’ Mandatory IFRS Reporting Crowd Out Private Firms’ Capital Investment?

DOI: 10.1111/1475-679X.12494

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied SAS constructors for the Amadeus and Oriana analyses followed by the Stata main-table program. Required raw inputs and cross-program table schemas remain unresolved.

Entry points: `LSZZ_1_Data_Assembly_Code_Amadeus_SAS.sas`, `LSZZ_2_Data_Assembly_Code_Oriana_SAS.sas`, `LSZZ_3_Main_Tables_STATA.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12494 - Does-Public-Firms-Mandatory-IFRS-Reporting-Crowd-Out-Private-Firms-Capital-Investment/lszz-datasheet-code-and-identifiers.zip",
      "sha256": "15c03e1a619609a26197184d344fd57b6f4ad67a74aba4e4674a870628a19dbe"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12494 - Does-Public-Firms-Mandatory-IFRS-Reporting-Crowd-Out-Private-Firms-Capital-Investment/lszz-internet-appendix.pdf",
      "sha256": "a308cdd837110194988ea726a8e3d62de1f7b0c71e6df384f6be7533348b7839"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "f54274aab8469c019466ef001ec3506c4861aee8e1a28f7ca92bda449651406a"
}
```

## Proposed actions

### A-CLARIFY-HANDOFFS: Resolve the named source-table, output-member and variable-schema contracts for both SAS-to-Stata handoffs, including the patstat library-member path and the Orbis table that is overwritten before the main Oriana merge. The libref name does not establish a separate product. Retain compatible current or historical products as candidate routes after verifying actual fields, population and reporting history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-AMADEUS-SOURCE, R-ORBI-HISTORICAL-BASE, R-ORBI-HISTORICAL-1, R-ORBI-INDUSTRY, R-ORBI-LEGAL, R-ORIANA-FINANCIAL-MEMBER, I-AM-HANDOFF, I-OR-HANDOFF
Evidence: E-DOC-AM-PRODUCER, E-DOC-OR-PRODUCER, E-SAS-AM-READ, E-SAS-AM-AA-READ, E-SAS-AM-STATIC-FIELDS, E-SAS-OR-READ, E-SAS-OR-SELFREAD, E-SAS-PATSTAT-READ, E-SAS-OR-INDUSTRY, E-SAS-OR-LEGAL, E-SAS-OR-JOIN, E-DO-AM-READ, E-DO-OR-READ, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Map each active SAS input member to its actual source table/path and record source columns, identifiers, population and date coverage; treat `patstat` only as a SAS library name until its mapping is documented.
2. Compare each generated SAS table's actual field names and storage format with every Stata consumer; make only same-analysis field and path mappings once the source contract is confirmed.

Validation to perform later:

- In a separate authorized portable working copy, verify that each SAS-produced output member and column is readable by its intended Stata consumer without changing the analysis definitions.

### A-REORDER-DROP-ES: Preserve the supplied Amadeus construction while ensuring drop_es_gr exists before the first Stata merge that consumes it.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I-DROP-ES-ORDER
Evidence: E-DO-DROP-ES-CONSUMER, E-DO-DROP-ES-PRODUCER, E-DO-AM-SAVE, E-DO-AM-ORDER

Preparation / proposed procedure:

1. After the Stata source saves amadeus_ready at line 96, execute or move its supplied drop_es_gr producer block at lines 132–146 before the first `merge ... using drop_es_gr` at line 103.
2. Keep the original drop_es_gr criteria and its separate public_new field-mapping gap; do not change the sample or infer a replacement variable.

Validation to perform later:

- In a separate authorized portable working copy, confirm that the generated drop_es_gr file is available before the first consumer and that the source-field mapping is resolved before running the analysis.

### A-RESOLVE-OR-ADOPT2002: Resolve the missing Oriana 2002 adoption intermediate and the before1 field needed by the supplied benchmark-2 preparation, preserving all authored country/year branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-OR-ADOPT2002, I-OR-HANDOFF
Evidence: E-DO-OR-ADOPT2002, E-DO-OR-ADOPTION-PRODUCERS, E-DO-BEFORE1, E-DO-OR-BEFORE1, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Identify the supplied producer or compatible author-prepared file for oriana_adopt2002 and document its source, country/year population, fields and output path.
2. Identify the source of before1 in the Oriana benchmark-2 stage, or document the missing preparation that creates it. Do not invent an adoption year or country mapping.

Validation to perform later:

- In a separate authorized portable working copy, verify that the 2002 branch and before1 field are produced before the Stata append and benchmark-2 grouping steps.

### A-FIX-AM-EXPORT: Repair the supplied Amadeus PROC EXPORT command to write the already constructed SAS combined table to the existing Stata DTA target path, while retaining the table and file name.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-AM-EXPORT-SYNTAX
Evidence: E-SAS-AM-COMBINED, E-SAS-AM-EXPORT, E-PUBLIC-SAS-STATA-EXPORT

**Proposed edit:** `LSZZ_1_Data_Assembly_Code_Amadeus_SAS.sas:407–407`
Source SHA-256: `c04ad365ce3877e6fbf8e09f41e25cabf39f0548a04c90aacb4f86f6e3b6fa59`

The source has already created JAR_Data.Amadeus_2009disk_combined. The official Stata DTA example uses an explicit DATA= dataset, FILE= DTA filename, and DBMS=STATA REPLACE statement; this changes only the incomplete export wrapper and keeps the authored output name/path. The SAS runtime and export component remain unverified.

Current text:
```
proc export datafile="local directory\Amadeus_2009disk_combined.dta",replace
```

Proposed replacement:
```
proc export data=JAR_Data.Amadeus_2009disk_combined
            file="local directory\Amadeus_2009disk_combined.dta"
            dbms=stata replace;
```

Preparation / proposed procedure:

1. Apply the proposed correction only in a separate portable working copy, retaining the same relative output location under the shared runtime working root.

Validation to perform later:

- In a separately authorized SAS 9.4 batch run, verify that the DTA file is written at the relative path consumed by Stata; confirm the independent variable-name mapping before using it for analysis.

### A-PORTABLE-ROOTS: Configure a separate portable runtime root while preserving the supplied Amadeus jar_data libref, resolving the Oriana source librefs to their actual documented locations, and aligning Stata working paths with generated handoffs.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R-AMADEUS-SOURCE, R-ORBI-HISTORICAL-BASE, R-ORBI-HISTORICAL-1, R-ORBI-INDUSTRY, R-ORBI-LEGAL, R-ORIANA-FINANCIAL-MEMBER, I-AM-HANDOFF, I-OR-HANDOFF
Evidence: E-DO-DATASET-ORDER, E-SAS-OR-READ, E-SAS-PATSTAT-READ, E-SAS-AM-EXPORT, E-DO-AM-READ, E-WORKFLOW-TRACE, E-LIBNAME-ALIAS-VIEW

Preparation / proposed procedure:

1. Choose a writable relative or [redacted-path-837ed78ab226] execution root for a separate working copy; do not embed the Dropbox workspace path in host-run configuration.
2. Preserve and port the existing Amadeus jar_data LIBNAME mapping (the exact physical path is masked in the safe view); separately identify the actual JAR_Data and patstat library locations used by the Oriana constructor. Do not infer a distinct PATSTAT product from the libref name.
3. Run SAS and Stata from explicitly documented directories that make the existing relative Amadeus DTA target and Stata cd resolve consistently. Keep SAS library, DTA export and Stata working-directory paths distinct in run notes.

Validation to perform later:

- Before any separately authorized execution, verify that each selected source directory is visible and each output root is writable from both SAS and Stata; confirm the SAS and Stata paths resolve to the same Amadeus DTA handoff.

### A-SETUP-WINSOR2: Make the Stata command winsor2 available in the runtime adopath without changing the authors' 1st/99th percentile by-year winsorization.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S-WINSOR2
Evidence: E-DO-SOFTWARE, E-DO-OR-WINSOR, E-ENVIRONMENT

Preparation / proposed procedure:

1. Obtain and configure a compatible winsor2 implementation in the Stata adopath; the environment probe did not find it in the checked paths.

Validation to perform later:

- After separately authorized setup, verify `which winsor2` and the installed command metadata without running author analyses.

### A-SETUP-XTILEJ: Resolve the user-written xtileJ command invoked for the supplied size-median and leverage-tercile partitions; do not substitute built-in xtile without evidence that it preserves the authored interface and grouping.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-XTILEJ
Evidence: E-DO-XTILEJ, E-XTILEJ-PROBE

Preparation / proposed procedure:

1. Obtain a compatible xtileJ implementation or its exact source/release and configure it on the Stata adopath; the supplied package contains no separate ado source.

Validation to perform later:

- After separately authorized setup, verify `which xtileJ` and inspect its version/help metadata; do not trial it on study or synthetic data.

### A-VERIFY-SAS-RUNTIME: SAS readiness remains unverified from the supplied environment artifact. Resolve a compatible SAS 9.4 batch runtime and Stata DTA export capability before attempting either SAS constructor; the recorded startup failure is not a license conclusion.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-SAS, S-SAS-PCFILES
Evidence: E-ENVIRONMENT, E-PUBLIC-SAS-STATA-EXPORT

Preparation / proposed procedure:

1. Use a separately authorized SAS 9.4 batch runtime with the Base SAS procedures required by the code and verify the available local Stata DTA export method/PC Files component.
2. Keep host wrapper paths relative or under [redacted-path-837ed78ab226] and preserve the original author files in a separate audit copy.

Validation to perform later:

- After separately authorized setup, verify SAS batch availability and the selected PROC EXPORT method through permitted software metadata/documentation; do not start SAS during this assessment.


## Remaining issues and prerequisites

- I-AM-HANDOFF [unresolved; full_pipeline]: The Amadeus SAS constructor writes Amadeus_2009disk_combined from the transposed numeric table and static table, but the Stata consumer immediately expects names such as bvd_id, op_rev, nace, total_asset and current_asset. The supplied SAS blocks retain names such as Mark, bvdep_id_number, nace_rev_2__primary_code, fixed_assets1 and total_assets1 and do not show a mapping to the Stata names. The precise export/member and variable aliases required for this handoff are unresolved.
- I-OR-HANDOFF [unresolved; full_pipeline]: The Oriana SAS constructor creates Oriana_data_merged from its historical-financial, industry-code and legal-information tables, but the Stata consumer expects fields including bvd_id, year, turnover1, fixed_assets1, p_l_after_tax1 and delisted_date, and before1 has no shown producer. The SAS blocks show different input spellings and do not establish the consumed schema. The code first writes JAR_Data.Oriana_historical_financials from the Orbis table and later overwrites it from patstat.Oriana_historical_financials. `patstat` is only a libref name; its source-table mapping is unresolved and it does not prove a separate product. The SAS source does not show a DTA export for Oriana_data_merged, while Stata loads that name as a DTA from its local directory. The table format and path handoff are unresolved.
- I-DROP-ES-ORDER [preparation; full_pipeline]: The Stata consumer merges drop_es_gr before the supplied producer saves that file later in the source. The producer uses the already saved amadeus_ready dataset and is a known same-analysis block; move or execute that existing block after amadeus_ready and before its first consumer. The separate missing public_new/field mapping remains covered by I-AM-HANDOFF.
- I-OR-ADOPT2002 [unresolved; full_pipeline]: The Oriana Stata branch loads oriana_adopt2002 and appends it to the adoption-year datasets, but neither supplied SAS program nor the Stata source produces oriana_adopt2002. Its source, country/year population and construction remain unspecified; preserve it as an unresolved producer/input gap rather than inventing an adoption group.
- I-AM-EXPORT-SYNTAX [preparation; full_pipeline]: The Amadeus source's final PROC EXPORT line uses DATAFILE=, a comma before REPLACE, and no explicit DATA= or DBMS=STATA statement terminator, so the intended .dta handoff is not established by the supplied command. The exact SAS dataset and output path are evident; a same-operation source edit is supported by the official Stata DTA export syntax. SAS 9.4 runtime/PC Files method availability remains unverified, and the separate Stata variable-alias gap remains unresolved.
- R-AMADEUS-SOURCE [undetermined]: The Amadeus SAS constructor directly reads JAR_Data.Amadeus_2009disk and JAR_Data.Amadeus_2009disk_aa; the latter supplies fields for the turnover, sales, cost of goods sold, operating profit, after-tax profit and taxation transposes. The supplied package contains a final-sample firm-name workbook, not these full analysis inputs.
- R-ORBI-HISTORICAL-BASE [undetermined]: The Oriana SAS constructor directly reads JAR_Data.Orbis_historical_financials and filters it into an intermediate that is later overwritten. Keep the executed constructor input contract; the earlier table’s contribution to the final joined output is not shown.
- R-ORBI-HISTORICAL-1 [undetermined]: The Oriana SAS constructor directly self-reads JAR_Data.Orbis_historical_financials_1 to derive Year and Country. No producer appears in the supplied programs, and the rewritten member has no shown downstream consumer; preserve it as a direct input contract for the supplied source as written.
- R-ORBI-INDUSTRY [undetermined]: The Oriana SAS constructor reads JAR_Data.Orbis_industrycode to produce its firm industry-code table, filtering by BvD_ID_number.
- R-ORBI-LEGAL [undetermined]: The Oriana SAS constructor reads JAR_Data.Orbis_legalinfo to produce its firm legal-information table used in the final SQL merge.
- R-ORIANA-FINANCIAL-MEMBER [undetermined]: The Oriana SAS constructor reads patstat.Oriana_historical_financials to overwrite its earlier JAR_Data.Oriana_historical_financials intermediate, which is then consumed in the merged output. The `patstat` prefix is a SAS libref; it does not establish an independent product requirement.
- S-SAS [unverified]: The author constructors use Base SAS DATA steps, PROC SORT, PROC TRANSPOSE, PROC SQL and PROC EXPORT. The supplied environment record does not establish a runnable SAS 9.4 runtime; its recorded startup failure is not evidence of a missing license. No SAS process was started for this assessment.
- S-SAS-PCFILES [unverified]: The documented local Stata DTA export method is available in SAS documentation, but this work item's environment evidence does not establish whether the matching SAS export component is present or configured.
- S-WINSOR2 [preparation_required]: The supplied Stata code invokes winsor2 for the 1st/99th percentile by-year winsorization. The environment probe did not find this command in the checked adopaths.
- S-XTILEJ [preparation_required]: The supplied Stata code invokes xtileJ for median-size and leverage-tercile partitions. The exact command probe reports it unavailable in the checked Stata adopath; no replacement is inferred.

## Review notes

- Static assessment follows the three supplied constructors/main-table programs as the full-pipeline target; no author code or data were executed. The SAS sources contain no observed %macro definitions/includes; SAS comment blocks are /* ... */. The Stata foreach var macros are bound locally by the listed loops; indicator wildcard expansions remain category-dependent. Full variable and producer-consumer tracing is in E-WORKFLOW-TRACE.
- The Amadeus named historical disk in the datasheet is provenance, not a byte-identity requirement. A compatible current or historical source route remains possible if its actual fields, population and reporting history meet the constructor contract. The identifiers workbook is a final-sample name list and is not the full panel.
- For Oriana, the source first reads JAR_Data.Orbis_historical_financials, then overwrites the same JAR_Data intermediate from patstat.Oriana_historical_financials before the SQL join. The `patstat` prefix is a SAS namespace; no separate PATSTAT product requirement or access barrier is inferred. Preserve both direct source-member contracts and the actual source order while clarifying the physical mapping and source semantics.
- The frozen catalog lookup CLI failed on a stale sibling-resource path; a bounded exact-name fallback over the frozen catalog found no matching dataset, physical-file or alias records. This is discovery only and does not prove no compatible source, no local access or an absent license.
- The datasheet and internet appendix provide historical provenance and supplementary-analysis context. Table IA9 is not an additional execution target because the supplied code entry points are the two constructors and main-table Stata program; no separate paper-wide reconstruction was attempted.
- Process-only records preserved but deliberately not referenced by any recursive evidence_ids: E-REDACTOR-FAIL, E-CATALOG-CLI-FAIL, E-WEB-ORIANA-FAIL, E-XLSX-INSPECT-FAIL-1, E-XLSX-INSPECT-FAIL-2, E-MACRO-SWEEP-FAIL and E-WORKFLOW-TRACE-FAIL. The failed redaction/query/page/helper processes support no scientific, product-access or license conclusion; E-PREFLIGHT-FAIL-1 and E-PREFLIGHT-INVOCATION-001 are also process-only and unreferenced.
