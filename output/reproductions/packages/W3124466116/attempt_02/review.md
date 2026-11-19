# Independent review — attempt 02

## Source and construction checks

The target is equation (2), Table 4 column (2), for 1990–97. Source references are the paper's Table 1 and definitions (printed p.811; physical PDF p.11), sample-selection Table 2 (printed p.817; physical p.13), descriptive Table 3 (printed pp.818–819; physical pp.14–15), regression Table 4 and equation (2) (printed pp.821–822; physical pp.17–18), and footnote 18 (printed p.830; physical p.26). The legacy item index supports #12→SALE, #63→TXFED, #64→TXFO, #170→PI, and #273→PIFO. The construction uses `WWETR=(TXFED+TXFO)/PI`, `ln(1+SALE)` and `ln(1+PI)` in USD millions, and the table's MNC rule from observed positive PIFO or supported foreign assets. It does not fill missing tax, asset, or geography values with zero.

Table 2 says “observations with negative assets or stockholder’s equity”; it does not specify the treatment of missing equity. The production code's observed-SEQ requirement is therefore an explicit conservative eligibility interpretation. In the bounded negative-only sensitivity, 7 records have missing SEQ after US incorporation, USD currency, and nonzero PI/AT screens; all 7 remain at the equity screen. None pass the next observed-TXFED/TXFO screen, and none enter either the ETR pool or the Table 4 complete cases. The sensitivity pool is still N=23,081 and its Table 4 flag N=182; this assumption does not change the model result.

The paper reports 19,737 firm-years in its ETR pool and N=16,750 in Table 4. Current data produce an ETR pool of 23,081, with 67 missing-SICH rows. Footnote 18 says the 2,987 missing-SIC observations are included in Tables 2–3 and excluded from Tables 4–6, so the source's equation-specific N is exactly 19,737−2,987. That resolves the source N gap; it does not explain the much smaller current complete-case result (N=182), which is primarily a geographic-source coverage limit. No count was used to tune the construction.

Industry exclusions are a disclosed best-effort mapping because the paper names banks, insurance carriers, and utilities without giving exact cutoffs. The historical `SICH` screen uses SIC 49, 60, and 63 major groups: 4900–4999, 6000–6099, and 6300–6399. This preserves other finance and real-estate groups. The source's six industry controls retain its displayed one-digit boundaries; missing SIC remains in the ETR pool and is excluded only from the Table 4 flag.

The current catalog has one annual operating-segment source, `COMPSEG.WRDS_SEGMERGED`; the customer-geography dataset is not a substitute. The table is joined on exact GVKEY-DATADATE, and 23,068 of 23,081 ETR-pool rows have a GEOSEG report, leaving 13 without one. All 50,559 matched GEOSEG rows have USD segment and source currencies and observed source dates; data years are 1990–98, source years 1990–2000, with vintage gaps 0–2. The latest-source audit finds 50,443 SID groups, no duplicate latest SIDs, and no latest type, currency, or date changes. The vintage audit flags 52 repeated SID groups and one type change. There is no observed `GEOTP=1` Total Foreign row. Of 27,433 `GEOTP=3` NonDomestic rows, 25,420 lack `SNMS` and 14,298 lack `IAS`. This supports a field-coverage explanation rather than a failed firm-date join.

The local merged catalog has no SGEOCD/SGEOAR fields; current provider documentation places these in a separate geography file ([WRDS Segment Information, pp.5, 7, 11](https://wrds-www.wharton.upenn.edu/documents/217/Segment_Info.pdf)). Location indicators are therefore a best-effort reconstruction from explicit segment-name matches. Broad Europe/Asia labels cannot establish the absence of separately named countries, and unknown or aggregate-only coverage stays unclassified. The construction supports foreign assets for 5,545 rows (4,323 non-domestic component sums and 1,222 explicit Domestic-only zeros); it does not manufacture zeros from missing reports. Dropping the Domestic-row requirement for summing a complete NonDomestic component set adds one supported asset measure, but it lacks complete location indicators and does not enter Table 4. Conversely, a domestic-only zero still requires an explicit Domestic row and no foreign rows. The 169 detected firm-dates with 236 country/region hierarchy overlaps are excluded from component sums. Four supported FOROPER values exceed one (maximum 1.6384); they are retained, without an unsupported cap. MNC is 1 for observed positive PIFO or supported positive foreign assets, 0 only when both measures are observed and nonpositive, and missing otherwise. Current statuses are 7,219 MNC, 379 domestic-only, and 15,483 unknown.

## Table 4, column (2)

The current Stata run uses ordinary OLS with an intercept and conventional standard errors. All 32 slopes and the intercept are estimable. The fit is N=182, F(32,149)=1.94 (p=.0042), R²=.2946, adjusted R²=.1431. The source reports adjusted R²=10.47%, N=16,750, coefficient estimates, and t-statistics; it does not specify a correction or clustering rule for its t-statistics. The source's † threshold is one-sided at 1%; * is two-sided at 1%; ‡ is two-sided at 5%. The output template reports two-sided p-values, so the inference columns below are not directly equivalent.

| Term | Source estimate | Source t / mark | Current estimate | Current t | Current two-sided p |
| --- | ---: | ---: | ---: | ---: | ---: |
| Intercept | 0.2078 | 22.73* | 0.1660 | 1.07 | .286 |
| SIZE | 0.0499 | 24.32† | 0.1205 | 3.10 | .002 |
| PTI | −0.0504 | −21.47† | −0.0801 | −1.60 | .112 |
| FOROPER | −0.0706 | −2.48† | −0.0588 | −0.23 | .820 |
| FOROPER² | 0.1057 | 2.61† | 0.2804 | 0.80 | .423 |
| MNC | −0.0633 | −5.74† | 0.3265 | 2.89 | .004 |
| MNC×SIZE | 0.0339 | 9.91† | −0.0620 | −1.43 | .156 |
| MNC×PTI | −0.0368 | −10.22† | 0.0208 | 0.37 | .709 |
| AFRICA | 0.0106 | 1.38 | 0.0522 | 0.53 | .594 |
| ASIA | 0.0160 | 3.51* | −0.1058 | −1.32 | .190 |
| JAPAN | 0.0249 | 4.30* | 0.0592 | 1.06 | .292 |
| MIDDEAST | −0.0079 | −0.94 | −0.1479 | −1.64 | .102 |
| EUROPE | 0.0130 | 2.97* | 0.0625 | 0.88 | .382 |
| UK | 0.0030 | 0.71 | −0.0062 | −0.17 | .868 |
| FRANCE | 0.0028 | 0.46 | 0.0272 | 0.45 | .654 |
| GERMANY | 0.0066 | 1.17 | 0.0248 | 0.52 | .601 |
| OCEANIA | 0.0190 | 3.79* | −0.0229 | −0.48 | .634 |
| SAMERICA | −0.0111 | −2.05‡ | −0.0254 | −0.48 | .630 |
| CANADA | −0.0052 | −1.36 | −0.0015 | −0.05 | .964 |
| MEXICO | 0.0035 | 0.68 | 0.0230 | 0.46 | .648 |

The source suppresses industry and year dummy coefficients; the current regression includes six SIC-group and seven year indicators. Most focal estimates differ materially, including the MNC sign and the SIZE and MNC interaction magnitudes. Given the complete-case N and location-proxy limitations, the current estimates should not be read as a close coefficient replication.

## Descriptives and output

Current ETR-pool descriptives are computed only for the 7,598 rows with observed MNC status, not the full 23,081-row pool. In the MNC group, current N=7,219 versus source Table 3 N=7,463; current/source means are WWETR .3237/.3228, net sales $2,420.2m/$2,594.7m, PTI $219.2m/$232.1m, total assets $3,055.0m/$2,646.9m, and FOROPER .2017/.1902. In the domestic group, current N=379 versus source N=12,274; means are WWETR .2910/.2917, net sales $328.3m/$593.7m, PTI $18.3m/$41.5m, and assets $245.6m/$549.6m. These group differences reflect the large unknown-MNC population and the data limits above. The actual Table 4 complete-case descriptives use N=182 (38 domestic and 144 MNC): overall WWETR .275, SIZE 5.353, PTI 2.975, and FOROPER .129.

The assigned fit and both descriptive populations are exported in `tables/table4_col2.*`, `tables/descriptives_etr_pool.*`, and `tables/descriptives_table4.*`. The reported numbers come from the native SAS/Stata logs and output tables; the standalone SEQ sensitivity was aggregate-only and did not alter the production build or estimation sample.
