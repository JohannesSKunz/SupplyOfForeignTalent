********************************************************************************
** 	Table 1 for Beerli, Indergand & Kunz 2022
********************************************************************************

*Settings
clear all 
set more off 
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 
global path "/Volumes/Time Machine Backups/Storage/_dropbox/publications/2022_BeerliIndergandKunz/BIK_final/estimation/_tables"
mat R = J(17,6,.)

*-------------------------------------------
*** Tasks
*-------------------------------------------
use 2017_09_02_tasks, clear

local j=1
foreach cat in 1 0 {   
qui su  population if highistrsh==`cat' & year==1990 
   mat R[1,`j'] = r(sum) 

local i=2
foreach var in RTItop331990 indcat1 indcat2 indcat3 indcat4 indcat5 indcat6 {
	qui su `var' if highistrsh==`cat' & year==1990 [aw=population]
	mat R[`i',`j'] = r(mean)
	local i=`i'+1
	}
local j=`j'+1

//Col 2 
qui su  population if highistrsh==`cat' & year==1990 
sca r1= r(sum) 
qui su  population if highistrsh==`cat' & year==2000 
sca r2= r(sum) 
   mat R[1,`j'] = r2-r1   
local i=2
foreach var in RTItop331990 indcat1 indcat2 indcat3 indcat4 indcat5 indcat6 {
	qui su `var' if highistrsh==`cat' & year==1990 [aw=population]
	sca r1= r(mean) 
	qui su  `var' if highistrsh==`cat' & year==2000 [aw=population]
	sca r2= r(mean) 
    mat R[`i',`j'] = (r2-r1)
	local i=`i'+1
	}
local j=`j'+1

//Col 3 
qui su  population if highistrsh==`cat' & year==2000 
sca r1= r(sum) 
qui su  population if highistrsh==`cat' & year==2010 
sca r2= r(sum) 
   mat R[1,`j'] = r2-r1   
local i=2
foreach var in RTItop331990 indcat1 indcat2 indcat3 indcat4 indcat5 indcat6 {
	qui su `var' if highistrsh==`cat' & year==2000 [aw=population]
	sca r1= r(mean) 
	qui su  `var' if highistrsh==`cat' & year==2010 [aw=population]
	sca r2= r(mean) 
    mat R[`i',`j'] = (r2-r1)
	local i=`i'+1
	}
local j=`j'+1
}
mat li R, format(%11.2f)
*/

*
*-------------------------------------------
*** Immigrants
*-------------------------------------------
use 2021_04_01_main.dta , clear
keep if indcat=="pop"
drop if edu=="total"
local j=1 
foreach k in 1 0 {
local i=9
su pop if highistrsh==`k' & year==1990 
sca pop_total_ir_1990=r(sum)
mat R[`i',`j'] =pop_total_ir_1990
local i=`i'+1 

foreach l in 1high 2mid 3low {
su pop if highistrsh==`k' & year==1990 & edu=="`l'" 
sca pop_`l'_ir_1990=r(sum)
mat R[`i',`j'] =pop_`l'_ir_1990/pop_total_ir_1990
local i=`i'+1 
}

//Col2 
local j=`j'+1 
local i=9 
su pop if highistrsh==`k' & year==2000 
sca pop_total_ir_2000=r(sum)
mat R[`i',`j'] =pop_total_ir_2000 - pop_total_ir_1990
local i=`i'+1 

foreach l in 1high 2mid 3low {
su pop if highistrsh==`k' & year==2000 & edu=="`l'" 
sca pop_`l'_ir_2000=r(sum)
mat R[`i',`j'] =pop_`l'_ir_2000/pop_total_ir_2000 - pop_`l'_ir_1990/pop_total_ir_1990
local i=`i'+1 
}

//Col3 
local j=`j'+1 
local i=9 
su pop if highistrsh==`k' & year==2010 
sca pop_total_ir_2010=r(sum)
mat R[`i',`j'] =pop_total_ir_2010 - pop_total_ir_2000
local i=`i'+1 

foreach l in 1high 2mid 3low {
su pop if highistrsh==`k' & year==2010 & edu=="`l'" 
sca pop_`l'_ir_2010=r(sum)
mat R[`i',`j'] =pop_`l'_ir_2010/pop_total_ir_2010 - pop_`l'_ir_2000/pop_total_ir_2000
local i=`i'+1 
}
local j=`j'+1 
}

*/

*-------------------------------------------
*** Wages
*-------------------------------------------
use 2017_09_16_wages.dta, clear
rename ms_nr msregion

replace year=1990 if year==1994
keep if year==1990 | year==2000 | year==2010
merge m:1 msregion year using _temp/rsh
drop _merge

*Col 1 
local j=1
foreach cat in 1 0 {   	
local i=13
foreach var in wagerhrl1high wagerhrl2mid wagerhrl3low {
	noi su `var' if highistrsh==`cat' & year==1990 [aw=workertotal]
	sca def sca_`var'=r(mean)
	mat R[`i',`j'] = sca_`var'
	local i=`i'+1
	}
	mat R[`i',`j'] = sca_wagerhrl1high - sca_wagerhrl2mid
	local i=`i'+1
	mat R[`i',`j'] = sca_wagerhrl2mid - sca_wagerhrl3low
	local i=`i'+1

*Col 2 
local j=`j'+1
local i=13
foreach var in wagerhrl1high wagerhrl2mid wagerhrl3low {
	noi su `var' if highistrsh==`cat' & year==1990 [aw=workertotal]
	sca def sca1_`var'=r(mean)
	noi su `var' if highistrsh==`cat' & year==2000 [aw=workertotal]
	sca def sca2_`var'=r(mean)
	mat R[`i',`j'] = sca2_`var' - sca1_`var'
	local i=`i'+1
	}
	mat R[`i',`j'] = (sca2_wagerhrl1high - sca2_wagerhrl2mid) - (sca1_wagerhrl1high - sca1_wagerhrl2mid)
	local i=`i'+1
	mat R[`i',`j'] = (sca2_wagerhrl2mid - sca2_wagerhrl3low) - (sca1_wagerhrl2mid - sca1_wagerhrl3low)
	local i=`i'+1

*Col 3
local j=`j'+1
local i=13
foreach var in wagerhrl1high wagerhrl2mid wagerhrl3low {
	noi su `var' if highistrsh==`cat' & year==2000 [aw=workertotal]
	sca def sca1_`var'=r(mean)
	noi su `var' if highistrsh==`cat' & year==2010 [aw=workertotal]
	sca def sca2_`var'=r(mean)
	mat R[`i',`j'] = sca2_`var' - sca1_`var'
	local i=`i'+1
	}
	mat R[`i',`j'] = (sca2_wagerhrl1high - sca2_wagerhrl2mid) - (sca1_wagerhrl1high - sca1_wagerhrl2mid)
	local i=`i'+1
	mat R[`i',`j'] = (sca2_wagerhrl2mid - sca2_wagerhrl3low) - (sca1_wagerhrl2mid - sca1_wagerhrl3low)
	local i=`i'+1

local j=`j'+1
}


mat li R, format(%11.2f)
outtable using $path/tab_desc , mat(R)  nobox replace format(%11.2f)

exit 
*/


