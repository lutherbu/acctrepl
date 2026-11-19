# Patch proposal: jar-9268d3835cd1

Do Managers Issue More Voluntary Disclosure When GAAP Limits Their Reporting Discretion in Financial Statements?

DOI: 10.1111/1475-679X.12401

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete author-documented workflow: SAS constructs disclosure, discretion and supporting measures; SAS builds main, robustness, MD&A, DiD, Appendix B, Folsom and forecast-count products; Stata consumes the seven main, robustness, DiD, MD&A and Folsom branches.

Entry points: `Master_Code_JAR.sas`, `Master_Stata_code Jar.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12401 - Do-Managers-Issue-More-Voluntary-Disclosure-When-GAAP-Limits-Their-Reporting-Discretion-in-Financial-Statement/hmryz-datasheet-code-and-identifiers.zip",
      "sha256": "f0e4e2da97bc8c3fc75fa268ffcf2652a421f8f513cee436e6ec8fe388c05552"
    },
    {
      "path": "JAR-Volume 60/Issue 1/12401 - Do-Managers-Issue-More-Voluntary-Disclosure-When-GAAP-Limits-Their-Reporting-Discretion-in-Financial-Statement/hmryz-online-appendix.pdf",
      "sha256": "8b2b994f3eb6b1134a953313ec62791d3a3482baa76f9a7c3aab7384d6d3d843"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "32d7e81d47468ca0dc1a0d0389368268995a34266c178ed34e2b155bdbbe5e58"
}
```

## Proposed actions

### ACT_INPUT_001: Resolve Author-prepared input(s) nonames.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NONAMES
Evidence: SRC_D0001

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_002: Resolve Author-prepared input(s) names.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NAMES
Evidence: SRC_D0002

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_003: Resolve Author-prepared input(s) LM_first_half.csv consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_LM_FIRST
Evidence: INS_LOCAL_TEXT_PATHS, SRC_D0004, WEB_LM_CLEANED

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_004: Resolve Author-prepared input(s) LM_second_half.csv consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_LM_SECOND
Evidence: INS_LOCAL_TEXT_PATHS, SRC_D0005, WEB_LM_CLEANED

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_005: Resolve Author-prepared input(s) gvkey_permno_link2017nov30.sas7bdat consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_BYU_LINK
Evidence: SRC_D0008

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_006: Resolve Author-prepared input(s) comp.sas7bdat consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_CREATE
Evidence: P_COMP_FUNDA, SRC_D0009

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_007: Resolve Author-prepared input(s) new_codification_link.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CODIFICATION_LINK
Evidence: SRC_D0012

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_008: Resolve Author-prepared input(s) asu_word_counts1.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ASU_WORD_COUNTS
Evidence: SRC_D0013

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_009: Resolve Author-prepared input(s) par_and_sec_max_edits1.sas7bdat consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_PAR_SEC_EDITS
Evidence: SRC_D0014

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_010: Resolve Author-prepared input(s) modal_words.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MODAL_WORDS
Evidence: SRC_D0015

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_011: Resolve Author-prepared input(s) rbc_public1.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RBC_PUBLIC1
Evidence: SRC_D0017

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_012: Resolve Author-prepared input(s) rbc_public2.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RBC_PUBLIC2
Evidence: SRC_D0018

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_013: Resolve Author-prepared input(s) rbc_ready_to_merge.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RBC_READY
Evidence: SRC_D0020

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_014: Resolve Author-prepared input(s) complexity_ready_to_merge.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPLEXITY_READY
Evidence: SRC_D0021

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_015: Resolve Author-prepared input(s) myear.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MYEAR
Evidence: SRC_D0023

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_016: Resolve Author-prepared input(s) wcasu.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_WCASU
Evidence: SRC_D0025

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_017: Resolve Author-prepared input(s) imp1_lengthrraz.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IMP1_LENGTH
Evidence: SRC_D0027

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_018: Resolve Author-prepared input(s) mdata2.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MDATA2
Evidence: SRC_D0028

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_019: Resolve Author-prepared input(s) imp1_orthlengthrraz.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IMP1_ORTH_LENGTH
Evidence: SRC_D0030

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_020: Resolve Author-prepared input(s) imp1_orthrbcrraz.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IMP1_ORTH_RBC
Evidence: SRC_D0032

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_021: Resolve Author-prepared input(s) link_int_guidance.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_LINK_INT_GUIDANCE
Evidence: SRC_D0033

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_022: Resolve Author-prepared input(s) dscore_limited.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_LIMITED
Evidence: SRC_D0034

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_023: Resolve Author-prepared input(s) accruals.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ACCRUALS
Evidence: SRC_D0035

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_024: Resolve Author-prepared input(s) pscore1.xlsx consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_PSCORE
Evidence: SRC_D0036

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_025: Resolve Author-prepared input(s) det_guidance_1_29_2017.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_GUIDANCE_PREPARED_MAIN
Evidence: P_IBES_GUIDANCE, SRC_D0037

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_026: Resolve Author-prepared input(s) ibes.id consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_ID
Evidence: SRC_D0038

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_027: Resolve Author-prepared input(s) crsp.stocknames consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CRSP_STOCKNAMES
Evidence: P_CRSP_NAMES, SRC_D0039

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_028: Resolve Author-prepared input(s) aa_filedate.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_AA_FILEDATE
Evidence: SRC_D0040

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_029: Resolve Author-prepared input(s) ibes_statsum.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_STATSUM
Evidence: P_IBES_STATSUM, SRC_D0041

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_030: Resolve Author-prepared input(s) crsp.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CRSP_WRDS
Evidence: P_CRSP_DSF, SRC_D0043

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_031: Resolve Author-prepared input(s) analyst_disp1.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ANALYST_DISP
Evidence: SRC_D0046

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_032: Resolve Author-prepared input(s) e_wins.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_E_WINS
Evidence: SRC_D0047

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_033: Resolve Author-prepared input(s) inst_own.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_INST_OWN_DPERM
Evidence: SRC_D0050

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_034: Resolve Author-prepared input(s) fogdata_pre04.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FOG_PRE04
Evidence: SRC_D0051

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_035: Resolve Author-prepared input(s) fogdata_05_07.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FOG_0507
Evidence: SRC_D0052

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_036: Resolve Author-prepared input(s) fogdata_08_09.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FOG_0809
Evidence: SRC_D0053

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_037: Resolve Author-prepared input(s) fogdata_10_11.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FOG_1011
Evidence: SRC_D0054

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_038: Resolve Author-prepared input(s) non_gaap1.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NON_GAAP1_DPERM
Evidence: SRC_D0057

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_039: Resolve Author-prepared input(s) gee_data.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_GEE_DATA
Evidence: SRC_D0064

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_040: Resolve Author-prepared input(s) nonstick.sas7bdat, nonstick.sas7bdat consumed in SAS main tests and supporting data 2a, SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NONSTICK
Evidence: SRC_D0067, SRC_D0094

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_041: Resolve Author-prepared input(s) nonstickd.sas7bdat, nonstickd.sas7bdat consumed in SAS main tests and supporting data 2a, SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NONSTICKD
Evidence: SRC_D0068, SRC_D0095

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_042: Resolve Author-prepared input(s) dscore_limited_length.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_LIMITED_LENGTH
Evidence: SRC_D0055

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_043: Resolve Author-prepared input(s) dscore_limited_alt.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_LIMITED_ALT
Evidence: SRC_D0056

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_044: Resolve Author-prepared input(s) dscore_limited_rr1az.sas7bdat, dscore_limited_rr1az.sas7bdat consumed in SAS main tests and supporting data 2a, SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_RR1AZ
Evidence: SRC_D0061, SRC_D0089

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_045: Resolve Author-prepared input(s) dscore_alt_limited_length_rr1az.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_ALT_LIMITED_LENGTH
Evidence: SRC_D0063

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_046: Resolve Author-prepared input(s) non_gaap.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NON_GAAP
Evidence: SRC_D0069

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_047: Resolve Author-prepared input(s) components_of_dscore.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPONENTS_DSCORE
Evidence: SRC_D0070

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_048: Resolve Author-prepared input(s) nonstickd_hist.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_NONSTICKD_HIST
Evidence: SRC_D0071

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_049: Resolve Author-prepared input(s) dscore_limited_lengtha.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_LENGTHA
Evidence: SRC_D0073

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_050: Resolve Author-prepared input(s) ibes_actu.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_ACTU
Evidence: P_IBES_ACTU, SRC_D0075

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_051: Resolve Author-prepared input(s) ibes_detu.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_DETU
Evidence: P_IBES_DETU, SRC_D0076

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_052: Resolve Author-prepared input(s) comp.funda consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_FUNDA_OWNERSHIP
Evidence: P_COMP_FUNDA, SRC_D0078

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_053: Resolve Author-prepared input(s) tfn.s34 consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_TFN_S34
Evidence: CAT_TFN_S34, INS_TFN_S34_LOOKUP, SRC_D0080

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_054: Resolve Author-prepared input(s) readability_10k_10k.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_READABILITY_10K
Evidence: SRC_D0084

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_055: Resolve Author-prepared input(s) output_mda_std_hits_no_standard_names.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MDA_STANDARD_HITS
Evidence: SRC_D0086

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_056: Resolve Author-prepared input(s) import_std_year.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IMPORT_STD_YEAR
Evidence: SRC_D0087

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_057: Resolve Author-prepared input(s) fog_7.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FOG_7
Evidence: SRC_D0088

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_058: Resolve Author-prepared input(s) dscore_alt_limited_length_rr1az.sas7bdat consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DSCORE_ALT_LIMITED_LENGTH_RR1AZ
Evidence: SRC_D0091

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_059: Resolve Author-prepared input(s) standard changes.xlsx consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_STANDARD_CHANGES
Evidence: SRC_D0097

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_060: Resolve Author-prepared input(s) rel_imp_mda_nomin.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_REL_IMP_MDA_NOMIN
Evidence: SRC_D0098

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_061: Resolve Author-prepared input(s) ddaq.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DDAQ
Evidence: SRC_D0101

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_062: Resolve Author-prepared input(s) completepfsample.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPLETEPFSAMPLE
Evidence: SRC_D0102

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_063: Resolve Author-prepared input(s) appendix_aidz.xlsx consumed in SAS Appendix B1 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_APPENDIX_AIDZ
Evidence: SRC_D0104

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_064: Resolve Author-prepared input(s) resultsLM.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RESULTS_LM
Evidence: SRC_D0105

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_065: Resolve Author-prepared input(s) searchrestrictterms.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_SEARCH_RESTRICT
Evidence: SRC_D0106

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_066: Resolve Author-prepared input(s) LIWCrestrict.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_LIWC_RESTRICT
Evidence: SRC_D0107

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_067: Resolve Author-prepared input(s) constituent.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CONSTITUENT
Evidence: SRC_D0108

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_068: Resolve Author-prepared input(s) uploadrestrict.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_UPLOAD_RESTRICT
Evidence: SRC_D0109

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_069: Resolve Author-prepared input(s) finaldataw.dta consumed in SAS Folsom and forecast-count stages 2g-2h. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FOLSOM_FINALDATAW
Evidence: SRC_D0111

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_070: Resolve Author-prepared input(s) det_guidance_1_29_2017.sas7bdat consumed in SAS Folsom and forecast-count stages 2g-2h. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_GUIDANCE_FOLSOM
Evidence: SRC_D0113

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_INPUT_071: Resolve Author-prepared input(s) finalz4_fog.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FINALZ4_FOG
Evidence: SRC_D0100

Preparation / proposed procedure:

1. Provide the exact author-prepared file at the named source path, or identify the intended compatible source and author-documented conversion/filtering step.
2. Confirm the fields, identifiers, date/history bounds, selections, units and output schema needed by the first consumer in the cited source.
3. For a catalogued product candidate, compare its exact version and required history with the supplied preparation before using it; the bounded one-row metadata is not coverage evidence.

Validation to perform later:

- After the input contract is confirmed, inspect its bounded header and first record, then compare all required fields, identifiers, filters and period to the consumer before running the corresponding author stage.

### ACT_MACROS: Obtain both MacroRepository.sas include variants or author documentation of the exact macro contracts and stage prerequisites.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_MACROS
Evidence: SRC_D0011, SRC_D0077

Preparation / proposed procedure:

1. Ask for the exact macro source(s) referenced at the two distinct paths and retain each version separately.
2. Document macro definitions and their input/output datasets, remote calls and required invocation order before planning the SAS stages.

Validation to perform later:

- Statically match each called macro to its definition and confirm all macro inputs, generated outputs and source paths before author execution.

### ACT_SHEETS: Resolve the exact author spreadsheet handoffs and preserve each export/import filename and schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_SPREADSHEETS, REQ_IMP1_LENGTH, REQ_MDATA2, REQ_IMP1_ORTH_LENGTH, REQ_IMP1_ORTH_RBC
Evidence: SRC_D0026, SRC_D0027, SRC_D0028, SRC_D0029, SRC_D0030, SRC_D0031, SRC_D0032

Preparation / proposed procedure:

1. Provide the four imported workbooks and document whether they were manually edited, renamed, re-ordered, filtered or imputed after export.
2. Confirm whether mdata.xlsx and mdata2.xlsx are separate artifacts and provide the expected columns, sheet names and row-selection rules.
3. Keep lengthrraz.xlsx distinct from imp1_lengthrraz.xlsx and the orthogonalized .xlsx exports distinct from the imp1_ workbooks until equivalence is established.

Validation to perform later:

- Compare each workbook's sheet, column order, labels, keys and required transformations to the first SAS consumer before the stage is run.

### ACT_STAGE_ORDER: Confirm the intended stage order or prebuilt staging for shall21rraz, shall15rra and ba7.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_STAGE_ORDER
Evidence: SRC_D0019, SRC_D0022, SRC_D0072, PROD_D0019, PROD_D0072, PROD_D0022

Preparation / proposed procedure:

1. Ask whether the earlier read sites are legacy references to already-saved products or whether the later supplied producer sections are intended to run first and stage compatible outputs to the earlier consumer paths.
2. Record the fields and filters that make each generated table compatible; do not substitute an independently rebuilt table.

Validation to perform later:

- Review the documented DAG statically and verify every generated table's producer is scheduled before each consumer with the same library, path, schema and selection.

### ACT_INST_OWN: Confirm the intended DPERM.INST_OWN versus SAVED.INST_OWN handoff and staged location.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_INST_OWN_PATH, REQ_INST_OWN_DPERM
Evidence: SRC_D0050, SRC_D0078, SRC_D0080, PROD_D0050, OWN_SAVED_PATH, OWN_FORMULA

Preparation / proposed procedure:

1. Confirm whether the supplied later ownership block is the intended producer for the earlier DPERM.INST_OWN read; it writes SAVED.INST_OWN to a different Documents path after the remote sample download.
2. Request the intended working-copy path, library assignment, input sample/key, output columns, and any author-documented staging operation.

Validation to perform later:

- Compare exact SAS library and file paths, key fields, units, filters and producer timing across the two source blocks before editing or running.

### ACT_NON_GAAP: Confirm the intended DPERM.NON_GAAP1 read and later PERM.NON_GAAP1 product handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_NON_GAAP_PATH, REQ_NON_GAAP1_DPERM
Evidence: SRC_D0057, SRC_D0075, SRC_D0076, PROD_D0057

Preparation / proposed procedure:

1. Confirm whether the later ACTU/DETU-based PERM.NON_GAAP1 construction is intended to feed the earlier DPERM.NON_GAAP1 consumer, and document the exact staging library/path, field schema and selection.
2. Retain the separately required ACTU and DETU inputs and their current source paths until the contract is confirmed.

Validation to perform later:

- Statically compare the produced and consumed dataset names, library refs, columns, keys and date filters before any path/configuration change.

### ACT_D_SCORE_PRODUCERS: Identify the author-supplied stage or prepared products that provide the consumed D_SCORE aliases with no same-name producer in the supplied SAS file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_D_SCORE_PRODUCERS
Evidence: SRC_D0034, SRC_D0055, SRC_D0056, SRC_D0061, SRC_D0063, SRC_D0073, SRC_D0089, SRC_D0091, INS_SOURCE_TRACE

Preparation / proposed procedure:

1. Ask for the exact upstream program or author-prepared dataset files for each listed alias, including their library/path, columns, identifiers, period, filters and output schemas.
2. Keep these aliases distinct from the supplied generated D_SCORE variants until the author confirms field, selection and history compatibility; do not independently rebuild them.

Validation to perform later:

- Trace each confirmed producer to the exact SAS libref and dataset alias used by its consumer and compare key fields and transformations statically before running.

### ACT_FINALZ4_FOG: Confirm whether supplied DPERM.FINALZ4_FOG1 output is intended to serve the later DPERM.FINALZ4_FOG read.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_FINALZ4_FOG_PATH, REQ_FINALZ4_FOG
Evidence: SRC_D0100, PROD_D0100

Preparation / proposed procedure:

1. Ask the authors to confirm the intended suffix and whether the two same-library products have identical columns, keys, filters and period.
2. If staging is intended, document the exact output path and order without changing or renaming an author dataset before confirmation.

Validation to perform later:

- Statically compare both named datasets' producers, source library paths and first consumer schema before any future run.

### ACT_CASE_PATHS: Prepare one case-preserving filename and working-directory contract for each SAS-to-Stata handoff.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_CASE_PATHS
Evidence: SRC_D0085, SRC_D0114, SRC_D0117, SRC_D0134, SRC_D0135, PROD_D0085, PROD_D0114, PROD_D0117, PROD_D0134, PROD_D0135

Preparation / proposed procedure:

1. In the working copies, make each SAS export and its matching SAS/Stata consumer use identical filename case, and record the working directory for each EvGx/evgx, EvG1/evg1 and MD&A robustness pair.
2. Keep each output variant and its own consumer distinct while applying the matching path spelling.

Validation to perform later:

- Statically verify the matching case-preserving spelling and working directory at each SAS export, SAS import and Stata use site before execution.

### ACT_STATA_SYNTAX: Ask the authors to specify the intended Stata release and exact command specification for regress calls with absorb().

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_STATA_ABSORB
Evidence: E003, WEB_STATA18_ABSORB, WEB_REGRESS_MANUAL, P_ENV

Preparation / proposed procedure:

1. Confirm whether the analysis depends on a StataNow feature, another command/version, or supplied author change; keep each model's fixed effects, clustering, coefficients and samples intact.
2. Do not replace regress with another estimator based on this static review alone.

Validation to perform later:

- Using the author-confirmed release and command documentation, check compatibility statically for every affected call across all seven Stata branches before any future run.

### ACT_WRDS: Confirm the supported WRDS session setup and remote dataset products used by the SAS stages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_WRDS_SESSION
Evidence: SRC_D0038, SRC_D0039, SRC_D0043, SRC_D0078, SRC_D0080, WEB_SAS_CONNECT, CAT_TFN_S34, INS_TFN_S34_LOOKUP

Preparation / proposed procedure:

1. Document the SAS/CONNECT signon configuration, server-side librefs, authentication method and exact datasets returned by each RSUBMIT/PROC DOWNLOAD block.
2. Compare the local TFN.S34 catalog candidate to the remote author alias and required ticker/rdate/shares fields and history; separately confirm which route provides IBES.ID, CRSP and COMP.FUNDA.

Validation to perform later:

- Check the configured session and every returned field/schema contract statically before a future session; the catalog listing alone does not verify data readability or remote equivalence.

### ACT_SAS_SOFTWARE: Verify SAS 9.4 M8 runtime and required SAS/STAT, SAS/ETS, SAS/CONNECT and SAS/ACCESS PC Files components through supported metadata after the existing startup limitation is resolved.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_STAT, SW_SAS_ETS, SW_SAS_CONNECT, SW_SAS_PCFILES
Evidence: P_ENV, WEB_SAS_STAT, WEB_SAS_ETS, WEB_SAS_CONNECT, WEB_SAS_PCFILES

Preparation / proposed procedure:

1. Confirm the SAS 9.4 maintenance release and installed procedure/product metadata without launching or retrying the study program.
2. Confirm access to the intended UNIX XLSX reader/writer and SAS/CONNECT remote session configuration.

Validation to perform later:

- Record component/version and availability using metadata only; do not treat the previous TKELS initialization failure as evidence of missing license.

### ACT_CLOSURE: Close the remaining source, input, stage-order, remote-session and branch contracts before execution is attempted.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_CLOSURE
Evidence: E002, E003, SRC_D0011, SRC_D0077, WEB_STATA18_ABSORB

Preparation / proposed procedure:

1. Use the stage-by-stage dependency review and seven Stata branches as the checklist; preserve separate prepared-input variants and all current output filenames.
2. Resolve each linked input and software action, document the intended working directory at every export/import, and confirm macro-generated dependencies.

Validation to perform later:

- Reconcile all149 frozen IDs to the confirmed input, generated output, software or explicit issue contract; only then plan the author program run.


## Remaining issues and prerequisites

- ISS_MACROS [unresolved; full_pipeline]: Two separate %INCLUDE paths refer to MacroRepository.sas, but that external macro source is not supplied in the assigned package. Calls including %ICLINK, %WT, %corrps and %ff48 remain live dependencies; their bodies, side effects and input/output contracts are unresolved.
- ISS_SPREADSHEETS [unresolved; full_pipeline]: The supplied code exports lengthrraz.xlsx but imports imp1_lengthrraz.xlsx; also imports mdata2.xlsx while a later block exports mdata.xlsx; orthlengthrraz/orthrbcrraz exports have distinct imp1_ workbook imports. The supplied text does not establish that these are identical files, edited versions, or schema-compatible handoffs.
- ISS_STAGE_ORDER [unresolved; full_pipeline]: The supplied program contains producers for shall21rraz, shall15rra and ba7 after their earlier read edges. These are code-generated dependencies, not independent raw-data requirements; a runnable staged workflow must produce/save each compatible dataset before the listed consumer or document the intended prebuilt staging.
- ISS_INST_OWN_PATH [unresolved; full_pipeline]: The main branch reads DPERM.INST_OWN from the Tests/Test Data path. The later supplied ownership code builds SAVED.INST_OWN under a different Documents path after the earlier consumer and after remote sample downloads. Credit the supplied ownership algorithm; confirm intended order, library, output location, fields, filters and any working-copy staging rather than assuming the differently named tables are the same.
- ISS_NON_GAAP_PATH [unresolved; full_pipeline]: The main branch reads DPERM.NON_GAAP1 from Tests/Test Data. Later supplied code constructs PERM.NON_GAAP1 under the Datasets library using the separate ACTU/DETU inputs. This is a path/namespace/order/selection contract gap, not evidence that no construction algorithm exists; confirm compatibility and the intended staged handoff.
- ISS_D_SCORE_PRODUCERS [unresolved; full_pipeline]: The SAS main and robustness sections consume data.dscore_limited, dscore_limited_length, dscore_limited_alt, dscore_limited_rr1az, dscore_alt_limited_length_rr1az and dscore_limited_lengtha inputs without an exact same-name producer in the supplied Master_Code_JAR.sas. Related D_SCORE measures are constructed elsewhere in the file, but they do not establish these exact aliases or schemas. Confirm the upstream author stage or the intended prepared products; do not reconstruct them independently.
- ISS_FINALZ4_FOG_PATH [unresolved; full_pipeline]: The supplied MDA main block writes DPERM.FINALZ4_FOG1, but a later MDA robustness consumer reads DPERM.FINALZ4_FOG. The suffix differs in the same library/path; confirm whether these products are intended to match and document the exact schema/selection before staging.
- ISS_CASE_PATHS [preparation; full_pipeline]: SAS writes EvGx.dta and EvG1.dta while supplied SAS/Stata consumers refer to lowercase evgx.dta and evg1.dta; MD&A robustness has analogous capitalization differences for ROB_fog/ROBa outputs and lower-case reads. This is a known filename-configuration task on case-sensitive hosts; configure matching producer/consumer spellings while retaining each distinct dataset variant.
- ISS_STATA_ABSORB [blocking; full_pipeline]: The supplied Stata file invokes regress ..., absorb(cik|sta|cusip|gvkey) across main, robustness, DiD and MD&A branches. Static official documentation places high-dimensional absorb() support in StataNow areg and xtreg, fe, while the installed metadata reports Stata 18 and does not establish StataNow. Do not substitute an estimator or alter specifications without author clarification of the intended release and command.
- ISS_WRDS_SESSION [unresolved; full_pipeline]: SAS source uses SIGNON, RSUBMIT, PROC DOWNLOAD and WRDS server libraries. Exact credentials, remote session setup, returned datasets and histories are not established. The frozen catalog lists a local TFN.S34 candidate, but that does not establish equivalence to the remote author alias or resolve other WRDS inputs; no license or access barrier is inferred.
- ISS_CLOSURE [unresolved; full_pipeline]: The full source includes unresolved macro expansion, author-prepared input schemas/histories, spreadsheet handoffs, working-path variants, remote WRDS stages and multiple analysis branches. All frozen dependency IDs are individually dispositioned below, but readiness remains incomplete until these contracts are resolved.
- REQ_NONAMES [undetermined]: Author-prepared input(s) nonames.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_NAMES [undetermined]: Author-prepared input(s) names.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_LM_FIRST [undetermined]: Author-prepared input(s) LM_first_half.csv consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_LM_SECOND [undetermined]: Author-prepared input(s) LM_second_half.csv consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_BYU_LINK [undetermined]: Author-prepared input(s) gvkey_permno_link2017nov30.sas7bdat consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_COMP_CREATE [undetermined]: Author-prepared input(s) comp.sas7bdat consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_CODIFICATION_LINK [undetermined]: Author-prepared input(s) new_codification_link.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_ASU_WORD_COUNTS [undetermined]: Author-prepared input(s) asu_word_counts1.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_PAR_SEC_EDITS [undetermined]: Author-prepared input(s) par_and_sec_max_edits1.sas7bdat consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_MODAL_WORDS [undetermined]: Author-prepared input(s) modal_words.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_RBC_PUBLIC1 [undetermined]: Author-prepared input(s) rbc_public1.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_RBC_PUBLIC2 [undetermined]: Author-prepared input(s) rbc_public2.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_RBC_READY [undetermined]: Author-prepared input(s) rbc_ready_to_merge.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_COMPLEXITY_READY [undetermined]: Author-prepared input(s) complexity_ready_to_merge.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_MYEAR [undetermined]: Author-prepared input(s) myear.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_WCASU [undetermined]: Author-prepared input(s) wcasu.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IMP1_LENGTH [undetermined]: Author-prepared input(s) imp1_lengthrraz.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_MDATA2 [undetermined]: Author-prepared input(s) mdata2.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IMP1_ORTH_LENGTH [undetermined]: Author-prepared input(s) imp1_orthlengthrraz.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IMP1_ORTH_RBC [undetermined]: Author-prepared input(s) imp1_orthrbcrraz.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_LINK_INT_GUIDANCE [undetermined]: Author-prepared input(s) link_int_guidance.xlsx consumed in SAS measures 1a-1j. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_LIMITED [undetermined]: Author-prepared input(s) dscore_limited.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_ACCRUALS [undetermined]: Author-prepared input(s) accruals.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_PSCORE [undetermined]: Author-prepared input(s) pscore1.xlsx consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_GUIDANCE_PREPARED_MAIN [undetermined]: Author-prepared input(s) det_guidance_1_29_2017.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IBES_ID [undetermined]: Author-prepared input(s) ibes.id consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_CRSP_STOCKNAMES [undetermined]: Author-prepared input(s) crsp.stocknames consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_AA_FILEDATE [undetermined]: Author-prepared input(s) aa_filedate.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IBES_STATSUM [undetermined]: Author-prepared input(s) ibes_statsum.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_CRSP_WRDS [undetermined]: Author-prepared input(s) crsp.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_ANALYST_DISP [undetermined]: Author-prepared input(s) analyst_disp1.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_E_WINS [undetermined]: Author-prepared input(s) e_wins.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_INST_OWN_DPERM [undetermined]: Author-prepared input(s) inst_own.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FOG_PRE04 [undetermined]: Author-prepared input(s) fogdata_pre04.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FOG_0507 [undetermined]: Author-prepared input(s) fogdata_05_07.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FOG_0809 [undetermined]: Author-prepared input(s) fogdata_08_09.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FOG_1011 [undetermined]: Author-prepared input(s) fogdata_10_11.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_NON_GAAP1_DPERM [undetermined]: Author-prepared input(s) non_gaap1.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_GEE_DATA [undetermined]: Author-prepared input(s) gee_data.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_NONSTICK [undetermined]: Author-prepared input(s) nonstick.sas7bdat, nonstick.sas7bdat consumed in SAS main tests and supporting data 2a, SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_NONSTICKD [undetermined]: Author-prepared input(s) nonstickd.sas7bdat, nonstickd.sas7bdat consumed in SAS main tests and supporting data 2a, SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_LIMITED_LENGTH [undetermined]: Author-prepared input(s) dscore_limited_length.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_LIMITED_ALT [undetermined]: Author-prepared input(s) dscore_limited_alt.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_RR1AZ [undetermined]: Author-prepared input(s) dscore_limited_rr1az.sas7bdat, dscore_limited_rr1az.sas7bdat consumed in SAS main tests and supporting data 2a, SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_ALT_LIMITED_LENGTH [undetermined]: Author-prepared input(s) dscore_alt_limited_length_rr1az.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_NON_GAAP [undetermined]: Author-prepared input(s) non_gaap.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_COMPONENTS_DSCORE [undetermined]: Author-prepared input(s) components_of_dscore.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_NONSTICKD_HIST [undetermined]: Author-prepared input(s) nonstickd_hist.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_LENGTHA [undetermined]: Author-prepared input(s) dscore_limited_lengtha.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IBES_ACTU [undetermined]: Author-prepared input(s) ibes_actu.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IBES_DETU [undetermined]: Author-prepared input(s) ibes_detu.sas7bdat consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_COMP_FUNDA_OWNERSHIP [undetermined]: Author-prepared input(s) comp.funda consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_TFN_S34 [undetermined]: Author-prepared input(s) tfn.s34 consumed in SAS main tests and supporting data 2a. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_READABILITY_10K [undetermined]: Author-prepared input(s) readability_10k_10k.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_MDA_STANDARD_HITS [undetermined]: Author-prepared input(s) output_mda_std_hits_no_standard_names.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_IMPORT_STD_YEAR [undetermined]: Author-prepared input(s) import_std_year.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FOG_7 [undetermined]: Author-prepared input(s) fog_7.xlsx consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DSCORE_ALT_LIMITED_LENGTH_RR1AZ [undetermined]: Author-prepared input(s) dscore_alt_limited_length_rr1az.sas7bdat consumed in SAS robustness and MD&A 2b-2d. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_STANDARD_CHANGES [undetermined]: Author-prepared input(s) standard changes.xlsx consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_REL_IMP_MDA_NOMIN [undetermined]: Author-prepared input(s) rel_imp_mda_nomin.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_DDAQ [undetermined]: Author-prepared input(s) ddaq.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_COMPLETEPFSAMPLE [undetermined]: Author-prepared input(s) completepfsample.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_APPENDIX_AIDZ [undetermined]: Author-prepared input(s) appendix_aidz.xlsx consumed in SAS Appendix B1 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_RESULTS_LM [undetermined]: Author-prepared input(s) resultsLM.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_SEARCH_RESTRICT [undetermined]: Author-prepared input(s) searchrestrictterms.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_LIWC_RESTRICT [undetermined]: Author-prepared input(s) LIWCrestrict.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_CONSTITUENT [undetermined]: Author-prepared input(s) constituent.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_UPLOAD_RESTRICT [undetermined]: Author-prepared input(s) uploadrestrict.csv consumed in SAS Appendix B4 2f. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FOLSOM_FINALDATAW [undetermined]: Author-prepared input(s) finaldataw.dta consumed in SAS Folsom and forecast-count stages 2g-2h. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_GUIDANCE_FOLSOM [undetermined]: Author-prepared input(s) det_guidance_1_29_2017.sas7bdat consumed in SAS Folsom and forecast-count stages 2g-2h. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- REQ_FINALZ4_FOG [undetermined]: Author-prepared input(s) finalz4_fog.sas7bdat consumed in SAS validation DiD 2e. Confirm the exact file(s), source fields, identifiers, period/history, filters and schema used by the supplied code.
- SW_SAS [unverified]: SAS 9.4 executable path is present in metadata, but bounded startup failed to initialize TKELS. Runtime readiness and entitlement remain unverified.
- SW_SAS_STAT [unverified]: PROC REG, PROC SURVEYREG and other SAS statistical procedures require SAS/STAT support; installed product/license/version metadata is not verified.
- SW_SAS_ETS [unverified]: PROC EXPAND is used in the supplied source; exact SAS/ETS component/version availability is not verified.
- SW_SAS_CONNECT [unverified]: Remote SIGNON/RSUBMIT/PROC DOWNLOAD stages require SAS/CONNECT and a configured WRDS session. Neither component availability nor credentials are established.
- SW_SAS_PCFILES [unverified]: SAS imports and exports XLSX workbooks. Official 9.4 documentation describes DBMS=XLSX on UNIX; the installed component and exact M8 configuration are unverified.

## Review notes

- Assessment covers the full author-provided SAS and Stata workflow, including all named preparation, support, validation, appendix, robustness, MD&A and Folsom branches.
- The packaged ids.sas7bdat is a one-row-readable identifiers file only; it is not treated as a compatible analysis dataset or coverage proof.
- One-row SAS metadata probes establish readability and sampled columns only; no total rows, complete population, history or dataset construction was inferred.
- Generated datasets D0019, D0022 and D0072 are credited to supplied producers; the unresolved question is required stage order/staging. The INST_OWN and NON_GAAP1 algorithms are credited, while exact namespace/path/selection handoffs remain open.
- CRSP, Compustat and IBES local products are candidate routes only. Exact aliases, author filters, history, joins and coverage remain unverified; missing catalog lookups do not imply license or product absence.
- Factiva and manual text/standard classification descriptions are contextual unless a supplied code read requires a named input. No independent document or variable reconstruction is proposed.
- Stata regress, absorb() compatibility is assessed only from official static documentation and runtime metadata. No syntax, estimator, statistical, SAS, author-program or dataset trial was made.
- No author program was executed, imported, compiled, edited, installed, downloaded, or deserialized. Execution remains unverified.
