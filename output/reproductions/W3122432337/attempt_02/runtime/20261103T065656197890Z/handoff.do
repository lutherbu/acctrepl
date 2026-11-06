version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
which estpost
which estadd
import sas using "data/table2_valuation/valuation.sas7bdat", clear
assert _N > 0
isid gvkey datadate
save "data/table2_valuation/reg.dta", replace
import sas using "data/table3_information/information.sas7bdat", clear
assert _N > 0
isid gvkey datadate
save "data/table3_information/reg.dta", replace
exit, clear
