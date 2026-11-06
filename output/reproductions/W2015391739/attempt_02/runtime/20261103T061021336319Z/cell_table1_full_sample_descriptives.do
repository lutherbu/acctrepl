version 18
set more off
use "data/basu_replication_1963_1990/reg.dta", clear
label variable x "X: scaled earnings"
label variable r_actual "R: actual return"
label variable r_sim "R: simulated return"
est clear
estpost tabstat x r_actual r_sim, stat(N mean p50 variance min max) c(s)
esttab using "tables/table1_full_sample_descriptives.md", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) p50(fmt(%9.3f)) variance(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") replace label
esttab using "tables/table1_full_sample_descriptives.rtf", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) p50(fmt(%9.3f)) variance(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") replace label
esttab using "tables/table1_full_sample_descriptives.csv", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) p50(fmt(%9.3f)) variance(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") replace label
esttab using "tables/table1_full_sample_descriptives.tex", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) p50(fmt(%9.3f)) variance(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") replace label
est clear
exit, clear
