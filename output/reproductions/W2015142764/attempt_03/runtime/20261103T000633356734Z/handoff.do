version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which ivreg2
which esttab
which estadd
import sas using "data/dd_firm_years/reg.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/dd_firm_years/reg.dta", replace
import sas using "data/abacc_firm_years/reg.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/abacc_firm_years/reg.dta", replace
exit, clear
