# Patch proposal: jar-e6cee8c6ce4c

Offshore Shared Services Center Usage by U.S. Big 4 Audit Engagement Teams

DOI: 10.1111/1475-679X.12611

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | restricted_access_required | no_runnable_code |

### full_pipeline

Complete documented empirical data-to-analysis workflow for constructing offshore shared-services engagement measures and producing the study analyses. The supplied release is a data-description PDF with no executable code, analysis dataset, theory model, numeric calibration or embedded manual program workflow.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12611 - Offshore-Shared-Services-Center-Usage-by-U-S-Big-4-Audit-Engagement-Teams/sherwood-datasheet.pdf",
      "sha256": "547dbb5a5a5fc0ad6a7beb8b084cab0ac3cedaa603d058482150150372c8ec7f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "5c69f0693f848035ce1070f1ca983319c97c6dbea32121bf97eccc26f343754a"
}
```

## Proposed actions

### ACT_PCAOB_ACCESS: Establish the permitted PCAOB fellowship or permission-based route for the exact AFR and inspection-finding inputs used by this study.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_PCAOB_AFR, REQ_PCAOB_PARTI
Evidence: E_PCAOB_ACCESS, E_METHOD, E_PARTI_RULE, E_CATALOG_PCAOB, E_FROZEN_CATALOG

Preparation / proposed procedure:

1. Confirm whether the PCAOB fellowship route is available for this replication and identify its on-site IT requirements.
2. Obtain the author-used PCAOB-provided input bundle or a compatible author-prepared release through an authorized route.
3. Record the actual input inventory, engagement identifiers, inspection years, fields and relation to the published analysis variables.

Validation to perform later:

- After authorized access, compare the supplied PCAOB source fields, engagement keys and inspection-year coverage with the documented SSC and Part I roles; do not infer completeness from the datasheet alone.

### ACT_COMMERCIAL_INPUTS: Check local catalog candidates and current WRDS entitlement for the specifically named Compustat and Audit Analytics products, then establish their source-field and period mapping.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_COMP_FUNA, REQ_AA_OPINIONS, REQ_AA_RESTATEMENTS, REQ_AA_FEES, REQ_AA_CONTROLS, REQ_AA_ENGAGEMENT
Evidence: E_PUBLIC_PRODUCTS, E_VARS_A, E_VARS_B, E_SP_COMPUSTAT, E_WRDS_LICENSE, E_AA_MODULES, E_AA_PRICING, E_CATALOG_COMP, E_CATALOG_AA, E_CATALOG_AA_VARIABLES, E_FROZEN_CATALOG

Preparation / proposed procedure:

1. Confirm permitted WRDS/S&P and Audit Analytics entitlement for each required product; official product pages describe licensed or separately sold access.
2. Use the frozen metadata candidates only as leads: COMP.FUNDA, FEED03 audit fees, FEED34 revised opinions, FEED39 restatements and FEED11 internal controls remain unverified inputs.
3. Recover the author-used raw tables, complete source fields, identifiers, filters and study years for each target variable before acquiring or treating any candidate as compatible.
4. Acquire the required named products through an authorized route only after the full input contract is established.

Validation to perform later:

- Reconcile all consumed fields, identifiers, product roles and complete study-period coverage with the recovered author code or full variable definitions; catalog matches and sampled presence do not establish closure.

### ACT_PUBLIC_FILINGS: Verify official Form AP and Form 10-K source routes and recover the exact identifiers, filing selection and construction used for PRT_CLT_DIST.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_PCAOB_FORM_AP, REQ_SEC_10K
Evidence: E_FORM_AP_10K, E_PCAOB_FORM_AP_GUIDANCE, E_PCAOB_FORM_AP_SEARCH, E_SEC_EDGAR, E_TRANSFORM, E_CATALOG_SEC, E_SEC_CORPORA, E_SRAF_10X, E_FROZEN_CATALOG

Preparation / proposed procedure:

1. Use official PCAOB and SEC documentation to identify the public Form AP and 10-K sources; those sources establish access, not the author's required fields or compatible records.
2. Recover the Form AP and Form 10-K source fields, issuer/auditor identity rule, filing selection and time window for PRT_CLT_DIST from the author materials.
3. After the input contract is known, stage only the needed records through the public filing routes; treat local SEC corpus paths as candidates, noting that Stage One 10-X parsing excludes tables.

Validation to perform later:

- Verify that the selected Form AP and Form 10-K records cover the same auditor-client observations and period required by the supplied definition.

### ACT_GET_PROGRAMS: Obtain the retained author/PCAOB programs, logs, driver order and declared software dependencies before attempting the documented full pipeline.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_NO_PROGRAMS
Evidence: E_PROGRAMS, E_METHOD

Preparation / proposed procedure:

1. Request the actual conversion and analysis program files and their documented launch sequence through the permitted PCAOB fellowship/permission process.
2. Ask for the software/runtime and add-on list, required working directories and identities of each generated or consumed intermediate.
3. Stage any authorized copy in a separate working directory; preserve the as-downloaded package.

Validation to perform later:

- After the missing programs are obtained, trace every input and producer-to-consumer handoff before selecting runnable entry points.

### ACT_GET_DEFINITIONS: Recover the missing study-specific input contract, period and calculation definitions before treating any named source route as compatible.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_WORKFLOW_DETAILS
Evidence: E_METHOD, E_TRANSFORM, E_VARS_A, E_VARS_B, E_FORM_AP_10K, E_CATALOG_AA_VARIABLES, E_AA_MODULES

Preparation / proposed procedure:

1. Obtain the referenced Appendix B, exact sample period, complete source columns, merge keys, filters and order of the author workflow.
2. Map every target variable to its raw fields, product/table, identifier, period and transformation, including all Audit Analytics roles and the Form AP/Form 10-K link for PRT_CLT_DIST.
3. Separate author-prepared PCAOB data from any genuinely reconstructed input and identify each supplied intermediate or directly provided field.

Validation to perform later:

- Reconcile the recovered definitions against the author programs and authorized data inputs before marking closure complete.


## Remaining issues and prerequisites

- ISS_NO_PROGRAMS [unresolved; full_pipeline]: The assigned package contains only a data-description PDF. The author states the conversion/analysis programs and logs are proprietary to PCAOB and may be accessed through the fellowship or with permission; no runnable code or entry point is supplied in this release.
- ISS_WORKFLOW_DETAILS [unresolved; full_pipeline]: The datasheet provides source families and selected target-variable definitions but omits exact raw files/columns, product/table mapping for several Audit Analytics variables, join keys, sample years, complete producer order and the calculations referenced in absent Appendix B. The supplied PDF contains no separate analytical/theory model, numerical calibration, embedded author program or executable manual workflow.
- REQ_PCAOB_AFR [restricted_access_required]: PCAOB annual firm review data for the Big 4 and study inspection years, including the engagement-level inputs used to construct SSC measures and other directly supplied PCAOB variables. Exact files, columns, join keys and sample years are not specified in this PDF.
- REQ_PCAOB_PARTI [restricted_access_required]: PCAOB inspection findings needed to construct the Part I finding indicator for engagements that were reviewed. Exact fields, engagement matching keys and period are not supplied.
- REQ_COMP_FUNA [undetermined]: Compustat Fundamentals Annual observations used to construct the listed client financial characteristics. Appendix A gives target variables but not underlying input columns, identifiers or sample dates.
- REQ_AA_OPINIONS [undetermined]: Audit Analytics inputs for GC (going-concern) and audit opinion roles. The datasheet names Audit Opinions as a source family and maps GC to Audit Analytics, but does not identify the exact table, raw field, identifier, period or author table selection.
- REQ_AA_RESTATEMENTS [undetermined]: Audit Analytics Restatements data used for RESTATE; exact table/fields, identifiers and period are not supplied.
- REQ_PCAOB_FORM_AP [undetermined]: PCAOB Form AP audit-firm data used with client Form 10-K data to construct PRT_CLT_DIST; the exact fields, linking rule, population and period are not supplied.
- REQ_SEC_10K [undetermined]: SEC Form 10-K client-firm data jointly used with PCAOB Form AP to construct PRT_CLT_DIST; the exact identity fields, filing selection and matching rule are not supplied.
- REQ_AA_FEES [undetermined]: Audit Analytics inputs used to calculate AUDITFEES. The target variable is documented, but raw source columns, currency/fee selection, identifiers, period and table role are unspecified.
- REQ_AA_CONTROLS [undetermined]: Audit Analytics inputs used to calculate WEAKNESS. The datasheet does not specify the raw control-deficiency fields, aggregation, identifiers, period or exact module/table.
- REQ_AA_ENGAGEMENT [undetermined]: Audit Analytics inputs for BUSY, AUD_TENURE, INDSPE, CLIENTIMP and FEE_RATIO. Appendix A identifies these target variables and source family, but not the module/table, raw fields, definitions, identifiers, years or author extraction.

## Review notes

- The full supplied data-description text was read after screening its connected-block masking. It documents an empirical data construction and analysis target, but no separate analytical/theory model, numerical calibration, embedded author program, or standalone executable manual workflow. The author says PCAOB retains the proprietary conversion/analysis programs and logs; no executable or manual substitute is in this package.
- The author names PCAOB AFR and nonpublic inspection findings as required sources; bounded local catalog queries did not identify those exact proprietary inputs. Their fellowship/permission and PCAOB IT restrictions remain an access barrier. The official public Form AP and SEC EDGAR routes do not supply the full unpublished PCAOB engagement inputs.
- The author names Compustat and Audit Analytics products. Official product evidence indicates commercial/licensed access. Frozen metadata contains unverified candidates, including COMP.FUNDA and Audit Analytics fee, revised-opinion, restatement and internal-control records. Only candidate metadata was inspected; no dataset payload or rows were read.
- The data sheet's Appendix A target variables were represented separately by source role: Compustat, PCAOB AFR, PCAOB inspection findings, Audit Analytics opinions, restatements, fees, controls, engagement characteristics, Form AP and Form 10-K. Exact raw fields, periods, joins, formulas and producer/consumer order remain incomplete.
- SEC filing corpora paths are supported by exact workspace documentation. Stage One 10-X parsing documentation says tables are excluded. All filing/corpus paths remain unverified for the author's required client data and PRT_CLT_DIST construction.
- No software requirement is specified in the author material. No author code, imports, compiles, model runs, statistical trials, or dataset payload reads were performed. Execution readiness and data-route resolution remain for the pinned finalizer to compute.
