# Patch proposal: jar-d0a9413cb33a

The JOBS Act and the Costs of Going Public

DOI: 10.1111/1475-679X.12172

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Recreate the author-documented IPO sample and reproduce the paper and online-appendix analyses.

Entry points: `JOBS_Act_Code_JAR.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 4/12172 - The-JOBS-Act-and-the-Costs-of-Going-Public/chaplinksy-hanley-moon-datasheet-and-code.zip",
      "sha256": "1a95d54680bc3a042200b805787f9840e329c5f47320742fe63d55e4e85097aa"
    },
    {
      "path": "JAR-Volume 55/Issue 4/12172 - The-JOBS-Act-and-the-Costs-of-Going-Public/chm-online-appendix.pdf",
      "sha256": "08aab83e707e1d85cda49388ae7945ef10b93b1d2d17127c96a4b934b5f4c190"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b339a0e3a03207a70703666926608174d29bcbef458afd4e10be2da7d4ad8255",
  "work_item_sha256": "3c3a64f52e8b64a69d4b5f5580b5d3d0d4ece87c0e4eb8eb42871275d3a63dd5"
}
```

## Proposed actions

### ACT-request-data-and-producers: Obtain the permitted inputs and the missing preparation/supplemental workflow needed to complete the author pipeline.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-final-sample, REQ-industry-MTB-PE, REQ-hightech-SIC, ISS-famafrench17, ISS-data-preparation, ISS-variable-producers, ISS-appendix-coverage, ISS-variable-spelling
Evidence: EV-author-final-sample-restriction, EV-datasheet-sources, EV-data-preparation, EV-code-inputs, EV-code-execution-path, EV-code-hightech-join, EV-appendix-residual-producer, EV-appendix-rd-log, EV-local-crsp, EV-local-compustat, EV-local-sdc, EV-sec-raw-location, EV-sec-parsed-location, EV-public-ritter-data, EV-code-variable-name, EV-code-table4-cost-regressions

Preparation / proposed procedure:

1. Request a lawfully shareable author-prepared analysis dataset, or the precise permitted raw-data inputs, complete producer program, and authorized field-level access route. The authors’ contract statement concerns redistribution of FINAL_SAMPLE.dta; do not infer that a user lacks a CRSP/Compustat license.
2. For the documented reconstruction route, confirm the exact SDC, SEC filing, CRSP/Yahoo, Compustat, CPI, and firm-age product versions, identifiers, periods, sample filters, transformations, and hand-collected fields. Treat the local probes and current Ritter workbook as candidates only until their paper-sample compatibility and the authors’ historical/manual supplements are established.
3. Request IND_MTB_FF17 and HIGHTECH files or complete documented producers, including join keys, data source, years/quarters, and SIC/high-tech coding rules. The local SDC HIGHTECH/SICP fields do not establish the do-file’s sic key mapping.
4. Request famafrench17.do and clarify where famafrench, indprc_earn17, hightech, dum_biopharma and lnproceeds_res are created or supplied, including whether lnproceeds_res is a FINAL_SAMPLE column or the omitted OA1 producer output.
5. Request the omitted code or exact specifications for OA1–OA3 and a complete table/figure-to-code map; in particular resolve OA2 Proceeds>125 interactions and the OA3 log-proceeds RD form.
6. Confirm whether wacctlegalpct in JOBS_Act_Code_JAR.do line 43 is a supplied FINAL_SAMPLE field or is intended to refer to acctlegalpct. Do not patch the token until the source field and intended test are confirmed.

Validation to perform later:

- After the inputs and producers are received, use bounded metadata probes to verify exact fields, keys, date periods and the stated IPO sample; confirm the SEC source covers the relevant S-1 and 10-K documents and the authors’ first-1,000-word screening method.
- Trace every consumed variable to a supplied field or producer in stage order, including famafrench17, IND_MTB_FF17, HIGHTECH and the OA1 residual-proceeds output.
- Compare the visible main and appendix specifications with a complete table/figure map before any separately authorized execution.

### ACT-setup-stata-addons: Set up the two Stata user-written commands required by the supplied do-file and missing from the checked default ado path.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-psmatch2, SW-DCdensity
Evidence: EV-code-psmatch, EV-code-dcdensity, EV-software-psmatch2, EV-software-dcdensity, EV-public-psmatch2, EV-public-dcdensity

Preparation / proposed procedure:

1. After authorized setup, install the Leuven–Sianesi psmatch2 module from SSC (the repository lists `ssc install psmatch2`) or use its linked repository files; preserve the paper’s supplied psmatch2 invocation.
2. Obtain Justin McCrary’s author-hosted DCdensity.ado and place it in a user ado directory on the active Stata adopath. Its author page lists a 2009 update, so confirm compatibility with Stata 18 and any required companion files.
3. Do not install packages or execute the author do-file as part of this assessment.

Validation to perform later:

- In the intended Stata 18 environment, verify `which psmatch2` and `which DCdensity`, inspect their help/dependencies, and only proceed to separately authorized author-code execution after data and producer gaps are closed.


## Remaining issues and prerequisites

- ISS-famafrench17 [unresolved; full_pipeline]: The do-file calls famafrench17.do to recreate the Fama-French 17 industry classification used before matching, but that producer is absent from the package. It is unresolved whether the file is available from another documented route and whether it also supplies variables needed later.
- ISS-data-preparation [unresolved; full_pipeline]: The datasheet describes S-1 screening, commercial sources, hand collection and sample filters, while the supplied do-file begins from FINAL_SAMPLE.dta. The direct author file is withheld under contract and no complete raw-to-analysis producer is supplied. Local CRSP/Compustat/SDC probes and SEC directory checks are candidate evidence only; sample/identifier/section coverage and transformation compatibility remain unknown.
- ISS-variable-producers [unresolved; full_pipeline]: IND_MTB_FF17 and HIGHTECH are mandatory code inputs with no supplied files or complete producers. The do-file also consumes famafrench, indprc_earn17, hightech, dum_biopharma and lnproceeds_res; the available package does not establish whether these arrive as FINAL_SAMPLE fields or from omitted producer stages. Appendix OA1 describes a residual-log-proceeds producer, but no such producer is visible in the supplied do-file.
- ISS-appendix-coverage [unresolved; full_pipeline]: The supplied do-file covers named main-paper tables and figures but does not label the appendix analyses. OA1 specifies a residual-log-proceeds regression whose output is consumed but not visibly produced; OA2 includes Proceeds>125 interactions whose exact match to the supplied Table 4 regressions is unresolved; OA3 uses log proceeds in the RD specification while the visible pre/post RD blocks construct dollar proceeds minus 75. Request the missing or mapping workflow before claiming complete appendix coverage.
- ISS-variable-spelling [unresolved; full_pipeline]: The Table 2 t-test requests wacctlegalpct, while adjacent Table 2 summary/median commands and Table 4 use acctlegalpct. Because FINAL_SAMPLE.dta is absent, it is unknown whether both columns exist or whether the t-test token is a source typo; do not change it without the exact dataset schema or author clarification.
- REQ-final-sample [undetermined]: The author-prepared IPO analysis dataset consumed repeatedly as FINAL_SAMPLE.dta, or a documented, authorized route to construct a compatible equivalent. It must support the paper and appendix analyses; its exact columns and compatibility have not been verified.
- REQ-industry-MTB-PE [undetermined]: The code joins the required IND_MTB_FF17 dataset by famafrench, year and quarter and consumes its industry P/E field indprc_earn17 for the propensity-score matching analysis.
- REQ-hightech-SIC [undetermined]: The code joins HIGHTECH by SIC for Table 7 and uses the resulting hightech classification; the package does not identify the file’s source or producer.
- SW-psmatch2 [preparation_required]: Required for propensity-score matching. The Stata 18 probe did not find the command in the default ado path; the RePEc/SSC record identifies a public GPL-licensed distribution. Install/configure it and confirm Stata 18 compatibility before any author execution.
- SW-DCdensity [preparation_required]: Required for the McCrary density figure. The Stata 18 probe did not find the command in the default ado path; Justin McCrary’s author page lists DCdensity.ado. Obtain/configure it and confirm Stata 18 compatibility before any author execution.

## Review notes

- The full pipeline is the only supported scope. The supplied Stata program is present, but its required FINAL_SAMPLE.dta, IND_MTB_FF17, HIGHTECH and famafrench17.do closure is incomplete; no compatible supplied analysis-only dataset supports a second scope.
- The authors state that their direct FINAL_SAMPLE.dta file is not redistributed under CRSP/Compustat contract terms. This is a barrier to that delivery route only; it does not establish that a local user lacks the relevant license or that all alternatives are blocked.
- Local CRSP, Compustat and SDC candidates were read only through one-row probes, and SEC root checks verified directory existence only. None establishes sample/period coverage, exact product compatibility or a complete author-data construction route.
- Two required Stata user-written commands were not found by the helper probes; public distribution pages support setup as a future preparation task, while Stata 18 compatibility remains to be checked. No software was installed and no author code or regressions were run.
- The online appendix remains in scope. OA1–OA3 are not fully mapped to the supplied main do-file; residual proceeds, OA2 interactions and the log-proceeds RD specification remain unresolved.
