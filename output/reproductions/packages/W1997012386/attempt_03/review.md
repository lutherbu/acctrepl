# Review and repair: W1997012386, attempt 03

## Scope and paper checks

I reviewed the frozen Table 3 Panel A and Panel B 1993–1998 levels scopes, the accepted A2 construction and outputs, the attempt template and implementation rules, the provider-source catalog, and the original PDF. The selected models are the complete Equation (2) levels regressions with `STDROA`, `DIV`, `LEV`, `ROA`, `SIZE`, `SALESGRO`, and `RNDADV`, plus an intercept. Equation (1) requires six BTM years and current plus six lagged annual total returns for the 1993–1998 fixed-effects fit. The paper reports 730 rated support firms; Table 3 reports 704 CONMKT and 632 CONACC firms (PDF physical pp. 6–7, 12, 17–18; printed pp. 872–873, 878, 883–884). The article says explanatory variables are firm-specific six-year means and reports White-corrected p-values, one-tailed where predicted (physical pp. 10, 18). It does not identify the cross-sectional estimator, so the template's direct OLS with robust covariance remains a best-effort translation.

The paper defines BTM as firm book-to-market and describes book equity relative to market value of equity (Equation (1), physical pp. 6–7). This firm-level construction pairs consolidated Compustat common equity with company common market equity. The article does not specify its book-equity adjustments or exact market-value source. I therefore checked the source units and CRSP company mapping before choosing the denominator. Published descriptive values are from Table 1 (physical p. 13; definitions and sample-size note continue on p. 14).

## Repairs made

1. **Extended only the raw reporting-date support.** A2 used 1998-12-31 for raw CRSP monthly history, names, link candidates, and both FX sources. The local FY1998 population contains 12,554 rows dated as late as 1999-05-31, including 1,681 rows after the A2 cap (1,465 USD and 216 CAD). The A3 build sets the raw source end to that observed maximum for CRSP MSF, name/link support, and FX. It retains 1998-12-31 as the end of the separately defined calendar market-model window, and 1998-08-31 as the end of the source-supported pre-change senior-debt rating screen. Source descriptors are joined only at their exact dates.

2. **Aligned BTM numerator and denominator at the company level.** The A2 primary-PERMNO market value could differ materially from the company common equity paired with consolidated CEQ. The 2012 CRSP stock guide identifies ordinary common shares by first-digit share type 1 and ADRs by type 3 (physical p. 115, printed p. 111), and reports shares outstanding in thousands (physical pp. 83–84, printed pp. 79–80). CRSP monthly prices are in U.S. dollars per share. `abs(PRC) × SHROUT / 1,000` therefore gives USD millions per issue, consistent with Compustat annual equity in millions. For each selected primary-link fiscal month, A3 sums all active ordinary-common PERMNO values sharing the PERMCO. The CCM guide defines `LC`/`LU`, `LS`, primary/secondary markers, and `USEDFLAG` (physical pp. 8–9, 21, 23; printed pp. 4–5, 17, 19). All used active `LC`/`LU`/`LS` links on common issues are checked. Company BTM is retained when their mapped GVKEYs resolve to one GVKEY matching the Compustat firm, with complete class prices and shares. An ordinary-common issue with no active link is counted separately; because it has no CCM row, no `J`/`N` marker is inferred. It may be included if it introduces no competing GVKEY; a conflicting GVKEY or missing class value leaves that firm-year's company BTM unavailable. Primary-only market value remains a diagnostic. This is targeted to unresolved mappings; coherent multi-class firms remain eligible.

3. **Audited fiscal dates, BTM price age, returns, and FX coverage before final estimation.** The build reports source and derived coverage by actual `DATADATE`/fiscal interval, including which complete return intervals would fail under the old cap. It records selected price dates and the age to each fiscal date. The Jan–Dec 1993–1998 market model and pre-September 1998 rating screen are not shifted with the raw horizon.

4. **Preserved exact same-date ratio cancellation.** LEV and RNDADV use native same-date ratios because their common currency factor cancels. The diagnostics compare native and converted ratios where both are available. No missing accounting amount is set to zero. After the FX horizon repair, no FX-only or native-only RNDADV comparison years remain in the overlap.

The changed BTM/company-mapping logic passed a bounded synthetic SAS smoke test in `scratch/horizon_smoke.sas`: a same-GVKEY mapped issue plus an unmapped common issue is included in company value, while a PERMCO mapped to two GVKEYs produces unavailable company BTM and retains primary value only for comparison. The full SAS construction and native Stata handoff were then run. `sync` and `validate` reported a valid attempt with no errors or warnings. The final SAS run returned 0 with no warnings/errors, and all three Stata cells returned 0.

## Horizon and class audit findings

Across the FY1998 source rows, 1,681 dates fall after 1998-12-31. The post-cap raw support retained 44,184 CRSP monthly rows, 9,066 common-name rows and 7,295 primary-link rows overlapping 1999, 25,024 daily FX rows, and 845 monthly FX rows. CRSP history now runs through 1999-05-28; the FX sources run through 1999-05-31.

For FY1998 BTM, 7,256 firm-date candidates matched a CRSP price; 895 selected price dates are after the old cap. The latest price date is 1999-05-28, no more than 31 days before its accounting date. Of the 11,363 CAD annual rows, all 9,560 rows with assets and all 9,491 rows with sales now have the required exact-date daily or average FX rate. Under the old cap those counts were 9,354 and 9,287, respectively. The 204 FY1998 non-USD CEQ records dated after the cutoff also have exact-date rates.

For fiscal returns, FY1987–1997 complete 12-valid-return interval counts are 5,118, 5,347, 5,289, 5,304, 5,365, 5,483, 5,900, 6,398, 6,647, 6,891, and 7,175; the predecessor cap changes none of these. FY1998 has 7,845 monthly rows across 12,554 fiscal intervals, 7,039 intervals with twelve monthly rows, and 6,916 with twelve valid returns. Only 6,039 would be complete under the old cap: the extension restores 883 complete intervals and adds at least one late month to 964 intervals.

The bounded PERMCO audit contains 55,862 support GVKEY–PERMCO–month rows for all 726 primary-rated support firms; all have a PERMCO. It finds 1,444 of these firm-month rows with multiple ordinary-common PERMNOs and all 1,444 have complete class prices/shares. Among these multiclass rows, company ME exceeds primary-security value by up to $68,940.08 million and by a ratio up to 18.38812. At the distinct PERMCO/month grain, 55,785 months are audited; 105 map to multiple GVKEYs and 17 contain an unmapped ordinary-common PERMNO. The support-row count has 182 GVKEY–PERMCO–month rows with active common-class links to multiple GVKEYs; 17 rows contain an unmapped ordinary-common PERMNO, and all 17 are multiclass. The unmapped PERMNOs have no active CCM row, so they are distinguished from a security carrying the provider's `J`/`N` secondary marker and from a mapped second-GVKEY conflict. These audit-row and PERMCO-month counts are not BTM-year counts. At the six fiscal BTM endpoints, conflicting GVKEY mappings affect 15 BTM firm-years across four firms (2, 2, 2, 2, 3, and 4 by year). One further firm has an unmapped common issue in FY1996 and FY1997 but only one linked GVKEY, so its common issue is included. Thus 722 support firms have six resolved company-BTM values, and 98 coherent multiclass BTM firm-years remain in the balanced panel. No blanket multi-class exclusion is applied.

## Samples and outcomes

| Population / scope | Accepted A2 | Repaired A3 | Published |
|---|---:|---:|---:|
| Complete six-year BTM/return histories before rating screen | 1,645 firms (9,870 rows) | 1,932 firms (11,592 rows), before company-map availability | Not separately reported |
| Rated balanced support cohort | 636 firms (3,816 rows) | 722 company-BTM firms (4,332 rows); 726 before company-map check | 730 firms |
| Table 3 Panel A, CONMKT | 105 | 140 | 704 |
| Table 3 Panel B, CONACC | 105 | 140 | 632 |

The A2 review attributed its 105 final firms largely to observed XRD/XAD/SALE availability. The horizon repair adds actual late fiscal dates, BTM prices, return months, and rates; the company-equity repair then removes one final firm relative to the extended-horizon primary-only result (141 to 140; GVKEY 005073). The full A2-to-A3 count change cannot be allocated to one repair because both fiscal history and BTM denominator scope changed. In A3, 140 of 722 support firms have RNDADV; all 722 pass the 24-month market model, 660 have DP-based CONACC, and 398 have XDP-based coverage. All 140 final firms have DP-based CONACC; 103 have XDP. This explains why the two A3 regression Ns are equal without applying a CONACC screen to Panel A. The published counts are comparison results, not selection targets.

The support `CONMKT` mean is 4.83e−16 over 722 firms, confirming centered firm effects. LEV has 64,614 native/FX overlap firm-years and maximum absolute difference 7.11e−15; no FX-only LEV observations occur. RNDADV has 6,492 overlaps and maximum difference 8.88e−16; no FX-only or native-only comparison years remain after the extended FX source window. This preserves the same-date algebra without manufacturing values.

### Table 3 interest coefficients

The exported estimates are from the actual A3 analysis sample and the template's two-sided heteroskedasticity-robust inference. The paper reports one-tailed p-values where predicted (Table 3 note, physical p. 18).

| Scope / term | Paper coefficient (p) | A3 coefficient (p) | Result |
|---|---:|---:|---|
| Panel A STDROA | 2.079 (.001) | 3.343 (.041) | Positive and significant in both |
| Panel A DIV | 3.557 (.001) | 7.963 (.001) | Positive and significant in both |
| Panel A LEV | 0.316 (.001) | 1.776 (.005) | Positive and significant in both |
| Panel B STDROA | 0.216 (.001) | 0.306 (<.001) | Positive and significant in both |
| Panel B DIV | 0.404 (.001) | 0.115 (.466) | Positive, not significant in A3 |
| Panel B LEV | 0.001 (.450) | −0.001 (.974) | Insignificant in both |

Panel A adjusted R² is .402 (paper .292); Panel B adjusted R² is .460 (paper .249). Both A3 N values are 140; published Ns are 704 and 632 (Table 3, physical pp. 17–18). The A3 Panel B positive DIV result does not reproduce. Different sample sizes and inference conventions preclude a close point-estimate comparison. Full coefficient tables are in `tables/table3_panel_a_levels_1993_98.{csv,md,rtf,tex}` and `tables/table3_panel_b_levels_1993_98.{csv,md,rtf,tex}`.

### Descriptive statistics

Published Table 1 statistics are compared with the actual A3 common analysis sample (N=140). The paper's CONACC mean is based on its 632 eligible firms; every A3 final firm has DP-based CONACC, so the A3 CONACC count is also 140.

| Variable | Paper mean (SD) | A3 mean (SD) |
|---|---:|---:|
| CONMKT | 0.002 (0.283) | 0.150 (0.481) |
| CONACC | 0.004 (0.031) | 0.006 (0.042) |
| STDROA | 0.030 (0.041) | 0.049 (0.080) |
| DIV | 0.017 (0.018) | 0.021 (0.021) |
| LEV | 0.236 (0.148) | 0.198 (0.149) |
| ROA | 0.039 (0.043) | 0.055 (0.078) |
| SIZE | 8.067 (1.518) | 7.945 (1.488) |
| SALESGRO | 0.130 (0.210) | 0.127 (0.175) |
| RNDADV | 0.023 (0.042) | 0.107 (0.297) |
| BETA | 0.898 (0.439) | 0.996 (0.466) |
| MSE | 0.076 (0.031) | 0.010 (0.009) |

The shifted CONMKT mean is compatible with selecting a smaller final subset from the centered support cohort. RNDADV and MSE remain large descriptive discrepancies; the currently available source and construction evidence does not isolate their cause. The actual A3 descriptive export, including counts and quartiles, is `tables/table3_analysis_descriptives.csv` (and matching Markdown, RTF, and TeX files).

## Remaining limitations

The exact historical Compustat/CRSP vintage and author CCM selection policy are unavailable. The paper does not specify BTM adjustments, annual return compounding, the Compustat row filters, missing-item conventions, or a minimum available-year count for accounting means. The local `SPLTICRM` mapping to the legacy rating item remains best-effort. The BTM aggregation uses active CRSP ordinary-common PERMCO issues and the documented CCM link set; unresolved local GVKEY conflicts are unavailable, but historical security coverage may differ. DP remains a broad proxy for the paper's unnamed depreciation expense item; XDP is diagnostic. The RNDADV and MSE descriptive discrepancies remain unresolved. No coefficient, screen, imputation, or source exclusion was changed to target the published sample or results.
