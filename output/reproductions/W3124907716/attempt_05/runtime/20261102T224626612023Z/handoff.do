version 18
set more off
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
which esttab
import sas using "data/table23_t1.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/table23_t1/reg.dta", replace
import sas using "data/table23_t2.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/table23_t2/reg.dta", replace
import sas using "data/table23_t3.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/table23_t3/reg.dta", replace
import sas using "data/table4_t1.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/table4_t1/reg.dta", replace
import sas using "data/table4_t2.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/table4_t2/reg.dta", replace
import sas using "data/table4_t3.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/table4_t3/reg.dta", replace
exit, clear
