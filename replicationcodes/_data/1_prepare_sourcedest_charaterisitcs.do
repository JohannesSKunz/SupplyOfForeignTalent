********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate prepare source-dest characteristics 
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 


********************************************************************************
** Destination dataset
*----------------------------------------

*_______________________________________________________________________________
*Gen Destsource
use _rawfiles/vz_msregionsPL_countryab_allyearsSE1012_zeros_nozeros_BI2015_SAMPLEage15999_population, clear 
g 	temp1=edush21high if year==1970
bys msregion  countryab: egen edush21high1970=max(temp1)
la var edush21high1970 "Share immigrants middle skilled 1970, from source country"
g 	temp2=edush22mid   if year==1970
bys msregion  countryab: egen edush22mid1970=max(temp2)
la var edush22mid1970 "Share immigrants middle skilled 1970, from source country"
drop temp*
rename yearnew year 
keep msregion year countryab edush22mid1970* edush21high1970*
keep if year>1980
save _temp/educationsupply_1970 , replace


 
*_______________________________________________________________________________
*Gen dataset 
use _temp/educationsupply_1970 , clear 
*rename ms_nr 
merge m:1  countryab msregion using _rawfiles/vz_msregion_origincountryshares1970.dta , nogen keep(1 3)
la var originimmsh70 "Missing: Share immigrants 1970, from source country"

drop if year<1990 
drop if year==.

sort countryab msregion year
drop mssh_imm70

g originimmsh70_m=originimmsh70==.
la var originimmsh70_m "Missing: Share immigrants 1970, from source country"
replace originimmsh70=0 if originimmsh70==.
g edush21high1970_m=edush21high1970==.
la var edush21high1970_m "Missing: Share immigrants middle skilled 1970, from source country"
replace edush21high1970=0 if edush21high1970==.
g edush22mid1970_m=edush22mid1970==.
la var edush22mid1970_m "Missing: Share immigrants middle skilled 1970, from source country"
replace edush22mid1970=0 if edush22mid1970==.

compress 
save _temp/sourcedest_charaterisitcs.dta, replace

