********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate wage-based data 
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 

*-------------------------------------------------------------------------------
tempfile rsh offsh adh

** RSH
use _rawfiles/vz_llm_ms_rsh_rshIV.dta, clear
keep msregion year rsh rshIVall canton
keep if year==1990
rename msregion ms_nr
drop year canton
save `rsh'

*----------------------------------------
** OFFSHORING 
*----------------------------------------
use _rawfiles/vz_llm_offshoring_BI2015.dta, clear
keep if year==1990
rename  msregion ms_nr
save `offsh'

*----------------------------------------
** AUTOR, DORN, HANSON (2015) CONTROLS
*----------------------------------------
use  _rawfiles/vz_ADH2015_controls_BI2015.dta, clear
keep if year==1990
rename  msregion ms_nr
save `adh'

use _rawfiles/sess_msnr_cbw_wages_rsh.dta, clear
merge m:1 ms_nr using `rsh' , nogen
merge m:1 ms_nr using `offsh' , nogen
merge m:1 ms_nr using `adh' , nogen
merge m:1 ms_nr using _rawfiles/ms_nr_canton_amsregion.dta , nogen
merge m:1 ms_nr using _rawfiles/ms_nr_university.dta , nogen


*-----------------------------------------------------------
** OUTCOMES 
*-----------------------------------------------------------

gen LNcbw_HvM = ln((cbw1high+1)/(cbw2mid+1))
gen LNcbw_MvL = ln((cbw2mid+1)/(cbw3low+1))
*browse ms_nr year cbw1high cbw2mid cbw3low LNcbw_HvM LNcbw_MvL

*--------------------------------
** IMMIGRANT SHARE WITH 1998 BASE
*--------------------------------
tsset ms_nr year
gen 	workertotal1998 = workertotal if year==1998
replace workertotal1998 = F2.workertotal if year==1996
replace workertotal1998 = F4.workertotal if year==1994
forvalues i=2000(2)2010 {
local j = `i'-1998
replace workertotal1998 = l`j'.workertotal if year==`i'
}
*

gen 	cbwSH1998 = cbwtotal/workertotal1998
replace cbwSH1998 = 0			if cbwSH1998==. & workertotal1998!=.


*------------------------
** VARIABLES FOR ANALYSIS 
*------------------------

** SINGLE YEAR EFFECTS
*---------------------
tab year, gen(Dyear)

forvalues i=1(1)9 {
local j = `i'*2 +1992
rename Dyear`i' D`j'
}
*
gen trend = year-1993


*
tab ams_nr, gen(amsnr)
forvalues i=1(1)16{
gen trend_amsnr`i' = trend*amsnr`i'
}
*
tab canton_nr, gen(cantonnr)
forvalues i=1(1)26{
gen trend_cantonnr`i' = trend*cantonnr`i'
}
*

foreach x in rsh rshIVall {
forvalues i=1996(2)2010 {
gen `x'_D`i' = `x'*D`i'
}
}
*

su rshIVall , d
g highistrsh=rshIVall>=r(p50)

forvalues i=1994(2)2010 {
gen highistrsh_D`i' 	= highistrsh*D`i'
}
*


foreach x in C1 C2 CC1 CC2 {
foreach y in LNwagerhrl wagerhrl {
gen D`y'`x'_HvM 	= `y'`x'1high-`y'`x'2mid
gen D`y'`x'_MvL 	= `y'`x'2mid-`y'`x'3low
}
}
*

gen wagerhrl_p90p50 = wagerhrlp90/wagerhrlp50
gen wagerhrl_p50p10 = wagerhrlp50/wagerhrlp10


foreach x in C1 C2 CC1 CC2 {
foreach y in LNwagerhrl wagerhrl {
* HvM
gen		D20D`y'`x'_HvM 	= ((F16.`y'`x'1high-F16.`y'`x'2mid)-(`y'`x'1high-`y'`x'2mid))	if year==1994 // *(20/6)

gen		D10D`y'`x'_HvM 	= ((F6.`y'`x'1high-F6.`y'`x'2mid)-(`y'`x'1high-`y'`x'2mid))		if year==1994 // *(10/6)
replace D10D`y'`x'_HvM 	= (F10.`y'`x'1high-F10.`y'`x'2mid)-(`y'`x'1high-`y'`x'2mid) 	if year==2000
* MvL
gen 	D20D`y'`x'_MvL 	= ((F16.`y'`x'2mid-F16.`y'`x'3low)-(`y'`x'2mid-`y'`x'3low))		if year==1994 // *(20/6)

gen 	D10D`y'`x'_MvL 	= ((F6.`y'`x'2mid-F6.`y'`x'3low)-(`y'`x'2mid-`y'`x'3low))		if year==1994 // *(10/6)
replace D10D`y'`x'_MvL 	= (F10.`y'`x'2mid-F10.`y'`x'3low)-(`y'`x'2mid-`y'`x'3low) 		if year==2000
}
}
*


gen baseline=0
compress
save 2017_09_16_wages, replace 

