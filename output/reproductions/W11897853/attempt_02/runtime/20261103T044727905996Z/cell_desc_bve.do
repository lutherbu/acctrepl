version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/main/reg.dta", clear

global sampleflag "fit_bve"
label variable y_bve "SD of future earnings"
label variable xrd_bve_w "R&D"
label variable capx_bve_w "Capital expenditures"
label variable xad_bve_w "Advertising"
label variable size_bve_w "Log market value (USD billions)"
label variable lev_bve_w "Leverage"
est clear
estpost tabstat y_bve xrd_bve_w capx_bve_w xad_bve_w size_bve_w lev_bve_w if $sampleflag==1, statistics(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/sample_bve_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_bve_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_bve_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_bve_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
