********************************************************************************
** 	Table 2 for Beerli, Indergand & Kunz 2022
********************************************************************************

*Settings
clear all 
set more off 
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 
global path "/Users/jkun0001/Dropbox/publications/2022_BeerliIndergandKunz/BIK_final/estimation/_tables/"
mat R = J(17,6,.)

**Start
use 2017_09_16_wages.dta
global fe i.canton_nr i.year  i.ams_nr // i.ams_nr#.year
global ses "cluster(ms_nr)" 

cap keep if indcat=="pop" 
cap keep if countryab=="AU" 
global weighting "[aw=workertotal]  " 
global outcome1_1 "D10DwagerhrlC1_HvM"
global outcome1_2 "D10DLNwagerhrlC1_HvM"

global outcome2_1 "D10DwagerhrlC1_MvL"
global outcome2_2 "D10DLNwagerhrlC1_MvL"

*_______________________________________________________________________________________________________________________
**Estimation 
*Panel a: high-middle (ignore edu=="1high", its equal in all rows, just not to use them twice)
local regnum=1
local num=1

su rshIVall if D10DwagerhrlC1_HvM!=. , d
sca IQR = r(p75) - r(p25)
di IQR


qui ivreg2 $outcome1_1  rshIVall  $fe  $weighting  ,  $ses partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1
qui ivreg2 $outcome1_1  rshIVall  Uni_pre1990 off_skill ADHmanufacturingshare $fe   $weighting , $ses partial($fe Uni_pre1990 off_skill ADHmanufacturingshare)
est sto reg`regnum'_`num'
local num=`num'+1
sca mainb = _b[rshIVall]
qui ivreg2 $outcome1_2 rshIVall  $fe   $weighting ,  $ses partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1
qui ivreg2 $outcome1_2 rshIVall  Uni_pre1990 off_skill ADHmanufacturingshare $fe  $weighting  , $ses partial($fe Uni_pre1990 off_skill ADHmanufacturingshare)
est sto reg`regnum'_`num'
local regnum=`regnum'+1

*Panel b: high-middle (ignore edu=="1high", its equal in all rows, just not to use them twice)
local num=1
qui ivreg2 $outcome2_1  rshIVall  $fe   $weighting ,  $ses partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1
qui ivreg2 $outcome2_1 rshIVall  Uni_pre1990 off_skill ADHmanufacturingshare $fe   $weighting , $ses partial($fe Uni_pre1990 off_skill ADHmanufacturingshare)
est sto reg`regnum'_`num'
local num=`num'+1
qui ivreg2 $outcome2_2  rshIVall  $fe  $weighting  ,  $ses partial($fe)
est sto reg`regnum'_`num'
local num=`num'+1
qui ivreg2 $outcome2_2 rshIVall Uni_pre1990  off_skill ADHmanufacturingshare $fe   $weighting , $ses partial($fe Uni_pre1990 off_skill ADHmanufacturingshare)
est sto reg`regnum'_`num'
local num=`num'+1


*_______________________________________________________________________________________________________________________
*Generate Tables
 esttab reg1_* using $path/tab_wages.tex, replace b(3) se nostar keep(rsh*) stats(N r2)
 esttab reg2_* using $path/tab_wages.tex, append  b(3) se nostar keep(rsh*) stats(N r2)

* Interpretation example (times hours & weeks)*IQR*decads
di (mainb*52*42.5)*IQR*2
di (mainb*52*42.5)


