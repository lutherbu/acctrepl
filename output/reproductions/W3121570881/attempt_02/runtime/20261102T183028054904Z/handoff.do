version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
import sas using "data/primary_ferc.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/primary_ferc/reg.dta", replace
exit, clear
