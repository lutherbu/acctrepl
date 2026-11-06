# Independent source and code review

## Scope and paper evidence

This review covers the frozen `annual_pooled_dt` / `annual_pooled_eq1` scope. I checked the original PDF directly. Physical page 4 (printed page 68) gives Equation (1): continuing-operations EPS divided by prior-period price, negative-return indicator `DUM`, `Return`, and `DUM×Return`. It defines `DUM=1` for negative returns and says annual Return may cover either the fiscal year or the 12 months beginning nine months before fiscal-year end. Footnote 3 specifies raw returns and continuing-operations EPS by default. Physical page 5 (printed page 69) gives 1951–2001 annual availability, 136,887 initial firm-years, 131,920 final firm-years after trimming the top and bottom 1% of EPS/price and Return each year, and pooled `β₂=0.302`. It also reports 14,383 firms. The paper does not identify the pooled fit's timing alternative, underlying estimator, standard errors, fixed effects, or weights, and it does not report separate `DUM` or `Return` rows.

The fiscal-year Return option is the selected best-effort interpretation. The construction uses adjacent actual Compustat DATADATEs, daily CRSP total returns over `(prior DATADATE, current DATADATE]`, and the inclusive prior/current endpoint range for dated link support and the prior price. It does not switch to the unreported 12-month-from-nine-months-before window. Irregular DATADATE spans are retained and counted.

## Independent source decisions

- **Population and annual records.** Physical page 5 describes all eligible companies on the 2001 Primary-Supplementary-Tertiary, Full Coverage, and Research files, without an industry exclusion. The current `COMP.FUNDA` file is a later merged vintage. The build uses `POPSRC='D'`, `DATAFMT='STD'`, `CONSOL='C'`, and both `INDFMT='INDL'` and `INDFMT='FS'`; it does not drop financial services. FY 1950 is retained only to support the first FY 1951 lag. The paper does not specify these current-file descriptor filters or a historical duplicate-resolution rule, so they remain implementation choices rather than exact recovery of the 2001 extract.
- **Historical format codes.** The local catalog labels `SICH` as historical SIC and `NAICSH` as historical NAICS. The 2004 Compustat guide identifies `SICH` as unavailable for some banks (physical page 97 / printed page 47) and describes the historical NAICS hierarchy from two-digit sectors through six-digit industries (physical page 90 / printed page 40). I repaired the duplicate-format rule to treat SICH zero or out-of-range values as unavailable and to derive the first two NAICS digits at the code's observed length; sector 52 maps to FS. This is a code-validity inference because the guide does not define a separate numeric missing code for SICH. The construction diagnostics show zero SICH zeros, zero out-of-range SICH values, and zero NAICSH zeros in the filtered source rows. The format-rule repair does not change the retained A1/A2 analysis rows or any common model input.
- **EPS and price basis.** The 2011 Xpressfeed guide gives split-adjusted basic EPS as `EPSPX/AJEX` (physical page 29 / printed page 21) and describes prices and share items as unadjusted (physical pages 107–108 / printed pages 99–100). The 2004 guide describes `EPSPX` as basic EPS before extraordinary items and discontinued operations and documents the 1997 primary-to-basic EPS transition (physical pages 659–660 / printed pages 609–610). `PRCC_F` is the fiscal-year close, including the last available trading close for a suspended issue (physical pages 674–675 / printed pages 624–625). The code rebases the EPS numerator with the same-provider relative factor `EPSPX_t×AJEX_(t-1)/AJEX_t`; it does not assume Compustat and CRSP cumulative factors share an absolute terminal basis. For USD EPS, it divides by the absolute raw CRSP price at the latest trading date on or before the prior actual DATADATE, at most seven calendar days old. For non-USD EPS, it uses prior `PRCC_F` only when the security-price currency at the historical-primary `HIID` matches current `CURCD`. This scope's final sample happens to contain only USD EPS and CRSP prices.
- **Issue links.** The local `FUNDA.IID` label is Header Primary Global Issue ID; `HIID` is Historic Primary Global Issue ID. The 2013 CRSP/Compustat guide documents the dated CCM fields and `P`/`C`, `LC`/`LU`, and `USEDFLAG=1` rules (physical pages 8–9, 15, and 17). It documents X-suffix dummy LIIDs for dated company ranges without an identified Compustat security (physical pages 19 and 21 / printed pages 15 and 17). The code requires stable HIID at both annual endpoints, uses exact LIID-to-HIID matches or dated X placeholders, coalesces only adjacent/overlapping same-GVKEY/HIID/PERMNO intervals, and excludes more than one candidate PERMNO. The previous header-IID-only diagnosis was superseded by the local historic-HIID and dated-X audit; no link is backdated.
- **Return coverage.** The CRSP stock guide describes daily `RET` as a holding-period total return (physical pages 44 and 128). Expected sessions come from `CRSP.DSI`; every expected DSI date must have a unique DSF row with a valid daily return, and observed endpoints must match. Returns are compounded without zero-filling missing or coded values. No minimum trading-session cutoff is imposed, so a genuinely short adjacent DATADATE span can qualify if its own calendar coverage is complete. Possible early delistings with missing endpoint data remain unavailable; the paper does not prescribe a `DLRET` extension.
- **Trimming and regression.** In-scope rows first require complete EPS/price and Return inputs; separate 1st/99th percentile cutoffs are then calculated by fiscal year for each variable. Values below/above the cutoffs are removed and ties at the cutoff remain. No winsorization or additional outlier rule is applied. Pooled built-in Stata OLS with an intercept and conventional homoskedastic errors is the best-effort estimator; the paper does not supply an estimator or inference method.

## Demonstrated repair: route attribution

In A1, `dummy_x_used` and `direct_id_used` were ORed over every link row in each coalesced history segment before selecting a segment that covered a particular annual period. These fields therefore described route availability anywhere in the coalesced history, not whether an X or direct-HIID row overlapped the firm's actual prior/current endpoint interval. A1's design presented those as period-specific counts.

A2 now computes `dummy_x_used` and `direct_id_used` from original qualifying CCM rows overlapping the inclusive link-support interval `[prevdate, datadate]`. It keeps separate `dummy_x_history` and `direct_id_history` fields for the old whole-segment diagnostic. The final-sample route cross-tab is:

| Route evidence over the annual link-support interval | Firm-years |
| --- | ---: |
| Direct HIID only | 134,366 |
| X placeholder only | 4,590 |
| Both direct HIID and X | 781 |
| **Total** | **139,737** |

The separate coalesced-history cross-tab reproduces the A1 attribution: direct only 108,106, X only 130, and both 31,501. Before trimming, 8,756 unique linked periods overlap at least one X row and 168,323 overlap a direct-HIID row; the corresponding whole-history counts are 39,948 and 175,457. These fields are diagnostics; sample eligibility never depended on them.

The repair is attribution-only. A one-to-one comparison of A1 and A2 `GVKEY`/`FYEAR` keys finds all 139,737 rows in both versions. All 50 shared non-route columns, including dates, source inputs, prices, Return, DUM, and the interaction, are identical. The data file adds two history-flag columns. Regression and descriptive table hashes are unchanged from A1.

## Sample and estimates

| Sample measure | Paper | A2 | Difference |
| --- | ---: | ---: | ---: |
| Initial annual firm-years before trimming | 136,887 | 145,055 complete cases | +8,168 |
| Final annual firm-years | 131,920 | 139,737 | +7,817 |
| Firms / identifiers | 14,383 firms | 15,767 unique GVKEYs | +1,384 identifiers |

The final A2 sample spans every FY 1951–2001. Annual retained counts range from 297 (1951) to 6,118 (1997). The constructed firm count is 15,767 unique GVKEYs; it is descriptive and was not used as a screen. The paper's sample-size differences remain unexplained by the current evidence. I checked the declared population, duplicate selection, lag, price/currency path, CCM uniqueness, daily coverage, complete-case screen, and annual trimming; the current modern merged vintage and timing/source choices cannot be isolated as the sole cause.

| Equation (1) term | Paper | A2 coefficient | Conventional SE | t | Two-sided p |
| --- | ---: | ---: | ---: | ---: | ---: |
| `DUM` | Not reported | -0.0161345 | 0.0014668 | -11.00 | <0.001 |
| `Return` | Not reported | 0.0001854 | 0.0011757 | 0.16 | 0.875 |
| `DUM×Return` (`β₂`) | 0.302 | 0.2837306 | 0.0034418 | 82.44 | <0.001 |
| Intercept | Not reported | 0.0702411 | 0.0008431 | 83.31 | <0.001 |

A2 R-squared is 0.1211 and N is 139,737. The interaction is 0.0182694 below the published point estimate. No source inference procedure is given for `β₂`, so A2's reported t and p use conventional OLS inference and are not a same-method comparison.

Descriptives for the actual retained analysis sample:

| Variable | Mean | SD | P25 | P50 | P75 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `EPS/Price` | 0.0246 | 0.1876 | 0.0002 | 0.0587 | 0.1044 |
| `DUM` | 0.4496 | 0.4975 | 0.0000 | 0.0000 | 1.0000 |
| `Return` | 0.1247 | 0.5739 | -0.2261 | 0.0503 | 0.3500 |
| `DUM×Return` | -0.1353 | 0.2088 | -0.2261 | 0.0000 | 0.0000 |
| Actual DATADATE span (days) | 365.4860 | 12.2118 | 365 | 365 | 366 |

Actual DATADATE spans run from 30 to 701 days. With descriptive boundaries of under 300 and over 400 days, the retained sample has 390 short and 584 long spans; the complete-case pretrim counts are 408 and 624. All final return windows cover their expected DSI sessions. The session count ranges from 20 to 485 (median 253). Of 175,859 uniquely linked pretrim windows, 164,182 have a complete valid daily-return window, 11,341 have at least one missing/invalid `RET`, 15 lack the first expected session, 65 lack the last, and 256 have no DSF daily rows. These endpoint cases are not attributed exclusively to delisting.

### Bounded raw-date attribution audit

I checked every one of the 974 retained windows with `RET_DAYS<300` or `RET_DAYS>400` against every raw annual date key for the same GVKEY in the build's exact filtered `COMP.FUNDA` universe (`FYEAR=1950–2001`, domestic source, standard format, consolidated, industrial/financial-services). To keep this diagnostic bounded after the failed temporary-build edit, the standalone native SAS audit used A1's retained date keys as its driver; A2's earlier successful comparison established the same 139,737 GVKEY/FYEAR keys and identical values in all 50 shared non-route columns, including both endpoint dates and `RET_DAYS`. The script then reread and filtered `COMP.FUNDA` for the 938 GVKEYs in these windows and reconstructed the exact annual one-row selector from `build.sas`. It did not use A1 for estimation or change the A2 sample.

There are **zero intermediate raw DATADATE keys** strictly between `PREVDATE` and `DATADATE` in all 974 irregular windows: zero of 390 short windows and zero of 584 long windows. Consequently, none of these windows contains a date selected under another FYEAR label, a date discarded by the one-row-per-GVKEY/FYEAR selector, or an intermediate date with repeated FYEAR labels. The result is based on actual source dates, not nominal FYEAR adjacency alone. `FYR` differs between the prior and current source endpoints in all 974 windows, consistent with fiscal-year-end month changes. Thus the irregular spans are present in the selected adjacent observed annual source dates; there is no evidence that an intermediate annual report was discarded and caused an incorrect prior-price/return anchor. They remain in the model without a duration screen. This establishes adjacency within the available filtered source, not that the modern source contains every historical company report.

The local FUNDA catalog labels `FYR` as “Fiscal Year-end Month,” `PDDUR` as “Period Duration,” and `APDEDATE` as “Actual Period End date.” In this bounded source subset, `PDDUR` is populated on both endpoints. Current-endpoint values are 9 for 160 windows, 10 for 2, 11 for 16, 12 for 781, 13 for 8, 14 for 3, and 15 for 4; prior-endpoint values are 1 for 1, 10 for 1, and 12 for 972. The S&P Xpressfeed *Understanding the Data* guide says that `PDDUR` gives the actual number of months in an annual source document for international companies (Fiscal Year Changes section, PDF page 9); it also says FYR and DATADATE indicate a fiscal-year change ([guide](https://w3.loibl.com/uni/xf_understanding_the_data.pdf)). Because this build uses `POPSRC='D'`, I report PDDUR's observed values as a descriptor and do not treat the guide's international-specific unit statement as a verified definition for these records. `APDEDATE` is missing on all 18,448 filtered raw FUNDA rows examined for these 938 GVKEYs, so it cannot refine the endpoint day or provide a second intermediate-date check for this historical subset. The audit therefore relies on the source's observed DATADATE keys and FYR month evidence, with the PDDUR interpretation limited as above.

The final sample's prices are all CRSP USD quotes for USD EPS. The quote-age mean is 0.467 days, median 0, 99th percentile 2, and maximum 6. In the pretrim target years, 25,661 firm-years have CAD `CURCD`; 12,874 match security currency and a prior Compustat price, while 12,787 do not. These CAD matches do not appear in the trimmed model sample. No daily/monthly security-currency conflicts were observed.

## Execution and remaining limits

The final production SAS build and native SAS-to-Stata handoff succeeded in runtime `20261102T222532232445Z`; the unchanged template Stata cells `6756ee91` and `f388b926` succeeded in runtime `20261102T222748435650Z`. I inspected all four regression-table formats and all four descriptive-table formats. The coefficient-table and descriptive-table hashes match the prior successful A2 run, with N=139,737 and R-squared 0.1211. The bounded source-date audit's SAS code and ordinary log/output are retained at `runtime/temporal_audit.sas`, `runtime/temporal_audit.log`, and `runtime/temporal_audit.lst`. A temporary build-integrated diagnostic attempt at `runtime/20261102T221628933141Z` failed before producing analysis output because the diagnostic aggregated period-key fields a second time from a table that no longer carried those source descriptors. That diagnostic-only code was removed; final `build.sas` is byte-for-byte the previously successful A2 production source snapshot.

The exact annual Return window and pooled fit inference are not stated in the paper. Modern Compustat/CRSP inputs also differ from the 2001 vintage. The current sample and coefficient are therefore a documented best-effort reconstruction, not a tuned numerical match. The reviewed scope is executable and its estimation limitations are explicit.
