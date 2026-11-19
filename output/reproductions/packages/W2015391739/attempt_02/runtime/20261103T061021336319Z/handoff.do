version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
import sas using "data/basu_replication_1963_1990.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/basu_replication_1963_1990/reg.dta", replace
exit, clear
