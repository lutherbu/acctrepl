# Patch proposal: jar-9576dd101acb

Occupational Licensing and Accountant Quality: Evidence from the 150-Hour Rule

DOI: 10.1111/1475-679X.12408

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied author preparation branches: CPA profile cleaning followed by CPA working-data construction/CEM, then the textual-metrics preparation handoff; and the independent NASBA university-supply preparation program. Relative-path roots, unproduced lookup inputs, and text-path copies must be reconciled before a full attempt.

Entry points: `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/1_Clean_Raw_Data.do`, `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do`, `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/3_Textual_Analysis/Build_Working_Data.do`, `Barrios-datasheet-code/Build_Code/NASBA_Supply_Sample/Build_Working_Data.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12408 - Occupational-Licensing-and-Accountant-Quality-Evidence-from-the-150-Hour-Rule/barrios-datasheet-code.zip",
      "sha256": "2b53e5e8751db306cd4d2b4f909cdbd5db40a4ea3b256a01919430d65dabf389"
    },
    {
      "path": "JAR-Volume 60/Issue 1/12408 - Occupational-Licensing-and-Accountant-Quality-Evidence-from-the-150-Hour-Rule/barrios-online-appendix.pdf",
      "sha256": "56b65d2fe9c0ec1ad66bacc7d271035f13a9a47227f3951ab26e2b7155731167"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "88571b31a12dbe45b460395524bcbc3b19274f8dbda23882376ef574028b437c"
}
```

## Proposed actions

### A_PROFILE_INPUTS: Obtain the two author-compatible profile-history inputs and establish their current permitted route, exact headers, common key contract, and historical coverage before staging the required filenames.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_EXPERIENCE, R_EDUCATION, I_PROFILE_INPUTS
Evidence: E_DATASHEET_ACCESS, E_PROFILE_SELECTION, E_EXP_IMPORT, E_EXP_FIELDS, E_EDU_FIELDS

Preparation / proposed procedure:

1. Ask the authors or authorized provider whether compatible prepared employment and education CSVs are available; do not treat the historical Recruiter-account description as proof that every current route is blocked.
2. Obtain the exact employment and education source schemas, identifier types, and the authors' declared snapshot/population coverage for summer 2014 and fall 2016 across the 11-state sample.
3. Stage only compatible files as raw/experience_info.csv and raw/education_info.csv in the CPA working copy after confirming the expected input contract.

Validation to perform later:

- Before an authorized run, confirm varnames(1) yields the source variables listed by the requirements, the profile keys align across files, and reported job and degree history matches the author-declared coverage.
- Confirm the Stata string/numeric type of end_year before applying the proposed source edit in A_FIX_END_YEAR.

### A_DIRECTORY_LOOKUPS: Prepare and map the CPA profile directory, state-level adoption-year lookup, and text branch's person-key adoption crosswalk as distinct inputs; confirm the branch-specific path and case handoff.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_DIRECTORY, R_STATE_ADOPTION, R_TEXT_ADOPTION, I_DIRECTORY_INPUTS, I_TEXT_HANDOFF
Evidence: E_DIR_CROSSWALK, E_BUILD_LOOKUPS, E_TEXT_DIRECTORY_MERGE, E_TEXT_ADOPTION_MERGE, E_TEXT_WORKING_MERGE, E_TEXT_SUMMARY_MERGE, E_ADOPTION_TABLE, E_ADOPTION_LATEST, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain the author's cleaned directory with its key, names, gender, state, and job-market-entry-year fields; no supplied program produces it.
2. Use Appendix Table 1's Jurisdiction and Effective Date as the documented source for the state-level adoption year, subject to confirming the author's state-label normalization and preparing state and EffectiveYear fields.
3. Obtain the separate Adoption_Linking_File mapping profile key to state_id and EffectiveYear; do not substitute the state-level adoption table for this per-profile crosswalk.
4. Confirm the intended current directory for each entry point and stage the CPA files under output/ while placing the text branch copies under its author-confirmed 2_Data/input, 2_Data/temp, and 2_Data/raw paths.

Validation to perform later:

- Check the directory's required fields and key/state types against both CPA consumers, and check Adoption_Linking_File contains key, state_id, and EffectiveYear.
- Check the adoption table maps each required directory state to the intended effective year and that the lower-case text paths are intentional copies of the CPA-produced intermediates before running merges.

### A_COMPANY_ROSTERS: Validate the three readable catalog candidates against the dated author roster products before SAS-to-Stata staging under the exact source aliases.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_AA_ROSTER, R_COMPUSTAT_ROSTER, R_CRSP_ROSTER, I_ROSTER_HISTORY
Evidence: E_AA_ROSTER, E_COMP_ROSTER, E_COMP_ROSTER_WIDE, E_CRSP_ROSTER, E_CATALOG_FIELDS, E_AA_PROBE, E_COMP_PROBE, E_CRSP_PROBE

Preparation / proposed procedure:

1. Ask the authors to identify the vintage, population, identifiers, and required history for public_acc_audit_0731, public_acc_compustat_0731, and crsp_0803.
2. Compare those contracts with the bounded-readable local candidates AUDIT.FEED01_AUDITORS, COMP.FUNDA, and CRSP.DSENAMES; catalog hits and one-row readability alone do not establish compatible rosters.
3. After author-vintage and identifier compatibility are established, stage converted working copies at raw/public_acc_audit_0731.dta, raw/public_acc_compustat_0731.dta, and raw/crsp_0803.dta while preserving the code's 2018 Compustat branch and its separate wider-name-list branch.

Validation to perform later:

- Check the prepared source fields AUDITOR_KEY/AUDITOR_NAME, gvkey/conm/fyear, and PERMNO/COMNAM, plus the author-confirmed periods and entity/identifier semantics before matching.
- Confirm the Stata staging conversion preserves names, keys, and both Compustat source branches without replacing an unverified candidate.

### A_TEXT_METRIC_INPUT: Request the author-prepared Desc_Complex input or its documented producer and metric contract; the supplied code consumes the metrics but does not create them.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_TEXT_METRICS, I_TEXT_PRODUCER
Evidence: E_TEXT_INPUT_PATH, E_TEXT_JOBS, E_TEXT_METRIC_FIELDS, E_TEXT_FORMULAS

Preparation / proposed procedure:

1. Ask for the prepared 2_Data/raw/Desc_Complex.dta or exact authorized source and construction documentation for the description-level observations.
2. Confirm how key, Num_Job, des, fog_index, flesch_score, num_words, num_sentences, and Total_Job were produced, including metric units, missing-value treatment, and profile-period coverage.
3. Do not reconstruct author text metrics from a generic Fog/Flesch formula until the author-specific scoring and description input are documented.

Validation to perform later:

- Before the textual branch, verify the prepared file has the consumed fields, profile key, job sequence, and author-confirmed units/coverage; compare the metric definition to the supplied appendix formulas.
- Confirm no separate upstream producer is required to create Desc_Complex.dta.

### A_NASBA_INPUT_AND_SCHEMA: Establish an authorized current route to the NASBA university-level input and its exact Stata variable namespace before running the independent supply branch.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_NASBA, I_NASBA_INPUT, I_NASBA_NAMES
Evidence: E_DATASHEET_ACCESS, E_NASBA_READ, E_NASBA_LABEL_BLOCK, E_NASBA_RULE_BLOCK, E_NASBA_SITTING_INTERACTION, E_NASBA_INPUT_COUNTS

Preparation / proposed procedure:

1. Ask the authors for the June 2016 prepared DTA and its schema, period, and university coverage, or verify the current official public NASBA PDF route and the author's transcription contract.
2. Do not treat historical proprietary origin as proof that the present prepared-data or public-manual route is blocked.
3. Confirm which input variables exist for Year, EffectiveYear, State_cl, May_Nov, GRAD, ALL, NONE, NUMBEROFCANDIDATES, AUDITING, LAW, PRACTICE, THEORY, SOME, Rule_150, Int_150, yearb1, and log_Cand; distinguish generated log_cand and Rule_1 from those source names.

Validation to perform later:

- Check the input variable names and year/university coverage against the required NASBA fields before Stata staging.
- Confirm the distinct log_Cand input and log_cand generated variable, the Rule_150 versus Rule_1 relationship, and the source's Int_150 drop/recreate behavior from the actual input schema and author intent; do not guess a rename.

### A_MATCHIT_SETUP: Provide an author-compatible matchit release in the Stata adopath and verify the source's similmethod(token_soundex) option support.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_MATCHIT
Evidence: E_MATCHIT, E_TOKEN_LOOKUP, E_MATCHIT_DOCS, E_MATCHIT_CALL, E_MATCHIT_CALL_SECOND

Preparation / proposed procedure:

1. Set up the matchit Stata command from its author-supported distribution at a release compatible with the available Stata 18 runtime.
2. Treat token_soundex as a built-in matchit similmethod() value, not a standalone ado command or independent installation requirement.

Validation to perform later:

- In a later authorized software-only check, confirm which matchit resolves and its help documents similmethod(token_soundex) for the chosen release.
- Confirm the actual matchit option names used by both company-name matching calls before author-code execution.

### A_OTHER_STATA_ADDONS: Set up the missing distinct, winsor2, cem, and dups commands at author-compatible Stata releases; all four actual command lookups returned not found.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_DISTINCT, S_WINSOR2, S_CEM, S_DUPS
Evidence: E_DISTINCT, E_DISTINCT_CALLS, E_WINSOR2, E_WINSOR2_CALLS, E_CEM, E_CEM_CALL, E_DUPS, E_DUPS_CALL

Preparation / proposed procedure:

1. Identify the author-compatible releases and configure the Stata adopath for distinct, winsor2, cem, and dups without changing their call arguments.
2. Preserve the driver's two winsor2 calls, CEM specification, and dups key, terse drop command contract.

Validation to perform later:

- In a later authorized software-only check, confirm which and help resolve for each exact invoked command and option set under the selected Stata runtime.
- Do not run the author preparation driver as part of software availability checks.

### A_FIX_END_YEAR: If the confirmed CSV schema leaves end_year as a string at the beginning of this block, remove the premature duplicate conversion and retain the existing string cleanup and final destring.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I_END_YEAR_TYPE, R_EXPERIENCE
Evidence: E_END_YEAR_BEFORE, E_END_YEAR_AFTER, E_EXP_FIELDS

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/1_Clean_Raw_Data.do:64–64`
Source SHA-256: `b98fb451252a90bc5e360f7472124798974dc3f2eb0852ee8722c01a667ffe21`

Conditional on confirming end_year is imported as a string: remove the early destring that precedes the source's string cleanup, retaining the final conversion after replacements and sieve().

Current text:
```
	destring end_year, replace force
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. First confirm the raw end_year type and prescribed import result from the author-compatible experience CSV.
2. If string, apply only the line 64 deletion proposed below; preserve the replacements, egen sieve() call, and final destring at line 109.

Validation to perform later:

- Review the exact source diff against the frozen code and confirm the author input's string cleanup still precedes the retained final numeric conversion.
- Run a future authorized preparation check only after all inputs and software are resolved.

### A_FIX_VARLIST: Correct the foreach keyword typo at line 1468 without changing the loop variables or replacement logic.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_VARLIST
Evidence: E_VARLIS

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/1_Clean_Raw_Data.do:1468–1468`
Source SHA-256: `b98fb451252a90bc5e360f7472124798974dc3f2eb0852ee8722c01a667ffe21`

Correct the foreach keyword token while preserving the existing loop list and replacements.

Current text:
```
	foreach x of varlis Accounting Finance Marketing Law Management Banking Big4 Big4_First BigN BigN_First Tax has_cpa{
```

Proposed replacement:
```
	foreach x of varlist Accounting Finance Marketing Law Management Banking Big4 Big4_First BigN BigN_First Tax has_cpa{
```

Preparation / proposed procedure:

1. Apply the single-token source edit below in an authorized working copy after preserving the frozen original.

Validation to perform later:

- Compare the proposed line against the source and later confirm Stata accepts the foreach varlist form during an authorized run.

### A_FIX_CONTINUATIONS: Change only the reviewed single-slash line endings that introduce continued expressions/lists in the CPA working-data driver to Stata continuation markers.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_LINE_CONTINUATIONS
Evidence: E_BUILD_CONT_1, E_BUILD_CONT_2, E_BUILD_CONT_3, E_BUILD_CONT_4, E_BUILD_CONT_5, E_BUILD_CONT_6, E_BUILD_CONT_7, E_BUILD_CONT_8

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:29–30`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		replace In_ACC = 0 if In_ACC == 1 & lower(title) == "information technology" //
			| lower(title) == "technical communications assistant" //
```

Proposed replacement:
```
		replace In_ACC = 0 if In_ACC == 1 & lower(title) == "information technology" ///
			| lower(title) == "technical communications assistant" ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:43–43`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		replace In_ACC = 0 if In_ACC == 1 & strpos(lower(title), "adminis") >0 //
```

Proposed replacement:
```
		replace In_ACC = 0 if In_ACC == 1 & strpos(lower(title), "adminis") >0 ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:47–47`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		replace In_ACC = 0 if In_ACC == 1 & strpos(lower(comp), "society") >0 //
```

Proposed replacement:
```
		replace In_ACC = 0 if In_ACC == 1 & strpos(lower(comp), "society") >0 ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:67–67`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		gen Job1_Start_Year_Temp = start_year if job_order == 1 & Intern_Check == 0 //
```

Proposed replacement:
```
		gen Job1_Start_Year_Temp = start_year if job_order == 1 & Intern_Check == 0 ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:153–154`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
	keep key Non_ACC_Mast ACC_Mast Masters year_enter_job_market clean_name //
	State Post_150 Pre_150 Male state Year_Eval Total_Job mean_dur_yr BigN //
```

Proposed replacement:
```
	keep key Non_ACC_Mast ACC_Mast Masters year_enter_job_market clean_name ///
	State Post_150 Pre_150 Male state Year_Eval Total_Job mean_dur_yr BigN ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:238–238`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
	order key total_change total_change_order job_order Total_Job Seniority //
```

Proposed replacement:
```
	order key total_change total_change_order job_order Total_Job Seniority ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:437–437`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		replace partner = 1 if strpos(title, "Partner")>0 | strpos(title, "partner")>0 //
```

Proposed replacement:
```
		replace partner = 1 if strpos(title, "Partner")>0 | strpos(title, "partner")>0 ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:461–464`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		replace BigN2 = 1 if strpos(lower(comp),"deloi") >0 | strpos(lower(comp),"touch") >0 //
		 | strpos(lower(comp),"pwc") >0 | strpos(lower(comp),"pricew") >0 //
		 | strpos(lower(comp)," ey ") >0 | strpos(lower(comp),"ernst ")>0 //
		 | strpos(lower(comp),"& young ")>0 | strpos(lower(comp),"kpmg")>0 //
```

Proposed replacement:
```
		replace BigN2 = 1 if strpos(lower(comp),"deloi") >0 | strpos(lower(comp),"touch") >0 ///
		 | strpos(lower(comp),"pwc") >0 | strpos(lower(comp),"pricew") >0 ///
		 | strpos(lower(comp)," ey ") >0 | strpos(lower(comp),"ernst ")>0 ///
		 | strpos(lower(comp),"& young ")>0 | strpos(lower(comp),"kpmg")>0 ///
```

**Proposed edit:** `Barrios-datasheet-code/Build_Code/CPA_Profile_Sample/2_Build_Working_Data.do:506–509`
Source SHA-256: `f295f9ca083731d09b12c2c92488ae9c06d854d177b1e2f37f7a5de876e28ee1`

Restore the Stata line-continuation marker without changing the continued expression or variable list.

Current text:
```
		replace Job_Bign = 1 if strpos(lower(comp),"deloi") >0 | strpos(lower(comp),"touch") >0 //
		 | strpos(lower(comp),"pwc") >0 | strpos(lower(comp),"pricew") >0 //
		 | strpos(lower(comp)," ey ") >0 | strpos(lower(comp),"ernst ")>0 //
		 | strpos(lower(comp),"& young ")>0 | strpos(lower(comp),"kpmg")>0 //
```

Proposed replacement:
```
		replace Job_Bign = 1 if strpos(lower(comp),"deloi") >0 | strpos(lower(comp),"touch") >0 ///
		 | strpos(lower(comp),"pwc") >0 | strpos(lower(comp),"pricew") >0 ///
		 | strpos(lower(comp)," ey ") >0 | strpos(lower(comp),"ernst ")>0 ///
		 | strpos(lower(comp),"& young ")>0 | strpos(lower(comp),"kpmg")>0 ///
```

Preparation / proposed procedure:

1. Apply the exact line-ending edits below in an authorized working copy; preserve every predicate and variable name.

Validation to perform later:

- Review that only the listed line endings changed and, after inputs/software are ready, validate the source through a future authorized Stata run.

### A_CLARIFY_CCM_CHUNKS: Ask the authors to confirm intended Compustat ID chunk coverage and the final merge range before repairing the inconsistent chunk loops.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CCM_CHUNKS
Evidence: E_CCM_PARTITIONS, E_CCM_MATCH_LOOPS

Preparation / proposed procedure:

1. Confirm whether all 0..40000 chunks are intended for company-name matching or only the 28000..40000 range, and confirm how the clean-match tempfile macros should be created and merged.
2. Do not invent loop bounds, drop nonmatched chunks, or alter name-match criteria while the intended source range is unknown.

Validation to perform later:

- Compare the author-confirmed range against both producer loops and the later merge loop before proposing any source edit.

### A_CLARIFY_LONG_TENURE: Confirm the raw experience-file field and intended target of the long-tenure aggregation before changing line 274.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LONG_TENURE, R_EXPERIENCE
Evidence: E_LONG_TENURE, E_EXP_FIELDS

Preparation / proposed procedure:

1. Ask the authors whether long_tenure exists in the raw employment extract and whether the replacement should update long_tenure or the immediately created long_tenure_check.
2. Retain the current code until that field and intent are documented; do not add an assumed column or silently rename the target.

Validation to perform later:

- Compare the confirmed raw schema and author response to lines 273-275 before proposing a narrowly scoped repair.

### A_ORDERED_RUN_PROCEDURE: After input, software, CWD, and source issues are resolved, execute the supplied preparation branches in their supported producer order while keeping textual and NASBA inputs distinct.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_TEXT_HANDOFF
Evidence: E_WORKFLOW_TRACE, E_CLEAN_COMPANY_OUTPUT, E_STAGE2_PANEL, E_PANEL_FULL_SAVE, E_WORKING_IND_FULL_SAVE, E_WORKING_INDIVIDUAL_SAVE, E_TEXT_WORKING_MERGE, E_TEXT_SUMMARY_MERGE, E_NASBA_READ

Preparation / proposed procedure:

1. Use a CPA_Profile_Sample working copy as the current directory, create its referenced raw, temp, output, and check directories, and stage the compatible profile, lookup, and company-roster inputs.
2. After resolving the listed source and software requirements, run 1_Clean_Raw_Data.do first; it produces Experience_Clean, Title_Clean, Company_Clean, Ind_Emp_Sum, and Education_Clean.
3. Run 2_Build_Working_Data.do second from the same CPA working directory; it consumes the cleaning outputs plus the cleaned directory and state-level adoption lookup and produces working_individual_data and its CEM output.
4. Run the textual Build_Working_Data.do third only from the author-confirmed working directory after Desc_Complex.dta and the separate 2_Data/input and 2_Data/temp handoffs are staged and schema-checked; it produces 2_Data/output/Desc_clean.
5. Run NASBA_Supply_Sample/Build_Working_Data.do as its own branch from its confirmed NASBA working directory after the prepared NASBA input and source namespace are resolved; it produces output/workingdata.dta.

Validation to perform later:

- Before each future run, verify the exact current directory and required input/output directory names because none of the four programs supplies an explicit cd command.
- After each branch, verify the named source outputs exist and the next branch's key names, types, and case-specific paths match its documented handoff; do not run text preparation before CPA stage 2.
- No regression/estimation driver or compatible analysis-data route is supplied in this package; this proposal covers the four supplied preparation programs only.


## Remaining issues and prerequisites

- I_PROFILE_INPUTS [unresolved; full_pipeline]: The release lacks both profile CSVs. The documented 2014/2016 Recruiter history does not verify a current compatible export, exact CSV headers, key consistency, or complete job/education-history coverage; no access barrier was established.
- I_DIRECTORY_INPUTS [unresolved; full_pipeline]: The cleaned profile directory and text key-to-state adoption crosswalk are not produced or packaged. The appendix provides a jurisdiction/effective-date table that can inform the separate state-level State_Adoptions lookup, but exact state-label normalization, the directory fields/route, and the profile-key-to-state_id mapping remain unresolved. The source programs expect these files under different roots.
- I_ROSTER_HISTORY [unresolved; full_pipeline]: Local catalog candidates match the required Audit Analytics auditor key/name, Compustat gvkey/conm/fyear and CRSP permno/comnam fields and passed one-row reads. The author's dated roster vintages, population, periods and identifier semantics remain unverified, so these are not verified substitutes.
- I_TEXT_PRODUCER [unresolved; full_pipeline]: No supplied source creates Desc_Complex.dta or computes the consumed fog_index, flesch_score, num_words and num_sentences fields. Appendix formulas document Fog/Flesch definitions, but do not establish the author scoring implementation or the prepared field units/missingness.
- I_TEXT_HANDOFF [unresolved; full_pipeline]: The text branch reads separate 2_Data paths for the directory, Adoption_Linking_File, working_ind_full and ind_emp_sum. The CPA producers write temp/working_ind_full and output/Ind_Emp_Sum under another root/case; no copy, key/schema check, or CWD configuration establishes those as the same inputs.
- I_NASBA_INPUT [unresolved; full_pipeline]: The independent NASBA branch's university-level DTA is absent. The datasheet documents historical public-PDF digitization and the code mentions contacting NASBA, but current official URLs, delivery, exact fields and year/university coverage remain unverified; there is no access-barrier proof.
- I_NASBA_NAMES [unresolved; full_pipeline]: The NASBA program labels log_Cand, Rule_150, Int_150, and yearb1, later generates log_cand and Rule_1, and drops/recreates Int_150. Stata treats log_Cand and log_cand as distinct variable names; the unseen input's actual variables and the intended relationship of Rule_150 to Rule_1 and the other labeled variables remain unknown. Confirm the input schema and author intent before running; do not invent an alias or repair.
- I_END_YEAR_TYPE [preparation; full_pipeline]: Clean Raw Data destrings end_year at line 64, then performs string replacements and egen sieve(end_year) through line 107, and destrings again at line 109. The early conversion conflicts with the intervening string operations. A supported preparation edit removes the duplicate early conversion so the existing final conversion follows the string cleanup.
- I_VARLIST [preparation; full_pipeline]: The foreach statement at line 1468 uses varlis rather than the varlist keyword used by nearby foreach statements. The source correction is a mechanical token repair with no change to the listed variables.
- I_LINE_CONTINUATIONS [preparation; full_pipeline]: The working-data driver ends multiple continued statements/lists with single // and starts the next line with a bare operator or field. These markers terminate the prior line as comments. Changing only those markers to /// preserves the authored conditions and lists.
- I_CCM_CHUNKS [unresolved; full_pipeline]: The Compustat roster is split into 0..40000 ID chunks, but the match-result producer loop covers only 28000..40000; a later merge loop requests tempfile macros for 0..40000 although only 28000..40000 were created. The intended match coverage and correct final loop bounds require clarification; no chunk range or sample restriction is guessed.
- I_LONG_TENURE [unresolved; full_pipeline]: The code initializes and aggregates long_tenure_check but line 274 replaces long_tenure. Without the experience CSV schema this may be a missing input field or a misdirected source assignment; confirm whether long_tenure exists and the intended check target before changing it.
- R_EXPERIENCE [undetermined]: LinkedIn profile employment-history CSV imported as raw/experience_info.csv; rows must retain the author's key and complete reported job spells. The exact source header/order, key type/order, and current compatible historical export route are not verified.
- R_EDUCATION [undetermined]: LinkedIn profile education-history CSV imported as raw/education_info.csv; it must join to employment records using the same author key and carry reported schools/degrees/dates needed to derive Year_Graduated and degree indicators.
- R_DIRECTORY [undetermined]: Author-prepared cleaned profile directory expected at output/Comb_Directory_Cleaned_Noduplicates. It supplies the person key, names, gender, state, and year_enter_job_market. The textual program separately expects a same-named file under 2_Data/input; no producer or copy mapping is supplied.
- R_STATE_ADOPTION [undetermined]: State-level 150-hour adoption-year table expected at output/State_Adoptions and merged on state; the build code consumes EffectiveYear. The supplied appendix contains jurisdiction effective dates, but the state-label mapping and exact prepared table remain unverified.
- R_AA_ROSTER [undetermined]: Audit Analytics auditor-name/key roster consumed by CPA company matching from raw/public_acc_audit_0731.dta.
- R_COMPUSTAT_ROSTER [undetermined]: Compustat company-name and gvkey roster consumed by CPA company matching from raw/public_acc_compustat_0731.dta. The code also filters fyear == 2018 for one normalization branch and separately uses the wider name list.
- R_CRSP_ROSTER [undetermined]: CRSP company-name/PERMNO list consumed from raw/crsp_0803.dta by the CPA company matching stage.
- R_TEXT_ADOPTION [undetermined]: Text-branch key-to-state adoption crosswalk expected at 2_Data/input/Adoption_Linking_File with key, state_id and EffectiveYear. This profile-level table is distinct from output/State_Adoptions and is not produced by the supplied programs.
- R_TEXT_METRICS [undetermined]: Prepared description-level dataset 2_Data/raw/Desc_Complex.dta consumed by the textual branch. Its producer and score/field contract are unknown beyond source reads; no compatible prepared file is included.
- R_NASBA [undetermined]: University-level NASBA prepared input raw/FULL_NASBA_Universities_Work_June2016.dta consumed by the independent supply branch. The program writes output/workingdata.dta and needs a schema matching its labels, calculations and year/state identifiers.
- S_MATCHIT [preparation_required]: which matchit returned not found. The source calls matchit with similmethod(token_soundex); the author repository identifies token_soundex as a built-in matchit method, not a separate command. Provide a compatible matchit release and verify that release's option support; do not install token_soundex independently.
- S_DISTINCT [preparation_required]: The CPA working-data driver invokes distinct; which distinct returned not found in the checked Stata 18 adopath.
- S_WINSOR2 [preparation_required]: The CPA working-data driver invokes winsor2 twice; which winsor2 returned not found in the checked Stata 18 adopath.
- S_CEM [preparation_required]: The CEM stage invokes cem; which cem returned not found in the checked Stata 18 adopath.
- S_DUPS [preparation_required]: The working-data driver invokes dups key, terse drop; which dups returned not found. Preserve this exact command contract and provide the author-compatible command before a run.

## Review notes

- Static review covers the datasheet, appendix, and all four supplied Stata programs. No author program, import, estimation, data transformation, or syntax trial was run.
- The scope keeps CPA profile cleaning first, CPA working-data/CEM construction second, textual-metrics preparation third with its separate 2_Data inputs, and the independent NASBA supply branch distinct. Appendix Figure 6 analysis is contextual because no corresponding analysis program or compatible analysis-data route is supplied.
- All 33 frozen dependency IDs are individually reviewed from the source-based producer/consumer trace in probes/workflow_trace.json. Catalog-listed SAS candidates passed bounded row_limit=1 metadata reads, but their author-vintage and population compatibility remains unverified.
- The appendix provides a packaged jurisdiction/effective-date adoption table; its conversion to the author's exact state labels remains unverified. The text branch's Adoption_Linking_File is a separate unresolved profile-key crosswalk.
- Stata's which token_soundex result is preserved as a check of the option name, not as a missing standalone command: the matchit author documentation identifies token_soundex as a built-in similmethod().
- The NASBA source's log_Cand and log_cand spellings are distinct Stata variable names; the uncertainty is the unseen input schema and source intent for labels, Rule_150 versus Rule_1, and the actual Int_150 drop/recreation.
