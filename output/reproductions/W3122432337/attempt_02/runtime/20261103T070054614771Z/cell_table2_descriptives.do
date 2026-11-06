version 18
set more off
use "data/table2_valuation/reg.dta", clear

est clear
label variable price3_usd "Price three months after quarter end (USD)"
label variable bvps_usd "Book value per share (USD)"
label variable street_usd "I/B/E/S STREET EPS (USD)"
label variable epsop_usd "Operating EPS (USD)"
label variable other_street_usd "Bottom-line EPS less STREET EPS (USD)"
label variable other_epsop_usd "Bottom-line EPS less operating EPS (USD)"
label variable ni_usd "Bottom-line EPS including extraordinary items (USD)"
estpost tabstat price3_usd bvps_usd street_usd epsop_usd ni_usd other_street_usd other_epsop_usd, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/table2_sample_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table2_sample_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table2_sample_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table2_sample_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
