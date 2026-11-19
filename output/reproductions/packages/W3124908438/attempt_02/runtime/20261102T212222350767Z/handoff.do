version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
which xtfmb
import sas using "data/reg.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/reg.dta", replace
exit, clear
