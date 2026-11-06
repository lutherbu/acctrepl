# Review and native-run results

## Construction review

Attempt 02 uses the frozen source, implementation instructions, and both W11897853 review-queue focus sections. The principal repairs are in `build.sas` and `design.md`:

- The Xpressfeed currency guide specifies GBP as the primary/intermediate currency. Annual and quote amounts are translated through dated GBP-to-reporting/quote and GBP-to-USD rates; `CURNCD` is not used as the FX origin. FY1997 actual records run through 1998-05-31, so the FX and security inputs also extend to that date.
- Annual `PRCC_F` is routed by full `HIID` to the same-date monthly issue and quote, with `PRIMISS` and quote currency retained. A dated primary issue is accepted when its quote agrees with `PRCC_F` within 0.00005. A blank `PRIMISS` is accepted only if the same-date HIID quote and currency are present and the price matches; explicit non-`P` markers, including `J`, are rejected. The native frequency has 173,461 `HIID_DATED_P` matches and 15 unique-primary fallbacks. It has zero `HIID_NO_MARKER` matches and zero `HIID_EXPLICIT_NONP` rows. The remaining route counts are 64,920 HIID rows with no dated quote, 122 HIID price mismatches, 3,020 rows without HIID or a dated primary, 1 unique-primary fallback without a quote, and 9 fallback price mismatches. The 64,920 no-quote rows are not split by marker in the native frequency. Thus, 173,476 of the 241,548 selected annual statement rows (71.82%) receive a supported dated price. No later-month quote is carried backward and alternate AJEX directions are not tried.
- Capitalized R&D is constructed as the USD dollar asset `XRD_t + .8 XRD_(t−1) + .6 XRD_(t−2) + .4 XRD_(t−3) + .2 XRD_(t−4)`, then divided once by current end-period `CSHO`. Net PP&E uses the same current `CSHO` denominator, giving both Table 4 assets the same stock-per-share unit. `CSHPRI` remains the item-54 basis for market value and the current-flow comparison; the paper does not name the Table 4 share item. The previous sum of historical per-share outlays is retained only as a diagnostic.
- The executed rule winsorizes regressors at annual P1/P99 boundaries, following the data-section instruction (physical p. 11). Across the three models, P1 lower-tail variable-cases are 287, 289, and 281; P99 upper-tail variable-cases are 1,095, 1,044, and 695. The `extra_if_p2` diagnostic counts only values from P1 inclusive to P2 exclusive: 747, 700, and 442 variable-cases. These are additional cases that a P2 lower cutoff would affect beyond the values below P1; they are neither all observations below P2 nor the cases actually changed by A1's rule of clamping below-P1 values to P2. They are not part of attempt 02's executed P1-boundary rule.
- Current `EPSPX` is an eligibility field, not a regression control or donor requirement; it excludes zero candidate rows in this run. Donor deciles are ranked over the broad available Compustat population. Only missing source future earnings are imputed from same-year, same-decile observed outcomes; missing FX or AJEX constructions are not imputed. The Table 4 parent screen retains current CAPX, as the source footnote defines the full sample using CAPX, R&D, market value, and leverage even though CAPX is not a Table 4 regressor.

## Native run and coefficient comparison

The successful native run is `runtime/20261103T044727905996Z`. SAS 9.4 completed with return code 0; all three Stata 18 regression cells and three descriptives cells completed with return code 0. The logs have no emitted errors or warnings. Each regression has 21 full-rank annual fits for 1972–1992. NW(5) coefficient contrasts use the exact equivalent reparameterization documented in `design.md`.

| Model | N (attempt 02 / source) | R&D or CAPR&D coefficient (attempt 02 / source) | Its t (attempt 02 / source) | CAPEX or PPE coefficient (attempt 02 / source) | Its t (attempt 02 / source) |
|---|---:|---:|---:|---:|---:|
| Table 3A, BVE | 22,951 / 42,776 | 0.196 / 0.067 | 10.05 / 3.41 | 0.097 / 0.021 | 9.63 / 3.47 |
| Table 3B, price | 21,929 / 40,569 | 0.257 / 0.072 | 15.10 / 6.34 | 0.094 / 0.028 | 35.75 / 9.00 |
| Table 4B, capitalized assets | 14,817 / 29,408 | 0.080 / 0.041 | 11.32 / 3.71 | 0.018 / 0.009 | 5.67 / 4.54 |

Table 3's coefficients, t-statistics, and sample sizes are from physical p. 15; Table 4B values and the five-year-history sample reduction are from physical p. 16. The focal coefficients and sample sizes remain materially above and below the paper's values. Attempt 02 does not reproduce the published magnitudes or sample counts. The mismatch is unresolved; construction choices were not calibrated to target estimates.

## Fit quality and actual-analysis-sample descriptives

Mean annual adjusted R-squared is reported as a proportion in the attempt outputs and as a percent in the paper. Table 3A is 0.167 versus 10.2% (0.102); Table 3B is 0.249 versus 18.4% (0.184); Table 4B is 0.126 versus 16.6% (0.166). Attempt values are from the 21 native annual fits; source values are from Table 3 (physical p. 15) and Table 4B (physical p. 16).

The exported `sample_*_descriptives.csv` files summarize the actual analysis samples after attempt 02's annual regressor winsorization. They include imputed outcomes. The source Table 1 means below describe broader full samples; source advertising has fewer observations. Table 4A uses the five-year R&D history sample. These source populations differ from attempt 02's smaller fit samples, so mean differences are descriptive checks rather than like-for-like targets.

| Sample and metric | Attempt 02 mean (analysis N) | Source mean (source population) |
|---|---:|---:|
| Table 3A BVE: future SD | 0.161 (22,951) | 0.115 (Table 1A, N=55,073) |
| Table 3A BVE: R&D | 0.108 (22,951) | 0.108 (Table 1A, N=55,073) |
| Table 3A BVE: CapEx | 0.206 (22,951) | 0.198 (Table 1A, N=55,073) |
| Table 3A BVE: advertising | 0.104 (22,951) | 0.057 (Table 1A, N=42,776) |
| Table 3A BVE: log market value | −3.189 (22,951) | −3.190 (Table 1A, N=55,073) |
| Table 3A BVE: leverage | 0.337 (22,951) | 0.289 (Table 1A, N=55,073) |
| Table 3B price: future SD | 0.116 (21,929) | 0.100 (Table 1B, N=52,046) |
| Table 3B price: R&D | 0.057 (21,929) | 0.045 (Table 1B, N=52,046) |
| Table 3B price: CapEx | 0.138 (21,929) | 0.128 (Table 1B, N=52,046) |
| Table 3B price: advertising | 0.081 (21,929) | 0.043 (Table 1B, N=40,569) |
| Table 3B price: log market value | −3.163 (21,929) | −3.142 (Table 1B, N=52,046) |
| Table 3B price: leverage | 0.352 (21,929) | 0.294 (Table 1B, N=52,046) |
| Table 4B BVE: gross future SD | 0.150 (14,817) | 0.117 (Table 4A, five-year-history sample N=29,408) |
| Table 4B BVE: capitalized R&D | 0.270 (14,817) | 0.264 (Table 4A, five-year-history sample N=29,408) |
| Table 4B BVE: net PPE | 0.756 (14,817) | 0.608 (Table 4A, five-year-history sample N=29,408) |

Source Table 1 is on physical p. 11 and Table 4A on physical p. 16. Attempt means are from the exported actual-sample descriptives; source means are transcribed from those tables. The broader Table 1 samples have N=55,073 for most BVE variables and N=52,046 for most price variables, with advertising N=42,776 and N=40,569. Table 4A describes the five-year R&D sample; the attempt's Table 4 regression sample is 14,817.

## Remaining source and data limits

The sample gap persists after repairing price-issue routing and extending inputs through May 1998. The local annual Compustat vintage is not the authors' original vintage; current advertising availability and other source coverage remain plausible points for further reconciliation, but the available evidence does not isolate the gap to one cause. The paper leaves the Table 4 share item and asset timing implicit. The common CSHO denominator is therefore an explicit, consistent stock-per-share choice. No target-estimate tuning was used.
