version 18
set more off
use "data/book_tax_firm_years/reg.dta", clear

label var ptbi_tp1 "PTBI(t+1)"
label var ptbi_t "PTBI(t)"
label var btd_scaled "Scaled temporary BTD"

est clear
estpost tabstat ptbi_tp1 ptbi_t btd_scaled, stat(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/sample_descriptives.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace
esttab using "tables/sample_descriptives.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace
esttab using "tables/sample_descriptives.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace
esttab using "tables/sample_descriptives.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace
est clear
exit, clear
