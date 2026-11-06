version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
which estadd
import sas using "data/order_backlog_firm_years/order_backlog_firm_years.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/order_backlog_firm_years/reg.dta", replace
exit, clear
