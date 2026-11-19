# Patch proposal: jar-557644d8d842

On the EPA’s Radar: The Role of Financial Reports in Environmental Regulatory Oversight

DOI: 10.1111/1475-679X.12572

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | undetermined |

### full_pipeline

Complete author-documented preparation, data construction, descriptive statistics, regression, and figure workflow.

Entry points: `1. Raw Edgar data.sas`, `2. Raw EPA data.sas`, `3. Merge and clean data.sas`, `4. Descriptive results.sas`, `5. Regression results.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

A bounded Stata final-data analysis route using the exact four packaged author-prepared DTA files. It covers the supplied Regression results.do final-data branch (lines 37–428): Tables 2B–8, Table 9B–9D, F-statistics for Tables 4/6/8 and Figures 2–4. It excludes the initial Appendix III prediction block that rebuilds case_distance/p_distance, all raw-data preparation, the SAS descriptive/Appendix III branch, and outputs not present in this Stata branch; it is not a full-paper execution claim.

Entry points: `5. Regression results.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12572 - On-the-EPAs-Radar-The-Role-of-Financial-Reports-in-Environmental-Regulatory-Oversight/lw-datasheet-code-identifiers-log-files.zip",
      "sha256": "8e323d1b5e305bd188d0d3604045c8b08264c472420fe3f98afaf3f86daf5142"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12572 - On-the-EPAs-Radar-The-Role-of-Financial-Reports-in-Environmental-Regulatory-Oversight/lw-2024-online-appendix.pdf",
      "sha256": "a49c79c0821b01b16fa8c23ec5cee700188c5036f80695cc36ca8e776a46625f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "9a77c9412bed3ca7370d758fb3a59635aecb49524557d52140b47f2363094da1"
}
```

## Proposed actions

### A_HANDOFF: After required upstream inputs and software are resolved, run Merge/clean through its Output/case_distance.dta export; run only the supplied Step 5 prediction block that consumes that exact file and writes Output/case_pdistance.dta; resume Merge/clean at its matching import so the final case.dta contains p_distance; then continue its final exports and the separate SAS descriptive and Stata analysis branches. Preserve this exact producer/consumer order in one working/output root.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_HANDOFF
Evidence: E_README_ORDER, E_S3_CASE_DISTANCE, E_S5_PREDICT, E_S4_EDGAR, E_S5_SAMPLE

Preparation / proposed procedure:

1. Keep the original SAS/Stata programs unchanged and use working copies. Set one coherent writable Output root for the case_distance.dta export, Step 5 input, case_pdistance.dta save and Merge/clean import; configure the separate RTF output roots consistently for the chosen runtime.
2. Run the raw preparation stages only after their distinct input, SAS runtime and supporting-helper prerequisites are resolved.
3. Pause Merge/clean after it produces case_distance.dta; execute only the named supplied Step 5 prediction block; resume Merge/clean at the case_pdistance.dta import and allow it to export the final case.dta and other final datasets.
4. Run the SAS descriptive branch and the Stata final-data branch only as separate downstream steps after their own inputs and software are ready.

Validation to perform later:

- Before any separately authorized run, confirm the three path/basename handoffs case_distance.dta → case_pdistance.dta → final case.dta against the cited active export, save and import statements; do not substitute the final case.dta for the raw prediction input.

### A_HELPERS: Obtain the exact ff48.sas and winsorn.sas include sources used by the authors, and clarify their intended relative paths and versions before attempting Merge/clean.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SUPPORTING_SAS
Evidence: E_S3_HELP_FF48, E_S3_HELP_WINSOR

Preparation / proposed procedure:

1. Request the author-used helper source files and their version/provenance.
2. Place them at a consistent relative path in the working copy and confirm both includes resolve.

Validation to perform later:

- Future authorized run only: confirm both includes resolve in the intended SAS project root.

### A_CORRTBL: Locate the author-used compatible corrtbl ado source/version or document a compatible local copy, then confirm its discovery through Stata metadata before a separately authorized run.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: conditional.
Addresses: I_STATA_CORRTBL, S_CORRTBL
Evidence: E_S5_SAMPLE, E_SW_CORRTBL

Preparation / proposed procedure:

1. Identify the author-used corrtbl source and version or a documented compatible release.
2. Place it only through the normal software provisioning process, if separately approved.
3. Run a bounded `which corrtbl` metadata check and record the resolved version/path before any author-code attempt.

Validation to perform later:

- Confirm Stata 18 resolves corrtbl through a bounded `which` check; do not run the author model during this check.

### A_SAS_RUNTIME: Verify SAS 9.4 and SAS/STAT version/component availability through an approved software inventory before a later full-pipeline attempt; this assessment made no SAS invocation.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SAS_RUNTIME, S_SAS94
Evidence: E_ENV_SOFTWARE, E_S3_HELP_FF48

Preparation / proposed procedure:

1. Consult the approved software inventory or package administrator record for the installed SAS release and SAS/STAT component.
2. Record the version and PROC REG component status without starting SAS or running an author program.

Validation to perform later:

- Record the approved SAS and SAS/STAT version evidence before any separately authorized full-pipeline run.

### A_PUBLIC_INPUTS: Select compatible files for each public source named by the code and match them to the specific author input tables and code periods.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_PUBLIC_INPUTS, R_EDGAR_LOGS, R_TRI, R_FEC_CASE_ENFORCEMENTS, R_FEC_CASE_VIOLATIONS, R_FEC_CASE_PENALTIES, R_FEC_CASE_FACILITIES, R_FEC_CASE_DEFENDANTS, R_FEC_CASE_MILESTONES, R_FEC_CASE_ENFORCEMENT_CONCLUSIONS, R_FEC_CASE_ENFORCEMENT_TYPE, R_FEC_INSPECTIONS, R_FEC_CASE_RELATED_ACTIVITIES, R_SEC_INDEX, R_LM_COMPLEXITY
Evidence: E_PUBLIC_EDGAR_LOGS, E_PUBLIC_SEC_FULL_INDEX, E_PUBLIC_TRI, E_PUBLIC_ECHO_FEC, E_PUBLIC_LM_COMPLEXITY

Preparation / proposed procedure:

1. For SEC log data, match the official 2003–June 2017 product and required log fields to the data.log&date consumer.
2. For TRI, match each annual 2000–2020 CSV partition and its facility/year keys to the separate program imports.
3. For EPA FE&C, keep each case/inspection/related-activity table separate and document its actual key/date fields for the named consumer.
4. For SEC full-index and LM complexity, verify the author table/file field mapping and relevant period using a compatible public or author-prepared/local route.
5. Record the selected product period/version for traceability; no original-byte or original-vintage gate is imposed.

Validation to perform later:

- For each public requirement, record its selected file/table, required identifier/date fields, and covered source period; do not download or execute author code as part of this assessment.

### A_LOCAL_AUTHOR_INPUTS: Locate or verify the distinct author-prepared/local/vendor inputs by their code-named filenames, preserving their separate keys, dates and mapping roles.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_LOCAL_AUTHOR_INPUTS, R_TRI_PARENT_MATCH, R_CASE_MATCH, R_WRDS_GVKEY_CIKLINK, R_CALENDAR, R_NLPSA, R_CASE_TIMELINE, R_AFFECTED_INDUSTRY, R_RULE_SOURCE, R_DIRECTEDGAR_8K
Evidence: E_S2_PARENT_MATCH, E_S2_RAWCASE, E_S3_CALENDAR, E_S3_READ_NLPSA, E_S3_CASE_DISTANCE, E_S3_READ_AFFECTEDINDUSTRY, E_S3_READ_RULESOURCE, E_S4_8K

Preparation / proposed procedure:

1. Verify ParentCo_Match_TRI.csv and MatchedCase.csv as distinct maps and document their key/date validity rules.
2. Verify calendar.csv covers the monthly dates read by the sample and event-window consumers.
3. Verify database.Nlpsa has the filing-level issuer/form/date/accession fields used by Merge/clean.
4. Verify Case_discovery_timeline.csv by case_number and the date1/date2 fields used by the distance calculation.
5. Verify AffectedIndustry.dta and source Data/rule.dta separately by rule identifiers, NAICS/publication fields, and abstract fields.
6. Verify DirectEdgar_8K.csv as a compatible local author/vendor input for Descriptive results.

Validation to perform later:

- Record each file’s exact input role, source keys/date fields, and period/row coverage in its own requirement route.

### A_WRDS_CONTRACT: Resolve the author-table construction and history contracts using the four already-readable common-source candidates and the supplied consumer code; do not treat alias or SAS-export differences as absence or a new access gate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WRDS_CONTRACT, R_CCMXPF_LNKHIST, R_COMPUSTAT_CCM_FUNDA, R_CRSP_MSF, R_COMPUSTAT_SEGMENT_GEO
Evidence: E_S3_WRDS_LINK, E_S3_CCM_LINK, E_S3_FUNDAMENTALS, E_S3_READ_SEGMENT, E_CAT_COMPUSTAT_ALIAS, E_CAT_COMPUSTAT_CANDIDATE, E_CAT_CRSP_ALIAS, E_CAT_CRSP_CANDIDATE, E_CAT_WRDS_LINK, E_CAT_WRDS_LINKCSV, E_CAT_SEGMENT_ALIAS, E_CAT_SEGMENT_SNMS, E_CAT_SEGMENT_SALES, E_COMMON_PROBE_COMP_FUNDA, E_COMMON_PROBE_CRSP_MSEALL, E_COMMON_PROBE_CCMXPF, E_COMMON_PROBE_SEGMENT

Preparation / proposed procedure:

1. For ccm_funda, map COMP.FUNDA's readable annual financial fields to the author table and establish how LPERMNO is supplied from the separate CCM link history; retain the source FIC=USA and FYEAR 2002–2018 filters, deduplication keys and date contract.
2. For crsp_msf, map the readable MSEALL DATE/PERMNO/SICCD/NAICS/SHRCD/EXCHCD fields to the author input and record its monthly row selection and required date history.
3. For ccmxpf_lnkhist, document the selected link types, effective-date boundaries, duplicate handling and required history for the author's GVKEY-to-PERMNO join.
4. For Compustat_segment_geo, document the WRDS_SEGMERGED-to-author-table preparation, geographic segment record unit, SNMS classification and SALES meaning for the source's grouping keys.
5. Keep the currently observed one-row fields/readability separate from full historical coverage and from any author-specific prepared-table contract; do not perform another lookup or row probe as part of this action.

Validation to perform later:

- Compare the documented source-table names, required fields, join keys, date rules, filters and record units with the cited consumer ranges before any separately authorized full-pipeline run; do not claim complete historical coverage from these one-row probes.

### A_ANALYSIS_STAGE: Use only the exact author-prepared final DTA files for the bounded Stata final-data branch. Stage same-byte copies under the unprefixed names expected by the code, apply only the listed working-copy path changes, and start from line 37. The supplied final case.dta already has p_distance; the separate raw case_distance prediction block is not part of this scope.

Scopes: analysis_only. Type: source_edit. Certainty: supported.
Addresses: I_ANALYSIS_PATH_STAGING, R_STATA_FINAL_SAMPLE, R_STATA_FINAL_CASE, R_STATA_FINAL_INSPECT, R_STATA_FINAL_RULE
Evidence: E_README_DATA, E_S3_FINALSAMPLE, E_S3_CASE_DISTANCE, E_S3_CASE_EXPORT, E_S3_INSPECT_EXPORT, E_S3_RULE_EXPORT, E_DTA_SAMPLE, E_DTA_CASE, E_DTA_INSPECT, E_DTA_RULE, E_S5_PREDICT, E_S5_SAMPLE, E_S5_CASE, E_S5_INSPECT, E_S5_RULE, E_S5_FTEST_SETUP, E_S5_FTEST_TABLE4, E_S5_FTEST_TABLE6_8, E_S5_FIGURE_SETUP, E_S5_FIGURES

**Proposed edit:** `5. Regression results.do:39–39`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Point this final-data branch at the same writable local Output directory that will hold the four staged final datasets.

Current text:
```
cd "[redacted-path-d1f451f6193f]"
```

Proposed replacement:
```
cd "historical artifact Output"
```

**Proposed edit:** `5. Regression results.do:180–180`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Point this final-data branch at the same writable local Output directory that will hold the four staged final datasets.

Current text:
```
cd "[redacted-path-d1f451f6193f]"
```

Proposed replacement:
```
cd "historical artifact Output"
```

**Proposed edit:** `5. Regression results.do:217–217`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Point this final-data branch at the same writable local Output directory that will hold the four staged final datasets.

Current text:
```
cd "[redacted-path-d1f451f6193f]"
```

Proposed replacement:
```
cd "historical artifact Output"
```

**Proposed edit:** `5. Regression results.do:254–254`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Point this final-data branch at the same writable local Output directory that will hold the four staged final datasets.

Current text:
```
cd "[redacted-path-d1f451f6193f]"
```

Proposed replacement:
```
cd "historical artifact Output"
```

**Proposed edit:** `5. Regression results.do:291–291`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Point this final-data branch at the same writable local Output directory that will hold the four staged final datasets.

Current text:
```
cd "[redacted-path-d1f451f6193f]"
```

Proposed replacement:
```
cd "historical artifact Output"
```

**Proposed edit:** `5. Regression results.do:373–373`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Point this final-data branch at the same writable local Output directory that will hold the four staged final datasets.

Current text:
```
cd "[redacted-path-d1f451f6193f]"
```

Proposed replacement:
```
cd "historical artifact Output"
```

**Proposed edit:** `5. Regression results.do:76–76`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", nogaps ///
```

Proposed replacement:
```
esttab  model0 model1 model2 model3 using "epa.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:80–80`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:101–101`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  m1 m2 m3 m4 m5 m6 using "[redacted-path-6bbd9ff452f8]", nogaps ///
```

Proposed replacement:
```
esttab  m1 m2 m3 m4 m5 m6 using "epa.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:105–105`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab m1 m2 m3 m4 m5 m6  using "[redacted-path-6bbd9ff452f8]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab m1 m2 m3 m4 m5 m6  using "epa.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:117–117`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", nogaps ///
```

Proposed replacement:
```
esttab  model0 model1 model2 model3 using "epa.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:121–121`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:131–131`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  model2 model3 using "[redacted-path-6bbd9ff452f8]", nogaps ///
```

Proposed replacement:
```
esttab  model2 model3 using "epa.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:135–135`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:149–149`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", nogaps ///
```

Proposed replacement:
```
esttab model0 model1 model2 model3 using "epa.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:153–153`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:165–165`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  model2 model3  using "[redacted-path-6bbd9ff452f8]", nogaps ///
```

Proposed replacement:
```
esttab  model2 model3  using "epa.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:169–169`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the table output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab model0 model1 model2 model3 using "[redacted-path-6bbd9ff452f8]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:207–207`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the Table 9 output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  m1 m2 m3 m4 m5 m6 m7 using "[redacted-path-9e20e3bd3f46]", nogaps ///
```

Proposed replacement:
```
esttab  m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:211–211`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the Table 9 output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab m1 m2 m3 m4 m5 m6 m7 using "[redacted-path-9e20e3bd3f46]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:244–244`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the Table 9 output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  m1 m2 m3 m4 m5 m6 m7 using "[redacted-path-9e20e3bd3f46]", nogaps ///
```

Proposed replacement:
```
esttab  m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:248–248`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the Table 9 output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab m1 m2 m3 m4 m5 m6 m7 using "[redacted-path-9e20e3bd3f46]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", ar2(4) append keep(_cons)
```

**Proposed edit:** `5. Regression results.do:281–281`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the Table 9 output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab  m1 m2 m3 m4 m5 m6 m7 using "[redacted-path-9e20e3bd3f46]", nogaps ///
```

Proposed replacement:
```
esttab  m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", nogaps ///
```

**Proposed edit:** `5. Regression results.do:285–285`
Source SHA-256: `a8bd6608370c38d563ff03c333a1e98cfa2b0c4bba348416a0d6f6c35d5464aa`

Keep the Table 9 output in the same local Output directory as the staged analysis inputs.

Current text:
```
esttab m1 m2 m3 m4 m5 m6 m7 using "[redacted-path-9e20e3bd3f46]", ar2(4) append keep(_cons)
```

Proposed replacement:
```
esttab m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", ar2(4) append keep(_cons)
```

Preparation / proposed procedure:

1. Create historical artifact Output in a working copy and copy the supplied Data/1. sample.dta, Data/2. case.dta, Data/3. inspect.dta and Data/4. rule.dta there as sample.dta, case.dta, inspect.dta and rule.dta, preserving the original files and bytes.
2. Apply the listed path-only changes to a working copy of 5. Regression results.do. The analysis branch reads the four unprefixed basenames from the Output root and writes epa.rtf and ratio.rtf there; do not change data construction, filters, variables, estimators or model specifications.
3. After the separate corrtbl preparation item is resolved, begin at the final-data branch (line 37). Use the packaged case.dta p_distance field and do not run the Appendix III case_distance prediction block (lines 5–32) in this scope.
4. The bounded scope is Tables 2B–8, Table 9B–9D, F-statistics for Tables 4/6/8 and the Figures 2–4 coefplot commands. Table 1, Table 9A, the SAS descriptive branch and the upstream raw-data/prediction stages are outside this scope. The figure commands create plots but contain no graph export statement.

Validation to perform later:

- Before any separately authorized run, verify that each staged filename corresponds to the exact packaged file and that the selected source fields are present after the supplied lowercase transforms; the case input must include p_distance.
- After a separately authorized run, check the RTF outputs in the selected Output root and capture Figures 2–4 from their coefplot commands if file deliverables are required. Do not infer full-paper success or complete population/year coverage from this bounded branch.


## Remaining issues and prerequisites

- I_HANDOFF [preparation; full_pipeline]: The supplied programs specify the cross-language producer/consumer order: Merge/clean exports Output/case_distance.dta, Stata Step 5 reads it, predicts p_distance and saves Output/case_pdistance.dta, and Merge/clean resumes at that import before exporting the final case.dta. The shared working/output root and the separate RTF destinations must be configured in working copies; this is a concrete orchestration/path preparation step, not an unresolved scientific specification.
- I_SUPPORTING_SAS [unresolved; full_pipeline]: Merge/clean includes external ff48.sas and winsorn.sas helpers; neither is among the five supplied entry programs. Their exact bytes/contracts and compatible preparation location must be supplied or verified.
- I_STATA_CORRTBL [preparation; full_pipeline, analysis_only]: The supplied final-data Stata branch calls corrtbl for Table 2B; bounded Stata 18 software metadata did not find that command. Other observed analysis commands (reghdfe, ppmlhdfe, esttab and coefplot) have available software evidence. The compatible corrtbl source/version is a Table 2B preparation item.
- I_SAS_RUNTIME [preparation; full_pipeline]: The environment record marks SAS as unverified without a version; SAS/STAT availability for PROC REG is also unverified. No SAS process was started and no startup or source execution was attempted.
- I_PUBLIC_INPUTS [preparation; full_pipeline]: Official public pages identify SEC EDGAR logs/full index, EPA TRI/FE&C and the LM complexity measure as plausible source routes, but no public files were downloaded. Match each selected source to the distinct code-named input and verify its required fields/period in the corresponding requirement; do not require original download bytes or a specific original vintage.
- I_LOCAL_AUTHOR_INPUTS [preparation; full_pipeline]: The source names separate author-prepared matching, calendar, filing, timeline, regulatory mapping and vendor files: ParentCo_Match_TRI.csv, MatchedCase.csv, calendar.csv, database.Nlpsa, Case_discovery_timeline.csv, AffectedIndustry.dta, the source Data/rule.dta, and DirectEdgar_8K.csv. Their local copies and distinct field/key/date coverage have not been verified; the matching contracts remain individually described by the requirements.
- I_WRDS_CONTRACT [unresolved; full_pipeline]: Exact catalog candidates COMP.FUNDA, CRSP.MSEALL, CRSP.CCMXPF_LNKHIST and COMPSEG.WRDS_SEGMERGED each returned a successful one-row read with the selected underlying fields. The remaining unresolved items are the mapping from those candidates to the author-named ccm_funda, crsp_msf and Compustat_segment_geo inputs, the construction/key/date contract (including LPERMNO linkage and fiscal-year/month matching), the selected link history, and the geography segment record unit and period. Preserve these as distinct requirements; alias differences and coverage_verified=false are not product absence or entitlement findings.
- I_ANALYSIS_PATH_STAGING [preparation; analysis_only]: The four packaged final DTA files are under Data/ with numeric filename prefixes, while the Stata final-data branches read unprefixed sample.dta, case.dta, inspect.dta and rule.dta from a hard-coded Windows Output root and write RTF tables under [redacted-path-d298f7085a31]. The current Linux Stata route needs a local working Output root, same-byte staged filenames and the listed path-only edits in a working copy; this is preparation, not a scientific-input incompatibility.
- R_EDGAR_LOGS [undetermined]: Daily SEC EDGAR log tables read by the program 1 macro as data.log&date (2003–June 2017). The precise local table/file coverage and input-field mapping have not been verified.
- R_TRI [undetermined]: EPA TRI Basic annual CSV partitions, imported separately for calendar years 2000–2020 by program 2.
- R_TRI_PARENT_MATCH [undetermined]: ParentCo_Match_TRI.csv, the author-prepared parent-company mapping imported by program 2; key and link-date/duplicate semantics are not documented in the package.
- R_FEC_CASE_ENFORCEMENTS [undetermined]: EPA ICIS FE&C Case enforcement records; the supplied code names CASE_ENFORCEMENTS.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_VIOLATIONS [undetermined]: EPA ICIS FE&C Case violation records; the supplied code names CASE_VIOLATIONS.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_PENALTIES [undetermined]: EPA ICIS FE&C Case penalty records; the supplied code names CASE_PENALTIES.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_FACILITIES [undetermined]: EPA ICIS FE&C Case facility records; the supplied code names CASE_FACILITIES.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_DEFENDANTS [undetermined]: EPA ICIS FE&C Case defendant records; the supplied code names CASE_DEFENDANTS.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_MILESTONES [undetermined]: EPA ICIS FE&C Case milestone records; the supplied code names CASE_MILESTONES.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_ENFORCEMENT_CONCLUSIONS [undetermined]: EPA ICIS FE&C Enforcement conclusion records; the supplied code names CASE_ENFORCEMENT_CONCLUSIONS.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_ENFORCEMENT_TYPE [undetermined]: EPA ICIS FE&C Enforcement type records; the supplied code names CASE_ENFORCEMENT_TYPE.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_INSPECTIONS [undetermined]: EPA ICIS FE&C FE&C inspections used to construct facility-month and firm-month observations; the supplied code names ICIS_FEC_EPA_INSPECTIONS.csv. Exact source rows, keys, version and period coverage are unverified.
- R_FEC_CASE_RELATED_ACTIVITIES [undetermined]: EPA ICIS FE&C Related case activity records used for the investigation-timeline outcome; the supplied code names CASE_RELATED_ACTIVITIES.csv. Exact source rows, keys, version and period coverage are unverified.
- R_CASE_MATCH [undetermined]: MatchedCase.csv, an author-prepared case-number-to-security matching file used by program 2, distinct from the TRI parent-company mapping.
- R_SEC_INDEX [undetermined]: Author table database.Uniquefile_form, consumed to add Form_Type and Date_Filed to EDGAR records; the source program joins by CIK and accession.
- R_WRDS_GVKEY_CIKLINK [undetermined]: WRDS_GvkeyCIKlink.csv, the supplied-code GVKEY–CIK matching input. Its validity dates, duplicate handling and provenance are unresolved; a catalog alias nonmatch is not an absence finding.
- R_CCMXPF_LNKHIST [undetermined]: Author-coded ccmxpf_lnkhist.sas7bdat historical GVKEY–PERMNO link input. Required link intervals and table mapping remain unverified.
- R_COMPUSTAT_CCM_FUNDA [undetermined]: Author-coded database.ccm_funda.sas7bdat table is used both for FY2002–2018 linkage/fundamentals and for liquidity/profitability/solvency fields. Required combined table/key contract is not established.
- R_CRSP_MSF [undetermined]: Author-coded database.crsp_msf.sas7bdat monthly security input. The code requires PERMNO/DATE linkage plus SICCD, NAICS, SHRCD and EXCHCD; exact product/vintage and date coverage are unresolved.
- R_LM_COMPLEXITY [undetermined]: Loughran–McDonald 10-K complexity file named by program 3 as LoughranMcDonald_10KComplexity_2001-2018.csv; exact author-file identity and rows are unverified.
- R_CALENDAR [undetermined]: Author-prepared calendar.csv imported by Merge/clean to map annual observations and event dates to months.
- R_NLPSA [undetermined]: Author-coded database.Nlpsa.sas7bdat filing-level table used to derive monthly new filing indicators and filing counts.
- R_CASE_TIMELINE [undetermined]: Hand-collected Case_discovery_timeline.csv used with FE&C related activities to compute investigation distance; exact case-key and date coverage are unresolved.
- R_AFFECTED_INDUSTRY [undetermined]: Author-prepared AffectedIndustry.dta mapping imported for rule-to-industry/event-month expansion; the source program uses publication_date, NAICS fields and rule ID.
- R_RULE_SOURCE [undetermined]: Local author-prepared Data/rule.dta source imported by Merge/clean to join regulatory abstracts by rule ID; distinct from the final Output/rule.dta export.
- R_COMPUSTAT_SEGMENT_GEO [undetermined]: Author-coded database.Compustat_segment_geo.sas7bdat geography/segment table; source groups by GVKEY, DATADATE and SID and classifies geography using SNMS and sales.
- R_DIRECTEDGAR_8K [undetermined]: DirectEdgar_8K.csv vendor/author file imported by the Descriptive results program; exact fields, source period and vendor-file version are not documented.
- S_SAS94 [unverified]: Environment metadata marks SAS unverified and supplies no version. PROC REG is used in the SAS source; SAS/STAT availability is unverified. No SAS process was started for this assessment.
- S_CORRTBL [preparation_required]: The supplied Stata script calls corrtbl, but the bounded Stata 18 `which` check did not find it. A compatible author-used source/version is not established; no installation was attempted.

## Review notes

- The four exact packaged final DTA files are documented by the author README, readable in one-row probes, and contain the selected downstream Stata fields. The bounded analysis_only scope uses these files, including the supplied case.dta p_distance; coverage_verified=false describes the one-row probe and is not a prerequisite for an independent full-data sweep or author confirmation. The scope covers only the supplied Stata final-data branch and does not claim full-paper success.
- The README-numbered order omits a concrete cross-language handoff: Merge/clean exports case_distance.dta, Step 5 reads and predicts case_pdistance.dta, then Merge/clean resumes at that import and exports the final case.dta. The active producer/consumer sequence and shared Output-root setup are documented as a preparation action; the raw prediction stage remains separate from analysis_only.
- The frozen work item has 80 dependency IDs. The dependency_review table covers D0001–D0080 exactly once. External inputs are distinct requirements, except the 21 annual TRI files are a homogeneous year partition. Generated rows cite the active producer evidence and have empty target_ids; the two missing include files map to I_SUPPORTING_SAS.
- Bounded official/author page checks are captured in probes/public_route_checks.json. SEC logs/full-index, EPA TRI/FE&C, and the LM complexity page provide plausible source routes; no data pages/files were downloaded. Federal Register was named as context in the datasheet, but no supplied program directly reads a Federal Register file/URL; the actual local rule/industry/calendar inputs remain distinct author-prepared requirements.
- Frozen catalog candidates COMP.FUNDA, CRSP.MSEALL, CRSP.CCMXPF_LNKHIST and COMPSEG.WRDS_SEGMERGED each have a successful exact one-row field/readability probe. These observations credit the readable underlying fields; they do not establish author-table aliases, source-to-prepared mappings, link/segment row contracts or complete history. Alias differences and coverage_verified=false are not absence or entitlement findings.
- Software fields were limited to explicit availability/version/path and bounded which results. Stata 18, reghdfe 6.12.3, ftools 2.49.1, esttab 2.1.1, ppmlhdfe and coefplot were found; corrtbl was not found. SAS/SAS-STAT remain unverified. No author code/data was executed/imported, no installation was attempted and no SAS process was started.
- Process-only history is preserved by unreferenced inspection evidence rows and probe records, including the failed prior path/empty-helper attempts, summary-helper failures and the source-screening method limitation. These records are uncited scientifically and do not create an access barrier or feasibility claim.
- The earlier finalizer attempts, readonly submitted copies and the previously completed pair were preserved before this reassessment under the assigned generation's probes directory. This is process history only and is not cited as scientific evidence.
