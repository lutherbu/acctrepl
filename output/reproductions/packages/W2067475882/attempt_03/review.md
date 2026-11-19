# Independent review: Model (I), one-year pooled sample

## Sources checked

I checked the original paper at physical PDF pp. 6–9 (journal pp. 52–55), especially the Model (I) equation and sales-decrease definition (pp. 6 and 9), source screens (p. 7), trimming rule (p. 8), and Table 2 (p. 9). The paper's one-year model uses log changes in annual SG&A and sales with a sales-decrease interaction, OLS, and 1979–1998 data. The source screen requires nonmissing current/prior SG&A and sales and excludes current SG&A above sales. The paper reports 64,663 source-screened firm-years and 63,958 after trimming.

The assigned catalog identifies `COMP.FUNDA` as the source and labels `curcd` “ISO Currency Code” and `currtr` “Currency Translation Rate.” I checked the provider's *S&P Research Insight North America Data Guide*, physical p. 71 (printed p. 21), which defines CURRTR/A228 as the exchange rate used to translate foreign currency amounts into USD at the balance-sheet date. The page does not state whether to multiply or divide a reported amount by the rate. The page extract is retained in `scratch/compustat_currency_guide_p71.txt`.

I also reviewed A2's build, design, Stata log, and exports. A2 used raw ratios across every adjacent year, including differing CURCD pairs. Its saved handoff has 58 such pairs among 109,388 source-screened rows; 51 were in A2's 107,619-observation trimmed fit.

## Currency finding and repair

The A3 build retains the same source selection and original paper screens. It carries current/prior `curcd` and `currtr`, checks adjacent-year unit status before deriving any baseline variable, and preserves raw amounts and source codes in the native handoff. The current-period `SG&A <= sales` screen compares two amounts from the same annual row and reported currency, so it remains unchanged. Positive values remain required for the logs.

Across all 194,018 current-year/source-pair rows before the paper screens, SAS finds 136 adjacent-year CURCD changes. None of those pairs has a missing or nonpositive CURRTR on either side. Among the 109,388 source-screened rows, 109,330 pairs have the same CURCD and 58 differ: 49 CAD-to-USD and 9 USD-to-CAD. In the first group, lagged CAD CURRTR ranges from 1.0000 to 1.4286 (mean 1.0087) while current USD CURRTR is 1.0000; in the second group both rates are 1.0000. These values do not establish the rate's quote direction or a safe arithmetic rule for this table. I therefore leave all 58 unlike-currency ratios and the associated sales-decrease comparisons unavailable, as authorized, rather than guessing a conversion. All 109,330 same-currency rows retain their original ratios and decrease classifications exactly. No baseline controls use monetary variables.

The 58 unavailable rows remain in the source-screened SAS handoff with their amounts, codes, rates, and currency status, but have missing model variables and `trimflag=0`. The pooled 0.5/99.5 percentile cutoffs are recomputed on the 109,330 unit-verified rows. This leaves 107,562 observations in the final fit: 57 fewer than A2. Of these, 51 are the unlike-currency rows that A2 included; six same-currency rows no longer fall within the recalculated cutoffs. Seven unlike-currency rows were outside A2's trimmed fit already. No sample choice was made to match the paper.

## Estimates and paper comparison

Coefficients below are in log-change units (dimensionless); N counts firm-years. Stata's ordinary log has the unrounded estimates and t-statistics. The four exports display coefficients to three decimals. Table 2 reports coefficients to four decimals and t-statistics. Its baseline table does not state whether those t-tests are one- or two-sided. The A3 exports follow the template and report two-sided p-values; the sign and two-sided significance of the interaction still support the paper's negative-asymmetry finding.

| Estimate | Published Table 2 | A2 raw-unit fit | A3 unit-verified fit |
|---|---:|---:|---:|
| Observations | 63,958 | 107,619 | 107,562 |
| Intercept | 0.0481 (t = 39.88) | 0.0451848 (t = 51.54) | 0.0452445 (t = 51.60) |
| Log sales change, β₁ | 0.5459 (t = 164.11) | 0.5817312 (t = 215.96) | 0.5813068 (t = 215.69) |
| Decrease interaction, β₂ | −0.1914 (t = −26.14) | −0.0587447 (t = −9.29) | −0.0584407 (t = −9.23) |
| Adjusted R² | 0.3663 | 0.4090 | 0.4085 |

For A3, Stata reports two-sided p-values below 0.001 for all three coefficients. A one-sided test of the source's stickiness condition, β₂ < 0, also rejects at p < 0.001; the export keeps the requested two-sided p-value presentation. The currency-unit repair changes the coefficients only slightly, but the published interaction remains materially more negative. The local Compustat vintage and population are not confirmed to match the paper's 1999 PST/full-coverage files, and the historical item-number crosswalk and operational industrial-firm screen remain unresolved. These limitations prevent a numerical match; no further adjustment is supported by the source.

## Execution and deliverables

The final `sync` and `validate` completed without warnings. The final SAS construction and native SAS-to-Stata handoff completed successfully in `runtime/20261102T160837273752Z/`; the template cell `model_i_one_year` completed successfully in `runtime/20261102T160909269402Z/`. I verified that `tables/table2_model_i_one_year.md`, `.rtf`, `.csv`, and `.tex` all contain N = 107,562 and the same rounded coefficient values.

The first A3 SAS execution is retained in `runtime/20261102T160301982304Z/`; SAS returned 1 because the `SG&A` label triggered an unresolved macro-reference warning. The label was corrected. An intermediate successful run is retained at `runtime/20261102T160615378793Z/`; its currency-rate diagnostics prompted the conservative unavailable construction documented above, and the final SAS/Stata stages were rebuilt and rerun. A2 and all shared files remain untouched.

## Coordinator closeout

After the final sample description changed, the coordinator reran the unchanged scientific code in `runtime/20261102T162031656011Z/` so execution hashes match the final declaration. All four regression table exports are byte-identical to the earlier final Stata run. A3 was then accepted.
