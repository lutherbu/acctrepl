version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/main/reg.dta", clear

global sampleflag "fit_cap"
label variable y_cap "SD of gross future earnings"
label variable caprd_bve_w "Capitalized R&D"
label variable ppent_bve_w "Net PPE"
label variable xad_cap_w "Advertising"
label variable size_cap_w "Log market value (USD billions)"
label variable lev_cap_w "Leverage"
est clear
estpost tabstat y_cap caprd_bve_w ppent_bve_w xad_cap_w size_cap_w lev_cap_w if $sampleflag==1, statistics(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/sample_cap_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_cap_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_cap_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_cap_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
