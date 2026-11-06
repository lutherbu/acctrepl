version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
which estadd
import sas using "data/history.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/history/reg.dta", replace
import sas using "data/main.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/main/reg.dta", replace
exit, clear
