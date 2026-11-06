# Results field and helper conventions

## Input and output

The production input is a version-1 paper specification, its reading JSON, paired PDF and matching sample record. Model and variable inventory is frozen. Predictor IDs are deterministic `iv_001`, `iv_002`, etc. in the existing RHS order; the outcome is `dv`. IDs are local to a model. Never assign a coefficient by position alone when the table uses a different row order.

The worker writes `schema_version: 2.0-enrichment`, accounting for every baseline model, with its role entries, result sets and descriptive groups. This remains the tested internal input format. `results_helpers.new_enrichment(base)` supplies a skeleton. The CLI merges, calculates and converts it to published schema 3.0; original specification fields are preserved. Supporting models receive `not_requested`. Do not leave constructor placeholders or unexplained null roles. A direct Python `merge_enrichment` call still returns schema 2 for compatibility; apply `convert_schema.to_v3` when using that API.

## Published variable-centered layout

Each dependent/predictor variable contains `results[]` and `statistics[]` alongside its definition. A result retains the full reported/derived parameter record and identifies its model-local `result_set_id`. A variable-specific auxiliary test also belongs there. Shared coefficient parameters appear under every linked variable with the same parameter/result-set IDs. Intercepts stay in `model.intercept_results`; joint tests, fixed-effect rows and other model-level parameters stay in `model.auxiliary_results`.

`model.result_sets[]` retains fit context, source locations, test defaults, legends and `parameter_order`; it contains no parameter values. Model result status/reason/missing fields/notes/evidence are `results_status`, `results_reason`, `results_missing_fields`, `results_review_notes`, and `results_evidence`.

Variable statistics retain `reported_variable_name`, `variable_relation`, `units`, `values[]`, evidence and notes. `source_group_id` identifies the paper's metadata-only `descriptive_groups[]` entry (sample, period, sample relation, locations and shared evidence). Source row/link indices preserve identity and original ordering; they are not empirical observations. Several model variables may contain the same source row. Shared copies must agree; validation rejects conflicting edits rather than selecting a copy silently. Preserve IDs/indices when editing existing values.

The schema-2 layout is retained in `output.v2.schema.json`. `convert_schema.to_v2` reverses the layout exactly, including original row/link ordering, for compatibility and source-aware validation. This conversion performs no inference calculations.

## Result columns and parameters

A result set identifies a reported column, including table/panel, physical page, horizon, period and population. Use only the frozen baseline family and selected columns; later additional-horizon or robustness tests remain excluded even when they reuse the equation. Set `aggregation` to `single_fit`, `mean_across_fits`, `median_across_fits`, `other_summary` or `unclear`. Distinguish a t-statistic testing a mean coefficient from an average of individual-fit t-statistics. The latter is not the mean coefficient divided by its SE: set `wald_on_reported_scale=false` when that identity is unsupported. Do not invent unreported horizon columns.

A joint test, coefficient contrast or paired pre/post summary does not itself create another regression fit. Store it as an auxiliary row in a relevant existing result set, explicitly naming the linked fits and its actual test context. Do not add a standalone diagnostic-only set or declare actually reported predictors missing just to pass coverage validation. An untabulated selected fit may still retain its own reported performance summaries with source-backed coefficient omissions.

Each parameter has a stable within-set ID and printed label. `target_kind` is `predictor`, `intercept`, `auxiliary`, `fixed_effect` or `unmapped`. Link predictors to their actual model variable IDs; nonlinear parameters can link multiple data inputs or have no direct predictor mapping. Explain unmapped rows. Do not add an intercept to the predictor list. The same model term can have several explicitly reported estimate types, but their inference must not be mixed.

`reported.estimate`, `reported.standard_error` and the statistic cell contain `{text, value}`. Prefer the constructors to parse printed signed numbers. Enclosing statistical parentheses are not a negative sign; preserve an actual minus sign. The numeric text may preserve scientific notation, thousands separators or a trailing percent sign; values remain in the printed scale, so `5.7%` has value 5.7. Numeric conversion is not a scale transformation.

`reported.statistic.kind` is `t`, `z`, `wald_ratio` or `other`. Use other only with explanatory notes. An individual-parameter chi-square can be retained as `other`, alongside its printed p-value; it is not a signed t/z ratio and must never be divided into the coefficient to obtain an SE. Joint chi-square tests remain excluded from parameter inference. Raw p-values carry `eq`, `lt`, `le`, `gt`, `ge`, `interval` or `rounded_boundary`. Store interval endpoints explicitly. Printed zero/one p-values are rounded boundaries, not invertible exact points. Preserve stars and their **source-specific** legend. Stars never establish an exact p-value.

A result-set `test_context` can be overridden per parameter. Capture actual Wald/LR/score type, null, alternative, reference distribution and degrees of freedom. A usual t/z test of an ordinary coefficient against zero can use `null_basis=standard_zero_coefficient_test`, with the table's inference note as evidence. Do not use this convention for ratio-scale, transformed-effect, cross-equation or explicitly nonzero-null tests. `wald_on_reported_scale` must be established, not assumed for marginal effects whose printed statistic might concern an underlying latent coefficient. Non-coefficient estimate types also require `null_basis=reported` with evidence identifying the null and inference on that actual scale before estimate/SE/statistic inversion. If unknown, retain the reported values and block the calculation.

For t/z rows, the distribution label identifies Student-t/normal unless the source explicitly states a different reference; t degrees of freedom still require source support. Never infer df from total sample size or cluster counts. Alternatives are `two_sided`, `greater`, `less` or `unknown`; do not choose a one-sided direction from the observed sign. Where the source says one-sided for predictions and two-sided otherwise, resolve each term from its reported prediction, or retain unknown.

For an ordinary unconstrained coefficient and its genuine sampling SE on the same estimate scale, enable a conventional zero-null Wald ratio even if the paper prints no t/z label: use `type=wald`, `null_value=0`, `null_basis=standard_zero_coefficient_test` and `wald_on_reported_scale=true`. Cite the coefficient/SE header and note that this is a conventional derived zero-null ratio, not an author-reported test. Keep `reference=unknown` unless source evidence identifies it; the helper then labels the derived statistic `wald_ratio`, not t/z, and cannot derive a point p-value. Do not fill a reported statistic with a calculated ratio. This rule does not apply to cross-fit dispersion SDs, an SE of a different quantity, constrained/boundary estimates, transformed effects or ratio-scale estimates; those retain the stricter scale/null requirements above. A printed zero SE cannot be inverted.

`estimate_multiplier` is the displayed value divided by the underlying estimate. `standard_error_multiplier` is separate. Both default to 1; a non-unit multiplier needs source evidence. The helper normalizes quantities before using their relationship. Coefficient multipliers do not apply to t/z/p. Do not substitute an odds ratio or marginal effect for an unreported coefficient.

In each result set account for every frozen predictor: link its parameter, or put a source-backed omission reason under that variable ID in the model results' `missing_fields`. Explain an unreported intercept under `intercept`. An unavailable estimate uses `reported.estimate`; unavailable inference uses `reported.inference` in the parameter's missing fields. Do not mark an entire table unavailable because a few controls are suppressed.

`complete` means extracted reported fields are supported. Use `needs_review` for unresolved mapping/role/value issues, `not_reported` for an unreported fit and `unreadable` for source damage that could not be resolved. The new `results_status` is separate from inherited specification flags. Missing optional derivations alone are not an error; missing reported estimates/inference remains explicit.

A reported distribution of coefficient estimates belongs in that parameter’s `reported_distribution` array (the same statistic objects used below). It does not describe the associated predictor or outcome. A mean coefficient can be the reported estimate in a mean-across-fits set, with its distributional mean, SD and percentiles preserved here. Those dispersion statistics never become `reported.standard_error` and are not used to derive inference.

## Descriptive groups

Each group identifies the actual sample and table/panel, with `sample_relation` to linked baseline models: exact, broader, narrower, different or unclear. Use unclear when equality cannot be established. Variable-specific N belongs in that row's statistics; never fill it from the model or parent sample.

Descriptive rows have `statistics_about=data_values`. Link each variable row to baseline model variables with relation `exact`, `raw_version`, `component` or `unclear`. A raw market-value row is not the summary of log market value. A `component` row is an input to the retained variable, not a downstream score, prediction error or ratio containing it. Variable IDs are model-local; match both the model and the actual variable, including time indices. Current-earnings summaries are not exact summaries of future earnings; preserve any timing/sample limitation explicitly rather than assuming shifted means or Ns. Do not link every outcome row to every model’s `dv`. Do not use `unclear` to attach an intercept distribution to an outcome; omit an invalid link. Duplicate exact targets across different rows in one group are rejected. Do not multiply component means to produce an interaction mean. Preserve group-specific units and source sign/scaling inconsistencies.

Statistic names: n, mean, sd, min, median, max, variance, skewness, kurtosis, percentile, other. `percentile` is a numeric level from 0 to 100, required only for percentile rows; it can be fractional. `reported_label` preserves Q1, P33, etc. Keep a separately reported median or other summary with its actual label. Use `other` for meaningful additional reported summaries, not regression fit statistics or correlations. Include evidence for every value. Check for relevant summaries throughout the paper, including means in other tables or prose, before claiming no summaries are reported. No relevant descriptive table requires an explicit `not_reported` reason; no baseline models use `not_applicable`.

## Helpers

Add the frozen skill's `scripts` directory to Python's import path. `results_helpers` provides:

- `new_enrichment(base)`; `new_result_set(id,label,statistic_kind=None,alternative='unknown',df=None)`.
- `new_parameter(id,label,variable_ids,target_kind='predictor',estimate=None,statistic=None,statistic_kind='t',standard_error=None,p_value=None,marker=None,evidence=None,estimate_kind='coefficient')`.
- `new_descriptive_group(id,label,model_ids)`, `new_descriptive_variable(name,links,units,evidence)`, `statistic(name,value,evidence,percentile=None,reported_label=None)`, `variable_link(model_id,variable_id,relation='exact')`, `location(page,table,panel=None,column=None,page_end=None)`.
- `derive_statistics.context(kind,alternative='unknown',df=None,...)` constructs test metadata; `kind='wald_ratio'` enables the conventional SE-only rule while leaving its reference unknown. Fill evidence and explanatory notes. The constructor does not establish what the authors did.
- `model_result.source_quote(paper,page,needle)` locates literal source wording. It preserves numbers, signs and punctuation.

Run from the git workspace using the assigned frozen scripts:

```bash
python FROZEN/scripts/render_result_evidence.py PDF --page N --output EVIDENCE.png --bbox X0 Y0 X1 Y1
python FROZEN/scripts/derive_statistics.py REPORTED.json --specifications BASE.json --output RESULT.json
python FROZEN/scripts/validate_extraction.py RESULT.json --paper-text READING.json --base BASE.json --pdf PDF --workspace . --samples output/samples/sample_extractions.filtered.jsonl
```

Rendering also saves `EVIDENCE.evidence.json`. Load that object rather than typing its hashes manually. View the rendered crop before citing it. If the crop omits a header or legend, render and view another relevant region. Full-page regions are allowed for navigation but use sufficiently legible views for transcription. Images must remain inside the workspace. No OCR/network is used by these helpers.

The derivation helper also accepts full schema-2 or schema-3 JSON/JSONL without `--specifications` and preserves that input format. Raw enrichments emit schema 3 by default; `--schema-version 2.0` requests the internal legacy layout. The numerical core remains byte-preserved in `derive_statistics_v2.py`, so source calculation provenance remains verifiable. Output must differ from input. The validator recomputes calculations and rejects manual changes to derived fields. Preserve raw enrichment before calculating or merging.
