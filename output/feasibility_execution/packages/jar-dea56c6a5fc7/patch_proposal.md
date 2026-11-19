# Patch proposal: jar-dea56c6a5fc7

The Effect of Regulatory Harmonization on Cross-border Labor Migration: Evidence from the Accounting Profession

DOI: 10.1111/1475-679X.12155

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow, including the supplied Table 3 Stata pipeline and the companion analyses described in the datasheet and online appendix.

Entry points: `BBCL_LM_Code_updated.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 1/12155 - The-Effect-of-Regulatory-Harmonization-on-Cross-border-Labor-Migration-Evidence-from-the-Accounting-Profession/bbcl-datasheet-and-code.zip",
      "sha256": "f44b9bb2201667e6c4521c02a8f392c1628b0d3f66394b0e35b6f6223d9abb17"
    },
    {
      "path": "JAR-Volume 55/Issue 1/12155 - The-Effect-of-Regulatory-Harmonization-on-Cross-border-Labor-Migration-Evidence-from-the-Accounting-Profession/bbcl_lm-online-appendix.pdf",
      "sha256": "c815ced90cc38b8a9ab5c88e47951dc999836ee2d575a4aab74eaa88c03a82cd"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "272596e884253a4822b0adfd40e3eaffe5b8ac261c5118839813a15e0eda6043"
}
```

## Proposed actions

### A-LFS-ACCESS: Establish a current, permitted Eurostat research-access route for the December 2012 LFS inputs and, for IA5, the December 2014 core data. Keep confidential data within the approved research entity and do not treat the authors’ expired access as transferable.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-LFS-2012, R-LFS-2014-IA5
Evidence: EV1, EV4, EV5, EV6, EV7, EV8, EV17

Preparation / proposed procedure:

1. Confirm that the project and researchers can apply through a recognized research entity under current Eurostat rules.
2. Request the required vintage and exact country/year files through the approved access process.
3. Verify the approved data contain the fields expected by the supplied main do-file; obtain the IA5 field/file mapping from its companion procedure.
4. Keep any authorized confidential data and analysis within the approved research entity and its permitted access environment.

Validation to perform later:

- Confirm current approval and permitted access mode before use.
- Before execution, verify that all 29 × 6 main-analysis files are available with the required columns and names.
- For IA5, confirm the intended 2002–2013 selection and the 1998–2013 contents-heading discrepancy with the author.
- After all authorized inputs and code clarifications are available, run the author program in the permitted environment and compare the resulting Table 3 outputs with the paper.

### A-APPENDIX-WORKFLOW: Request the missing companion programs or author-approved complete procedures, compatible input files/specifications, and execution ordering for Section 3.2 and the appendix. The named historical raw sources are clarification leads, not independently reconstructed inputs. Specifically confirm the IA5 period and provide the legal/business-control regression workflow behind Table IA8.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-APPENDIX-PREPARED-DATA, I-APPENDIX-CODE, I-IA5-PERIOD
Evidence: EV3, EV18, EV19, EV24, EV25, EV26, EV27, EV28

Preparation / proposed procedure:

1. Ask the authors or repository curator for the companion entrypoints, exact prepared-data files or field mappings, and required execution order for the documented non-Table 3 analyses.
2. Confirm whether the IA5 target is 2002–2013 as stated in the detailed section/datasheet or 1998–2013 as stated in the contents heading.
3. Request the code/procedure and inputs that generate Table IA8’s legal- and business-professional control panels.

Validation to perform later:

- Map each supplied companion entrypoint and compatible input to the documented Section 3.2 and IA1–IA9 outputs.
- Verify producer-consumer order, input columns and periods from the author materials without reconstructing variables or final tables from appendix values.
- Confirm the Table IA8 control-group panels and IA5 time range against the author-provided workflow.


## Remaining issues and prerequisites

- I-APPENDIX-CODE [unresolved; full_pipeline]: The supplied do-file identifies itself as the main Table 3 analysis. The online appendix reports companion outputs including Table IA8 for legal and business control groups, while the supplied final regression blocks set control to sample_pro; the code prepares matched files for multiple controls but does not provide the appendix regression/output workflow. Other companion analyses and their exact input mapping/order are also not supplied. Request the companion programs or author-approved complete procedures and compatible prepared inputs; do not reconstruct them from appendix values.
- I-IA5-PERIOD [unresolved; full_pipeline]: The IA5 contents heading says 1998–2013, while the datasheet and detailed IA5 section heading specify 2002–2013. The detailed statement supports the 2002–2013 requirement recorded here, but the title discrepancy needs author confirmation because the IA5 program is absent.
- R-LFS-2012 [undetermined]: Eurostat EU Labour Force Survey December 2012 core data, annual files for the 29 listed European countries and years 2002–2004 and 2008–2010, usable under the supplied do-file’s EU_LFS_yr_<country><year> names. The code expects source columns country, year, isco3d, countryb, national, yearesid, countr1y, sex, age, marstat, hhlink, qhhnum, hatlevel, hatyear, sizefirm, startime, and coeffy.
- R-LFS-2014-IA5 [undetermined]: December 2014 EU LFS core input used by appendix IA5 for the extended aggregate mobility analysis; IA5-specific code, country/file selection, and field mapping are not supplied.
- R-APPENDIX-PREPARED-DATA [undetermined]: For the complete author-documented target, compatible inputs or author-prepared datasets and exact input mappings for the companion analyses (including Section 3.2 and appendix outputs) remain unspecified. The datasheet names historical sources as discovery leads, but supplies no compatible analysis-ready files or companion input specification.

## Review notes

- Only one executable author entrypoint is packaged; it is the Table 3 Stata do-file. No LFS or prepared analysis data are included in the bounded package inventory.
- The do-file creates BBCL_Data_raw and BBCL_Data_clean, as well as dynamic matching intermediates; the frozen checklist entries for those outputs are reviewed as generated dependencies, while EU_LFS files are mandatory inputs.
- No analysis-only scope is supported because neither compatible prepared analysis data nor a verified author-prepared-data route is supplied.
- The existing environment probe was reused; no author code, data, downloads, or installations were executed.
- The source-wide macro inventory finds no local `mob` declaration, but the provided generic Stata semantic probe confirms the empty expansion becomes a successful same-name rename no-op; no unresolved macro issue or source edit is warranted.
