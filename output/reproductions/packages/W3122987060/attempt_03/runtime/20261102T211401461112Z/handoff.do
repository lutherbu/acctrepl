version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
which estadd
import sas using "data/main/reg.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/main/reg.dta", replace
exit, clear
