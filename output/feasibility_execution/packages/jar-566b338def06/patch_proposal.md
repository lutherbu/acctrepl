# Patch proposal: jar-566b338def06

Paper vs. Practice: A Field Investigation of Integrity Hotlines

DOI: 10.1111/1475-679X.12302

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The documented historical workflow covers selection of 250 firms from the stated possible set of 685 (with an S&P 900 reference as of October 2017), manual hotline-location research, website/email inquiries and response waiting, recording and coding field observations, merging Appendix B controls, and the described t-test, OLS and logistic analyses. The release documents these manual stages but supplies no dataset or executable program. A compatible author-prepared merged dataset may serve as the empirical input and bypass rebuilding historical field contacts. The frame reference does not establish the field-collection period or current index membership.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 2/12302 - Paper-vs-Practice-A-Field-Investigation-of-Integrity-Hotlines/soltes-datasheet.pdf",
      "sha256": "7d662aa1aa435937976630f6da7afa132f104239d9a22f20070ba8ebedc74c11"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "5fe84806025f8cdb68ee36ff6953a8f6fd6566fcdb5e5019273e03e643e25054"
}
```

## Proposed actions

### act-data: Resolve the compatible author-prepared empirical input and its schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-final
Evidence: ev-frame, ev-vars, ev-package

Preparation / proposed procedure:

1. Identify whether an existing author-prepared company-level dataset containing the field records, paper-defined coded outcomes, and merged controls can be obtained through an authorized route; record the route and its access terms before classifying access status.
2. Obtain the actual file format and data dictionary, including field names, types, units/codes, firm identifier, sample identifiers, inquiry/response date fields, and the Appendix B control variables and merge key. Confirm the data cover the historical study sample described by the authors.
3. Use the prepared dataset as the input if compatible; do not use current S&P membership or repeat historical hotline contacts to fill missing fields. If no merged dataset exists, clarify the availability of the authors’ existing historical field/coding/control records before assessing any reconstruction route.

Validation to perform later:

- After an authorized dataset is available, use a bounded metadata/readability check and compare observed columns, types, keys, date fields, firm coverage and coded values with the supplied dictionary and historical sample identifiers.
- Check that field observations and Appendix B controls join on the documented key and that the delivered data preserve the authors’ stated selection and no-additional-truncation process; leave any unsupported schema or coverage claim unresolved.

### act-program: Resolve the missing executable analysis program or complete run recipe.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-code
Evidence: ev-methods, ev-package

Preparation / proposed procedure:

1. Obtain the author analysis and data-preparation program(s), or a complete manual/GUI recipe if the authors intentionally did not provide code. Request the actual software and version, entry point and order, input paths/formats, invocation steps, and required outputs.
2. Obtain the analysis-to-table mapping, including model specifications, outcome and regressor definitions, sample restrictions, and the required t-test, OLS and logistic results; the generic labels in the datasheet do not define these details.
3. Keep software requirements unassigned until the authors specify them; do not infer Stata, SAS, R, Python, or add-on requirements from the method names alone.

Validation to perform later:

- Review the delivered program or recipe against all reported analyses and tables, and trace every input to the resolved dataset or a documented preparation step.
- Only in a later authorized execution, run the resolved entry point(s) with the specified software and compare the produced analyses with the paper’s reported outputs; execution is not verified in this assessment.

### act-method: Resolve the manual field, coding, sample and control-variable definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-contract
Evidence: ev-frame, ev-field, ev-methods, ev-vars

Preparation / proposed procedure:

1. Obtain the full paper and Appendix B or an equivalent author-supplied specification covering the 685-firm eligibility criteria, the historical 250-firm sample identifiers, fieldwork dates, hotline-location lookup, inquiry protocol, response/obstacle coding, and the precise control-variable list and definitions.
2. Request the final coding dictionary and firm-level merge key, including the stated treatment of inquiry closure and response dates. If the compatible author-prepared dataset is used, use these materials to interpret and validate it; do not rebuild the historical fieldwork or contact sampled companies.
3. Keep unresolved any sample, coding, timing or control-variable definition that the supplied materials do not establish; do not derive it from the S&P 900 frame reference or the Compustat example alone.

Validation to perform later:

- Cross-check every requested field and coded value against the delivered dictionary and prepared data; reconcile control-variable definitions and join keys before analysis.
- Confirm the historical selection/frame specification is documented without substituting current index membership, and distinguish sample-frame date from field-collection dates.


## Remaining issues and prerequisites

- issue-code [unresolved; full_pipeline]: No executable analysis or data-preparation program, entry point, or run instructions are included. The datasheet names t-statistics, OLS and logistic regressions but does not identify software, model specifications, commands, or a table-to-analysis mapping. The workflow is partly documented as manual field collection and coding, so this is no runnable code rather than no documented workflow.
- issue-contract [unresolved; full_pipeline]: The datasheet delegates firm-selection criteria, inquiry creation and sending, and variable definitions to the paper and Appendix B, which are not included in this release. The exact sampled firm identifiers, field-collection dates, coded-variable dictionary, historical manual lookup/crosswalk records, complete control-variable list, merge key, and final data schema therefore remain unspecified. The 250/685 sample-frame count and October 2017 S&P 900 reference do not resolve those details or establish the collection period.
- data-final [undetermined]: A company-level empirical dataset compatible with the study, including the recorded field observations (anonymous-reporting text, phone/email/web channel availability, obstacles, provider, inquiry response dates and text), the paper-defined coded outcomes, and the Appendix B controls merged at firm level (examples include revenue and company age). Exact column names, types, coding values, join key, row-level sample identifiers and date coverage are not supplied. A compatible author-prepared dataset is a valid primary input; the datasheet’s 250-of-685 sampling frame and October 2017 S&P 900 reference describe historical frame provenance, not current membership or the field-collection period.

## Review notes

- The frozen work-item dependency checklist is empty, and the package inventory contains only the datasheet; manual collection/coding steps remain part of the documented workflow.
- No separate analysis_only scope is supported because no compatible dataset or analysis program is supplied.
- The datasheet’s 250-of-685 and October 2017 statements are treated as historical sampling-frame context, not as current firm membership or the study’s collection period.
- The frozen title/DOI/provenance are retained even though the datasheet heading uses a variant title and volume/date label.
- The data access route and any associated conditions are not stated in the supplied datasheet; the requirement remains undetermined, with no inference of public availability, NDA, or access denial.
- No live fieldwork, hotline contact, message, form submission, data acquisition, author-code execution, installation, or source edit was performed.
