version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
which estadd
which xtfmb
import sas using "data/main.sas7bdat", clear
assert _N > 0
isid gvkey year
save "data/reg.dta", replace
exit, clear
