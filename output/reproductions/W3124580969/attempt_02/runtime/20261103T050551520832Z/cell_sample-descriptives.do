version 18
set more off
set linesize 120
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear

global y "sret1"
global x "gscore"
global ctrl "size bm mom accr eqoff"
global complete "!missing(sret1, gscore, size, bm, mom, accr, eqoff)"
keep if $complete

est clear
estpost tabstat $y $x $ctrl, stat(n mean sd p25 p50 p75) c(s)
esttab using "tables/table7_actual_sample_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table7_actual_sample_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table7_actual_sample_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table7_actual_sample_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
