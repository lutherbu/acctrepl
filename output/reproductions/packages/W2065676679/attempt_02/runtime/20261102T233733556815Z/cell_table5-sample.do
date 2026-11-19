version 18
set more off
global samplevars "roe0 btm roe1 roe2 roe3 roe4 roe5 bc lc timefx eps"
use "data/main/reg.dta", clear
est clear
estpost tabstat $samplevars, by(fyear) stat(N p50) c(s)
esttab using "tables/table5_sample_desc.md", replace cells("count(fmt(0)) p50(fmt(3))") label
esttab using "tables/table5_sample_desc.rtf", replace cells("count(fmt(0)) p50(fmt(3))") label
esttab using "tables/table5_sample_desc.csv", replace cells("count(fmt(0)) p50(fmt(3))") label
esttab using "tables/table5_sample_desc.tex", replace cells("count(fmt(0)) p50(fmt(3))") label
est clear
exit, clear
