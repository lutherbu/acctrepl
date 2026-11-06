version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global descvars "ret fr fr_sup fr_norm fr_inf superior normal inferior"
use "data/revisions/reg.dta", clear
isid event_id
est clear
estpost summarize $descvars
esttab using "tables/table4_80_descriptives.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") label replace
esttab using "tables/table4_80_descriptives.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") label replace
esttab using "tables/table4_80_descriptives.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") label replace
esttab using "tables/table4_80_descriptives.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") label replace
est clear
exit, clear
