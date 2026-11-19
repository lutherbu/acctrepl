# Independent review: Richardson et al. (2005), Table 5C

## Scope and disposition

One retained scope was reviewed: `table5_panel_c_extended_multivariate` / `table5_panel_c_final_multivariate`, the final joint row of Table 5 Panel C. The delivered SAS construction and Stata cell are byte-for-byte the same as A1, and the sample declarations are unchanged. The coordinator's `reuse` command verified both inherited dataset hashes; A2 validation passes with one scope and no blocked fits. The reviewer checked the unchanged Fama–MacBeth calculation against A1's native SAS listing, Stata log, and four exported tables. The coordinator then ran the unchanged Stata cell in A2 runtime `20261103T002809825042Z` to populate the current attempt's required exports and execution record. It succeeded; all four table files are byte-for-byte identical to A1.

## Source and construction checks

The original paper's data section and footnote 8 (PDF physical pp. 15–17; journal pp. 451–453) prescribe 1962–2001, the SIC 6000–6999 exclusion, the required and optional Compustat items, and the shared Compustat–CRSP sample. Physical pp. 16–17 describe ROA, average-assets deflation, ±1 winsorization, and the future-return and delisting treatment. Table 5 Panel C (physical pp. 26–27; journal pp. 462–463) gives the retained equation and all signs. The coefficient comparison uses the final multivariate row only.

The provider's *Research Insight North America Data Guide* (local copy, physical p. 270 / printed p. 220, A12) confirms item 12 maps to `SALE`. The same guide's annual items map the other paper items as follows: 1=`CHE`, 4=`ACT`, 5=`LCT`, 6=`AT`, 9=`DLTT`, 32=`IVAO`, 34=`DLC`, 130=`PSTK`, 178=`OIADP`, 181=`LT`, and 193=`IVST`. This agrees with the exact `COMP.FUNDA` fields in the local catalog. Item 12 is a screen requirement, though it is not in the Table 5C equation.

The formulas in [build.sas](build.sas) use OIADP for both ROA terms and adjacent-year average assets: `(AT[t−1]+AT[t])/2` for current-year regressors and `(AT[t]+AT[t+1])/2` for ROA[t+1]. `COA=ACT−CHE`, `COL=LCT−DLC`, `NCOA=AT−ACT−IVAO`, `NCOL=LT−LCT−DLTT`, and `FINL=DLTT+DLC+PSTK`; each change is divided by current average assets. `DSTI` uses IVST/item 193 and `DLTI` uses IVAO/item 32. The model variables `−DCOL`, `−DNCOL`, and `−DFINL` are negated before estimation. All amounts are in Compustat millions and are deflated within a stable reporting currency, so the final inputs are dimensionless ratios.

The required current/prior fields and five zero rules match footnote 8. A bounded audit rejoined the final 127,722 rows to the exact prior/current/lead `COMP.FUNDA` records. No required field (items 1, 4, 5, 6, 12, 181, 178[t], or 178[t+1]) was missing. Missing optional item values were zero-filled only for 9, 32, 34, 130, and 193; their current/prior missing counts were respectively 26/32, 8,056/8,400, 546/478, 929/234, and 20,513/18,846. At least one of those zero rules applied to 31,070 final rows.

The audited raw formulas reproduce every handoff input after `max(−1,min(1,x))` winsorization: there were zero mismatches across all nine variables. No current or lead average-assets denominator was zero or nonpositive; the minima were 0.0345 and 0.118 Compustat millions. All three period currency codes agreed on every final row: 125,450 USD and 2,272 CAD. Three checks spanning early USD, 1987 CAD, and late USD rows confirmed that prior/current/lead currencies and actual fiscal dates agree. Because there are no absolute monetary regressors, no currency conversion is needed for these ratios.

The current-year anchor is joined to the prior and next records by exact `GVKEY` and `FYEAR±1`, with actual `DATADATE` retained. Source coverage includes fiscal-year 1961 lags and fiscal-year 2002 leads; final current dates span 1962-06-30 through 2002-05-31, with next-year data through 2003-05-31. The selected annual source has two `GVKEY/FYEAR` groups with distinct dates and no same-date duplicates; A1 explicitly retains the latest dated row in each such group. The final handoff has no duplicate `GVKEY/year` keys.

## SIC provenance and CRSP availability

The local CRSP guide documents `SICCD` as dated historical SIC and treats zero as unavailable; the build does not substitute header `HSICCD`. The date-effective fallback uses CCM `LC`/`LU`, `P`/`C` links valid at `DATADATE_t` and `DSENAMES` rows whose `NAMEDT/NAMEENDT` contain that date ([build.sas](build.sas), lines 214–229). The CCM join also preserves its documented open `.E` link ends (lines 220–229); the executed source audit found those open ends locally. An independent rejoin over the selected 309,336 annual anchors found no multiple eligible primary or secondary PERMNO candidates per anchor and no ambiguity in the selected SIC code. The alternative `COMP.CO_INDUSTRY` has no useful pre-1982 coverage and only 109–157 valid SIC rows/year in 1982–1986, so it cannot support the stated start.

The very large SIC disagreement is real in the local date-valid overlap, and the breakdown is material:

| Population | Both SIC sources valid | Exact 4-digit disagreements | Same first 2 digits | Different first 2 digits | Financial/nonfinancial disagreement |
| --- | ---: | ---: | ---: | ---: | ---: |
| Final handoff (127,722 rows) | 71,034 | 54,853 | 34,147 | 20,706 | 1,118 |
| All selected annual anchors (309,336 rows, including rows dropped by later screens) | 95,307 | 73,227 | 44,040 | 29,187 | 3,584 |

The audit reproduced the stored disagreement flag and source SIC on every final row. Final provenance is 72,187 `FUNDA.SICH` rows and 55,535 date-valid `CRSP.DSENAMES.SICCD` fallbacks. Among final overlap rows with both sources valid, all 1,118 financial-status disagreements are FUNDA nonfinancial / CRSP financial. The broader anchor set also contains the reverse pattern; those anchors are not the final or complete-case sample. The paper does not name an SIC provider or tie-breaking rule. The build's explicit best-effort choice is to prefer historical Compustat `SICH` and use dated CRSP SIC only when `SICH` is invalid or missing. Switching to CRSP for the retained overlap would drop 1,118 current rows; any compensating additions from the reverse disagreement direction have not been recalculated under every other screen. This remains an unresolved source-choice sensitivity, not evidence that the sample should be tuned.

The article says returns cover 12 months beginning four months after fiscal year-end, but it does not say the interval starts on the first day of a later calendar month. The code implements `[start,end)`, with `start=intnx('month',DATADATE_t,4,'same')` and `end=intnx('month',start,12,'same')`. Thus, a December 31 year-end starts on April 30 and includes April 30 through April 29 of the next year. This exact-day interpretation is now stated in [design.md](design.md); it does not claim a May–April month window.

The executed build screened on any complete eligible security, not on a CCM match alone. It joined all DSI market dates in the window to daily DSF returns, required nonmissing stock returns before delisting, accepted the paper's missing-DLRET = −100% rule for codes 500 and 520–584, then required `VWRETD` after an in-window delisting. No actual stock-return regressor was added to the retained accounting model. A1's native log shows 136,198 eligible GVKEY-year/PERMNO candidates, 34,337,188 expected DSI dates, 42,849,783 bounded DSF rows, and 34,337,188 matched expected-date rows; there were no duplicate `PERMNO/DLSTDT` keys. The annual return-completeness screen retains 127,722 rows, with no duplicate final firm-years. These link filters and the complete-window rule remain best-effort because the paper does not specify CCM link or security selection.

## Estimation and comparisons

The Stata cell uses direct annual OLS rank checks and `xtfmb` without a lag adjustment, weights, fixed effects, or firm clusters. The native annual `regress` results show 40/40 fits at rank 9/9 with positive residual degrees of freedom; annual N ranges from 625 to 5,814. The Fama–MacBeth output uses all 40 years and 127,722 observations. Table p-values are two-sided as required by the template; the paper reports t-statistics only for accrual terms and no exact p-values. No means or screens were adjusted to approach the published targets.

| Term | Published mean (t-statistic) | A1 mean (FMB SE; t-statistic) | Mean difference |
| --- | ---: | ---: | ---: |
| Intercept | 0.014 (not reported) | 0.0131 (0.0029; 4.56) | −0.0009 |
| ROA[t] | 0.801 (not reported) | 0.8099 (0.0068; 119.88) | +0.0089 |
| DCOA | −0.137 (−18.81) | −0.1255 (0.0074; −16.97) | +0.0115 |
| −DCOL | −0.178 (−18.13) | −0.1519 (0.0118; −12.85) | +0.0261 |
| DNCOA | −0.084 (−13.03) | −0.0765 (0.0062; −12.44) | +0.0075 |
| −DNCOL | −0.075 (−6.48) | −0.0568 (0.0141; −4.03) | +0.0182 |
| DSTI | 0.004 (0.10) | 0.0036 (0.0356; 0.10) | −0.0004 |
| DLTI | −0.084 (−6.33) | −0.0708 (0.0093; −7.61) | +0.0132 |
| −DFINL | −0.056 (−8.17) | −0.0455 (0.0073; −6.23) | +0.0105 |

The paper's adjusted R² is 0.595; A1's mean annual adjusted R² is 0.636711 (exported as 0.637), and its average R² is 0.638. The published aggregate sample is 108,617 firm-years; the local sample is 127,722, 19,105 higher (17.6%), across 14,509 GVKEYs. The local count is an observed discrepancy, not a target or proof of a vintage effect. Annual filters, local selectors, the SIC source choice, and the unspecified return-link rule remain plausible explanations; the available diagnostics do not attribute the gap to a single cause.

Table 4 Panel A (PDF physical pp. 22–23; journal pp. 458–459) also reports same-variable means and standard deviations for the full published sample. Its descriptive-table winsorization status is not stated. The local values below are the final ±1-winsorized analysis inputs, with liability means sign-reversed to match Table 5C's regressors.

| Variable | Published mean / SD | Local mean / SD | Δ mean |
| --- | ---: | ---: | ---: |
| ROA[t+1] | 0.063 / 0.177 | 0.0404 / 0.2061 | −0.0226 |
| ROA[t] | 0.070 / 0.175 | 0.0488 / 0.2067 | −0.0212 |
| DCOA | 0.047 / 0.133 | 0.0483 / 0.1392 | +0.0013 |
| −DCOL | −0.025 / 0.084 | −0.0264 / 0.0912 | −0.0014 |
| DNCOA | 0.057 / 0.153 | 0.0618 / 0.1695 | +0.0048 |
| −DNCOL | −0.006 / 0.047 | −0.0056 / 0.0480 | +0.0004 |
| DSTI | 0.006 / 0.096 | 0.0100 / 0.1200 | +0.0040 |
| DLTI | 0.003 / 0.046 | 0.0033 / 0.0515 | +0.0003 |
| −DFINL | −0.030 / 0.151 | −0.0264 / 0.1705 | +0.0036 |

## Repairs, current files, and limits

The only production change in A2 is the documentation correction in `design.md` that spells out the return-window day/month boundary already implemented in A1. No construction code, sample declaration, Stata code, or estimation changed; there is no old/new coefficient impact. The bounded review audit is retained as `review_audit.sas` with aggregate-only output in `review_audit/`. A2 reuses the hash-verified A1 SAS handoff and has its own successful Stata execution in `runtime/20261103T002809825042Z`; its exports are identical to A1.

Current assigned files include `build.sas`, synchronized `sas.ipynb`, `stata.ipynb`, `stata.template.ipynb`, `submission.json`, `design.md`, `review.md`, the hash-verified `data/compustat_108617/{reg.sas7bdat,reg.dta}`, and the bounded SIC/formula audit. One scope is reviewed and unblocked. The unresolved assumptions are the annual selectors/duplicate-date choice, adjacent-period asset averaging, historical SIC preference, and exact CRSP link/return-completeness definition; the local-versus-published sample-size and moment differences remain unexplained by the present diagnostics.
