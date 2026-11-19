version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
import sas using "data/primary_ferc.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/primary_ferc/reg.dta", replace
exit, clear
