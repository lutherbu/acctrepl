version 18
set more off
use "data/basu_replication_1963_1990/reg.dta", clear
label variable x "X: scaled earnings"
label variable r_actual "R: actual return"
label variable r_sim "R: simulated return"
est clear
estpost tabstat x r_actual r_sim if r_actual < 0, stat(N mean sd) c(s)
est store actual_bad
estpost tabstat x r_actual r_sim if !missing(r_sim) & r_sim < 0, stat(N mean sd) c(s)
est store simulated_bad
estpost tabstat x r_actual r_sim if !missing(r_actual) & r_actual >= 0, stat(N mean sd) c(s)
est store actual_good
estpost tabstat x r_actual r_sim if !missing(r_sim) & r_sim >= 0, stat(N mean sd) c(s)
est store simulated_good
esttab actual_bad simulated_bad actual_good simulated_good using "tables/table2_partition_descriptives.md", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f))") replace label mtitle("Actual bad" "Simulated bad" "Actual good" "Simulated good")
esttab actual_bad simulated_bad actual_good simulated_good using "tables/table2_partition_descriptives.rtf", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f))") replace label mtitle("Actual bad" "Simulated bad" "Actual good" "Simulated good")
esttab actual_bad simulated_bad actual_good simulated_good using "tables/table2_partition_descriptives.csv", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f))") replace label mtitle("Actual bad" "Simulated bad" "Actual good" "Simulated good")
esttab actual_bad simulated_bad actual_good simulated_good using "tables/table2_partition_descriptives.tex", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f))") replace label mtitle("Actual bad" "Simulated bad" "Actual good" "Simulated good")
est clear
exit, clear
