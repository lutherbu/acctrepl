# Patch proposal: jar-a81829339edb

Human + AI in Accounting : Early Evidence from the Field

DOI: 10.1111/1475-679X.70052

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full documented workflow from the run_all.py task registry, including preprocessing, supplied table programs, table2, and manuscript outputs. The producer-consumer order is traced; authorized routes for the required raw inputs remain unresolved.

Entry points: `JAR Replication Package/JAR Replication Package/run_all.py`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 3/70052 - Human-AI-in-Accounting-Early-Evidence-from-the-Field/cx-datasheet-code-and-log-files.zip",
      "sha256": "327867b6c73154df9617e759dee97dd0a6bb9eff7b48f9a1821ae0e182ff3315"
    },
    {
      "path": "JAR-Volume 64/Issue 3/70052 - Human-AI-in-Accounting-Early-Evidence-from-the-Field/cx-online-appendix.pdf",
      "sha256": "b30b57e44d5e3bbd835908fa1e7ce839cdad973c022c8d9574a1808dd6ea934b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "8d32bb69f9e4548b531eea857ebdcc5e2a6519d5467bb309be4278c0986c5076"
}
```

## Proposed actions

### ACT-TRACE-INPUTS: Identify authorized source routes for the separately named survey, table2 presurvey, partner, field, and client-description inputs, then verify each file and field against the remaining source and dependency trace.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE-INPUT-CLOSURE, REQ-FIELD-EXPERIMENT, REQ-PAGEVIEW, REQ-PARTNER-ACCOUNTING, REQ-PARTNER-CLIENT-META, REQ-PARTNER-CONFIDENCE, REQ-PARTNER-DESCRIPTIVE-CLIENTS, REQ-SURVEY-RAW, REQ-TABLE2-PRESURVEY
Evidence: INSP-WORK-ITEM-INVENTORY, SRC-P1-PARTNER-RAW, SRC-P2-DESCRIPTIVE-CLIENTS, SRC-P5-PREPAID-2024, SRC-PAGEVIEW-RAW-FIELDS, SRC-README-RAW-DATA, SRC-RUNNER-FIELD-INPUTS, SRC-SURVEY-POST-RECORDS, SRC-SURVEY-PRE-RECORDS, SRC-TABLE5-PARTNER-META-PATH, SRC-SURVEY-PRODUCTIVITY-WEEK5, SRC-SURVEY-TIMEALLOC-WEEK5, SRC-P5-SURVEY-ADDITIONAL-PRE, SRC-TABLE2-PRESURVEY-INPUT, SRC-MANUSCRIPT-TABLE5-INPUTS, SRC-MANUSCRIPT-MASTER-INPUT, SRC-TABLE2-DATA-ROOT

Preparation / proposed procedure:

1. For each exact input path, identify an authorized route and compare consumed fields and population with the code contract.
2. Keep distinct workbooks and paths separate unless source evidence shows they are alternatives.
3. Complete authorized route and field-contract checks for each named raw input, while retaining the existing full unique dependency-ID dispositions.

Validation to perform later:

- Reconcile required inputs and generated handoffs against every unique frozen dependency ID.
- Use only bounded registered metadata probes for authorized candidate sources; preserve missing fields, history, and prepared-panel gaps separately.

### ACT-TRACE-ORG-MAPPING: Identify who supplies org_name_id_mapping_entered.csv and verify its Org name and Org ID contract before processing recategorized transactions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-ORG-MANUAL-MAPPING, ISSUE-ORG-MANUAL-MAPPING
Evidence: SRC-P3-MANUAL-TEMPLATE, SRC-P3-MANUAL-INPUT, INSP-WORK-ITEM-INVENTORY

Preparation / proposed procedure:

1. Confirm whether the entered crosswalk is supplied separately or populated as a manual preparation step.
2. Do not infer a populated crosswalk from the separately written manual file.

Validation to perform later:

- Confirm the exact entered CSV path and Org name and Org ID fields through an authorized metadata probe.

### ACT-SETUP-SOFTWARE: Before any authorized run, verify the exact package statuses against the prepared Python and Stata environment. Obtain missing packages through an approved source and confirm versions; do not trigger the supplied setup task while this proposal is under static review.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: ISSUE-SOFTWARE-SETUP, SOFT-WINSOR2, SOFT-OUTREG2, SOFT-PPMLHDFE, SOFT-ESTOUT, SOFT-REQUIRE, SOFT-EBALANCE, SOFT-STACKDID, SOFT-CSdid, SOFT-DID-IMPUTATION, SOFT-COEFPLOT, SOFT-CORRTABLE, SOFT-ASDOC, SOFT-PYTHON-REQS
Evidence: PRB-ORIGINAL-ENVIRONMENT, SRC-STATA-SETUP-PACKAGE-LIST, SRC-STATA-SETUP-INSTALL, SRC-RUNNER-STATA-SETUP-ORDER, SRC-PYTHON-REQUIREMENTS

Preparation / proposed procedure:

1. Confirm whether each unverified setup-list package and Python requirement is available in the target environment.
2. If winsor2 or outreg2 remains unavailable, prepare the environment through an authorized package source before the documented full workflow.
3. Check ppmlhdfe, estout, and the remaining setup packages by exact package name; do not infer availability from similarly named commands.

Validation to perform later:

- Record the exact typed version and availability result for each required package.
- Confirm that the full package list can pass setup before any authorized execution attempt.


## Remaining issues and prerequisites

- ISSUE-INPUT-CLOSURE [unresolved; full_pipeline]: The README names data/raw_data as the package raw-data root, and the registered archive inventory has no data-file members; this describes archive contents only. Source code names survey, partner, field, table2 presurvey, and other required inputs whose authorized routes remain unverified. The datasheet's aggregate-only partner disclosure condition does not itself establish an access barrier.
- ISSUE-ORG-MANUAL-MAPPING [unresolved; full_pipeline]: processing_3.ipynb writes org_name_id_mapping_manual.csv, then reads the separately named org_name_id_mapping_entered.csv. The entered mapping's populated route is not established by the registered inventory.
- ISSUE-SOFTWARE-SETUP [preparation; full_pipeline]: The original probe reports winsor2 and outreg2 unavailable. The runner normally calls a setup script that attempts SSC installs for its package list before do-file tasks; packages with no exact typed status, including ppmlhdfe and several setup-list entries, remain unverified.
- REQ-SURVEY-RAW [undetermined]: The productivity, time-allocation, and balance-sheet preprocessing notebooks read the initial Company A internal/external and Company B/C pre-treatment CSVs; Company A internal/external weekly CSVs for weeks 1-2; Company B/C weekly CSVs for weeks 1-5; Company B/C week4/pre_treatment4.csv for the week-4 and week-5 joins; Company B/C post-treatment CSVs; and Company A internal pre_treatment_9_2.csv in processing_5. Source code names the paths and fields, but matching raw files and authorized routes are not established.
- REQ-PARTNER-ACCOUNTING [undetermined]: Partner preprocessing reads a CPA-to-client workbook, client transaction workbooks, engagement timing, prepaid and accrued ledgers, and bank transaction workbooks.
- REQ-PARTNER-CONFIDENCE [undetermined]: processing_3.ipynb reads recategorized transaction files and xlsx confidence reports with transaction, score, client, sheet, and status fields.
- REQ-ORG-MANUAL-MAPPING [undetermined]: The notebook writes org_name_id_mapping_manual.csv and separately reads org_name_id_mapping_entered.csv with Org name and Org ID; the populated route is not established.
- REQ-PARTNER-DESCRIPTIVE-CLIENTS [undetermined]: processing_2.ipynb reads PARTNER_DESCRIPTIVE_CLIENTS.xlsx sheet data1 with Company ID, number employees, Funding, Sector Name, CPA ID, and size.
- REQ-PARTNER-CLIENT-META [undetermined]: table5.do imports partner_client_data.xlsx from manual_path/data, Sheet1, retaining company_id, size, funding, sector_name, industry_group_name, and num_employees.
- REQ-FIELD-EXPERIMENT [undetermined]: The two preprocessing builders require four rounds of client exports, metadata, Qualtrics, pre-screen, time, rubric, treatment-extracted, and COA sources; they generate master_df_0904.csv and treatment_categories_suggestion_final_0904.csv.
- REQ-PAGEVIEW [undetermined]: The Stata labelling, table4, and table7 programs read data/pageview.csv. The analysis retains username, event, company/firm, pathname, timestamp, pageview duration, year, month, and day fields.
- REQ-TABLE2-PRESURVEY [undetermined]: The runner's table2 notebook reads data/genai_presurveyresponses.csv and summarizes PrimaryConcern, Benefit, and Concern. No producer for this CSV is identified in the supplied task chain; the registered package inventory has no data members and an authorized route is unverified.
- SOFT-WINSOR2 [preparation_required]: Original probe reports available=false, configured=false, which=111, with no version token. stata_setup.do lists this package and its runner task attempts SSC setup.
- SOFT-OUTREG2 [preparation_required]: Original probe reports available=false, configured=false, which=111, with no version token. Supplied do-files call outreg2 and the runner setup list includes it.
- SOFT-PPMLHDFE [unverified]: The setup script lists ppmlhdfe and table3 do-files call it, but the original typed probe has no ppmlhdfe entry; its availability is unverified.
- SOFT-ESTOUT [unverified]: stata_setup.do lists estout, but the original typed environment result has entries for esttab, estpost, and estadd rather than an estout entry; keep estout itself unverified.
- SOFT-REQUIRE [unverified]: stata_setup.do lists require; no typed result for this exact name is available in the original environment probe.
- SOFT-EBALANCE [unverified]: stata_setup.do lists ebalance; no typed result for this exact name is available in the original environment probe.
- SOFT-STACKDID [unverified]: stata_setup.do lists stackdid; no typed result for this exact name is available in the original environment probe.
- SOFT-CSdid [unverified]: stata_setup.do lists csdid; no typed result for this exact name is available in the original environment probe.
- SOFT-DID-IMPUTATION [unverified]: stata_setup.do lists did_imputation; no typed result for this exact name is available in the original environment probe.
- SOFT-COEFPLOT [unverified]: stata_setup.do lists coefplot; no typed result for this exact name is available in the original environment probe.
- SOFT-CORRTABLE [unverified]: stata_setup.do lists corrtable; no typed result for this exact name is available in the original environment probe.
- SOFT-ASDOC [unverified]: stata_setup.do lists asdoc; no typed result for this exact name is available in the original environment probe.
- SOFT-PYTHON-REQS [unverified]: requirements.txt lists nbformat, nbclient, numpy, pandas, statsmodels, and openpyxl without version pins; no typed availability result for these packages is cited here.

## Review notes

- Checkpoint after enumerating survey, partner ledger, confidence-report, manual org mapping, and client-description contracts. All 35 frozen dependency IDs are mapped; later survey wave paths and the separate processing_5 pre-treatment input are now source-cited. Authorized routes for missing raw inputs remain unverified.
- The registered processing_1.ipynb rows 752–756 are active code in cell_index 9, cell_id null, cell_type code. After derived_df and derived_path, the supplied text has derived_df. then a blank row then (derived_path, index=False). This is code-cell content, not a comment, literal, or extraction boundary.
- The documented run_all.py path applies patch_notebook_source to each code cell before NotebookClient execution. Its regex maps that fragment to derived_df.to_csv(derived_path, index=False), so this is a bounded runner-supported CSV-export preparation repair on the documented path, not an active blocker there. Direct notebook/manual execution that bypasses run_all.py may not receive this patch; it was not run or independently verified. This derived_financial_metrics.csv export is distinct from financial_metrics.csv, whose normal writer and consumers are separately traced.
- No author code, notebook, Stata, or other runtime was executed; source relationships are static only.
- The pageview_clean.dta dependencies are generated by table4.do and table7.do from pageview.csv. For the documented runner path, table7.do sets manual_path from c(pwd), and run_all.py executes do files with cwd=PROJECT_ROOT; its later relative data/pageview_clean.dta read therefore resolves to the same package data output. D0025 retains its frozen unresolved status in the inventory, while source code supports a generated disposition for the documented path.
- The registered task list runs the field master and treatment builders, survey notebooks and label task, partner preprocessing, then the table and experiment programs; generated outputs are classified as workflow intermediates, not extra raw-input requirements.
- All 35 frozen dependency IDs are assigned once. Generated CSV/DTA/XLSX handoffs are workflow products with source-backed producers; they are not added as extra raw-data requirements. D0025 retains its frozen unresolved status in metadata while the documented run_all.py working directory and table7.do c(pwd) setup support the generated-file resolution.
- Source coverage includes the complete survey-wave paths from both productivity and time-allocation notebooks, the processing_5 survey baseline, partner transaction/ledger/confidence inputs, manual mapping, field-experiment builder contracts, table inputs, and generated consumers. Authorized raw-data routes remain unresolved.
- The runner's automatic Stata setup task invokes a supplied SSC install/update script before Stata do-file tasks unless setup is skipped. This static dependency is recorded as a preparation requirement; no Stata or package installation was run.
- Software statuses cite only exact typed original result.software[exact_name] entries or remain unverified when that exact entry is absent. The source setup script's broader package list is preserved without inferring availability from related package names.
- processing_5.ipynb separately reads Company A internal pre_treatment_9_2.csv; the notebook maps Q4/Q11/Q14/Q18, standardizes Q1 as CPA ID, maps Q13 as CPA status, and joins education, experience, and CPA status into its generated panel.
- The runner executes table2.ipynb after the other analysis tasks, then build_manuscript_outputs.py. Table2 reads the separate data/genai_presurveyresponses.csv (PrimaryConcern, Benefit, Concern) without an identified producer; it writes table2a/b/c.csv, which the output builder copies. The output builder also consumes generated merge_new_send.dta and master_df_0904.csv plus the already required PARTNER_DESCRIPTIVE_CLIENTS.xlsx. Its lines 7-10 remain masked by the registered source-view policy; no absence or code defect is inferred from that mask.
- Citation-only correction: SRC-PAGEVIEW-RAW-FIELDS now quotes the complete contiguous pageview import and retained-fields lines 10-12; its input path and field contract are unchanged.
- The README's data/raw_data directory is a package staging root, not an independent data contract. The registered archive inventory has no data-file members; keep the exact survey, partner, field, table2, pageview, and mapping requirements separately tracked, with authorized routes unverified.
