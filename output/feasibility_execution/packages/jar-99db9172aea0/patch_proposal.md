# Patch proposal: jar-99db9172aea0

The Impact of Consulting Services on Audit Quality: An Experimental Approach

DOI: 10.1111/1475-679X.12197

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | local_available | blocked |

### full_pipeline

Complete supplied three-condition workflow: import and append the author-assembled workbooks; construct the full-population Table 3 summaries from all.dta; create filtered all_2.dta for the other Table 1–2 and 4–7 branches; and complete the Table 1/Table 3 spreadsheet steps documented in the code comments.

Entry points: `NAS_DataPolicy/JAR STATA Code.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12197 - The-Impact-of-Consulting-Services-on-Audit-Quality-An-Experimental-Approach/kmt-datasheet-and-code.zip",
      "sha256": "d6815d437087801c6b4bc0d327f72e801308a3471d742966ec9e2e003fe6f96b"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12197 - The-Impact-of-Consulting-Services-on-Audit-Quality-An-Experimental-Approach/kmt-online-appendix.pdf",
      "sha256": "387446b511744e75821f8074f476debe07c9ea89856771f71fcbd4d617ea16a3"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12197 - The-Impact-of-Consulting-Services-on-Audit-Quality-An-Experimental-Approach/kowaleski-mayhew-tegeler-accepted-proposal.pdf",
      "sha256": "7feab746cdad746e9152e4c4e6f03aee3066cd0680185dde54a5fe5b69b90111"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "bd35530a7332ab81de1a3b5a141fd8bbc29762fe17247ff090d5612b8f5665bf",
  "work_item_sha256": "407ee82b92fb704c9ddd97c9219b4e41c6123aac011af85f4af78f73e73379c4"
}
```

## Proposed actions

### A-WORKDIR: Launch the unchanged Stata program with the supplied RawData directory as the current working directory.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-WORKDIR
Evidence: E-IMPORT-BASE, E-IMPORT-SAME, E-IMPORT-SEP, E-DATASET-ASSEMBLY

Preparation / proposed procedure:

1. In Stata, set the working directory to the package folder NAS_DataPolicy/RawData.
2. Run the supplied program using the quoted relative path ../JAR STATA Code.do so that the bare workbook names resolve and generated .dta intermediates stay in the same directory.

Validation to perform later:

- Before a future authorized run, confirm Stata pwd is NAS_DataPolicy/RawData.
- Confirm the three import commands resolve their intended Full worksheets and the program saves base.dta, same.dta, sep.dta, all.dta, all_2.dta and temp1.dta in that folder.

### A-TABLE3-SORT: Obtain the intended sort variable for both Table 3 summaries before proposing a source edit.

Scopes: full_pipeline. Type: clarification. Certainty: blocked.
Addresses: I-TABLE3-SORT
Evidence: E-AA-PRODUCER, E-TABLE3-A-KEEP, E-TABLE3-A-SORT, E-TABLE3-C-KEEP, E-TABLE3-C-SORT

Preparation / proposed procedure:

1. Ask the authors whether the post-keep gsort commands should retain aa or sort on another field that is retained in each branch.
2. Apply the author-confirmed ordering consistently to the auditor and consultant Table 3 summaries; do not substitute a guessed measure.

Validation to perform later:

- After authorized correction and execution, confirm both Table 3 branches pass their gsort commands and return the intended per-session ranking and order.

### A-MANUAL-TABLES: Follow the Table 1 and Table 3 spreadsheet steps documented in the supplied code comments.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E-TABLE1-MANUAL, E-TABLE3-MANUAL

Preparation / proposed procedure:

1. For Table 1, link each Session to its Condition and organize the columns by VerifierInvestigation as described in the comment; include the separate ConsultantEffort summary by Session.
2. For Table 3, use the auditor and consultant summary views prepared from temp1.dta and combine the information in a spreadsheet, aligning auditor 1 with consultant 1, auditor 2 with consultant 2, and auditor 3 with consultant 3 within each Session.
3. Use the author-confirmed Table 3 sort order after resolving the aa-loss issue; do not change the Table 3 population from all.dta to the filtered all_2.dta.

Validation to perform later:

- Compare the completed Table 1 and Table 3 layouts with the corresponding paper tables and retain the stated Session/Condition and within-session role alignment.
- Confirm the Table 3 cumulative summaries use all rows in the supplied all.dta population, while other table branches use all_2.dta after the Period 6–20 filter.


## Remaining issues and prerequisites

- I-WORKDIR [preparation; full_pipeline]: The do-file imports all three workbooks by bare basename, while the supplied spreadsheets are in NAS_DataPolicy/RawData. The program has no working-directory setup; it must be launched with RawData as the current directory or given a supported path configuration.
- I-TABLE3-SORT [blocking; full_pipeline]: In both Table 3 branches, keep removes aa and the next gsort refers to -aa. Stata will report aa not found. The intended sort key cannot be inferred safely from the supplied output instructions.

## Review notes

- All six frozen dependency IDs were reviewed. The checklist does not enumerate base.dta and same.dta; source lines 2/12 and 6/13 show they are generated by the workbook imports and consumed by append. sep.dta is saved, but the in-memory NAS-Separate data remains the append master. all.dta, all_2.dta and temp1.dta are also generated in sequence and then read at their documented consumer branches.
- All three exact author-named, author-assembled condition workbooks are supplied and verified locally for bounded readability and required header fields. The historical experiment and z-Tree collection are provenance for these files, not mandatory live data acquisition. The Base workbook lacks ConsultantHired/ConsultantEffort as expected; those columns are introduced by the NAS condition workbooks in the append union.
- The bounded Excel probe sampled a header and one row, and the Stata metadata probe imported only header rows. These checks do not establish full-row coverage, exact earliest/latest periods, or storage types beyond the sampled row; that is a normal future import/session/period validation limit, not a request for new author data or author confirmation.
- The script saves all.dta before dropping observations outside Period 6–20. Table 3 reloads unfiltered all.dta and computes cumulative counts/shares over all periods present in the supplied files; the remaining table branches use all_2.dta after the Period 6–20 filter. No exact earliest source period is inferred from a one-row probe.
- Stata 18 header-only metadata probing confirms raw headers “Mgr Misreport” in Base and NAS-Separate and “MgrMisreport” in NAS-Same all become Stata variable MgrMisreport under the exact firstrow import.
- The supplied comments document the manual Table 1 organization and Table 3 combination/alignment steps; these are credited as a run procedure rather than treated as a missing workbook or unverified software dependency.
- The supplementary appendix contains experiment instructions and pilot-study material. The registered-report proposal contains a Figure 2 placeholder and conditional additional experiment designs, but it is contextual and does not establish a current required figure or branch for this supplied three-condition workflow.
- No separate analysis_only scope is supported because the package does not contain all.dta, all_2.dta, temp1.dta or another prepared analysis dataset; those are generated by the supplied Stata program. The analysis route remains inside full_pipeline.
- Author code, regressions, and package modifications were not run or applied. Stata probes were self-written and bounded to header metadata; xls probes sampled one row.
