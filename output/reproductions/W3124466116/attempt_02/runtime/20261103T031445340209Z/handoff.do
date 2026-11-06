version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
import sas using "data/mnc_etr_regressions.sas7bdat", clear
assert _N > 0
isid gvkey datadate
save "data/mnc_etr_regressions/reg.dta", replace
exit, clear
