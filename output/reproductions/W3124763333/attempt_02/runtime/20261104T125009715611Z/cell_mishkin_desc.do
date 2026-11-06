version 18
set more off

use "data/order_backlog_firm_years/reg.dta", clear
est clear

estpost tabstat earn_t earn_lead bklg sar, statistics(n mean sd p25 p50 p75) columns(statistics)
esttab using "tables/table2_descriptives.md", ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") ///
    replace label
esttab using "tables/table2_descriptives.rtf", ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") ///
    replace label
esttab using "tables/table2_descriptives.csv", ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") ///
    replace label
esttab using "tables/table2_descriptives.tex", ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") ///
    replace label
est clear
exit, clear
