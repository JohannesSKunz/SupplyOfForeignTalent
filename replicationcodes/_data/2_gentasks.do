********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate task-based file 
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 


********************************************************************************
use _rawfiles/vz_allvarallyearSE2010to12_BI2015_fullsample.dta, clear 	

replace	year = 2010 	if year==2011 | year==2012

gen 	population = weight
replace population = population/3 	if year==2010

keep if age>=15
gen 	fte_w = fteweighted
replace fte_w = fteweighted/3 	if year==2010

drop if pber==92101 
keep if age>=18 & age<=64
drop if fte<=0
drop if edu3==""
drop if nationality==""
drop if permit==""
drop if isco88==.

keep if isco88!=.
drop if isco88==110
drop if edu3==""

*-----------------------------------------------------------
** OCCUPATION GROUPS
*-----------------------------------------------------------
gen isco881 = int(isco88/1000)
gen 	occ3 = "1a"	if isco881==1 | isco881==2 | isco881==3
replace	occ3 = "2r"	if isco881==4 | isco881==7 | isco881==8
replace occ3 = "3m" if isco881==5 | isco881==9 | isco881==6
replace occ3 = "" if employed==0
tab occ3, gen(occ3)
rename occ31 occ31a
rename occ32 occ32r
rename occ33 occ33m

*-------------------------------------------
*** (2) MERGE TASK VARIABLES
*-------------------------------------------
merge m:1 isco88 using _rawfiles/AA2011_DOT77_census2000weights_collapsed_on_isco88imputed.dta, nogen keep(3) 

rename msregionpr msregion
merge m:1 msregion year using _temp/rsh.dta , keep(3) nogen

foreach x in task_abstract task_manual task_routine RTI {
summ `x' [aw=fte_w] if year==1990
gen `x'sd = [`x'-r(mean)]/r(sd) // = [`x'-`x'm]/`x'sd
}

foreach x in 1970 1980 1990 {
foreach y in RTI RTIsd {
_pctile `y' if year==`x' [aw=fte_w], p(66)
scalar s`y'p66`x' = r(r1)				
gen `y'p66`x' = s`y'p66`x' 			// NOTE THAT THIS IS SIMILAR FOR 1970 AND 1980 	
gen `y'top33`x' = `y'>`y'p66`x'  	// DUMMY FOR OBS ABOVE P66
}
}

gen 	wart3 = "0" + string(wart) 	if wart<100 & wart>0 	& year<=2000
replace wart3 = string(wart) 		if wart>100				& year<=2000
replace wart3 = "" 					if wart==0 & wart==.	& year<=2000
merge m:1 wart3 using _rawfiles/correspondace_asw853_to_noga2002.dta // NOTE THAT NOGA 2002 HAS 2 AND 3 DIGIT VALUES
drop if _merge==2

** ADD A ZERO TO 2 DIGIT VALUES 
replace noga2002 ="260"	if noga2002=="26"
replace noga2002 ="270"	if noga2002=="27"
replace noga2002 ="280"	if noga2002=="28"
replace noga2002 ="290"	if noga2002=="29"
replace noga2002 ="310"	if noga2002=="31"
replace noga2002 ="330"	if noga2002=="33"
replace noga2002 ="350"	if noga2002=="36"
replace noga2002 ="500"	if noga2002=="50"
replace noga2002 ="510"	if noga2002=="51"
replace noga2002 ="500"	if noga2002=="50"
replace noga2002 ="710"	if noga2002=="71"
replace noga2002 ="740"	if noga2002=="74"
replace noga2002 ="910"	if noga2002=="91"
replace noga2002 ="930"	if noga2002=="93"

** INSERT VALUES FOR MISSING WART3 CODES USING THE MANUAL CROSS-WALK FOR THE HARMONISED CENSU1970-2000
replace noga2002 = "400" if wart3 =="110" & noga2002==""
replace noga2002 = "157" if wart3 =="219" & noga2002==""
replace noga2002 = "159" if wart3 =="220" & noga2002==""
replace noga2002 = "160" if wart3 =="230" & noga2002==""
replace noga2002 = "180" if wart3 =="255" & noga2002==""
replace noga2002 = "220" if wart3 =="280" & noga2002==""
replace noga2002 = "290" if wart3 =="350" & noga2002==""
replace noga2002 = "450" if wart3 =="410" & noga2002==""
replace noga2002 = "450" if wart3 =="423" & noga2002==""
replace noga2002 = "550" if wart3 =="570" & noga2002==""
replace noga2002 = "500" if wart3 =="580" & noga2002==""
replace noga2002 = "600" if wart3 =="610" & noga2002==""
replace noga2002 = "610" if wart3 =="630" & noga2002==""
replace noga2002 = "620" if wart3 =="640" & noga2002==""
replace noga2002 = "640" if wart3 =="660" & noga2002==""
replace noga2002 = "650" if wart3 =="710" & noga2002==""
replace noga2002 = "660" if wart3 =="720" & noga2002==""
replace noga2002 = "700" if wart3 =="730" & noga2002==""
replace noga2002 = "800" if wart3 =="810" & noga2002==""
replace noga2002 = "730" if wart3 =="820" & noga2002==""
replace noga2002 = "900" if wart3 =="840" & noga2002==""
replace noga2002 = "910" if wart3 =="870" & noga2002==""
replace noga2002 = "950" if wart3 =="890" & noga2002==""

rename _merge mergeWART
	 
*--------------------------
**	SE  
*--------------------------


gen 	noga2008 = "0" + string(companylocunnoga) 	if companylocunnoga<100000 & year>=2010
replace noga2008 = string(companylocunnoga) 		if companylocunnoga>=100000 & year>=2010
replace noga2008 = ""					 			if companylocunnoga<0 & year>=2010
gen noga08 = substr(noga2008, 1, 4)


merge m:1 noga08 using _rawfiles/correspondace_noga084_to_noga023.dta
drop if _merge==2
drop _merge mergeWART


** NEW NOGA MEASURE: 
gen 	noga20023 = noga2002 	if year<=2000
replace noga20023 = noga02 		if year>=2010
gen noga20022 = substr(noga20023, 1,2) // 58 industries 

drop wart3 noga2002 noga2008 noga08 noga02 

gen noga20022r = real(noga20022)

gen 	noga2002group="ABC"		if noga20022r<=	14		
replace noga2002group="D"		if noga20022r>=	15	& noga20022r<=	37
replace noga2002group="E"		if noga20022r>=	40	& noga20022r<=	41
replace noga2002group="F"		if noga20022r==	45		
replace noga2002group="G"		if noga20022r>=	50	& noga20022r<=	52
replace noga2002group="H"		if noga20022r==	55		
replace noga2002group="I"		if noga20022r>=	60	& noga20022r<=	64
replace noga2002group="J"		if noga20022r>=	65	& noga20022r<=	67
replace noga2002group="K"		if noga20022r>=	70	& noga20022r<=	74
replace noga2002group="L"		if noga20022r==	75								// PUBLIC SECTOR IS NOT IN DATASET
replace noga2002group="M"		if noga20022r==	80	
replace noga2002group="N"		if noga20022r==	85
replace noga2002group="O"		if noga20022r>=	90	& noga20022r<=	93
replace noga2002group="P"		if noga20022r>=	95	& noga20022r<=	97
replace noga2002group="Q"		if noga20022r==	99

gen 	indcat = "1afofi"		if 		noga20022r<=	14		
replace	indcat = "2Mhightec" 	if 		noga20022=="24" | noga20022=="30" | noga20022=="32" | noga20022=="33" | noga20022=="35" | /// HIGH-TECH   
										noga20022=="29" | noga20022=="31" | noga20022=="34"   // MEDIUM-HIGH TECH	
										
replace indcat = "3Mlowtec" 	if 		noga20022=="23" | noga20022=="25" | noga20022=="26" | noga20022=="27" | noga20022=="28" | /// MEDIUM-LOW TECH
										noga20022=="15" | noga20022=="16" | noga20022=="17" | noga20022=="18" | noga20022=="19" | noga20022=="20" | noga20022=="21" | noga20022=="22" | /// LOW-TECH
										noga20022=="36" | noga20022=="37"										
replace indcat = "4egwc"		if 	noga20022r>=40 & noga20022r<=45
replace indcat = "5kis"			if 	noga20022r==61 | noga20022r==62 | (noga20022r>=64 & noga20022r<=67) | (noga20022r>=70 & noga20022r<=74) | noga20022r==80 | noga20022r==85 | noga20022r==92
replace indcat = "6nkis"		if 	(noga20022r>=50 & noga20022r<=52) | noga20022r==55 | noga20022r==60 | noga20022r==63 | noga20022r==75 | noga20022r==90 | noga20022r==91 | noga20022r==93 | (noga20022r>=95 & noga20022r<=99)

tab noga2002group, gen(noga2002group)
rename noga2002group1 noga2002groupABC
rename noga2002group2 noga2002groupD
rename noga2002group3 noga2002groupE
rename noga2002group4 noga2002groupF
rename noga2002group5 noga2002groupG
rename noga2002group6 noga2002groupH
rename noga2002group7 noga2002groupI
rename noga2002group8 noga2002groupJ
rename noga2002group9 noga2002groupK
rename noga2002group10 noga2002groupL
rename noga2002group11 noga2002groupM
rename noga2002group12 noga2002groupN
rename noga2002group13 noga2002groupO
rename noga2002group14 noga2002groupP
rename noga2002group15 noga2002groupQ

tab indcat, gen(indcat)

compress
save 2017_09_02_tasks, replace


