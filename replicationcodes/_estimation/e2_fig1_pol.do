********************************************************************************
** 	Figure 1 for Beerli, Indergand & Kunz 2022
********************************************************************************

*Settings
clear all 
set more off 
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 
global path "/Users/jkun0001/Dropbox/publications/2022_BeerliIndergandKunz/BIK_final/estimation/_figures/"
mat R = J(17,6,.)
set mat 10000

//Start
global cate "isco084" 
global wage "LNnetwage_rhrl" 
global weights "weight_cross" 

//population 
global population ""

* ---------------------------
/* Compute employment, earnings (among FTFY workers), and weeks worked (among FTFY workers) by occupation in each year */
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta , clear
$population
su rshIVall, d 
keep if rshIVall>=r(p50)
replace year= 1990 if year==1991 | year==1992 | year==1993 
keep if year==1990
drop if $wage==.
drop if $cate==. 
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights * wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp1990
saveold "`emp1990'.dta", replace

//Do 2010
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
$population
su rshIVall, d 
keep if rshIVall>=r(p50)
replace year= 2010 if year==2009 | year==2010 | year==2011
keep if year==2010
drop if $wage==.
drop if $cate==. //
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights *wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp2010
saveold "`emp2010'.dta", replace

//Append
use "`emp1990'.dta", clear
append using "`emp2010'.dta"
fillin year $cate
replace $wage = 0 if _fillin == 1
drop _fillin
tempfile emp
saveold "`emp'.dta", replace
* Earnings and weeks worked among FTFY workers
foreach y of numlist 1990 2010 {
	use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
	$population
	su rshIVall, d 
	keep if rshIVall>=r(p50)
	replace year= 1990 if year==1991 | year==1992 | year==1993
	replace year= 2010 if year==2009 | year==2010 | year==2011
	keep if year==`y'
	drop if $cate==. 
	* Restrict to workers employed full-time and full-year
	keep if wklhrs > 0 & wklhrs < .
	keep if weight_cross > 0 & weight_cross < .
	* Sum up earnings and weeks worked across workers
	gen incwt = ln($wage) * $weights
	gen wkswt = wklhrs * $weights
	collapse (sum) incwt wkswt, by(year $cate)
	tempfile earnings`y'
	saveold "`earnings`y''.dta", replace
}
use "`earnings1990'.dta", clear
append using "`earnings2010'.dta"
fillin year $cate
replace incwt = 0 if _fillin == 1
replace wkswt = 0 if _fillin == 1
drop _fillin
tempfile earnings
saveold "`earnings'.dta", replace
//restart
use "`emp'.dta", clear
merge 1:1 year $cate using "`earnings'.dta", //assert(3) nogenerate
drop if _merge!=3
drop _merge
/* Map occupations into percentiles */
joinby $cate using _temp/percentiles.dta , _merge(_merge)
assert _merge == 3
drop _merge
replace $wage = $wage * frac
replace incwt = incwt * frac
replace wkswt = wkswt * frac
collapse (sum) $wage incwt wkswt, by(year perc)
/* Compute mean weekly earnings by occupation percentile */
gen wkwage = incwt/wkswt
keep year perc $wage wkwage 
label var perc "Skill Percentile (Ranked by Occupation's 1990 Mean Log Wage)"
order perc $wage* wkwage*
g rwt=1
tempfile main1
saveold "`main1'.dta", replace

*_______________________________________________________________________________lowrsh
/* Compute employment, earnings (among FTFY workers), and weeks worked (among FTFY workers) by occupation in each year */
//Pool 1991-1993 and 2009-2011 (check robustness)
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
su rshIVall, d 
keep if rshIVall<r(p50)
replace year= 1990 if year==1991 | year==1992 | year==1993
keep if year==1990
drop if $wage==.
drop if $cate==. 
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights * wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp1990
saveold "`emp1990'.dta", replace
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
su rshIVall, d 
keep if rshIVall<r(p50)
replace year= 2010 if year==2009 | year==2010 | year==2011
keep if year==2010
drop if $wage==.
drop if $cate==. //
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights *wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp2010
saveold "`emp2010'.dta", replace
use "`emp1990'.dta", clear
append using "`emp2010'.dta"
fillin year $cate
replace $wage = 0 if _fillin == 1
drop _fillin
tempfile emprwt
saveold "`emprwt'.dta", replace
* Earnings and weeks worked among FTFY workers
foreach y of numlist 1990 2010 {
	use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
	su rsh, d 
	keep if rsh<r(p50)
	replace year= 1990 if year==1991 | year==1992 | year==1993
	replace year= 2010 if year==2009 | year==2010 | year==2011
	keep if year==`y'
	drop if $cate==. 
	* Restrict to workers employed full-time and full-year
	keep if wklhrs > 0 & wklhrs < .
	keep if weight_cross > 0 & weight_cross < .
	* Sum up earnings and weeks worked across workers
	gen incwt = ln($wage) * $weights
	gen wkswt = wklhrs * $weights
	collapse (sum) incwt wkswt, by(year $cate)
	tempfile earnings`y'
	saveold "`earnings`y''.dta", replace
}
use "`earnings1990'.dta", clear
append using "`earnings2010'.dta"
fillin year $cate
replace incwt = 0 if _fillin == 1
replace wkswt = 0 if _fillin == 1
drop _fillin
tempfile earnings
saveold "`earningsrwt'.dta", replace
//Reweighted
use "`emprwt'.dta", clear
merge 1:1 year $cate using "`earningsrwt'.dta", //assert(3) nogenerate
drop if _merge!=3
drop _merge
/* Map occupations into percentiles */
joinby $cate using _temp/percentiles.dta , _merge(_merge)
assert _merge == 3
drop _merge
replace $wage = $wage * frac
replace incwt = incwt * frac
replace wkswt = wkswt * frac
collapse (sum) $wage incwt wkswt, by(year perc)
/* Compute mean weekly earnings by occupation percentile */
gen wkwage = incwt/wkswt
*assert wkwage > 0 & wkwage < .
keep year perc $wage wkwage 
*reshape wide $wage wkwage , i(perc) j(year)
label var perc "Skill Percentile (Ranked by Occupation's 1990 Mean Log Wage)"
order perc $wage* wkwage*
g rwt=0
tempfile main2
saveold "`main2'.dta", replace

*___________________________________________________________________________________________________
//Combine
use "`main1'.dta", clear
append using "`main2'.dta"
* Occupation employment shares
	bys year rwt: egen totlswt = total($wage)
	gen occsh = $wage/totlswt
	drop $wage totlswt
tempfile main
saveold "`main'.dta", replace

*___________________________________________________________________________________________________
*Graph 
use "`main'.dta" , clear
local subtit = ""
* Plot observed change and counterfactual change at 1980 service occupation employment
local bw = 0.45
local y1 = 1990
local y2 = 2010
local span1=-0.5
local span2=1.25
local int = 0.5
local tick=0.1
local rewtyr=1990
* Calculate share changes for observed and reweighted distributions
preserve

sort rwt perc year
quietly by rwt perc: gen dsh = 100*(occsh-occsh[_n-1])
keep if year==`y2'
drop occsh
tab rwt, summ(dsh)
keep dsh perc rwt
reshape wide dsh, i(perc) j(rwt)
label var perc "Occupation's Percentile in 1991 Wage Distribution"
* Get plotting points
lowess dsh0 perc, gen(pdsh0) bwidth(`bw') nograph
lowess dsh1 perc, gen(pdsh1) bwidth(`bw') nograph
label var pdsh0 "Low Rsh"
label var pdsh1 "High Rsh"
sort perc
	#delimit ;
	twoway 
	(connected pdsh0 perc , msymbol(O) msize(vsmall) mcolor(black) clcolor(black) clstyle(dot)) 
	(connected pdsh1 perc , msymbol(Dh) msize(vsmall) mcolor(gray) clcolor(gray) clstyle(dot)) 
		, title("Smoothed `y_lbl' Changes by Skill Percentile, 1991-2010", size(medsmall))
		xtitle("", size(medsmall))
		title("A. Total employment", size(small)) 
		ylabel(`span1'(`int')`span2')
		ymtick(`span1'(`tick')`span2')
		yscale(range(`yrange'))
		l1title("100 x Change in Employment Share", size(medsmall))
		yline(0) 
		scheme(s2mono) 
		graphregion(color(white))
		legend(off)  name(gr1);
	#delimit cr	
	
/* Compute employment, earnings (among FTFY workers), and weeks worked (among FTFY workers) by occupation in each year */
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta, clear 
keep if permit=="foreign_BL"
su rshIVall, d 
keep if rshIVall>=r(p50)
replace year= 1990 if year==1991 | year==1992 | year==1993 
keep if year==1990
drop if $wage==.
drop if $cate==. 
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights * wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp1990
saveold "`emp1990'.dta", replace

//Do 2010
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
keep if permit=="foreign_BL"
su rshIVall, d 
keep if rshIVall>=r(p50)
replace year= 2010 if year==2009 | year==2010 | year==2011
keep if year==2010
drop if $wage==.
drop if $cate==. //
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights *wklhrs //check: Autor does not use weights for this 
collapse (sum) $wage, by(year $cate)
tempfile emp2010
saveold "`emp2010'.dta", replace

//Append
use "`emp1990'.dta", clear
append using "`emp2010'.dta"
fillin year $cate
replace $wage = 0 if _fillin == 1
drop _fillin
tempfile emp
saveold "`emp'.dta", replace
* Earnings and weeks worked among FTFY workers
foreach y of numlist 1990 2010 {
	use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
	keep if permit=="foreign_BL"
	su rshIVall, d 
	keep if rshIVall>=r(p50)
	replace year= 1990 if year==1991 | year==1992 | year==1993
	replace year= 2010 if year==2009 | year==2010 | year==2011
	keep if year==`y'
	drop if $cate==. 
	* Restrict to workers employed full-time and full-year
	keep if wklhrs > 0 & wklhrs < .
	keep if weight_cross > 0 & weight_cross < .
	* Sum up earnings and weeks worked across workers
	gen incwt = ln($wage) * $weights
	gen wkswt = wklhrs * $weights
	collapse (sum) incwt wkswt, by(year $cate)
	tempfile earnings`y'
	saveold "`earnings`y''.dta", replace
}
use "`earnings1990'.dta", clear
append using "`earnings2010'.dta"
fillin year $cate
replace incwt = 0 if _fillin == 1
replace wkswt = 0 if _fillin == 1
drop _fillin
tempfile earnings
saveold "`earnings'.dta", replace
//restart
use "`emp'.dta", clear
merge 1:1 year $cate using "`earnings'.dta", //assert(3) nogenerate
drop if _merge!=3
drop _merge
/* Map occupations into percentiles */
joinby $cate using _temp/percentiles.dta , _merge(_merge)
assert _merge == 3
drop _merge
replace $wage = $wage * frac
replace incwt = incwt * frac
replace wkswt = wkswt * frac
collapse (sum) $wage incwt wkswt, by(year perc)
/* Compute mean weekly earnings by occupation percentile */
gen wkwage = incwt/wkswt
keep year perc $wage wkwage 
label var perc "Skill Percentile (Ranked by Occupation's 1990 Mean Log Wage)"
order perc $wage* wkwage*
g rwt=1
tempfile main1
saveold "`main1'.dta", replace

*_______________________________________________________________________________lowrsh
/* Compute employment, earnings (among FTFY workers), and weeks worked (among FTFY workers) by occupation in each year */
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
keep if permit=="foreign_BL"
su rshIVall, d 
keep if rshIVall<r(p50)
replace year= 1990 if year==1991 | year==1992 | year==1993
keep if year==1990
drop if $wage==.
drop if $cate==. //need to check this!
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights * wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp1990
saveold "`emp1990'.dta", replace
use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
keep if permit=="foreign_BL"
su rshIVall, d 
keep if rshIVall<r(p50)
replace year= 2010 if year==2009 | year==2010 | year==2011
keep if year==2010
drop if $wage==.
drop if $cate==. //
keep if wklhrs > 0 & wklhrs < .
keep if weight_cross > 0 & weight_cross < .
replace $wage = $wage * $weights *wklhrs 
collapse (sum) $wage, by(year $cate)
tempfile emp2010
saveold "`emp2010'.dta", replace
use "`emp1990'.dta", clear
append using "`emp2010'.dta"
fillin year $cate
replace $wage = 0 if _fillin == 1
drop _fillin
tempfile emprwt
saveold "`emprwt'.dta", replace
* Earnings and weeks worked among FTFY workers
foreach y of numlist 1990 2010 {
	use _rawfiles/sake19912014_allvariables_msnr_rsh1990.dta
	keep if permit=="foreign_BL"
	su rsh, d 
	keep if rsh<r(p50)
	replace year= 1990 if year==1991 | year==1992 | year==1993
	replace year= 2010 if year==2009 | year==2010 | year==2011
	keep if year==`y'
	drop if $cate==. 
	* Restrict to workers employed full-time and full-year
	keep if wklhrs > 0 & wklhrs < .
	keep if weight_cross > 0 & weight_cross < .
	* Sum up earnings and weeks worked across workers
	gen incwt = ln($wage) * $weights
	gen wkswt = wklhrs * $weights
	collapse (sum) incwt wkswt, by(year $cate)
	tempfile earnings`y'
	saveold "`earnings`y''.dta", replace
}
use "`earnings1990'.dta", clear
append using "`earnings2010'.dta"
fillin year $cate
replace incwt = 0 if _fillin == 1
replace wkswt = 0 if _fillin == 1
drop _fillin
tempfile earnings
saveold "`earningsrwt'.dta", replace
//Reweighted
use "`emprwt'.dta", clear
merge 1:1 year $cate using "`earningsrwt'.dta", //assert(3) nogenerate
drop if _merge!=3
drop _merge
/* Map occupations into percentiles */
joinby $cate using _temp/percentiles.dta , _merge(_merge)
assert _merge == 3
drop _merge
replace $wage = $wage * frac
replace incwt = incwt * frac
replace wkswt = wkswt * frac
collapse (sum) $wage incwt wkswt, by(year perc)
/* Compute mean weekly earnings by occupation percentile */
gen wkwage = incwt/wkswt
keep year perc $wage wkwage 
label var perc "Skill Percentile (Ranked by Occupation's 1990 Mean Log Wage)"
order perc $wage* wkwage*
g rwt=0
tempfile main2
saveold "`main2'.dta", replace

*___________________________________________________________________________________________________
*Combine
use "`main1'.dta", clear
append using "`main2'.dta"
* Occupation employment shares
	bys year rwt: egen totlswt = total($wage)
	gen occsh = $wage/totlswt
	drop $wage totlswt
tempfile main
saveold "`main'.dta", replace

*___________________________________________________________________________________________________
*Graph 
use "`main'.dta" , clear
local subtit = ""
* Plot observed change and counterfactual change at 1980 service occupation employment
local bw = 0.45
local y1 = 1990
local y2 = 2010
local span1=-0.5
local span2=1.25
local int = 0.5
local tick=0.1
local rewtyr=1990
* Calculate share changes for observed and reweighted distributions
sort rwt perc year
quietly by rwt perc: gen dsh = 100*(occsh-occsh[_n-1])
keep if year==`y2'
drop occsh
tab rwt, summ(dsh)
keep dsh perc rwt
reshape wide dsh, i(perc) j(rwt)
label var perc "Occupation's Percentile in 1991 Wage Distribution"
* Get plotting points
lowess dsh0 perc, gen(pdsh0) bwidth(`bw') nograph
lowess dsh1 perc, gen(pdsh1) bwidth(`bw') nograph
label var pdsh0 "Low Rsh"
label var pdsh1 "High Rsh"
sort perc
	#delimit ;
	twoway 
	(connected pdsh0 perc , msymbol(O) msize(vsmall) mcolor(black) clcolor(black) clstyle(dot)) 
	(connected pdsh1 perc , msymbol(Dh) msize(vsmall) mcolor(gray) clcolor(gray) clstyle(dot)) 
		, title("Smoothed `y_lbl' Changes by Skill Percentile, 1991-2010", size(medsmall))
		xtitle("", size(medsmall))
		title("B. Recent immigrant employment", size(small)) 
		ylabel(`span1'(`int')`span2')
		ymtick(`span1'(`tick')`span2')
		yscale(range(`yrange'))
		l1title("", size(medsmall))
		yline(0) 
		scheme(s2mono) 
		graphregion(color(white))
		legend(pos(6) rows(1) ring(1) order(1 "Below median RSH" 2 "Above median RSH")  region(lcolor(white))) 
		name(gr2);
#delimit cr	

grc1leg2  gr1 gr2 ,  legend(gr2) lsize(small)  ring(10) position(6) b1title("Skill Percentile (Ranked by Occupation's 1991 Mean Log Wage)" , ring(1) position(6) size(small))  ///
		ycommon scheme(s1mono) fysize(70)  fxsize(140)

 graph export $path/fig1_prct.pdf, replace 

