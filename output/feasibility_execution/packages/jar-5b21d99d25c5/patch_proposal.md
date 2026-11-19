# Patch proposal: jar-5b21d99d25c5

Whistleblowers and Outcomes of Financial Misrepresentation Enforcement Actions

DOI: 10.1111/1475-679X.12177

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete author-documented workflow: Stata analyses on the packaged action-level dataset plus the separate SAS/WRDS Compustat-firm comparison branch for Table 2 Panel C and Appendix Table A1 Panel C. The SAS export is not consumed by the Stata do-file; its downstream industry-count step remains unresolved.

Entry points: `CMSW (2017) JAR Stata Code.do`, `CPST Firms (Post SOX Sample Comparison)_2017-04-19.sas`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Direct Stata analyses on the author-provided CMSW_WB_final.dta, bypassing raw-data collection. This scope does not produce or validate the separate Compustat-firm counts required for the documented comparison panels.

Entry points: `CMSW (2017) JAR Stata Code.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12177 - Whistleblowers-and-Outcomes-of-Financial-Misrepresentation-Enforcement-Actions/csmw-datasheet-and-code.zip",
      "sha256": "539a02ada5e3fd765673e2fc3972ab05a5deb7e502210f6aaed3d9cd6ae29969"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12177 - Whistleblowers-and-Outcomes-of-Financial-Misrepresentation-Enforcement-Actions/cmsw_online_appendix.pdf",
      "sha256": "60f550a26b51576fdf68de5474cae36cd9ede41fedef49b7e078c027ab555234"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "afb307a0eb466f8e4c0c319f5a990ab4e94a3e514c74a37db52e9fbc1045c0e5"
}
```

## Proposed actions

### ACT_FILE_CASE: Match the Stata input basename to the packaged filename’s capitalization for the Linux execution environment.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: ISS_FILE_CASE
Evidence: EV_STATA_USE, EV_PACKAGED_DTA

**Proposed edit:** `CMSW (2017) JAR Stata Code.do:12–12`
Source SHA-256: `ae1418f3a737cd5057bdd533c320744e817a527bc680ea83ddd546f49652971a`

The only packaged file is CMSW_WB_final.dta and the lowercase path is absent in this Linux workspace; matching the basename lets Stata open the supplied author-prepared data without altering it.

Current text:
```
use cmsw_wb_final, clear
```

Proposed replacement:
```
use CMSW_WB_final, clear
```

Preparation / proposed procedure:

1. Apply the single capitalization correction in an authorized working copy of the Stata do-file.
2. Run from a writable working directory containing the packaged CMSW_WB_final.dta.

Validation to perform later:

- Confirm Stata opens the packaged dataset and its observation count and required variable list match the assigned metadata probe.

### ACT_STATA_PACKAGES: Install or configure the missing Stata commands from the sources listed in the program and verify they resolve in the intended Stata 18 ado path.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2, SW_PSACALC, ISS_STATA_PACKAGES
Evidence: EV_STATA_INSTALL, EV_WINSOR, EV_OUTREG2, EV_PSACALC

Preparation / proposed procedure:

1. Install or configure outreg2 and psacalc from the net-install sources listed in the do-file; the current Stata 18 probe already finds winsor.
2. Configure the intended Stata ado path and record the versions of the commands obtained. The source does not pin a release, and no specific incompatibility with Stata 18 is evidenced.
3. For a future offline analysis run, prepare the commands before running the do-file and disable its inline net-install statements in a working copy only after local command resolution is confirmed; if network access is available, the listed install commands can remain.

Validation to perform later:

- In the intended Stata 18 ado path, verify which winsor, which outreg2 and which psacalc resolve and record their versions.
- During a future authorized Stata execution, verify the outreg2 exports and psacalc calls complete; the current probes show missing commands, not a compatibility failure.

### ACT_COMP_DATA_ROUTE: Confirm the intended authorized source and vintage for the separate Compustat comparison branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_FUNDA, REQ_COMP_COMPANY
Evidence: EV_DS_SAS, EV_SAS_REMOTE, EV_COMP_FUNDA_READ, EV_COMP_COMPANY_READ, EV_COMP_LOCAL, EV_COMP_LOCAL_LIMITS

Preparation / proposed procedure:

1. Confirm the authors’ expected WRDS source/vintage and how the !SASROOT/wrdslib.sas include is made available on the remote server.
2. The exact local COMP.FUNDA and COMP.COMPANY paths returned required field names in a prior metadataonly operation, but no row/byte limit or bounded traversal method was established. Their year coverage and vintage remain unverified; do not use their reported row counts as coverage evidence or substitute them for WRDS without confirmation.
3. If the author-approved route is a prepared output rather than live WRDS access, obtain its period/row-unit specification and producer instructions; do not reconstruct OSHA or enforcement-action records independently.

Validation to perform later:

- With the approved route, check FYEAR bounds and required filtered fields using bounded metadata, and confirm GVKEY/SIC join behavior and the intended final firm sample before a future authorized SAS run.

### ACT_SAS_RUNTIME: Confirm a supported SAS launch/session and the SAS/CONNECT and SAS/ACCESS features required by the companion program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_CONNECT, SW_SAS_ACCESS, ISS_SAS_RUNTIME
Evidence: EV_SAS_DMS, EV_SAS_REMOTE, EV_SAS_SAMPLE_OUTPUT, EV_ENV, EV_DOC_SAS_DM, EV_DOC_SAS_CONNECT, EV_DOC_PCFILES

Preparation / proposed procedure:

1. Confirm whether the SAS companion is intended for an interactive Display Manager session or a batch client; its DM command is a windowing-environment command and SIGNON uses USERNAME=_PROMPT_.
2. Confirm a functioning SAS runtime plus SAS/CONNECT and the SAS/ACCESS PC Files feature needed by DBMS=STATA export, along with a valid author-approved WRDS sign-on path. Do not put credentials in source.
3. The assigned SAS startup probe stopped at TKELS initialization; treat runtime and feature availability as unverified, not as proof of a missing license. No further SAS startup troubleshooting was performed.

Validation to perform later:

- In an authorized SAS environment, verify session startup, credential prompting, remote sign-on and Stata export capability before executing the author companion.

### ACT_WRDS_INCLUDE: Confirm the remote WRDS library include required by the supplied RSUBMIT block.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_WRDS_INCLUDE
Evidence: EV_WRDS_INCLUDE, EV_SAS_REMOTE

Preparation / proposed procedure:

1. Ask the authors or WRDS administrator whether !SASROOT/wrdslib.sas is available in the remote SAS session and whether the include path or librefs require a project-specific setup.
2. Preserve the program’s remote WORK and COMP librefs; do not guess a local file substitute.

Validation to perform later:

- Before any authorized SAS run, confirm the remote include resolves and the COMP library exposes FUNDA and COMPANY.

### ACT_SAS_SAMPLE: Clarify the intended company/year selection represented by the SAS comments and deduplication steps.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_SAS_SAMPLE
Evidence: EV_SAS_SAMPLE_COMMENT, EV_COMP_FUNDA_READ, EV_SAS_JOIN, EV_SAS_SAMPLE_OUTPUT

Preparation / proposed procedure:

1. Ask whether the “first year of any violation beginning” comment refers to an omitted join or filter, and request the actual intended one-row-per-GVKEY selection rule.
2. Confirm whether the final 1979–2012 filter is intended after the remote NODUPKEY step and which Compustat record should represent each firm.
3. Do not infer date order from the physical order of COMP.FUNDA rows or alter the sample rule without author confirmation.

Validation to perform later:

- After author clarification and an authorized run, verify one row per intended GVKEY and the documented period/filter before computing comparison counts.

### ACT_FF12_HANDOFF: Obtain the missing author-documented SIC-to-FF12 and Compustat summary stage for the comparison panels.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_SAS_FF12
Evidence: EV_DS_SAS, EV_APPX_FF12, EV_APPX_COMP, EV_SAS_SAMPLE_OUTPUT, EV_STATA_TABLE2, EV_STATA_APPENDIX

Preparation / proposed procedure:

1. Ask for the supplied mapping or program that turns the SAS SIC/SIC_N output into FF12 firm counts for Table 2 Panel C and online Appendix Table A1 Panel C.
2. Confirm whether cpstfirms1.dta is meant to feed another author script or a manual table step; the supplied Stata do-file never loads it.
3. Keep the Stata action-level FF12 tabulations separate from the Compustat-firm counts and do not build an independent crosswalk.

Validation to perform later:

- Compare the author-provided FF12 category counts and totals against the cited table panels after an authorized execution.

### ACT_SAS_OUTPUT: Replace the Windows-specific export destination only after the intended output location is confirmed.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS_SAS_OUTPUT
Evidence: EV_SAS_SAMPLE_OUTPUT

Preparation / proposed procedure:

1. Confirm the writable Linux output path and downstream reader for cpstfirms1.dta.
2. In an authorized working copy, configure the OUTFILE path for that destination while preserving the output dataset name.

Validation to perform later:

- Verify the export creates cpstfirms1.dta at the confirmed destination and that the intended downstream stage can read it.

### ACT_RUN_SEQUENCE: Run the Stata analysis directly on the supplied prepared dataset, and keep the independent SAS/WRDS comparison branch separate.

Scopes: full_pipeline, analysis_only. Type: run_procedure. Certainty: conditional.
Addresses: REQ_ANALYSIS_DTA
Evidence: EV_DS_ANALYSIS, EV_DS_SAS, EV_STATA_USE, EV_SAS_REMOTE, EV_SAS_JOIN, EV_SAS_DOWNLOAD, EV_SAS_SAMPLE_OUTPUT, EV_STATA_TABLE2, EV_STATA_APPENDIX

Preparation / proposed procedure:

1. For the Stata route, use the author-prepared CMSW_WB_final.dta with the corrected basename, required commands and a writable working directory; the script defines testgroup itself and then produces its descriptive/model analyses.
2. For the separate full-pipeline SAS route, establish the approved WRDS session first, then execute the remote FUNDA/COMPANY filters, join and deduplication, download cpstfirms, client filter and Stata export in the source order.
3. Do not run the SAS program as a producer of the Stata analysis input: the supplied Stata do-file opens CMSW_WB_final.dta directly and never reads cpstfirms1.dta.
4. Do not claim reproduction of the Compustat FF12 comparison panels until the missing sample rule and FF12 summary consumer are supplied.

Validation to perform later:

- After a future authorized execution, confirm Stata analyses against the paper/datasheet table map and separately reconcile the SAS Compustat output and FF12 category totals; execution remains unverified until then.


## Remaining issues and prerequisites

- ISS_FILE_CASE [preparation; full_pipeline, analysis_only]: On Linux the packaged file is named CMSW_WB_final.dta while the Stata source requests cmsw_wb_final. A supported one-line basename correction in a working copy is routine setup preparation; the mismatch is not an unresolved scientific or repair blocker.
- ISS_STATA_PACKAGES [preparation; full_pipeline, analysis_only]: The program calls winsor, outreg2 and psacalc and issues net install commands for all three. winsor is found; outreg2 and psacalc are not found in the checked ado path. The package versions are not pinned by the code, and an unmodified run may attempt online installs.
- ISS_SAS_RUNTIME [unresolved; full_pipeline]: The assigned startup probe failed during TKELS initialization, so a working SAS run is not verified. The companion source uses a Display Manager command and SIGNON with USERNAME=_PROMPT_, which require a compatible SAS launch context and a credential prompt. This does not establish a missing SAS license.
- ISS_WRDS_INCLUDE [unresolved; full_pipeline]: Inside RSUBMIT, the SAS program includes !SASROOT/wrdslib.sas. That remote include is not in the package and its availability/version on the authors’ WRDS server is not verified. The remote include must be distinguished from a local package file.
- ISS_SAS_SAMPLE [unresolved; full_pipeline]: SAS comments describe selecting the first year of a violation, but the supplied program filters COMP.FUNDA years, sorts with NODUPKEY only by GVKEY, and does not read or join violation data. The intended one-row-per-company rule and link to the described violation sample therefore remain unresolved; do not infer chronology or reconstruct the sample.
- ISS_SAS_FF12 [unresolved; full_pipeline]: The SAS companion exports cpstfirms1.dta with SIC/SIC_N but supplies no FF12 mapping or Compustat industry-count aggregation. The Stata do-file tabulates ff12 from the action-level analysis dataset and never loads cpstfirms1.dta. The author-documented Compustat counts for Table 2 Panel C and Appendix Table A1 Panel C lack a supplied consumer/mapping stage.
- ISS_SAS_OUTPUT [preparation; full_pipeline]: The SAS program exports cpstfirms1.dta to a hard-coded Windows Dropbox path. The assigned environment is Linux, and no Linux output destination or downstream consumer path is specified.
- REQ_COMP_FUNDA [undetermined]: Annual Compustat fundamentals read by the separate SAS comparison program, requiring GVKEY, DATADATE, FYEAR, AT, SALE, NI, INDFMT, DATAFMT, POPSRC, CONSOL and CURCD. The code filters source observations to FYEAR 1979–2014 before later client-side selection.
- REQ_COMP_COMPANY [undetermined]: The WRDS Compustat company lookup read by SAS to append SIC using GVKEY.
- SW_OUTREG2 [preparation_required]: The Stata program invokes outreg2 for table3 and table5 exports; the checked ado path does not contain the command.
- SW_PSACALC [preparation_required]: The Stata program invokes psacalc for Oster sensitivity analyses; the checked ado path does not contain the command. The code comments refer to a December 2016 version, but no installed version was found.
- SW_SAS [unverified]: The machine lists a SAS executable, but the assigned bounded startup probe stopped during TKELS initialization before confirming a working runtime. This is not evidence that a SAS license is absent.
- SW_SAS_CONNECT [unverified]: The SAS companion uses SIGNON and RSUBMIT to connect to WRDS. A working SAS/CONNECT session, author-approved credentials and remote server setup are not verified.
- SW_SAS_ACCESS [unverified]: The SAS program uses PROC EXPORT DBMS=STATA. The required SAS/ACCESS PC Files capability is not verified in the assigned SAS environment; official SAS documentation describes the format support and interface license requirement.

## Review notes

- The packaged CMSW_WB_final.dta is the author-designated underlying analysis data. Historical OSHA FOIA and proprietary enforcement-action sources in the datasheet describe data provenance; they are not additional live inputs to the supplied Stata analysis program.
- The Stata testgroup program is defined in the supplied do-file. It is not a missing user-written add-on.
- The current packaged DTA metadata probe read one row for columns and reports a catalog observation count of 1,133; the datasheet and Appendix describe 1,133 actions from 1978–2012. This supports the supplied analysis-data route but does not revalidate every record value.
- A prior pyreadstat.read_sas7bdat(metadataonly=True) call on the exact local COMP.FUNDA (7,258,374,144 bytes) and COMP.COMPANY (173,408,256 bytes) files had no explicit row or byte bound or proven bounded header method. The returned field names do not establish year coverage, history, or source-vintage compatibility; no row values were returned.
- The SAS branch order is explicit: remote COMP.FUNDA and COMP.COMPANY are filtered into WORK.CDATA_RAW and WORK.COMPANY; PROC SQL joins by GVKEY; PROC SORT NODUPKEY creates the remote joined table; PROC DOWNLOAD creates client WORK.CPSTFIRMS; a client-side filter and coercion precede PROC EXPORT. The supplied Stata do-file does not load cpstfirms1.dta.
- The SAS source comments mention a first violation year, but no violation data are read or joined in the supplied SAS program. The exact GVKEY selection rule and the missing FF12 table handoff remain unresolved; no independent reconstruction is proposed.
- The SAS chained filter 1979 <= fyear <= 2012 is a valid fully bounded range condition in SAS; it is not treated as a defect.
- The existing SAS environment probe failed at TKELS initialization. No further SAS startup troubleshooting was performed, and the failure is not treated as proof that SAS entitlement or a license is absent.
- The Stata add-on probes find winsor and do not find outreg2 or psacalc in the checked path. No author program was executed and no package was installed.
- For CAL002, ISS_FILE_CASE is classified as preparation because the supported repair is one line: change the Stata data basename at line 12 to match the packaged capitalization in a working copy. This preserves the data, variables, analyses, and scientific definitions.
- This generation uses the current frozen header and current packaged-data/environment probe hashes. Prior accepted files remain read-only context; earlier add-on and Compustat metadata probe bytes were copied unchanged into this generation. No new resource checks or author-code execution were performed.
- The supplied Stata lines list net-install sources for winsor, outreg2 and psacalc; the current Stata 18 probes find winsor but not outreg2 or psacalc. Their absence requires routine package/path preparation. The source does not pin a release, and no specific Stata 18 incompatibility is evidenced, so version recording and later authorized validation do not require an author-approval gate.
