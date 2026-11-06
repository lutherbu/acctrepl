version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"

global desc "roa_f1 roa acc cfo grnoa grwc depamort grltnoa"
use "data/reg.dta", clear

label variable roa_f1 "ROA_(t+1)"
label variable roa "ROA_t"
label variable acc "ACC_t"
label variable cfo "CFO_t"
label variable grnoa "GrNOA_t"
label variable grwc "GrWC_t"
label variable depamort "DEPAMORT_t"
label variable grltnoa "GrLTNOA_t"

est clear
estpost tabstat $desc, statistics(count mean sd p25 p50 p75) columns(statistics)
esttab using "tables/descriptive_main.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/descriptive_main.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/descriptive_main.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/descriptive_main.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
