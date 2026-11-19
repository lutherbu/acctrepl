adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
**************************Alternative Income Shifting Measure Test
*Import Table 6 data
use "Table 6.dta", clear

*Demean variables
summarize avgftr score
gen avgftr_dm=avgftr+.050921
gen score_dm=score+9.42184

*Baseline
vce2way nlsur ///
    (dpifo={a0}+(1- ///
        ({gamma0}+{gamma2}*avgftr+{gamma4}*ros+{gamma5}*rd_at+{gamma6}*ads_at+{gamma7}*intan_at+{gamma8}*cash_at+{gamma9}*debt_at+{gamma10}*size))* ///
        ({pi_f0}+{pi_f2}*avgftr+{pi_f3}*ros+{pi_f4}*rd_at+{pi_f5}*ads_at+{pi_f6}*intan_at+{pi_f7}*cash_at+{pi_f8}*debt_at+{pi_f9}*size)*dsalefo ///
        +({theta0}+{theta2}*avgftr+{theta4}*ros+{theta5}*rd_at+{theta6}*ads_at+{theta7}*intan_at+{theta8}*cash_at+{theta9}*debt_at+{theta10}*size)* ///
        ({pi_d0}+{pi_d2}*avgftr+{pi_d3}*ros+{pi_d4}*rd_at+{pi_d5}*ads_at+{pi_d6}*intan_at+{pi_d7}*cash_at+{pi_d8}*debt_at+{pi_d9}*size)*dsaledom) ///
    (dpidom={b0}+ ///
        ({gamma0}+{gamma2}*avgftr+{gamma4}*ros+{gamma5}*rd_at+{gamma6}*ads_at+{gamma7}*intan_at+{gamma8}*cash_at+{gamma9}*debt_at+{gamma10}*size)* ///
        ({pi_f0}+{pi_f2}*avgftr+{pi_f3}*ros+{pi_f4}*rd_at+{pi_f5}*ads_at+{pi_f6}*intan_at+{pi_f7}*cash_at+{pi_f8}*debt_at+{pi_f9}*size)*dsalefo ///
        +(1-({theta0}+{theta2}*avgftr+{theta4}*ros+{theta5}*rd_at+{theta6}*ads_at+{theta7}*intan_at+{theta8}*cash_at+{theta9}*debt_at+{theta10}*size))* ///
        ({pi_d0}+{pi_d2}*avgftr+{pi_d3}*ros+{pi_d4}*rd_at+{pi_d5}*ads_at+{pi_d6}*intan_at+{pi_d7}*cash_at+{pi_d8}*debt_at+{pi_d9}*size)), ///
    cluster (gvkey fyear)

*Full model
vce2way nlsur ///
    (dpifo={a0}+(1- ///
        ({gamma0}+{gamma1}*score+{gamma2}*avgftr+{gamma3}*score_dm*avgftr_dm+{gamma4}*ros+{gamma5}*rd_at+{gamma6}*ads_at+{gamma7}*intan_at+{gamma8}*cash_at+{gamma9}*debt_at+{gamma10}*size))* ///
        ({pi_f0}+{pi_f1}*score+{pi_f2}*avgftr+{pi_f3}*ros+{pi_f4}*rd_at+{pi_f5}*ads_at+{pi_f6}*intan_at+{pi_f7}*cash_at+{pi_f8}*debt_at+{pi_f9}*size+{pi_f10}*score_dm*avgftr_dm)*dsalefo ///
        +({theta0}+{theta1}*score+{theta2}*avgftr+{theta3}*score_dm*avgftr_dm+{theta4}*ros+{theta5}*rd_at+{theta6}*ads_at+{theta7}*intan_at+{theta8}*cash_at+{theta9}*debt_at+{theta10}*size)* ///
        ({pi_d0}+{pi_d1}*score+{pi_d2}*avgftr+{pi_d3}*ros+{pi_d4}*rd_at+{pi_d5}*ads_at+{pi_d6}*intan_at+{pi_d7}*cash_at+{pi_d8}*debt_at+{pi_d9}*size+{pi_d10}*score_dm*avgftr_dm)*dsaledom) ///
    (dpidom={b0}+ ///
        ({gamma0}+{gamma1}*score+{gamma2}*avgftr+{gamma3}*score_dm*avgftr_dm+{gamma4}*ros+{gamma5}*rd_at+{gamma6}*ads_at+{gamma7}*intan_at+{gamma8}*cash_at+{gamma9}*debt_at+{gamma10}*size)* ///
        ({pi_f0}+{pi_f1}*score+{pi_f2}*avgftr+{pi_f3}*ros+{pi_f4}*rd_at+{pi_f5}*ads_at+{pi_f6}*intan_at+{pi_f7}*cash_at+{pi_f8}*debt_at+{pi_f9}*size+{pi_f10}*score_dm*avgftr_dm)*dsalefo ///
        +(1-({theta0}+{theta1}*score+{theta2}*avgftr+{theta3}*score_dm*avgftr_dm+{theta4}*ros+{theta5}*rd_at+{theta6}*ads_at+{theta7}*intan_at+{theta8}*cash_at+{theta9}*debt_at+{theta10}*size))* ///
        ({pi_d0}+{pi_d1}*score+{pi_d2}*avgftr+{pi_d3}*ros+{pi_d4}*rd_at+{pi_d5}*ads_at+{pi_d6}*intan_at+{pi_d7}*cash_at+{pi_d8}*debt_at+{pi_d9}*size+{pi_d10}*score_dm*avgftr_dm)*dsaledom), ///
    cluster (gvkey fyear)

/*Note: The parameter names above must be manually adjusted for presentation purposes (Table 6).*/
