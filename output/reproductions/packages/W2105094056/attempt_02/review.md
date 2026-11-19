# Independent review — Has goodwill accounting gone bad?

## Scope and disposition

I reviewed the frozen A2 work item, reproduction skill and implementation rules, Stata template, original paper, A1 build and design, SAS/Stata logs, and ordinary exports. The required scope is exactly three Table 3 Panel A Eq. (1) fits: estimated impairment in 1996–2000, estimated impairment in 2004–2011, and Compustat-reported impairment in 2004–2011. The 2001–2003 transition years are excluded from those fits but retained in the fundamentals and segment history. No quarterly/AOQ, marginal-effects, IPROB, return-model, or 2012–2015 robustness scope was added.

I found no demonstrated sample or model-construction defect requiring a rebuild. A2's `build.sas` matches A1 byte-for-byte, and the sample declaration is substantively unchanged. The helper hash-verified and reused both A1 handoff datasets, then executed fresh Stata cells for all three A2 fits. `sync` and `validate` completed; validation reports three scopes and zero blocked scopes. The fresh cell logs and exports are under `runtime/20261103T075342996629Z/` and `tables/`.

## Source and construction checks

- The original PDF, physical p. 6, defines the Compustat/CRSP common-stock intersection, the 1996–2011 period, the positive beginning-goodwill screen, the pre/post regimes, the 2001–2003 transition exclusion, and the goodwill-drop/SPI definitions. It requires both a segment-count decline and a goodwill reduction for the divestiture exclusion. Physical p. 7 footnote 5 explicitly permits missing GDWLIP to be set to zero for firms with positive goodwill. The build follows these rules. Its estimated-outcome code returns a known zero when there is no threshold-qualifying goodwill drop; SPI is required only after such a drop. A qualifying drop with missing SPI remains unknown. The reported-GDWLIP zero rule applies only after positive beginning goodwill is established.
- All predictors are dated t−1. GTA is GDWL/AT; ROA uses OIADP and average AT at t−2/t−1; IMPI is only assigned zero when both GTA and ROA are observed; BTMG1 uses CEQ/(PRCC_F×CSHO)>1. Missing inputs are not imputed to zero. The average-AT endpoints remain an explicit best-effort choice because the paper does not state them.
- The construction keeps FY1994 for the initial ROA denominator and FY2001–2003 as history. The final candidate panel contains only FY1996–2000 or FY2004–2011. Fiscal-year matching and latest-DATADATE selection for a duplicate GVKEY/FYEAR are disclosed assumptions.
- The two duplicate GVKEY/FYEAR keys are the same company in FY2010 and FY2011, each with June and December records. A bounded read-only SAS audit (`audit/duplicate_role_completeness.sas`; successful listing `audit/duplicate_role_completeness_fixed.lst`) checked GDWL, GDWLIP, SPI, AT, OIADP, CEQ, PRCC_F, and CSHO. All four June/December rows lack GDWL, GDWLIP, SPI, AT, OIADP, CEQ, and CSHO; PRCC_F is present. The FY2009 row for this firm also lacks GDWL. Therefore neither FY2010 nor FY2011 can meet the positive beginning-goodwill screen, so the latest-date choice does not affect a retained baseline row. The initial audit invocation stopped on invalid SAS OPTIONS statements; that failed log is preserved as `audit/duplicate_role_completeness.log`, and the corrected read-only run completed without SAS errors.
- The selected segment source is the catalog-listed `COMPSEG.WRDS_SEGMERGED`. The cached provider guide, physical p. 5, distinguishes BUSSEG, OPSEG, GEOSEG, and STSEG; physical p. 7 explains data-year/source-year restatements. The build selects the latest `SRCDate` vintage, counts distinct SID within STYPE, prefers BUSSEG when both adjacent years have usable BUSSEG counts, and otherwise uses OPSEG only when both years have usable OPSEG counts. It does not sum overlapping or geographic segment presentations. An unavailable same-type pair remains unknown and cannot establish a decline. The exclusion requires both an observed segment decline and a positive common-basis goodwill drop. The source is silent on the count type and vintage convention, so these remain best-effort choices.
- The currency correction is present in the final build: GDWL at t and t−1 and SPI are compared in reported units when reporting currency is unchanged. If it changes, the code uses own-date USD stock/flow conversions to form a common basis. GTA and same-currency ROA preserve their original ratios. Xpressfeed's cached guide (physical pp. 82–89, especially p. 87) supports the GBP-intermediary cross-rate formula and the use of EXRATD for stocks, EXRAT12M for income/flow items, and EXRAT1M for monthly security prices. The bounded CAD edge case passes: unchanged goodwill of 100 at FX 0.80 then 0.75 has a same-currency decrease of 0, while naive USD translation would produce a decrease of 5 (`attempt_01/runtime/20261103T074704166766Z/build.lst`, p. 7).
- Annual PRCC_F currency is checked against the fiscal-month dated primary issue using historic HIID, dated SEC_MTH.PRIMISS, SEC_MTHPRC.PRCCM, and CURCDM. The bounded random probe in `attempt_01/probe5.lst` found 182/182 comparable same-currency primary quotes within $0.005; HIID matched all 182 while header IID matched 163. Three cross-currency cases did not price-match and remain unavailable rather than receiving an inferred currency. Production diagnostics report 177,824 verified annual prices and 29,675 unverified out of 207,499 fundamentals rows; BTMG1 is missing when the price route or another BTM input cannot be verified.
- CCM/CRSP eligibility is dated at the fiscal DATADATE: effective LC/LU links with P/C markers, effective CRSP names with share code 10 or 11, and at least one nonmissing monthly return in the preceding 12 months. Open link/name boundaries are handled explicitly. The paper does not supply these exact timing and CCM filters, so they are operational best-effort choices. The bounded 208-row link probe had 103 common-share firm-years with return rows; all 103 had at least one nonmissing return. Multiple qualifying securities are collapsed to one GVKEY/FYEAR candidate.

## Estimation and results

Physical pp. 17–18 of the paper identify conditional logit, firm-level clustered standard errors, z-statistics, two-tailed significance, and pseudo-R². The table does not define the conditional-likelihood strata. A2 therefore retains the A1 best-effort native Stata specification, `clogit ..., group(firmid) vce(cluster firmid)`, with GVKEY as the firm stratum and cluster. This is not claimed as an exact stratum match; it drops all-positive/all-negative firms and does not estimate a global intercept. Panel B's probabilities are numerically consistent with a normalized stratum effect (for example, logistic(0.509×0.155)≈0.520), but that inference does not identify the strata and was not used to tune the fits.

The candidate N is after common-stock, positive beginning-goodwill, and divestiture screens but before model-variable missingness and conditional selection. Complete-case N is the conditional-fit N plus observations omitted in complete, all-positive/all-negative firms, as reported by the native Stata logs.

| Fit | Candidate N | Complete cases before conditional selection | Conditional N / firm clusters |
| --- | ---: | ---: | ---: |
| Pre-142 estimated | 10,182 | 9,063 | 2,325 / 638 |
| Post-142 estimated | 20,846 | 20,258 | 9,973 / 1,687 |
| Post-142 reported | 20,846 | 20,360 | 9,140 / 1,561 |

The paper reports descriptive Table 1 Ns of 9,049 pre and 19,290 post, not Table 3 conditional-fit Ns. The A2 candidate Ns are respectively 1,133 (12.5%) and 1,556 (8.1%) larger. I found no source-supported basis to tune those counts, and the discrepancy alone does not establish a vintage effect. The actual conditional-fit Ns above should not be compared with the Table 1 Ns as if they were the same quantity.

| Fit | IMPI: A2 b (z; p) vs. paper b (z) | BTMG1: A2 b (z; p) vs. paper b (z) | Pseudo-R²: A2 vs. paper |
| --- | --- | --- | --- |
| Pre-142 estimated | 0.256 (2.06; 0.040) vs. 0.162 (1.24) | 0.560 (3.61; <0.001) vs. 0.509 (3.31) | 0.0129 vs. 0.002 |
| Post-142 estimated | 0.500 (5.95; <0.001) vs. 0.604 (6.85) | 1.127 (14.24; <0.001) vs. 1.114 (13.94) | 0.0377 vs. 0.013 |
| Post-142 reported | 0.431 (4.91; <0.001) vs. 0.494 (5.61) | 1.220 (15.54; <0.001) vs. 1.207 (15.70) | 0.0476 vs. 0.015 |

The exported p-values are two-sided, consistent with the paper's stated two-tailed tests. Stata prints 0.000 at three decimals for p<0.001; it is not a zero probability. The clearest inference difference is pre-period IMPI: A2 is positive and significant (p=0.040), whereas the paper's z=1.24 is not significant (two-sided p≈0.215). The remaining focal estimates are directionally consistent; coefficient, z, and pseudo-R² differences remain. They are not a reason to change screens or the estimator.

All three Stata cells converged in three iterations. Their logs show conditional deletion of 2,606 firms/6,738 observations pre, 2,424 firms/10,285 observations for post estimated, and 2,561 firms/11,220 observations for post reported. These counts reconcile to the complete-case Ns above. The regressions and actual `e(sample)` descriptives were exported in MD, RTF, CSV, and TeX; all required files are present, the coefficient tables include coefficient/p-value cells and pseudo-R², and the descriptive exports use the actual fitted observations.

| Fit | e(sample) outcome mean | IMPI mean (SD) | BTMG1 mean (SD) |
| --- | ---: | ---: | ---: |
| Pre-142 estimated | 0.330 | −0.132 (0.556) | 0.190 (0.392) |
| Post-142 estimated | 0.248 | −0.046 (0.464) | 0.137 (0.344) |
| Post-142 reported | 0.260 | −0.031 (0.461) | 0.158 (0.365) |

These are descriptives for `e(sample)`, not the parent Table 1 regime samples. The higher outcome means reflect conditional-logit selection of firms with within-firm outcome variation; they should not be read as full-sample impairment rates or compared directly with Table 1's 10.2%, 12.4%, and 13.0%.

## Remaining limitations

The conditional-logit stratum definition, average-AT endpoints, segment-count/vintage rule, and exact Compustat/CRSP timing are not specified by the source and remain disclosed best-effort choices. Table 3's regression Ns are not reported. The candidate panel's descriptive Ns exceed the published counts, with no demonstrated single cause. The pre-142 IMPI significance differs from the paper, and pseudo-R² values are higher in all three fits. No additional specifications or sensitivity models were run.
