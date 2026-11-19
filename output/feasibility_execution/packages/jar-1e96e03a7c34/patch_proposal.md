# Patch proposal: jar-1e96e03a7c34

Politically Connected Governments

DOI: 10.1111/1475-679X.12325

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Run all supplied Stata transformations and analyses from compatible author-prepared inputs: the main local-government panel plus the municipal bond issue match, followed by the separate local-election and congressional-election branches. Raw-source construction is conditional context because no producer program is supplied; retain the prepared CKM/new-issues route when the authors can provide compatible inputs.

Entry points: `CKM Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 4/12325 - Politically-Connected-Governments/ckm-datasheet-and-code.zip",
      "sha256": "a946742473446de08f8d924e8e6a1d1a2e8d2f52b05034cfc41174689b599d69"
    },
    {
      "path": "JAR-Volume 58/Issue 4/12325 - Politically-Connected-Governments/ckm-online-appendix.pdf",
      "sha256": "fd651fecf7280b82da17e2f556b730a8936ce9fbebba2f9d27e938562a16f2a3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "221065d8370f2594de5b0a699dd2556db9a19ee3ba089b055c2830d56b39da1a"
}
```

## Proposed actions

### A_INPUTS: Obtain the exact author-prepared analysis files and definitions, then verify the panel, municipal issue match, and both separate election branches against the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MAIN, R_EMMA, R_LOCAL, R_CONGRESS, I_INPUTS, I_PREP_WORKFLOW, I_EMMA_SOURCE, I_DATA_HISTORY, I_ELECTION_HANDOFF
Evidence: E_MAIN_READ, E_EMMA_MERGE, E_LOCAL_READ, E_CONGRESS_READ, E_DATASET_DESCRIPTION, E_MANUAL_LINKAGES, E_CATALOG_SDC, E_CODE_LAGS, E_CODE_PC1_WINDOW, E_APP_REPUTATION_WINDOW, E_WORKFLOW_TRACE, E_ELECTION_SOURCES, E_AUX_SOURCES, E_CONTROL_SOURCES, E_ZIP_POP

Preparation / proposed procedure:

1. Request CKM.dta, new_issues_emma.dta, CKM_local.dta, and CKM_congress.dta in their author-prepared formats, with data dictionaries, identifiers, dates, and field definitions.
2. For CKM.dta, preserve dbkey and dbkey1 as distinct fields until the authors document their relationship; confirm all code-consumed columns, types, audit-year coverage, and the t−1, contiguous t−1 through t−4, and t+1 input windows. Keep the documented FAC 1999–2016 source period separate from those construction windows.
3. For new_issues_emma.dta, confirm the intended product and whether it is the prepared file behind the datasheet’s SDC-based municipal issuer match; document the local-government name/state/city/ZIP crosswalk, issue-year definition, and unique dbkey-audityear key. Do not substitute the generic SDC WRDS new-issues table or a corporate bond product.
4. For CKM_local.dta and CKM_congress.dta, document their separate year1 panels, the construction and meaning of lead_rvotes and pc1_finrep_lag, and the distinct local versus congressional tenure inputs; retain both branches.
5. If a compatible prepared input cannot be supplied, request the actual producer procedures and crosswalks for the relevant city/county, district, committee-membership, bond-issuer, and court/DOJ links. Treat that reconstruction as a conditional fallback, not as additional mandatory raw-source inputs while prepared author data remain the primary route.

Validation to perform later:

- Use bounded metadata/readability inspection for each received Stata file. Compare actual source fields and types with expected_fields, verify dbkey-audityear uniqueness in both merge inputs, and inspect government, county/city, district, committee and year mappings.
- Check date coverage and lead/lag edge availability from the actual inputs without inferring a minimum start year from the broad source-period statement. Do not use transcript counts or identifier listings as analysis data or completeness evidence.

### A_PATHS: Replace the four Windows-drive input paths with coherent relative paths under a data/ directory, and run from the analysis root. This follows the documented host batch-wrapper path convention and preserves all input filenames.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: R_MAIN, R_EMMA, R_LOCAL, R_CONGRESS, I_PATHS
Evidence: E_MAIN_READ, E_EMMA_MERGE, E_LOCAL_READ, E_CONGRESS_READ, E_WORKFLOW_TRACE

**Proposed edit:** `CKM Code.do:1–1`
Source SHA-256: `e9d5eaab816531934597f25b5cc963345beb9b531f3585f572019fc8fe7f7f3f`

Use a relative path compatible with the host batch wrapper; stage the same author-prepared main panel under data/.

Current text:
```
use "[redacted-path-e2289362cb86]", clear
```

Proposed replacement:
```
use "data/CKM.dta", clear
```

**Proposed edit:** `CKM Code.do:5–5`
Source SHA-256: `e9d5eaab816531934597f25b5cc963345beb9b531f3585f572019fc8fe7f7f3f`

Keep the authored merge keys and point the separate municipal issue input to the same relative staging root.

Current text:
```
merge 1:1 dbkey audityear using "[redacted-path-aa25443a0351]"
```

Proposed replacement:
```
merge 1:1 dbkey audityear using "data/new_issues_emma.dta"
```

**Proposed edit:** `CKM Code.do:444–444`
Source SHA-256: `e9d5eaab816531934597f25b5cc963345beb9b531f3585f572019fc8fe7f7f3f`

Keep the separate local-election branch and stage its input under the same relative root.

Current text:
```
use "[redacted-path-259e20b5ec0f]", clear
```

Proposed replacement:
```
use "data/CKM_local.dta", clear
```

**Proposed edit:** `CKM Code.do:466–466`
Source SHA-256: `e9d5eaab816531934597f25b5cc963345beb9b531f3585f572019fc8fe7f7f3f`

Keep the separate congressional-election branch and stage its input under the same relative root.

Current text:
```
use "[redacted-path-59d63643d890]", clear
```

Proposed replacement:
```
use "data/CKM_congress.dta", clear
```

Preparation / proposed procedure:

1. Stage the four exact author-prepared inputs under data/ relative to the analysis working directory.
2. Run the quoted entry filename from the analysis root, where CKM Code.do and data/ are visible. Do not insert an absolute Dropbox workspace path into the Stata source.

Validation to perform later:

- Review all four edited producer/consumer references together and confirm each resolves to the intended filename under data/.
- Confirm the host wrapper can see the relative working directory and input files before a separately authorized batch execution.

### A_STATE_FIX: Correct the Table 21 state label to match the appendix’s documented 12-state list.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_STATE_LABEL
Evidence: E_STATE_CODE, E_STATE_APPENDIX

**Proposed edit:** `CKM Code.do:422–422`
Source SHA-256: `e9d5eaab816531934597f25b5cc963345beb9b531f3585f572019fc8fe7f7f3f`

The appendix names FL; this exact label correction preserves the intended 12-state exclusion test.

Current text:
```
replace large12 = 1 if inlist(statename,"CA","FA","GA","IL","MI","NC")
```

Proposed replacement:
```
replace large12 = 1 if inlist(statename,"CA","FL","GA","IL","MI","NC")
```

Preparation / proposed procedure:

1. Change only FA to FL in the existing inlist() condition; retain all other states and the model specification.

Validation to perform later:

- Confirm the combined two inlist() calls name CA, FL, GA, IL, MI, NC, NJ, NY, OH, PA, TX, and VA, matching the appendix.

### A_REG2HDFE_SETUP: Set up the missing reg2hdfe Stata add-on through its documented public SSC route in a separately authorized runtime setup.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_REG2HDFE
Evidence: E_CODE_REG2HDFE, E_REG2HDFE_PROBE, E_PUBLIC_REG2HDFE

Preparation / proposed procedure:

1. After authorization to configure software, use the repository-listed Stata command ssc install reg2hdfe or recover the exact author environment release if that is required for compatibility.
2. Confirm Stata 18 resolves reg2hdfe on the runtime adopath; do not install or download anything during this assessment.

Validation to perform later:

- Run which reg2hdfe in the configured Stata session and record the resolved path/version before any future author-program run.

### A_REGHDFE_COMPAT: Resolve the specific legacy IV reghdfe syntax and keepsin option compatibility without changing the estimator or model design.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_REGHDFE_COMPAT
Evidence: E_CODE_REGHDFE, E_ENV, E_LOG_REGHDFE

Preparation / proposed procedure:

1. Review the installed reghdfe 6.12.3 help and release notes against CKM Code.do line 329, including the parenthetical endogenous/instrument terms and keepsin abbreviation.
2. The historical transcript shows a prior execution but does not identify the author’s reghdfe version; preserve the original instrument, dependent and control variables, absorb(id), cluster(stcd), and singleton handling.
3. If the current package does not support the exact call, request the author’s target reghdfe version or prepare a narrowly scoped syntax compatibility proposal supported by its version-specific documentation; do not replace the estimator.

Validation to perform later:

- Before a separately authorized full run, document whether reghdfe 6.12.3 accepts the exact call and option. If that remains uncertain, keep the compatibility issue open rather than claiming an error or successful compatibility.

### A_RUN: After the data, path, and software prerequisites are resolved, execute the full supplied workflow in its authored order and retain all main and appendix branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_MAIN, R_EMMA, R_LOCAL, R_CONGRESS, I_INPUTS, I_PREP_WORKFLOW, I_DATA_HISTORY, I_ELECTION_HANDOFF, I_PATHS
Evidence: E_CODE_CONTENT, E_MAIN_READ, E_EMMA_MERGE, E_LOCAL_READ, E_CONGRESS_READ, E_WORKFLOW_TRACE, E_LOG_END, E_ELECTION_SOURCES

Preparation / proposed procedure:

1. From the analysis root, stage the main panel and new-issue file, run CKM Code.do through the main merge, variable construction, Tables 1–6, and all included online-appendix analyses. The merge creates new_issue from dbkey-audityear match status; the supplied code does not save a new analysis dataset.
2. Continue in the authored do-file order: load CKM_local.dta for Table 7, then load CKM_congress.dta for Table 8. These are independent supplied input branches, not outputs of the main merge.
3. Use host batch mode from the analysis root with the quoted relative entry filename, for example: stata -b do "CKM Code.do". All relative data/ paths must resolve from that same working directory.

Validation to perform later:

- Confirm the main, local-election, and congressional-election branches all complete and every analysis entry point listed in the trace artifact is represented.
- Review the merge match keys, time windows, input coverage and Table 21 corrected state list. Compare historical transcript output only as contextual evidence; do not require historical counts or coefficients when input versions differ.
- Keep execution_verified false until a separately authorized end-to-end run has actually been completed and reviewed.


## Remaining issues and prerequisites

- I_INPUTS [unresolved; full_pipeline]: The four exact analysis inputs named by the supplied code are absent from the assigned package inventory: CKM.dta, new_issues_emma.dta, CKM_local.dta, and CKM_congress.dta. No readable file, schema, or verified compatible retrieval route is present.
- I_PREP_WORKFLOW [unresolved; full_pipeline]: The datasheet describes historical source collection and manual construction of the analysis panel, including Single Audit city/county records, ZIP-to-district assignment, political membership/tenure, departure verification, bond issuer matching, and DOJ/court geographic linkage. It also names separate election data sources. The supplied do-file starts from prepared datasets and the datasheet-referenced Appendix D worked example is not included. The author-prepared CKM and new-issue files are the primary route; historic raw source origins are not separate mandatory inputs if compatible prepared files are supplied.
- I_EMMA_SOURCE [unresolved; full_pipeline]: The do-file calls the bond merge input new_issues_emma.dta, while the datasheet says Thomson Reuters SDC Platinum records were hand-matched to Single Audit auditees by issuer name, state, city, and ZIP. The source/product relationship, issuer-to-government mapping, issue-year definition, and whether the prepared EMMA file is the intended deliverable are unresolved. Frozen catalog SDC new-issues metadata does not establish a compatible municipal issuer crosswalk.
- I_DATA_HISTORY [unresolved; full_pipeline]: The code’s actual time construction requires t−1 tenure/death/appropriation values, contiguous PC1 history for t−1 through t−4, and a t+1 PC1 value for the reputation measure. The broad FAC period is 1999–2016, but the required per-variable edge coverage and construction of precomputed pc1_finrep_lag/lead_rvotes in the two election inputs are not specified. Do not infer a minimum start year from the source filter.
- I_ELECTION_HANDOFF [unresolved; full_pipeline]: The Table 7 and Table 8 branches load independent CKM_local.dta and CKM_congress.dta files. The datasheet traces local-official elections to OurCampaigns and congressional elections to MIT Election Data and Science Lab, but CKM Code.do does not create either analysis file or document the producer/identifier/period handoff for lead_rvotes, pc1_finrep_lag, and their distinct local versus congressional tenure inputs. Both supplied branches remain in the target.
- I_PATHS [preparation; full_pipeline]: All four input references use Windows [redacted-path-9842a853c665] paths. The documented Stata batch wrapper runs in the host working directory and requires relative or [redacted-path-ed5326351e1f] paths; the exact file references need a coherent relative staging root.
- I_STATE_LABEL [preparation; full_pipeline]: The Table 21 exclusion code names FA in the 12-state list, while the appendix specifies FL. This is a supported exact repair so the listed 12 states match the source description.
- I_REGHDFE_COMPAT [unresolved; full_pipeline]: Stata 18 currently finds reghdfe 6.12.3, and the supplied code uses its older parenthetical IV specification plus the keepsin option. The PDF transcript records a prior run, but it does not identify the reghdfe release. Current syntax/option compatibility remains unverified; preserve the estimator, instrument, fixed effects, sample, and cluster specification.
- R_MAIN [undetermined]: Author-prepared main local-government audit and political-representation panel read as [redacted-path-e2289362cb86]. The supplied code consumes the listed input columns and creates reporting-quality, tenure interaction, court/DOJ, media, favoritism, and other variables for the main paper and appendix analyses.
- R_EMMA [undetermined]: Separate prepared municipal bond-issue match file merged into the main panel on dbkey and audityear to construct new_issue. Preserve local-government identity and issue-year matching; the source product and mapping differ from the datasheet description and need clarification.
- R_LOCAL [undetermined]: Separate author-prepared local-election analysis dataset read by the supplied Table 7 branch as [redacted-path-259e20b5ec0f]. The datasheet traces local-official election data to OurCampaigns and identifies county controls; this file is not produced by CKM Code.do.
- R_CONGRESS [undetermined]: Separate author-prepared congressional-election analysis dataset read by the supplied Table 8 branch as [redacted-path-59d63643d890]. The datasheet traces congressional election data to MIT Election Data and Science Lab; this file is not produced by CKM Code.do.
- SW_REG2HDFE [preparation_required]: The supplied state-by-year fixed-effects branch invokes reg2hdfe, but the exact Stata 18 which reg2hdfe probe did not find it. The RePEc Boston College software-components page identifies an SSC install route; compatibility and execution on current data still need future validation.

## Review notes

- All three frozen dependency IDs are individually reviewed. Manual source inspection also found the direct new_issues_emma.dta merge input at CKM Code.do lines 3–5, omitted from the frozen checklist; it is recorded as R_EMMA without inventing a dependency ID.
- The 488-line standalone Stata DO is substantive preparation and analysis code. CKM Code.pdf is a historical command/output transcript that ends with end of do-file; its numerical outputs or any identifier listing are not an analysis panel or a substitute for the four missing inputs.
- No analysis_only scope is added: the two election files are absent, and no compatible prepared-data route is verified. All supplied branches remain in the full target.
- Historic source origins are contextual if the authors provide compatible prepared CKM/new-issue inputs. The county/city, municipality, district, committee membership, political departure, and DOJ/court links must remain intact. The catalog SDC candidate is not credited as a municipal substitute.
- Stata 18, estpost, reghdfe 6.12.3, ftools 2.49.1, and the actual _gxtile helper were observed. reg2hdfe is not found and has a documented public SSC route. The legacy reghdfe IV call and keepsin compatibility remain specifically unresolved.
- The author Stata release is unspecified; no incompatibility is inferred from that alone. Execution has not been verified, and no author code or regression was run.
- The datasheet also documents DOJ and court source periods of 1998–2017, local-government elections from OurCampaigns, congressional elections from MIT Election Data and Science Lab, voter registration, and county controls. These are source provenance/context for the missing prepared files; they are not added as independent mandatory inputs when the author-prepared route is supplied.
- Datasheet source sections cite the 1998–2017 DOJ/court material, 2010 voter registration, OurCampaigns local elections, MIT congressional elections, and BLS/BEA/USDA county controls. These remain upstream provenance for prepared inputs rather than separate AND-rebuild requirements.
- The datasheet specifically says 2015 ZIP-level demographic data were used to map auditee ZIP codes to city/county population; this remains part of the CKM prepared-panel provenance, not an extra raw file requirement if that panel is supplied.
