version 18
set more off
adopath ++ "historical artifact ado"
which esttab
import sas using "data/main.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/main/reg.dta", replace
exit, clear
