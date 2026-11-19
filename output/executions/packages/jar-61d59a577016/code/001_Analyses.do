adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"


//------------------------------------------------------------------------------
local folder "_nested_FinalData/FinalData"	//***Adjust this for your machine

local Condition0 "BothMCsCorrect >= 0" //Full sample
local Condition1 "BothMCsCorrect == 1" //Both manipulation checks correct
local conditionnum = 1

//------------------------
//LOADING IN THE LONG DATA
use "`folder'/AnalyticDataset_Long.dta", clear

keep if `Condition`conditionnum'' //keeping the desired sample (full or both mcs correct)


//Recoding the binary variables to be -.5/.5 rather than 0/1
local Low = -.5
local High = .5
replace LowContr = `Low' if LowContr == 0
replace Informativeness_Other = `Low' if Informativeness_Other == 0
replace Informativeness_Own = `Low' if Informativeness_Own == 0
replace LowContr = `High' if LowContr == 1
replace Informativeness_Other = `High' if Informativeness_Other == 1
replace Informativeness_Own = `High' if Informativeness_Own == 1

//Standardizing the continuous variables (this needs to be done after keeping the desired sample)
egen GF_RespTimes_std = std(GF_RespTimes) if NumMisses < 14 //omitting one person who did not take the response-time task seriously (see footnote 18)
egen GF_Survey_std = std(GF_Survey)
replace GF_RespTimes_std = GF_RespTimes_std*`High'
replace GF_Survey_std = GF_Survey_std*`High'

//Creating a factor analysis of the two goal-focus measures for a robustness check
factor GF_RespTimes_std GF_Survey_std, factors(1)
predict GF_Factor
egen GF_Factor_std = std(GF_Factor)
replace GF_Factor_std = GF_Factor_std*`High'


* cls omitted: display-only console command unsupported in Linux batch.
//------------------------
//ANALYSES
//Note that using i.Round##i.Trial fixed effects gives 60 fixed effect estiamtes (3*20). 
//This is statistically identical to using fixed effects for each of the 60 choice numbers.

//------------
//MAIN ANALYSIS (column 1)
logit DecQual c.LowContr i.Round##i.Trial, vce(cluster workerId) 
margins, dydx(LowContr)


//------------
//MAIN ANALYSIS robustness check without fixed effects (column 2)
logit DecQual c.LowContr, vce(cluster workerId) 
margins, dydx(LowContr)


//------------
//Effect of the controllability manipulation across rounds (averaged across trials)
logit DecQual c.LowContr##i.Round##i.Trial, vce(cluster workerId)
margins, dydx(LowContr) at(Round=(1 2 3)) post

//all pairwise comparisons of rounds
lincom _b[LowContr:2._at] - _b[LowContr:1bn._at]
lincom _b[LowContr:3._at] - _b[LowContr:2._at]


//------------
//Effect of the controllability manipulation across trials (averaged across rounds)
logit DecQual c.LowContr##(i.Round##i.Trial), vce(cluster workerId)
margins, dydx(c.LowContr) at(Trial=(1(1)20)) post

//making comparisons across different sets of trials
forvalues cutoff = 1/19 {
	local lintest1 "(-1/`cutoff')*_b[LowContr:1bn._at]"
	if `cutoff' >= 2 {
		forvalues i = 2/`cutoff' {
			local lintest1 "`lintest1' + (-1/`cutoff')*_b[LowContr:`i'._at]"
		}
	}
	local x = `cutoff' + 1
	local y = `cutoff' + 2
	local lintest2 "(1/(20-`cutoff'))*_b[LowContr:`x'._at]"
	if `y' <= 20 {
		forvalues i = `y'/20 {
			local lintest2 "`lintest2' + (1/(20-`cutoff'))*_b[LowContr:`i'._at]"
		}
	}
	
	quietly: lincom -1*(`lintest1')
	local m1 = string(round(100*`r(estimate)', .01), "%9.2f")
	local p1 = string(round(`r(p)', .001), "%9.3f")
	quietly: lincom `lintest2'
	local m2 = string(round(100*`r(estimate)', .01), "%9.2f")
	local p2 = string(round(`r(p)', .001), "%9.3f")
	quietly: lincom `lintest2' + `lintest1'
	local mdiff = string(round(100*`r(estimate)', .01), "%9.2f")
	local pdiff = string(round(`r(p)', .001), "%9.3f")
	
	di "Cutoff: `cutoff'; Effect (early): `m1'%; p (early): `p1'; Effect (late): `m2'%; p (late): `p2'; Effect (Diff): `mdiff'%; p (diff): `pdiff'"
}


//------------
//Interactions with informativeness_Other (informativeness of outcomes in the uncontrollable factories) (column 3)
logit DecQual c.LowContr##c.Informativeness_Other i.Round##i.Trial, vce(cluster workerId)
margins, dydx(LowContr) //main effect of LowContr
margins, dydx(Informativeness_Other) //main effect of Informativeness_Other
margins, dydx(LowContr) at(Informativeness_Other=(`Low' `High')) post
lincom _b[LowContr:2._at] - _b[LowContr:1bn._at]
di round(`r(p)'/2, .001)


//------------
//Footnote 17: Checking whether the results are robust to including Informativeness_Own 
logit DecQual c.LowContr##(c.Informativeness_Other c.Informativeness_Own) i.Round##i.Trial, vce(cluster workerId)
margins, dydx(LowContr) //main effect of LowContr
margins, dydx(Informativeness_Own) //main effect of Informativeness_Own
margins, dydx(LowContr) at(Informativeness_Other=(`Low' `High')) post
lincom _b[LowContr:2._at] - _b[LowContr:1bn._at]
di round(`r(p)'/2, .001)


//------------
//Showing that interacting the controllability manipulation with Informativneness_Other kills the interaction with round 
//This suggests that the controllability manipulation's effect on learning across rounds is explained by its effect on how
//well participants utilize information in the uncontrollable factories
logit DecQual c.LowContr##(c.Informativeness_Other i.Round##i.Trial), vce(cluster workerId)
margins, dydx(c.LowContr) at(Round=(1 2 3)) post coeflegend
lincom _b[LowContr:2._at] - _b[LowContr:1bn._at]
lincom _b[LowContr:3._at] - _b[LowContr:2._at]


//------------
//Interacting the controllability manipulation with goal-focus, measured using the response-time task (column 4)
logit DecQual c.LowContr##c.GF_RespTimes_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(LowContr) //main effect of LowContr
margins, dydx(GF_RespTimes_std) //main effect of GF_RespTimes_std
margins, dydx(c.GF_RespTimes_std) at(LowContr=(`Low' `High')) post
lincom _b[GF_RespTimes_std:2._at] - _b[GF_RespTimes_std:1bn._at]
di round(`r(p)'/2, .001)

//Follow-up simple effects of the controllability manipulation at different levels of goal-focus
logit DecQual c.LowContr##c.GF_RespTimes_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(c.LowContr) at(GF_RespTimes_std=(`Low' 0 `High'))


//------------
//Interacting the controllability manipulation with goal-focus, measured using the survey responses (column 5)
logit DecQual c.LowContr##c.GF_Survey_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(LowContr) //main effect of LowContr
margins, dydx(GF_Survey_std) //main effect of GF_Survey_std
margins, dydx(c.GF_Survey_std) at(LowContr=(`Low' `High')) post
lincom _b[GF_Survey_std:2._at] - _b[GF_Survey_std:1bn._at]
di round(`r(p)'/2, .001)

//Follow-up simple effects of the controllability manipulation at different levels of goal-focus
logit DecQual c.LowContr##c.GF_Survey_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(c.LowContr) at(GF_Survey_std=(`Low' 0 `High'))


//------------
//Footnote 19: Checking whether the results also hold when using a factor analysis of the two goal-focus measures
logit DecQual c.LowContr##c.GF_Factor_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(c.GF_Factor_std) at(LowContr=(`Low' `High')) post
lincom _b[GF_Factor_std:2._at] - _b[GF_Factor_std:1bn._at]
di round(`r(p)'/2, .001)

//Follow-up simple effects of the controllability manipulation at different levels of goal-focus
logit DecQual c.LowContr##c.GF_Factor_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(c.LowContr) at(GF_Factor_std=(`Low' 0 `High'))

logit DecQual c.LowContr##c.GF_Factor_std i.Round##i.Trial, vce(cluster workerId)
margins, dydx(c.LowContr) at(GF_Factor_std=(`Low' 0 `High'))




//------------------------------------------------------------------------------
//ANALYSES ON PARTICIPANT ATTENTION ALLOCATION (WIDE DATASET)
//LOADING IN THE WIDE DATA
use "`folder'/AnalyticDataset_Wide.dta", clear

keep if `Condition`conditionnum''

replace LowContr = `Low' if LowContr == 0
replace LowContr = `High' if LowContr == 1

egen GF_RespTimes_std = std(GF_RespTimes) if NumMisses < 14 
egen GF_Survey_std = std(GF_Survey)
replace GF_RespTimes_std = GF_RespTimes_std*`High'
replace GF_Survey_std = GF_Survey_std*`High'


//-------------
//Examining how the controllability manipulation affects the amount of attention participants allocate to the uncontrollable factories (column 6)
reg AttnUncontr c.LowContr, r
lincom _b[_cons] + `Low'*_b[c.LowContr]
lincom _b[_cons] + `High'*_b[c.LowContr]


//-------------
//Examining whether the attention effects of the controllability manipulation depends on goal-focus, measuring using the response-time task (column 7)
reg AttnUncontr c.LowContr##c.GF_RespTimes_std, r
margins, dydx(LowContr) at(GF_RespTimes_std=(`Low' 0 `High'))


//-------------
//Examining whether the attention effects of the controllability manipulation depends on goal-focus, measuring using the survey responses (column 8)
reg AttnUncontr c.LowContr##c.GF_Survey_std, r
margins, dydx(LowContr) at(GF_Survey_std=(`Low' 0 `High'))
