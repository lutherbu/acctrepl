version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/main/reg.dta", clear

global sampleflag "fit_price"
label variable y_price "SD of future earnings"
label variable xrd_price_w "R&D"
label variable capx_price_w "Capital expenditures"
label variable xad_price_w "Advertising"
label variable size_price_w "Log market value (USD billions)"
label variable lev_price_w "Leverage"
est clear
estpost tabstat y_price xrd_price_w capx_price_w xad_price_w size_price_w lev_price_w if $sampleflag==1, statistics(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/sample_price_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_price_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_price_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/sample_price_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
