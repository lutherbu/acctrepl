# Patch proposal: jar-dd565333b5b9

Cultural Origin and Minority Shareholder Expropriation: Historical Evidence

DOI: 10.1111/1475-679X.12517

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

The complete supplied Stata preparation workflow: files 01–10 construct the regression input panel, and both supplied People’s Daily scripts remain separate included branches with separate outputs.

Entry points: `Replication Packet/01_JinshiNum 20231109 clean.do`, `Replication Packet/02_CSMAR_Jinshi_Merge20230902.do`, `Replication Packet/03_Registered city, province, Taiping rebellion, geographical_Merge20230902.do`, `Replication Packet/04_disclosure quality.do`, `Replication Packet/05_More control variables20230902.do`, `Replication Packet/06_Scholar, book, controlling shareholders and other varible 0816_20230902.do`, `Replication Packet/07_institutional investor.do`, `Replication Packet/08_ret, independent directo4, separation.do`, `Replication Packet/09_CEO,Chairman birthplace and native place jsh.do`, `Replication Packet/10_regression_sample.do`, `Replication Packet/11_People's Daily/处理人民日报词频数据20221020_20230909.do`, `Replication Packet/11_People's Daily/处理人民日报词频数据_noneg20230609_20230906.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12517 - Cultural-Origin-and-Minority-Shareholder-Expropriation-Historical-Evidence/gsz-march-2024-datasheet-and-code.zip",
      "sha256": "3e26fa203fe0d6941502deb019fcb83188d7104f6fb60626eaf743abe029720b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "44be5dfda686cc9e3deb35de97cb6014c06ecd01904a9ea36261fe7cb51383b3"
}
```

## Proposed actions

### A_MAP_INPUTS: Reconcile each named raw input with an exact author-prepared or permitted source route, and resolve both separate dynamic People’s Daily workbook branches without inventing files or coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HQ_COORD, R_CSMAR_COMBAS_00, R_CSMAR_LISTED, R_CSMAR_TRANSFER, R_CITY_PROVINCE, R_TAIPING, R_GEOGRAPHY, R_GDP, R_DISCLOSURE, R_CSMAR_COMBAS_99, R_CSMAR_COMINS, R_EQUITY_2018, R_MING_SCHOLARS, R_MING_BOOKS, R_DIVIDEND, R_QING_POP, R_WIND_HOLDINGS, R_STOCK_MONTHLY, R_MARKET_MONTHLY, R_MANAGER, R_EQUITY_2022, R_CEO_BIRTH, R_PD_FRAUD, R_PD_NONEG, I_INPUT_CLOSURE
Evidence: E_DOC_STEPS, E_DOC_PEOPLE, E_ITEM_INVENTORY, E_TRACE_FINAL, E_CATALOG_EXACT, E_CATALOG_BROAD, E_PD_PUBLIC

Preparation / proposed procedure:

1. For each unverified local route, locate the exact author-named input under a documented host-visible root and confirm the source fields/period against its importing lines; retain the separately named balance-sheet and equity-nature extracts as distinct sources.
2. For the two People’s Daily variants, identify the exact annual Excel files behind all five glob loops, sheet names, year coverage, imported fields, and the separate fraud/noneg output contracts; the official catalog page and subscription note do not establish a current export or entitlement.
3. Treat frozen catalog results only as metadata discovery. Do not infer live access, licensing, or absence from a catalog miss; keep unsupported source-to-field/history claims unresolved.
4. Keep the packaged Qing Jinshi workbook as the primary historical input route. The separate six-field packaged DTA is not read by these programs and does not establish a documented full-panel bypass.

Validation to perform later:

- Before any separately authorized run, verify each actual input’s readability, required fields, period, sheet and source mapping against the cited importing code; verify produced/consumed table handoffs without demanding full join coverage beyond a documented source contract.

### A_CONFIG_ROOTS: Prepare a portable working copy with consistent host-visible roots for files 01–10 and the two distinct People’s Daily branches.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PORTABLE_ROOT
Evidence: E_PATH_01, E_PD_F_PATH, E_PD_N_PATH, E_TRACE_FINAL

Preparation / proposed procedure:

1. Choose a project root and a common Data/rawdata/output mapping for files 01–10, keeping producer and consumer locations identical across stages.
2. Configure separate source/data/output roots for the fraud-count and noneg-count People’s Daily variants; reconcile every cd, glob, save, use, and append path in a separate portable copy.
3. Preserve the assigned package, frozen sources, and evidence artifacts unchanged.

Validation to perform later:

- Before a separately authorized run, confirm every configured directory exists and is writable on the chosen host, then verify the static producer-to-consumer path sequence.

### A_REPAIR_06: Close the unmatched filename quote on the dividend CSV import in a separate working copy while preserving its exact target and operation.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DIVIDEND_IMPORT
Evidence: E_06_IMPORT

**Proposed edit:** `Replication Packet/06_Scholar, book, controlling shareholders and other varible 0816_20230902.do:226–226`
Source SHA-256: `15288563626a606ff6084badf985f4ab517ef4cdc44b7e9979218d5a81079477`

The supplied active line leaves the quoted author-named CSV path open. Adding only its closing quote preserves the same file target and the downstream dividend construction.

Current text:
```
import delimited "${rawdata}/CD_Dividend_2000-2018_15May2020.csv
```

Proposed replacement:
```
import delimited "${rawdata}/CD_Dividend_2000-2018_15May2020.csv"
```

Preparation / proposed procedure:

1. Apply this exact quote-only repair only in a separate working copy after mapping the same CSV to the configured rawdata directory.

Validation to perform later:

- In a separately authorized run, confirm the corrected statement imports that mapped CSV and that its named fields support the existing transformation.

### A_CLARIFY_RET: Locate an author-supported definition for the unfinished return expression before proposing any replacement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_RETURN_EXPRESSION
Evidence: E_08_RET

Preparation / proposed procedure:

1. Ask for or locate an author-supported source version documenting the intended operands and return formula; preserve the current source and its hash until that evidence exists. Do not supply a denominator or substitute formula by inference.

Validation to perform later:

- Only after the source definition is independently supported, propose the exact working-copy correction and verify its inputs and downstream return.dta contract in a separately authorized run.

### A_SETUP_EXTENSIONS: Resolve the missing Stata commands winsor2 and gather through the approved working adopath before a later authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_GATHER
Evidence: E_STATA_SOFTWARE, E_TEMP_03_FLOW, E_WIND_MUTUAL, E_WIND_SOCIAL

Preparation / proposed procedure:

1. Check the intended Stata adopath and author-compatible releases for winsor2 and gather, then arrange the approved local software setup separately; no package was installed during this audit.

Validation to perform later:

- With permission for a later run, verify the exact command entry points are available in the chosen Stata environment and preserve the author’s existing variables and operations.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The code requires multiple named local and CSMAR/Wind inputs, plus two dynamic People’s Daily workbook corpora. The package inventory contains a verified prepared Qing Jinshi workbook and a separate six-field DTA, but the latter is not read by supplied code and is not a complete panel. The exact compatible routes, People’s Daily annual files/fields/coverage, and some input-to-output contracts remain unresolved; catalog misses are not evidence of absent licenses or access barriers.
- I_PORTABLE_ROOT [preparation; full_pipeline]: Files 01–10 set path to an empty string and point rawdata/data/output at ${path}/Data; on POSIX the literal expands to [redacted-path-1cd22566382a]. Those files do not set a project root or change cwd. The two People’s Daily variants use backslash paths and distinct Data/Output roots. Configure host-visible, consistent roots in a separate working copy.
- I_DIVIDEND_IMPORT [preparation; full_pipeline]: File 06’s active dividend import line opens the CSV filename quote and does not close it. A one-character closing-quote edit preserves the same target and import operation in a working copy.
- I_RETURN_EXPRESSION [blocking; full_pipeline]: File 08’s active `gen ret = R-Rm /` expression ends with a division operator and no operand; the next line is blank and then the save command, with no comment or continuation supplying a term. The return.dta producer is therefore blocked by malformed source text. The intended numerator/denominator/formula is not supplied and must not be guessed.
- R_HQ_COORD [undetermined]: Author-named company/year headquarters-coordinate DTA; required by 01, 03, and 06 to construct headquarters distance/location measures.
- R_CSMAR_COMBAS_00 [undetermined]: Distinct author-named CSMAR balance-sheet extract used in file 02 for annual assets, liabilities, and leverage.
- R_CSMAR_LISTED [undetermined]: Author-named company information workbook used in file 02 to construct annual industry codes.
- R_CSMAR_TRANSFER [undetermined]: Author-named CSMAR related-party workbook used in file 02 to derive other receivables.
- R_CITY_PROVINCE [undetermined]: Prepared company-year registered city/province DTA merged by file 03.
- R_TAIPING [undetermined]: Prepared city-level historical covariate merged by file 03.
- R_GEOGRAPHY [undetermined]: Prepared provincial geography source used in file 03; exact feature columns and compatibility remain to be confirmed from the actual file.
- R_GDP [undetermined]: Prepared province-year GDP source merged by file 03.
- R_DISCLOSURE [undetermined]: Disclosure-ranking workbook imported by file 04 to construct code/year evaluation grades; the code omits a filename extension.
- R_CSMAR_COMBAS_99 [undetermined]: Separate author-named CSMAR balance-sheet extract used in file 05 for lagged assets; not merged with the separately named file 02 extract.
- R_CSMAR_COMINS [undetermined]: Author-named CSMAR income-statement source read by both 05 and 06; the code does not specify a filename extension.
- R_EQUITY_2018 [undetermined]: Author-named equity-nature workbook used by file 05 to derive ownership indicators.
- R_MING_SCHOLARS [undetermined]: Workbook with two separately imported school sheets; both coordinate-bearing sheets feed the scholar count constructed in file 06.
- R_MING_BOOKS [undetermined]: Prepared coordinate-level Ming book-printing source used in file 06.
- R_DIVIDEND [undetermined]: Author-named CSMAR dividend CSV used in file 06; its source line needs a closing quote repair before any later run.
- R_QING_POP [undetermined]: Prepared province-level Qing population/tax workbook merged by file 06.
- R_WIND_HOLDINGS [undetermined]: Author-named Wind workbook with separate mutual-fund and social-fund year-column reshapes in file 07; catalog substring matches do not identify this workbook.
- R_STOCK_MONTHLY [undetermined]: Author-named monthly individual-stock return workbook imported by file 08.
- R_MARKET_MONTHLY [undetermined]: Author-named monthly market-return workbook imported by file 08.
- R_MANAGER [undetermined]: Author-named manager/director source used in file 08 to construct independent-director measures.
- R_EQUITY_2022 [undetermined]: Distinct author-named 2022 equity-nature workbook used in file 08 to construct separation rates.
- R_CEO_BIRTH [undetermined]: Author-named CEO birthplace DTA used by file 09 to calculate the CEO birthplace Jinshi measure.
- R_PD_FRAUD [undetermined]: Five dynamic file-glob loops across four year-folder groups feed the fraud-count variant; the exact annual workbooks, coverage and field compatibility are unresolved.
- R_PD_NONEG [undetermined]: Five dynamic file-glob loops across four year-folder groups feed the separate noneg-count variant; the exact annual workbooks, coverage and field compatibility are unresolved.
- SW_WINSOR2 [preparation_required]: Files 03, 06 and 10 call winsor2; the bounded command lookup did not find it in the checked Stata adopath.
- SW_GATHER [preparation_required]: File 07 calls gather twice; the bounded command lookup did not find gather in the checked Stata adopath.

## Review notes

- This is a static assessment only. It includes every one of the 12 supplied Stata files, the actual frozen D0001–D0029 checklist, the prepared Qing Jinshi workbook, direct source reads not represented in that checklist, and both separate People’s Daily variants. No author program, estimator, data transformation, parsing/compilation attempt, or study data was executed.
- The packaged gsz2023_handcollecteddata.dta is a readable author-prepared six-field asset (code, year, jsh_50, scholar_50, book_50, popQing) but is not read by the supplied scripts and is not treated as a complete final panel or analysis-only route. The packaged Qing workbook is the documented, compatible historical input to file 01; only headers/readability were checked, not full history or coverage.
- Catalog exact-name misses and broad substring matches describe only the frozen metadata catalog. They do not establish that a source is absent from the host, unavailable, unlicensed, or inaccessible. The People’s Daily static official catalog page confirms only the archive/login information quoted in E_PD_PUBLIC; exact author workbook delivery and entitlement remain unresolved.
- The code’s 06:226 quote-only fix is a supported preparation proposal. The active 08:90 incomplete division expression is a confirmed blocker, while its intended formula remains unknown. Neither source change was applied.
- Pre-display source scan over all 12 Stata files recorded no credential/connection candidate lines. The unreadable official static page capture is retained in probes as process history only and is not scientific evidence.
