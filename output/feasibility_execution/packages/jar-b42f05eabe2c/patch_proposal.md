# Patch proposal: jar-b42f05eabe2c

Real effects of a widespread CSR reporting mandate: Evidence from the European Union’s CSR directive

DOI: 10.1111/1475-679X.12424

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied FHL_Code.do preparation, three sample branches, propensity-score-matching branch, and Tables 1-4 workflow; no separate analysis-ready panel route is supplied.

Entry points: `FHL_Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12424 - Real-effects-of-a-widespread-CSR-reporting-mandate-Evidence-from-the-European-Unions-CSR-directive/fhl-datasheet-code-identifiers.zip",
      "sha256": "a6e1e58b50e5a98ba2db2f3488478f71680087e1d803a7ff4aa50b6ee0698ca4"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12424 - Real-effects-of-a-widespread-CSR-reporting-mandate-Evidence-from-the-European-Unions-CSR-directive/fhl-online-appendix.pdf",
      "sha256": "53595d28410ec9473ddf39576dfb69de125c2681bdea31b29f709c8933897649"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "40c97369727082f67038f8af1cbf7bfd874f7b3bd298a9062ad11cee3d9aebdc"
}
```

## Proposed actions

### A_VENDOR_ROUTES: Use the author regional exports if obtained; the assigned catalog and exact one-row checks also expose candidate local products, but no tested candidate is compatible enough to close any vendor requirement. Preserve the author keys, regions, fields and period while resolving product/field mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WORLDSCOPE, R_IBES, R_ASSET4, I_VENDOR_COMPATIBILITY
Evidence: E_CODE_INPUT_GROUPS, E_DATASHEET_PRODUCTS, E_VENDOR_FIELDS, E_ASSET4_FIELDS, E_LAG_HISTORY, E_CATALOG_PRODUCTS, E_PROBE_WORLDSCOPE, E_PROBE_IBES_US, E_PROBE_IBES_INT, E_PROBE_TRESG_INFO, E_PROBE_TRESG_CG, E_PROBE_TRESG_EN, E_PROBE_TRESG_SO, E_PROBE_TRESG_SMRY, E_WORKFLOW_TRACE_RESOURCE

Preparation / proposed procedure:

1. Prefer the author's six regional Worldscope/I/B/E/S and fifteen ASSET4 export files; the staged package is missing them. Keep `wc06008` and `wc05350`, region partitions and the 2010-2018 source labels intact.
2. If considering the local catalog products, map each required source column to an actual product field and establish the company/ISIN, fiscal-year/date, region and product-version contract. Treat I/B/E/S NUMEST only as a candidate for recno, not an assumed equivalence; use the TRESG information bridge and panels only if the OrgId/FisYear-to-wc06008/wc05350 mapping and complete required item set are supported.
3. After separately authorized compatible acquisition, retain the authored transformations and validate the historical 2010 lag input for 2011 plus full 2011-2018 panel coverage before running the analysis.

Validation to perform later:

- After a separately authorized acquisition, inspect bounded headers and compare all imported columns, identifiers, period/date types, regional partitions and table-specific keys with FHL_Code.do before running the authored sequence.

### A_MANUAL_ROUTE: The compatible primary route is the exact pair of author-prepared workbooks. Obtain or inspect those files before considering Appendix H's public/manual route, which remains unverified at field, population and coding-rule level.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MANUAL_2019, R_MANUAL_2020, I_MANUAL_INPUT_CONTRACT
Evidence: E_MANUAL_2019, E_MANUAL_2020, E_MANUAL_MERGES, E_APPENDIX_H_PUBLIC, E_APPENDIX_H_EDGAR, E_APPENDIX_H_RULES, PUB_X_ADV_DATES, PUB_X_ADV_LOGIN, PUB_X_MISSING_POSTS, PUB_WAYBACK_SEARCH, PUB_WAYBACK_COVERAGE, PUB_SEC_SEARCH

Preparation / proposed procedure:

1. Obtain the distinct author-prepared `FHL_data_2019 10 03.xlsx` (sheet `stata 2.0`) and `Collection CSR 2020 June_EU and US nl.xlsx` (sheet `Stata`) files; the identifier-only FHL_Sample.xlsx is not a substitute.
2. For the 2019 sheet, compare the imported and kept fields and U.S. restriction to the code. For the 2020 sheet, verify the source columns AC/realinitiative/SOC/ENV/increasedvisibilityandorrest/CSRinitiativesourcewebpage/CSRinitiativesourcetwitter, `Sample_HandcollRev`, and the authored renamed columns.
3. Keep the two-file `wc06008`/year 1:1 merge and the later m:1 merge by `wc06008`; check uniqueness and types only after the actual workbooks or a fully documented compatible public collection are available.
4. If the prepared files cannot be obtained, review only the Appendix H 2014 annual-report, Wayback, Twitter and U.S.-high-exposure EDGAR channels. Establish issuer coverage and full coding rules for both workbook roles; the current static docs and non-exhaustive recipe do not close this route.

Validation to perform later:

- After separately authorized acquisition or collection, compare the actual sheet/raw headers and bounded key/type metadata with the import, keep, rename and merge calls; verify the required one-to-one and many-to-one key contracts without changing them.

### A_ROOT_SETUP: Use a working copy with one relative project root and preserve the authored Data, Temp, and Output folders. Launch from that root so the single PATH macro resolves every producing and consuming call consistently.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WORKING_ROOT
Evidence: E_PATH_ROOT, E_WORKFLOW_TRACE

**Proposed edit:** `FHL_Code.do:48–48`
Source SHA-256: `146c5d4209971fc6eaead6f678041014f149981da7e3b349ceac3f26fd219db8`

Set the existing common PATH root to the project working directory; invoke FHL_Code.do from that directory and keep the relative (1) Data, (2) Temp, and (3) Output tree intact. This changes path configuration only, not data, definitions, samples, or estimators.

Current text:
```
global PATH "[redacted-path-58d3cd3c49ea]"
```

Proposed replacement:
```
global PATH "."
```

Preparation / proposed procedure:

1. In a working copy, make the code root and all referenced relative subdirectories visible and writable on the host; the host batch wrapper must use the documented [redacted-path-82126f0ad9a6] or relative root, not a Dropbox absolute path.
2. Create the existing Temp and Output folders as needed and retain the separate source folders beneath the same project root.
3. Check every source read, intermediate save/use, and RTF output path under the common PATH before any separately authorized run.

Validation to perform later:

- Statically compare every PATH-based read/write against the selected working-copy tree; after separately authorized setup, run the ordered do-file from the configured project root and confirm output files land under Output.

### A_SOFTWARE_SETUP: Prepare the missing active Stata commands before a future run, then verify the invoked names individually in the same Stata 18 environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_PSMATCH2, SW_PSTEST, SW_RBOUNDS, I_ADDON_METADATA
Evidence: E_ADDON_HEADER, E_PSM_CALLS, E_SW_PSMATCH2, E_SW_PSTEST, E_SW_RBOUNDS

Preparation / proposed procedure:

1. Use the source-documented psmatch2 and rbounds setup instructions in the user's Stata environment; ensure the invoked pstest command is also provided. Do not run the source's install header as part of this assessment.
2. Keep the active winsor, ffind, eststo and esttab commands at their currently verified locations; do not add dependencies for comment-only npsynth or header-only boottest/eret2/ftools without an active call.

Validation to perform later:

- After setup, run only `which psmatch2`, `which pstest`, and `which rbounds` in the target Stata 18 environment and retain the results; no estimator or author-code trial is needed for this metadata check.

### A_USE_CLEAR_OPTIONS: In a working copy, change the three Stata `use` calls from `, replace` to `, clear` so they load the intended saved intermediate over current memory using a documented option.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_USE_REPLACE_OPTION
Evidence: E_USE_REPLACE_1050, E_USE_REPLACE_1195, E_USE_REPLACE_1204, PUB_STATA_USE

**Proposed edit:** `FHL_Code.do:1050–1050`
Source SHA-256: `146c5d4209971fc6eaead6f678041014f149981da7e3b349ceac3f26fd219db8`

The official Stata 18 [D] use syntax allows clear/nolabel, not replace; clear explicitly allows loading over the current in-memory data and preserves the intended load operation.

Current text:
```
		use "$PATH\(2) Temp\Master2", replace
```

Proposed replacement:
```
		use "$PATH\(2) Temp\Master2", clear
```

**Proposed edit:** `FHL_Code.do:1195–1195`
Source SHA-256: `146c5d4209971fc6eaead6f678041014f149981da7e3b349ceac3f26fd219db8`

The official Stata 18 [D] use syntax allows clear/nolabel, not replace; clear explicitly allows loading over the current in-memory data and preserves the intended load operation.

Current text:
```
use "$PATH\(2) Temp\Master2_s1", replace
```

Proposed replacement:
```
use "$PATH\(2) Temp\Master2_s1", clear
```

**Proposed edit:** `FHL_Code.do:1204–1204`
Source SHA-256: `146c5d4209971fc6eaead6f678041014f149981da7e3b349ceac3f26fd219db8`

The official Stata 18 [D] use syntax allows clear/nolabel, not replace; clear explicitly allows loading over the current in-memory data and preserves the intended load operation.

Current text:
```
use "$PATH\(2) Temp\Master2", replace
```

Proposed replacement:
```
use "$PATH\(2) Temp\Master2", clear
```

Preparation / proposed procedure:

1. Apply the three exact line edits only to a working copy; leave all saved filenames, branch order, data definitions and estimators unchanged.

Validation to perform later:

- Statically confirm the edited commands use `use ..., clear` and the corresponding saved intermediates are still produced earlier in the same PATH/Temp sequence.
- After all data and software prerequisites are resolved and any future run is separately authorized, verify the do-file proceeds past each load without changing its sample or analysis.


## Remaining issues and prerequisites

- I_VENDOR_COMPATIBILITY [unresolved; full_pipeline]: Frozen metadata and exact bounded reads identify accessible Worldscope annual, U.S./international I/B/E/S summary, and WRDS ESG panel/crosswalk candidates. They do not show equivalence to the six regional Worldscope/I/B/E/S exports or fifteen ASSET4 slices: `recno` is not proven to equal `NUMEST`, TRESG uses OrgId/FisYear and Isin rather than the authored wc06008/wc05350 pair, and complete product/period/field population remains unverified.
- I_MANUAL_INPUT_CONTRACT [unresolved; full_pipeline]: The two directly consumed author-prepared workbooks are absent. Appendix H provides a compatibility-limited 2014 collection alternative, but it does not establish both workbook roles, the second workbook's raw-column rename/hand-review field, the complete population or the wc06008/year key and Master1 merge contracts. X login/indexing and Wayback capture limits are documented; no issuer-specific record was checked.
- I_WORKING_ROOT [preparation; full_pipeline]: The source sets PATH to an author-specific absolute Windows directory. A coherent relative project root and Temp/Output staging are needed for a working-copy run, with every source and output path kept under the same root.
- I_ADDON_METADATA [preparation; full_pipeline]: Stata 18 is available; version/which metadata found the actively invoked winsor, ffind, eststo and esttab commands, but did not find psmatch2, pstest or rbounds. These are free setup dependencies named by the source's install header; no installation or author-code trial occurred.
- I_USE_REPLACE_OPTION [preparation; full_pipeline]: Three `use` calls pass `replace`; the official Stata 18 `use` syntax lists `clear` and `nolabel`. A working-copy change to `clear` is supported and preserves the intended load-over-current-data operation.
- R_WORLDSCOPE [undetermined]: The six region-split Worldscope/I/B/E/S export files are needed to build the 2010-2018 EU/US/INT firm panel. Worldscope ownership and consumed fields include wc06008, wc05350, wc02999, wc07011, wc06026/wc06027, wc05427, wc07021, accounting/market fields, xwc02999u, nosh, and noshff. Exact source-field, type, coverage, currency, and identifier compatibility remain unverified.
- R_IBES [undetermined]: The authors' regional Worldscope/I/B/E/S exports must supply the recno analyst-following value consumed by lnAF. Its actual I/B/E/S source mapping, population, period, regional coverage, and date/key alignment are not proven by this release.
- R_ASSET4 [undetermined]: All fifteen EU/US/INT ASSET4 export slices are required to produce the CSR, governance, disclosure, environmental, and social fields merged by wc06008 and wc05350. Actual field types, product/version, partitions, population, and panel coverage need verification.
- R_MANUAL_2019 [undetermined]: The separate FHL_data_2019 10 03.xlsx input, sheet stata 2.0, supplies the named hand-collected initiative fields for U.S. firms and is merged with the second manual dataset.
- R_MANUAL_2020 [undetermined]: The separate Collection CSR 2020 June_EU and US nl.xlsx input, sheet Stata, supplies the second hand-collected source, including raw columns renamed by the code, and is merged with the 2019 workbook.
- SW_PSMATCH2 [preparation_required]: Stata 18 `which psmatch2` reported not found (return code 111).
- SW_PSTEST [preparation_required]: Stata 18 `which pstest` reported not found (return code 111).
- SW_RBOUNDS [preparation_required]: Stata 18 `which rbounds` reported not found (return code 111).

## Review notes

- A source-review checkpoint was saved before optional product and software checks; this final assessment adds the catalog, public-route, bounded-probe and version/which evidence.
- The static audit's Table 2-4 missing-export flags are detector omissions: each corresponding active esttab using command is present in FHL_Code.do. The audit's generated Temp .dta paths were manually reconciled to preceding saves and subsequent uses.
- No author code, data import, formula recalculation, statistical or estimator trial, software installation, SAS process, or payload request was made.
- Stage 2: added exact frozen-catalog metadata, eight bounded one-row candidate product checks, and official static route documentation. All local/public alternatives remain explicitly unverified; catalog and first-row observations are not treated as full coverage, access or license evidence.
- Stage 3: actual active Stata add-ons were checked with version/which metadata only. Three active commands need setup; optional/comment-only installs were not promoted to mandatory software.
- Stage 4: the Stata 18 manual's static `use` syntax supports a narrow same-operation working-copy edit at the three `use ..., replace` calls; no author-code syntax or runtime trial was made.
- Stage 5: reconciled the saved trace with completed checks and the official Stata 18 use syntax; updated its evidence hash without overwriting earlier trace versions.
- Stage 6: linked active winsor and eststo software records to the exact source calls; kept the author-prepared workbook route as primary and classified the missing-input step as data acquisition.
