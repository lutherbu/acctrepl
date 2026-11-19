# Patch proposal: jar-3720bc1e52aa

Did the FASB Codification Reduce the Complexity of Applying U.S. GAAP?

DOI: 10.1111/1475-679X.12480

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied SAS preparation workflow, including separate Compustat and Audit Analytics branches, the author-prepared crosswalks and manual input maps, the embedded Stata Table 4 restatement and Table 6 comment analyses, and the descriptive XML output stage.

Entry points: `BHK JAR Code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12480 - Did-the-FASB-Codification-Reduce-the-Complexity-of-Applying-U-S-GAAP/bhk-datasheet-code-and-identifiers.zip",
      "sha256": "3b4c3f1b7c23e0b9a83a5531f673d487872d03559709050e7410c1181824b844"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12480 - Did-the-FASB-Codification-Reduce-the-Complexity-of-Applying-U-S-GAAP/bhk-online-appendix.pdf",
      "sha256": "b955f33007175d6baacce6ae840fa47ca469d6f5a4579a765b95ca1142afdfb7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "bf52d60ce7d26780f29e18533b7dc560245a6992ae7f8b8eefad1fbec20e59dc"
}
```

## Proposed actions

### A-AUTHOR-WORKBOOKS: Identify or obtain the five exact author-prepared workbooks named in the supplied SAS source, and establish their field/type/history contracts. Treat each workbook as a separate jointly required input. The supplied identifier list does not replace any of them.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R-SEC-OFFICE, R-RESTATE-TAXONOMY, R-CL-TIMEPERIOD, R-RESTATE-FORM, R-CODIFICATION-CROSSREF, ISS-AUTHOR-WORKBOOKS
Evidence: E-CODE-WORKBOOKS, E-CODE-TAXONOMY-WORKBOOK, E-CODE-CL-TIMEPERIOD-WORKBOOK, E-CODE-RESTATE-FORM-WORKBOOK, E-CODE-CROSSREF, E-CODE-CROSSREF-HOME, E-WORK-ITEM-INVENTORY, E-DATASHEET-IDENTIFIERS, E-PROBE-IDENTIFIERS, E-FASB-BASICVIEW

Preparation / proposed procedure:

1. Locate the author release for SEC_Office.xlsx, Restate_Taxonomy_JAR.xlsx, cl_timeperiod.xlsx, Restate_form.xlsx and Codification_CrossRef.xlsx; if the files are unavailable, request their construction details and permitted delivery route.
2. For SEC_Office, confirm SIC4, SEC_OFFICE and Industry_Title definitions and the office mapping period; for Restate_Taxonomy, confirm the Restatement___category_key to accounting_topic map.
3. For cl_timeperiod, confirm COMPANY_FKEY/CL_CON_ID joins, PF coding and CL_BDATE/CL_EDATE types; for Restate_form, confirm ASC_TOPIC, BEG_DATE, END_DATE, YEAR and C_QTR.
4. For Codification_CrossRef, confirm both All and Home sheets, the listed columns, numeric/text types, and compatibility with the December 2019 snapshot. The free Basic View check establishes content access only, not the exact workbook export.
5. Place verified files under a portable run root while preserving distinct filenames and sheet names; do not reconstruct manual mappings without an author specification.

Validation to perform later:

- Inventory each acquired workbook, file hash, sheet names and required headers/types without running workbook macros.
- Check required SEC Office IDs, taxonomy keys/topics, CL conversation keys/date/PF fields, Restate Form date/topic fields, and both CrossRef sheet schemas before any full run.

### A-COMPUSTAT-FUNDQ: Confirm the local Compustat North America quarterly candidate is the compatible product and covers the author filter before mapping it to compd.fundq.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R-COMPUSTAT-FUNDQ
Evidence: E-CODE-FUNDQ-FIELDS, E-CAT-COMP-FUNDQ, E-PROBE-COMP-FUNDQ

Preparation / proposed procedure:

1. Verify permitted access, product vintage and date range FYEARQ 2000–2016; confirm all 20 required fields in the source metadata.
2. If compatible, map the physical COMP.FUNDQ candidate to the source alias compd.fundq or stage an equivalent table with the author field names and types.
3. Preserve the source filters INDFMT=INDL, DATAFMT=STD, POPSRC=D, CONSOL=C and the nonmissing date/assets-times-sales conditions.

Validation to perform later:

- Check dataset labels, field types, date coverage and matching alias before submitting the full supplied workflow.
- Confirm that a one-row schema check has not been represented as period or population coverage.

### A-COMPUSTAT-COMPANY: Use the verified local COMP.COMPANY route through the source alias compd.company. Preserve the supplied GVKEY join and SIC1/SIC2/SIC4 derivations; retain a future join/output-fidelity check.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: R-COMPUSTAT-COMPANY
Evidence: E-CODE-COMPANY-FIELDS, E-CAT-COMP-COMPANY, E-PROBE-COMP-COMPANY, E-PROBE-IDENTIFIERS, E-PROBE-COMP-COMPANY-MATCH

Preparation / proposed procedure:

1. Map the verified current COMP.COMPANY table to the source alias compd.company in the documented run context.
2. Keep the supplied quarterly-to-company join on GVKEY and the existing numeric SIC1/SIC2/SIC4 derivations unchanged.
3. After the remaining required inputs and runtime setup are resolved, compare the produced SIC/SEC-office join and sample outputs with the supplied author identifiers where applicable.

Validation to perform later:

- Confirm GVKEY and SIC types are accepted by the unchanged source join and conversion.
- Check the join results, SIC1/SIC2/SIC4 values and downstream SEC-office assignments against the author identifier list or other documented reference output.

### A-AUDIT-OPINIONS: Confirm FEED34 or another compatible USA audit-opinion source for FY 2002–2016; its one-row core fields are present, while two retained source columns and period coverage remain unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R-AUDIT-OPINIONS
Evidence: E-CODE-OPINION-FIELDS, E-CAT-AUDIT-OPINIONS, E-PROBE-AUDIT-OPINIONS

Preparation / proposed procedure:

1. Verify the permitted Audit Analytics product/version, fiscal-year range and all source fields required by the supplied KEEP statement.
2. Confirm whether FISCAL_YE and LARGE_OFFICE are required in this version; the code derives BIG4 and NATIONAL_OFFICE itself.
3. Map a compatible source to audit.auditopin and preserve company/year joins and author filters.

Validation to perform later:

- Check all required source fields, FISCAL_YEAR_OF_OP 2002–2016, date types and company-key coverage.
- Verify code-generated BIG4/NATIONAL_OFFICE without substituting unrelated candidate fields.

### A-AUDIT-RESTATEMENTS: Resolve the exact non-reliance restatement and company-block table contracts as separate required inputs. FEED39 is a partial candidate and the company-block catalog result is not a compatible US source.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R-AUDIT-NONRELI, R-AUDIT-CBLOCK, ISS-AUDIT-NONRELI-CBLOCK
Evidence: E-CODE-RESTATEMENT-FIELDS, E-CODE-CBLOCK-FIELDS, E-DATASHEET-DATES, E-CAT-AUDIT-NONRELI-EXACT, E-CAT-AUDIT-NONRELI-ALIAS, E-CAT-AUDIT-CBLOCK-EXACT, E-CAT-AUDIT-CBLOCK-ALIAS

Preparation / proposed procedure:

1. Identify a permitted Audit Analytics release or author-prepared compatible input for audit.auditnonreli with the 26 selected fields, especially RES_NOTIF_KEY, RES_ACC_RES_FKEY_LIST and DISC_TEXT1.
2. Identify a separate common.auditcblock-compatible table with COMPANY_FKEY and SIC_CODE_FKEY; do not use SEDAR/Europe candidates as substitutes without evidence.
3. Confirm numeric SAS FILE_DATE semantics for 15706–20819 and the author-documented February 2020 restatement vintage or a compatible alternative.
4. Keep the two table inputs separate and preserve the supplied join on COMPANY_FKEY.

Validation to perform later:

- Check each table’s product, full field list, data types, period and company-key mapping independently before merging.
- Confirm any author-prepared alternative is compatible with the supplied program and replaces the corresponding raw table as a route rather than being added as an extra dataset.

### A-COMMENT-DETAIL: Verify a compatible comment-detail product and the full KEEP-list contract for FEED25; catalog fields cover five downstream fields, while the bounded row-one read timed out.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R-COMMENT-DETAIL
Evidence: E-CODE-COMMENT-DETAIL-FIELDS, E-CAT-COMMENT-DETAIL, E-PROBE-COMMENT-DETAIL-TIMEOUT, E-DATASHEET-DATES

Preparation / proposed procedure:

1. Verify permitted access, the full source KEEP-list, EVENT_DATE filters, comment identifiers, form fields and history for the compatible detail product.
2. If the FEED25 candidate is selected, map it to audit.commlett only after confirming its complete field and date contract; the saved 15-second timeout is inconclusive.
3. Preserve EVENT_DATE>MDY(09,1,2004) and the author-documented January 2020 download as provenance rather than requiring byte-identical vintage.

Validation to perform later:

- Check all source fields/types, event-date coverage, company/file/conversation keys and compatibility with the thread input before full execution.

### A-COMMENT-THREADS: Confirm FEED40 or another compatible response-thread source for the author’s numeric question-letter-date window; one row contains all 22 source fields but does not establish history.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R-COMMENT-THREADS
Evidence: E-CODE-COMMENT-THREAD-FIELDS, E-CAT-COMMENT-THREADS, E-PROBE-AUDIT-THREADS, E-DATASHEET-DATES

Preparation / proposed procedure:

1. Verify permitted access, product/version, data period and the complete question/answer text, date and key fields.
2. Map the compatible table to audit.commlettthreads and preserve the 16437–20088 QUESTION_LETTER_DATE filter and COMMENT_RESPONSE_KEY deduplication.

Validation to perform later:

- Check full date coverage, text-field types/lengths, response keys and compatibility with the separate comment-detail input.

### A-LM-COMPLEXITY: Obtain the missing producer or exact author-prepared input contract for g.lm_complexity; do not infer an LM corpus or rebuild it from the table name.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R-LM-COMPLEXITY, ISS-LM-PRODUCER
Evidence: E-CODE-LM

Preparation / proposed procedure:

1. Identify the author’s source file/product or upstream program and its permitted delivery route.
2. Confirm the CIK_CHAR/FYEAR key definitions, population, history, COMPLEXITY and MEDIAN_COMPLEXITY construction and join formatting.
3. Stage the verified input as g.lm_complexity or provide the documented generation step while retaining both source-code joins.

Validation to perform later:

- Check source and constructed fields, CIK/FYEAR types, year coverage and row uniqueness only after the author specification is available.

### A-RUNTIME-CONFIG: Obtain exact runtime contracts for the author-defined remote and embedded-Stata macros, library roots and path mapping before proposing source edits.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-RUNTIME-CONFIG
Evidence: E-CODE-WRDS-CONTEXT, E-CODE-COMPUSTAT, E-CODE-AA-RESTATEMENTS, E-CODE-COMMENTS, E-CODE-EMBEDDED-ANALYSIS, E-CODE-OUTPUT-SUMMARY, E-CODE-OUTPUT-COMMENT-TABLE

Preparation / proposed procedure:

1. Identify definitions and supported use for %wrds, the RSUBMIT/PROC DOWNLOAD session and %stata_wrapper; keep credentials out of assessment artifacts.
2. Specify a portable run root, the g libref target and the staging/transfer path between SAS and Stata.
3. Map each named author input and output path to one consistent relative path; preserve Summary_Info.xml, T4_MainRestatement.xml and T6_Main_Comment.xml.
4. Retain the generated in-memory reg_sample endpoint unless the authors document a separate export; do not invent one.

Validation to perform later:

- Resolve every %wrds/RSUBMIT/PROC DOWNLOAD and %stata_wrapper call with the documented macro contract.
- Confirm every g.* read has a producer and a consistent libref root; confirm the three outputs are written to the assigned output root.

### A-SAS-COMPONENTS: Verify the required SAS runtime and components in the target batch context. The saved TKELS startup failure leaves SAS availability unverified and is not proof of a missing license.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-SAS, SW-SASCONNECT, SW-SASETS, SW-SASACCESS
Evidence: E-ENV-TOOLCHAIN, E-CODE-WORKBOOKS, E-CODE-CROSSREF, E-CODE-COMPUSTAT, E-CODE-EMBEDDED-ANALYSIS

Preparation / proposed procedure:

1. Establish a working SAS batch startup in the intended environment without running the supplied author program.
2. Confirm SAS/CONNECT remote session capability, SAS/ETS PROC EXPAND, SAS/ACCESS XLSX import and ODS Tagsets.ExcelXP availability.
3. Record the SAS version and component availability from a supported environment probe; retain the existing failed startup record.

Validation to perform later:

- Verify each component through its documented command/procedure availability in the target batch context before author-code execution.

### A-OUTREG2: Locate or install outreg2 in an authorized configured Stata adopath; no package installation was performed during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-OUTREG2
Evidence: E-ENV-TOOLCHAIN, E-CODE-EMBEDDED-ANALYSIS, E-CODE-OUTPUT-COMMENT-TABLE

Preparation / proposed procedure:

1. Check for an approved existing outreg2 package source or ask the environment administrator to add it to the Stata adopath.
2. Record its version and keep the setup reproducible alongside Stata 18, reghdfe 6.12.3 and ftools 2.49.1.

Validation to perform later:

- Run `which outreg2` in the configured Stata context and confirm its `excel replace`/`append` modes can write the XML outputs after inputs and wrapper setup are ready.

### A-FULL-WORKFLOW-VALIDATION: After all required inputs and runtime contracts are resolved, run the supplied full SAS/embedded-Stata workflow from the portable root and check its descriptive, Table 4 and Table 6 outputs. This action is a future validation step only.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS-RUNTIME-CONFIG, SW-SAS, SW-SASCONNECT, SW-SASETS, SW-SASACCESS, SW-STATA, SW-REGHDFE, SW-FTOOLS, SW-OUTREG2, ISS-PROC-EXPAND-OPTION
Evidence: E-CODE-OUTPUT-SUMMARY, E-CODE-EMBEDDED-ANALYSIS, E-CODE-OUTPUT-COMMENT-TABLE, E-ENV-TOOLCHAIN, E-SAS-PROC-EXPAND-METHOD

Preparation / proposed procedure:

1. Use the original supplied BHK JAR Code.sas and the documented compatible input routes; keep the restatement, comment, descriptive and embedded Stata branches intact.
2. Run only in an authorized environment after confirming data access, SAS components, macro/bridge mappings and outreg2 setup.
3. Capture source/input hashes, exact batch command, working directory, return code and separate SAS/Stata logs.
4. In the future authorized execution copy, apply only the two documented PROC EXPAND option spelling edits before running the full supplied workflow; leave the assigned source bytes intact.

Validation to perform later:

- Confirm Summary_Info.xml, T4_MainRestatement.xml and T6_Main_Comment.xml are produced in the configured output root.
- Check the embedded Stata transfer receives the intended in-memory reg_sample and both table branches run; do not treat a partial branch as full-pipeline completion.

### A-PROC-EXPAND-OPTION: Prepare two exact unapplied edits in a future run copy: change only `menhod` to `method` on the two supplied PROC EXPAND option lines. Keep the supplied source unchanged during this assessment.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS-PROC-EXPAND-OPTION
Evidence: E-CODE-EXPAND-OPTION-562, E-CODE-EXPAND-OPTION-581, E-SAS-PROC-EXPAND-METHOD

**Proposed edit:** `BHK JAR Code.sas:562–562`
Source SHA-256: `8bff484524b04e4dfe3fea1df3166763e080b314666810dbc4d576d3fee0ee42`

Correct the misspelled PROC EXPAND option to the officially documented METHOD=NONE setting while preserving all other tokens and the specified no-interpolation behavior.

Current text:
```
proc expand data=compq2 out=compq3 menhod=none;
```

Proposed replacement:
```
proc expand data=compq2 out=compq3 method=none;
```

**Proposed edit:** `BHK JAR Code.sas:581–581`
Source SHA-256: `8bff484524b04e4dfe3fea1df3166763e080b314666810dbc4d576d3fee0ee42`

Apply the same supported option spelling correction to the rolling-volatility PROC EXPAND block, preserving every other token.

Current text:
```
proc expand data=compq4 out=compq5 menhod=none;
```

Proposed replacement:
```
proc expand data=compq4 out=compq5 method=none;
```

Preparation / proposed procedure:

1. Use the exact before/after text and frozen source hash in a separate authorized execution copy.
2. Apply only the two spelling corrections; preserve all input, output, transform and model tokens.

Validation to perform later:

- Compare the execution-copy diff with the two one-token replacements and confirm the original supplied source hash remains unchanged.
- Confirm the spelling and no-interpolation behavior against the cited official METHOD=NONE documentation; do not compile or execute the source as part of this assessment.


## Remaining issues and prerequisites

- ISS-AUTHOR-WORKBOOKS [unresolved; full_pipeline]: Five distinct author-side files named by the source are absent from the assigned package inventory: SEC_Office.xlsx, Restate_Taxonomy_JAR.xlsx, cl_timeperiod.xlsx, Restate_form.xlsx and Codification_CrossRef.xlsx. The code specifies key fields and transformations but not the workbook construction/history or an exact public delivery path. The supplied identifier workbook is not a substitute.
- ISS-AUDIT-NONRELI-CBLOCK [unresolved; full_pipeline]: The source needs audit.auditnonreli and common.auditcblock as separate jointly required tables. The local FEED39 restatement candidate lacks three catalogued source fields, the exact company-block lookup returned no record, and only non-US company-block candidates were found; these findings do not prove no data or access.
- ISS-LM-PRODUCER [unresolved; full_pipeline]: The supplied program joins g.lm_complexity in both main branches but does not create/import it or identify its source. Its history, population, definitions and CIK/FYEAR formatting remain unresolved.
- ISS-RUNTIME-CONFIG [unresolved; full_pipeline]: The source invokes %wrds, RSUBMIT/PROC DOWNLOAD and %stata_wrapper, reads/writes through g.* libraries, and contains Windows workstation input/output paths. The required macro definitions, remote session/data-transfer contract, libname g mapping, portable run root and Stata bridge are not supplied. The actual in-memory reg_sample is the analysis endpoint; the source does not require a new cleaned-data export.
- ISS-PROC-EXPAND-OPTION [preparation; full_pipeline]: The supplied program spells the PROC EXPAND option `menhod=none` on lines 562 and 581. Official SAS documentation supports `METHOD=NONE`; correcting these two tokens is a supported preparation edit and does not require scientific reconstruction.
- R-SEC-OFFICE [undetermined]: Author-prepared SIC4-to-SEC-office mapping (`SEC_Office.xlsx`) imported as `g.sec_office`; source uses SIC4, SEC_OFFICE and Industry_Title for the 11-office expansion/joins. The workbook and its historical mapping construction are not in the supplied package.
- R-RESTATE-TAXONOMY [undetermined]: Author-prepared Audit Analytics restatement-category to ASC-topic map (`Restate_Taxonomy_JAR.xlsx`), requiring Restatement___category_key and accounting_topic; used in the main restatement branch.
- R-CL-TIMEPERIOD [undetermined]: Author-prepared comment-conversation period map (`cl_timeperiod.xlsx`) with COMPANY_FKEY, CL_CON_ID, PF, CL_BDATE and CL_EDATE; code selects PF=1 for comment window construction.
- R-RESTATE-FORM [undetermined]: Author-prepared topic-quarter input (`Restate_form.xlsx`) with ASC_TOPIC, BEG_DATE, END_DATE, YEAR and C_QTR. The supplied program expands each ASC topic across SEC_OFFICE values 1–11.
- R-CODIFICATION-CROSSREF [undetermined]: Author-prepared Codification CrossRef workbook with All and Home sheets: All provides TOPIC/SUBTOPIC/SECTION/PARAGRAPH/STANDARD_TYPE/STANDARD_NUMBER/Paragraph___Label/SEQUENCE; Home provides TOPIC_NUMBER/TOPIC_NAME. Author code notes the FASB data was accessed in December 2019.
- R-COMPUSTAT-FUNDQ [undetermined]: Compustat quarterly fundamentals through `compd.fundq`, filtered to domestic industrial consolidated standard-format observations, FYEARQ 2000–2016, and nonmissing DATACQTR and ATQ*SALEQ.
- R-AUDIT-OPINIONS [undetermined]: Audit Analytics audit-opinion table, filtered by FISCAL_YEAR_OF_OP 2002–2016; supplies company, auditor/state and fiscal-year end for the restatement and comment branches.
- R-AUDIT-NONRELI [undetermined]: Audit Analytics non-reliance restatements (`audit.auditnonreli`) with the 26 selected fields named in the source, including RES_NOTIF_KEY, RES_ACC_RES_FKEY_LIST and DISC_TEXT1; filter FILE_DATE 15706–20819.
- R-AUDIT-CBLOCK [undetermined]: Separate `common.auditcblock` input joined on COMPANY_FKEY to provide SIC_CODE_FKEY. The exact table has no bounded catalog record; SEDAR/Europe candidates do not establish a compatible US company-block route.
- R-COMMENT-DETAIL [undetermined]: Audit Analytics comment-letter detail (`audit.commlett`) filtered to EVENT_DATE>MDY(09,1,2004), retaining the fields needed to map filings/conversations (16 source fields in the KEEP statement).
- R-COMMENT-THREADS [undetermined]: Separate Audit Analytics comment-response thread table (`audit.commlettthreads`), filtered to 16437<=QUESTION_LETTER_DATE<=20088 and retaining question/answer text, dates and keys.
- R-LM-COMPLEXITY [undetermined]: Local `g.lm_complexity` table consumed by both restatement and comment analyses, keyed by CIK_CHAR/FYEAR and providing COMPLEXITY/MEDIAN_COMPLEXITY; the supplied program has no producer, import step or source-file contract.
- SW-SAS [unverified]: SAS Base procedures, macros and ODS are required. The saved bounded environment probe failed during TKELS startup initialization, which leaves runtime availability unverified and does not establish a license barrier.
- SW-SASCONNECT [unverified]: The supplied source calls %wrds, RSUBMIT, PROC DOWNLOAD and ENDRSUBMIT; the macro, remote session and data-transfer configuration are not included.
- SW-SASETS [unverified]: PROC EXPAND is required for quarterly lags and rolling volatility. The METHOD=NONE spelling correction is supported by SAS documentation; SAS/ETS component availability remains unverified.
- SW-SASACCESS [unverified]: The source imports several XLSX workbooks with PROC IMPORT DBMS=XLSX; the required interface availability was not established.
- SW-OUTREG2 [preparation_required]: outreg2 was not found in either checked Stata adopath; it is used to write the Table 4 and Table 6 XML workbooks.

## Review notes

- The supplied package includes one SAS program, its datasheet, an identifier workbook and an online appendix. The datasheet describes the Excel workbook as identifiers for final-sample observations; the bounded XLSX probe reads one row, reports four first-sheet headers and explicitly marks coverage unverified. It is not a full analysis dataset or a route that replaces required source inputs.
- Target scope is the supplied full SAS preparation workflow and its actual embedded Stata restatement, comment and descriptive-output branches. The online appendix provides additional robustness results but this package supplies no separate program branch for them; no paper-wide analyses were added. No related-package candidates were listed for this assigned item.
- Each missing author workbook, Compustat table, Audit Analytics table and g.lm_complexity input is represented as a separate mandatory requirement. Any compatible prepared input would be an alternative route for that same input; it is not an extra raw-plus-prepared requirement. The current identifier list is not such a compatible prepared input.
- Catalog records are metadata only and do not establish licensing, access or historical coverage. The frozen lookup helper failed because its sibling resources.py path was missing; the exact catalog fallback was bounded to selected records. An initial broad selected-record capture exceeded the 1 MiB limit and remains preserved; narrower per-table outputs were used. No matching hit or miss is treated as license or access proof.
- The COMP.FUNDQ, COMP.COMPANY, FEED34 and FEED40 local metadata probes used Python row_limit=1 through separate guarded child processes. They establish a readable first row and the listed fields only, not full coverage, version or population. COMP.COMPANY is a verified route for the source’s current GVKEY-to-SIC lookup; the source does not require a dated SIC series. FEED34 and FEED40 retain their separate historical-period verification gaps, and the FEED25 timeout remains inconclusive.
- The author datasheet records FASB Codification data downloaded in December 2019 and Audit Analytics restatement/comment-response downloads in February/January 2020. These dates are provenance, not independent proof of required product fields or a demand for byte-identical historic files.
- An official FASB check confirms free Basic View content access without an account, but the check did not establish an equivalent December 2019 All/Home workbook export or its field mapping; that route remains unverified. The datasheet’s general public-availability statement also does not verify the exact Compustat/Audit Analytics input products.
- The supplied `%WT` macro remains part of the author code and its output tables are covered as generated dependencies. A conservative source-reader window withheld lines 352–355 because they matched a broad credential/connection candidate pattern; the candidate scan is not confirmation of content and is not treated as a missing-macro, input or scientific blocker. No credentials or raw connection blocks are reproduced.
- The saved environment artifact reports Stata 18, reghdfe 6.12.3 and ftools 2.49.1; outreg2 was not found in checked adopaths. SAS startup did not complete its bounded environment probe because TKELS initialization failed, which leaves SAS runtime availability unverified and does not establish a licensing barrier. No author code, estimators, SAS programs or data payloads were run during this assessment.
- The two supplied PROC EXPAND lines contain the literal spelling menhod=none. The saved official SAS/ETS result confirms METHOD=NONE is supported and specifies no interpolation. The two exact source_edit proposals correct only that option spelling and remain unapplied; this is a preparation fix, separate from unresolved data and runtime dependencies.
