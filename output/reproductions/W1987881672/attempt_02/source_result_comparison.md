# Table 1 source/result comparison — attempt 02

Paper source: Table 1 and note, physical p. 10 (printed p. 230); underlying I/B/E/S observation count and construction, physical pp. 5–6 (printed pp. 225–226). Paper annual sample counts are quarterly firm observations. Each annual regression has 16 observations, one outcome per fiscal year. Local regressions use common-USD quarterly events (`report_curr=USD` and `CURR_ACT=USD`) and `year(FPEDATS)`; the separate 47-row currency correction and its annual effects are listed below.

## Quarterly sample counts by year

| Year | Paper N | Local N | Local − paper |
| --- | --- | --- | --- |
| 1984 | 3378 | 4368 | 990 |
| 1985 | 4649 | 5186 | 537 |
| 1986 | 5387 | 5925 | 538 |
| 1987 | 5745 | 6682 | 937 |
| 1988 | 6827 | 7072 | 245 |
| 1989 | 8797 | 9133 | 336 |
| 1990 | 9640 | 9652 | 12 |
| 1991 | 10208 | 9927 | -281 |
| 1992 | 11227 | 11245 | 18 |
| 1993 | 11579 | 12577 | 998 |
| 1994 | 14611 | 15229 | 618 |
| 1995 | 15243 | 16161 | 918 |
| 1996 | 17136 | 18155 | 1019 |
| 1997 | 18202 | 19547 | 1345 |
| 1998 | 18499 | 19979 | 1480 |
| 1999 | 15391 | 19168 | 3777 |

The paper reports 176,519 quarterly observations; the current common-USD sample has 190,006, a difference of +13,487 (+7.64%). No duplicated eligible `TICKER × FPEDATS` event key was found. The mismatch remains unexplained by the available source diagnostics.

## Annual median surprises (cents per share)

| Year | Paper all | Local all | Paper profits | Local profits | Paper losses | Local losses |
| --- | --- | --- | --- | --- | --- | --- |
| 1984 | -0.19 | -0.110 | 0.00 | 0.000 | -32.93 | -31.000 |
| 1985 | -0.67 | -0.500 | -0.08 | -0.060 | -24.00 | -24.920 |
| 1986 | -0.38 | -0.250 | 0.00 | 0.000 | -17.50 | -16.000 |
| 1987 | -0.03 | -0.080 | 0.00 | 0.000 | -17.00 | -18.450 |
| 1988 | 0.00 | 0.000 | 0.17 | 0.100 | -16.00 | -17.000 |
| 1989 | -0.50 | -0.400 | 0.00 | 0.000 | -17.00 | -20.000 |
| 1990 | -0.50 | -0.335 | 0.00 | 0.000 | -15.70 | -19.000 |
| 1991 | 0.00 | 0.000 | 0.00 | 0.000 | -9.00 | -10.000 |
| 1992 | 0.00 | 0.000 | 0.14 | 0.060 | -5.00 | -5.000 |
| 1993 | 0.00 | 0.000 | 0.13 | 0.000 | -5.00 | -7.000 |
| 1994 | 0.09 | 0.000 | 0.50 | 0.280 | -3.50 | -4.000 |
| 1995 | 0.00 | 0.000 | 0.50 | 0.330 | -4.00 | -5.000 |
| 1996 | 0.50 | 0.250 | 1.00 | 0.510 | -2.00 | -4.000 |
| 1997 | 0.75 | 0.370 | 1.00 | 0.670 | -2.00 | -3.000 |
| 1998 | 0.50 | 0.000 | 1.00 | 0.500 | -1.00 | -3.000 |
| 1999 | 1.00 | 0.500 | 1.00 | 1.000 | 0.00 | -1.000 |

## Annual profit frequencies (percent)

| Year | Paper zero | Local zero | Paper positive | Local positive | Paper small positive surprise rate (conditional) | Local small positive surprise rate (conditional) |
| --- | --- | --- | --- | --- | --- | --- |
| 1984 | 4.37 | 4.00 | 49.3 | 49.89 | 44.9 | 46.18 |
| 1985 | 4.29 | 4.22 | 45.1 | 44.77 | 49.3 | 52.64 |
| 1986 | 5.60 | 5.66 | 48.0 | 48.20 | 49.4 | 52.68 |
| 1987 | 5.80 | 5.84 | 50.0 | 49.84 | 48.6 | 51.92 |
| 1988 | 7.06 | 6.76 | 51.5 | 51.30 | 50.5 | 54.66 |
| 1989 | 7.95 | 7.76 | 45.0 | 45.15 | 49.8 | 53.63 |
| 1990 | 8.32 | 8.26 | 44.4 | 44.70 | 53.4 | 59.63 |
| 1991 | 9.14 | 9.14 | 49.5 | 49.17 | 56.7 | 60.98 |
| 1992 | 10.03 | 10.04 | 50.9 | 50.49 | 57.4 | 61.04 |
| 1993 | 12.73 | 12.38 | 50.4 | 49.55 | 57.1 | 61.46 |
| 1994 | 14.61 | 14.62 | 53.8 | 53.29 | 60.1 | 63.43 |
| 1995 | 16.29 | 16.02 | 53.8 | 53.33 | 60.7 | 64.26 |
| 1996 | 16.78 | 16.69 | 57.3 | 56.67 | 60.7 | 64.53 |
| 1997 | 17.51 | 17.48 | 58.6 | 57.85 | 60.4 | 64.58 |
| 1998 | 20.15 | 19.74 | 55.5 | 54.85 | 61.4 | 65.75 |
| 1999 | 19.21 | 18.38 | 60.6 | 59.72 | 56.3 | 63.08 |

## Annual loss frequencies (percent)

| Year | Paper zero | Local zero | Paper positive | Local positive | Paper extreme negative surprise rate (conditional) | Local extreme negative surprise rate (conditional) |
| --- | --- | --- | --- | --- | --- | --- |
| 1984 | 0.00 | 0.36 | 9.1 | 10.99 | 63.0 | 62.60 |
| 1985 | 0.97 | 0.82 | 11.1 | 10.86 | 56.2 | 56.61 |
| 1986 | 1.46 | 1.49 | 11.1 | 11.94 | 48.6 | 45.94 |
| 1987 | 1.26 | 1.40 | 12.8 | 12.83 | 49.7 | 50.23 |
| 1988 | 2.17 | 2.19 | 13.5 | 12.69 | 47.1 | 48.46 |
| 1989 | 1.68 | 1.77 | 13.2 | 11.76 | 48.3 | 50.82 |
| 1990 | 2.54 | 2.44 | 14.5 | 13.50 | 48.9 | 53.52 |
| 1991 | 3.58 | 3.27 | 20.4 | 18.89 | 36.8 | 39.89 |
| 1992 | 5.40 | 4.97 | 25.6 | 25.40 | 30.5 | 33.39 |
| 1993 | 5.82 | 5.21 | 24.7 | 23.20 | 30.3 | 38.06 |
| 1994 | 7.47 | 6.56 | 29.7 | 28.12 | 25.6 | 33.80 |
| 1995 | 7.05 | 6.26 | 28.6 | 26.00 | 26.9 | 37.23 |
| 1996 | 7.18 | 6.37 | 31.1 | 28.93 | 22.3 | 34.92 |
| 1997 | 8.55 | 7.61 | 33.9 | 30.31 | 20.4 | 35.78 |
| 1998 | 10.08 | 8.53 | 35.1 | 31.37 | 21.6 | 36.66 |
| 1999 | 9.86 | 8.32 | 43.6 | 38.08 | 21.6 | 37.75 |

The paper's “Average” row is the time-series mean of the 16 annual values, not a pooled-quarter statistic. These means compare the printed source row with the local annual series:

| Outcome | Paper average | Local mean of 16 years | Unit |
| --- | --- | --- | --- |
| Mean quarterly sample size | 11032 | 11875.375 | observations |
| Median surprise, all earnings | 0.04 | -0.035 | cents/share |
| Median surprise, profits | 0.34 | 0.212 | cents/share |
| Median surprise, losses | -10.73 | -11.773 | cents/share |
| % zero surprise, profits | 11.24 | 11.061 | % |
| % zero surprise, losses | 4.69 | 4.224 | % |
| % positive surprise, profits | 51.5 | 51.174 | % |
| % positive surprise, losses | 22.4 | 20.930 | % |
| Small positive surprise among positive profit surprises | 54.8 | 58.778 | % |
| Extreme negative surprise among negative loss surprises | 37.4 | 43.478 | % |

## Nine trend regressions

The paper reports the trend slope, a positive t-value magnitude, and adjusted R-square, but does not identify an estimator or covariance procedure. Local results are annual OLS with a constant and conventional standard errors. Local p-values are two-sided; the paper does not report p-values. Slopes for medians are cents per share per year; rates are percentage points per year.

| Outcome | Paper trend | Paper absolute t | Paper adj. R² | Local trend | Local t | Local p | Local adj. R² |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Median surprise, all earnings | 0.08 | 5.61 | 67% | 0.041831 | 4.36 | 0.001 | 54.54% |
| Median surprise, profits | 0.08 | 7.11 | 77% | 0.054868 | 5.83 | <0.001 | 68.74% |
| Median surprise, losses | 1.89 | 10.37 | 88% | 1.783838 | 9.20 | <0.001 | 84.80% |
| Zero surprise, profits | 1.13 | 20.25 | 96% | 1.114189 | 20.61 | <0.001 | 96.58% |
| Zero surprise, losses | 0.69 | 17.88 | 96% | 0.579707 | 18.82 | <0.001 | 95.93% |
| Positive surprise, profits | 0.83 | 5.34 | 65% | 0.759891 | 4.94 | <0.001 | 60.94% |
| Positive surprise, losses | 2.16 | 15.48 | 96% | 1.809593 | 12.35 | <0.001 | 90.99% |
| Small positive profit surprise | 1.02 | 7.91 | 80% | 1.162195 | 9.69 | <0.001 | 86.09% |
| Extreme negative loss surprise | -2.86 | 13.48 | 92% | -1.615136 | -5.79 | <0.001 | 68.40% |

All nine trends retain the paper's direction. The local conventional OLS p-value is 0.001 for the all-earnings median (Stata display) and below 0.001 for the other eight. The paper's printed t-value for the extreme-negative-loss slope is 13.48 although the slope is negative; the local signed t is −5.79. The local absolute t is therefore smaller than the paper’s 13.48.

## Effect of the 47 common-currency exclusions

Attempt 01 kept 190,053 rows with `report_curr=USD`; the I/B/E/S Actuals-file currency field identifies 47 of those as `CURR_ACT=CAD`. Attempt 02 removes them after selecting the latest eligible forecast. No other eligibility rule changed.

| Year | Before | Removed | Final |
| --- | --- | --- | --- |
| 1984 | 4372 | 4 | 4368 |
| 1985 | 5186 | 0 | 5186 |
| 1986 | 5926 | 1 | 5925 |
| 1987 | 6682 | 0 | 6682 |
| 1988 | 7072 | 0 | 7072 |
| 1989 | 9134 | 1 | 9133 |
| 1990 | 9652 | 0 | 9652 |
| 1991 | 9927 | 0 | 9927 |
| 1992 | 11248 | 3 | 11245 |
| 1993 | 12578 | 1 | 12577 |
| 1994 | 15236 | 7 | 15229 |
| 1995 | 16167 | 6 | 16161 |
| 1996 | 18172 | 17 | 18155 |
| 1997 | 19548 | 1 | 19547 |
| 1998 | 19980 | 1 | 19979 |
| 1999 | 19173 | 5 | 19168 |

The 47 exclusions comprise 36 positive-actual, 7 negative-actual, and 4 zero-actual events. They affect 11 years. The all-earnings median changes only in 1984 (−0.100 to −0.110 cents); the profit median changes only in 1996 (0.530 to 0.510 cents); loss medians do not change. Profit zero and positive-surprise frequencies change in each affected year; the conditional small-positive rate changes in 9 affected years. Loss zero, positive, and extreme-negative frequencies change only in 1994, 1996, and 1999. Eight of the nine regression fits change slightly; the median-loss fit is numerically unchanged to the exported precision. This correction is separate from the unresolved annual-year and vendor-vintage differences.
