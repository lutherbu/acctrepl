version 18
set more off
global descvars "btm roe ret"
use "data/history/reg.dta", clear
est clear
estpost tabstat $descvars, stat(N p1 p5 p25 p50 p75 p95 p99) c(s)
esttab using "tables/table1_pooled.md", replace cells("count(fmt(0)) p1(fmt(3)) p5(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3)) p95(fmt(3)) p99(fmt(3))") label
esttab using "tables/table1_pooled.rtf", replace cells("count(fmt(0)) p1(fmt(3)) p5(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3)) p95(fmt(3)) p99(fmt(3))") label
esttab using "tables/table1_pooled.csv", replace cells("count(fmt(0)) p1(fmt(3)) p5(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3)) p95(fmt(3)) p99(fmt(3))") label
esttab using "tables/table1_pooled.tex", replace cells("count(fmt(0)) p1(fmt(3)) p5(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3)) p95(fmt(3)) p99(fmt(3))") label
est clear
exit, clear
