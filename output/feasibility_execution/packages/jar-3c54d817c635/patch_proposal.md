# Patch proposal: jar-3c54d817c635

The Asymmetric Effect of Reporting Flexibility on Priced Risk

DOI: 10.1111/1475-679X.12346

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete author-supplied Stata preparation and analysis workflow that builds the risk-asymmetry inputs and runs its OLS, SOX 404/RDD, placebo, reconvergence, and internal-control analyses.

Entry points: `Reporting Flexibility code.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12346 - The-Asymmetric-Effect-of-Reporting-Flexibility-on-Priced-Risk/bloomfield-datasheet-code-and-identifiers.zip",
      "sha256": "8e851321e439f1489b6fb11d2dda4120061526ca7d0c393c44854f4ab788b14c"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12346 - The-Asymmetric-Effect-of-Reporting-Flexibility-on-Priced-Risk/bloomfield-online-appendix.pdf",
      "sha256": "98ea5dd26beb20291b02c812e2503b968cfdfe8c649ce00ac353fab8dd028559"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "bde0e79b87c4e7c770eee379989a2878aa7abe404698264bf955f6221d53f7f8"
}
```

## Proposed actions

### ACT_DATA_DIRECTORY: Use one relative data directory for author inputs and generated intermediates, with Stata launched from the chosen project working directory. The source itself and datasheet identify line 2 as the user path setting; the proposal is not applied.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: R_CRSP_DAILY, R_FF_DAILY, R_CRSP_MONTHLY, R_COMPUSTAT_ANNUAL, R_SIC_FF48, R_SEGMENTS, R_PUBLIC_FLOAT, R_IL_COMPANYFY, R_IL_GPBA_GRANT, R_IL_GPBA_REL, R_IL_GPBA_ABS, R_IL_PARTICIPANTFY
Evidence: E_CODE_ROOT, E_DS_PACKAGE

**Proposed edit:** `Reporting Flexibility code.do:2–2`
Source SHA-256: `21ca7e326382bb3df4ace271a6214db6c5a80e006797e2dec3a405704f2a8705`

Replace the author-machine absolute path with a relative execution root consistent with the supplied datasheet instruction and common/README host-wrapper guidance.

Current text:
```
local data [redacted-path-73ed66bfa8c2]
```

Proposed replacement:
```
local data "data"
```

Preparation / proposed procedure:

1. Create a writable data directory named data in the selected run directory.
2. Place the prepared Stata-format inputs and generated intermediate files under that directory.
3. Run in batch mode from the same working directory so relative paths resolve on the host.

Validation to perform later:

- Confirm the host wrapper sees the chosen current directory and can read the prepared inputs and write intermediates before any separately authorized author-program run.

### ACT_CRSP_NAME_HISTORY: Prepare the author CRSP DTA panels from the local legacy DSF/MSF candidate tables only after validating the date-effective name-history mapping and author field contract.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_DAILY, R_CRSP_MONTHLY, I_CRSP_NAME_HISTORY_CONTRACT
Evidence: E_CODE_DAILY, E_CODE_MONTHLY, E_PROBE_DSF, E_PROBE_DSENAMES, E_PROBE_MSF, E_PROBE_MSENAMES

Preparation / proposed procedure:

1. Use PERMNO and observation DATE to match the corresponding DSENAMES/MSENAMES interval; preserve author PERMCO and test consistency against name-history PERMCO.
2. Map effective-date SICCD into daily observations and effective-date EXCHCD/SICCD into monthly observations only if source definitions match the author contract.
3. Confirm date interval endpoint semantics, row cardinality, duplicates, missing matches, and full history/population coverage.
4. Keep old DSF/MSF and the separate name-history source as the candidate route; do not automatically substitute DSF_V2 or MSF_V2.

Validation to perform later:

- Compare prepared fields, data types and date ranges with every direct read in the author source.
- Record unmatched and multiple effective-date matches by firm/date before using the prepared tables.

### ACT_COMPUSTAT_PANEL: Resolve the exact annual merged-panel field and lineage contract. COMP.FUNDA and the CCM link table are local candidates, not evidence that the author panel can be reproduced from them without additional source definitions.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMPUSTAT_ANNUAL, I_COMPUSTAT_ANNUAL_CONTRACT
Evidence: E_CODE_ANNUAL, E_CODE_EDR, E_PROBE_FUNDA, E_PROBE_CCM

Preparation / proposed procedure:

1. Match each author-used accounting and fiscal field to its precise source field and vintage.
2. If using COMP.FUNDA, document a date-valid CCM link to LPERMCO and test duplicate-link/cardinality handling before producing the author file.
3. Identify the source and definition of CIK, SIC/SICH and the SOX/internal-control variables already present in the author annual panel; retain them as unresolved until evidenced.
4. Do not infer a formula, link-type filter or special-field source from the one-row probes.

Validation to perform later:

- Compare a prepared annual panel's row unit, GVKEY/LPERMCO/CIK keys, fiscal dates and required field set with the supplied .do reads.
- Verify fyear history back through the construction years and later analysis filters.

### ACT_SIC_FF48: Use the official Ken French SIC definitions as a public candidate only after matching their exact row schema and vintage to SICtoFF48.csv.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SIC_FF48, I_SIC_FF48_VINTAGE
Evidence: E_CODE_SIC, E_PUBLIC_FF48_PAGE

Preparation / proposed procedure:

1. Obtain the official SIC-to-48 definitions file from the linked source.
2. Map to ffnum, ffcode, ffdesc, startsic and endsic without changing interval semantics.
3. Compare mapping version and boundary values with the author's intended historical CSV before deriving industry effects.

Validation to perform later:

- Verify every required CSV column and a complete, nonoverlapping SIC interval mapping for the version selected.

### ACT_PUBLIC_FLOAT: Reconcile the public farr Iliev release with the author's public-float input before use; its documented units and field names differ.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_PUBLIC_FLOAT, I_PUBLIC_FLOAT_VARIANT
Evidence: E_CODE_FLOAT, E_PUBLIC_FARR_INDEX, E_PUBLIC_ILIEV_DOC

Preparation / proposed procedure:

1. Compare the public iliev_2010 publicfloat values and date corrections with the author-version data contract.
2. Map FYEAR/PFYEAR to the author's fiscalyear/publicfloatyear only after confirming their meanings.
3. Convert the documented $ million measure to the dollar scale expected immediately before the author's divide-by-1,000,000 step, or otherwise preserve the documented transformation exactly.
4. Keep the corrected public release distinct from the original author-supplied Iliev file until value-level compatibility is established.

Validation to perform later:

- Check GVKEY/fiscal-year record unit, 2002/2004 year selection and publicfloat units on a documented matched sample.

### ACT_LOCAL_PRODUCT_CONVERSION: Convert the locally readable factors, segments and Incentive Lab SAS tables to the author .dta field contracts while preserving date and identifier meaning.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FF_DAILY, R_SEGMENTS, R_IL_COMPANYFY, R_IL_GPBA_GRANT, R_IL_GPBA_REL, R_IL_GPBA_ABS, R_IL_PARTICIPANTFY
Evidence: E_PROBE_FF, E_PROBE_SEGMENTS, E_PROBE_IL_COMPANYFY, E_PROBE_IL_GPBAGRANT, E_PROBE_IL_GPBAREL, E_PROBE_IL_GPBAABS, E_PROBE_IL_PARTICIPANTFY, E_CODE_INCENTIVE

Preparation / proposed procedure:

1. Create separate Stata-compatible outputs for each required source table; retain source table names and provenance.
2. Normalize source casing and types to the author variable contract only where the field mapping is documented.
3. Verify the 2019 Incentive Lab vintage or preserve any current-vintage differences explicitly.

Validation to perform later:

- Check merge keys and fiscal date fields against the author commands; confirm broad date coverage beyond the bounded single-row samples.

### ACT_STATA_ADDONS: Prepare Stata 18 resolution for winsor2 and runby, the two invoked commands not found by the bounded checks. The actual _gxtile implementation used by egen xtile() resolves successfully; reghdfe and ftools are also present.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_STATA_ADDONS, S_WINSOR2, S_RUNBY, S_EGEN_XTILE
Evidence: E_ENVIRONMENT, E_PROBE_RUNBY, E_CODE_EDR, E_CODE_BETAS, E_CODE_EGEN_XTILE, E_PROBE_GXTILE

Preparation / proposed procedure:

1. Make compatible winsor2 and runby commands resolvable in the intended Stata 18 environment through an approved local ado path.
2. Preserve the author release as unknown unless another supplied source establishes it.
3. Record the actual command versions with non-estimator which/version checks before a future run.
4. Retain the confirmed _gxtile implementation for the egen xtile() calls; do not replace it with the separate xtile command.

Validation to perform later:

- Confirm Stata 18 resolves winsor2, runby, reghdfe and ftools.
- Keep version-sensitive result comparisons separate from software availability.
- Check Stata resolves the invoked _gxtile implementation, winsor2 and runby by exact command/function name.

### ACT_LOG_SOURCE_VARIANT: Only if the historical XLS result tables are required, identify the intended source variant for the log-only output macro and outreg2 calls. The current assessed .do does not invoke outreg2.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LOG_SOURCE_VARIANT
Evidence: E_LOG_OUTPUT_MACRO, E_LOG_OUTREG2, E_CODE_ANALYSES_TAIL

Preparation / proposed procedure:

1. Compare the requested table-export deliverable with the actual supplied .do and PDF mirror.
2. If exports are in scope, identify an authorized source version and output path before proposing an export edit.

Validation to perform later:

- Do not add outreg2 to current software prerequisites unless an authorized source variant actually invokes it.


## Remaining issues and prerequisites

- I_CRSP_NAME_HISTORY_CONTRACT [unresolved; full_pipeline]: Legacy CRSP.DSF/MSF and their name-history tables expose plausible fields for the author panels, including SICCD and monthly EXCHCD with PERMNO and effective dates. The author DTA source join, effective-date boundary, cardinality, PERMCO consistency, time coverage and source-vintage contract are not verified by one-row reads.
- I_COMPUSTAT_ANNUAL_CONTRACT [unresolved; full_pipeline]: The exact author-prepared merged annual panel includes LPERMCO, GVKEY/CIK, fiscal-year/SIC and accounting fields plus SOX/internal-control definitions. COMP.FUNDA and the historical link table are readable candidates, but they do not verify the author's merged panel, special source fields or their definitions. Preserve those gaps rather than guessing a link or formula.
- I_SIC_FF48_VINTAGE [unresolved; full_pipeline]: The public Ken French SIC definitions support a candidate source, but the author-required five-column CSV and its historical mapping vintage have not been matched. The official SIC classification page does not establish exact author row values.
- I_PUBLIC_FLOAT_VARIANT [unresolved; full_pipeline]: The public farr iliev_2010 dataset is an Iliev-source candidate but already stores publicfloat in $ million and uses FYEAR/PFYEAR names; the author code expects dollar values divided by 1,000,000 and fiscalyear/publicfloatyear. The public release also documents date corrections, so values/vintage need explicit comparison before substitution.
- I_STATA_ADDONS [preparation; full_pipeline]: Stata 18, reghdfe 6.12.3, ftools 2.49.1 and the actual _gxtile implementation used by egen xtile() are available in the checked environment. The supplied program also invokes winsor2 and runby; neither was found by the bounded checks in the default/separately checked shared adopaths, so those commands need local preparation before a future run.
- I_LOG_SOURCE_VARIANT [unresolved; full_pipeline]: The 2020 historical log contains a separate output macro and outreg2 XLS table exports that are not in the supplied .do/PDF mirror. The supplied .do remains the assessed program; clarify the intended source variant only if those historical table files are required as an output.
- R_CRSP_DAILY [undetermined]: CRSP daily stock observations imported as CRSP_daily_FULL.dta. The code uses PERMCO, SICCD, RET and DATE to merge daily factors and construct excess returns, then firm-specific weekly returns/crash-risk measures. The local legacy DSF core is readable, and its separate name-history table has effective-dated SICCD; source join/cardinality and the full daily construction history remain unverified.
- R_FF_DAILY [undetermined]: Fama-French daily factor panel read as FFFactors.dta and merged by DATE to CRSP daily returns; the author needs RF and MKTRF. This is a joint but separate input from CRSP returns.
- R_CRSP_MONTHLY [undetermined]: CRSP monthly stock observations imported as CRSP_monthly_FULL.dta. The code uses PERMCO, DATE, RET, PRC, SHROUT, VOL, BID, ASK and EXCHCD to build fiscal-year mappings and annual size/age/volume/spread/volatility characteristics. Local MSF core fields are readable; EXCHCD/SICCD require a separate date-effective name-history candidate, with full period and cardinality unresolved.
- R_COMPUSTAT_ANNUAL [undetermined]: Author-prepared CRSP/Compustat merged annual panel read as CRSP:CompustatMergedFundamentalsAnnual.dta. It supplies firm-year, fiscal-year-end, GVKEY/LPERMCO/CIK, SIC/SICH and accounting inputs for mapping, EDR, characteristics, SOX/internal-control samples and analysis. Local COMP.FUNDA core fields and a separate historical link-table candidate are readable, but their mapping does not establish the author's full panel, special fields/definitions or construction-period contract.
- R_SIC_FF48 [undetermined]: SIC-to-Fama-French-48 lookup CSV read as SICtoFF48.csv with ffnum, ffcode, ffdesc, startsic and endsic. It is used for FF48 assignment in EDR and characteristics and is absent from the package; the current official public SIC definitions are a candidate pending schema/vintage matching.
- R_SEGMENTS [undetermined]: The separate Compustat Non-Historical Segments product read as Segments.dta supplies GVKEY, DATADATE and SID to derive a log segment control. A local merged-segments product has those fields in a bounded read; full period and source/vintage compatibility remain unverified.
- R_PUBLIC_FLOAT [undetermined]: Iliev public-float input read as public-float-data-complete.csv uses publicfloat, fiscalyear, publicfloatyear, gvkey and cik to form 2002/2004 values and merge by GVKEY. It remains a distinct hand-collected source, separate from CRSP and Compustat. A current public Iliev dataset is documented, but its units, field names and date corrections differ from the author contract.
- R_IL_COMPANYFY [undetermined]: Incentive Lab CompanyFY table used in all three Rel/Time/Abs branches; it is joined by CIK/fiscalyear and carries fiscalyearend for Compustat timing. This remains separate from grant and participant tables.
- R_IL_GPBA_GRANT [undetermined]: Incentive Lab GpbaGrant table supplies performance type, grant ID, fiscal month and participant ID across the Rel/Time/Abs branches; it is a separate required source table.
- R_IL_GPBA_REL [undetermined]: Incentive Lab GpbaRel table is merged by grant ID in the relative-performance grant branch and is a separate required source table.
- R_IL_GPBA_ABS [undetermined]: Incentive Lab GpbaAbs table is merged by grant ID in the absolute-performance grant branch and is a separate required source table.
- R_IL_PARTICIPANTFY [undetermined]: Incentive Lab ParticipantFY supplies the CIK/fiscal-year/month/participant join and currentCEO filter across Rel/Time/Abs; it is a separate required source table.
- S_WINSOR2 [preparation_required]: The supplied EDR/accounting construction invokes winsor2. Stata which returned 111 in both checked adopaths; availability elsewhere was not tested.
- S_RUNBY [preparation_required]: The supplied code invokes runby with its own firmspecificrets and getbetas_firm programs. The bounded Stata 18 which probe returned 111; no estimator or model was run.

## Review notes

- Scope: the complete supplied Reporting Flexibility code.do preparation and analysis workflow. The two included PERMCO CSVs are identifier lists, not usable author-prepared analysis panels.
- All 22 frozen dependency checklist IDs are dispositioned. The complete source review also accounts for FFFactors.dta and GpbaGrant.dta, GpbaRel.dta, GpbaAbs.dta and ParticipantFY.dta, which were not represented in the static audit's dependency edges.
- Local SAS resources were checked only with bounded one-row reads. A readable sample is not evidence of full-period coverage or nonmissing values; missing values in individual sampled rows are not field or population absence.
- Legacy CRSP DSF/MSF plus DSENAMES/MSENAMES provide a conditional field-mapping candidate. Effective-date joins, cardinality, source-vintage equivalence and history remain unverified; the current DSF_V2/MSF_V2 products are not automatic replacements.
- The local COMP.FUNDA and CCMXPF link-table probes are candidates only. They do not establish the author's merged annual panel, its CIK/SIC/SOX/internal-control fields, definitions or link construction.
- Public Ken French SIC definitions and the current CRAN farr Iliev table are source candidates. The author SIC CSV schema/vintage and Iliev public-float units, field names and corrected dates must be reconciled before use.
- Stata 18, reghdfe 6.12.3 and ftools 2.49.1 are available in the checked environment. winsor2 and runby were not found in the checked paths and need local preparation; no install was attempted.
- The code's EDR history uses ROA leads/lags and current-plus-two-prior residual windows. The estimation source specifies firm/year-by-fiscal-year/industry absorbed effects and ffnum/fyear clustering; it contains no IV estimator or instrument construction.
- The historical 2020 log is evidence of that earlier run only. Its 130 firm-specific-return by-group errors are not a current execution finding. The datasheet itself explains the paper/log singleton-count difference.
- The historical log's output macro and outreg2 exports are absent from the supplied .do/PDF source pair. outreg2 is not included as a current .do software dependency.
- No author code, model, regression, SAS startup, dataset download, installation, applied edit, synthetic/sentinel test or raw-history scan was performed. No current SEC, Execucomp or CRSP V2 substitution is proposed.
- The actual egen xtile() implementation was checked with `which _gxtile`; it resolves under Stata 18. No egen operation was run.
