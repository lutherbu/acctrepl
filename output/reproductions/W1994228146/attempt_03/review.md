# Independent review and repair: W1994228146, Table 3 Equation (2)

## Finding and repair

The assigned scope is `table3_eq2_h1` / `table3_eq2_panel_a`: annual cross-sectional regressions for 1964–1993, with the coefficient comparison and annual tests in Table 3 Panels B and C. I checked the paper's sample and measurement discussion (physical PDF pp. 5–8; printed pp. 357–360) and Table 3 (physical PDF p. 11; printed p. 363). The paper reports 32,961 firm-years across 30 regressions. It averages annual coefficients and adjusted R-squared; the coefficient t-statistics use the mean and standard deviation of 30 annual estimates. Table 3 reports a GrLTNOA-versus-ACC equality-test t-statistic of 1.65 (p=0.11) and annual counts of 7/20/3 at the two-sided 1% level.

Attempt 2's CCM filter and joins compared `LINKENDDT` directly with ordinary dates. Under SAS ordering, `.E` is below ordinary dates, so those ongoing links were removed. Attempt 3 now allows provider-coded open start/end endpoints in the support-window filter and both effective-date joins, while retaining the original inclusive comparisons for finite dates. The link type and primary-link restrictions (`LC`/`LU`, `P`/`C`), CRSP month selection, `max(1)` firm-period collapse, and duplicate-key rules are unchanged. No open or finite date rule changes the Compustat lag/lead joins or the model construction.

The WRDS examples indexed in `output/reproduction_runs/resource_documentation.json` identify `.B`/`.E` and missing CCM endpoints as open boundaries. The exact local audit in `output/reproduction_runs/preflight/ccm_date_boundaries.json` reports 92,711 link rows, 14,750 `.E` end dates, and no missing or special start dates. Among P/C LC/LU links, 1,179 open-end rows overlap 1963–1994; this is a candidate-link count, not the number of affected observations.

Before rebuilding the source data, I ran the revised predicates on bounded synthetic SAS data. The smoke retained four links overlapping the support window, matched the `.B`/`.E` interval and an inclusive finite interval at the test date, rejected links starting after or ending before the test date, and produced one collapsed firm-period price-presence row from two qualifying securities. The log records the assertion pass at `scratch/ccm_date_boundary_smoke.log`.

## Construction and eligible-key changes

The full build used the same catalog-listed sources and unchanged construction as attempt 2. `FUNDA` still contributes 220,451 filtered records / 20,658 GVKEYs; two ambiguous GVKEY-year keys (two extra rows) are excluded, leaving 220,447 unique annual records. The regression construction still has 205,708 anchors, 180,157 ordered lag/lead pairs, 180,030 same-currency windows, and 118,935 complete accounting constructions. The direct and expanded GrLTNOA formulas still agree over 118,935 rows to a maximum absolute difference of 1.14e-13. The `BSPR=GB` and observed goodwill-increase counts remain 21,640 and 3,310.

| Diagnostic | Attempt 2 | Attempt 3 | Change |
| --- | ---: | ---: | ---: |
| CCM support links | 16,323 | 17,502 | +1,179 |
| Firm-period CRSP presence keys | 119,482 | 134,717 | +15,235 |
| CRSP price/share at t−1 | 102,548 | 115,719 | +13,171 |
| CRSP price/share at t | 112,806 | 126,906 | +14,100 |
| CRSP price/share at t+1 | 114,293 | 128,940 | +14,647 |
| Price/share at all three anchors | 92,279 | 105,304 | +13,025 |
| Final eligible firm-year keys | 59,614 | 67,585 | +7,971 |

I compared the attempt 2 and attempt 3 native `reg.dta` keys. All 59,614 earlier eligible `(GVKEY, year)` keys remain; all their exported values are identical. Attempt 3 adds 7,971 keys and removes none. The new keys belong to 640 GVKEYs and all have price/share presence at t−1, t, and t+1 under the corrected join. The increase follows from the boundary repair; no other population, construction, exclusion screen, or estimation rule changed. The actual annual counts are:

| Fiscal year | A2 N | A3 N | Added |
| ---: | ---: | ---: | ---: |
| 1964 | 109 | 119 | 10 |
| 1965 | 153 | 165 | 12 |
| 1966 | 188 | 201 | 13 |
| 1967 | 253 | 269 | 16 |
| 1968 | 302 | 321 | 19 |
| 1969 | 425 | 455 | 30 |
| 1970 | 1,455 | 1,615 | 160 |
| 1971 | 1,586 | 1,756 | 170 |
| 1972 | 1,620 | 1,798 | 178 |
| 1973 | 2,251 | 2,483 | 232 |
| 1974 | 2,674 | 2,979 | 305 |
| 1975 | 2,770 | 3,078 | 308 |
| 1976 | 2,724 | 3,034 | 310 |
| 1977 | 2,624 | 2,942 | 318 |
| 1978 | 2,521 | 2,836 | 315 |
| 1979 | 2,460 | 2,768 | 308 |
| 1980 | 2,418 | 2,725 | 307 |
| 1981 | 2,417 | 2,724 | 307 |
| 1982 | 2,585 | 2,914 | 329 |
| 1983 | 2,571 | 2,912 | 341 |
| 1984 | 2,740 | 3,102 | 362 |
| 1985 | 2,703 | 3,088 | 385 |
| 1986 | 2,730 | 3,132 | 402 |
| 1987 | 2,826 | 3,245 | 419 |
| 1988 | 2,808 | 3,232 | 424 |
| 1989 | 2,427 | 2,803 | 376 |
| 1990 | 2,401 | 2,785 | 384 |
| 1991 | 2,390 | 2,814 | 424 |
| 1992 | 2,433 | 2,874 | 441 |
| 1993 | 2,050 | 2,416 | 366 |
| **Total** | **59,614** | **67,585** | **7,971** |

Every year remains covered, with annual N increasing from 109–2,826 in attempt 2 to 119–3,245 in attempt 3. The increase is not a match to the published sample target: the repaired N is 67,585 versus 32,961.

## Repaired regression and source comparison

The fresh attempt 3 build produced `data/main.sas7bdat`, and the coordinator handoff created `data/reg.dta`. Native Stata `xtfmb` with its default, no-`lag()` covariance estimated all 30 annual periods. This default uses the full covariance across coefficient series, so the GrLTNOA/ACC contrast is supported; the package's separate lag-option diagonal-covariance path is not used. All 30 annual OLS diagnostics and equality tests succeeded; there were zero failed fits and zero missing annual tests. I retained the same complete accrued-earnings/growth algebra, all supporting financial history, screens, Fama–MacBeth scope, and covariance choice from attempt 2. No coefficient or sample target was used for selection.

| Equation (2) term | Attempt 2 coefficient (t) | Repaired attempt 3 coefficient (t) | Paper coefficient (t) |
| --- | ---: | ---: | ---: |
| GrLTNOA | −0.0294 (−3.40) | −0.0364 (−4.33) | −0.04 (−5.25) |
| ACC | −0.0838 (−8.72) | −0.0857 (−9.10) | −0.06 (−5.61) |
| ROA | 0.8042 (67.29) | 0.8212 (67.26) | 0.79 (54.42) |
| Intercept | 0.0097 (3.37) | 0.0107 (3.96) | 0.02 (10.75) |
| Average adjusted R-squared | 0.592 | 0.624 | 0.62 |
| Firm-year observations | 59,614 | 67,585 | 32,961 |

The repaired GrLTNOA-minus-ACC contrast is 0.04925 (t=5.18, two-sided p=0.00001554), still rejecting equal slopes; attempt 2 reported t=5.97, p=0.000001745. The paper reports t=1.65, p=0.11 and does not reject. Attempt 3 Panel C counts at two-sided p<0.01 are 11 years with `ACC < GrLTNOA`, 19 with equality not rejected, and 0 with `ACC > GrLTNOA`; the paper reports 7/20/3. The notebook preserves the assigned template's coefficient p-values in parentheses; t-statistics above are from the native Stata log. The corrected link coverage changes the sample and estimates but does not close these research-result differences.

The table's coefficient rows and R-squared values were checked in all four exports (`.md`, `.rtf`, `.csv`, `.tex`); each reports N=67,585 and average/adjusted R-squared 0.625/0.624. The descriptive exports also report the current 67,585-observation sample. The Stata run is current to the repaired dataset hash in `runtime/latest.json`.

| Variable | Attempt 3 mean (SD; median) | Paper Table 1 mean (SD; median) |
| --- | ---: | ---: |
| ROA_(t+1) | 0.070 (0.200; 0.091) | 0.111 (0.110; 0.107) |
| ROA_t | 0.076 (0.190; 0.093) | 0.114 (0.112; 0.109) |
| ACC_t | −0.025 (0.118; −0.029) | −0.020 (0.101; −0.027) |
| CFO_t | 0.101 (0.198; 0.119) | 0.134 (0.132; 0.135) |
| GrNOA_t | 0.060 (0.190; 0.050) | 0.070 (0.158; 0.055) |
| GrWC_t | 0.020 (0.111; 0.013) | 0.024 (0.095; 0.014) |
| DEPAMORT_t | −0.045 (0.035; −0.038) | −0.044 (0.029; −0.038) |
| GrLTNOA_t | 0.086 (0.146; 0.063) | 0.090 (0.117; 0.068) |

## Remaining limits

The unchanged fidelity limits are the current Compustat/CRSP vintage rather than Compustat 2000 / CRSP 2001; absent voluntary-accounting-change footnote detail in the selected local fields; the unresolved historical mapping of paper goodwill item 240 (the current semantic `GDWL` field remains the same best-effort proxy); and the unspecified exact CRSP monthly price date rule. These limits do not undo the demonstrated link-boundary effect, and the remaining sample and coefficient differences are not attributed to a single cause.
