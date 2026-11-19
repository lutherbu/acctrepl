version 18
set more off

global t2vars "earnings_t earnings_next cfo_t opacc_t fcf_t tacc_t spi_ratio si low_op low_tacc earn_low_op earn_low_op_si earn_low_tacc earn_low_tacc_si"
use "data/accrual_persistence_main/reg.dta", clear
keep if table2_sample==1

label var earnings_t "Earnings t"
label var earnings_next "Earnings t+1"
label var cfo_t "CFO t"
label var opacc_t "OPACC t"
label var fcf_t "FCF t"
label var tacc_t "TACC t"
label var spi_ratio "Special items"
label var si "SI"
label var low_op "Low OPACC"
label var low_tacc "Low TACC"
label var earn_low_op "Earnings x Low OPACC"
label var earn_low_op_si "Earnings x Low OPACC x SI"
label var earn_low_tacc "Earnings x Low TACC"
label var earn_low_tacc_si "Earnings x Low TACC x SI"

est clear
estpost tabstat $t2vars, stat(N mean sd p25 p50 p75 min max) c(s)
esttab using "tables/table2_actual_sample.md", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
esttab using "tables/table2_actual_sample.rtf", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
esttab using "tables/table2_actual_sample.csv", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
esttab using "tables/table2_actual_sample.tex", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
est clear
exit, clear
