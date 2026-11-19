# Patch proposal: jar-16dd898e7ece

Textual Analysis in Accounting and Finance: A Survey

DOI: 10.1111/1475-679X.12123

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The package contains only a data policy datasheet, which documents the author-defined three-stage full data-construction workflow: raw SEC 10-K parsing, a non-GAAP flag, then filtering and matching with Compustat and CRSP. Those source inputs are required for the documented rebuild. The author-posted 66,707-observation final sample is the Stage Three output/reference, not a second mandatory input. The package contains no executable program; Stage Three matching details and the paper analyses remain incomplete.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 4/12123 - Textual-Analysis-in-Accounting-and-Finance-A-Survey/loughran-mcdonald-datasheet.pdf",
      "sha256": "f95b8f5f749f2f09fc52368ec3ac2a98b76bca238262d6533692cf0da67fb185"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "22dc345933514a562db5598dac979324d402a64ae8f8dff5bbc48c4e1e4a13e9"
}
```

## Proposed actions

### action_verify_sec: Use the verified author-listed raw SEC archive for the documented filing source stage, and resolve whether the local post-Stage-One Loughran–McDonald corpus is functionally compatible if it is considered as a shortcut.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_sec_filings, issue_filing_history
Evidence: doc_period, doc_dates, doc_stage1, doc_stage1_tables, public_raw_archive, public_clean_archive, public_stage1_docs, local_lm_inventory, local_lm_prefix

Preparation / proposed procedure:

1. For the raw-rebuild route, acquire the required 1994–2011 10-K form family from the author-listed SEC 10-X archive, then apply the datasheet’s Stage One cleaning sequence followed by the Stage Two case-insensitive non-GAAP flag. The route does not depend on historic download timestamps or identical source bytes.
2. Treat the bounded local ${ACCTREPL_LM10X} corpus as prepared Stage One text, not raw input. If considering it to bypass Stage One, confirm its form/date roster and functional treatment of markup, graphics, XBRL, tables, headers, exhibits and text normalization against the datasheet; otherwise retain the documented raw-source route.

Validation to perform later:

- Confirm that the required filing forms and years are covered and that Stage One/Two follow the documented functional operations. If the local prepared corpus is considered, establish roster and cleaning compatibility without requiring byte identity. The 66,707-observation author sample may serve as an optional Stage Three output reference after permitted acquisition, not a concurrent required input.

### action_clarify_stage3: Resolve the Compustat and CRSP inputs and matching specification needed to construct the documented Stage Three output; retain the author-posted final sample as an output/reference.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: req_compustat, req_crsp, issue_stage3_inputs
Evidence: doc_stage3, local_catalog_candidates

Preparation / proposed procedure:

1. Ask the authors for the Compustat and CRSP products/releases, required variables, firm and filing identifiers, date ranges, sample filters and join rules, and clarify how the Loughran–McDonald (2014) sample is used.
2. Treat COMP.FUNDA, CRSP.MSF/MSF_V2 and CCMXPF_LINKTABLE as catalog candidates only; verify exact fields, history and readable files against the author specification before use.
3. Use LM_2016_nonGAAP.dta only as the publicly posted Stage Three/Table 1 sample reference or output check; do not require both that output and the raw construction inputs as mandatory data acquisitions.

Validation to perform later:

- After specifications and inputs are obtained, verify identifiers, coverage, filters and joins against the author’s 66,707-observation sample construction; retain unknown fields or construction rules as unresolved until supported.

### action_request_workflow: Request the paper-specific executable programs or a complete documented manual workflow, including the analyses and outputs supported by the final sample.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_code_missing, issue_stage3_inputs
Evidence: doc_stages, doc_stage1, doc_stage2, doc_stage3, audit_no_code, public_code_listing

Preparation / proposed procedure:

1. Request original source programs, operating instructions, file order and the analysis entry points for every reported table and figure, or the complete no-code/manual procedure if no executable programs exist.
2. Ask the authors to identify all paper-specific analysis entry points and the outputs supported by the posted Table 1 final sample; treat it as a prepared output/reference unless a documented analysis workflow establishes a supported input route.

Validation to perform later:

- Review the supplied workflow’s producer-consumer order and full input/output closure before assigning readiness or adding any separate analysis scope.


## Remaining issues and prerequisites

- issue_code_missing [unresolved; full_pipeline]: No executable program is included in the package. The datasheet provides a documented manual sequence for parsing filings, flagging non-GAAP text, and constructing a filtered/matched sample, but it does not provide the paper’s actual processing or analysis programs. The current SRAF Code page lists an EDGAR download helper and general textual-analysis programs, not verified code for this sample or its reported analyses.
- issue_filing_history [unresolved; full_pipeline]: A bounded inventory found local Loughran–McDonald files for all 72 quarters from 1994Q1 through 2011Q4, and two fixed-file prefixes show post-Stage-One-style FileStats and SEC headers. This supports a local prepared-text candidate, but not collection-wide form/date roster completeness or functional equivalence to the datasheet’s detailed cleaning rules. The author-listed raw SEC archive is a supported source route; exact historic download timestamps or original-byte identity are not prerequisites. Treat the local corpus as a possible Stage One bypass only after its functional compatibility is established.
- issue_stage3_inputs [unresolved; full_pipeline]: For the documented full rebuild, Stage Three filters the SEC material using the Loughran and McDonald (2014) sample and matches firms to Compustat and CRSP, but the datasheet omits the exact products, fields, identifiers, date windows, join rules and sample criteria. The author-posted LM_2016_nonGAAP.dta is identified as the final sample for Table 1 and is credited as the Stage Three output/reference; it is not an additional mandatory input alongside the raw-source rebuild. Its schema and broader analysis coverage were not inspected.
- req_sec_filings [public_acquisition_required]: Raw SEC EDGAR 10-K, 10-K405, 10KSB and 10KSB40 filing material for 1994–2011, required for the documented full rebuild. The datasheet specifies the Stage One cleaning and Stage Two non-GAAP flag; later download timestamps and byte-identical historic copies are not required.
- req_compustat [undetermined]: Compustat data used for the Stage 3 firm matching and sample filters. The datasheet does not identify the Compustat product, fields, identifiers, date window, or transformation.
- req_crsp [undetermined]: CRSP data used for the Stage 3 firm matching and sample filters. The datasheet does not identify the CRSP product, fields, identifiers, date window, or transformation.

## Review notes

- The supplied datasheet defines a manual three-stage full data-construction workflow, so the full rebuild requires SEC filings for Stages One and Two plus Compustat and CRSP inputs for Stage Three. No executable program is supplied, and the specific Stage Three matching and analysis programs remain absent.
- The author-posted LM_2016_nonGAAP.dta is identified as the final sample for Table 1 (66,707 observations). It is the Stage Three output/reference, not a second mandatory input alongside raw SEC, Compustat and CRSP. No analysis-only scope was added because no supplied analysis entry program supports that route.
- The SRAF raw 10-X archive supports the required SEC source family and years. Historic download timestamps and original-byte identity are not prerequisites. Local Loughran–McDonald files are a post-Stage-One candidate; their population coverage and functional cleaning/roster compatibility remain unverified. No data were downloaded or author programs executed.
