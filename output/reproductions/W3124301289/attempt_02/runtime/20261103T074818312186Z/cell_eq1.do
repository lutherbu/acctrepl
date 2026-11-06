version 18
set more off

global dep "xret"
global rhs "gdelta grda garnoa"

use "data/reg.dta", clear
egen __miss = rowmiss(xret gdelta grda garnoa)
keep if __miss == 0

est clear
regress $dep $rhs
est store eq1

esttab eq1 using "tables/eq1.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab eq1 using "tables/eq1.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab eq1 using "tables/eq1.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab eq1 using "tables/eq1.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label

estpost tabstat $dep $rhs, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/eq1_descriptive.md", cells("count(fmt(%9.0f)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label replace
esttab using "tables/eq1_descriptive.rtf", cells("count(fmt(%9.0f)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label replace
esttab using "tables/eq1_descriptive.csv", cells("count(fmt(%9.0f)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label replace
esttab using "tables/eq1_descriptive.tex", cells("count(fmt(%9.0f)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label replace
est clear
exit, clear
