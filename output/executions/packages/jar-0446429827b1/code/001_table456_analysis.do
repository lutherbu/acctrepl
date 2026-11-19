adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
* Local paths for the supplied final-regression-sample analysis branch.
global main "@@ACCTREPL_WORK@@/staging"
local outdir "@@ACCTREPL_WORK@@/results"

* Table 4  
*===========
use "$main/Cleaned_data/document_regsample.dta", clear

reg cite_dum post final lnWord    if pro_final==2,  r
outreg2 using `outdir'/Table4.xls,  adjr2   ///
replace  sortvar(  post final postxfinal lnWord  Mandatory) ///
keep( post final postxfinal lnWord  Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("Citation") ctitle("Cite_dum") ///

reg cite_dum post final postxfinal lnWord    if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table4.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord  Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("Citation") ctitle("Cite_dum") ///

reg cite_dum post final postxfinal lnWord Mandatory if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table4.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord     Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory )   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("Citation") ctitle("Cite_dum") ///

reg cite_N post final lnWord     if pro_final==2,  r
outreg2 using `outdir'/Table4.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord    Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("Citation") ctitle("Cite_N") ///

reg cite_N post final postxfinal lnWord    if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table4.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord    Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("Citation") ctitle("Cite_N") ///

reg cite_N post final postxfinal lnWord Mandatory if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table4.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord     Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory )   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("Citation") ctitle("Cite_N") ///



*===========
* Table 5
*===========
use "$main/Cleaned_data/document_regsample.dta", clear
drop if cite_dum==0
    
reg ttcost2 post final lnWord    if pro_final==2,  r
outreg2 using `outdir'/Table5.xls,  adjr2   ///
replace  sortvar(  post final postxfinal lnWord  Mandatory) ///
keep( post final postxfinal lnWord  Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CiteTone") ctitle("N_CostCite") ///

reg ttcost2 post final postxfinal lnWord    if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table5.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord  Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CiteTone") ctitle("N_CostCite") ///

reg ttcost2 post final postxfinal lnWord Mandatory if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table5.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord     Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory )   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CiteTone") ctitle("N_CostCite") ///

reg tone_cost2 post final lnWord     if pro_final==2,  r
outreg2 using `outdir'/Table5.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord    Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CiteTone") ctitle("%CostCite") ///

reg tone_cost2 post final postxfinal lnWord    if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table5.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord    Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CiteTone") ctitle("%CostCite") ///

reg tone_cost2 post final postxfinal lnWord Mandatory if pro_final==2,  r
test post + postxfinal =0
outreg2 using `outdir'/Table5.xls, adjr2 ///
append  sortvar(  post final postxfinal lnWord     Mandatory) ///
keep( post final postxfinal  lnWord    Mandatory )   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CiteTone") ctitle("%CostCite") ///



*==========
* Table 6
*==========
use "$main/Cleaned_data/CL_regsample.dta",clear

reg p_negative2 post cite_dum postXcite lnWord  Mandatory, r
test cite_dum + postXcite =0
outreg2 using `outdir'/Table6.xls, adjr2 ///
replace  sortvar ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord   Mandatory) ///
keep ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CL") ctitle("p_negative") ///


reg p_negative2 post cite_N postXciteN lnWord  Mandatory , r
test cite_N + postXciteN =0
outreg2 using `outdir'/Table6.xls, adjr2 ///
append  sortvar ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory) ///
keep ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CL") ctitle("p_negative") ///


reg p_negative2 post ttcost2 postXcost lnWord Mandatory if  cite_dum ==1  , r
test ttcost2 + postXcost =0
outreg2 using `outdir'/Table6.xls, adjr2 ///
append  sortvar ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory) ///
keep ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CL") ctitle("p_negative") ///


reg p_negative2 post tone_cost2 postXcostp lnWord Mandatory if  cite_dum ==1  , r
test tone_cost2 + postXcostp =0
outreg2 using `outdir'/Table6.xls, adjr2 ///
append  sortvar ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory) ///
keep ( post cite_dum cite_N ttcost2 tone_cost2  postXcite  postXciteN  postXcost  postXcostp lnWord  Mandatory)   ///
excel tstat pdec(3) tdec(3) bdec(3) nocon  ///
title ("CL") ctitle("p_negative") ///

