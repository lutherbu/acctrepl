# Independent review: W3122987060, attempt 03

## Execution and scope coverage

The frozen assignment contains eight regression scopes: Equation (11), Table 2, for k=0 through 6, and Equation (12), Table 3 Panel A. All eight executed; none were blocked. The final coordinator run is `runtime/20261102T211401461112Z`. The SAS construction and native Stata handoff succeeded, and the `agg_earnings_lags`, `cf_components`, and `sample_descriptives` cells all completed successfully. Each regression and descriptive table has `.md`, `.rtf`, `.csv`, and `.tex` exports. The bounded SAS-to-Stata smoke used eight synthetic rows and passed assertions for separate sales and security currencies, GBP/CAD FX conversions, unavailable incoherent FX routes, blank/AR per-leg rate provenance, and a missing-XIDOC CF remaining unavailable.

The declared `cashflow_pred` sample and the frozen model/result-set IDs were retained. The core k=0–2/Table 3 sample is common, and k=3–6 use fit-specific earnings-history eligibility.

## Source review and repairs

I checked the original paper PDF on physical pages 10–17 and 26, including the equations, sample rules, Table 1 notes, Tables 2 and 3A, and the separate fixed-effects sensitivity model. The paper defines CF as #308/OANCF minus #124/XIDOC, excludes SIC 6000–6999, and gives the $10 million sales and $1 share-price screens, pooled 1% tail and studentized-residual rules, and the requirement that the primary sample support Equation (11) k=2 and Equation (12). It does not define a missing-zero rule for XIDOC or name the price mnemonic.

Two demonstrated defects in attempt 02 were repaired:

- **Dollar screens.** Attempt 02 applied the $10 million and $1 thresholds to reported values without confirming their currencies. Attempt 03 translates annual sales to USD with catalog-listed `COMP.G_EXRT_MTH.EXRAT12M`, the flow rate. For non-USD, non-GBP amounts it uses the provider's GBP cross-rate formula, USD leg divided by the source-currency leg, with both positive unique legs on one quote date. It selects the latest quote date no later than the actual `datadate` within 31 days. GBP uses one observed GBP→USD quote with an identity source leg; USD uses direct identity without an observed FX quote. A missing or ambiguous observed route leaves the USD amount unavailable.

  The paper does not name its price field. The build retains `PRCC_F` as the best-effort annual fiscal-close price proxy, and independently verifies its currency through the most recent `COMP.SEC_MTH.PRIMISS='P'` marker and the latest `COMP.SEC_DPRC` quote for that IID no later than the annual `datadate` and at most seven days earlier. It uses `CURCDD` on that daily quote. USD uses identity; GBP requires one observed GBP→USD quote; other foreign prices require both positive, unique GBP cross-rate legs on the same price date. The price is converted with daily `EXRATD` at the quote date. `EXRATTPD` is recorded per observed leg as quote provenance; it is not treated as a unit or used to discard positive known-currency quotes. Of 174,564 unique annual source rows, 104,712 received a verified USD price route. In the provenance frequency, both type fields were blank on 9,750 routes and both were `AR` on 94,962. The blank/blank count includes identity-price routes with no observed FX legs; it does not mean every row has two quotes with blank provenance.

  The post-build issue audit is in `scratch/price_issue_audit.sas`, with aggregate output in `scratch/price_issue_audit.lst` and the SAS log beside it. I reproduced the annual-key deduplication, compared `FUNDA.IID` with the unique dated `SEC_MTH.PRIMISS='P'` IID, and flagged membership in the actual 10,500-row analysis sample. The local SAS catalog identifies `COMP.FUNDA.IID` as “Header Primary Global Issue ID” (`/storage/sas/data_description.txt`, `COMP.FUNDA` PROC CONTENTS, p. 566, variable row #921). The final sample has 9,853 equal IID pairs and 647 differing pairs, with no missing FUNDA.IID or ambiguous primary marker. All 10,500 rows have a unique dated daily quote for the selected primary IID. Of these, 10,496 also have a same-date `SEC_MTHPRC` monthly quote; daily `CURCDD` and monthly `CURCDM` agree on all 10,496. Annual `PRCC_F` is within $0.005 of that same-date primary-IID monthly `PRCCM` on 10,495 of 10,496 rows: all 9,849 equal-IID rows and 646 of the 647 differing-IID rows. The remaining row differs in price value by $1.375, but its daily and monthly primary-IID currencies agree. The four rows without a monthly quote are equal-IID cases; each still has the unique dated daily quote and known currency/FX route used by construction. The price-value comparison is a diagnostic, not a price-equality screen.

  This evidence supports use of the selected dated primary issue's currency for the annual `PRCC_F`, even when the annual header IID differs. The source catalog label is at `COMP.FUNDA` PROC CONTENTS p. 566; the current `COMP.SEC_MTHPRC` schema is issue-level (`gvkey`, `iid`, `datadate`, `curcdm`, `prccm`). The cached 2004 guide discusses primary-only monthly market data for its legacy company-level series at physical p. 587/printed p. 537 and physical p. 643/printed p. 593; that description does not by itself establish the current issue-level mapping. The exact-date current-data comparison above supplies that evidence. In the 647 differing-IID rows, only 27 have a monthly FUNDA-IID quote; the median `PRCC_F`/same-IID monthly-close ratio is 1.034, versus 1.000 for the selected primary-IID monthly close. Seven rows with both issue currencies observed in daily quotes have FUNDA-IID currency USD and selected-primary currency CAD. In all seven, the primary daily and monthly currency records agree. The monthly-price comparison is diagnostic; the production threshold applies to annual `PRCC_F`, converted using the dated primary-IID daily currency/FX route. The guide defines annual PRCCF as the fiscal-year-end close adjusted for fiscal-year splits and stock dividends (physical p. 674/printed p. 624); the lone $1.375 value difference is not treated as a currency conflict.

- **Missing XIDOC.** Attempt 02 treated missing #124/XIDOC as zero whenever OANCF was observed. Attempt 03 follows the paper's `OANCF-XIDOC` definition and makes CF unavailable if either input is missing. In the selected domestic annual source rows, 303 of 82,639 observed OANCF values have missing XIDOC. The pre-tail audit identifies 83 rows otherwise complete for the primary k=2/Table 3 requirements and USD screens that are unavailable through missing current or lead XIDOC; these are candidate losses before percentile and residual screens, not a claim that all 83 would survive the later screens. A broader prior audit found 384 missing XIDOC values among 113,560 OANCF observations; neither count supports zero imputation.

A SAS route-building omission found while checking the first construction was also corrected before the final run: the converted sales route now carries `sale` into the USD amount calculation. The final construction log has no SAS errors or uninitialized-variable warnings. The price provenance frequency is restricted to verified routes.

Other reviewed construction choices were retained. Rows join on GVKEY and exact fiscal year; the actual DATADATE span reaches May 31, 1998 even though the last fiscal-year label is 1997. Duplicate `(gvkey,fyear)` records are ranked by completeness with latest `datadate` as a tie-break, as in A2; two duplicate groups occur in FY1982–1983 and do not alter the 1987–1996 primary origins. For FY1981–1997 adjacent-year pairs, 120 have changed `CURCD` and none have a missing code when a prior record exists. Cross-year monetary differences and average-assets denominators still require equal, known adjacent-year currency codes; no unsupported FX adjustment is introduced there.

The item mappings and signs remain consistent with the paper and the cached Compustat Research Insight guide: #302/RECCH and #303/INVCH are reversed to make increases positive, #304/APALCH is used directly, and balance-sheet fallbacks use matched adjacent years and identical known currency. Depreciation remains #103/XDP, distinct from #14/DP and DPC. The guide identifies XDP as ending collection in January 1997 (physical p. 707, printed p. 657); it does not justify generic zero filling or substitution. The build retains the stated depletion SIC exceptions for the AMORT fallback. In the selected source, XDP is present for 1,142/11,899 FY1994 rows, 415/12,492 FY1995 rows, and 92/12,624 FY1996 rows. The resulting sparse late-year component coverage is preserved and remains a limitation.

Source references: the paper's equations and prediction horizon (physical p. 10), sample screens (p. 11), item mapping/fallbacks (p. 13), Table 2 (p. 14), Table 3 Panel A and Panel B distinction (pp. 16–17), and pooling discussion (p. 26); Compustat guide items #65, #103, #124, #174, #302–#304, and #308 at the physical pages listed in `design.md`; currency and price-rate definitions at Xpressfeed physical pp. 86–89 (printed pp. 78–81); the annual PRCCF definition at physical p. 674/printed p. 624; and primary/joiner coding in the cached CRSP/Compustat guide physical p. 9. The local catalog's current fields are recorded by exact table and variable; see the FUNDA.IID label and SEC_MTHPRC schema cited above.

## Table 2: aggregate earnings results

Coefficients are dimensionless. Attempt 03 p-values use conventional two-sided pooled OLS inference; the paper reports t-statistics but does not specify the tail convention. A3 estimates below are ordered current EARN then included annual lags. The paper's coefficients and t-statistics are transcribed in the same order.

| Fit | A3 N / adj. R² | Paper N / adj. R² | A3 coefficients (two-sided p) | Paper coefficients (t-statistics) |
|---|---:|---:|---|---|
| k=0 | 10,500 / .188 | 10,164 / .15 | .459 ( <.001 ) | .42 (42.98) |
| k=1 | 10,500 / .198 | 10,164 / .16 | .390 (<.001), .106 (<.001) | .35 (30.31), .12 (11.59) |
| k=2 | 10,500 / .201 | 10,164 / .17 | .379 (<.001), .080 (<.001), .058 (<.001) | .33 (29.06), .07 (6.60), .10 (9.84) |
| k=3 | 9,868 / .209 | 9,250 / .18 | .375 (<.001), .079 (<.001), .042 (<.001), .041 (<.001) | .33 (27.47), .08 (7.03), .07 (5.47), .06 (5.32) |
| k=4 | 9,311 / .212 | 8,491 / .18 | .373 (<.001), .081 (<.001), .038 (<.001), .036 (<.001), .021 (.016) | .33 (25.98), .08 (6.33), .07 (5.28), .05 (3.99), .03 (2.47) |
| k=5 | 8,755 / .212 | 7,821 / .19 | .369 (<.001), .077 (<.001), .034 (.001), .036 (.001), .009 (.401), .035 (<.001) | .33 (24.22), .09 (6.74), .06 (4.30), .05 (3.43), .02 (1.14), .04 (3.31) |
| k=6 | 8,166 / .216 | 7,213 / .19 | .368 (<.001), .081 (<.001), .033 (.002), .032 (.003), .009 (.418), .015 (.175), .034 (<.001) | .33 (22.82), .09 (6.08), .06 (4.17), .04 (2.92), .01 (.92), .04 (2.51), .02 (1.94) |

All current-EARN estimates are positive and significant at p<.001. Most included lag coefficients are positive and significant; the A3 fourth lag is not significant in k=5 or k=6, and the fifth lag is not significant in k=6. Relative to the paper, A3's current-EARN slopes are larger across the fits, while several higher-lag coefficients and significance levels differ. These are observed estimates, not a reason to change the sample or specification.

A3's k=0–2 sample is 359 observations smaller than A2's 10,859; A3 k=3–6 are smaller by 339, 315, 291, and 270 observations, respectively. Relative to the paper, A3 remains 336 observations larger at k=0–2; the excess rises to 618, 820, 934, and 953 at k=3–6. The A3 primary complete-case population has 11,012 observations before the pooled 1% tail screen, 10,646 observations in the studentized-residual regression, and 10,500 after 146 absolute-residual exclusions. The changed currency screens and missing-XIDOC rule both affect eligibility, but the current diagnostics do not identify an exact non-overlapping A2-to-A3 count decomposition or a definitive cause for the remaining gap. No vintage attribution is inferred.

## Table 3 Panel A and actual-sample descriptives

All Table 3 signs match the paper's predictions. A3 uses 10,500 observations, R² .3773, and adjusted R² .3769, compared with paper N=10,164 and adjusted R²=.35.

| Term | A3 coefficient (t; two-sided p) | Paper coefficient (t-statistic) |
|---|---:|---:|
| Constant | .016 (11.65; <.001) | .01 (7.89) |
| CF(t) | .641 (69.38; <.001) | .59 (61.34) |
| ΔAR(t) | .456 (28.73; <.001) | .42 (28.10) |
| ΔINV(t) | .337 (20.11; <.001) | .35 (21.75) |
| ΔAP(t) | −.521 (−27.55; <.001) | −.56 (−28.58) |
| DEPR(t) | .278 (12.97; <.001) | .42 (16.39) |
| AMORT(t) | .261 (2.89; .004) | .47 (11.05) |
| OTHER(t) | .227 (16.18; <.001) | .15 (10.54) |

AMORT remains positive and significant under A3's two-sided OLS calculation, but its estimate and t-statistic are much lower than the published values. DEPR is also materially smaller. The other component slopes are directionally consistent, with their numerical differences retained as results.

The descriptive statistics below come from the actual 10,500-row A3 analysis sample. Paper values are reported to two decimals.

| Variable | A3 mean / median / SD | Paper mean / median / SD |
|---|---:|---:|
| EARN | .038 / .044 / .074 | .04 / .04 / .08 |
| CF | .093 / .093 / .078 | .08 / .09 / .08 |
| ACCRUALS | −.055 / −.054 / .075 | −.04 / −.04 / .08 |
| ΔAR | .013 / .008 / .045 | .01 / .01 / .05 |
| ΔINV | .009 / .002 / .040 | .01 / .01 / .05 |
| ΔAP | .011 / .007 / .040 | .01 / .01 / .04 |
| DEPR | .055 / .049 / .030 | .05 / .04 / .03 |
| AMORT | .002 / .000 / .007 | .01 / .00 / .02 |
| OTHER | −.010 / −.006 / .046 | −.01 / −.01 / .05 |

The means retain the paper's sign pattern. At the paper's displayed precision, A3 also differs in the EARN standard deviation, the CF and ACCRUALS means, ACCRUALS median, the inventory median and standard deviation, the DEPR median, and the AMORT mean and standard deviation. These are descriptive differences in the realized samples, not reasons to change the screens or item mappings.

## Remaining limitations and audit trail

The paper does not identify the baseline covariance estimator, residual-generating regression, whether percentile cutoffs are pooled or year-specific, the lead-outcome denominator timing, or the exact share-price mnemonic. This attempt uses pooled OLS with conventional unclustered errors, pooled tail cutoffs, Equation (11) k=2 external studentized residuals, the lead period's average-assets deflator, and annual `PRCC_F` with independently verified dated primary-IID currency as best-effort choices. Missing or ambiguous FX/security routes make screen quantities unavailable and exclude those records. The current local vintage cannot establish exact 1997 source-file equivalence. The A2/A3 and A3/paper N and estimate differences are not attributed to a vintage without supporting diagnostics.

Logs and exports are retained under `runtime/20261102T211401461112Z/` and `tables/`; the earlier A2 sources and outputs remain unchanged.
