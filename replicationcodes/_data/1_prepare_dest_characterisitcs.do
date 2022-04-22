********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate prepare destination characteristics crossboarder workers
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
*Gen dataset 
use _rawfiles/sess_msnr_cbw_wages_rsh.dta, clear
tsset ms_nr year

foreach x in C1 C2 CC1 CC2 {
foreach y in LNwagerhrl wagerhrl {
gen D`y'`x'_HvM 	= `y'`x'1high-`y'`x'2mid
gen D`y'`x'_MvL 	= `y'`x'2mid-`y'`x'3low
}
}
*

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
keep ms_nr year D10DwagerhrlC1_MvL D10DwagerhrlC1_HvM  DwagerhrlC1_MvL DwagerhrlC1_HvM D10DLNwagerhrlC1_MvL D10DLNwagerhrlC1_HvM workertotal

expand 2 if year==1994 
sort ms_nr year
bys ms_nr year: g t=_n
replace year =1990 if t==1 & year==1994
drop t
rename ms_nr msregion

save _temp/dest_characterisitcs.dta, replace


