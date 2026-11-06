version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
which estadd
import sas using "data/us_acquisitions_1307.sas7bdat", clear
assert _N > 0
isid dealid
save "data/us_acquisitions_1307/reg.dta", replace
exit, clear
