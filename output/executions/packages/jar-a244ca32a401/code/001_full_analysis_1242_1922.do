adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
use "Data/Using Data/Data for Analysis (2022-10-18).dta", clear	
	
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 1: Descriptive Statistics 
****
***
**
*	
	*** Panel A (Ideas) ***	
	gen C0  = ""
	gen C0_ = "&"
	
	forvalues i = 1(1)4 {
		gen C`i'  = .
		gen C`i'_ = "&"
	}
	
	gen C5  = .
	gen C5_ = "\\"
	
	replace C0 = "Creativity" 					in 1
	replace C0 = "Usefulness" 					in 2
	replace C0 = "Novelty" 						in 3
	replace C0 = "Idea Length (characters)" 	in 4
	replace C0 = "Time Spent Thinking (min.)" 	in 5
	replace C0 = "Difficulty of Thinking" 		in 6
	
	local tick = 1
	
	foreach i in Overall2_Creative Overall2_Useful Overall2_Novel IdeaLength IdeaTimeThinkingNum IdeaDifficultyNum {
		sum `i' if Idea_obs == 1 & Overall2_Creative != ., d
			replace C1 = r(N)    in `tick'
			replace C2 = round(r(mean),0.01) in `tick'
			replace C3 = round(r(sd),0.01)   in `tick'
			replace C4 = round(r(min),0.01)  in `tick'
			replace C5 = round(r(max),0.01)  in `tick'
			
		local tick = `tick' + 1
	}
	
	list C0-C5_ in 1/6, noobs
	
	drop C0-C5_
	
	*** Panel B (Participants) ***	
	gen C0  = ""
	gen C0_ = "&"
	
	forvalues i = 1(1)4 {
		gen C`i'  = .
		gen C`i'_ = "&"
	}
	
	gen C5  = .
	gen C5_ = "\\"
	
	replace C0 = "Age" 					in 1
	replace C0 = "Female" 	            in 2
	replace C0 = "Years of Education" 	in 3
	replace C0 = "Number of HITs (00s)" in 4
	
	local tick = 1
	
	foreach i in Age Female YearsofEducation NumberofHITs {
		sum `i' if ParticipantObs == 1 & Peer_100 == 1
			replace C1 = round(r(mean),0.01) in `tick'
			replace C1 = r(N) in 6
		sum `i' if ParticipantObs == 1 & Peer_10  == 1	
			replace C2 = round(r(mean),0.01) in `tick'
			replace C2 = r(N) in 6
		sum `i' if ParticipantObs == 1 & Exec_100 == 1	
			replace C3 = round(r(mean),0.01) in `tick'
			replace C3 = r(N) in 6
		sum `i' if ParticipantObs == 1 & Exec_10  == 1	
			replace C4 = round(r(mean),0.01) in `tick'
			replace C4 = r(N) in 6
			
		regress `i' Peer_100 Peer_10 Exec_100 Exec_10 if ParticipantObs == 1, noconstant   
		test Peer_100 = Peer_10 = Exec_100 = Exec_10
			replace C5 = round(r(p),0.001) in `tick'	
			
		local tick = `tick' + 1
	}
	
	list C0-C5_ in 1/6, noobs
	
	drop C0-C5_
	
	*** Variation in Participant Demographics ***
	sum Age 				if ParticipantObs == 1, d 
	sum Female 				if ParticipantObs == 1, d 
	
	tab q33 if ParticipantObs == 1
	
	sum YearsofEducation 	if ParticipantObs == 1, d 
	sum NumberofHITs 		if ParticipantObs == 1, d
	
	count if (Age <  30 | Age >  50) & ParticipantObs == 1
		local temp1 = r(N)
	count if (Age >= 30 & Age <= 50) & ParticipantObs == 1
		local temp2 = r(N)
		local temp3 = `temp2' / (`temp1' + `temp2')
		display `temp3'
	
	tab Age if ParticipantObs == 1 
	
	*** Panel C (Participation Rates)
	unique IdeaId if ParticipatedCount != 0 & Overall_Creative_Both != . & Peer_100 == 1
		*** 138
	unique IdeaId if ParticipatedCount != 0 & Overall_Creative_Both != . & Peer_10  == 1
		*** 170
	unique IdeaId if ParticipatedCount != 0 & Overall_Creative_Both != . & Exec_100 == 1
		*** 113
	unique IdeaId if ParticipatedCount != 0 & Overall_Creative_Both != . & Exec_10  == 1
		*** 106

	unique ParticipantId if ParticipatedCount != 0 & Peer_100 == 1
		*** 50
	unique ParticipantId if ParticipatedCount != 0 & Peer_10  == 1
		*** 67
	unique ParticipantId if ParticipatedCount != 0 & Exec_100 == 1
		*** 55
	unique ParticipantId if ParticipatedCount != 0 & Exec_10  == 1
		*** 56			
		
	unique ParticipantId if ParticipatedCount == 0 & Peer_100 == 1
		*** 185
	unique ParticipantId if ParticipatedCount == 0 & Peer_10  == 1
		*** 168
	unique ParticipantId if ParticipatedCount == 0 & Exec_100 == 1
		*** 180
	unique ParticipantId if ParticipatedCount == 0 & Exec_10  == 1
		*** 180	
	
	unique ParticipantId if ParticipatedCount == 1 & Peer_100 == 1
		*** 24
	unique ParticipantId if ParticipatedCount == 1 & Peer_10  == 1
		*** 36
	unique ParticipantId if ParticipatedCount == 1 & Exec_100 == 1
		*** 32
	unique ParticipantId if ParticipatedCount == 1 & Exec_10  == 1
		*** 27	
	
	unique ParticipantId if ParticipatedCount >= 2 & ParticipatedCount <= 5 & Peer_100 == 1
		*** 22
	unique ParticipantId if ParticipatedCount >= 2 & ParticipatedCount <= 5 & Peer_10  == 1
		*** 26
	unique ParticipantId if ParticipatedCount >= 2 & ParticipatedCount <= 5 & Exec_100 == 1
		*** 20
	unique ParticipantId if ParticipatedCount >= 2 & ParticipatedCount <= 5 & Exec_10  == 1
		*** 28	
		
	unique ParticipantId if ParticipatedCount >= 6 & ParticipatedCount <= 10 & Peer_100 == 1
		*** 3
	unique ParticipantId if ParticipatedCount >= 6 & ParticipatedCount <= 10 & Peer_10  == 1
		*** 3
	unique ParticipantId if ParticipatedCount >= 6 & ParticipatedCount <= 10 & Exec_100 == 1
		*** 2
	unique ParticipantId if ParticipatedCount >= 6 & ParticipatedCount <= 10 & Exec_10  == 1
		*** 1			
	
	unique ParticipantId if ParticipatedCount >= 11 & ParticipatedCount <= 15 & Peer_100 == 1
		*** 0
	unique ParticipantId if ParticipatedCount >= 11 & ParticipatedCount <= 15 & Peer_10  == 1
		*** 2
	unique ParticipantId if ParticipatedCount >= 11 & ParticipatedCount <= 15 & Exec_100 == 1
		*** 1
	unique ParticipantId if ParticipatedCount >= 11 & ParticipatedCount <= 15 & Exec_10  == 1
		*** 0	
	
	unique ParticipantId if ParticipatedCount >= 16 & ParticipatedCount < . & Peer_100 == 1
		*** 1
	unique ParticipantId if ParticipatedCount >= 16 & ParticipatedCount < . & Peer_10  == 1
		*** 0
	unique ParticipantId if ParticipatedCount >= 16 & ParticipatedCount < . & Exec_100 == 1
		*** 0
	unique ParticipantId if ParticipatedCount >= 16 & ParticipatedCount < . & Exec_10  == 1
		*** 0	
	
	unique ParticipantId if ParticipatedCount != 0 
	
	*** Treatment Cell of the Outlier ***
	count if ParticipatedCount == 26 & Peer_100 == 1 // Outlier is here
	count if ParticipatedCount == 26 & Peer_10  == 1
	count if ParticipatedCount == 26 & Exec_100 == 1
	count if ParticipatedCount == 26 & Exec_10  == 1
	
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 2: Correlation Table 
****
***
**
*		
	pwcorr Overall2_Creative Overall2_Useful Overall2_Novel IdeaLength IdeaTimeThinkingNum IdeaDifficultyNum if Idea_obs == 1 & Overall2_Creative != ., sig
	
	*** Correlation between usefulness and creativity is much higher when execs eval, then when peers eval ***
	*** 0.6569 vs. 0.3580

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 3: Participation with Dummy Coding and Effects Coding for Interaction
****
***
**
* 	
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1, noabsorb vce(robust)
		est store A	
	qui: reghdfe ParticipatedAny   c.ten_10##c.peer `controls' if ParticipantObs == 1, noabsorb vce(robust)
		est store B			
	estimates replay A
	estimates replay B

*
**
*** Sans-Controls
**
*
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer if ParticipantObs == 1, noabsorb vce(robust)
		est store A	
	qui: reghdfe ParticipatedAny   c.ten_10##c.peer if ParticipantObs == 1, noabsorb vce(robust)
		est store B			
	estimates replay A
	estimates replay B
						  
*
**
*** Result Among Contributors Only
**
*
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & ParticipatedCount > 0, noabsorb vce(robust)
		est store A	
	estimates replay A
						  
*
**
*** Outlier Controlled Specifications
**
*
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & ParticipatedCount < 26, noabsorb vce(robust)
		est store A	
	qui: reghdfe ParticipatedAny   c.ten_10##c.peer `controls' if ParticipantObs == 1 & ParticipatedCount < 26, noabsorb vce(robust)
		est store B			
	estimates replay A
	estimates replay B
					  
	foreach i in 10 11 12 13 14 15 {
		gen ParticipatedCount`i' = ParticipatedCount
			replace ParticipatedCount`i' = `i' if ParticipatedCount > `i'
	}		
	
	foreach i in 10 11 12 13 14 15 { 
		local controls "Age Female YearsofEducation NumberofHITs OtherGender"
		
		display " "
		display "`i'"
	
		estimates clear
		qui: reghdfe ParticipatedCount`i' c.ten_10##c.peer `controls' if ParticipantObs == 1, noabsorb vce(robust)
			est store A	
		qui: reghdfe ParticipatedAny      c.ten_10##c.peer `controls' if ParticipantObs == 1, noabsorb vce(robust)
			est store B			
		estimates replay A
		estimates replay B
	}

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 4: Effect of Contest Design Feature Among Young/Male vs. non-Young/Male
****
***
**
*		
	local controls "Age YearsofEducation NumberofHITs"
	
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1, noabsorb vce(robust)
		est store A
	     reg     ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1
		est store A1
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0, noabsorb vce(robust)
		est store B
	     reg     ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0
		est store B1
		suest A1 B1
		test [A1_mean]c.peer   		  = [B1_mean]c.peer		
		test [A1_mean]c.ten_10 		  = [B1_mean]c.ten_10
		test [A1_mean]c.ten_10#c.peer = [B1_mean]c.ten_10#c.peer
	qui: reghdfe ParticipatedCount c.ten_10##c.peer##Minority50 `controls' if ParticipantObs == 1, noabsorb vce(robust)
		est store C
	qui: reghdfe ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1, noabsorb vce(robust)
		est store D
	     reg     ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1
		est store D1
	qui: reghdfe ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0, noabsorb vce(robust)
		est store E
	     reg     ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0
		est store E1
		suest D1 E1
		test [D1_mean]c.peer   		  = [E1_mean]c.peer		
		test [D1_mean]c.ten_10 		  = [E1_mean]c.ten_10
		test [D1_mean]c.ten_10#c.peer = [E1_mean]c.ten_10#c.peer
	qui: reghdfe ParticipatedAny c.ten_10##c.peer##Minority50 `controls' if ParticipantObs == 1, noabsorb vce(robust)
		est store F		
	estimates replay A
	estimates replay B
	estimates replay C
	estimates replay D
	estimates replay E
	estimates replay F

*
**
*** With Gender Control
**
*
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1, noabsorb vce(robust)
		est store A
	     reg     ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1
		est store A1
	qui: reghdfe ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0, noabsorb vce(robust)
		est store B
	     reg     ParticipatedCount c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0
		est store B1
		suest A1 B1
		test [A1_mean]c.peer   		  = [B1_mean]c.peer		
		test [A1_mean]c.ten_10 		  = [B1_mean]c.ten_10
		test [A1_mean]c.ten_10#c.peer = [B1_mean]c.ten_10#c.peer
	qui: reghdfe ParticipatedCount c.ten_10##c.peer##Minority50 `controls' if ParticipantObs == 1, noabsorb vce(robust)
		est store C
	qui: reghdfe ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1, noabsorb vce(robust)
		est store D
	     reg     ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 1
		est store D1
	qui: reghdfe ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0, noabsorb vce(robust)
		est store E
	     reg     ParticipatedAny c.ten_10##c.peer `controls' if ParticipantObs == 1 & Minority50 == 0
		est store E1
		suest D1 E1
		test [D1_mean]c.peer   		  = [E1_mean]c.peer		
		test [D1_mean]c.ten_10 		  = [E1_mean]c.ten_10
		test [D1_mean]c.ten_10#c.peer = [E1_mean]c.ten_10#c.peer
	qui: reghdfe ParticipatedAny c.ten_10##c.peer##Minority50 `controls' if ParticipantObs == 1, noabsorb vce(robust)
		est store F		
	estimates replay A
	estimates replay B
	estimates replay C
	estimates replay D
	estimates replay E
	estimates replay F
							  
*
**
*** Without Any Contorls
**
*							  	
	estimates clear
	qui: reghdfe ParticipatedCount c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 1, noabsorb vce(robust)
		est store A
	     reg     ParticipatedCount c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 1
		est store A1
	qui: reghdfe ParticipatedCount c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 0, noabsorb vce(robust)
		est store B
	     reg     ParticipatedCount c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 0
		est store B1
		suest A1 B1
		test [A1_mean]c.peer   		  = [B1_mean]c.peer		
		test [A1_mean]c.ten_10 		  = [B1_mean]c.ten_10
		test [A1_mean]c.ten_10#c.peer = [B1_mean]c.ten_10#c.peer
	qui: reghdfe ParticipatedCount c.ten_10##c.peer##Minority50 if ParticipantObs == 1, noabsorb vce(robust)
		est store C
	qui: reghdfe ParticipatedAny c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 1, noabsorb vce(robust)
		est store D
	     reg     ParticipatedAny c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 1
		est store D1
	qui: reghdfe ParticipatedAny c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 0, noabsorb vce(robust)
		est store E
	     reg     ParticipatedAny c.ten_10##c.peer if ParticipantObs == 1 & Minority50 == 0
		est store E1
		suest D1 E1
		test [D1_mean]c.peer   		  = [E1_mean]c.peer		
		test [D1_mean]c.ten_10 		  = [E1_mean]c.ten_10
		test [D1_mean]c.ten_10#c.peer = [E1_mean]c.ten_10#c.peer
	qui: reghdfe ParticipatedAny c.ten_10##c.peer##Minority50 if ParticipantObs == 1, noabsorb vce(robust)
		est store F		
	estimates replay A
	estimates replay B
	estimates replay C
	estimates replay D
	estimates replay E
	estimates replay F

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Figure 1: Compare Self-Reported Creativity of Young/Male vs. non-Young/Male
****
***
**
*	
	ttest CreativeIdeas if ParticipantObs == 1, by(Minority50)
	ttest HowInnovative if ParticipantObs == 1, by(Minority50)
	ttest DevelopPlans  if ParticipantObs == 1, by(Minority50)
	ttest SecureFunds   if ParticipantObs == 1, by(Minority50)
	ttest PromoteIdeas  if ParticipantObs == 1, by(Minority50)
	
	gen beta = .
	gen _se1 = .
	gen _se2 = .
	gen spot = .
	
	local temp = 1
	foreach i in CreativeIdeas HowInnovative DevelopPlans SecureFunds PromoteIdeas {
		
		ttest `i' if ParticipantObs == 1, by(Minority50)
		
		replace beta = r(mu_2) - r(mu_1) in `temp'
		replace _se1 = beta + r(se)*1.645 in `temp'
		replace _se2 = beta - r(se)*1.645 in `temp'
		replace spot = `temp' in `temp'
		
		local temp = `temp' + 1
	}	

	graph set window fontface "Times New Roman"
	
	twoway 	(connected beta spot, mcolor(maroon) lcolor(white) lwidth(medthick) lpattern(dash)) || 	///
			(rcap _se1 _se2 spot, lcolor(maroon) lwidth(medthick)), 								///
			graphregion(color(white)) bgcolor(white) plotregion(color(white)) legend(off)			///			
			xlabel(.75 " " 5.25 " " 																///
				   1 `" "Creative" "Ideas" "' 2 `" "Are" "Innovative" "'							///
			       3 `" "Develop" "Plans" "'  4 `" "Secure" "Funds" "' 								///
				   5 `" "Promote" "Ideas" "', notick) xtitle("")  									///
			ytitle("Difference and 90% Confidence Interval") yline(0, lcolor(black) lpattern(dash))  
			graph export "Analysis and Documentation/Tables and Figures/CreativityFigures(Minority50).png", as(png) name("Graph") replace
	
	graph set window fontface default
	
	drop beta _se1 _se2 spot		
			
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 5: Main Quality Results w/ Top Idea Columns
****
***
**
*	
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	foreach i in Useful Novel Creative {
		estimates clear
		qui: reghdfe Overall2_`i' c.ten_10##c.peer `controls' if Idea_obs == 1							 , noabsorb vce(robust)
			est store A
		qui: reghdfe Overall2_`i' c.ten_10##c.peer `controls' if Idea_obs == 1 & rank_Overall2_`i' <=  50, noabsorb vce(robust)
			est store B
		qui: reghdfe Overall2_`i' c.ten_10##c.peer `controls' if Idea_obs == 1 & rank_Overall2_`i' <=  25, noabsorb vce(robust)
			est store C	
		estimates replay A
		estimates replay B
		estimates replay C
		display " "
		display " "
	}

	sum Overall2_Useful   if Idea_obs == 1, d
	sum Overall2_Novel    if Idea_obs == 1, d
	sum Overall2_Creative if Idea_obs == 1, d
	
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 6: Effort Exertion Results w/ Top Idea Columns 
***** 
****
***
**
*		
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	foreach i in IdeaTimeThinkingNum IdeaDifficultyNum IdeaLength {
		estimates clear
		qui: reghdfe `i' c.ten_10##c.peer `controls' if Idea_obs == 1 & Overall2_Creative != .						          , noabsorb vce(robust)
			est store A
		qui: reghdfe `i' c.ten_10##c.peer `controls' if Idea_obs == 1 & Overall2_Creative != . & rank_Overall2_Creative <=  50, noabsorb vce(robust)
			est store B
		qui: reghdfe `i' c.ten_10##c.peer `controls' if Idea_obs == 1 & Overall2_Creative != . & rank_Overall2_Creative <=  25, noabsorb vce(robust)
			est store C	
		estimates replay A
		estimates replay B
		estimates replay C
		display " "
		display " "
	}

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table A.1: Main Results Table (Robustness)
****
***
**
*	
	local controls "Age Female YearsofEducation NumberofHITs OtherGender"
	
	foreach i in Useful Novel Creative {
		estimates clear
		qui: reghdfe Overall2_`i'      c.ten_10##c.peer `controls' if Idea_obs == 1, noabsorb vce(robust)
			est store A
		qui: reghdfe Overall_`i'_Both  c.ten_10##c.peer `controls' if Idea_obs == 1, noabsorb vce(robust)
			est store B
		qui: reghdfe Overall_`i'_Exec  c.ten_10##c.peer `controls' if Idea_obs == 1, noabsorb vce(robust)
			est store C
		qui: reghdfe Overall_`i'_Peer  c.ten_10##c.peer `controls' if Idea_obs == 1, noabsorb vce(robust)
			est store D
		qui: reghdfe Overall_`i'_Treat c.ten_10##c.peer `controls' if Idea_obs == 1, noabsorb vce(robust)
			est store E	
		estimates replay A
		estimates replay B
		estimates replay C
		estimates replay D
		estimates replay E
		display " "
		display " "	
	}						 	 

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*
**
***
****
***** Table 7: Did PhD Students Care More or Less About Usefulness?
***** 
****
***
**
*		
	estimates clear 
	qui: reghdfe Overall_Creative_Peer Overall_Novel_Peer Overall_Useful_Peer if Idea_obs == 1, noabsorb 			   vce(robust)
		est store A
		test _b[Overall_Novel_Peer] = _b[Overall_Useful_Peer]
	qui: reghdfe Score_Creative Score_Novel Score_Useful 					  if ExecEval == 0, noabsorb 			   vce(robust)
		est store B
		test _b[Score_Novel] = _b[Score_Useful]
	qui: reghdfe Score_Creative Score_Novel Score_Useful 					  if ExecEval == 0, absorb(EvalID2) 	   vce(robust)
		est store C
		test _b[Score_Novel] = _b[Score_Useful]
	qui: reghdfe Score_Creative Score_Novel Score_Useful 					  if ExecEval == 0, absorb(EvalID2 IdeaId) vce(robust)
		est store D
		test _b[Score_Novel] = _b[Score_Useful]
	estimates replay A
	estimates replay B
	estimates replay C
	estimates replay D
  
	estimates clear   
	qui: reghdfe Overall_Creative_Exec Overall_Novel_Exec Overall_Useful_Exec if Idea_obs == 1, noabsorb 			   vce(robust)   
		est store A
		test _b[Overall_Novel_Exec] = _b[Overall_Useful_Exec]
	qui: reghdfe Score_Creative Score_Novel Score_Useful 					  if ExecEval == 1, noabsorb 			   vce(robust)
		est store B
		test _b[Score_Novel] = _b[Score_Useful]
	qui: reghdfe Score_Creative Score_Novel Score_Useful 					  if ExecEval == 1, absorb(EvalID2) 	   vce(robust)
		est store C
		test _b[Score_Novel] = _b[Score_Useful]
	qui: reghdfe Score_Creative Score_Novel Score_Useful 					  if ExecEval == 1, absorb(EvalID2 IdeaId) vce(robust)
		est store D
		test _b[Score_Novel] = _b[Score_Useful]
	estimates replay A
	estimates replay B
	estimates replay C
	estimates replay D

*
**
*** Compare Coefficients
**
*
	estimates clear 
	reg Overall_Creative_Peer Overall_Novel_Peer Overall_Useful_Peer if Idea_obs == 1
		est store A1
	reg Overall_Creative_Exec Overall_Novel_Exec Overall_Useful_Exec if Idea_obs == 1 
		est store A2
		suest A1 A2
	test [A1_mean]Overall_Novel_Peer  = [A2_mean]Overall_Novel_Exec
	test [A1_mean]Overall_Useful_Peer = [A2_mean]Overall_Useful_Exec
			
	reg Score_Creative Score_Novel Score_Useful if ExecEval == 0
		est store B1
	reg Score_Creative Score_Novel Score_Useful if ExecEval == 1
		est store B2
		suest B1 B2
	test [B1_mean]Score_Novel  = [B2_mean]Score_Novel
	test [B1_mean]Score_Useful = [B2_mean]Score_Useful		
		
	egen EvalID2_num = group(EvalID2)	
		
	reg Score_Creative Score_Novel Score_Useful c.EvalID2_num if ExecEval == 0
		est store C1
	reg Score_Creative Score_Novel Score_Useful c.EvalID2_num if ExecEval == 1
		est store C2	
		suest C1 C2
	test [C1_mean]Score_Novel  = [C2_mean]Score_Novel
	test [C1_mean]Score_Useful = [C2_mean]Score_Useful		
	
	egen IdeaId_num = group(IdeaId)
	
	reg Score_Creative Score_Novel Score_Useful c.EvalID2_num c.IdeaId_num if ExecEval == 0
		est store D1
	reg Score_Creative Score_Novel Score_Useful c.EvalID2_num c.IdeaId_num if ExecEval == 1
		est store D2
		suest D1 D2
	test [D1_mean]Score_Novel  = [D2_mean]Score_Novel
	test [D1_mean]Score_Useful = [D2_mean]Score_Useful	
			
