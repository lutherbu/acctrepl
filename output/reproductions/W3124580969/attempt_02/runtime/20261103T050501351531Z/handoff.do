version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
which estadd
which asreg
import sas using "data/low_bm_firm_years.sas7bdat", clear
assert _N > 0
isid gvkey year
save "data/reg.dta", replace
exit, clear
