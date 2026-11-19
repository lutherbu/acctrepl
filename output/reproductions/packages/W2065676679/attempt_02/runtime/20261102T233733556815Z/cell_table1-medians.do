version 18
set more off
global descvars "btm roe ret"
use "data/history/reg.dta", clear
keep if inlist(fyear,1975,1978,1981,1984,1987,1990,1993)
est clear
estpost tabstat $descvars, by(fyear) stat(N p50) c(s)
esttab using "tables/table1_medians.md", replace cells("count(fmt(0)) p50(fmt(3))") label
esttab using "tables/table1_medians.rtf", replace cells("count(fmt(0)) p50(fmt(3))") label
esttab using "tables/table1_medians.csv", replace cells("count(fmt(0)) p50(fmt(3))") label
esttab using "tables/table1_medians.tex", replace cells("count(fmt(0)) p50(fmt(3))") label
est clear
exit, clear
