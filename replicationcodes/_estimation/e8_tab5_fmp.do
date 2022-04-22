********************************************************************************
** 	Table 4 for Beerli, Indergand & Kunz 2022
********************************************************************************

*Settings
clear all 
set more off 
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 
global path "/Users/jkun0001/Dropbox/publications/2022_BeerliIndergandKunz/BIK_final/estimation/_tables/"
mat R = J(17,6,.)

**Start
use 2021_04_01_main.dta
keep if year==2000 | year==1990
drop if EU10==1
keep if indcat=="pop"
xi i.canton i.countryab*i.year


* Globals
global covars1 "Uni_pre1990"
global covars2 "originimmsh70"
global covars3 "edush21high1970 edush22mid1970"
global covars4 "off_skill off_skill_m"
	global covars4m "off_skill_m"
global covars5 "ADHmanufacturingshare ADHmanufacturingshare_m"
	global covars5m "ADHmanufacturingshare_m"
	
global source "giniUN* rgdpch* polity4* conflictsmall"
global Dsource "DginiUN* g_rgdpch* Dpolity4* conflictsmall"

global covars "$covars1 $covars2 $covars3 $covars4 $covars5 $Dsource"	
global fe "_Icanton* _Iyear* _Icountryab* "

* Prep 
su rshIValltreat
su rshtreat
replace treat=treat*100
replace rshIValltreat=rshIValltreat*100

* Regressions
local regnum=1
local num=1

qui ivreg2 dlnpophigh_mid (rsh = rshIVall) treat* $covars d10dlnnrhighmid* $fe if edu=="1high" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10dlnnrhighmid*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpopmid_low (rsh = rshIVall) treat* $covars d10dlnnrmidlow*   $fe if edu=="1high" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10dlnnrmidlow*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop 		 (rsh = rshIVall) treat* $covars d10lnnr1high*     $fe if edu=="1high" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10lnnr1high*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop 		 (rsh = rshIVall) treat* $covars d10lnnr2mid*      $fe if edu=="2mid" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10lnnr2mid*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop 		 (rsh = rshIVall) treat* $covars d10lnnr3low*      $fe if edu=="3low" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10lnnr3low*)
est sto reg`regnum'_`num'
local num=`num'+1
local regnum=`regnum'+1

*_______________________________________________________________________________
* Including fixed effects 
global fe " _Icant* _Iyear* _Icountryab* _IcouXyea_*  "
 ivreg2 dlnpophigh_mid (rsh rshtreat  = rshIVall rshIValltreat )  	 $covars d10dlnnrhighmid* 	 $fe if edu=="1high" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10dlnnrhighmid*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpopmid_low  (rsh rshtreat  = rshIVall rshIValltreat )  $covars d10dlnnrmidlow*   $fe if edu=="1high" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10dlnnrmidlow*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop 		  (rsh rshtreat  = rshIVall rshIValltreat )  $covars d10lnnr1high*     $fe if edu=="1high" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10lnnr1high*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop 		  (rsh rshtreat  = rshIVall rshIValltreat )  $covars d10lnnr2mid*      $fe if edu=="2mid" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10lnnr2mid*)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop 		  (rsh rshtreat  = rshIVall rshIValltreat )  $covars d10lnnr3low*      $fe if edu=="3low" , cluster(msregion countryab) partial($fe $covars $covars4m $covars5m $Dsource d10lnnr3low*)
est sto reg`regnum'_`num'
local num=`num'+1
local regnum=`regnum'+1

*_______________________________________________________________________________________________________________________
*Generate Tables
cap esttab reg1_* using $path/tab_fmp.tex, replace b(3) se nostar stats(N r2) keep(rsh* treat)
cap esttab reg2_* using $path/tab_fmp.tex, append  b(3) se nostar stats(N r2) keep(rsh* ) 

