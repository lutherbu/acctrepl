version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
which estadd
import sas using "data/equity_offerings/equity_offerings.sas7bdat", clear
assert _N > 0
isid offer_id
save "data/equity_offerings/reg.dta", replace
exit, clear
