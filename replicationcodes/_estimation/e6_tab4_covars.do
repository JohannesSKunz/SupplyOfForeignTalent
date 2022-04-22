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
xi i.canton i.countryab*i.year
keep if year==2000 | year==1990
*keep if indcat=="pop" 

global covars1 "Uni_pre1990"
global covars2 "originimmsh70"
global covars3 "edush21high1970 edush22mid1970"
global covars4 "off_skill off_skill_m"
	global covars4m "off_skill_m"
global covars5 "ADHmanufacturingshare ADHmanufacturingshare_m"
	global covars5m "ADHmanufacturingshare_m"
global fe "_Icanton* _Iyear* _Icountryab* _IcouXyea_* "

*_______________________________________________________________________________________________________________________
*Panel a: high-middle (ignore edu=="1high", its equal in all rows, just not to use them twice)
local regnum=1

foreach var in dlnpophigh_mid dlnpopmid_low {
local num=1
qui ivreg2 `var' (rsh = rshIVall) $covars1 $fe if edu=="1high" & indcat=="pop", cluster(msregion countryab) partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars2 $fe if edu=="1high" & indcat=="pop" , cluster(msregion countryab) partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars3 $fe if edu=="1high" & indcat=="pop", cluster(msregion countryab) partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars4 $fe if edu=="1high" & indcat=="pop", cluster(msregion countryab) partial($fe $covars4m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars5 $fe if edu=="1high" & indcat=="pop", cluster(msregion countryab) partial($fe $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="1high" & indcat=="pop" , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="1high" & indcat=="0all"  , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="1high" & indcat=="1man"  , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 `var' (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="1high" & indcat=="2nman"  , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'

local regnum=`regnum'+1
}

*_______________________________________________________________________________________________________________________
*Panel c-e:  (ignore edu=="1high", its equal in all rows, just not to use them twice)
foreach var in 1high 2mid 3low  {
local num=1
qui ivreg2 dlnpop (rsh = rshIVall) $covars1 $fe if edu=="`var'"  & indcat=="pop" , cluster(msregion countryab) partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars2 $fe if edu=="`var'"  & indcat=="pop" , cluster(msregion countryab) partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars3 $fe if edu=="`var'"  & indcat=="pop" , cluster(msregion countryab) partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars4 $fe if edu=="`var'"  & indcat=="pop" , cluster(msregion countryab) partial($fe $covars4m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars5 $fe if edu=="`var'"  & indcat=="pop"  , cluster(msregion countryab) partial($fe $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="`var'"  & indcat=="pop"  , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="`var'" & indcat=="0all" , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="`var'" & indcat=="1man" , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'
local num=`num'+1

qui ivreg2 dlnpop (rsh = rshIVall) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="`var'" & indcat=="2nman" , cluster(msregion countryab) partial($fe $covars4m $covars5m)
est sto reg`regnum'_`num'

local regnum=`regnum'+1
}

*_______________________________________________________________________________________________________________________
*Generate Tables
global tab1 "coeflabels(rsh "\quad $\rsh$" Uni_pre1990 "\quad Uni " originimmsh70 "\quad originimmsh70"  edush21high1970 "\quad edush21high1970" edush22mid1970 "\quad edush22mid1970" off_skill "\quad off_skill" ADHmanufacturingshare "\quad ADHmanufacturingshare" )  "
global tab2 "coeflabels(rsh "\quad $\rsh$"  )"
 esttab reg1_* using $path/tab6_covars.tex, replace b(3) se nostar stats(N r2) $tab1
 esttab reg2_* using $path/tab6_covars.tex, append  b(3) se nostar stats(N r2) $tab1
 esttab reg3_* using $path/tab6_covars.tex, append  b(3) se nostar stats(N r2) $tab2 keep(rsh*)
 esttab reg4_* using $path/tab6_covars.tex, append  b(3) se nostar stats(N r2) $tab2 keep(rsh*)
 esttab reg5_* using $path/tab6_covars.tex, append  b(3) se nostar stats(N r2) $tab2 keep(rsh*)
