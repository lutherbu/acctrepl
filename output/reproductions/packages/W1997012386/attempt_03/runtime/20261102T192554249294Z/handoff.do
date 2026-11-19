version 18
set more off
adopath ++ "historical artifact ado"
import sas using "data/main.sas7bdat", clear
assert _N > 0
isid gvkey
save "data/main/reg.dta", replace
exit, clear
