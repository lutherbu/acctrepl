version 18
set more off
global desc "wwetr sale pi at roa size pti foroper"
use "data/mnc_etr_regressions/reg.dta", clear
label variable wwetr "WWETR"
label variable sale "Net sales (USD millions)"
label variable pi "Pretax income (USD millions)"
label variable at "Total assets (USD millions)"
label variable roa "ROA"
label variable size "SIZE"
label variable pti "PTI"
label variable foroper "FOROPER"
est clear
estpost tabstat $desc if etrpool==1 & !missing(mnc), by(mnc) statistics(count mean sd p25 p50 p75) columns(statistics)
esttab using "tables/descriptives_etr_pool.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") unstack noobs label replace
esttab using "tables/descriptives_etr_pool.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") unstack noobs label replace
esttab using "tables/descriptives_etr_pool.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") unstack noobs label replace
esttab using "tables/descriptives_etr_pool.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") unstack noobs label replace
est clear
exit, clear
