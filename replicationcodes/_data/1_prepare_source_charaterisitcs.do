********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate prepare source characteristics 
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 


********************************************************************************
** Destination dataset
*----------------------------------------

//Source country
use _rawfiles/BL19702010_1599yearsold_origincountries_BI2015_withoutALBANIA.dta
egen id=group(countryab)
drop if year<1990
xtset id year 
keep id countryab year population edush1highBL edush2midBL edush3lowBL

g nredu1high=population*edush1highBL
la var nredu1high "Source country # high skilled"

g nredu2mid=population*edush2midBL
la var nredu2mid "Source country # middle skilled"

g nredu3low=population*edush3lowBL
la var nredu3low "Source country # low skilled"

g ln_nredu1high=ln(nredu1high)
la var ln_nredu1high "Source country log # high skilled"

g ln_nredu2mid=ln(nredu2mid)
la var ln_nredu2mid "Source country log # mid skilled"

g ln_nredu3low=ln(nredu3low)
la var ln_nredu3low "Source country log # low skilled"

g dlnnrhighmid=ln_nredu1high-ln_nredu2mid
la var dlnnrhighmid "Source country difference in log # high - middle skilled"

g dlnnrmidlow=ln_nredu2mid-ln_nredu3low
la var dlnnrmidlow "Source country difference in log # high - middle skilled"

g d10lnnr1high=F10.ln_nredu1high-ln_nredu1high
la var d10lnnr1high "Source country 10yr difference in log # high skilled"

g d10lnnr2mid=F10.ln_nredu2mid-ln_nredu2mid
la var d10lnnr2mid "Source country 10yr difference in log # middle skilled"

g d10lnnr3low=F10.ln_nredu3low-ln_nredu3low
la var d10lnnr3low "Source country 10yr difference in log # low skilled"

g d10dlnnrhighmid=F10.dlnnrhighmid-dlnnrhighmid
la var d10dlnnrhighmid "Source country 10yr difference in log # high - middle skilled"

g d10dlnnrmidlow=F10.dlnnrmidlow-dlnnrmidlow
la var d10dlnnrmidlow "Source country 10yr difference in log # middle - low skilled"
save _temp/educationsupply_contemp , replace


*_______________________________________________________________________________
*Gen dataset 
use _temp/educationsupply_contemp , clear 

*----------------------------------------
** UNWIIDER DATA 
*----------------------------------------
merge m:1 countryab year using _rawfiles/gini_BI2015.dta, keepusing(DginiUN giniUN) nogen
*----------------------------------------
** POLITY IV
*----------------------------------------
merge m:1 countryab year using _rawfiles/polityIV_BI2015.dta , keepusing(Dpolity4 polity4) nogen
*----------------------------------------
** 	CONFLICT
*----------------------------------------
merge m:1 countryab year using _rawfiles/conflict_BI2015.dta, keepusing(conflictsmall) keep(1 3) nogen
*--------------
** PWT71 DATA
*--------------
* NOTE THAT THERE IS NO GDP INFORATION FROM LIECHTENSTEIN IN PWT
merge m:1 countryab year using _rawfiles/pwt71_rgdp_growth_BI2015.dta, keepusing(g_rgdpch rgdpch) keep(1 3) nogen

drop if countryab=="CH"
drop nredu3low nredu2mid nredu1high id edush3lowBL edush2midBL edush1highBL
keep if year>1980

foreach var of varlist population ln_nredu1high ln_nredu2mid ln_nredu3low dlnnrhighmid dlnnrmidlow d10lnnr1high d10lnnr2mid d10lnnr3low d10dlnnrhighmid d10dlnnrmidlow giniUN DginiUN polity4 Dpolity4 conflictsmall rgdpch g_rgdpch {
g `var'_m=`var'==.
replace `var'=0 if `var'==.
}

drop conflictsmall_m 
compress 
save _temp/source_characterisitcs.dta, replace

