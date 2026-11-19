version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which xtfmb
which estadd
which asreg
import sas using "data/full_sample/full_sample.sas7bdat", clear
assert _N > 0
isid gvkey datadate
save "data/full_sample/reg.dta", replace
exit, clear
