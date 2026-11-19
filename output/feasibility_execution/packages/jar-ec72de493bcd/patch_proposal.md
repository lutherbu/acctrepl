# Patch proposal: jar-ec72de493bcd

Earnings Management During Antidumping Investigations in Europe: Sample-Wide and Cross-Sectional Evidence

DOI: 10.1111/1475-679X.12166

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented Orbis/CD and manual antidumping-data construction, matched firm/event panel preparation, winsorization and Stata analysis. Only EU Code.sas and a non-analysis GVKEY sample are supplied.

Entry points: `EU Code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 2/12166 - Earnings-Management-During-Antidumping-Investigations-in-Europe-Sample-Wide-and-Cross-Sectional-Evidence/godsell-et-al.zip",
      "sha256": "9d5371980df246c35e94510297fb0e6600cf2a858e0e4c7414760ab10a6e4bb7"
    },
    {
      "path": "JAR-Volume 55/Issue 2/12166 - Earnings-Management-During-Antidumping-Investigations-in-Europe-Sample-Wide-and-Cross-Sectional-Evidence/welker-online-appendix.pdf",
      "sha256": "27b8e2f667d5f54e3bf7807f8cedc96161419362d7c2ff0a21138d006e19bec7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "277af284c550fd013b9db57f72e8c6e5b1fdbd8a3ee6fec3b77b0c68d66babe8"
}
```

## Proposed actions

### A_ACCESS: Confirm an authorized route for Orbis web/CD histories and status data. The documented no-assignment clause blocks author transfer but does not establish whether a separate subscription is available.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_WEB, R_CD, R_STATUS
Evidence: E_TERMS, E_WEB, E_CD, E_STATUS, E_WEBSTATUS

Preparation / proposed procedure:

1. Confirm independent Orbis entitlement for 2013-era/dead-firm historical data and required fields/years.
2. If unavailable, request a legally distributable prepared panel or authorized access route; do not rely on assignment of proprietary author files.

Validation to perform later:

- Verify permissions, history, yearly fields, identifiers, units and 1993–2012 panel coverage.

### A_DICT: Obtain the authorized BvD oldid/newid dictionary and identify the WORK.DICTIONARY producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DICT
Evidence: E_CROSSWALK, E_CD

Preparation / proposed procedure:

1. Request file/schema and clarify whether the ORBIS dictionary is an input or imported from another stage.

Validation to perform later:

- Verify old/new IDs cover changed CD/web identifiers.

### A_MISSING_TABLES: Resolve exact inputs/producers for datebase, EUID, year and WORK.dictionary before running the pipeline.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DATE, R_EUID, R_YEAR, I_UNPRODUCED
Evidence: E_DATEBASE, E_PRETRANS, E_EUID, E_YEAR, E_CROSSWALK

Preparation / proposed procedure:

1. Request the exact files or active producer instructions and intended stage order.
2. Confirm whether the commented fdate block remains the datebase producer.

Validation to perform later:

- Confirm every table is created before its first read and matches join keys/periods.

### A_CASE_MATCH: Obtain compatible case, duty, BvD candidate-match and manually revised files, plus BvD software/version and manual review records.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CASE, R_MASTER, R_RAWMATCH, R_MANUALMATCH, S_BVD, I_MANUAL
Evidence: E_CASE, E_MATCH, E_MANUAL, E_DUTY

Preparation / proposed procedure:

1. Request author-prepared files and field lineage.
2. Confirm the BvD matching software route and preserve documented manual quality/product checks.
3. Clarify how the September 2013 GAD and EU reports map into `master7`.

Validation to perform later:

- Verify case/date/product/country/firm keys and duty/match fields before the joins.

### A_MANUAL_CASE: Obtain author-collected distance and exporter-share files and recipes; retain manual procedures.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DISTANCE, R_SHARE
Evidence: E_DISTANCE, E_DUTY, E_DISTANCE_CODE, E_SHARE_CODE

Preparation / proposed procedure:

1. Request checked case-level inputs and document multiple-plaintiff aggregation and injury-share definitions.
2. Do not independently recreate manual values.

Validation to perform later:

- Check holisticdist and exporters_pct fields and case keys.

### A_PUBLIC_CASE: Treat the current official World Bank case database as a related public lead, not a verified replacement for the authors’ 2013 GAD/master file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MASTER
Evidence: E_PUB_GAD, E_GAD, E_DUTY

Preparation / proposed procedure:

1. In a future authorized step, verify case IDs, EU coverage, duty/margin fields and vintage; otherwise obtain the authors’ authorized prepared master inputs.

Validation to perform later:

- Confirm `case_id`, duty and margin field compatibility before use.

### A_COW: Use COW v3.0 as an unverified public route until coverage and the bilateral2 transformation are checked.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COW
Evidence: E_PUB_COW, E_COW, E_BILATERAL_CODE

Preparation / proposed procedure:

1. Acquire exact v3.0 only in a future authorized step and inspect its codebook; no download occurred.
2. Verify 1992–2012 event coverage; v3.0 ends in 2007, so request author-compatible continuation if needed rather than substituting v4.0.
3. Confirm country-code/export-share construction into bilateral2.

Validation to perform later:

- Verify case/year/country/proportion fields and event-year coverage.

### A_WGI: Use current WGI only as a partial public route until author vintage, field mapping and early-year coverage are resolved.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WGI
Evidence: E_PUB_WGI, E_WGI_CODE

Preparation / proposed procedure:

1. Check regulatory-quality estimate and convert country/year keys only after the author file schema is confirmed.
2. Resolve 1992–1995, before current catalog coverage starts in 1996.

Validation to perform later:

- Verify iso2/year/regquality and full required years.

### A_CONTEXT: Request source, vintage, rights, fields and period for the remaining context panels.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LAPORTA, R_OVERHAUL, R_IPO, R_TRADEFREE, R_GDP
Evidence: E_LAPORTA_CODE, E_CONTEXT_CODE, E_APPENDIX

Preparation / proposed procedure:

1. Obtain author-prepared panels or exact source/field mappings; clarify GDP vintage used by pseudo-event analyses.
2. Do not infer source products from filenames.

Validation to perform later:

- Verify country/firm keys, annual coverage and required columns.

### A_ENFORCEMENT: Request enforcement and EU-fraction input schemas and resolve WORK versus ORBIS enforcement-score handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AUDIT, R_ENFORCE, R_TOTAL, R_ENFORCESCORE, R_ENFSCORE, R_EUFRACTION, I_ENFORCE_HANDOFF
Evidence: E_BROWN_CODE, E_ENF_LOCAL, E_ENF_EXTERNAL, E_EUFRACTION

Preparation / proposed procedure:

1. Obtain author-prepared panels and source/vintage definitions.
2. Clarify whether WORK.ENFORCESCORE is intended to be saved/read or an earlier ORBIS file is required.

Validation to perform later:

- Verify ISO/year keys, score definitions, 1992–2012 coverage and production order.

### A_RETURNS: Keep the data-source attribution to Worldscope distinct from the `capiq` library label; test catalog hits only as discovery leads.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RETURNS
Evidence: E_RETURNS, E_COW, E_CATALOG

Preparation / proposed procedure:

1. Confirm the exact Worldscope vintage, security/country/industry mapping and author indret30 construction.
2. Obtain prepared indret30 or specified producer; no catalog source-data probe/download was performed.

Validation to perform later:

- Verify iso2/fyear/FF30 medret/medexret and required history before joining.

### A_MACROS: Obtain the nine external SAS helper files or their authorized portable paths/versions.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_MACROS
Evidence: E_INCLUDE, E_WINSOR, E_ACCRUALS

Preparation / proposed procedure:

1. Request all `%include` files; clarify whether included but uncalled helpers are part of the intended branch.

Validation to perform later:

- Confirm all includes resolve and called macros provide matching behavior.

### A_SAS: Confirm SAS 9.3/9.4 runtime and needed procedures; existing TKELS failure does not prove absent license.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: S_SAS, I_SAS_RUNTIME
Evidence: E_SAS93, E_ENV, E_ACCRUALS, E_EXPORT

Preparation / proposed procedure:

1. Resolve startup issue with environment owner and verify PROC EXPAND/export support before future execution.

Validation to perform later:

- Run a future authorized empty startup/version probe; do not run author code during this assessment.

### A_EXCEL: Confirm Excel 2013 access or obtain exact author-prepared outputs and manual recipe.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: S_EXCEL, I_MANUAL
Evidence: E_README, E_MANUAL_PREP

Preparation / proposed procedure:

1. Request workbook outputs and steps for CD renaming, Orbis inspection and match review.

Validation to perform later:

- Verify outputs and expected fields before SAS ingestion.

### A_STATA: Request missing Stata regression and table scripts for the main paper and online appendix A1–A15.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STATA_CODE
Evidence: E_STATA, E_EXPORT, E_SUMMARIES, E_APPENDIX, E_INVENTORY

Preparation / proposed procedure:

1. Obtain all main and independent appendix entry points, Stata commands/add-ons/versions, and mapping to reported tables.

Validation to perform later:

- Map each reported table to code, data fields, estimator/sample restrictions and output.

### A_HANDOFF_EDITS: Propose source-name repairs only after author confirmation; none were applied.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I_HANDOFF
Evidence: E_PRETRANS, E_PRECALL, E_AFTERWRITE, E_ASSEMBLE, E_CROSSWALK

**Proposed edit:** `EU Code.sas:439–439`
Source SHA-256: `7083d187901f8dc96628bbe00be93a388d0e7314462b3213c37a4ad5425aceb7`

Use the WORK table just created unless the author confirms a separate checkpoint was intended.

Current text:
```
%getall (dsetin=orbis.pretranspose);
```

Proposed replacement:
```
%getall (dsetin=pretranspose);
```

**Proposed edit:** `EU Code.sas:761–761`
Source SHA-256: `7083d187901f8dc96628bbe00be93a388d0e7314462b3213c37a4ad5425aceb7`

Use the ORBIS table produced at line 442, subject to confirmation of the intended web-panel handoff.

Current text:
```
from orbis.aftertranspose;
```

Proposed replacement:
```
from orbis.aftertransposemore;
```

**Proposed edit:** `EU Code.sas:765–765`
Source SHA-256: `7083d187901f8dc96628bbe00be93a388d0e7314462b3213c37a4ad5425aceb7`

Use the ORBIS table produced at line 715, subject to confirming UPDATEDCDl is not a separate intended variant.

Current text:
```
from orbis.updatedCDl (where=(missing(datadate)=0));
```

Proposed replacement:
```
from orbis.updatedCD2 (where=(missing(datadate)=0));
```

Preparation / proposed procedure:

1. Confirm intended handoffs, then apply the proposed fragments and validate producer/consumer names.

Validation to perform later:

- Future authorized parse/run must verify table creation order and panel key/periods.

### A_COUNTRY_EDIT: Propose removing the duplicate comma before IE; no source change applied.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_COUNTRY_SYNTAX
Evidence: E_EU_FILTER

**Proposed edit:** `EU Code.sas:780–780`
Source SHA-256: `7083d187901f8dc96628bbe00be93a388d0e7314462b3213c37a4ad5425aceb7`

Line 779 already ends GR with a comma; remove the second comma before IE.

Current text:
```
, "IE", "IT", "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK", "SI", "ES", "SE", "GB") then 1 else 0 end as EU, a.standard
```

Proposed replacement:
```
"IE", "IT", "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK", "SI", "ES", "SE", "GB") then 1 else 0 end as EU, a.standard
```

Preparation / proposed procedure:

1. Apply the one-line comma correction after review.

Validation to perform later:

- Future authorized run should confirm the EU filter parses and selects the intended countries.


## Remaining issues and prerequisites

- I_MACROS [unresolved; full_pipeline]: Nine `%include` paths are external and absent from the package; some macros are called later and included files must resolve unless author confirms otherwise.
- I_SAS_RUNTIME [unresolved; full_pipeline]: SAS 9.3 is documented but the existing SAS 9.4 startup fails at TKELS; runtime/modules are unverified.
- I_MANUAL [unresolved; full_pipeline]: Excel inspection and manual Orbis cleaning, match review, duty, distance and retaliation work are documented but their workbooks/prepared outputs are absent.
- I_STATA_CODE [unresolved; full_pipeline]: SAS exports baseline and summaries, while the datasheet assigns regressions to Stata; no main regression or appendix A1–A15 code is supplied. No analysis-only path is supported by a one-row gvkey probe.
- I_HANDOFF [preparation; full_pipeline]: Source creates WORK.PRETRANSPOSE but reads ORBIS.PRETRANSPOSE, writes ORBIS.AFTERTRANSPOSEMORE but reads ORBIS.AFTERTRANSPOSE, and creates ORBIS.UPDATEDCD2 but reads ORBIS.UPDATEDCDl. Confirm intended handoffs before applying exact proposals.
- I_COUNTRY_SYNTAX [preparation; full_pipeline]: The active EU ISO list has adjacent commas between GR and IE; a one-character repair is proposed, unapplied.
- I_UNPRODUCED [unresolved; full_pipeline]: Active ORBIS.DATEBASE, ORBIS.EUID, ORBIS.YEAR and WORK.DICTIONARY reads lack active in-source producers; datebase producer block is commented.
- I_ENFORCE_HANDOFF [unresolved; full_pipeline]: Code builds WORK.ENFORCESCORE then later reads ORBIS.ENFORCESCORE; intended handoff is unresolved.
- R_WEB [undetermined]: 1,443 Orbis web extracts through 2012 with raw annual financial, firm, country, identifier and industry fields.
- R_CD [undetermined]: Historical Orbis CD firm-year financial and auxiliary data; documentation describes 1993–2002 while code loops over CD-year files 1988–2005.
- R_DICT [undetermined]: Old/new BvD identifier translation file.
- R_DATE [undetermined]: Closing-date panel needed to create annual web firm-year observations.
- R_STATUS [undetermined]: Orbis status extracts and prepared web-status data for public/private classification.
- R_CASE [undetermined]: Prepared EU antidumping case/filer panel used to align firms and investigation dates.
- R_MASTER [undetermined]: Case-level duties/injury margins joined by case_id.
- R_RAWMATCH [undetermined]: BvD software candidate match output.
- R_MANUALMATCH [undetermined]: Manually reviewed final match data.
- R_DISTANCE [undetermined]: Case-level hand-collected driving distances.
- R_SHARE [undetermined]: Case-level exporter share used in injury-duty partition.
- R_COW [undetermined]: Prepared case/year bilateral trade proportions for retaliation measure.
- R_LAPORTA [undetermined]: Author-labeled country institutional indicators.
- R_WGI [undetermined]: Author-prepared WGI regulatory-quality country-year file.
- R_OVERHAUL [undetermined]: Prepared firm public-status confirmation input.
- R_IPO [undetermined]: Firm IPO date and legal-form panel.
- R_TRADEFREE [undetermined]: Country-year tradefree input.
- R_GDP [undetermined]: Country-year GDP panel used in code and GDP pseudo-events.
- R_AUDIT [undetermined]: Country-year audit source panel used in Brown et al. enforcement-score processing.
- R_ENFORCE [undetermined]: Country-year enforce source panel used in Brown et al. enforcement-score processing.
- R_TOTAL [undetermined]: Country-year total source panel used in Brown et al. enforcement-score processing.
- R_ENFORCESCORE [undetermined]: Prepared ORBIS enforcement-score country-year file.
- R_ENFSCORE [undetermined]: Staff enforcement score panel.
- R_EUFRACTION [undetermined]: Prepared EU fraction panel.
- R_RETURNS [undetermined]: Author-prepared annual median excess returns from Worldscope; `capiq` is a libref location, not proof of source.
- R_EUID [undetermined]: EU country-ID map.
- R_YEAR [undetermined]: Year dimension for country-year enforcement panel.
- S_SAS [unverified]: SAS 9.3 is documented; the existing SAS 9.4 startup probe fails at TKELS, so runtime/module availability remains unknown, not presumed unlicensed.
- S_EXCEL [unverified]: Required for manual inspection/cleaning; exact environment availability not probed.
- S_BVD [unverified]: Used for candidate matches; software access/version and outputs are not supplied.

## Review notes

- Expanded draft saved after complete reading of the README, datasheet, all 1,820 SAS lines, appendix tables, existing probes, exact-name/source-product catalog lookups and bounded official pages. No author code, data downloads, installs or patches were run/applied.
- The packaged ids.sas7bdat probe reports one sampled `gvkey`, not a full analysis panel or verified identifier mapping; source renames BvDID to GVKEY. No analysis-only route is supported.
- COW v3.0 and current WGI/World Bank case pages are recorded as public candidates with unresolved version/coverage/field compatibility. Worldscope hits are raw catalog discovery candidates only; no field/history/readability probe was performed; capiq is only the code libref.
- Exact source edits are proposals only. Full closure remains unresolved pending author-prepared inputs, manual stages, helper files, handoff confirmation and Stata scripts.
