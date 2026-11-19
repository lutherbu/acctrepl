# Patch proposal: jar-48794c55446c

IRS Attention

DOI: 10.1111/1475-679X.12154

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete documented author workflow for IRS Attention: EDGAR and Compustat preparation, SAS dataset construction, the separately described Tables 5–6 process, Stata regressions and the documented appendix analyses.

Entry points: `BHTW_2016_07_15_JAR.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 1/12154 - IRS-Attention/bhtw-data-description-and-code.zip",
      "sha256": "356c39e91864445ae5b92c9ce9def4dbf2daed16e7092fc6022832616d92091d"
    },
    {
      "path": "JAR-Volume 55/Issue 1/12154 - IRS-Attention/bhtw-online-appendix_final.pdf",
      "sha256": "a4da1dbedb4ca33c42f4a6db84fbb65f825a3ba1ffe51bd0a17c316cfd28858b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "c2acea8d58262afb85387a54cf6087d712735c8d54a5cb1b92c3c643af17c503"
}
```

## Proposed actions

### A-RAW-SEC: Acquire only the documented public SEC source records after the author-selected periods and required files are confirmed.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-SEC-LOGS, R-SEC-INDEX, R-SEC-10K
Evidence: EV10, EV35, EV36, EV37, EV38

Preparation / proposed procedure:

1. Use the official SEC older EDGAR log dataset for the target 2003–2015 years; follow current SEC fair-access guidance and retain its documented completeness limitations.
2. Obtain SEC full/quarterly index files for the same period to link accessions to filing form, CIK, date and file path.
3. Obtain author-required 10-K documents from the SEC archive after the author selection is confirmed; SEC archive history is public from 1994/1995 onward, while author-specific extraction remains separate.

Validation to perform later:

- Confirm selected daily logs and index files cover the author-stated years and retain any SEC-reported gaps.
- Check log fields against the official older-log variable list and index form/CIK/date/file mapping before any later authorized join.
- Do not treat public annual IRS counts as event-level EDGAR logs or tax-text data.

### A-EDGAR-PRODUCER: Request the prepared EDGAR tables or complete author-side producer contracts, and conditionally assess the author’s exact-study IRS Attention data request route without assuming it supplies the event-level panel.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-EDGAR-PANEL, R-FIRM-LIST, I-DATA-CLOSURE, I-EDGAR-PRODUCER, S-ARIN-WHOIS
Evidence: EV01, EV02, EV03, EV06, EV27, EV35, EV36, EV39, EV40, EV41, EV42

Preparation / proposed procedure:

1. Request `data1.edgar_2003_2015_all` and `data1.firms_in_edgar_final`, or the exact SAS/Perl scripts, configuration and prepared ARIN/government-IP mapping that produce them.
2. Clarify the panel schema and population for CIK, accession, log date, filing type and government-download flags; identify the producer for the firm list described as firms downloaded by anyone.
3. Provide the DATA1 library assignment and any required autoexec/setup without exposing credentials in the package. SEC-published annual download totals are not a substitute for the event-level tables.
4. If the intended use is non-commercial and a prepared author dataset could address a missing input, consider the embedded author form, which requests name, workplace, and email; do not assume its delivery is event-level data or submit it during this assessment.
5. If any data are later received, inspect the files and schema and verify period, observation unit, fields, identifier keys, and joins before considering them compatible with data1.edgar_2003_2015_all or any other missing input.

Validation to perform later:

- Use bounded metadata to confirm output fields and period; document how file type, CIK and download date join to the author firm list.
- After separate execution authorization, compare the produced panel and firm list to the authors’ documented keys and sample counts.
- Treat annual IRS-download counts as a distinct output unless the delivered data demonstrate the event-level CIK/accession/date/filing mapping required by the SAS panel; verify that this route does not substitute for tax-footnote or other workflow inputs.

### A-COMP1: Confirm the exact author Compustat panel contract before using the local Funda candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-COMP1
Evidence: EV04, EV05, EV28, EV29

Preparation / proposed procedure:

1. Request the prepared `data1.comp1` file or its exact Compustat export specification, including the required fields, CIK/year history and company geography/name variables.
2. Resolve whether `state`, `incorp` and `lengthm3` come from an additional author-prepared source or a documented construction step; the current COMP.FUNDA candidate alone does not contain these fields.
3. Keep the local Funda candidate conditional until its CIK/fyear coverage and equivalence to the author’s August 2015 source are confirmed.

Validation to perform later:

- Read bounded metadata for the exact input and confirm all fields consumed by the SAS code, keys and fyear coverage before an authorized run.

### A-TEXT-INPUTS: Request author-prepared text inputs or the exact programs and specifications that produce them.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-TAX-DISCLOSURE, R-TENK-LENGTH, R-TEXT-SIMILARITY, I-TEXT-PRODUCER
Evidence: EV07, EV08, EV09, EV10, EV11, EV12, EV13, EV32, EV33, EV34, EV39

Preparation / proposed procedure:

1. Request the prepared `data1.tax_footnote_disclosure`, `data1.tenk_all` and `data1.TFN_SimPairs_final` tables, or the Perl source/configuration and exact schemas used to create them.
2. Document tax-footnote headings/XBRL fallback, cleaning and date/file keys; specify the `tenklength` definition and the paired-file keys/settings for `SimScore`.
3. The documented local SEC and LM roots were checked only at their root. Verify exact filing paths, section coverage, period and cleaning against the author recipe before using either corpus; do not substitute automatically.

Validation to perform later:

- Check bounded metadata for exact fields (`words`, `numbers`, `file`, `fog`; `file`, `tenklength`; `file1`, `SimScore`), keys and history.
- After separate authorization, verify each text input is produced before the SAS joins at lines 248–270 and paired files follow the author design.

### A-TEXT-SOFTWARE: Resolve author-specified Perl text modules and Mallet version/invocation in the future analysis environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-LINGUA-FATHOM, S-ALGORITHM-VSM, S-MALLET
Evidence: EV13, EV31

Preparation / proposed procedure:

1. Ask the authors for compatible versions and invocation details for Lingua::Fathom, Algorithm::VSM and Mallet.
2. After authorized environment setup, configure only the documented packages; this assessment did not install anything.
3. For Mallet, confirm the executable or jar path and support for the documented LDA stage; a PATH miss alone does not rule out an unconfigured package.

Validation to perform later:

- Run bounded version/module-availability checks in the designated environment and record versions before any author text/LDA program is run.

### A-ANALYSIS-CODE: Request missing companion analyses and map each documented output to its producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-ANALYSIS-CODE
Evidence: EV13, EV14, EV25, EV26, EV39

Preparation / proposed procedure:

1. Request Stata regression programs, the separate Tables 5–6 preparation/analysis files and their exact inputs/outputs.
2. Map appendix Tables A1–A12 and Figures A1–A6 to supporting scripts and data, including any LDA/Mallet stage.
3. Preserve the supplied SAS program as the Tables 2–4 dataset constructor; do not assume it alone reproduces all paper and appendix results.

Validation to perform later:

- Review supplied code headers and output targets to confirm every documented table/figure and required input is accounted for before later authorized execution.

### A-LIBREFS: Obtain the author SAS library and setup contract without inventing local paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-LIBREFS, I-DATA-CLOSURE
Evidence: EV03, EV05, EV07, EV17, EV24, EV39

Preparation / proposed procedure:

1. Request exact DATA1 and DATA libref assignments, storage locations, any autoexec/include, and the expected location for DATA1.BHTW20160602.
2. Clarify the `comp` libref context used inside RSUBMIT separately; the source does not establish that it maps to the local SAS catalog.

Validation to perform later:

- After receiving setup details, confirm each library resolves to the expected input/output member names using read-only metadata checks.

### A-REMOTE-DTA: Resolve the remote Compustat stage and SAS runtime/session configuration.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-COMP-DTA-DTL, I-REMOTE-SETUP, S-SAS, S-SAS-CONNECT
Evidence: EV15, EV16, EV17, EV18, EV28, EV30

Preparation / proposed procedure:

1. Request the authorized remote SAS/CONNECT session and COMP.FUNDA library details, including source period and setup; do not include credentials in the assessment.
2. Ask whether catalog-listed local COMP.FUNDA can serve the exact filters and 1994+ history; the bounded sample is insufficient to establish this.
3. Resolve the existing SAS startup/TKELS error through the environment owner and confirm runtime availability without inferring a missing license.

Validation to perform later:

- Before any later run, verify source fields and fyear coverage, then confirm the remote producer creates WORK.DTASANDDTLS before PROC DOWNLOAD creates DATA.DTASANDDTLS and the local join consumes it.

### A-WINSOR: Obtain the exact `%winsor` macro dependency and source/version.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-WINSOR-MACRO, S-WINSOR
Evidence: EV19, EV39

Preparation / proposed procedure:

1. Request the author macro source or documented macro catalog/include path and confirm it implements the supplied 1st/99th percentile call.
2. Do not replace it with a different Stata winsor package or guessed SAS macro.

Validation to perform later:

- After the exact dependency is available, inspect its version and confirm the output variables/ranges before any separately authorized execution.

### A-FFINDL: Obtain the format catalog/source required by the FFINDL. conversion.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-FFINDL-FORMAT, S-FFINDL
Evidence: EV20, EV39

Preparation / proposed procedure:

1. Request the author-provided FFINDL. definition or exact SAS format catalog and library assignment that defines it.
2. Do not replace the industry mapping with an assumed format.

Validation to perform later:

- Confirm the requested format is available in the future SAS session and inspect its mappings before creating the industry field.

### A-SAMPLE-LOGIC: Clarify two sample-selection expressions before proposing any source change.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-SAMPLE-SPEC
Evidence: EV21, EV22, EV23

Preparation / proposed procedure:

1. Ask whether the lagged CIK condition was intended to compare the prior row CIK with the current row CIK; the supplied expression compares `lag(cik1)` with itself.
2. Ask whether the later `drop="notcorp"` test is intended to match the earlier `drop="noncorp"` values; do not silently change the category spelling.
3. Keep any source edit conditional until the author confirms intended sample rules and affected observations.

Validation to perform later:

- After author clarification and separate execution authorization, compare row classifications, period coverage and sample counts with author-provided target outputs.


## Remaining issues and prerequisites

- I-DATA-CLOSURE [unresolved; full_pipeline]: The supplied SAS entry point reads several unprovided DATA1 tables and writes its output to DATA1; the packaged CIK workbook is an identifier list, not a full analysis panel. Required DATA1/DATA librefs and compatible prepared-input routes are not defined in the source.
- I-EDGAR-PRODUCER [unresolved; full_pipeline]: Author documentation describes EDGAR log conversion, government/IP filtering and index joining, but the Perl/SAS processing files and ARIN whois output mapping are absent; the immediate DATA1 event-panel producer cannot be traced.
- I-TEXT-PRODUCER [unresolved; full_pipeline]: The package lacks the author programs/schema needed to create the tax-footnote, 10-K length and similarity inputs. Local SEC and LM corpus roots exist, but only their root paths were checked; compatible filings, sections, years and cleaning were not verified.
- I-ANALYSIS-CODE [unresolved; full_pipeline]: The data description identifies the SAS file as the Tables 2–4 constructor and says Stata performs regression analysis; Tables 5–6 are separately described. The package contains no Stata program or separate Table 5–6 entry point, and the appendix lists additional tables/figures without a matching supplied analysis script.
- I-LIBREFS [unresolved; full_pipeline]: DATA1 and DATA librefs are used by the supplied SAS program but not assigned there; no assigned library setup/autoexec is included in the package.
- I-REMOTE-SETUP [unresolved; full_pipeline]: The code uses RSUBMIT, remote COMP.FUNDA and PROC DOWNLOAD without providing remote-session or library configuration. The current local Funda file is only a conditional candidate because required coverage and equivalence are not established.
- I-WINSOR-MACRO [unresolved; full_pipeline]: The supplied SAS code invokes `%winsor` at the 1st and 99th percentiles, but its macro source/location is not included.
- I-FFINDL-FORMAT [unresolved; full_pipeline]: The supplied SAS code calls the FFINDL. format, but its format catalog/source is not included.
- I-SAMPLE-SPEC [unresolved; full_pipeline]: Two source expressions have unclear intended sample logic: the lagged CIK expression is compared with itself, and the code sets `drop="noncorp"` while a later filter checks `drop="notcorp"`. Do not infer replacements because either change can alter sample selection.
- R-EDGAR-PANEL [undetermined]: Prepared event-level `data1.edgar_2003_2015_all` input panel consumed by SAS, with CIK, filing type, log date and accession/document mapping.
- R-SEC-LOGS [public_acquisition_required]: SEC EDGAR request logs for 2003–2015 that author preprocessing used to construct the event panel.
- R-SEC-INDEX [public_acquisition_required]: SEC EDGAR filing indexes used to map accessions to filing type, CIK and filing dates for the author panel.
- R-COMP1 [undetermined]: Author-prepared Compustat `data1.comp1` annual panel with accounting variables and firm identifiers/geography used by the main SAS program.
- R-FIRM-LIST [undetermined]: Prepared `data1.firms_in_edgar_final` CIK list required by the SAS merge; the code says it includes firms downloaded by anyone, but its producer and exact coverage are not specified.
- R-TAX-DISCLOSURE [undetermined]: Prepared `data1.tax_footnote_disclosure` input with `words`, `numbers`, `file` and `fog` measures keyed to the SAS panel.
- R-TENK-LENGTH [undetermined]: Prepared `data1.tenk_all` dataset with `file` and `tenklength` required by the core SAS join.
- R-TEXT-SIMILARITY [undetermined]: Prepared `data1.TFN_SimPairs_final` with `file1` and `SimScore` required by the SAS panel.
- R-COMP-DTA-DTL [undetermined]: Compustat Funda source rows used remotely to create `net_dta`/`net_dtl` for fyear 1994 onward under the code filters.
- R-SEC-10K [public_acquisition_required]: Public SEC 10-K filing text used as an upstream source by the authors; SEC archive history is available from 1994/1995 onward, while the author-selected sample and cleaning remain to be specified.
- S-SAS [unverified]: SAS is required, but the existing bounded startup probe failed at the TKELS extension. It does not establish a missing license or the runtime’s final availability.
- S-LINGUA-FATHOM [preparation_required]: The documented Perl readability module was not found by the bounded module probe.
- S-ALGORITHM-VSM [preparation_required]: The documented Perl similarity module was not found by the bounded module probe.
- S-MALLET [unverified]: Mallet is documented for LDA, but a `mallet` executable was not found on PATH; no broader package search was performed and version/invocation are unspecified.
- S-ARIN-WHOIS [unverified]: The data description identifies a proprietary query program but does not supply its exact name/version, program or output mapping.
- S-SAS-CONNECT [unverified]: The RSUBMIT/PROC DOWNLOAD stage depends on an established remote SAS session and library routes; connection details are not provided.
- S-WINSOR [unverified]: The invoked macro is not included or located in the package; external availability is unknown.
- S-FFINDL [unverified]: The invoked format is not included or located in the package; external format-catalog availability is unknown.

## Review notes

- Assessment is limited to the assigned package variant and its frozen source snapshot. Local SEC/LM probes checked only documented root existence, not contents or coverage.
- No author code, regressions, downloads, installations, data extraction, patches or publishing were performed.
- The author form is only a candidate prepared-data route. Its output unit, schema and delivery/coverage are unverified; the annual IRS-download counts are not treated as event-level EDGAR logs, prepared SAS panel inputs, tax-footnote data, or a full-analysis substitute. The form was not submitted and no files were downloaded.
