version 18
set more off
use "data/reg.dta", clear
est clear
estpost summarize rt ur rfut earn dearn rnoa drnoa pm ato dpm dato rnoap1 pmp1 atop1 sur anrev, detail
esttab using "tables/descriptives.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") replace label
esttab using "tables/descriptives.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") replace label
esttab using "tables/descriptives.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") replace label
esttab using "tables/descriptives.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p50(fmt(3)) min(fmt(3)) max(fmt(3))") replace label
est clear
exit, clear
