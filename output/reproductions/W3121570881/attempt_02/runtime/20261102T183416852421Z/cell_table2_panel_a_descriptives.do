version 18
set more off
use "data/primary_ferc/reg.dta", clear
est clear
estpost tabstat rt xm1 xt xt3 rt3 acct cfot corr dapt, statistics(mean sd p50 min max) columns(statistics)
esttab using "tables/table2_panel_a_descriptives.md", cells("mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") stats(N, fmt(0) labels("N")) noobs nonumber nomtitle label replace
esttab using "tables/table2_panel_a_descriptives.rtf", cells("mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") stats(N, fmt(0) labels("N")) noobs nonumber nomtitle label replace
esttab using "tables/table2_panel_a_descriptives.csv", cells("mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") stats(N, fmt(0) labels("N")) noobs nonumber nomtitle label replace
esttab using "tables/table2_panel_a_descriptives.tex", cells("mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") stats(N, fmt(0) labels("N")) noobs nonumber nomtitle label replace
est clear
exit, clear
