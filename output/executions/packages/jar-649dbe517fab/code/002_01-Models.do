adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
/******************************************************************************/
/* Title:	Evaluation of Simulated Data from Dynamic Investment Model 		  */
/* Authors: M. Breuer, D. W. Windisch                        	          	  */
/* Date:    09/12/2017                                                  	  */
/******************************************************************************/
/* Program description:														  */
/* Generating Figures and Tables using simulated data						  */
/******************************************************************************/

/* Preliminaries */
version 13.1
clear all
set more off

/******************************************************************************/
/* Basic Model: Simulation data (based on calibrated parameter values)		  */
/******************************************************************************/

/* Directory */
cd "$directory/Code/Models/01-Basic model/Simulation/Data"

/* Data */
insheet using Simulations.csv, nonames clear

/* Time-series definition */

	/* Time dimension */
	gen t = _n
	label var t "Period"

	/* Set time series */
	tsset t
		
/* Model parameters */

	/* Discount rate (expected return) */
	local r = 0.1
	
	/* Persistence */
	local rho = 0.7
	
	/* Mean profitability */
	local mean = 1.5
	
/* Variables */

	/* Destring */
	qui destring v8, replace force
	
	/* Renaming model outputs */
	rename v1 earnings
	label var earnings "Earnings"

	rename v2 cash
	label var cash "Cash from Operations"

	rename v3 price
	label var price "Price"

	rename v4 profitability
	label var profitability "Profitability"

	rename v5 investment
	label var investment "Investment"

	rename v6 capital
	label var capital "Capital" // Note: Capital is beginning of period capital

	rename v7 adj_cost
	label var adj_cost "Adjustment cost"

	rename v8 surprise
	label var surprise "Surprise"
	
	/* Variable transformations */
	gen z = profitability - ((1-`rho')*`mean' + `rho'*l.profitability)
	label var z "Profitability shock"
	
	gen price_ex_div = price - cash + investment
	label var price_ex_div "Price (ex dividend)"

	gen ear = earnings/l.price_ex_div
	label var ear "Earnings(t)/Price(t-1)"

	gen l_ear = l.earnings/l.price_ex_div
	label var l_ear "Earnings(t-1)/Price(t-1)"
	
	gen cfo = cash/l.price_ex_div
	label var cfo "CFO(t)/Price(t-1)"

	gen ret = price/l.price_ex_div - (1 + `r')
	label var ret "Return"
	
	gen dear = d.earnings/l.price_ex_div
	label var dear "Change in Earnings/Price(t-1)"
	
	gen dear_c = d.earnings/capital
	label var dear "Change in Earnings/Capital(t-1)"
		
	gen fcapital = f.capital
	label var fcapital "Capital (t)"

	gen inv = investment/l.price_ex_div
	label var inv "Investment(t)/Price(t-1)"
	
	gen inv_price = 1/l.price_ex_div
	label var inv_price "1/Price(t-1)"

	gen mtb = price/capital
	label var mtb "Market-to-Book"	
	
	gen loss = (earnings < 0)
	label var loss "Loss"	
	
	gen d = (ret<0)
	label var d "Negative Return Indicator"
	
	gen d_earnings = (l.earnings < 0)
	label var d_earnings "Negative Earnings Indicator"
	
	gen d_dearnings = (l.d.earnings < 0)
	label var d_dearnings "Negative Earnings Change Indicator"
	
	gen d_dear = (l.dear < 0)
	label var d_dear "Negative Earnings Change/Price Indicator"
	
	gen d_dear_c = (l.dear_c < 0)
	label var d_dear_c "Negative Earnings Change/Capital Indicator"
		
	gen sue = surprise/l.price_ex_div
	label var sue "Earnings Surprise"
	
	gen abs_sue = abs(sue)
	label var sue "Absolute Earnings Surprise"
	
	/* AR(1) earnings surprise */
	qui reg earnings l.earnings
	qui predict sue_res, res
	label var sue_res "Earnings Surprise"

	gen sue_e = sue_res/l.price_ex_div
	label var sue_e "Earnings Surprise"	

/* Outlier treatment */

	/* Drop burn-in period */
	drop if t<=1000 | t>101000
	
	/* Drop extreme values (ensure positive value function) */
	drop if price < 0
	drop if abs(ret) > 1
	
/* Panel definition */
	
	/* Firm dimension */
	gen firm = ceil(t/25)
	label var firm "Firm"
	
	/* Set panel structure */
	xtset firm t
	
/* Endogenous split variables (by firm) */	

	/* Mean */
	egen mean_mtb = mean(mtb), by(firm)

	/* Standard deviation */
	egen sd_ear = sd(ear), by(firm)
	
/* Quintiles */
	
	/* Earnings volatility */
	xtile q_sd_ear = sd_ear, nq(5)
	
	/* Investment */
	xtile q_inv = investment, nq(5)

/* Persistence, earnings-response coefficient, and earnings-return asymmetry (by firm) */
 
	/* Placeholders */
	gen rho = .
	gen erc = .
	gen basu = .
	
	/* Loop */
	qui sum firm, d
	qui forvalues q = `r(min)'(1)`r(max)' {
		capture {
			/* Earnings persistence */
			reg earnings l.earnings if firm == `q'
			replace rho = _b[L.earnings] if firm == `q'
			
			/* Earnings response coefficient */
			reg ret sue if firm == `q'
			replace erc = _b[sue] if firm == `q'
			
			/* Earnings-return coefficient */
			reg ear c.ret##i.d if firm == `q'
			replace basu = _b[1.d#c.ret] if firm == `q'
			
		}
	}	
	
/* Leads and lags for future earnings-response coefficient regression */

	/* Earnings growth */
	gen x_0 = ln(earnings/l.earnings)
	gen x_1 = f1.x_0
	gen x_2 = f2.x_0
	gen x_3 = f3.x_0
	gen x_1_3 = exp(ln(1+x_1) + ln(1+x_2) + ln(1+x_3))-1 
	
	/* Returns */
	gen ret_1 = f1.ret
	gen ret_2 = f2.ret
	gen ret_3 = f3.ret
	gen ret_1_3 = exp(ln(1+ret_1) + ln(1+ret_2) + ln(1+ret_3))-1 

	/* Other */
	gen ep = l.earnings/l.price
	gen ag = ln(capital/l.capital)	
	
/* Save */
cd "$directory/Data/Output"
save Simulation, replace

/******************************************************************************/
/* Basic Model: Simulation data (based on varying parameter values)	  		  */
/******************************************************************************/

/* Directory */
cd "$directory/Code/Models/01-Basic model/Simulation/Data"

/* Data */
insheet using Predictions.csv,  clear

/* Variable names */

	/* Identifiers */
	rename v1 i
	label var i "Parameter"

	rename v2 j
	label var j "Step"

	/* Parameters */
	rename v3 p1
	rename v4 p2
	rename v5 p3
	rename v6 p4


	/* Destring */
	qui destring v*, replace force

	/* Coefficients */
	rename v7 ear_0
	label var ear_0 "Positive slope (Earnings)"

	rename v8 ear_1
	label var ear_1 "Incremental negative slope (Earnings)"

	rename v9 erc
	label var erc "Earnings-Response Coefficient"

	gen ear_2 = ear_0 + ear_1
	label var ear_2 "Negative slope (Earnings)"

	gen ear = ear_2 / (ear_0 + ear_2)
	label var ear "Share of negative slope (Earnings)"

/* Reshape */
egen ij=group(i j)
reshape long p, i(ij) j(parameter)

/* Paramter Values */
rename p values
label var values "Parameter Values"

label var parameter "Parameter"
label define parameter 1 "std_epsilon" 2 "psi" 3 "rho" 4 "r"
label values parameter parameter

/* Save */
cd "$directory/Data/Output"
save ComparativeStatics, replace

/******************************************************************************/
/* Alternative Models: Simulation data (based on calibrated parameter values) */
/******************************************************************************/

/* Model directories */
local directory_1 = "$directory/Code/Models/03-Model 1 (no delay, no adjustment cost)/Simulation/Data"
local directory_2 = "$directory/Code/Models/04-Model 2 (no adjustment cost)/Simulation/Data"
local directory_3 = "$directory/Code/Models/05-Model 3 (no delay)/Simulation/Data"

/* Loop over models */
forvalues i = 1(1)3 {

	/* Directory */
	cd "`directory_`i''"

	/* Data */
	if `i' == 1 {
		insheet using Simulations_nodelay_nocost.csv, nonames clear
	}
	
	if `i' == 2 {
		insheet using Simulations_nocost.csv, nonames clear
	}
	
	if `i' == 3 {
		insheet using Simulations_nodelay.csv, nonames clear
	}	
	
	/* Time-series definition */

		/* Time dimension */
		gen t = _n
		label var t "Period"

		/* Set time series */
		tsset t
		
	/* Variables */

		/* Destring */
		qui destring v8, replace force
		
		/* Renaming model outputs */
		rename v1 earnings
		label var earnings "Earnings"

		rename v2 cash
		label var cash "Cash from Operations"

		rename v3 price
		label var price "Price"

		rename v4 profitability
		label var profitability "Profitability"

		rename v5 investment
		label var investment "Investment"

		rename v6 capital
		label var capital "Capital" // Note: Capital is beginning of period capital

		rename v7 adj_cost
		label var adj_cost "Adjustment cost"

		rename v8 surprise
		label var surprise "Surprise"
		
		/* Variable transformations */
		gen z = profitability - ((1-`rho')*`mean' + `rho'*l.profitability)
		label var z "Profitability shock"
		
		gen price_ex_div = price - cash + investment
		label var price_ex_div "Price (ex dividend)"

		gen ear = earnings/l.price_ex_div
		label var ear "Earnings(t)/Price(t-1)"

		gen cfo = cash/l.price_ex_div
		label var cfo "CFO(t)/Price(t-1)"

		gen ret = price/l.price_ex_div - (1 + `r')
		label var ret "Return"
		
		gen dear = d.earnings/l.price_ex_div
		label var dear "Change in Earnings/Price(t-1)"
		
		gen dear_c = d.earnings/capital
		label var dear "Change in Earnings/Capital(t-1)"
			
		gen fcapital = f.capital
		label var fcapital "Capital (t)"

		gen inv_price = 1/l.price_ex_div
		label var inv_price "1/Price(t-1)"

		gen mtb = price/capital
		label var mtb "Market-to-Book"	
		
		gen loss = (earnings < 0)
		label var loss "Loss"	
		
		gen d = (ret<0)
		label var d "Negative Return Indicator"
		
		gen d_earnings = (l.earnings < 0)
		label var d_earnings "Negative Earnings Indicator"
		
		gen d_dearnings = (l.d.earnings < 0)
		label var d_dearnings "Negative Earnings Change Indicator"
		
		gen d_dear = (l.dear < 0)
		label var d_dear "Negative Earnings Change/Price Indicator"
		
		gen d_dear_c = (l.dear_c < 0)
		label var d_dear_c "Negative Earnings Change/Capital Indicator"
			
		gen sue = surprise/l.price_ex_div
		label var sue "Earnings Surprise"
		
		gen abs_sue = abs(sue)
		label var sue "Absolute Earnings Surprise"
		
		/* AR(1) earnings surprise */
		qui reg earnings l.earnings
		qui predict sue_res, res
		label var sue_res "Earnings Surprise"

		gen sue_e = sue_res/l.price_ex_div
		label var sue_e "Earnings Surprise"	

	/* Outlier treatment */

		/* Drop burn-in period */
		drop if t<=1000 | t>101000
		
		/* Drop extreme values (ensure positive value function) */
		drop if price < 0
		drop if abs(ret) > 1
		
	/* Panel definition */
		
		/* Firm dimension */
		gen firm = ceil(t/25)
		label var firm "Firm"
		
		/* Set panel structure */
		xtset firm t
		
	/* Endogenous split variables (by firm)*/	

		/* Mean */
		egen mean_mtb = mean(mtb), by(firm)

		/* Standard deviation */
		egen sd_ear = sd(ear), by(firm)

	/* Quintiles */
		
		/* Earnings volatility */
		xtile q_sd_ear = sd_ear, nq(5)
		
		/* Investment */
		xtile q_inv = investment, nq(5)
	
	/* Persistence, earnings-response coefficient, and earnings-return asymmetry (by firm) */
	 
		/* Placeholders */
		gen rho = .
		gen erc = .
		gen basu = .
		
		/* Loop */
		qui sum firm, d
		qui forvalues q = `r(min)'(1)`r(max)' {
			capture {
				/* Earnings persistence */
				reg earnings l.earnings if firm == `q'
				replace rho = _b[L.earnings] if firm == `q'
				
				/* Earnings response coefficient */
				reg ret sue if firm == `q'
				replace erc = _b[sue] if firm == `q'
				
				/* Earnings-return coefficient */
				reg ear c.ret##i.d if firm == `q'
				replace basu = _b[1.d#c.ret] if firm == `q'
				
			}
		}	
		
	/* Leads and lags for future earnings-response coefficient regression */

		/* Earnings growth */
		gen x_0 = ln(earnings/l.earnings)
		gen x_1 = f1.x_0
		gen x_2 = f2.x_0
		gen x_3 = f3.x_0
		gen x_1_3 = exp(ln(1+x_1) + ln(1+x_2) + ln(1+x_3))-1 
		
		/* Returns */
		gen ret_1 = f1.ret
		gen ret_2 = f2.ret
		gen ret_3 = f3.ret
		gen ret_1_3 = exp(ln(1+ret_1) + ln(1+ret_2) + ln(1+ret_3))-1 

		/* Other */
		gen ep = l.earnings/l.price
		gen ag = ln(capital/l.capital)	
			
	/* Save */
	cd "$directory/Data/Output"
	save Simulation_Model_`i', replace

/* End: loop over models */
}

/******************************************************************************/
/* Manuscript: Figures and Tables											  */
/******************************************************************************/

/* Log */
cd "$directory/Results/Models/Logs"
log using Manuscript, replace smcl name(Manuscript)
	
/* 3. Economic model */	
	
	/* d. Policy function */	
	
		/* Figure 1: Capital and profitability */
			
			/* Data: Simulation */
			cd "$directory/Data/Output"
			use Simulation, clear
			
			/* Results Directory */
			cd "$directory/Results/Models/Figures"			
		
			/* Figure */
			graph twoway ///
				(lpolyci capital profitability, clcolor(black)) ///
				(lpolyci fcapital profitability, clcolor(black) clpattern(dash)) ///
				, legend(label(2 "Capital (t)") label(4 "Capital (t+1)") rows(3) order(1 2 4) ring(0) position(11) bmargin(medium) symxsize(5)) /// 
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xtitle("Profitability (t)") ///
				xline(1.5, lcolor(gs10) lpattern(dash)) ///
				ylabel(, format(%9.0f) angle(0)) /// 				
				title("Capital and Profitability", color(black)) ///
				name(Figure_1, replace) saving(Figure_1, replace)
				version 18: graph export "Figure_1.pdf", as(pdf) replace name(Figure_1)
	
		/* Figure 2: Impulse response of investment and capital with respect to profitability shocks */

			/* IRF investment */
			qui var investment profitability, lags(1/10)
			qui irf create irf, set(irf, replace)
			irf graph irf ///
				, impulse(profitability) response(investment) ///
				legend(label(1 "CI 95%") label(2 "Impulse Response Function") rows(1) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Impulse Response: Profitability and Investment", color(black)) ///
				name(IRF_Investment, replace)
	
			/* IRF capital */
			qui var capital profitability, lags(1/10)
			qui irf create irf, set(irf, replace)
			irf graph irf ///
				, impulse(profitability) response(capital) ///
				legend(label(1 "CI 95%") label(2 "Impulse Response Function") rows(1) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Impulse Response: Profitability and Capital", color(black)) ///
				name(IRF_Capital, replace)
	
			/* Combined figure */
			graph combine IRF_Investment IRF_Capital, ///
				altshrink cols(3)  ysize(4) xsize(10) ///
				title("Investment and Capital Dynamics", color(black)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_2, replace)	saving(Figure_2, replace)	
				version 18: graph export "Figure_2.pdf", as(pdf) replace name(Figure_2)
		
/* 4. Model predictions */

	/* a. Distributions */
	
		/* Figure 3: Histograms of profitability, investment, earnings, and returns */
		
			/* Profitability */
			hist profitability ///
				, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Histogram of Profitability Levels", color(black)) ///
				ylabel(, format(%9.1f) angle(0)) /// 								
				name(Profitability, replace)

			/* Investment */				
			hist investment ///
				, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Histogram of Investment Levels", color(black)) ///
				ylabel(, format(%9.2f) angle(0)) /// 												
				name(Investment, replace)
	
			/* Earnings */
			hist earnings ///
				, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Histogram of Earnings Levels", color(black)) ///
				ylabel(, format(%9.3f) angle(0)) /// 								
				name(Earnings, replace)
	
			/* Returns */
			hist ret ///
				, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Histogram of Returns", color(black)) ///
				ylabel(, format(%9.0f) angle(0)) /// 								
				name(Returns, replace)

			/* Combined figure */
			graph combine Profitability Investment Earnings Returns, ///
				altshrink cols(4) ysize(4) xsize(15) ///
				title("Profitability, Investment, Earnings, and Returns", color(black)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_3, replace) saving(Figure_3, replace)
				version 18: graph export "Figure_3.pdf", as(pdf) replace name(Figure_3)
	
		/* Figure 4: Histograms of price and earnings scaled by lagged price */
	
			/* Price */
			hist price ///
				, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Histogram of Price Levels", color(black)) ///
				ylabel(, format(%9.3f) angle(0)) /// 
				name(Price, replace)
			
			/* Earnings scaled by lagged price */
			hist ear ///
				, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Histogram of Scaled Earnings", color(black)) ///
				ylabel(, format(%9.0f) angle(0)) /// 								
				name(Earnings_Scaled, replace)
				
			/* Combined figure */
			graph combine Price Earnings_Scaled, ///
				altshrink cols(2) ysize(4) xsize(10) ///
				title("Price and Scaled Earnings", color(black)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_4, replace)	saving(Figure_4, replace) 	
				version 18: graph export "Figure_4.pdf", as(pdf) replace name(Figure_4)
				
	/* b. Persistence of earnings levels and changes */
	
		/* Table 3: Differential persistence */
		
			/* Column 1: Earnings persistence */
			qui xtreg earnings c.l.earnings##1.d_earnings, fe cluster(firm)
				est store M1
				
			/* Column 2: Earnings change persistence */
			qui xtreg d.earnings c.l.d.earnings##1.d_dearnings, fe cluster(firm)
				est store M2
		
			/* Column 3: Earnings change (scaled by price) persistence (Basu (1997)) */
			qui xtreg dear c.l.dear##1.d_dear, fe cluster(firm)
				est store M3		
		
			/* Column 4: Earnings change (scaled by capital) persistence (Ball/Shivakumar (2005)) */
			qui xtreg dear_c c.l.dear_c##1.d_dear_c, fe cluster(firm)
				est store M4			

			/* Combined table */
			estout M1 M2 M3 M4, keep(L.earnings 1.d_earnings 1.d_earnings#cL.earnings LD.earnings 1.d_dearnings 1.d_dearnings#cLD.earnings ///
				L.dear 1.d_dear 1.d_dear#cL.dear L.dear_c 1.d_dear_c 1.d_dear_c#cL.dear_c) ///
				cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(L.earnings "E (t-1)" 1.d_earnings "D(E (t-1) < 0)" 1.d_earnings#cL.earnings "E*D(E < 0)" ///
				LD.earnings "d.E (t-1)" 1.d_dearnings "D(d.E < 0)" 1.d_dearnings#cLD.earnings "d.E*D(d.E < 0)" ///
				L.dear "d.E/P (t-1)" 1.d_dear "D(d.E/P < 0)" 1.d_dear#cL.dear "d.E/P*D(d.E/P < 0)" ///
				L.dear_c "d.E/K (t-1)" 1.d_dear_c "D(d.E/K < 0)" 1.d_dear_c#cL.dear_c "d.E/K*D(d.E/K < 0)") ///
				mlabels("[1] Earnings" "[2] d.Earnings" "[3] d.Earnings/Price" "[4] d.Earnings/Capital")  modelwidth(20) unstack ///
				title("Table 3: Asymmetric Earnings Persistence") ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))		
		
	/* c. Earnings-response coefficient */
	
		/* Figure 5: Earnings-response  */
		
			/* Data: ComparativeStatics */
			cd "$directory/Data/Output"
			use ComparativeStatics, clear
			
			/* Discount rate */
			graph twoway ///
				(lpolyci erc values if parameter==4 & i==4, clcolor(black)), ///
						legend(off) ///
						ytitle("ERC") ///
						xtitle("Discount rate (r)") xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(ERC_Discount, replace)	
						
			/* Persistence */
			graph twoway ///
				(lpolyci erc values if parameter==3 & i==3, clcolor(black)), ///
						legend(off) ///
						xtitle("Persistence (rho)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(ERC_Persistence, replace)
						
			/* Data: Simulation */
			cd "$directory/Data/Output"
			use Simulation, clear
			
			/* Market-to-book */
			preserve
				
				/* Duplicates (by firm) */
				duplicates drop firm, force
				
				/* ERC and market-to-book */
				graph twoway (lpolyci erc mean_mtb, clcolor(black)) ///
					, legend(label(1 "95% CI") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
					graphregion(color(white)) plotregion(fcolor(white)) ///
					xtitle("Market-to-Book (V/K)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
					name(ERC_MTB, replace)
					
			restore
			
			/* Results Directory */
			cd "$directory/Results/Models/Figures"

			/* Combined figure */
			graph combine ERC_Discount ERC_Persistence ERC_MTB, ///
				altshrink cols(3) ysize(4) xsize(10) ///
				title("Determinants of Earnings-Response Coefficients: Discount Rate, Persistence, and Market-to-Book", color(black)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_5, replace) saving(Figure_5, replace)	
				version 18: graph export "Figure_5.pdf", as(pdf) replace name(Figure_5)
		
		/* Table 4: Earnings-response coefficient */
		
			/* ERC */
			qui xtreg ret sue, fe cluster(firm)
				est store M1
				
			/* Cross-sectional determinants */
			qui xtreg ret sue c.sue##c.rho c.sue##c.abs_sue c.sue##c.mtb c.sue##1.loss, fe cluster(firm)
				est store M2
				
			/* Output table */
			estout M1 M2, keep(sue c.sue#c.rho abs_sue c.sue#c.abs_sue mtb c.sue#c.mtb 1.loss 1.loss#c.sue) ///
				cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(c.sue "UE" c.sue#c.rho "UE*Persistence" abs_sue "|UE|" c.sue#c.abs_sue "UE*|UE|" mtb "Market-to-Book" c.sue#c.mtb "UE*MTB" 1.loss "Loss" 1.loss#c.sue "UE*Loss") ///
				title("Table 4: Determinants of Earnings-Response Coefficient") ///								
				mlabels("[1] Return" "[2] Return")  modelwidth(20) unstack ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))							
		
		/* Figure 6: Shape of earnings-response coefficient */
		graph twoway ///
			(fpfitci ret sue , clcolor(black)) ///
			(fpfitci ret sue_e , clcolor(black) clpattern(dash)) ///
			, legend(label(2 "ERC (correct expectation)") label(4 "ERC (AR(1) expectation)") order(1 2 4) rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
			graphregion(color(white)) plotregion(fcolor(white)) ///
			xtitle("Earnings Surprise (t)") ytitle("Return (t)") xlabel(, format(%9.1f)) ylabel(, format(%9.1f) angle(0)) ///
			title("Earnings-Response Coefficient", color(black)) ///
			name(Figure_6, replace) saving(Figure_6, replace)
			version 18: graph export "Figure_6.pdf", as(pdf) replace name(Figure_6)
			
		/* Table 5: Future earnings-response coefficient (Collins et al. (1994)) */
		
			/* Original firm-level specifications */
			qui xtreg ret x_0, fe cluster(firm)
				est store M1
				
			qui xtreg ret x_0 x_1 x_2 x_3, fe cluster(firm)
				est store M2
				
			qui xtreg ret x_0 x_1 x_2 x_3 ret_1 ret_2 ret_3 ep ag, fe cluster(firm)
				est store M3
	
			/* Current firm-level specification */
			qui xtreg ret x_0, fe cluster(firm)
				est store M4
				
			qui xtreg ret x_0 x_1_3, fe cluster(firm)
				est store M5			
			
			qui xtreg ret x_0 x_1_3 ret_1_3 ep ag, fe cluster(firm)
				est store M6
				
			/* Output table */
			estout M1 M2 M3, drop(_cons) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(x_0 "X (t)" x_1 "X (t+1)" x_2 "X (t+2)" x_3 "X (t+3)" ret_1 "R (t+1)" ret_2 "R (t+2)" ret_3 "R (t+3)" ep "EP (t-1)" ag "AG (t)") ///
				title("Table 5: Future Earnings-Response Coefficient (Original Specification)") ///				
				mlabels("[1] Simple Model" "[2] Augmented Model" "[3] Original Model")  modelwidth(20) unstack ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))

			estout M4 M5 M6, drop(_cons) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(x_0 "X (t)" x_1_3 "X (t+1 to t+3)" ret_1_3 "R (t+1 to t+3)" ep "EP (t-1)" ag "AG (t)") ///
				title("Table 5: Future Earnings-Response Coefficient (Current Specification)") ///								
				mlabels("[1] Simple Model" "[2] Augmented Model" "[3] Current Model")  modelwidth(20) unstack ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))		
				
	/* d. Earnings-return asymmetry */
	
		/* Figure 7: Earnings-return concavity */
		
			/* Earnings levels */
			graph twoway ///
				(fpfitci earn ret, clcolor(black)) ///
				, legend(label(2 "Earnings") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///
				name(Basu_level, replace)
			
			/* Earnings scaled by lagged price */
			graph twoway ///
				(fpfitci ear ret, clcolor(black)) ///
				, legend(label(2 "Earnings/Price") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.1f)) ylabel(, format(%9.1f) angle(0)) ///
				name(Basu, replace)
				
			/* Combined figure */	
			graph combine Basu_level Basu, ///
				altshrink cols(2) ysize(4) xsize(10) ///
				title("Earnings-Return Concavity", color(black)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_7, replace) saving(Figure_7, replace)
				version 18: graph export "Figure_7.pdf", as(pdf) replace name(Figure_7)
				
		/* Untabulated: Placebo test */
			
			/* Lagged earnings */
			qui xtreg l_ear c.ret##i.d, fe cluster(firm)
			
			/* Output */
			estout, keep(ret 1.d 1.d#c.ret) ///
				cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(ret "Return" 1.d "D(Return<0)" 1.d#c.ret "Return*D(Return<0)") ///
				title("Untabulated: Placebo Test with Lagged Earnings/Price") ///								
				modelwidth(40) mlabels("Earnings(t-1)/Price(t-1)") ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))				
					
		/* Figure 8: Channels */
		
			/* Earnings-news */
			graph twoway ///
				(fpfitci earnings z, clcolor(black)) ///
				(lfit earnings z, clcolor(black) clpattern(dash)) ///				
				, legend(label(2 "Earnings") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.0f)) ylabel(, format(%9.0f) angle(0)) ///
				name(Earnings_news, replace)			
			
			/* Adjustment costs-news (note: small in terms of magnitude) */
			graph twoway ///
				(fpfitci adj_cost z, clcolor(black)) ///
				, legend(label(2 "Adjustment costs") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.0f)) ylabel(, format(%9.0f) angle(0)) ///
				name(Adj_cost_news, replace)	
			
			/* Return-news */
			graph twoway ///
				(fpfitci ret z, clcolor(black)) ///
				(lfit ret z, clcolor(black) clpattern(dash)) ///				
				, legend(label(2 "Returns") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.0f)) ylabel(, format(%9.1f) angle(0)) ///
				name(Return_news, replace)
				
			/* Combined figure */	
			graph combine Earnings_news Adj_cost_news Return_news, ///
				altshrink cols(3) ysize(4) xsize(10) ///
				title("Relation of Earnings, Adjustment Costs, and Returns to Profitability Shocks (News)", color(black)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_8, replace)	saving(Figure_8, replace)	 			
				version 18: graph export "Figure_8.pdf", as(pdf) replace name(Figure_8)
				
		/* Figure 9: Other asymmetries */
			
			/* Profitability-returns */
			graph twoway ///
				(fpfitci profitability ret, clcolor(black)) ///
				(lfit profitability ret, clcolor(black) clpattern(dash)) ///				
				, legend(label(2 "Profitability level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///
				name(Profitability_returns, replace)			

			/* Profitability-news */			
			graph twoway ///
				(fpfitci profitability z, clcolor(black)) ///
				(lfit profitability z, clcolor(black) clpattern(dash)) ///				
				, legend(label(2 "Profitability level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///			
				name(Profitability_news, replace)
				
			/* Investment-returns */
			graph twoway ///
				(fpfitci investment ret, clcolor(black)) ///
				(lfit investment ret, clcolor(black) clpattern(dash)) ///				
				, legend(label(2 "Investment level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///			
				name(Investment_returns, replace)			
			
			/* Investment-returns */
			graph twoway ///
				(fpfitci investment z, clcolor(black)) ///
				(lfit investment z, clcolor(black) clpattern(dash)) ///				
				, legend(label(2 "Investment level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///				
				name(Investment_news, replace)	
				
			/* Combined figure */	
			graph combine Profitability_returns Investment_returns Profitability_news Investment_news, ///
				altshrink cols(2) ysize(4) xsize(5) ///
				title("Relation of Profitability and Investment to Returns and Profitability Shocks (News)", color(black) size(medium)) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				name(Figure_9, replace) saving(Figure_9, replace)	
				version 18: graph export "Figure_9.pdf", as(pdf) replace name(Figure_9)
			
	/* Results */	

		/* Table 6, Panel A: Earnings-return asymmetry and volatility */
		
			/* Loop across volatility quantiles */
			qui sum q_sd_ear, d
			qui forvalues q = `r(min)'/`r(max)' {

				/* Earnings-return asymmetry */
				reg ear c.ret##i.d if q_sd_ear == `q', cluster(firm)
				est store M`q'
					
			}

			/* Output table */
			estout M1 M2 M3 M4 M5, keep(1.d#c.ret) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(1.d#c.ret "Earnings-Return Asymmetry") ///
				title("Table 6, Panel A: Earnings-Return Asymmetry and Volatility") ///												
				mlabels("[1] Low" "[2]" "[3]" "[4]" "[5] High")  modelwidth(8) unstack ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))
		
		/* Table 6, Panel B: Earnings-return asymmetry and investment */
		
			/* Loop across volatility quantiles */
			qui sum q_inv, d
			qui forvalues q = `r(min)'/`r(max)' {

				/* Earnings-return asymmetry */
				reg ear c.ret##i.d if q_inv == `q', cluster(firm)
				est store M`q'
					
			}

			/* Output table */
			estout M1 M2 M3 M4 M5, keep(1.d#c.ret) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
				legend label varlabels(1.d#c.ret "Earnings-Return Asymmetry") ///
				title("Table 6, Panel B: Earnings-Return Asymmetry and Investment") ///																
				mlabels("[1] Low" "[2]" "[3]" "[4]" "[5] High")  modelwidth(8) unstack ///
				stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))		
	
	/* Figure 10: Comparative Statics */
	
		/* Data: ComparativeStatics */
		cd "$directory/Data/Output"
		use ComparativeStatics, clear
			
		/* Basu */

			/* Volatility */
			graph twoway ///
				(lpolyci ear_1 values if parameter==1 & i==1, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "Concavity") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Volatility (standard deviation of epsilon)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						title("Earnings-Return Concavity", color(black) size(vhuge)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Basu_Volatility, replace)
						
			/* Adjustment Cost */			
			graph twoway ///
				(lpolyci ear_1 values if parameter==2 & i==2, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "Concavity") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Adjustment Costs (psi)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Basu_AdjCost, replace)				

			/* Persistence */
			graph twoway ///
				(lpolyci ear_1 values if parameter==3 & i==3, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "Concavity") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Persistence (rho)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Basu_Persistence, replace)
			
			/* Discount rate */			
			graph twoway ///
				(lpolyci ear_1 values if parameter==4 & i==4, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "Concavity") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Discount rate (r)") xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Basu_Discount, replace)

		/* ERC */

			/* Volatility */
			graph twoway ///
				(lpolyci erc values if parameter==1 & i==1, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Volatility (standard deviation of epsilon)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						title("Earnings-Response Coefficient", color(black) size(vhuge)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(ERC_Volatility, replace)
						
			/* Adjustment Cost */			
			graph twoway ///
				(lpolyci erc values if parameter==2 & i==2, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Adjustment Costs (psi)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(ERC_AdjCost, replace)				

			/* Persistence */
			graph twoway ///
				(lpolyci erc values if parameter==3 & i==3, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Persistence (rho)") xlabel(, format(%9.1f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(ERC_Persistence, replace)
			
			/* Discount rate */			
			graph twoway ///
				(lpolyci erc values if parameter==4 & i==4, clcolor(black)), ///
						legend(label(1 "95% CI") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						xtitle("Discount rate (r)") xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(ERC_Discount, replace)
			
			/* Results directory */
			cd "$directory/Results/Models/Figures"

			/* Combination */
			graph combine Basu_Volatility ERC_Volatility Basu_AdjCost ERC_AdjCost Basu_Persistence ERC_Persistence Basu_Discount ERC_Discount, ///
				rows(4) cols(2) altshrink ysize(10) xsize(10) ///
				graphregion(color(white)) plotregion(fcolor(white)) ///
				title("Comparative Statics", color(black) size(small)) ///
				name(Figure_10, replace) saving(Figure_10, replace)		
				version 18: graph export "Figure_10.pdf", as(pdf) replace name(Figure_10)
	
/* Log close */
log close Manuscript
	
/******************************************************************************/
/* Online Appendix: Figures and Tables										  */
/******************************************************************************/

/* Log */
cd "$directory/Results/Models/Logs"
log using Appendix, replace smcl name(Appendix)

/* Model comparison */

	/* Loop over models */
	forvalues i = 1(1)3 {

		/* Data */
		cd "$directory/Data/Output"
		use Simulation_Model_`i', clear	
		
		/* Results Directory */
		cd "$directory/Results/Models/Figures/Alternative Models"
		
		/* Model predictions */
		
			/* a. Distributions */
			
				/* Figure 3: Histograms of profitability, investment, earnings, and returns */
				
					/* Profitability */
					hist profitability ///
						, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
						title("Histogram of Profitability Levels", color(black)) ///
						name(Profitability, replace)

					/* Investment */				
					hist investment ///
						, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
						title("Histogram of Investment Levels", color(black)) ///
						name(Investment, replace)
			
					/* Earnings */
					hist earnings ///
						, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
						title("Histogram of Earnings Levels", color(black)) ///
						name(Earnings, replace)
			
					/* Returns */
					hist ret ///
						, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
						title("Histogram of Returns", color(black)) ///
						name(Returns, replace)

					/* Combined figure */
					graph combine Profitability Investment Earnings Returns, ///
						altshrink cols(4) ysize(4) xsize(15) ///
						title("Profitability, Investment, Earnings, and Returns", color(black)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Figure_3_M`i', replace) saving(Figure_3_M`i', replace)
						version 18: graph export "Figure_3_M`i'.pdf", as(pdf) replace name(Figure_3_M`i')
			
				/* Figure 4: Histograms of price and earnings scaled by lagged price */
			
					/* Price */
					hist price ///
						, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
						title("Histogram of Price Levels", color(black)) ///
						name(Price, replace)
					
					/* Earnings scaled by lagged price */
					hist ear ///
						, color(gs10) graphregion(color(white)) plotregion(fcolor(white)) ///
						title("Histogram of Scaled Earnings", color(black)) ///
						name(Earnings_Scaled, replace)
						
					/* Combined figure */
					graph combine Price Earnings_Scaled, ///
						altshrink cols(2) ysize(4) xsize(10) ///
						title("Price and Scaled Earnings", color(black)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Figure_4_M`i', replace) saving(Figure_4_M`i', replace)		
						version 18: graph export "Figure_4_M`i'.pdf", as(pdf) replace name(Figure_4_M`i')
						
			/* b. Persistence of earnings levels and changes */
			
				/* Table 3: Differential persistence */
				
					/* Column 1: Earnings persistence */
					qui xtreg earnings c.l.earnings##1.d_earnings, fe cluster(firm)
						est store M1
						
					/* Column 2: Earnings change persistence */
					qui xtreg d.earnings c.l.d.earnings##1.d_dearnings, fe cluster(firm)
						est store M2
				
					/* Column 3: Earnings change (scaled by price) persistence (Basu (1997)) */
					qui xtreg dear c.l.dear##1.d_dear, fe cluster(firm)
						est store M3		
				
					/* Column 4: Earnings change (scaled by capital) persistence (Ball/Shivakumar (2005)) */
					qui xtreg dear_c c.l.dear_c##1.d_dear_c, fe cluster(firm)
						est store M4			

					/* Combined table */
					estout M1 M2 M3 M4, keep(L.earnings 1.d_earnings 1.d_earnings#cL.earnings LD.earnings 1.d_dearnings 1.d_dearnings#cLD.earnings ///
						L.dear 1.d_dear 1.d_dear#cL.dear L.dear_c 1.d_dear_c 1.d_dear_c#cL.dear_c) ///
						cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
						legend label varlabels(L.earnings "E (t-1)" 1.d_earnings "D(E (t-1) < 0)" 1.d_earnings#cL.earnings "E*D(E < 0)" ///
						LD.earnings "d.E (t-1)" 1.d_dearnings "D(d.E < 0)" 1.d_dearnings#cLD.earnings "d.E*D(d.E < 0)" ///
						L.dear "d.E/P (t-1)" 1.d_dear "D(d.E/P < 0)" 1.d_dear#cL.dear "d.E/P*D(d.E/P < 0)" ///
						L.dear_c "d.E/K (t-1)" 1.d_dear_c "D(d.E/K < 0)" 1.d_dear_c#cL.dear_c "d.E/K*D(d.E/K < 0)") ///
						mlabels("[1] Earnings" "[2] d.Earnings" "[3] d.Earnings/Price" "[4] d.Earnings/Capital")  modelwidth(20) unstack ///
						stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))		
				
			/* c. Earnings-response coefficient */
			
				/* Figure 5: Earnings-response  (w/o comparative static/predictions part) */
					
					/* Market-to-book */
					preserve
						
						/* Duplicates (by firm) */
						duplicates drop firm, force
						
						/* ERC and market-to-book */
						graph twoway (lpolyci erc mean_mtb, clcolor(black)) ///
							, legend(label(1 "95% CI") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
							graphregion(color(white)) plotregion(fcolor(white)) ///
							xtitle("Market-to-Book (V/K)") ///
							name(Figure_5_M`i', replace) saving(Figure_5_M`i', replace)
							version 18: graph export "Figure_5_M`i'.pdf", as(pdf) replace name(Figure_5_M`i')
							
					restore	
				
				/* Table 4: Earnings-response coefficient */
				
					/* ERC */
					qui xtreg ret sue, fe cluster(firm)
						est store M1
						
					/* Cross-sectional determinants */
					qui xtreg ret sue c.sue##c.rho c.sue##c.abs_sue c.sue##c.mtb c.sue##1.loss, fe cluster(firm)
						est store M2
						
					/* Output table */
					estout M1 M2, keep(sue c.sue#c.rho abs_sue c.sue#c.abs_sue mtb c.sue#c.mtb 1.loss 1.loss#c.sue) ///
						cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
						legend label varlabels(sue "UE" c.sue#c.rho "UE*Persistence" abs_sue "|UE|" c.sue#c.abs_sue "UE*|UE|" mtb "Market-to-Book" c.sue#c.mtb "UE*MTB" 1.loss "Loss" 1.loss#c.sue "UE*Loss") ///
						title("Determinants of Earnings-Response Coefficient") ///
						mlabels("[1] Return" "[2] Return")  modelwidth(20) unstack ///
						stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))									
				
				/* Figure 6: Shape of earnings-response coefficient */
				graph twoway ///
					(fpfitci ret sue, clcolor(black)) ///
					(fpfitci ret sue_e, clcolor(black) clpattern(dash)) ///
					, legend(label(2 "ERC (correct expectation)") label(3 "ERC (AR(1) expectation)") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
					graphregion(color(white)) plotregion(fcolor(white)) ///
					xtitle("Earnings Surprise (t)") ytitle("Return (t)") ///
					title("Earnings Response Coefficient", color(black)) ///
					name(Figure_6_M`i', replace) saving(Figure_6_M`i', replace)
					version 18: graph export "Figure_6_M`i'.pdf", as(pdf) replace name(Figure_6_M`i')
					
				/* Table 5: Future earnings-response coefficient (Collins et al. (1994)) */
				
					/* Original firm-level specifications */
					qui xtreg ret x_0, fe cluster(firm)
						est store M1
						
					qui xtreg ret x_0 x_1 x_2 x_3, fe cluster(firm)
						est store M2
						
					qui xtreg ret x_0 x_1 x_2 x_3 ret_1 ret_2 ret_3 ep ag, fe cluster(firm)
						est store M3
			
					/* Current firm-level specification */
					qui xtreg ret x_0, fe cluster(firm)
						est store M4
						
					qui xtreg ret x_0 x_1_3, fe cluster(firm)
						est store M5			
					
					qui xtreg ret x_0 x_1_3 ret_1_3 ep ag, fe cluster(firm)
						est store M6
						
					/* Output table */
					estout M1 M2 M3, drop(_cons) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
						legend label varlabels(x_0 "X (t)" x_1 "X (t+1)" x_2 "X (t+2)" x_3 "X (t+3)" ret_1 "R (t+1)" ret_2 "R (t+2)" ret_3 "R (t+3)" ep "EP (t-1)" ag "AG (t)") ///
						title("Future Earnings-Response Regressions (following Collins et al. (1994))") ///
						mlabels("[1] Simple Model" "[2] Augmented Model" "[3] Original Model")  modelwidth(20) unstack ///
						stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))

					estout M4 M5 M6, drop(_cons) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
						legend label varlabels(x_0 "X (t)" x_1_3 "X (t+1 to t+3)" ret_1_3 "R (t+1 to t+3)" ep "EP (t-1)" ag "AG (t)") ///
						title("Future Earnings-Response Regressions (Current Firm-Level Specification)") ///
						mlabels("[1] Simple Model" "[2] Augmented Model" "[3] Current Model")  modelwidth(20) unstack ///
						stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))		
						
			/* d. Earnings-return asymmetry */
			
				/* Figure 7: Earnings-return concavity */
				
					/* Earnings levels */
					graph twoway ///
						(fpfitci earn ret, clcolor(black)) ///
						, legend(label(2 "Earnings") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Basu_level, replace)
					
					/* Earnings scaled by lagged price */
					graph twoway ///
						(fpfitci ear ret, clcolor(black)) ///
						, legend(label(2 "Earnings/Price") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Basu, replace)
						
					/* Combined figure */	
					graph combine Basu_level Basu, ///
						altshrink cols(2) ysize(4) xsize(10) ///
						title("Earnings-Return Concavity", color(black)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Figure_7_M`i', replace) saving(Figure_7_M`i', replace)
						version 18: graph export "Figure_7_M`i'.pdf", as(pdf) replace name(Figure_7_M`i')
					
				/* Figure 8: Channels */
				
					/* Earnings-news */
					graph twoway ///
						(fpfitci earnings z, clcolor(black)) ///
						(lfit earnings z, clcolor(black) clpattern(dash)) ///				
						, legend(label(2 "Earnings") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Earnings_news, replace)			
					
					/* Adjustment costs-news (note: small in terms of magnitude) */
					graph twoway ///
						(fpfitci adj_cost z, clcolor(black)) ///
						, legend(label(2 "Adjustment costs") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Adj_cost_news, replace)	
					
					/* Return-news */
					graph twoway ///
						(fpfitci ret z, clcolor(black)) ///
						(lfit ret z, clcolor(black) clpattern(dash)) ///				
						, legend(label(2 "Returns") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Return_news, replace)
						
					/* Combined figure */	
					graph combine Earnings_news Adj_cost_news Return_news, ///
						altshrink cols(3) ysize(4) xsize(10) ///
						title("Relation of Earnings, Adjustment Costs, and Returns" "to Profitability Shocks (News)", color(black)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Figure_8_M`i', replace) saving(Figure_8_M`i', replace)				
						version 18: graph export "Figure_8_M`i'.pdf", as(pdf) replace name(Figure_8_M`i')
						
				/* Figure 9: Other asymmetries */
					
					/* Profitability-returns */
					graph twoway ///
						(fpfitci profitability ret, clcolor(black)) ///
						(lfit profitability ret, clcolor(black) clpattern(dash)) ///				
						, legend(label(2 "Profitability level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///
						name(Profitability_returns, replace)			

					/* Profitability-news */			
					graph twoway ///
						(fpfitci profitability z, clcolor(black)) ///
						(lfit profitability z, clcolor(black) clpattern(dash)) ///				
						, legend(label(2 "Profitability level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///
						name(Profitability_news, replace)
						
					/* Investment-returns */
					graph twoway ///
						(fpfitci investment ret, clcolor(black)) ///
						(lfit investment ret, clcolor(black) clpattern(dash)) ///				
						, legend(label(2 "Investment level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///						
						name(Investment_returns, replace)			
					
					/* Investment-returns */
					graph twoway ///
						(fpfitci investment z, clcolor(black)) ///
						(lfit investment z, clcolor(black) clpattern(dash)) ///				
						, legend(label(2 "Investment level") label(3 "Linear fit") rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						xlabel(, format(%9.1f)) ylabel(, format(%9.0f) angle(0)) ///						
						name(Investment_news, replace)	
						
					/* Combined figure */	
					graph combine Profitability_returns Investment_returns Profitability_news Investment_news, ///
						altshrink cols(2) ysize(4) xsize(5) ///
						title("Relation of Profitability and Investment" "to Returns and Profitability Shocks (News)", color(black)) ///
						graphregion(color(white)) plotregion(fcolor(white)) ///
						name(Figure_9_M`i', replace) saving(Figure_9_M`i', replace)	
						version 18: graph export "Figure_9_M`i'.pdf", as(pdf) replace name(Figure_9_M`i')
								
			/* Results */

				/* Table 6, Panel A: Earnings-return asymmetry and volatility */
				
					/* Loop across volatility quantiles */
					qui sum q_sd_ear, d
					qui forvalues q = `r(min)'/`r(max)' {

						/* Earnings-return asymmetry */
						reg ear c.ret##i.d if q_sd_ear == `q', cluster(firm)
						est store M`q'
							
					}

					/* Output table */
					estout M1 M2 M3 M4 M5, keep(1.d#c.ret) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
						legend label varlabels(1.d#c.ret "Earnings-Return Asymmetry") title("Earnings/Price Volatility")  ///
						mlabels("[1] Low" "[2]" "[3]" "[4]" "[5] High")  modelwidth(8) unstack ///
						stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))
				
				/* Table 6, Panel B: Earnings-return asymmetry and investment */
				
					/* Loop across volatility quantiles */
					qui sum q_inv, d
					qui forvalues q = `r(min)'/`r(max)' {

						/* Earnings-return asymmetry */
						reg ear c.ret##i.d if q_inv == `q', cluster(firm)
						est store M`q'
							
					}

					/* Output table */
					estout M1 M2 M3 M4 M5, keep(1.d#c.ret) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
						legend label varlabels(1.d#c.ret "Earnings-Return Asymmetry") title("Investment Levels")  ///
						mlabels("[1] Low" "[2]" "[3]" "[4]" "[5] High")  modelwidth(8) unstack ///
						stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))							
	
	/* End: model loop */
	}
	
/* Data */
cd "$directory/Data/Output"
use Simulation, clear	

/* Further Appendix Tables */

	/* Table A5: Asymmetries */
		
		/* Earnings levels */
		qui xtreg earnings c.ret##i.d, fe cluster(firm)
			est store M1
			
		/* Earnings scaled by lagged price */
		qui xtreg ear c.ret##i.d, fe cluster(firm)
			est store M2
			
		/* Cash flow */
		qui xtreg cash c.ret##i.d, fe cluster(firm)
			est store M3
			
		/* Cash flow scaled by lagged price */
		qui xtreg cfo c.ret##i.d, fe cluster(firm)
			est store M4
						
		/* Investment */
		qui xtreg investment c.ret##i.d, fe cluster(firm)
			est store M5
			
		/* Investment scaled by lagged price */
		qui xtreg inv c.ret##i.d, fe cluster(firm)
			est store M6

		/* Output table */
		estout M1 M2 M3 M4 M5 M6, keep(ret 1.d 1.d#c.ret) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			legend label varlabels(ret "Return" 1.d "D(Return<0)" 1.d#c.ret "Return*D") title("Earnings, Cash Flow, And Investment Asymmetry")  ///
			mlabels("Earnings" "Earnings/Price" "Cash Flow" "Cash Flow/Price" "Investment" "Investment/Price")  modelwidth(8) unstack ///
			stats(N N_clust r2_a, fmt(0 0 3) label("Obs." "# Clusters" "Ad. R-Squared"))		
		
	/* Table A6: Decomposition */	
			
		/* Firm-fixed effects decomposition */
		qui {
		
			/* Partialling firm effects out */
			xtreg ear d, fe
			predict r_ear, e

			xtreg ret d, fe
			predict r_ret, e
	
			/* Negative return partition: variance/covariance */
			corr r_ear r_ret if ret<0, cov
			local cov_neg = r(cov_12)
			local var_neg = r(Var_2)

			/* Positive return partition: variance/covariance */
			corr r_ear r_ret if ret>=0, cov
			local cov_pos = r(cov_12)
			local var_pos = r(Var_2)
		}
		
		/* Output */
		di "___________________________"
		di "Negative Return Partition"
		di "Return variance: " round(`var_neg',.0001)
		di "Earnings-Return covariance: " round(`cov_neg',.0001)
		di "___________________________"
		di "Positive Return Partition"
		di "Return variance: " round(`var_pos',.0001)
		di "Earnings-Return covariance: " round(`cov_pos',.0001)
		di "___________________________"
		di "Spreads/Differences (Negative - Positive)"
		di "Variance: " round(`var_neg'-`var_pos',.0001)
		di "Earnings-Return covariance: " round(`cov_neg'-`cov_pos',.0001)
	
/* Log: close */
log close Appendix

/******************************************************************************/
/* Accrual Model: Simulation data (based on calibrated parameter values)	  */
/******************************************************************************/

/* Directory */
cd "$directory/Code/Models/02-Accrual model/Simulation/Data"

/* Data */
insheet using SimulationsWorkingCapital.csv,  clear
save Simulation_workingcapital, replace

/* Time Series */
gen t = _n
label var t "Period"

tsset t

/* Variables */
rename v1 earnings
label var earnings "Earnings"

rename v2 cash
label var cash "Cash from Operations"

rename v3 price
label var price "Price"

rename v4 profitability
label var profitability "Profitability"

rename v5 investment
label var investment "Investment"

rename v6 capital
label var capital "Capital"

rename v7 adj_cost
label var adj_cost "Adjustment cost"

rename v8 working_capital
label var working_capital "Working Capital"

gen price_ex_div = price-cash+investment
label var price_ex_div "Price (ex dividend)"

gen ret = d.price/l.price_ex_div
label var ret "Return"

gen wc_accruals = d.working_capital
label var wc_accruals "Working Capital Accruals"

gen wca = wc_accruals/l.price_ex_div
label var wca "Working Capital Accruals(t)/Price(t-1)"

/* Outlier Treatment */
drop if t<=1000 | t>101000
drop if abs(ret)>1

/* Figure A1: Working Capital Accruals */

	/* Results Directory */
	cd "$directory/Results/Models/Figures"
	
	/* Graphs */
	graph twoway ///
		(fpfitci wca ret, clcolor(black)) ///
		, legend(label(2 "Working Capital Accruals(t)/Price(t-1)") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
		graphregion(color(white)) plotregion(fcolor(white)) ///
		xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///	
		title("Working Capital Accruals and Returns", color(black)) ///
		name(Figure_A1, replace) saving(Figure_A1, replace)
		version 18: graph export "Figure_A1.pdf", as(pdf) replace name(Figure_A1)

/******************************************************************************/
/* Non-Parametric Comparison												  */
/******************************************************************************/

/* Figure A2: Simulated Patterns */

	/* Data */
	cd "$directory/Data/Output"
	use Simulation, clear
	
	/* Results Directory */
	cd "$directory/Results/Models/Figures"
	
	/* Graph 1: Earnings-Return Concavity */
	graph twoway ///
		(fpfitci ear ret, clcolor(black)) ///
		, legend(label(1 "CI 95%") label(2 "Earnings-Return Concavity") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
		graphregion(color(white)) plotregion(fcolor(white)) ///
		xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///
		ytitle("Earnings/Price") ///
		xtitle("Return") ///		
		title("Earnings-Return Concavity", color(black)) ///
		name(Figure_A2_1, replace) saving(Figure_A2_1, replace)
		version 18: graph export "Figure_A2_1.pdf", as(pdf) replace name(Figure_A2_1)

	
	/* Graph 2: Concavity and Volatility*/
	preserve
	
		/* Drop duplicates */
		duplicates drop firm, force
		
		/* Graph */
		graph twoway (lpolyci basu sd_ear, clcolor(black)) ///
			, legend(label(1 "CI 95%") label(2 "Earnings-Return Concavity") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
			graphregion(color(white)) plotregion(fcolor(white)) ///
			xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///
			ytitle("Earnings-Return Concavity") ///
			xtitle("Earnings Volatility") ///
			title("Earnings-Return Concavity and Earnings Volatility", color(black)) ///
			name(Figure_A2_2, replace) saving(Figure_A2_2, replace)
			version 18: graph export "Figure_A2_2.pdf", as(pdf) replace name(Figure_A2_2)
			
	restore
	
	/* Graph 3: ERC */
	graph twoway ///
		(fpfitci ret sue_e, clcolor(black)) ///
		, legend(label(1 "CI 95%") label(2 "ERC") order(1 2 4) rows(3) ring(0) position(11) bmargin(medium) symxsize(5)) ///
		graphregion(color(white)) plotregion(fcolor(white)) ///
		xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///		
		ytitle("Return") ///
		xtitle("Earnings Surprise") ///
		title("Earnings-Response Coefficient", color(black)) ///
		name(Figure_A2_3, replace) saving(Figure_A2_3, replace)
		version 18: graph export "Figure_A2_3.pdf", as(pdf) replace name(Figure_A2_3)
	
	/* Graph 4: ERC and Volatilty */
	preserve
	
		/* Drop duplicates */
		duplicates drop firm, force
		
		/* Graph */
		graph twoway (lpolyci erc sd_ear, clcolor(black)) ///
			, legend(label(1 "CI 95%") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
			graphregion(color(white)) plotregion(fcolor(white)) ///
			xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///		
			ytitle("ERC") ///
			xtitle("Earnings Volatility") ///
			title("ERC and Volatility", color(black)) ///
			name(Figure_A2_4, replace) saving(Figure_A2_4, replace)
			version 18: graph export "Figure_A2_4.pdf", as(pdf) replace name(Figure_A2_4)
	
	restore
	
	/* Graph 5: ERC and MTB */
	preserve
	
		/* Drop duplicates */
		duplicates drop firm, force
		
		/* Graph */
		graph twoway (lpolyci erc mean_mtb, clcolor(black)) ///
			, legend(label(1 "CI 95%") label(2 "ERC") rows(2) ring(0) position(11) bmargin(medium) symxsize(5)) ///
			graphregion(color(white)) plotregion(fcolor(white)) ///
			xlabel(, format(%9.2f)) ylabel(, format(%9.2f) angle(0)) ///					
			ytitle("ERC") ///
			xtitle("Market-to-Book") ///
			title("ERC and Market-to-Book", color(black)) ///
			name(Figure_A2_5, replace) saving(Figure_A2_5, replace)
			version 18: graph export "Figure_A2_5.pdf", as(pdf) replace name(Figure_A2_5)
		
	restore
