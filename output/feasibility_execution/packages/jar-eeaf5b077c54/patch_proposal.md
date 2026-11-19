# Patch proposal: jar-eeaf5b077c54

Out of Site, Out of Mind? The Role of the Government-Appointed Corporate Monitor

DOI: 10.1111/1475-679X.12502

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied SAS, R, and Stata data-preparation programs together with the documented manual and author-prepared inputs for the determinants, violations, ethics and compliance, monitor-characteristics, innovation, R&D, and EPA-inspection branches. This scope covers the supplied workflow, not paper-wide estimation programs that are not included.

Entry points: `4. getvars.sas`, `5. ISSDirectors.sas`, `6. CEOIsChair.sas`, `7. NewCEO.sas`, `8. PrelimDeterminants.sas`, `18. Add Ethics and Compliance Norms Vars.R`, `20. Merge Patents vars.R`, `21. Create Restructuring and RD vars from WRDS pull.do`, `22. EPA inspections counts.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12502 - Out-of-Site-Out-of-Mind-The-Role-of-the-Government-Appointed-Corporate-Monitor/glt-datasheet-code-and-identifers.zip",
      "sha256": "9e637d45c5df6875d9d16c0a6bb5683a3917e8dcbcff7606f91b6dc1e665028c"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12502 - Out-of-Site-Out-of-Mind-The-Role-of-the-Government-Appointed-Corporate-Monitor/glt-online-appendix.pdf",
      "sha256": "e52494ffaceb3e63af60f593656255b25b0ec8c88752bec380426eae510519c1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "9c413a0c25e8769fd4b40ac3579c0178eb3c4c58ea0ae0c298668489ebeec278"
}
```

## Proposed actions

### ACT-PREPARED-HANDOFFS: Resolve the manual and author-prepared inputs at their documented handoff points before any future authorized run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-AUTHOR-PREPARED-INPUTS, REQ-CPR-DPA-GVKEY, REQ-CPR-YEARS-OF-INTEREST, REQ-TIMESERIES-YOI-PERMNO, REQ-MANUAL-GOVERNANCE-CODING, REQ-MONITOR-CHARACTERISTICS, REQ-BOARD-ROLES, ISSUE-INPUT-CLOSURE
Evidence: EV-README-CPR-FOUNDATION, EV-README-GOVERNANCE, EV-README-TIMESERIES, EV-README-MONITOR-CHAR, EV-DATASHEET-CODE, EV-BOARD-ROLES

Preparation / proposed procedure:

1. For CPR agreements, YearsOfInterest, TimeSeriesYoI_Permno, Manager_Roles, governance/payment coding and monitor characteristics, record each actual producer, output location, field and key schema, date coverage and M&A/firm attribution rule.
2. Keep the packaged identifiers_w_recid.dta limited to R18 rec_id/GVKEY_TS mapping; do not substitute it for monitor_violations or the firm-year time series.

Validation to perform later:

- Before any future execution, compare author-provided handoffs with the exact supplied consumer keys and dates using metadata only; no source-query or program execution is part of this assessment.

### ACT-GJF-VIOLATIONS: Resolve the author monitor_violations.dta panel and its collection contract, keeping free Good Jobs First search/display separate from subscriber-only bulk downloads.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-VIOLATION-RECORDS, REQ-MONITOR-VIOLATIONS
Evidence: EV-PUBLIC-GJF-SEARCH, EV-PUBLIC-GJF-DOWNLOAD, EV-README-GOVERNANCE, EV-R20-PATENTS, EV-RD-HANDOFF

Preparation / proposed procedure:

1. Obtain or document the author-prepared panel fields rec_id, year, GVKEY_TS, at and size_lag1, producer, date history, firm/parent/M&A attribution and allowed source route.
2. Do not replace the prepared panel with raw manual search results or infer all manual/public access is barred from bulk-download terms.

Validation to perform later:

- Compare only the prepared panel metadata with the exact R20/Stata21 consumers and merge keys before any separately authorized execution.

### ACT-CCM-LINKS: Resolve the author ccmlink.csv producer and history, or document that the bounded local CCM catalogue candidate is an acceptable versioned replacement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-CCM-LINKS
Evidence: EV-R20-PATENTS, EV-CAT-CRSP-CCM, EV-PROBE-CRSP-CCM

Preparation / proposed procedure:

1. Establish the author CSV fields, link-type rules, link-date interval conventions, covered years and exact mapping from the local CCM source to R20.

Validation to perform later:

- Compare schemas and documented history metadata; do not infer version compatibility from a one-row read.

### ACT-WRDS-RD-PULL: Resolve the author WRDS raw R&D/restructuring extract and exact query/period contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-WRDS-RD-PULL
Evidence: EV-RD-INPUTS, EV-README-PATENT-RD, EV-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. Identify the authorized author-prepared raw extract with RCA, RCD, RCEPS, RCP, XRD and every other field referenced by the supplied Stata file; record query, date period and firm keys.

Validation to perform later:

- Check field and period metadata against the supplied consumers without running Stata or querying subject data.

### ACT-RD-HANDOFF: Resolve the intended saved output and downstream consumer for the processed R&D/restructuring merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE-RD-PERSISTENCE
Evidence: EV-RD-HANDOFF, EV-README-PATENT-RD

Preparation / proposed procedure:

1. Obtain the author-specified output name, location and consumer for rd_scaled_w and restructuring; preserve all existing calculations and do not invent a paper-wide endpoint.

Validation to perform later:

- Statically compare the confirmed output contract with the supplied next-stage files before any future authorized execution.

### ACT-COMMERCIAL-PERIODS: Confirm the exact commercial dataset releases, author library configuration and historical coverage needed by the supplied SAS branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-COMPUSTAT-FUNDA, REQ-COMPUSTAT-NAMES, REQ-ISS-LEGACY, REQ-ISS-POSTLEGACY, REQ-CRSP-STOCKNAMES, REQ-CRSP-MSF, REQ-EXECUCOMP-ANNUAL
Evidence: EV-PROBE-COMP-FUNDA, EV-PROBE-COMP-NAMES, EV-PROBE-ISS-LEGACY, EV-PROBE-ISS-POST, EV-PROBE-CRSP-STOCKNAMES, EV-PROBE-CRSP-MSF, EV-PROBE-EXECUCOMP, EV-COMP-DATES, EV-ISS-YEAR-SPLIT

Preparation / proposed procedure:

1. Record the allowed source/version, field aliases, covered firm/date periods and library mappings for Compustat FUNDA/NAMES/ANNCOMP, legacy/post-legacy ISS and CRSP stocknames/MSF.
2. Reconcile the legacy catalog label through 2006 with the code split that retains 2007, and retain the code’s 1995–2020 Compustat window.

Validation to perform later:

- Use provider/catalog and metadata evidence to establish source contracts; one-row bounded probes do not establish full history or target-firm coverage.

### ACT-BOARD-EX-SCHEMA: Resolve the BoardEx NA organization-summary schema aliases and field contract for the supplied CEO-chair join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-BOARD-EX, ISSUE-BOARD-EX-SCHEMA
Evidence: EV-CAT-BOARD-EX, EV-PROBE-BOARD-EX, EV-BOARD-INPUT, EV-BOARD-CUSIP-FIELDS

Preparation / proposed procedure:

1. Confirm authorized field names or documented aliases for ISIN, RoleName, BoardName, AnnualReportDate, DirectorName, BoardID and DirectorID in the named BoardEx product.
2. Resolve the preceding catalog-field mismatch through bounded metadata or provider documentation; do not infer data absence or license status.

Validation to perform later:

- Compare the documented schema and period with SAS6 expectations before any separately authorized data read.

### ACT-EPA-SOURCES: Resolve the exact public ECHO/FRS products and author facility-to-rec_id mapping used by R22.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-EPA-FRS-PROGRAM-LINKS, REQ-EPA-AIR-FACILITIES, REQ-EPA-AIR-FCES-PCES, REQ-EPA-AIR-STACK-TESTS, REQ-EPA-AIR-TITLEV, REQ-EPA-NPDES-INSPECTIONS, REQ-EPA-FEC-INSPECTIONS, REQ-EPA-FACILITY-RECID-MAP
Evidence: EV-PUBLIC-EPA, EV-EPA-INPUTS, EV-EPA-OUTPUT, EV-EPA-FACILITY-MAP, EV-README-EPA

Preparation / proposed procedure:

1. Map each R22 filename to the provider dataset/version, archive member, required fields and study-year coverage.
2. Identify the hand-collected Registry_ID-to-rec_id/company facility CSV producer and preserve the five inspection groups actually counted; FRS_FACILITIES.csv and ICIS_FACILITIES.csv are optional in the supplied code.

Validation to perform later:

- Check published product schema and period against R22 fields and firm/year keys before any separately authorized acquisition or execution.

### ACT-ETHICS-INPUTS: Pin the upstream Li scoring stage and exact score-file contract used by R18.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-PREDICTION-MODEL-ID-MAP, REQ-ETHICS-SCORE-CSV-FAMILY, REQ-FACTSET-TRANSCRIPTS, ISSUE-ETHICS-SCORE-PRODUCER
Evidence: EV-R18-SCORE-FAMILY, EV-R18-ID-MAP, EV-DATASHEET-LI-FACTSET, EV-PUBLIC-LI-REPO, EV-IDENTIFIER-PROBE

Preparation / proposed procedure:

1. Identify the exact Li code/release, transcript inputs and permitted source, model artifacts, six score-file names/order, required columns and study-period coverage.
2. Use the packaged identifiers file only for the verified rec_id/GVKEY_TS mapping; do not infer it supplies score values or the analysis panel.

Validation to perform later:

- Compare the documented score files and identifier keys with R18 indexed joins using metadata only before any future authorized run.

### ACT-KPSS-VERSION: Pin the patent-series version corresponding to the November 2022 author handoff, or establish that a documented current release is acceptable.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-KPSS-PATENT-PANEL, ISSUE-KPSS-VERSION
Evidence: EV-R20-PATENTS, EV-PUBLIC-KPSS-2025

Preparation / proposed procedure:

1. Confirm whether the current 1926–2025 author series with updated CRSP matches and re-estimated values is acceptable; if so, map its file/member names and fields to the supplied R20 reads.

Validation to perform later:

- Verify patent_num, permno, filing_date, xi_real and overlap years against author-panel metadata; do not treat field-name similarity as version equivalence.

### ACT-R-PACKAGES: Make the four R packages used by the supplied scripts discoverable through the approved R environment before any future authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-RPKG-TIDYVERSE, SW-RPKG-HAVEN, SW-RPKG-LUBRIDATE, SW-RPKG-STRINGR, ISSUE-R-PACKAGES
Evidence: EV-ENV, EV-R-PACKAGES, EV-R18-LIBRARIES, EV-R20-LIBRARIES, EV-EPA-LIBRARIES

Preparation / proposed procedure:

1. Provision or expose tidyverse, haven, lubridate and stringr through the normal approved R library process.

Validation to perform later:

- Use package metadata or requireNamespace checks in the intended R runtime; do not run any author R script as a dependency check.

### ACT-SAS-RUNTIME: Establish an ordinary usable SAS runtime and the SAS/ETS support required by PROC EXPAND, together with the approved library configuration for the supplied SAS programs.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, ISSUE-SAS-UNVERIFIED
Evidence: EV-ENV, EV-COMP-SOURCE-FILTER, EV-ISS-LEGACY-INPUTS, EV-SAS-ETS

Preparation / proposed procedure:

1. Resolve ordinary SAS runtime and SAS/ETS component availability through the approved environment configuration; establish safe library roots and aliases without exposing credentials in source or logs.

Validation to perform later:

- A separately authorized future setup check may verify runtime and SAS/ETS component availability; no author program, data read, or license-absence inference is part of this assessment.

### ACT-WINSOR2: Make winsor2 discoverable through the approved Stata environment before any future authorized Stata preparation run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-WINSOR2, ISSUE-WINSOR2
Evidence: EV-ENV, EV-RD-HANDOFF

Preparation / proposed procedure:

1. Verify the authorized Stata adopath or use the administrator’s ordinary add-on setup process.

Validation to perform later:

- Confirm metadata discoverability in the intended Stata environment without executing the author program.

### ACT-PRELIM-MERGE: In a working copy, have the controls merge produce MergeAll6 from the preceding NewCEO MergeAll5 output.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE-PRELIM-MERGE
Evidence: EV-PRELIM-MERGE, EV-PRELIM-CONSUMER

**Proposed edit:** `8. PrelimDeterminants.sas:52–52`
Source SHA-256: `aaf92561d92d9a59310d781e20beb15e38a3d286c9e32146515529d880781345`

The later output step reads MergeAll6; the supplied controls merge currently overwrites the preceding NewCEO MergeAll5.

Current text:
```
proc sql; create table MergeAll5 as
```

Proposed replacement:
```
proc sql; create table MergeAll6 as
```

**Proposed edit:** `8. PrelimDeterminants.sas:54–54`
Source SHA-256: `aaf92561d92d9a59310d781e20beb15e38a3d286c9e32146515529d880781345`

Retain the preceding NewCEO merge while appending Compustat controls and producing the table consumed below.

Current text:
```
	from MergeAll4 as a left join GLTDatFn.vars_final as b
```

Proposed replacement:
```
	from MergeAll5 as a left join GLTDatFn.vars_final as b
```

Preparation / proposed procedure:

1. Keep the supplied package bytes unchanged and apply the two line changes only in a separate working copy.

Validation to perform later:

- In a future working copy, statically confirm that the controls merge reads MergeAll5 and produces MergeAll6, and that the existing determinants write/export consume MergeAll6. After any separately authorized run, validate MergeAll6 fields, join keys and output/sample flow; no execution is part of this assessment.

### ACT-VARS-LIBREF: Configure an exact SAS handoff so GLTDatFn.vars_final resolves to the SAS4-produced var1.vars_final dataset, using the assigned library root or an unchanged dataset copy.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISSUE-VARS-HANDOFF
Evidence: EV-GETVARS-PRODUCER, EV-VARS-CONSUMER, EV-COMP-CONTROLS, EV-COMP-LAGS

Preparation / proposed procedure:

1. Set the assigned SAS library alias/root so GLTDatFn.vars_final references var1.vars_final, or copy the produced dataset unchanged under the consumer name and location.
2. Keep the six controls and the source table construction unchanged; record the mapping and expected output keys.

Validation to perform later:

- At a separately authorized future data run, verify the consumer table has the six produced controls lev, aqi, cvar_emp, mb, roa and size, the expected GVKEY/GVKEY_TS and datadate join, and the documented source period. Keep Compustat history/coverage checks under REQ-COMPUSTAT-FUNDA.

### ACT-R20-ORPHAN-READ: Remove the unused patent_match archive read in a working copy if that optional archive is unavailable.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE-R20-ORPHAN-READ
Evidence: EV-R20-ORPHAN-READ, EV-R20-PATENTS

**Proposed edit:** `20. Merge Patents vars.R:40–40`
Source SHA-256: `d277cc56ff23e40ce56959dc070234f09812bbfccda8135b4af8a592feecad16`

The loaded object is never referenced later in the supplied R20 program, so this read creates an avoidable optional file dependency.

Current text:
```
patent_match <- read.csv(unz('patent_permco_permno_match_public_2020.csv.zip','patent_permco_permno_match_public_2020.csv'), header = T)
```

Proposed replacement:
```
# Optional read removed in a working copy; patent_match has no consumer in the supplied program.
```

Preparation / proposed procedure:

1. Leave the supplied package file unchanged; the proposed one-line comment replacement applies only to a working copy.

Validation to perform later:

- Statically confirm that patent_match has no consumer in the supplied R20 file and that the proposed edit changes no downstream calculation.


## Remaining issues and prerequisites

- ISSUE-INPUT-CLOSURE [unresolved; full_pipeline]: The README and supplied code require several hand-collected agreement, firm-year, violation, governance, monitor-characteristic and facility-crosswalk inputs. Their producers, schemas, histories and firm-attribution rules are not supplied. identifiers_w_recid.dta is an identifier list, not the analysis panel.
- ISSUE-PRELIM-MERGE [preparation; full_pipeline]: PrelimDeterminants.sas creates MergeAll5 with NewCEO fields, then creates MergeAll5 again from MergeAll4 for controls, while the subsequent determinants step and export read MergeAll6. The supported exact two-line same-data working-copy repair remains proposed and unapplied; future output/sample validation is required to confirm the repaired handoff.
- ISSUE-VARS-HANDOFF [preparation; full_pipeline]: SAS4 constructs lev, aqi, cvar_emp, mb, roa and size and writes var1.vars_final; SAS8 consumes GLTDatFn.vars_final. The supplied files do not map those library roots, so configure a same-output alias or an unchanged handoff copy. No separate control-construction mismatch is established here; source period/history coverage remains tracked under REQ-COMPUSTAT-FUNDA.
- ISSUE-BOARD-EX-SCHEMA [unresolved; full_pipeline]: The named BoardEx NA organization-summary candidate is present in the catalogue, but the bounded request for SAS6 fields returned unverified before reading because those requested fields were absent from the catalog. This does not establish data absence or license status.
- ISSUE-SAS-UNVERIFIED [unresolved; full_pipeline]: A usable SAS runtime remains unverified. SAS4 uses PROC EXPAND, which requires SAS/ETS support; the existing startup failure does not establish component availability or license absence, and no new runtime probe was performed.
- ISSUE-WINSOR2 [preparation; full_pipeline]: The Stata program invokes winsor2, which was not found in the bounded checked adopaths. Availability remains unresolved pending ordinary setup.
- ISSUE-R-PACKAGES [preparation; full_pipeline]: R 4.5.0 is available, but the bounded installed-package metadata probe did not find tidyverse, haven, lubridate or stringr in the queried site library.
- ISSUE-ETHICS-SCORE-PRODUCER [unresolved; full_pipeline]: R18 summarizes CSVs selected by directory-list positions 2, 4 and 6. The upstream Li scoring producer and FactSet transcript files are not in this package; exact names, order, required model artifacts and period remain unknown.
- ISSUE-KPSS-VERSION [unresolved; full_pipeline]: R20 names a 2020 KPSS archive; the current author page documents a 2025 series with updated CRSP matches and parameter estimates. Matching field names do not establish equivalence to the November 2022 handoff.
- ISSUE-RD-PERSISTENCE [unresolved; full_pipeline]: The supplied Stata excerpt saves a processed raw pull, merges it into monitor_violations, computes rd_scaled and calls winsor2, then ends at a test comment without persisting the merged result. The intended next handoff is unresolved.
- ISSUE-R20-ORPHAN-READ [preparation; full_pipeline]: R20 reads the patent_permco_permno_match_public_2020 archive into patent_match, but the supplied program never uses that object. The read is optional to the shown workflow and can be removed in a working copy if the file is unavailable.
- REQ-AUTHOR-PREPARED-INPUTS [undetermined]: Author-prepared firm and agreement inputs used by the supplied programs, including the monitor_violations firm-year panel and hand-prepared CPR_DPA_GVKEY, YearsOfInterest, and related crosswalks. The release's identifiers_w_recid.dta is an identifier list rather than a complete analysis panel; the specific producer and schema for these consumed inputs remain to be reconciled.
- REQ-ETHICS-SCORE-CSV-FAMILY [undetermined]: R18 discovers CSVs by directory listing and joins list positions 2, 4 and 6; expected document identifiers/metadata and ethics scores are not supplied. Exact filenames, ordering, producer and period remain unknown.
- REQ-FACTSET-TRANSCRIPTS [undetermined]: The README places Li scoring before R18, and the datasheet identifies FactSet earnings-call transcripts. Transcript files, coverage and local/source access are unresolved; no account status was tested.
- REQ-KPSS-PATENT-PANEL [undetermined]: R20 joins the Kogan patent-level panel by CRSP permno and filing year, then summarizes patent counts and xi_real. The supplied script names a 2020 ZIP; the exact November 2022 handoff is absent.
- REQ-VIOLATION-RECORDS [undetermined]: The README directs manual collection of Good Jobs First violations, while R20 and Stata21 consume the author-prepared monitor_violations.dta firm-year panel. The panel producer, keys, field history and coverage are missing; public violation records are not a substitute for the prepared panel or its author coding.
- REQ-CPR-DPA-GVKEY [undetermined]: SAS8 consumes CPR_DPA_GVKEY; README steps 1–3 also require CPR agreement records, GVKEY identification, dates and coded terms. Neither the prepared table nor its exact producer/period contract is in the package. CPR downloads are a candidate raw source followed by author coding, not proof of the prepared table.
- REQ-MONITOR-VIOLATIONS [undetermined]: R20 and Stata21 read monitor_violations.dta as the author-prepared firm-year panel. Code uses rec_id/year/GVKEY_TS and Stata21 also uses at and size_lag1; producer, field history, firm attribution and period are absent.
- REQ-CCM-LINKS [undetermined]: R20 reads ccmlink.csv with GVKEY, link type, link dates and permanent permno/permco fields, filters link types, and matches year-end dates. The author 2022 CSV is absent.
- REQ-WRDS-RD-PULL [undetermined]: Stata21 reads the author-prepared WRDS raw extract for rca, rcd, rceps, rcp and xrd, then creates a processed pull. Neither extract is packaged; exact query and period remain unknown.
- REQ-COMPUSTAT-FUNDA [undetermined]: SAS4/SAS7 require annual Compustat fundamentals. SAS4 filters 1995-01-01 through 2020-06-15 and uses lags plus five-observation employee windows.
- REQ-COMPUSTAT-NAMES [undetermined]: SAS4 separately joins Compustat names by GVKEY and uses SIC.
- REQ-ISS-LEGACY [undetermined]: SAS5 reads legacy risk.directors and forms independent-director counts/CRSP links. Local candidate fields were probed; catalog label says 1996–2006 while supplied merge retains datadate through 2007.
- REQ-ISS-POSTLEGACY [undetermined]: SAS5 reads post-legacy risk.rmdirectors. Local fields were probed; exact history coverage is unknown.
- REQ-CRSP-STOCKNAMES [undetermined]: SAS5 requires CRSP stocknames for CUSIP-to-permco linking in both ISS branches.
- REQ-CRSP-MSF [undetermined]: SAS5/SAS6 require monthly CRSP data for meeting-date permno selection, market cap and CUSIP matching.
- REQ-BOARD-EX [undetermined]: SAS6 reads BoardEx NA_WRDS_ORG_SUMMARY and expects ISIN, RoleName, BoardName, AnnualReportDate, DirectorName, BoardID and DirectorID.
- REQ-BOARD-ROLES [undetermined]: SAS6 imports the manual Manager_Roles.csv crosswalk with RoleName, Role_ID, CEO/CFO/GC/Role/Chairman and CEOIsChair fields; the file is absent.
- REQ-EXECUCOMP-ANNUAL [undetermined]: SAS7 requires annual Compustat/ExecuComp records by GVKEY/fiscal year to create NewCEO.
- REQ-CPR-YEARS-OF-INTEREST [undetermined]: SAS7/SAS8 consume YearsOfInterest date flags and firm-year series. README says GVKEY/year history is hand-collected and M&A-adjusted; the table and exact periods are absent.
- REQ-TIMESERIES-YOI-PERMNO [undetermined]: SAS5/SAS6 separately upload TimeSeriesYoI_Permno, described as the hand-collected full time series with permnos. It is distinct from unused TimeSeries_Dates and is not packaged.
- REQ-MANUAL-GOVERNANCE-CODING [undetermined]: README steps 9/11 require manually collected N/DPA governance variables and total-payment calculations. No completed data/executable producer is supplied; fields/provenance remain unresolved.
- REQ-MONITOR-CHARACTERISTICS [undetermined]: README step 19 requires manually collected monitor-characteristic data. Completed data and an executable producer are absent.
- REQ-EPA-FRS-PROGRAM-LINKS [undetermined]: R22 uses FRS_PROGRAM_LINKS.csv to map program system IDs to Registry IDs.
- REQ-EPA-AIR-FACILITIES [undetermined]: R22 uses ICIS-AIR_FACILITIES.csv to map program system IDs to Registry IDs.
- REQ-EPA-AIR-FCES-PCES [undetermined]: R22 counts air FCE/PCES records by ACTUAL_END_DATE and mapped PGM_SYS_ID.
- REQ-EPA-AIR-STACK-TESTS [undetermined]: R22 counts air stack-test records by ACTUAL_END_DATE and mapped PGM_SYS_ID.
- REQ-EPA-AIR-TITLEV [undetermined]: R22 counts Title V records by ACTUAL_END_DATE and mapped PGM_SYS_ID.
- REQ-EPA-NPDES-INSPECTIONS [undetermined]: R22 counts NPDES inspections by ACTUAL_END_DATE and Registry_ID.
- REQ-EPA-FEC-INSPECTIONS [undetermined]: R22 counts ICIS FE&C inspections by ACTUAL_END_DATE and Registry_ID.
- REQ-EPA-FACILITY-RECID-MAP [undetermined]: R22 dynamically reads author hand-collected EPA facility CSVs to map Registry_ID to rec_id/company. File names, sources, dates and completed mappings are absent.
- SW-SAS [unverified]: SAS preparation code is supplied. SAS4 uses PROC EXPAND and therefore requires SAS/ETS support; the assigned runtime probe did not establish SAS availability or component installation, and its startup failure is not evidence of license absence.
- SW-WINSOR2 [preparation_required]: The supplied Stata preparation program invokes winsor2; the assigned environment probe did not find it in the checked adopaths.
- SW-RPKG-TIDYVERSE [preparation_required]: The supplied R programs load tidyverse; the saved installed-package metadata probe did not find it in the queried R site library.
- SW-RPKG-HAVEN [preparation_required]: The supplied R programs load haven; the saved installed-package metadata probe did not find it in the queried R site library.
- SW-RPKG-LUBRIDATE [preparation_required]: The supplied R programs load lubridate; the saved installed-package metadata probe did not find it in the queried R site library.
- SW-RPKG-STRINGR [preparation_required]: The supplied R programs load stringr; the saved installed-package metadata probe did not find it in the queried R site library.

## Review notes

- Assessment covers the supplied author preparation workflow: README manual stages and the 9 supplied SAS/R/Stata entry points. It does not infer unsupplied paper-wide estimation programs.
- All source quotations use the exact frozen content_path text; evidence file identity remains each work_item source path. Candidate credential/connection lines were not displayed or used as evidence.
- The exact frozen dependency review covers D0001–D0105 once each. Generated intermediates and unused optional reads have empty target_ids; dynamic/manual reads outside that frozen list are separately recorded in workflow_trace_v4.json.
- Prepared author inputs remain the primary route. The packaged identifiers_w_recid.dta supports only the bounded R18 rec_id/GVKEY_TS mapping and is not the firm-year panel.
- Local SAS probes were bounded to named catalogue files and one row at offset zero with a 15 second timeout. BoardEx requested-field lookup returned unverified before reading. R package checks used installed-package metadata only.
- Public checks were static product documentation only. Good Jobs First free search/display is distinct from subscriber-only bulk spreadsheet downloads; no subject, company, person, court or facility records were queried.
- No author source program, estimator, model, descriptive/statistical routine, synthetic trial or SAS process was executed. No data or model downloads, installations, source edits, or external payload queries were made.
- Input periods, coverage, provider releases, field aliases, crosswalk producers and persistent output handoffs remain unknown where cited. No dataset equivalence or license absence is inferred from catalog metadata or a brand-level result.
- Public source quotes bind directly to the untouched raw text captures. The original capture metadata files contain a trailing literal \n and were preserved byte-for-byte; valid JSON index artifacts point to those raw captures without rewriting or reconstructing them.
- SAS4’s PROC EXPAND calls require SAS/ETS support; the official SAS/ETS overview is supported by the existing primary documentation capture. Product availability remains unverified, with no new runtime probe or installation.
- The MergeAll5 overwrite and vars_final library-name mismatch are recorded as preparation repairs/configuration. Their proposed changes remain unapplied; future output/sample validation and independent Compustat history coverage checks remain open.
