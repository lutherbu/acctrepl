version 18
set more off

global descriptive_vars "drnoa_f1 rnoa_t dnoa_t wdelta_ato wdelta_pm int_raw"

use "data/main/reg.dta", clear

est clear
estpost tabstat $descriptive_vars, stat(N mean sd min p1 p50 p99 max) c(s)
esttab using "tables/table2_model3_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.4f)) sd(fmt(%9.4f)) min(fmt(%9.4f)) p1(fmt(%9.4f)) p50(fmt(%9.4f)) p99(fmt(%9.4f)) max(fmt(%9.4f))") label
esttab using "tables/table2_model3_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.4f)) sd(fmt(%9.4f)) min(fmt(%9.4f)) p1(fmt(%9.4f)) p50(fmt(%9.4f)) p99(fmt(%9.4f)) max(fmt(%9.4f))") label
esttab using "tables/table2_model3_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.4f)) sd(fmt(%9.4f)) min(fmt(%9.4f)) p1(fmt(%9.4f)) p50(fmt(%9.4f)) p99(fmt(%9.4f)) max(fmt(%9.4f))") label
esttab using "tables/table2_model3_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.4f)) sd(fmt(%9.4f)) min(fmt(%9.4f)) p1(fmt(%9.4f)) p50(fmt(%9.4f)) p99(fmt(%9.4f)) max(fmt(%9.4f))") label
est clear
exit, clear
