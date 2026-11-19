# Check raw observation dates before bundling inputs

For every eligible work item, write the file named in temporal_audit_path. Start
with the temporal-template command. It lists supporting-model outcomes and
predictors separately; --include-baseline also lists baseline variables. Retain
all supporting observed variables and add rows for baseline inputs with lags,
leads, average denominators, rolling windows or event-to-fiscal-year alignment.
Rows can share a calculation only when their raw dates are identical.

The audit has paper_id, baseline_timing_review and records. The timing review
explains the date basis of the selected baseline and identifies nontrivial
transformations. For each record supply model_id, variable_id, requirement_ids,
anchor_begin, anchor_end, anchor_basis, evidence_ids, non_data_reason, and the
four components printed by the template. Each component has lookback_months,
lead_months and reason. Months are nonnegative integers; use null for an unknown
offset. Explain zero offsets too. Pure parameters may use non_data_reason only
when the assessment already identifies them as non-observed inputs.

Read each supporting outcome and predictor definition before filling its row:

- sample_offset moves the original sample/event anchor to the analyzed observation.
- support_fit_window adds the estimation/history window used by a supporting fit.
- variable_lag_or_lead adds the individual variable’s own offset within that fit.
- scaling_or_fiscal_alignment adds raw denominator history and event-to-fiscal
  alignment that the other stages do not already include.

A prior-period predictor needs raw data earlier than the first dependent-variable
observation in the supporting fit, unless the source explicitly includes that
predictor history in its stated raw window. Do not silently absorb that lag into
“ten-year history” or another fit-window label. Likewise, a lagged scaled measure
may need both the measure’s lag and its denominator’s history.

Inspect normalization inside a rolling measure: each observation's own lagged
denominator can extend the raw window further. A common denominator evaluated at
the current baseline date has different timing. Split raw-component rows when
their windows differ; do not apply the longest lag indiscriminately to all fields.

For a calendar-dated event, the fiscal year containing it can end in the next
calendar year; the following fiscal year can end another year later. Identify
whether an anchor denotes a calendar year, fiscal-year label, actual fiscal-year
end, announcement date or posting date before applying a year offset.
Required coverage bounds for dated raw records refer to calendar years of the actual source date field (for example DATADATE, filing date or return DATE), not an analytical year bucket or a fiscal-year label. State the mapping before computing offsets. Add an alignment offset only when that mapping is established from the paper or source-date documentation; the word fiscal alone does not justify an extra year at either end. If the mapping is unresolved, keep actual raw-calendar bounds/offsets null and describe the known nominal period and mapping gap separately. If bucket y covers dates in calendar y-1 and y, its raw envelope needs the earlier calendar year. A verbal cutoff does not replace that alignment in the calculation. For a discrete rolling window, enumerate the first and last included year labels for each horizon before converting to raw dates; do not count the endpoint gap twice.

An annual report's fiscal-year label is not its filing year. For non-December
year ends a report can be filed in the same calendar year; a conservative filing
envelope can retain the first fiscal year while extending the last year for the
filing delay. State late-filing uncertainty rather than shifting both endpoints.

Run window with all source-supported components, then use their union for each
shared raw requirement. Keep unknown anchors/endpoints or offsets null. A
hypothetical post period is not the observed final period. Split rows or raw
requirements when different components need different dates. Do not invent exact
raw bounds merely to fill a number.

Intersect event-relative windows with explicit source-cohort cutoffs before
setting the observed anchor interval. A truncated event window does not require
unobserved future cohort records. Apply genuine construction lags/leads to the
resulting included observations separately. Forecast estimation inputs likewise
depend on realized historical training rows, not unavailable future outcomes at
the forecast origin.

The finalizer requires this audit, checks supporting-variable coverage and source
links, calculates the offsets in Python, and rejects a requirement that starts
after a computed raw beginning or ends before a computed raw end. It cannot infer
an omitted source offset: the per-variable source check is essential. The audit
file/hash is included in output provenance and replayed during validation.

When no supporting fit or nontrivial baseline offset exists, an empty records
array with a specific baseline_timing_review is sufficient. Papers with no
baseline regression do not require an audit.
