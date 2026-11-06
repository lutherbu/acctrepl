version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which estpost
which esttab
which reghdfe
import sas using "data/main.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "reg.dta", replace
exit, clear
