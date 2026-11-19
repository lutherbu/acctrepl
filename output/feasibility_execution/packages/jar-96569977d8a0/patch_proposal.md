# Patch proposal: jar-96569977d8a0

Personal Financial Distress, Limited Attention and Sell-Side Analysts

DOI: 10.1111/1475-679X.12409

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Supplied SAS workflow embedded in Code.pdf, including identifier linking, CRSP/13F/Compustat joins, main and interaction regressions, and the two-iteration randomization appendix branch. Code.pdf is a program container requiring extraction/reflow and setup; it is not itself a directly executable standalone driver.

Entry points: `Code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12409 - Personal-Financial-Distress-Limited-Attention-and-Sell-Side-Analysts/aslan-datasheet-and-code.zip",
      "sha256": "fcdd18cc6f2aa645d0d457f2d22ff8c0277f5781293a811c0cbcebb9cdd3945c"
    },
    {
      "path": "JAR-Volume 60/Issue 1/12409 - Personal-Financial-Distress-Limited-Attention-and-Sell-Side-Analysts/aslan-online-appendix.pdf",
      "sha256": "890b732de51bcd3b0b6f3c82ecf9228d1d618fdbb89afcf0bcd9f2524880f666"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "c0b7e8ae378a865d7e2dde5960c6f9e9ef4f5e19ed7635778929d9d0d33ac785"
}
```

## Proposed actions

### action-acquire-prepared-tables: Obtain or identify compatible author-prepared input tables for the named mylib/inst consumers while retaining their separate schemas and exact table roles.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req-idsum, req-stocknames, req-varset, req-s34type1, req-s34type3, req-mycompq, req-gvkeyperm, req-analysts, iss-prepared-inputs
Evidence: src-librefs, src-idlink, src-stocknames-fields, src-varset, src-13f, src-compustat, src-analysts, src-datasheet-origins

Preparation / proposed procedure:

1. Provide compatible prepared tables for mylib.idsum, mylib.stocknames, mylib.varset, inst.s34type1, inst.s34type3, mylib.mycompq, mylib.gvkeyperm, and mylib.analysts; these are distinct supplied-code consumers and no compatible prepared data files are in the package.
2. Place the selected inputs under the corresponding mylib/ and inst/ run libraries after configuring writable working directories; preserve their original table names or document a direct alias in the working copy.
3. For each table, record the consumed fields, key, period and construction metadata from its actual prepared schema. Keep CoreLogic/property/profile/census provenance as conditional construction context when the compatible prepared analyst table is available; do not add those raw origins as mandatory extra inputs.

Validation to perform later:

- Before any author-code run, check the delivered table schemas against each route's expected_fields and confirm date/identifier coverage for the 2005–2009 workflow and any required pre-period reporter history.
- Confirm that mylib.mycompq actually provides the source names FYEAR and YRQTR or preserve the corresponding unresolved mapping issue; do not silently substitute FYEARQ.
- Confirm that inst.s34type1 and inst.s34type3 remain separately mapped to filing-level and holdings roles, and that the analyst table keys are ANALYSTID/YRQTR.

### action-verify-local-candidates: Assess the exact catalog-listed local candidates as alternative routes to prepared inputs, preserving the author-prepared route where local history, product compatibility or transformation is not established.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req-stocknames, req-crsp-msf, req-crsp-msenames-direct, req-s34type1, req-s34type3, req-mycompq, req-gvkeyperm, iss-compustat-contract, iss-tfn-table-mapping
Evidence: catalog-resources, probe-crsp-msenames, probe-crsp-msf, probe-comp-fundq, probe-ccm-link, probe-tfn-s34, inspection-catalog-commands, src-compustat, src-13f

Preparation / proposed procedure:

1. For CRSP.MSENAMES and CRSP.MSF, confirm required date/population coverage, source product and identifiers for the authored joins; use the catalogued paths and keep CRSP.MSENAMES available under the direct crsp.msenames reference.
2. For CRSP.CCMXPF_LINKTABLE, confirm link-date coverage and the authored linktype/linkprim selection before mapping it to mylib.gvkeyperm.
3. For COMP.FUNDQ, preserve the observed FYEARQ field and resolve the author FYEAR and YRQTR contract from supported prepared-source documentation before any field mapping.
4. For TFN.S34, resolve readable access through an allowed bounded metadata check and document how the combined table maps to s34type1 and s34type3, including typecode and reporter history; the timed-out probe does not establish absence or an access barrier.
5. Use CRSP.MSENAMES as a stocknames alternative only after confirming the same required effective-date/name history and identifier coverage.

Validation to perform later:

- A bounded readable file/column result alone does not verify date or population coverage; retain each route as unverified until its source product, fields, key and required history are supported.
- Do not infer FYEAR/YRQTR construction, 13F table splitting, ownership units or security-history completeness from catalog field names.

### action-recover-crspm-source: Resolve the missing external crspm.sas producer and its actual interface before relying on the generated monthly CRSP table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-crspm-source
Evidence: src-crspm, src-crsp-derive

Preparation / proposed procedure:

1. Identify the exact author-supplied crspm.sas source and its documented dependencies/namespace; do not substitute an unverified routine.
2. Confirm that its supported interface accepts the supplied monthly MSF/MSENAMES variable lists, SHRCd filter, 2005–2009 dates and output name mylib.crsp_m.
3. Retain the complete recovered macro file and its provenance in the working project; do not create a standalone source or hash from Code.pdf extraction.

Validation to perform later:

- Before use, compare the macro's documented input/output contract with the exact call and downstream fields in src-crspm and src-crsp-derive.
- Keep this source-closure issue unresolved until the producer and namespace are actually available and compatible.

### action-resolve-clustr-binding: Confirm the intended primary/interaction macro binding for the supplied %clustr calls before preparing a runnable working copy.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-macro-name
Evidence: src-macro-definitions, src-clust3-definition, src-primary-analysis-calls, src-interaction-analysis-calls, src-randomization

Preparation / proposed procedure:

1. Confirm whether the primary and interaction spelling %clustr is intended to bind to the supplied %macro clstr or to another author macro/alias.
2. Preserve the supplied %macro clust3 definition and the randomization macro's explicit %clstr calls while resolving the primary/interaction binding; do not add a guessed alias or silently rename calls.
3. Once the author-supported binding is established, apply only that supported name repair to the reflowed working copy and preserve the original Code.pdf.

Validation to perform later:

- Statically check that every primary, interaction and randomization call resolves to a supplied or recovered macro definition and retains its original arguments.
- Keep the binding unresolved until the author-supported namespace is known.

### action-configure-working-copy: Reflow the PDF-embedded SAS program into a working source file and configure coherent relative author-library roots plus the direct CRSP name-history libref.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss-path-configuration, iss-crsp-library-binding
Evidence: src-librefs, src-crspm, src-13f, probe-crsp-msenames, catalog-resources

Preparation / proposed procedure:

1. Extract and reflow Code.pdf to a new working .sas file under an analysis/ run directory; preserve Code.pdf and record that the original program was embedded in a PDF container.
2. Use analysis/ as the working directory, bind MYLIB to a writable ./mylib run directory and INST to ./inst, and place the recovered external macro under ./macros after its source is obtained.
3. In the reflowed working copy only, replace the Windows library roots with the relative run paths and normalize the curly-quoted include to an ASCII-quoted relative path such as %INCLUDE "macros/crspm.sas"; keep the binary PDF unchanged.
4. Bind CRSP to ${ACCTREPL_SAS_ROOT}/crsp/a_stock for the direct CRSP.MSENAMES query, subject to host path visibility; do not assume this establishes the unknown external crspm macro's own library contract.
5. Keep the COMP.CCMXPF_LINKTABLE candidate's ${ACCTREPL_SAS_ROOT}/crsp/a_ccm path separate when preparing mylib.gvkeyperm; the CRSP.MSENAMES/MSF directory does not contain that separate library file.

Validation to perform later:

- Before a future separately authorized run, verify the relative working directories exist and MYLIB is writable, INST is readable, the CRSP.MSENAMES path resolves, and the recovered include path resolves.
- Statically check all affected libname and include references after reflow; do not patch Code.pdf or insert absolute Dropbox workspace paths.

### action-fix-randomization-fields: Apply the two source-supported field fixes in the reflowed randomization working copy so the sort key and the later fixed-effect/cluster variables survive the generated tables.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss-randomization-fields
Evidence: src-randomization, src-panel-join-sequence, public-keep-option-doc

Preparation / proposed procedure:

1. In the PROC SORT input KEEP= list at the supplied randomization block, retain the existing variables and add RAND: KEEP=ANALYSTZIP ANALYSTID YRQTR RAND, because RAND is generated immediately above and used in BY ANALYSTZIP RAND.
2. In the final&i SELECT of the reflowed copy, add a.GVKEY and a.EMPCBSA to the selected columns so final1/final2 contain the variables passed to cluster=GVKEY ANALYSTID and fe=EMPCBSA YRQTR in regression(2).
3. Leave the random assignment, shuffle keys, downstream DROP RAND, source order and original Code.pdf unchanged.

Validation to perform later:

- Statically verify RAND is available to PROC SORT's BY statement and remains dropped after the shuffled merge.
- Statically verify final1/final2 expose GVKEY and EMPCBSA with the names consumed by the later regression calls; do not run a trial regression.

### action-confirm-sas-runtime: Confirm the existing SAS runtime and SAS/STAT component availability through approved local metadata before any separately authorized execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw-sas, sw-sasstat
Evidence: probe-environment, src-surveyreg, public-surveyreg-doc

Preparation / proposed procedure:

1. Use the approved SAS version/which/help or installed-component metadata checks to confirm the configured runtime without launching the author program; record the prior TKELS initialization failure as runtime unverified, not as a license denial.
2. Confirm SAS/STAT availability for the active PROC SURVEYREG path in the supplied CLUST3 macro; do not add SAS/ETS as an active dependency solely for the dormant instruments branch.
3. If the existing runtime or required component is not available, arrange an approved compatible local runtime/component before a separate run; do not install packages or infer entitlement from a startup error.

Validation to perform later:

- Record the exact tool/metadata result and version/component status; no author-code startup, compilation, syntax trial or estimation belongs in this assessment.
- Keep SAS/STAT unverified until the component itself is confirmed, even though official documentation identifies PROC SURVEYREG.

### action-ordered-run-procedure: Once all required inputs, source bindings and working-copy corrections are resolved, follow the supplied producer-consumer order and retain every active primary, interaction and randomization branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: req-idsum, req-stocknames, req-varset, req-crsp-msf, req-crsp-msenames-direct, req-s34type1, req-s34type3, req-mycompq, req-gvkeyperm, req-analysts, iss-prepared-inputs, iss-crspm-source, iss-macro-name, iss-randomization-fields, iss-path-configuration, iss-crsp-library-binding, iss-compustat-contract, iss-tfn-table-mapping
Evidence: src-idlink, src-ibes-fallback, src-varset, src-crspm, src-crsp-derive, src-13f, src-ownership-to-io, src-compustat, src-panel-join-sequence, src-primary-analysis-calls, src-interaction-analysis-calls, src-interaction-owner-calls, src-interaction-analysis-calls-final, src-randomization, src-append-call, src-clstr-ols-branch, src-clstr-iv-branch, src-proc-reg-syslin

Preparation / proposed procedure:

1. From mylib.idsum and mylib.stocknames, build the supplied identifier-link products using the CUSIP path and the OFTIC/ticker fallback; merge the resulting mylib.idlink with mylib.varset on PERMNO and the authored score condition to produce all1.
2. Use the recovered external %crspm routine with the documented CRSP monthly inputs to produce mylib.crsp_m; follow the supplied CRSP normalization to quarter-end, adjusted price/shares/market capitalization and the quarter-end CRSP work table.
3. From inst.s34type1, build first_vint reporter flags/counts; join inst.s34type3 into holdings_v1, map historical CUSIP through crsp.msenames into holdings_v2, join to quarter-end CRSP to make holdings, aggregate io_metrics, and merge with CRSP to produce io/ior. Retain the earlier reporter history the first/last logic consumes.
4. Run the supplied WIN macro on mylib.mycompq to create mycompqw and winsorize ATQ/LTQ/CEQQ before the FYEAR 2005–2009 and format filters; join through mylib.gvkeyperm to make all2, join all2 with all1 to create all3 and BM, join ownership io to create all4, and join mylib.analysts on ANALYSTID/YRQTR to create all5.
5. After the author-supported macro name binding is resolved, execute the eight supplied primary %clustr calls on all5, then create all5_int from the five housing interactions and retain all ten paired errors/bias interaction calls.
6. Retain the supplied randomization sequence after the main/interaction source block: %randsamp(2) produces final1/final2, %regression(2) estimates those outputs, and %append(2) assembles them. Preserve the supplied two-iteration, unseeded behavior exactly.
7. Keep the generic instruments branch present as supplied. The provided selected calls use the empty-instruments path; do not add separate IV data or active SAS/ETS dependencies without an actual selected call.

Validation to perform later:

- Before any separately authorized execution, statically trace each producer's output names and keys into the next consumer, including all1, mylib.crsp_m/crsp_m, holdings/io, all2 through all5, all5_int and final1/final2.
- Resolve the unavailable CRSP macro, the direct CRSP libref, the %clustr binding, the Compustat field contract, 13F type mapping, missing prepared inputs and SAS/STAT runtime status before treating the pipeline as runnable.
- Do not execute, compile, import, syntax-test or estimate the author program as part of this assessment.


## Remaining issues and prerequisites

- iss-prepared-inputs [unresolved; full_pipeline]: The code expects prepared SAS tables in the mylib and inst libraries (including analyst, stock/forecast, quarterly Compustat, identifier-link, and two 13F tables), but the package inventory contains only the datasheet PDF, Code.pdf, and online appendix PDF. Their exact fields and history are being derived from the supplied consumers; no compatible prepared-data file is included.
- iss-crspm-source [unresolved; full_pipeline]: The supplied PDF calls an external crspm.sas routine at a Windows path and invokes it to create mylib.crsp_m; that routine and its interface/source closure are not included. The original PDF page 4 was inspected: the extracted INCLUDE statement uses a curly opening quote, so any normalization/path change must be made in a working copy after reflow, not to the PDF binary.
- iss-macro-name [unresolved; full_pipeline]: The supplied definition is %macro clstr, which calls the supplied %macro clust3, while the primary and interaction calls are spelled %clustr. The randomization regression macro calls %clstr. No alias or definition for clustr appears in Code.pdf; confirm the intended primary/interaction macro binding before a working-copy repair.
- iss-randomization-fields [preparation; full_pipeline]: Two concrete field omissions are supported by the supplied source: RAND is absent from the input KEEP= list but used in BY, and final&i omits GVKEY and EMPCBSA even though regression(2) requests them as clusters and fixed effects. In a reflowed working copy, add RAND to the KEEP list and add a.gvkey and a.empcbsa to the final SELECT; these variables are already present in all5/nround. Keep the original PDF unchanged.
- iss-path-configuration [preparation; full_pipeline]: Code.pdf embeds a SAS source program with Windows absolute library roots for mylib and inst and a curly-quoted Windows include path. The program needs extraction/reflow and a working-copy configuration with writable output roots; the original PDF must remain unchanged.
- iss-crsp-library-binding [preparation; full_pipeline]: Code.pdf directly queries crsp.msenames but declares only MYLIB and INST. The selected CRSP.MSENAMES candidate is locally readable at ${ACCTREPL_SAS_ROOT}/crsp/a_stock; bind CRSP to that directory in the working configuration. This is routine setup. Historical coverage remains an unverified data-route condition, and the separate external crspm macro/interface remains an unresolved source-closure issue.
- iss-compustat-contract [unresolved; full_pipeline]: The local COMP.FUNDQ candidate exposes FYEARQ and the bounded schema sample does not expose YRQTR, while the author-prepared mycompq consumer filters on FYEAR and uses YRQTR. Confirm a compatible prepared-table contract or source-supported field/quarter mapping before treating the local candidate as equivalent.
- iss-tfn-table-mapping [unresolved; full_pipeline]: The local TFN.S34 candidate is a combined raw table; the one-row read timed out, and the supplied consumers expect separate s34type1 filing and s34type3 holdings tables. Their split/typecode mapping and full pre-2005 reporter history are not verified.
- req-idsum [undetermined]: Author-prepared IBES identifier summary consumed by the supplied identifier-link builder; the code uses ticker, CUSIP, company name, security dates, fallback ticker and US-firm flag.
- req-stocknames [undetermined]: Name-history table consumed for ticker/CUSIP identifier linking, with PERMNO, company/security names and effective dates.
- req-varset [undetermined]: Author-prepared stock-quarter analyst/firms control table joined to idlink by PERMNO and YRQTR and reused in the combined analysis table.
- req-crsp-msf [undetermined]: CRSP monthly security series underlying the external crspm routine that produces the supplied workflow's quarterly-normalized CRSP output.
- req-crsp-msenames-direct [undetermined]: CRSP security-name history used both for the external %crspm call's NCUSIP/EXCHCD/SHRCD security fields and for the direct CUSIP-to-PERMNO mapping in the 13F ownership join, separate from the named mylib.stocknames prepared-table consumer.
- req-s34type1 [undetermined]: Prepared 13F filing-level table used to construct first/last reporter status and manager counts.
- req-s34type3 [undetermined]: Prepared 13F holdings table merged to filing-level reporters by FDATE and MGRNO, then mapped to CRSP PERMNO by historical CUSIP.
- req-mycompq [undetermined]: Author-prepared quarterly Compustat table winsorized and filtered before joining to the dated gvkey-PERMNO crosswalk; the supplied consumer expects YRQTR and FYEAR as well as the financial and format fields.
- req-gvkeyperm [undetermined]: Dated gvkey-to-PERMNO link table used to join quarterly Compustat records to the CRSP/idlink panel under link-type and primary-link filters.
- req-analysts [undetermined]: Author-prepared analyst-quarter outcomes, housing controls, analyst characteristics and employer/geography keys merged into all5 and used by the supplied main, interaction and randomization regressions.
- sw-sas [unverified]: Code.pdf is SAS source. The documented local SAS startup ended in a TKELS initialization failure, so runtime availability/version for this assessment is unverified; the failure is not evidence of a missing license.
- sw-sasstat [unverified]: The supplied CLSTR macro calls CLUST3, which invokes PROC SURVEYREG on its empty-instruments branch; the supplied primary call spelling %clustr remains unresolved. Official documentation identifies the SAS/STAT procedure, but component availability locally is unverified.

## Review notes

- Code.pdf was read through all 1,786 cached lines. Its native SAS ID-linking, CRSP, 13F, Compustat, analyst-panel, primary, interaction and randomization branches were reviewed despite zero checklist IDs in the static audit. Original PDF pages 4, 30 and 31 were rendered to verify the INCLUDE glyph and macro spellings.
- The exact registered catalog was used for bounded one-row CRSP, Compustat and CCM link probes. The local TFN.S34 one-row probe timed out at 15 seconds and remains unverified; this is not evidence of absence or entitlement denial. Historical coverage, prepared-table contracts and source mappings remain unverified where specified by the routes/issues.
- Randomization fidelity context: the supplied code calls randsamp(2), regression(2), and append(2) with unseeded RAND; the online appendix describes 10,000 iterations. This selected scope follows the supplied code count and behavior; the paper-side discrepancy is recorded without requiring clarification or changing the count/seed.
- No author program was executed, imported, compiled, syntax-tested or estimated. The SAS startup TKELS failure leaves runtime/component status unverified and is not interpreted as license denial. The output is a static proposal; no execution is certified.
