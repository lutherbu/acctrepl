adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
adopath ++ "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Personal"
use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/TTTG_Mining_Regions.dta", clear
gen constant = 1
do "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/TTTG_Mining_Regions_do_file.do"
