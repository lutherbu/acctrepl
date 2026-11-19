# Patch proposal: jar-56d510b29e91

Director-Liability-Reduction Laws and Conditional Conservatism

DOI: 10.1111/1475-679X.12267

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied SAS preparation and companion Stata law-indicator code for the author-described workflow. Code_1 and Code_2 form ordered SAS preparation branches; Code_3 is a partial Stata robustness-code companion.

Entry points: `Code and Firm ID/Code_1.sas`, `Code and Firm ID/Code_2.sas`, `Code and Firm ID/Code_3.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 4/12267 - Director-Liability-Reduction-Laws-and-Conditional-Conservatism/bl-datasheet-and-code.zip",
      "sha256": "95312e1f57249d8e9455aecb6adee06d8ef336a9dd8b7a2ab2c63c9ab024d8d7"
    },
    {
      "path": "JAR-Volume 57/Issue 4/12267 - Director-Liability-Reduction-Laws-and-Conditional-Conservatism/bl-internet-appendix.pdf",
      "sha256": "2d5503a78bfef6118502eca350f9049a1e894ce37a757236051533d803089daa"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "5ba2786b0edadb384522a06cd34a087c8de971ed2dbbb9b3bb5e325cd096fd7d"
}
```

## Proposed actions

### a-resolve-input-tables: Resolve the exact author-prepared SAS tables or verify compatible underlying products and mappings. Treat each source as a separate input: Compustat financial data; CRSP monthly returns and market returns; Compact Disclosure; 10-K/IRRC state records; Mergent pre-1989 changes; 13F ownership; Bushee classifications; pre/post-1990 G-index; and auditor data. Keep unknown author extraction and periods explicit.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: r-compan, r-crspmon, r-vwretd, r-cd-inc, r-tk-inc, r-mergent-inc, r-owner, r-dedcount, r-gindex89, r-gindex90, r-audit, r-irrc-inc, r-tenkhead, r-bushee-class
Evidence: ev-ds-comp, ev-ds-crsp, ev-ds-own, ev-ds-incorp, ev-ds-gindex, ev-code1-base, ev-code2-owner, ev-code2-ded, ev-code2-gindex, ev-code2-audit, ev-cat-comp, ev-cat-crsp, ev-cat-risk, ev-cat-tfn, ev-cat-mergent, ev-probe-comp-funda, ev-probe-comp-company, ev-probe-crsp-msf, ev-probe-crsp-msi, ev-probe-risk-gset, ev-probe-tfn, ev-bushee-range, ev-bushee-subscription, ev-sraf-headers-range, ev-sraf-incorp-field

Preparation / proposed procedure:

1. Locate each exact author-prepared conserv.* table, or document a compatible source-product-to-table mapping, including keys, fields, units, versions, and coverage.
2. Use COMP.FUNDA plus COMP.COMPANY only as the Compustat accounting/current-company source components; retain the distinct historical Compact Disclosure, 10-K/IRRC, and Mergent mapping. Do not apply current Company incorporation to all historical years.
3. The CRSP.MSF date-to-month key is ordinary preparation supported by Code_1’s companion market-index conversion; build the same YYYYMM key in a prepared copy and confirm it matches CRSP.MSI without changing returns or sample definitions.
4. For historical incorporation, resolve `cd_inc` by CUSIP/fyear, `tk_inc` by CIK/fyear, and Mergent `incorpo` by CIK/year_end; verify state codes, year-boundary rules, and source coverage. The local RISK.GSET file is a candidate for the 1990–2006 IRRC state component, while the exact `tk_inc` composition and 1989 rows remain unresolved.
5. For the 10-K component, the current SRAF 10-X header route covers 1993–2025 and supplies a state-of-incorporation field; confirm the CIK/fiscal-year/form selection and supply a compatible 1989–1992 source. Local SEC/LM path checks did not verify content or coverage.
6. For ownership, confirm the study’s 2016 13F and Bushee classification vintages, manager key and version handling, INSTOWN_PERC/dshare/shrout definitions, units, and date alignment. Do not treat the current 2026 classification file or a raw holdings table as the author-prepared outputs without that mapping.
7. For G-index, locate both distinct pre-1990 Cremers and post-1990 ISS inputs and resolve `gmissing` and the described collection-year expansion; do not substitute a governance table lacking that field.
8. For auditor analysis, locate the separate annual Compustat `au` extract or verify a same-product source mapping for `gvkey/fyear/au`.

Validation to perform later:

- Use bounded metadata/readability probes on exact located files and compare actual source fields against the expected_fields listed on each requirement.
- After a future authorized run, validate required period/identifier coverage, CIK/CUSIP/GVKEY joins, 12-month return windows, and Code_2 filters; one-row reads alone do not establish full history/population.

### a-config-conserv: Configure the SAS `conserv` libref and run Code_1 before Code_2 in the same SAS session so the generated WORK tables remain available. Use a writable batch working directory with a coherent relative execution root and host-visible `[redacted-path-787be8080667]` or relative paths; the exact data directory must be established first.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: i-conserv-library
Evidence: ev-code1-lib, ev-code2-precondition

Preparation / proposed procedure:

1. Identify the actual directory holding the required SAS tables and define conserv there in the future batch configuration.
2. Start one SAS batch session in the selected writable run directory; execute Code_1, then Code_2 without ending the session between scripts.

Validation to perform later:

- Confirm the libref resolves each required input table and that Code_1 creates WORK.comp, WORK.compan, and the required return intermediates before Code_2 reads them.

### a-complete-analysis-driver: Request the missing Stata estimation/output programs and the exact cross-language handoff specification. The needed package additions must identify which SAS WORK branch is exported, the file format/path and variables, how Code_3 is applied to its intended input, and which supplied/omitted scripts produce the paper and appendix analyses. Do not infer estimators or table scripts from reported output alone.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: i-analysis-driver
Evidence: ev-readme, ev-ds-software, ev-code2-main, ev-code2-tail, ev-code3, ev-appendix-scope, ev-cat-risk, ev-bushee-range, ev-sraf-headers-range

Preparation / proposed procedure:

1. Obtain the exact author Stata export/import and estimation programs for all Code_2 branches that end at “export data file to STATA” comments.
2. Confirm which SAS WORK table and schema each ownership, G-index, auditor, main, and DCD test branch should hand to Stata, and which paper/appendix outputs each driver produces.
3. Obtain the producer/specification for Code_2’s consumed owner, dedicated count, G-index and auditor input tables when they are not delivered prepared.
4. For Code_3.txt, confirm its intended input dataset and placement in the Stata workflow; when packaging as a `.do` file, normalize the opening single-slash heading to a valid comment marker in a working copy, preserving all five law-indicator assignments.

Validation to perform later:

- After the completed drivers and prepared inputs are available, verify each intended output dataset/table is generated and matches the documented sample/specification.

### a-verify-sas: Resolve SAS startup availability by an authorized administrator/environment check; the existing probe only establishes a TKELS initialization failure and cannot distinguish runtime setup from entitlement.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw-sas, i-sas-runtime
Evidence: ev-env

Preparation / proposed procedure:

1. Have the SAS environment owner diagnose the existing TKELS initialization failure and confirm SAS 9.4 batch availability and Base SAS components.

Validation to perform later:

- Run a bounded SAS version/component check in a future authorized setup step before author code is considered.

### a-run-procedure: Once the exact inputs, SAS setup and missing analysis handoff are available, run the full supplied branch in dependency order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: ev-code2-precondition, ev-code2-main, ev-code2-owner, ev-code2-ded, ev-code2-gindex, ev-code2-audit, ev-code3

Preparation / proposed procedure:

1. Set a verified writable batch execution root using relative or [redacted-path-787be8080667] paths only, and configure the `conserv` libref to the located inputs.
2. Run Code_1 then Code_2 in the same SAS session; retain the main sample and every ownership, dedicated-ownership, G-index, and auditor preparation branch.
3. After the missing export/import and estimator drivers are supplied, execute each Stata branch in its documented order and apply Code_3 only to its author-confirmed input.

Validation to perform later:

- Compare generated tables and sample counts with author-provided expected outputs; no execution has been verified in this assessment.

### a-derive-crsp-month-key: When preparing a local CRSP.MSF copy for Code_1, derive its YYYYMM `months` key from DATE using the same year(date)*100+month(date) construction that Code_1 applies to the companion CRSP.MSI value-weighted series. This is a supported key-preparation step; it does not resolve history or other author-table fields.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: r-crspmon
Evidence: ev-code1-base, ev-cat-crsp, ev-probe-crsp-msf

Preparation / proposed procedure:

1. In the data preparation input table, retain DATE/CUSIP/PERMNO/RET/HSICCD and create months as year(DATE)*100+month(DATE).
2. Keep the prepared source in a working copy and preserve the author’s return values and key grain.

Validation to perform later:

- Confirm `months` is numeric YYYYMM and matches the corresponding CRSP.MSI month key before joining.
- Check the full author-relevant month coverage in a later authorized validation; the bounded probe did not establish it.


## Remaining issues and prerequisites

- i-analysis-driver [unresolved; full_pipeline]: The README calls Code_2 regression analysis and the datasheet says SAS and Stata perform all analyses, but the supplied Code_2 content prepares WORK datasets and ends at comments to export each branch to Stata. It contains no executable export commands or estimators. Code_3 assigns five law indicators but has no import, dataset handoff, or estimation driver. The appendix documents reported tables/checks whose estimation programs are not supplied. The resulting full workflow and required output mapping cannot be closed from this package.
- i-conserv-library [unresolved; full_pipeline]: Code_1/Code_2 read multiple conserv.* datasets but provide no LIBNAME assignment or directory mapping. The datasheet says the files are saved in a local SAS library named conserv, without listing the table locations or SAS serialization/schema.
- i-sas-runtime [unresolved; full_pipeline]: SAS is required, but the frozen bounded startup probe failed at TKELS initialization and could not establish whether SAS is operational; it does not establish a licensing barrier.
- r-compan [undetermined]: Annual Compustat firm observations consumed as conserv.compan. Code_1 uses financial/accounting items, gvkey/cusip/cik, annual fyear and current incorporation/SIC fields; Code_2 then constructs lags and the 1976–2002 main sample.
- r-crspmon [undetermined]: Monthly CRSP stock returns consumed as conserv.crspmon and joined to annual Compustat/fiscal-year records through a numeric YYYYMM month key.
- r-vwretd [undetermined]: Monthly CRSP value-weighted return series consumed as conserv.vwretd; Code_1 constructs months=year(date)*100+month(date) and merges by months.
- r-cd-inc [undetermined]: Compact Disclosure incorporation records consumed as conserv.cd_inc.
- r-tk-inc [undetermined]: Prepared annual incorporation-state records consumed as conserv.tk_inc and merged to Compustat by CIK/fyear. The datasheet attributes these records to 10-K headings and IRRC; exact author-prepared mapping and period coverage are not included.
- r-mergent-inc [undetermined]: Mergent Online incorporation-change rows consumed as conserv.incorpo and used to reconstruct pre-1989 state changes. The code requires CIK plus year_end (or fyear to derive year_end) and incorp_o; this is separate from the Compact Disclosure and 10-K/IRRC table inputs.
- r-owner [undetermined]: Thomson Reuters 13F ownership input consumed as conserv.owner. Code_2 filters June report dates and requires INSTOWN_PERC, CUSIP and rdate before joining on CUSIP/fyear.
- r-dedcount [undetermined]: Bushee-classified dedicated institutional ownership data consumed as conserv.dedcount and merged to the owner records.
- r-gindex89 [undetermined]: Pre-1990 G-index data consumed as conserv.gindex_89 and joined on GVKEY/fyear.
- r-gindex90 [undetermined]: 1990-and-later ISS Governance Legacy G-index data consumed as conserv.gindex_90, keyed by CIK/year and expanded by the supplied code.
- r-audit [undetermined]: Separately downloaded Compustat auditor data consumed as conserv.audit.
- r-irrc-inc [undetermined]: IRRC/RiskMetrics annual state-of-incorporation records used with 10-K headings to create the Code_1 `conserv.tk_inc` table. This is a distinct required historical source component.
- r-tenkhead [undetermined]: 10-K heading records used to construct the annual CIK/fyear/incorporation-state table consumed as `conserv.tk_inc`. The author datasheet reports a 1989-onward source and uses it jointly with IRRC; it is not a live input to Code_1 once an exact prepared `tk_inc` table is supplied.
- r-bushee-class [undetermined]: Brian Bushee dedicated/transient/quasi-indexer manager classifications used upstream to construct `conserv.dedcount` for Code_2’s dedicated-ownership branch. The author datasheet reports a 2016 download.
- sw-sas [unverified]: SAS 9.4 code requires Base SAS data steps, PROC SORT, PROC SQL, and PROC MEANS. The frozen environment probe failed during TKELS initialization, so runtime availability and version are unverified; this does not establish missing entitlement.

## Review notes

- This expanded checkpoint was built from the complete author documentation/programs plus bounded catalog, one-row SAS, directory-existence, current author/repository-page, and CIK-list checks. It does not execute author code or reconstruct estimators.
- Code_2 requires Code_1’s WORK comp and return tables in the same SAS session. Its comments promise export-to-Stata handoffs, but it contains no executable transfer or regression code. Code_3 is substantial Stata indicator-construction code; it has no data import or estimator, and its first single slash may require comment normalization when packaged as a .do file.
- The CIK list has 1,735 identifiers plus its `cik` header and is not a firm-year analysis dataset. No analysis_only scope is supported because no prepared analysis dataset or working export/input route is included.
- Catalog-listed COMP.FUNDA/COMP.COMPANY, CRSP.MSF/CRSP.MSI, and RISK.GSET were readable in bounded row_limit=1 probes. The probes establish columns/readability only. COMP.COMPANY contains current incorporation and is only a baseline/fallback source; historical states still require the separate CUSIP/fyear and CIK/fyear mappings, including Mergent pre-1989 history.
- CRSP.MSF has DATE rather than Code_1’s `months` key; the companion market series code supplies the intended YYYYMM formula, so deriving that key is ordinary preparation. Annual/monthly population and fiscal-year windows remain unverified.
- The local RiskMetrics Governance Legacy product is labeled 1990–2006 and contains CIK/YEAR/STATE/GINDEX. It is a candidate IRRC state source and G-index product, but it does not expose the active Code_2 `gmissing` field; the author gindex_90 table/expansion remains unresolved. No pre-1990 Cremers table was identified locally.
- The local TFN.S34 13F row_limit=1 probe timed out at 15 seconds. Its catalog fields include holdings/shares-outstanding columns, but not the required prepared INSTOWN_PERC; this timeout does not establish data absence or a license barrier. The current WRDS source page describes a 1978–2026 product, while the study used a 2016 extract.
- Brian Bushee’s current author page offers 1981–2025 classification data and requires 13F holdings for the merge. Its current vintage is not verified as equivalent to the authors’ 2016 download. Mergent FISD catalog data are a different product from Mergent Online incorporation history.
- The official Notre Dame 10-X header file is downloadable for 1993–2025 and has an optional state-of-incorporation field. That is a candidate for part of the documented 1989-onward header history; it does not resolve 1989–1992 or the exact CIK/fyear/form and duplicate-filer mapping. SEC raw/parsed roots and LM10X/2002 exist locally, but the bounded checks did not verify their relevant content; the exact LM10X/1989 check was inconclusive and no broad scan was performed.
- The appendix describes state GDP/population and further regression analyses, but no supplied code reads BEA data. These are not added as live inputs. Law enactment thresholds are hard-coded in Code_2/Code_3, so the historic Romano email/table is not treated as a live input. The “public sources” statement is not proof of current commercial entitlement.
