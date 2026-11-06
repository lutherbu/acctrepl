# Independent review — W3121345849, attempt 02

## Scope and source checks

I reviewed the nine Table 1 outputs: HVZ, EP, and RI, each at horizons 1, 2, and 3. The original PDF’s Table 1 (physical p. 9) covers annual rolling fits for 1969–2012. Equations (1), (3), and (7) are on physical pp. 4–6; June 30 availability, the April–March fiscal-year-end rule, the ten-year horizon-specific windows, and the AC/TACC zero rule are on p. 7. Appendix 1 on physical pp. 30–31 gives the item mappings and per-share denominator. I also checked the parsed paper against the original PDF, including visual inspection of Table 1 and Appendix 1.

This is the coefficient-estimation table, not the later Table 2 forecast-evaluation sample of 119,653 firm-years from 1969–2008. No CRSP, IBES, return, analyst, ICC, or Table 2 common-sample eligibility screen is used. For estimation year T and horizon h, the code uses base availability years T−9−h through T−h; the h-year outcome is therefore available by T. The April–March rule is implemented by mapping April–December fiscal-year ends to the following availability year and January–March ends to the same year. No naked F-year label is used to form the window.

## Construction and units

The A2 build filters COMP.FUNDA to INDL/STD/C/D as a best-effort interpretation of the paper’s “all firms” description, selects the latest DATADATE and then latest FDATE within each GVKEY-by-availability-year duplicate group, and keeps missing years as gaps. Its support runs from actual DATADATE 30Apr1955 through 31Mar2012 (427,637 source rows, 34,237 GVKEYs); 444 duplicate availability-year groups are resolved. The handoff has one row per GVKEY×availability year, 415,060 rows from 33,136 firms, base availability years 1957–2011, and actual DATADATE 30Apr1956–31Mar2011. The first h=3/T=1969 fit uses 1957–1966 base years and 1956 history for changes.

HVZ is fitted in USD millions with E=IB−SPI, AT, DVC, DD=1 when observed DVC>0, NegE=1 when observed E<0, and AC=Δ(ACT−CHE)−Δ(LCT−DLC−TXP)−DP. EP and RI use (IB−SPI)/base-year CSHO for current and future earnings; future CSHO is not used as the denominator. RI book value is CEQ/base-year CSHO. The unequal-share audit found 249,853, 249,943, and 237,902 observations with current CSHO different from future CSHO for h=1/2/3, with zero base-share formula errors.

The Appendix 1 TACC sum simplifies to Δ(AT−CHE−LT+IVST−PSTK)/base-year CSHO. The construction uses those uncancelled terms and does not gate on ACT, IVAO, LCT, DLC, or DLTT. The native identity audit covered 219,497 complete composite observations, found no mismatch, and had maximum absolute numerator error 7.28×10⁻¹¹. Only AC and TACC are set to zero when their construct is missing, as stated on physical p. 7. Missing SPI, DVC, earnings, shares, or book value are not generically zero-filled. DD and NegE remain binary; continuous levels and interactions are winsorized at annual 1st/99th percentiles by base availability year. The paper does not specify the winsorization grouping date for future outcomes, so grouping them by base availability year is an explicit best-effort choice.

CURCD is used for each statement’s own reporting currency; USD receives an identity factor, and non-USD amounts use GBP-primary Xpressfeed cross-rates. Daily rates convert balance-sheet items and monthly EXRAT12M rates convert flows. CURNCD is not substituted for CURCD, and EXRATTPD’s actual/carried labels are not currency or eligibility screens. The bounded source coverage has 385,538 USD, 41,592 CAD, and 63 blank-CURCD records. This conversion route is an explicit unit harmonization choice because Table 1 does not state a common currency convention.

## Missing-to-zero attribution audit

I ran a separate bounded, read-only SAS audit in this attempt’s runtime directory after the production Stata stage. It used the same exact Funda filters, availability-year mapping, duplicate rule, and dated GBP-to-USD/CAD rates; it added raw-input completeness flags before conversion. The resulting eligible-union counts exactly match the three `desc01` input-union tables. It separates raw-source missing constructs from rows whose required accounting inputs are all present but whose prior-period currency conversion is unavailable. Those FX-only rows have a complete outcome and all other model inputs. The implementation applies the missing-accrual zero rule after conversion; extending it to FX-only construction gaps is an explicit best-effort interpretation, because the paper does not discuss this case.

| Model | Horizon | Unique eligible rows | Raw-input-missing zero fills | FX-only zero fills | FX-only fit-row uses across rolling windows |
|---|---:|---:|---:|---:|---:|
| HVZ | 1 | 308,732 | 80,287 | 591 | 5,910 |
| HVZ | 2 | 281,115 | 74,475 | 560 | 5,600 |
| HVZ | 3 | 255,945 | 68,986 | 533 | 5,330 |
| RI | 1 | 296,384 | 61,626 | 233 | 2,330 |
| RI | 2 | 268,326 | 57,070 | 214 | 2,140 |
| RI | 3 | 243,085 | 53,169 | 208 | 2,080 |

All FX-only zero-fill rows have prior CURCD=CAD. Since their current-period predictors and outcome are complete, the unavailable leg is the prior-period daily conversion factor. Each such unique row appears in ten annual fit windows. Their zero values encode unavailable constructs rather than measured zero accruals. The audit leaves the production implementation unchanged and records this additional uncertainty in applying the source rule. The full audit code, log, and listing are `runtime/20261103T051501161740Z/fx_zero_fill_audit.sas`, `.log`, and `.lst`.

## Estimation and execution

The Stata cells filter complete cases before `asreg`, tag result rows only after that filter, and use native `regress` rank/df checks before averaging annual vectors. Each model has 132 model-year-horizon groups checked: HVZ and EP are full rank for 132/132; RI is full rank for 131/132. RI h=3/T=1969 has 4,575 complete rows but TACC is constant zero across 1957–1966 after the stated missing-to-zero rule. That slope is unidentified, so the output averages 43 qualified years for this one scope; all other eight scopes average 44. The matching adjusted-R² mean uses those same qualified fits. This preserves the missing coefficient rather than counting an omitted zero as an estimate.

The A2 Stata execution is fresh and current at `runtime/20261103T051501161740Z`; all four cells (`hvzfit01`, `epfit01`, `rifit01`, `desc01`) completed successfully. In 17 estimable endpoint comparisons, `asreg` and native OLS coefficients agree within 5.51×10⁻¹² and sample N differences are zero; the rank-deficient RI h=3/T=1969 endpoint is correctly excluded. Regression tables use `cells(b(star fmt(3)) p(par))` in all four formats; the descriptive tables use `estpost tabstat` with count, mean, SD, p1, and p99. Table `Observations` counts annual fits (44 or 43), not the firm-year N within a fit. The mean-annual regression N and the unique window-union N are reported separately below.

| Model | h | Qualified fits | Mean annual fit N (min–max) | Unique complete-case inputs in window union |
|---|---:|---:|---:|---:|
| HVZ | 1 | 44 | 60,529.7 (16,637–96,059) | 308,732 |
| HVZ | 2 | 44 | 54,927.3 (14,875–87,942) | 281,115 |
| HVZ | 3 | 44 | 49,783.3 (13,269–80,279) | 255,945 |
| EP | 1 | 44 | 59,899.0 (16,753–94,430) | 305,554 |
| EP | 2 | 44 | 54,338.7 (15,019–86,315) | 278,058 |
| EP | 3 | 44 | 49,279.1 (13,424–78,808) | 253,301 |
| RI | 1 | 44 | 58,778.0 (8,681–94,324) | 296,384 |
| RI | 2 | 44 | 53,062.0 (6,487–86,215) | 268,326 |
| RI | 3 | 43 | 48,855.1 (6,487–78,716) | 243,085 |

Table 1 does not report annual regression Ns, so these observed Ns are not treated as a published-N comparison. The separate `hvz_input_union`, `ep_input_union`, and `ri_input_union` exports report count, mean, SD, p1, and p99 for each model/horizon’s unique complete-case window union. They are descriptive of Table 1 inputs, not a comparison with the later forecast-evaluation population.

## Published-result comparison

Published adjusted R² and the A2 mean adjusted R² (percent) are:

| Model | Published h=1/2/3 | A2 h=1/2/3 |
|---|---|---|
| HVZ | 89.6 / 84.0 / 80.1 | 90.034 / 84.171 / 80.641 |
| EP | 68.1 / 51.5 / 41.5 | 66.400 / 61.799 / 56.853 |
| RI | 68.1 / 52.1 / 42.5 | 70.743 / 66.273 / 61.574 |

The tables below compare every coefficient mean. Each cell is `published mean (published signed time-series t) → A2 mean (A2 t)`. A2 t is calculated from the native `mean` log’s coefficient and standard error; the exported p-values are two-sided and rounded to three decimals, while Table 1 prints signed t-statistics rather than p-values.

### HVZ — USD millions

| Variable | t+1 | t+2 | t+3 |
|---|---:|---:|---:|
| Intercept | 0.3462 (3.73) → -0.4398 (-2.26) | 0.9587 (8.38) → -0.1454 (-0.79) | 2.2031 (8.92) → 0.3759 (1.65) |
| A | 0.0018 (11.88) → 0.0025 (17.26) | 0.0034 (11.83) → 0.0049 (23.65) | 0.0051 (10.34) → 0.0074 (23.07) |
| D | 0.2109 (11.05) → 0.1448 (16.17) | 0.2937 (8.32) → 0.2766 (16.11) | 0.3149 (5.33) → 0.3785 (16.58) |
| DD | 1.3629 (6.38) → 1.1997 (3.05) | 2.2667 (6.58) → 0.9975 (2.03) | 2.6674 (8.79) → 0.0627 (0.10) |
| E | 0.8715 (84.03) → 0.9079 (118.70) | 0.8365 (46.48) → 0.8496 (92.45) | 0.8378 (29.11) → 0.8358 (68.69) |
| NegE | 1.2460 (5.08) → 1.5297 (4.18) | 2.4850 (7.60) → 2.0193 (5.41) | 2.5332 (7.46) → 2.2606 (6.68) |
| AC | -0.0405 (-6.37) → -0.0585 (-6.48) | -0.0549 (-5.01) → -0.0857 (-4.41) | -0.0585 (-4.39) → -0.0853 (-2.84) |

### EP — USD per share

| Variable | t+1 | t+2 | t+3 |
|---|---:|---:|---:|
| Intercept | 0.1495 (13.02) → 1.2270 (5.06) | 0.2873 (11.23) → 1.4724 (6.23) | 0.4498 (11.24) → 1.5052 (7.52) |
| NegE | -0.1229 (-4.58) → -2.5249 (-6.97) | -0.1717 (-5.88) → -3.1488 (-7.04) | -0.2125 (-5.31) → -3.1041 (-7.05) |
| E | 0.9614 (204.78) → 0.8658 (21.61) | 0.9846 (154.65) → 0.8444 (18.50) | 0.9992 (118.66) → 0.8559 (17.12) |
| NegE×E | -0.7096 (-19.77) → -2.7905 (-9.66) | -1.1451 (-17.03) → -3.6720 (-10.44) | -1.4155 (-19.97) → -3.9841 (-9.68) |

### RI — USD per share

| Variable | t+1 | t+2 | t+3 |
|---|---:|---:|---:|
| Intercept | 0.0914 (6.04) → 0.5395 (2.28) | 0.1855 (6.83) → 0.9108 (5.03) | 0.2993 (7.59) → 0.9135 (6.08) |
| NegE | -0.1087 (-3.98) → -0.8555 (-4.05) | -0.1475 (-4.78) → -1.8127 (-6.39) | -0.2518 (-5.51) → -1.7971 (-6.40) |
| E | 0.8649 (109.26) → 0.6161 (13.66) | 0.8280 (86.93) → 0.5711 (12.41) | 0.8105 (69.57) → 0.5443 (11.32) |
| NegE×E | -0.5436 (-15.26) → -0.5001 (-3.18) | -0.8601 (-11.91) → -1.8298 (-9.74) | -1.3241 (-6.54) → -2.0660 (-8.58) |
| B | 0.0167 (15.66) → 0.0379 (6.79) | 0.0294 (20.70) → 0.0377 (8.83) | 0.0409 (21.94) → 0.0408 (9.39) |
| TACC | -0.0034 (-2.28) → 0.1766 (3.19) | -0.0217 (-10.07) → 0.0573 (0.37) | -0.0413 (-13.38) → -0.0288 (-0.12) |

The HVZ E slopes are closest to Table 1; several other HVZ terms differ, especially h=3 DD. EP and RI estimates and adjusted R² differ materially from the published table, including the RI TACC means and their inference. I found no source-supported sample or formula correction that would justify changing the frozen construction to improve agreement. These discrepancies remain unresolved; I do not attribute them to data vintage without evidence.

## Repairs, provenance, and remaining limits

The A1 handoff construction and A2 sample declaration are unchanged; helper `reuse` verified the construction signature and copied handoff hashes, and the A2 SAS and DTA hashes match A1 exactly. A2’s fresh Stata stage addresses A1’s stale-current-evidence issue: A1’s historical HVZ/EP table outputs were produced under source signatures that later changed, so I do not count A1 as a current 9/9 execution. A2 logs and hashes are current for all four cells. The A2 code already contains the corrected complete-case-before-`asreg` tagging and native full-rank checks; this review found no demonstrated production-code or sample-declaration defect requiring a rebuild. The only added code is the isolated read-only FX attribution audit described above.

Remaining best-effort limitations are the Compustat descriptor/duplicate choices, USD translation for the small CAD subset with dated rate gaps, applying the missing-accrual zero rule to FX-only construction gaps, annual winsorization timing for future outcomes, and the material unexplained differences from the published EP/RI estimates. RI h=3 has 43 identified annual vectors because the first requested fit is rank deficient under the paper’s missing-TACC zero rule. The paper does not publish annual firm-year fit Ns, so only observed A2 Ns and input-union descriptives can be reported.
