# Independent review: W3124580969, attempt 02

## Scope and source checks

I reviewed the frozen model and sample records, the attempt-specific skill and implementation rules, the assigned Stata template, the original cached paper, and attempt 01's final design, SAS build, Stata notebook, native logs, handoff, and exported tables. The reviewed scope is Table 7, model (2): 23 annual cross-sectional regressions for 1979–2001 of one-year size-adjusted returns on GSCORE and the five listed controls.

The source supports the selected construction sequence: annualized financials from the latest October–December quarter, annual fallback when quarterly information is inadequate, prior-year whole-market BM cutoffs, and at least four low-BM firms in each two-digit SIC cell so the focal firm has three peers (§3.1, printed pp. 140–141; physical PDF pp. 8–9). The paper requires earnings and cash-flow availability and explicitly sets missing-history G4/G5 signals to zero (printed p. 141; physical PDF p. 9). Returns begin May 1 after formation and subtract the same-period CRSP capitalization-decile return (§3.2, printed p. 141; physical PDF p. 9). Table 7 and its note give the 23-year averaging, source N and annual-N range, reported coefficient/t-statistic values, and two-tailed star legend (printed p. 158; physical PDF p. 26).

I also verified the conflicting control definitions against the PDF: §4.4 calls the BM control log(BM) and MOM size-adjusted (printed p. 157; physical p. 25), while Table 7's note labels BM as the raw formation ratio and describes MOM as the six-month pre-formation return (printed p. 158; physical p. 26). Attempt 02 retains the table-specific definitions and identifies the conflict. The paper does not name the annual regression estimator, so annual OLS/Fama–MacBeth remains a best-effort interpretation.

## Repair to quarterly currency handling

Attempt 01's final build was substantially repaired and runnable, but its quarterly YTD subtraction did not consistently require the current and preceding quarter to have known, matching `CURCDQ` values. This affected the fallback paths for YTD IB and sales and the YTD capex, R&D, and cash-flow fields. The four-quarter annualization screen checked currency across its selected quarters, but that did not protect standalone quarterly histories used for G4/G5.

Attempt 02 now permits YTD subtraction only across a contiguous same-fiscal-year quarter sequence with known matching currencies. CFO YTD subtraction also requires known, matching SCFQ formats. Direct quarter values remain usable without a prior-quarter subtraction. Quarterly ROA and year-over-year sales growth now require known currencies on both compared records. I added a bounded fixture that confirms a currency-changing YTD difference is missing while a directly reported quarter amount remains available, and enabled SAS `ERRORABEND`.

The native source audit counted potential YTD differences blocked across changed or unavailable currencies: 82 capex, 24 R&D, 61 OANCF, 9 FOPT, and 8 WCAPC. No IB or sales YTD candidate crossed currencies. These field counts can overlap and are source-quarter diagnostics, not sample counts. A row-level comparison with attempt 01 found identical values in all 18,509 common GVKEY-year handoff rows, including G4, G5, and GSCORE; their missing counts and the 3,782 complete-case memberships were unchanged. Annual complete-case Ns were also unchanged, and all four regression and descriptive export hashes match attempt 01. The repair corrects the construction rule without changing this run's delivered sample or estimates.

The side-by-side check is reproducible from [`scratch/compare_handoff.py`](scratch/compare_handoff.py). It read only the two declared SAS handoffs and emitted aggregate comparisons; it did not create or alter either handoff.

## Execution and native evidence

`sync` generated the SAS notebook and `validate` returned valid with one scope and no blocked scope. The final native SAS run is `20261103T050501351531Z`; SAS and the Stata handoff both succeeded. The dataset has 18,509 unique GVKEY-year rows and no duplicate final keys. The final fresh Stata run is `20261103T050551520832Z`; both `table7-fmb` and `sample-descriptives` completed successfully. The regression table and actual-sample descriptive table are present in `.md`, `.rtf`, `.csv`, and `.tex` under `tables/`.

The native Stata audit found 23 of 23 annual fits full rank (rank 7, positive residual degrees of freedom), with annual N from 77 to 297 and total N 3,782. The mean of the 23 native annual adjusted R² values is 0.0298. The asreg coefficient series contains 23 valid annual rows; its lag-one correlation uses the 22 adjacent annual pairs. The printed Bernard (1995) AR(1) finite-sample factor is 1.0599 for `n=23`; using the documented Pearson lag-one convention yields a separate GSCORE t-statistic of 1.573. The main p-values use `asreg, fmb newey(1)` and are explicitly an inference approximation, not Bernard's correction.

### Table 7 comparison

Coefficients and t-statistics are rounded as shown in Table 7; the reconstructed coefficient/t-statistics below are the native Stata results. The paper states a two-tailed star convention. The NW(1) p-values are also two-tailed and use the package's 16 residual degrees of freedom.

| Term | Published coefficient (t) | Reconstructed coefficient (NW(1) t; p) |
| --- | ---: | ---: |
| Intercept | −0.138 (−3.29) | −0.2093 (−2.78; 0.013) |
| SIZE | −0.001 (−0.25) | 0.0103 (1.80; 0.091) |
| BM | 0.034 (1.69) | 0.3390 (1.45; 0.167) |
| MOM | 0.023 (2.46) | 0.1080 (2.89; 0.011) |
| ACCR | −0.052 (−1.42) | −0.0099 (−0.35; 0.734) |
| EQ_OFF | −0.008 (−0.50) | 0.0007 (0.01; 0.990) |
| GSCORE | 0.034 (5.53) | 0.0134 (1.62; 0.124); separate Bernard-adjusted t = 1.573 |
| Mean adjusted R² | 0.0429 | 0.0298 |
| Complete observations | 21,253 | 3,782 |

The GSCORE slope is 1.34 percentage points of SRET1 per score point in the reconstructed annual fits, versus the source's 3.4 percentage points. The reconstructed estimate is not statistically significant under either displayed inference method. The sample is smaller than the paper's 21,724 low-BM observations (21,253 complete for Table 7); no sample cutoff was adjusted to chase those figures.

The native construction had 19,500 low-BM candidates with usable dated SIC before the required earnings/CFO screen; 991 lacked one of those required fields, leaving 18,509. Among that set, GSCORE is unavailable for 14,228 observations, MOM for 1,522, EQ_OFF for 1,297, and SRET1 for 492. Signal missingness is overlapping: G6 is missing for 7,522 and G8 for 12,294. The source specifically authorizes zeroes for missing G4/G5 histories; attempt 02 preserves observed zeros and does not turn missing R&D, capex, or advertising into raw zeroes. This supports a current-sample completeness explanation for much of the Table 7 attrition, but it does not identify why the local reconstructed population differs from the source vintage.

For the actual 3,782-observation regression sample, the exported mean (SD) values are SRET1 −0.032 (0.685), GSCORE 3.838 (1.781), SIZE 5.446 (2.316), BM 0.195 (0.105), MOM 0.251 (0.656), ACCR 0.387 (0.487), and EQ_OFF 0.843 (0.364). The paper does not report matching mean/SD statistics for this complete-case Table 7 sample.

## Remaining assumptions and limits

- The underlying annual estimator is unspecified. Attempt 02 uses separate OLS cross-sections and Fama–MacBeth averaging.
- The main coefficient p-values use Newey–West lag 1 as a package-supported approximation. The separate GSCORE Bernard t uses the finite-sample factor printed in Bernard (1995), with Pearson correlation of adjacent annual coefficients; it does not create a custom covariance estimator or coefficient file. The focal t and coefficients differ materially from the source.
- Raw BM and raw MOM follow Table 7's note despite the §4.4 log-BM and size-adjusted-MOM descriptions. No single choice resolves that source conflict.
- Missing current R&D, capex, and advertising remain unavailable; the source's broad Table 2 default-zero language is not treated as authority to invent raw zero expense values. Quarterly XAD is not present in the cataloged FUNDQ, so the documented annual-as-of-quarter anchor is used when available.
- The low-BM cutoff uses the prior year's all-market BM distribution, while signal medians use current low-BM/SIC2 peers after earnings/CFO eligibility. The build uses dated CCM and CRSP name records, USD book-equity conversion at the statement date, and PERMCO-level December equity aggregation; local coverage and source-vintage differences remain. A specific vintage cause for the sample gap is not established.
- The CRSP capitalization-decile benchmark is source-native from MSIX; the company's size decile is assigned by annual December primary-security size ranks because the source does not state its breakpoint method.

The assigned baseline is runnable, all required analysis and descriptive outputs are present, and the remaining differences and assumptions are documented above.
