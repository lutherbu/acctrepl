version 18
set more off
use "data/table3_information/reg.dta", clear

est clear
label variable car "Three-day market-adjusted return"
label variable uop_street "Unexpected STREET EPS scaled by beginning-quarter price"
label variable uop_epsop "Unexpected operating EPS scaled by beginning-quarter price"
label variable street_usd "I/B/E/S STREET EPS (USD)"
label variable epsop_usd "Operating EPS (USD)"
label variable forecast_usd "Latest pre-announcement mean forecast (USD)"
label variable price0_usd "Beginning-quarter price (USD)"
estpost tabstat car uop_street uop_epsop street_usd epsop_usd forecast_usd price0_usd, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/table3_sample_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table3_sample_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table3_sample_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table3_sample_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
