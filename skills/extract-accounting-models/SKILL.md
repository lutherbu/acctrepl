---
name: extract-accounting-models
description: Extract accounting baseline specifications, their reported coefficient results, focal/control roles and model-related descriptive statistics into source-linked JSON. Use with a supplied paper or a frozen specification inventory.
---

# Extract accounting models and results

Use variable-centered schema 3.0 in [output.schema.json](references/output.schema.json). Each outcome/predictor has `results` and `statistics` beside `definition`. For an existing specification inventory, write the tested compact [enrichment.schema.json](references/enrichment.schema.json) (the internal schema-2 enrichment format); the CLI merges, calculates and converts it to schema 3. Do not rewrite existing specifications. Read [results rules](references/results_rules.md) for field conventions, layout and helper interfaces. The method vocabulary remains [regression_methods.json](references/regression_methods.json).

Use supplied input paths literally. A worklist's `reading_json` may be a verified reading outside `papers/parsed`; never reconstruct its path from the paper ID. Hash and validate the assigned version.

## Scope

For this campaign use the supplied paper's frozen baseline models, IDs and selected table locations. Extract all result sets belonging to that baseline family, including its primary horizons, periods or co-primary populations. A reused equation does not bring later robustness, additional-horizon, mechanism or subgroup tests into scope; do not add those from prose or footnotes outside the selected baseline family. Supporting models remain definitions only. Do not replace an untabulated model with a later regression merely to find numbers. Flag a specification/table discrepancy rather than silently changing the target. If no inventory is supplied, first follow [specification rules](references/specification_rules.md) to select and define the principal family.

Repeated fits represented by one specification can have multiple result sets. Distinguish a single fit from means/medians of coefficients across repeated fits. Do not turn numbers of annual fits into observations. Retain actual nonlinear parameter labels; an estimated parameter is not necessarily an observed predictor.

## Read and copy reported values

Read the relevant introduction/design, selected tables, their headers and notes, the discussion of those selected results, and relevant variable-descriptive tables. The discussion may report actual tests absent from a table. Test/reference evidence can come from methods text; cite the actual supporting location rather than attributing it to a p-only table. During verification inspect source values before opening the previous results. Prior extractions and model labels are navigation, not numerical evidence.

For each selected column, align the outcome, sample, horizon and every reported parameter row. Include controls and the reported intercept. Copy the signed estimate and at least one available t/z-statistic, standard error or p-value. Identify parentheses from the table note, not convention. Preserve reported marginal effects/ratios as their actual estimate type. Preserve explicit display multipliers and any source conflicts. Do not copy joint F/LR/chi-square tests into individual-parameter inference. Missing cells and dashes are not zeros.

Attach a shared test or cross-fit summary as an auxiliary row of a relevant existing result set, naming the compared fits and using separate test metadata. Do not create an extra regression result set solely for that diagnostic.

When authors suppress control coefficients or do not tabulate a fit, record that absence with evidence and variable-ID reasons; do not fabricate a full table. Check every reported estimate/statistic against its exact row and column. Read the complete relevant page, including supplied verified tails, before declaring information absent.

## Variable roles and descriptive statistics

Classify each baseline predictor in its model context. `is_research_interest=true` means its coefficient/relationship directly addresses the selected research prediction or primary fitted-method contribution. Use false for controls and adjustment/design terms without that role. A significant coefficient or interaction is not automatically focal. Use null with a specific reason if unresolved. Cite source context for supported roles.

Collect descriptive-statistics rows for retained outcomes, predictors and explicitly related raw versions/components. A component link is directional: the descriptive row is an input to the retained variable. A downstream score, fitted value or prediction error constructed using a predictor is not a component of that predictor. Exclude those downstream summaries unless that quantity is itself a retained variable; coefficient-fit distributions use their separate field. Preserve table/panel, population, period, units and per-variable N; a descriptive sample need not equal regression N. Collect all reported statistics in a relevant row, including arbitrary percentiles, not just common cutoffs. IDs are local to each model: link an ROA row only to ROA, not to every model’s `dv`. Within one sample group, different data rows cannot both be exact descriptions of the same model variable. Keep raw versus logged/ranked/interaction variables separate. Do not calculate descriptive means, SDs or percentiles from other summary values. Distributions of estimated coefficients are not data-variable descriptives: keep them in the parameter’s `reported_distribution`; their SD is not a standard error. Before declaring descriptives absent, search relevant source locations for the retained variables’ summaries, including means embedded in other tables or prose. They need not be beside regressions or in a table titled “descriptive.” Pairwise correlations and hypothesis-test tables are not variable-descriptive tables. Variables used only in excluded regressions are outside scope.

## Evidence and calculations

Use literal page quotes where text is usable. For uncertain alignment or image/vector tables, render and **view** a targeted region using `scripts/render_result_evidence.py`. Cite its returned evidence object. It records the original PDF hash, physical page, bounding box, scale and crop hash. A crop's existence does not mean it was viewed. Do not append a self-written transcription to a reading JSON and call it verified. Preserve original PDFs and reading JSONs; no full OCR sweep.

Use one-based physical PDF pages, including covers. Give column/header/legend evidence for each result set and row/cell evidence for parameters and descriptive statistics. Quotes remain literal even when labels are normalized. A PDF-region citation proves file provenance, not correct interpretation; inspect it carefully.

Copy printed numeric text using the constructors. **Do not calculate** statistical values yourself. Apply the SE-only conventional Wald-ratio rule in the results rules when a genuine sampling SE belongs to an ordinary coefficient; an unknown reference stays unknown. Run `scripts/derive_statistics.py` to merge and derive supported quantities, then `scripts/validate_extraction.py` with the reading, base specification, PDF and workspace. Calculated values live only in `derived`; reported values remain unchanged. Strict derivation never guesses degrees of freedom, sidedness or a normal approximation. A missing derived quantity with a stated reason does not by itself mean extraction failed.

Save the raw enrichment before finalization. Checkpoint each assigned paper with validation, source/raw/result hashes, concrete checks and unresolved items. Record text pages read separately from PDF pages actually viewed. Touch only assigned outputs, evidence and scratch files; keep worklists, sources, schemas and frozen instructions unchanged. Stop after completing the retained models and their related descriptives, without harvesting unrelated regressions.
