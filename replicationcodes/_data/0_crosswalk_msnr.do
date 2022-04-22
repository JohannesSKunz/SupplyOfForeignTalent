********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Crosswalk, agglomeration and university city information 
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 

********************************************************************************
** Destination dataset
*----------------------------------------

use _rawfiles/ms_nr_canton_amsregion , clear 
rename ms_nr msregion

//City agglomerations 
// (Basel-Stadt, Bern, Genf, Lausanne, Zürich)
g city=0
replace city=1 if msregion == 1 | msregion ==  11 | msregion ==  47 | msregion ==  84 | msregion ==  105
la var city "Indicator for big city (Basel,Bern,Genf,Lausanne,Zurich)"
// (+ Lugano, Luzern, St.Gallen, Winterthur)
g city2=city
replace city2=1 if msregion == 8 | msregion ==  26 | msregion ==  53 | msregion ==  82 
la var city2 "Indicator for city (Lugano,Luzern,St.Gallen,Wintertur)"

//University
rename msregion ms_nr
merge m:1 ms_nr using _rawfiles/ms_nr_university.dta , nogen
rename ms_nr msregion 
la var Uni_pre1990 "Indicator for university city (before 1990)"
la var Uni_post1990 "Indicator for university city (after 1990)"

compress 
save _temp/msnr.dta, replace

