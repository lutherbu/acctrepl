# Patch proposal: jar-ead091f628cd

Disclosure "Scriptability

DOI: 10.1111/1475-679X.12203

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete current author-documented workflow; the datasheet provides the manual construction recipe and the online appendix provides current measure definitions and validation analyses. The package does not include complete executable Python/R or empirical-analysis entry points; its R console history is only a partial code artifact.

Entry points: `ADM Datasheet.pdf`, `_audit_supplements/adm-online-appendix.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12203 - Disclosure-Scriptability/adm-datasheet-and-data-file.zip",
      "sha256": "00117c9c0ea150cca33cdcb3514c8ac979dca24e842cfff9dd6d9351955e8d0e"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12203 - Disclosure-Scriptability/adm-online-appendix.pdf",
      "sha256": "9976ad6a0904630ad18aec23307b41b6abbe618522a5e03c77297cfaba727d2c"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12203 - Disclosure-Scriptability/allee-deangelis-moon-accepted-proposal.pdf",
      "sha256": "53f50de9e7cbdfd612318ed70e972b65eb7860e5120ee6b42b1c585a6d0a4cd0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "48ee84ac04bb95ad80c7dd556c83f4d048dc9c77405a757b429ca3946f20110c"
}
```

## Proposed actions

### acquire_sec_filing_corpus: Use the verified official SEC EDGAR Feed/Oldloads route or a later verified compatible local corpus to obtain the 1995–2015 filing records required by the current measure-construction recipe. The SEC route supplies daily tar/gzip archives and complete disseminated filing text; the author recipe refers to ZIP archives, so align archive handling with the eventual current program before processing.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: sec_filing_corpus
Evidence: public_sec_archives, src_datasheet_raw_period, src_datasheet_formtypes, inspect_sec_roots

Preparation / proposed procedure:

1. Obtain the 1995–2015 EDGAR daily archive material through the official Feed/Oldloads interface under SEC fair-access conditions, or verify that the documented local SEC roots contain a compatible copy.
2. Retain the author-specified non-amended 10-K, 10-Q, 8-K and DEF 14A filings; use the full filing/header content the documented parser requires.
3. After the current program or full manual recipe is supplied, align tar/gzip versus ZIP handling and compare the archive/index inventory by day, form, CIK and accession number. Verify HTML, header, XBRL and binary/exhibit bytes before claiming coverage.

Validation to perform later:

- Verify the target date range and all four form types against SEC filing indexes and the authors’ final workflow; keep absent days and paper filings explicit.
- Run bounded metadata/content checks on representative acquired filings only after an authorized execution phase; no such acquisition or program run was performed in this assessment.

### clarify_complete_workflow: Request the current complete programs or an equivalent step-by-step recipe and input/output map for every reported main and validation analysis. Resolve the exact CRSP/Compustat valid-filing join, product and fields; identify the additional model/validation inputs; and specify the exact NLTK stop-word resource and Aspell word-list version if measure construction is intended.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: workflow_coverage_gap, crsp_compustat_linkage, other_empirical_inputs, sw_nltk_stopwords, sw_aspell_list
Evidence: src_datasheet_in_lieu_code, src_datasheet_python_parse, src_datasheet_python_similarity, src_datasheet_python_merge, src_datasheet_r_merge, src_datasheet_valid_linkage, src_datasheet_other_sources, src_datasheet_manuscript_map, src_appendix_validation1, src_appendix_validation2, src_appendix_validation3, src_appendix_nltk, src_appendix_aspell, inspect_rhistory, inspect_code_inventory, inspect_catalog_candidates

Preparation / proposed procedure:

1. Ask the authors to provide the current Python/R and empirical-analysis programs, or a complete manual procedure, with a separate entry/output map for each reported table and figure and every required input, working directory, field, identifier, date range, transformation, and version.
2. Clarify whether the packaged .Rhistory is only a console record or a required current stage. It attempts to read docindidxFINAL2.csv and SCRIPTABILITY_DATA.csv.gz, neither of which is in the assigned package; if the stage is required, provide the supported script and exact inputs or explain how the supplied SCRIPTABILITY_DATA_FINAL.csv.gz replaces them. Do not source the full history as a clean workflow.
3. Specify the exact CRSP/Compustat table, join keys, filing identifier crosswalk and effective-date rule for the 1995–2015 valid-filing filter; treat the catalogued CCMXPF_LINKTABLE only as a candidate until a bounded check can be tied to that contract.
4. Map the additional source products and prepared data for the current main and validation analyses to their required fields, periods, joins and table outputs. Distinguish sample membership indicators from outcome/control data.
5. If the measure-construction branch is to be rerun, identify the NLTK stop-word corpus and Aspell list/version actually used. The supplied final score file can be used as prepared data without acquiring these recipe resources.
6. Confirm how the current workflow creates CompScript: the appendix defines it as the average of IdentifyData and DataToInformation, which appear in the packaged score file, but no CompScript column is present in the bounded header. Keep that author-specified derivation in the complete script/recipe rather than assuming the .Rhistory performs it.

Validation to perform later:

- Review the author-supplied code/recipe and document a closed producer-consumer map for raw filing filtering, Python extraction, heading/row processing, Python merges, R measure construction, and all current paper analyses.
- Check every claimed input route against its exact product, schema, identifiers and period; keep coverage or linkage fields unresolved until supported.

### request_dow_jones_dissem_input: Request an authorized current route to the Dow Jones news data needed for the Dissem/news-dissemination analysis, or an author-prepared compatible NewsDelay/Dissem dataset. The supplied sample_Dissem flag is sample membership only, and the README says NewsDelay is omitted to avoid reconstructing Dissem without that proprietary archive.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: dow_jones_dissem_input
Evidence: src_readme_newsdelay, src_datasheet_other_sources, src_appendix_dissem

Preparation / proposed procedure:

1. Ask for the exact authorized data product or author-prepared derived file, identifiers, required NewsDelay/Dissem fields, format, cleaning, join rule and 2010–2015 coverage.
2. Clarify any license or redistribution terms; do not infer an access barrier from the authors’ historic purchase and do not attempt to reconstruct Dissem from the sample-membership list.

Validation to perform later:

- If the authors supply a route or dataset, verify its documented fields, identifiers and period with a bounded metadata probe and compare it to the Table 7 workflow before analysis.

### setup_r_data_table_if_required: If the authors confirm the visible R history fragment is a required current stage, configure the R data.table package that its fread/.SD/%like% commands use. It is absent from the checked R library; this conditional setup is not needed merely to consume the supplied final score CSV.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_r_data_table
Evidence: inspect_rhistory, probe_documented_software

Preparation / proposed procedure:

1. Only after the current workflow identifies this fragment as required, install or configure the supported data.table version in the selected R environment.
2. Replace the exploratory console-history sequence with the author-supported bounded script and input paths; do not run update.packages, install.packages, updateR, or source the entire .Rhistory as part of this assessment.

Validation to perform later:

- Use a read-only R package/function check to confirm data.table, fread, .SD and %like% are available, then validate the documented input/output contract after authorization.


## Remaining issues and prerequisites

- workflow_coverage_gap [unresolved; full_pipeline]: The datasheet states that conversion code is not supplied and documents a current sequence of SEC filing processing, heading/row-name post-processing, Python output combination, and an R combination/measure-construction stage. The package inventory has no standalone programs; its 64-line .Rhistory is an interactive, partial history with repeated path attempts, exploratory commands and a CSV selection/export fragment, not a complete entry point for those stages or the reported analyses. That fragment references docindidxFINAL2.csv and SCRIPTABILITY_DATA.csv.gz, which are not in the assigned package, while SCRIPTABILITY_DATA_FINAL.csv.gz is supplied as the author-prepared score file. I retain the history as code evidence but do not treat it as a clean runnable stage or make its historical inputs live dependencies absent author confirmation. The complete analysis entry points, their input/output map and dependency closure remain unresolved.
- dow_jones_dissem_input [undetermined]: Underlying data needed for the reported Dissem/news-dissemination analysis. The packaged sample_Dissem field indicates sample membership only; the README expressly says the NewsDelay indicator is withheld and that Dissem cannot be reconstructed without the proprietary Dow Jones News Archive. Exact consumed fields and file format are not specified in this release.
- sec_filing_corpus [public_acquisition_required]: The measure-construction branch explicitly begins with SEC EDGAR filing-day archives from 1995–2015, then retains non-amended 10-K, 10-Q, 8-K and DEF 14A filings and extracts full filing metadata/content. This is a required raw input for the scoped measure-construction stage; the packaged final scores do not replace it for the raw-rebuild branch.
- crsp_compustat_linkage [undetermined]: The valid-filing screen in the current measure-construction recipe requires a match in the CRSP/Compustat linking file to exclude duplicate/subsidiary filings. The exact source dataset, join keys, link-date validity rule and period coverage are not specified in the supplied workflow.
- other_empirical_inputs [undetermined]: Additional data required by the complete main and validation analyses, excluding the separately tracked SEC filing corpus, CRSP/Compustat valid-filing linkage and Dow Jones Dissem input. The current documents name validation datasets and other sources, but the released files and sources do not map the full remaining empirical data contracts to each table/test: exact products, fields, identifiers, sample bounds, transformations, and joins remain unknown. Catalog matches are discovery candidates only.
- sw_nltk_stopwords [unverified]: NLTK version 3.10.3 is installed, and the current glossary names its English stop-word list; the corpus/resource and exact version used by the authors were not checked. The prepared score CSV does not need this resource, but rebuilding the measure may.
- sw_aspell_list [unverified]: The system Aspell executable 0.60.8.1 is present, and current Appendix F says the authors used the Aspell word list instead of Enchant. The exact word-list file/version used by the authors is not verified.
- sw_r_data_table [unverified]: The visible R history uses data.table functions fread, .SD and %like%; the package is absent from the checked R library. Whether this console-history fragment is a required current stage is unresolved, so data.table is not treated as required to consume the supplied final score file.

## Review notes

- One full_pipeline scope is retained. No analysis_only scope is supported: the packaged scriptability-score file and sample-membership index do not provide the missing complete main-analysis entry points and all outcome/control inputs.
- The .Rhistory is code content but not a clean runnable workflow. It includes help/View calls, repeated local path attempts, package update/install commands, exploratory filters, and a partial CSV selection/export segment. It references docindidxFINAL2.csv and SCRIPTABILITY_DATA.csv.gz, neither of which is in this package. Those history-only inputs are not treated as current live requirements because the final author-prepared SCRIPTABILITY_DATA_FINAL.csv.gz is separately supplied; if the authors confirm that history-derived stage is required, its inputs and current script must be provided.
- The selected full-pipeline scope includes the documented raw filing-construction branch, so the 1995–2015 four-form SEC corpus and CRSP/Compustat valid-filing linkage are explicit requirements. The packaged final score data do not close that raw-rebuild branch.
- Official SEC documentation verifies a free public route to daily EDGAR archives and complete filing text, subject to fair-access rules. The verified route does not certify local coverage or the authors’ exact archive handling; local SEC/LM checks were root metadata only, with no content reads or recursive scans.
- The frozen catalog’s CCMXPF_LINKTABLE and 13F entries are discovery candidates only. No bounded read or exact field/date compatibility was established, and catalog misses do not prove that a source or license is absent.
- The September 2016 registered-report proposal is historical. Current Internet Appendix F records substantive and minor changes; proposed alternatives in the original proposal were not treated as current workflow dependencies.
- The final-sample CSV is a document-membership index, not underlying dependent-variable data. The README specifically says NewsDelay is omitted and identifies the proprietary Dow Jones archive as necessary to reconstruct Dissem.
- Software versions reflect this environment only. Author versions are unspecified; NLTK corpus and Aspell-list identity remain unverified, and data.table is absent but is only conditional on using the partial R history.
- No author code, regressions, or full datasets were executed/read; no downloads, installations, or package edits were performed. Checks were bounded metadata/software inspections.
