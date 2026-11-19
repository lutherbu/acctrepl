adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
********************************************************************************
********************************************************************************
//Directory// 
cd "."
********************************************************************************
//Parallel Trend// 
********************************************************************************
********************************************************************************
********************************************************************************
//Parallel Trend//
********************************************************************************
********************************************************************************

use "dta/mca_starting_point_reg.dta", clear

keep if treatment2==1
bysort year dummy_criteria_csr_avg : egen CSR_Ratio=mean(CSRRatio_m_w1)

duplicates drop year dummy_criteria_csr_avg , force 

keep year dummy_criteria_csr_avg CSR_Ratio dummy_criteria_csr_avg


twoway (line CSR_Ratio year if dummy_criteria_csr_avg==1)(line CSR_Ratio year if dummy_criteria_csr_avg==0), xtitle("Years") ytitle("Ratio of CSR to Assets")  legend(label(1 "Treatment") label(2 "Control")) 

********************************************************************************
//Tables//
********************************************************************************
//Table 3: Univariate Comparison Between High And Low CSR Firms//
********************************************************************************
use "dta/mca_starting_point_reg.dta", clear

gen lg_csr=log(.00001+CSRF_m)
gen CSRRatio_univ= CSRF_m/meanprofit
gen CSRRatio_univ_w1=CSRRatio_univ
winsor2 CSRRatio_univ_w1, cuts(1 99) replace
winsor2 CSRF_m, cuts(1 99) replace

*ttest CSRRatio_univ_w1 if sa_pat>0 ,by(post)

ttest CSRRatio_univ_w1 if (treat12==1| treat01==1 | zero==1  ) & sa_pat>0,by(post)
ttest CSRRatio_univ_w1 if (treat12!=1 & treat01!=1 & zero!=1  ) & sa_pat>0,by(post)
ttest CSRRatio_univ_w1 if (treat12==1| treat01==1) & sa_pat>0 ,by(post)

ttest CSRRatio_univ_w1 if zero==1    & sa_pat>0,by(post)
ttest CSRRatio_univ_w1 if treat01==1 & sa_pat>0,by(post)
ttest CSRRatio_univ_w1 if treat12==1 & sa_pat>0,by(post) 
ttest CSRRatio_univ_w1 if treat23==1 & sa_pat>0, by(post)
ttest CSRRatio_univ_w1 if treat34==1 & sa_pat>0, by(post)
ttest CSRRatio_univ_w1 if treat45==1 & sa_pat>0, by(post)
ttest CSRRatio_univ_w1 if treat56==1 & sa_pat>0, by(post)
ttest CSRRatio_univ_w1 if treat67==1 & sa_pat>0, by(post)
ttest CSRRatio_univ_w1 if treat70==1 & sa_pat>0   ,by(post)
ttest CSRRatio_univ_w1 if treat10more==1 & sa_pat>0,by(post)


************************************************************************************
//Table 4:Comparison Between Mandated and Non-Mandated Firms Within High CSR Firms//
************************************************************************************

//Amount//

reghdfe CSRF_m_w1 int_new   if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new   if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new   if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new   if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment2==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment3==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment4==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment5==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(2) tstat coefastr bracket


//Ratio//

reghdfe CSRRatio_m_w1 int_new   if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new   if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new   if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new   if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment3==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment4==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment5==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/table4.xls", dec(4) tstat coefastr bracket

********************************************************************************
//Table 5: Summary Comparison of Accounting Ratios// 
********************************************************************************

gen sa_pat_w=sa_pat
winsor2 sa_pat_w, cuts(1 99) replace

gen sa_total_income_w=sa_total_income
winsor2 sa_total_income_w, cuts(1 99) replace

gen sa_net_worth_w=sa_net_worth
winsor2 sa_net_worth_w, cuts(1 99) replace


gen sa_total_assets_w=sa_total_assets
winsor2 sa_total_assets, cuts(1 99) replace


gen sa_advertising_w=sa_advertising
winsor2 sa_advertising_w, cuts(1 99) replace

gen sa_sales_w=sa_sales
winsor2 sa_sales_w, cuts(1 99) replace


egen tang1=rowtotal(sa_plant sa_cap_wip sa_net_land_n_building sa_oth_fixed_ast)

gen tang1_w=tang1
winsor2 tang1_w, cuts(1 99) replace

gen profitability_w= meanprofits/sa_total_income
gen debeq= sa_long_term_borrowings/sa_net_worth
gen ROE=sa_pbit/sa_net_worth
gen adratio=sa_advertising/sa_total_income
gen profitperemp=sa_pat/sa_no_of_employees
gen tangratio1=tang1/sa_total_assets
gen turn=meansales / sa_total_assets


ttest profitability_w if treatment2==1 & meanprofits>0 , by(dummy_criteria_csr_avg) 
ttest debeq if treatment2==1 , by(dummy_criteria_csr_avg) 
ttest turn if treatment2==1, by(dummy_criteria_csr_avg) 
ttest ROE if treatment2==1 , by(dummy_criteria_csr_avg) 
ttest adratio if treatment2==1 , by(dummy_criteria_csr_avg) 
ttest profitperemp if treatment2==1 , by(dummy_criteria_csr_avg) 

***********************************************************************************************************************
//Table 6: Comparison Between Mandated and Non-Mandated Firms Within High CSR Firms In Terms of Operating Performance//
***********************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear

gen ROE=sa_pbit/sa_net_worth
gen ROA=sa_pbit/sa_total_assets 
gen sales_growth=(sa_sales-lagmeansales)/lagmeansales
gen income_growth=(sa_total_income-meanincome)/meanincome
gen opincome_growth=(sa_cf_net_frm_op_activity-lagopincome_1)/lagopincome_1


gen sa_total_income_w1=sa_total_income
winsor2 sa_total_income_w1, cuts(1 99) replace

gen sales_w1=sales
winsor2 sales_w1, cuts(5 95) replace

gen income_growth_w1=income_growth
winsor2 income_growth_w1, cuts(1 99) replace

gen sales_growth_w1=sales_growth
winsor2 sales_growth_w1, cuts(5 95) replace

gen opincome_growth_w1=opincome_growth
winsor2 opincome_growth_w1, cuts(1 99) replace

gen ROA_w1=ROA
winsor2 ROA_w1, cuts(1 99) replace

gen ROE_w1=ROE
winsor2 ROE_w1, cuts(1 99) replace

gen lg_sales=log(sales_w1)
gen lg_income=log(sa_total_income_w1)


reghdfe ROE_w1 int_new   if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table6.xls", dec(4) tstat coefastr bracket
reghdfe ROA_w1 int_new   if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table6.xls", dec(4) tstat coefastr bracket
reghdfe lg_sales int_new   if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table6.xls", dec(4) tstat coefastr bracket


reghdfe ROE_w1 int_new lagmeanprofits sa_net_worth  if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table6.xls", dec(4) tstat coefastr bracket
reghdfe ROA_w1 int_new lagmeanprofits sa_net_worth  if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table6.xls", dec(4) tstat coefastr bracket
reghdfe lg_sales int_new sa_pat sa_net_worth  if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table6.xls", dec(4) tstat coefastr bracket

***********************************************************************************************************************
//Table 7: The Value Impact Of Mandatory CSR//
***********************************************************************************************************************
//**Use the event study folder in special test section**//
***********************************************************************************************************************
//Table 8: Test of Signaling Hypothesis- Social Media Communication//
***********************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear
keep CIN year treatment2 treatment3 treatment4 treatment5 dummy_criteria_csr_avg nic_code_three sa_finance1_cocode sa_pat sa_net_worth
duplicates drop CIN year, force

save "dta/twitter_treatment.dta", replace 

//Twitter// 

import delimited "raw/twitter_frequency_data.csv", case(preserve) clear 
drop v1 UID
duplicates drop CIN year,force 
merge 1:1 CIN year using "dta/twitter_treatment.dta"
/*
 Result                           # of obs.
    -----------------------------------------
    not matched                       238,526
        from master                    23,098  (_merge==1)
        from using                    215,428  (_merge==2)

    matched                            20,616  (_merge==3)
    -----------------------------------------
*/

keep if _m==3
drop _m 

//regressions// 

gen post=0 
replace post=1 if year>2014

gen int_treatment2=post*treatment2
gen int_csrtreat=post*dummy_criteria_csr_avg


gen prop_csr=csr_main_count/main_count

gen prop_product=(csr_prod_count+csr_prod_growth_count+csr_prod_charity_count)/main_count
gen prop_charity=(csr_charity_count+csr_growth_charity_count+csr_prod_charity_count)/main_count
gen prop_growth=(csr_growth_count+csr_prod_growth_count+csr_growth_charity_count)/main_count

*keep if score>0.85

reghdfe prop_csr int_csrtreat   if treatment2==1 & year>2011 & year<2018 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/table8.xls", dec(2) tstat coefastr bracket
reghdfe prop_product int_csrtreat  if treatment2==1 & year>2011 & year<2018, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table8.xls", dec(2) tstat coefastr bracket
reghdfe prop_charity int_csrtreat  if treatment2==1 & year>2011 & year<2018, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table8.xls", dec(2) tstat coefastr bracket

reghdfe prop_csr int_csrtreat sa_pat sa_net_worth  if treatment2==1 & year>2011 & year<2018, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table8.xls", dec(2) tstat coefastr bracket
reghdfe prop_product int_csrtreat sa_pat sa_net_worth if treatment2==1 & year>2011 & year<2018, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table8.xls", dec(2) tstat coefastr bracket
reghdfe prop_charity int_csrtreat sa_pat sa_net_worth if treatment2==1 & year>2011 & year<2018, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table8.xls", dec(2) tstat coefastr bracket


***********************************************************************************************************************
//Table 9: Test of Signaling Hypothesis- Annual Reports//
***********************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear
keep company_name CIN year treatment2 treatment3 treatment4 treatment5 dummy_criteria_csr_avg nic_code_three sa_finance1_cocode sa_pat sa_net_worth
duplicates drop CIN year, force

save "dta/twitter_treatment.dta", replace 

import delimited "raw/Annual_reports_frequency_data.csv", case(preserve) clear
drop if CIN=="" 
duplicates drop CIN year, force

gen post=0
replace post=1 if year>2014

merge 1:1 CIN year using "dta/twitter_treatment.dta"

keep if _m==3

*csr_count_without growth_count_without product_count_without main_count_without

gen int_treatment2=post*treatment2
gen int_csrtreat=post*dummy_criteria_csr_avg

/*
gen prop_csr=csr_count/main_count

gen prop_product=product_count/main_count
gen prop_charity=charity_count/main_count
gen prop_growth=growth_count/main_count

gen prop_product_w1=prop_product
winsor2 prop_product_w1,cuts(1 99) replace
*/

gen prop_csr=csr_count_without/main_count_without
gen prop_product=product_count_without/main_count_without
gen prop_charity=charity_count_without/main_count_without
gen prop_growth=growth_count_without/main_count_without

replace prop_product=0 if prop_product==.
replace prop_charity=0 if prop_charity==.

gen prop_product_w1=prop_product
winsor2 prop_product_w1,cuts(1 99) replace

reghdfe prop_product int_csrtreat   if treatment2==1   , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/Table9.xls", dec(2) tstat coefastr bracket
reghdfe prop_charity int_csrtreat    if treatment2==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/Table9.xls", dec(2) tstat coefastr bracket


reghdfe prop_product int_csrtreat sa_pat sa_net_worth if treatment2==1   , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/Table9.xls", dec(2) tstat coefastr bracket
reghdfe prop_charity int_csrtreat sa_pat sa_net_worth   if treatment2==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/Table9.xls", dec(2) tstat coefastr bracket


********************************************************************************
********************************************************************************
//Similarity Index//
********************************************************************************
********************************************************************************

clear
import excel "raw/Annual_reports_cosine.xlsx", sheet("Sheet1") firstrow
drop if CIN=="" 
duplicates drop CIN year, force

gen post=0
replace post=1 if year>2014


merge 1:1 CIN year using "dta/twitter_treatment.dta"

keep if _m==3

ttest means if dummy_criteria_csr_avg==1 & treatment2==1, by (post)
ttest means if dummy_criteria_csr_avg==0 & treatment2==1, by (post)

gen int_csrtreat=post*dummy_criteria_csr_avg

reghdfe means int_csrtreat  if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/Table9.xls", dec(2) tstat coefastr bracket

reghdfe means int_csrtreat sa_pat sa_net_worth if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/Table9.xls", dec(2) tstat coefastr bracket



***********************************************************************************************************************
//Table 10: Test of Signaling Hypothesis- Advertisement//
***********************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear

//Amount//

reghdfe adv_w1 int_new  if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new  if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new  if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new  if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new sa_pat sa_net_worth   if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new sa_pat sa_net_worth  if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new sa_pat sa_net_worth  if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket

reghdfe adv_w1 int_new sa_pat sa_net_worth if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(2) tstat coefastr bracket


//Ratio// 
reghdfe adv_ratio_w1 int_new  if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new  if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new  if treatment4==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new  if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new sa_pat sa_net_worth   if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new sa_pat sa_net_worth  if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new sa_pat sa_net_worth  if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket

reghdfe adv_ratio_w1 int_new sa_pat sa_net_worth if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/table10.xls", dec(4) tstat coefastr bracket


*******************************************************************************************************************************
*******************************************************************************************************************************
//Appendix Tables//
*******************************************************************************************************************************
*******************************************************************************************************************************
//Table A4:Pre And Post Comparison Within Mandated High CSR Firms//
*******************************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear

//Amount//

reghdfe CSRF_m_w1 post  if treatment2==1 & dummy_criteria_csr_avg==1, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post   if treatment3==1 & dummy_criteria_csr_avg==1, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post   if treatment4==1 & dummy_criteria_csr_avg==1, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post   if treatment5==1 & dummy_criteria_csr_avg==1, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post sa_pat sa_net_worth   if treatment2==1 & dummy_criteria_csr_avg==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post sa_pat sa_net_worth   if treatment3==1 & dummy_criteria_csr_avg==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post sa_pat sa_net_worth   if treatment4==1 & dummy_criteria_csr_avg==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post sa_pat sa_net_worth   if treatment5==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(2) tstat coefastr bracket


//Ratio//

reghdfe CSRRatio_m_w1 post   if treatment2==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post   if treatment3==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post   if treatment4==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post   if treatment5==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post sa_pat sa_net_worth   if treatment2==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post sa_pat sa_net_worth   if treatment3==1 & dummy_criteria_csr_avg==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post sa_pat sa_net_worth   if treatment4==1 & dummy_criteria_csr_avg==1, absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post sa_pat sa_net_worth   if treatment5==1 & dummy_criteria_csr_avg==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA4.xls", dec(4) tstat coefastr bracket

*******************************************************************************************************
//Table A5:Comparison Between Mandated and Non-Mandated Firms Within Low CSR Firms//
*******************************************************************************************************

//Amount// 
reghdfe CSRF_m_w1 post  if treatment2==0, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 post sa_pat sa_net_worth if treatment2==0, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new   if treatment2==0, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment2==0, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(2) tstat coefastr bracket

//Ratio// 
reghdfe CSRRatio_m_w1 post  if treatment2==0, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 post sa_pat sa_net_worth if treatment2==0, absorb( sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new   if treatment2==0, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth  if treatment2==0, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA5.xls", dec(4) tstat coefastr bracket

******************************************************************************************************
//Table A6:Impact of the CSR Mandate- Triple Interaction//
******************************************************************************************************

gen triple_int=post*treatment2*dummy_criteria_csr_avg
gen treatment2_post=post*treatment2
gen treatment_elig=treatment2*dummy_criteria_csr_avg

reghdfe CSRF_m_w1 triple_int int_new treatment2_post , absorb( year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA6.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 triple_int int_new treatment2_post sa_pat sa_net_worth , absorb( year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA6.xls", dec(2) tstat coefastr bracket

reghdfe CSRRatio_m_w1 triple_int int_new treatment2_post , absorb( year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA6.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 triple_int int_new treatment2_post sa_pat sa_net_worth , absorb( year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA6.xls", dec(4) tstat coefastr bracket

***************************************************************************************************************
//Table A7:Comparison Between Mandated and Non-Mandated Firms Within High CSR Firms- Test of Premandate Trend//
***************************************************************************************************************

reghdfe CSRRatio_m_w1 int_new int_newpre1 int_newpre2 int_newpre3 sa_pat sa_net_worth  if treatment2==1 & year>=2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/tableA7.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new int_newpre1 int_newpre2 int_newpre3 sa_pat sa_net_worth if treatment3==1 & year>=2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/tableA7.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new int_newpre1 int_newpre2 int_newpre3 sa_pat sa_net_worth  if treatment4==1 & year>=2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/tableA7.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new int_newpre1 int_newpre2 int_newpre3 sa_pat sa_net_worth  if treatment5==1 & year>=2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/tableA7.xls", dec(4) tstat coefastr bracket


**************************************************************************************************************
//Table A8: Comparison Between Mandated and Non-Mandated Firms- High CSR- Dropping Years//
**************************************************************************************************************
use "dta/final_data_ready.dta",clear
keep if year<2014
sort CIN year
by CIN: egen Avgcsr=mean(CSRRatiop_m)
duplicates drop CIN, force
xtile tertiles = Avgcsr, nq(3)
gen treatment =1 if tertiles == 3
replace treatment = 0 if tertiles == 1
gen treatment2=0
replace treatment2=1 if Avgcsr>=0.02 & Avgcsr!=.
replace treatment2=. if Avgcsr==.

gen treatment2_placebo=0
replace treatment2_placebo=1 if Avgcsr< 0.02 & Avgcsr!=.
replace treatment2_placebo=. if Avgcsr==.


gen treatment3=0
replace treatment3=1 if Avgcsr>=0.05 & Avgcsr!=.
replace treatment3=. if Avgcsr==.


gen treatment4=0
replace treatment4=1 if Avgcsr>=0.075 & Avgcsr!=.
replace treatment4=. if Avgcsr==.

gen treatment5=0
replace treatment5=1 if Avgcsr>=0.1 & Avgcsr!=.
replace treatment5=. if Avgcsr==.


keep CIN  Avgcsr treatment treatment2 treatment3 treatment4 treatment5 
 
save "dta/treatment_A10.dta",replace


clear
use "dta/mca_starting_point_reg.dta", clear

*keep if year<2015
drop if year==2014 | year==2015
drop post Avgcsr treatment treatment2 treatment3 treatment4 treatment5

gen post=1 if year>2014
replace post=0 if post==.

merge m:1 CIN using "dta/treatment_A10.dta" 
/*
Result                           # of obs.
    -----------------------------------------
    not matched                         8,525
        from master                     8,525  (_merge==1)
        from using                          0  (_merge==2)

    matched                           174,291  (_merge==3)
    -----------------------------------------
*/
keep if _m==3
drop _m

drop avg_ttl_inc avg_ttl_pat avg_ttl_networth dummy_turnover_avg dummy_profit_avg dummy_networth_avg dummy_criteria_csr_avg int_new CSRF_m_w1
bysort sa_finance1_cocode post: egen avg_ttl_inc=mean(sa_total_income)
bysort sa_finance1_cocode post: egen avg_ttl_pat=mean(sa_pat)
bysort sa_finance1_cocode post: egen avg_ttl_networth=mean(sa_net_worth)



gen dummy_turnover_avg=1 if avg_ttl_inc>=10000 & post==0 
gen dummy_profit_avg=1 if avg_ttl_pat>=50 & post==0  
gen dummy_networth_avg=1 if avg_ttl_networth>=5000 & post==0   
replace dummy_turnover_avg=0 if dummy_turnover_avg==.
replace dummy_profit_avg=0 if dummy_profit_avg==.
replace dummy_networth_avg=0 if dummy_networth_avg==.

gen dummy_criteria_csr_avg=1 if (dummy_turnover_avg==1| dummy_profit_avg==1| dummy_networth_avg==1) & post==0
replace dummy_criteria_csr_avg=0 if dummy_criteria_csr_avg==.

gsort sa_finance1_cocode -dummy_criteria_csr_avg
by sa_finance1_cocode: replace dummy_criteria_csr_avg= dummy_criteria_csr_avg[_n-1] if dummy_criteria_csr_avg==0
replace dummy_criteria_csr_avg=0 if dummy_criteria_csr_avg==.


gen int_new=dummy_criteria_csr_avg*post 


gen CSRF_m_w1=CSRF_m
winsor2 CSRF_m_w1, cuts(1 99) replace

//Amount// 
reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment2==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/tableA8.xls", dec(2) tstat coefastr bracket
reghdfe CSRF_m_w1  int_new sa_pat sa_net_worth if treatment3==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
outreg2 using "tables/tableA8.xls", dec(2) tstat coefastr bracket
reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment4==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
outreg2 using "tables/tableA8.xls", dec(2) tstat coefastr bracket
reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment5==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
outreg2 using "tables/tableA8.xls", dec(2) tstat coefastr bracket

//Ratio//
reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth  if treatment2==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
outreg2 using "tables/tableA8.xls", dec(4) tstat coefastr bracket
reghdfe CSRRatio_m_w1  int_new sa_pat sa_net_worth if treatment3==1 , absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
outreg2 using "tables/tableA8.xls", dec(4) tstat coefastr bracket
reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth  if treatment4==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
outreg2 using "tables/tableA8.xls", dec(4) tstat coefastr bracket
reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth  if treatment5==1  , absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
outreg2 using "tables/tableA8.xls", dec(4) tstat coefastr bracket

clear

**************************************************************************************************************
//Table A9: Comparison Between Mandated and Non-Mandated Firms- High CSR-Placebo Test//
**************************************************************************************************************

use "dta/mca_starting_point_reg_placebo.dta", clear


reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment2==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment3==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment4==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment5==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(2) tstat coefastr bracket


reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment3==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment4==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment5==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA9.xls", dec(4) tstat coefastr bracket

/*
cd "[redacted-path-b3713c4373d5]"
use "dta\final_data_ready.dta",clear
keep if year<2013
sort CIN year
by CIN: egen Avgcsr=mean(CSRRatiop_m)
duplicates drop CIN, force
xtile tertiles = Avgcsr, nq(3)
gen treatment =1 if tertiles == 3
replace treatment = 0 if tertiles == 1
gen treatment2=0
replace treatment2=1 if Avgcsr>=0.02 & Avgcsr!=.
replace treatment2=. if Avgcsr==.

gen treatment2_placebo=0
replace treatment2_placebo=1 if Avgcsr< 0.02 & Avgcsr!=.
replace treatment2_placebo=. if Avgcsr==.


gen treatment3=0
replace treatment3=1 if Avgcsr>=0.05 & Avgcsr!=.
replace treatment3=. if Avgcsr==.


gen treatment4=0
replace treatment4=1 if Avgcsr>=0.075 & Avgcsr!=.
replace treatment4=. if Avgcsr==.

gen treatment5=0
replace treatment5=1 if Avgcsr>=0.1 & Avgcsr!=.
replace treatment5=. if Avgcsr==.


keep CIN  Avgcsr treatment treatment2 treatment3 treatment4 treatment5 
 
save "dta\treatment_palcebotar.dta",replace


clear
use "dta\mca_starting_point_reg.dta", clear

keep if year<2015
drop post Avgcsr treatment treatment2 treatment3 treatment4 treatment5

gen post=1 if year>2012
replace post=0 if post==.

merge m:1 CIN using "dta\treatment_palcebotar.dta" 
/*
Result                           # of obs.
    -----------------------------------------
    not matched                        28,637
        from master                     2,292  (_merge==1)
        from using                     26,345  (_merge==2)

    matched                            17,891  (_merge==3)
    -----------------------------------------
*/
keep if _m==3
drop _m

drop avg_ttl_inc avg_ttl_pat avg_ttl_networth dummy_turnover_avg dummy_profit_avg dummy_networth_avg dummy_criteria_csr_avg int_new CSRF_m_w1
bysort sa_finance1_cocode post: egen avg_ttl_inc=mean(sa_total_income)
bysort sa_finance1_cocode post: egen avg_ttl_pat=mean(sa_pat)
bysort sa_finance1_cocode post: egen avg_ttl_networth=mean(sa_net_worth)



gen dummy_turnover_avg=1 if avg_ttl_inc>=10000 & post==0 
gen dummy_profit_avg=1 if avg_ttl_pat>=50 & post==0  
gen dummy_networth_avg=1 if avg_ttl_networth>=5000 & post==0   
replace dummy_turnover_avg=0 if dummy_turnover_avg==.
replace dummy_profit_avg=0 if dummy_profit_avg==.
replace dummy_networth_avg=0 if dummy_networth_avg==.

gen dummy_criteria_csr_avg=1 if (dummy_turnover_avg==1| dummy_profit_avg==1| dummy_networth_avg==1) & post==0
replace dummy_criteria_csr_avg=0 if dummy_criteria_csr_avg==.

gsort sa_finance1_cocode -dummy_criteria_csr_avg
by sa_finance1_cocode: replace dummy_criteria_csr_avg= dummy_criteria_csr_avg[_n-1] if dummy_criteria_csr_avg==0
replace dummy_criteria_csr_avg=0 if dummy_criteria_csr_avg==.


gen int_new=dummy_criteria_csr_avg*post 

keep if year<2015



gen CSRF_m_w1=CSRF_m
winsor2 CSRF_m_w1, cuts(1 99) replace


reghdfe CSRF_m_w1 int_new   if treatment2==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
reghdfe CSRF_m_w1 int_new  if treatment3==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
reghdfe CSRF_m_w1 int_new  if treatment4==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
reghdfe CSRF_m_w1 int_new  if treatment5==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment2==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three)
reghdfe CSRF_m_w1  int_new sa_pat sa_net_worth  if treatment3==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment4==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)
reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth  if treatment5==1 & year>2010, absorb(year sa_finance1_cocode) vce(cluster nic_code_three year)

*/
******************************************************************************************************************
//Table A10: Comparison Between Mandated and Non-Mandated Firms- High CSR-Excluding Firms Close to the Threshold//
******************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear


reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment2==1 & max_dis<1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment3==1 & max_dis<1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment4==1 & max_dis<1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1 int_new sa_pat sa_net_worth   if treatment5==1 & max_dis<1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(2) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment2==1 & max_dis<1  , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment3==1 & max_dis<1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment4==1 & max_dis<1  , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1 int_new sa_pat sa_net_worth   if treatment5==1 & max_dis<1  , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA10.xls", dec(4) tstat coefastr bracket

******************************************************************************************************************
//Table A11: Test of Signaling Hypothesis- CSR And Advertising Expenditure//
******************************************************************************************************************
use "dta/mca_starting_point_reg.dta", clear

egen ttl_exp=rsum(CSRF_m adv_sum),missing 
gen ttl_exp_ratio=ttl_exp/lagmeanassets

winsor2 ttl_exp, cuts(1, 99)

winsor2 ttl_exp_ratio, cuts(1, 99)


//Amount//
reghdfe ttl_exp int_new sa_pat sa_net_worth   if treatment2==1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

reghdfe ttl_exp int_new sa_pat sa_net_worth   if treatment3==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

reghdfe ttl_exp int_new sa_pat sa_net_worth   if treatment4==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

reghdfe ttl_exp int_new sa_pat sa_net_worth   if treatment5==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

//Ratio//
reghdfe ttl_exp_ratio int_new sa_pat sa_net_worth   if treatment2==1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

reghdfe ttl_exp_ratio int_new sa_pat sa_net_worth   if treatment3==1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

reghdfe ttl_exp_ratio int_new sa_pat sa_net_worth   if treatment4==1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

reghdfe ttl_exp_ratio int_new sa_pat sa_net_worth   if treatment5==1  , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA11.xls", dec(2) tstat coefastr bracket

******************************************************************************************************************
//Table A12: Comparison Between Mandated and Non-Mandated Firms Within High CSR- The Consumer Channel//
******************************************************************************************************************
clear
import delimited "raw/stock_unit.txt", delimiter("|")

destring  purchase_qty clubflag_purchase_qty purchase_val clubflag_purchase_val opening_stock_qty clubflag_opening_stock_qty opening_stock_val ///
clubflag_opening_stock_val closing_stock_qty clubflag_closing_stock_qty closing_stock_val clubflag_closing_stock_val sales_qty clubflag_sales_qty sales_value ///
clubflag_sales_value, replace force

egen ttl_stk=rsum(purchase_qty opening_stock_qty), missing 
gen net_sold_stk=ttl_stk-closing_stock_val
gen price=sales_value/net_sold_stk
gen price_2=sales_value/sales_qty

tostring prod_date, replace 
gen day=substr(prod_date,7,2)
gen month=substr(prod_date,5,2)
gen year=substr(prod_date,1,4)
destring month day year, replace 
gen date=mdy(month,day,year)
format date %tdCCYYNNDD

egen stk=rsum(purchase_val opening_stock_val), missing 
gen net_stk_val=stk-closing_stock_val
keep products_cocode company_name product_name products_product_code year month date price_2  stk net_stk_val
duplicates drop products_cocode company_name product_name products_product_code year, force 
rename products_cocode sa_finance1_cocode 


bysort sa_finance1_cocode year: egen avg_price=mean(price_2)
bysort sa_finance1_cocode year: egen cogs=sum(net_stk_val)


save "dta/stk.dta", replace

use "dta/mca_starting_point_reg.dta", clear

keep CIN year sa_finance1_cocode treatment2 treatment3 treatment4 treatment5 nic_code_three int_new dummy_criteria_csr_avg post sa_sales sa_pat sa_net_worth

merge 1:m sa_finance1_cocode year using "dta/stk.dta"
keep if _m==3
drop _m

winsor2 price_2,cuts(1 99)
gen lg_price=log(0.00000001+price_2)
reghdfe lg_price int_new  i.year if treatment2==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
reghdfe price_2 int_new  i.year if treatment2==1 , absorb( products_product_code sa_finance1_cocode) vce(cluster nic_code_three ) //close//
reghdfe price_2 int_new sa_pat sa_net_worth i.year if treatment2==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three ) //close//
reghdfe price_2_w int_new  i.year if treatment2==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )



reghdfe lg_price int_new  i.year if treatment2==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket
reghdfe lg_price int_new  i.year if treatment3==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket
reghdfe lg_price int_new  i.year if treatment4==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket
reghdfe lg_price int_new  i.year if treatment5==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket


reghdfe lg_price int_new sa_pat sa_net_worth i.year if treatment2==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket
reghdfe lg_price int_new sa_pat sa_net_worth i.year if treatment3==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket
reghdfe lg_price int_new sa_pat sa_net_worth i.year if treatment4==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket
reghdfe lg_price int_new sa_pat sa_net_worth i.year if treatment5==1 , absorb(products_product_code sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA12.xls", dec(4) tstat coefastr bracket




*************************************************************************************************
//Table A13: Comparison Between Mandated and Non-Mandated Firms Within High CSR- Labor Donations Channel//
*************************************************************************************************

clear
import delimited "raw/wages.txt", delimiter("|", collapse)
tostring sa_finance1_year , replace
gen year=substr( sa_finance1_year ,1,4)
gen month=substr( sa_finance1_year ,5,2)
gen day=substr( sa_finance1_year ,7,2)
destring month year day, replace

keep if month==3
gsort sa_finance1_cocode -day
duplicates drop sa_finance1_cocode year, force

merge 1:1 sa_finance1_cocode year using "dta/mca_starting_point_reg.dta", force
/*
Result                           # of obs.
    -----------------------------------------
    not matched                       126,431
        from master                   121,966  (_merge==1)
        from using                      4,465  (_merge==2)

    matched                           231,579  (_merge==3)
    -----------------------------------------
*/
keep if _m==3
destring sa_compensation_to_employees, replace force
gen wages= sa_compensation_to_employees/sa_total_income

winsor2 wages, cuts(1,99)


reghdfe wages int_new   if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new   if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new   if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new   if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new sa_pat sa_net_worth   if treatment2==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new sa_pat sa_net_worth   if treatment3==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new sa_pat sa_net_worth   if treatment4==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket
reghdfe wages int_new sa_pat sa_net_worth   if treatment5==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA13.xls", dec(4) tstat coefastr bracket

********************************************************************************
//Table A14: Preempting Public Or Private Politics//
********************************************************************************

clear
use "dta/mca_starting_point_reg.dta",clear 

merge m:1 sa_finance1_cocode using "dta/pol.dta"
/*

    Result                           # of obs.
    -----------------------------------------
    not matched                        14,308
        from master                     2,977  (_merge==1)
        from using                     11,331  (_merge==2)

    matched                           233,067  (_merge==3)
    -----------------------------------------
*/
keep if _merge ==3
drop _merge


replace dummy_red=0 if dummy_red==.

gen redpost=dummy_red*post
gen triplered1=dummy_red*post*treatment2
gen triplered2=dummy_red*post*treatment3
gen triplered3=dummy_red*post*treatment4
gen triplered4=dummy_red*post*treatment5

gen redeli= dummy_criteria_csr_avg*dummy_red
gen tri=dummy_criteria_csr_avg*post*dummy_red


/* Highly Polluting Firms- eli vs non eli*/


reghdfe CSRF_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket
reghdfe CSRF_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket
reghdfe CSRF_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket
reghdfe CSRF_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket


reghdfe CSRRatio_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment2==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket
reghdfe CSRRatio_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment3==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket
reghdfe CSRRatio_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment4==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket
reghdfe CSRRatio_m_w1 int_new redpost tri sa_pat sa_net_worth if treatment5==1, absorb(year sa_finance1_cocode) vce(cluster nic_code_three )
outreg2 using "tables/tableA14.xls", dec(2) tstat coefastr bracket


//Panel B//
//**Use climate measures folder**//

********************************************************************************
//Table A15: Comparison Between Mandated and Non-Mandated Firms- Compliance And Signaling //
********************************************************************************
clear
use "dta/mca_starting_point_reg.dta",clear 

keep if post==0 
keep CIN year sa_finance1_cocode sa_total_assets

bysort CIN: egen avg_asset=mean( sa_total_assets)
duplicates drop CIN, force
keep CIN avg_asset
egen mean=mean( avg_asset)
gen large_firms=0
replace large_firms=1 if avg_asset>mean
keep CIN large_firms

merge 1:m CIN using "dta/mca_starting_point_reg.dta"
keep if _m==3

gen triple_large=post*dummy_criteria_csr_avg*large_firms
gen post_mandate=post*dummy_criteria_csr_avg
gen post_large=post*large_firms
gen large_mandate=large_firms*dummy_criteria_csr_avg

reghdfe CSRF_m_w1   post_mandate post_large triple_large  if treatment2==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA15.xls", dec(2) tstat coefastr bracket

reghdfe CSRF_m_w1   post_mandate post_large triple_large sa_pat sa_net_worth   if treatment2==1 , absorb(sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA15.xls", dec(2) tstat coefastr bracket


reghdfe CSRRatio_m_w1  post_mandate post_large triple_large    if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA15.xls", dec(4) tstat coefastr bracket

reghdfe CSRRatio_m_w1  post_mandate post_large triple_large sa_pat sa_net_worth   if treatment2==1 , absorb(year sa_finance1_cocode) vce(cluster nic_prod_code )
outreg2 using "tables/tableA15.xls", dec(4) tstat coefastr bracket

