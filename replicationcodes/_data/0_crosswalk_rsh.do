********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate RSH, median split, 
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 

********************************************************************************
*RSH data 
use _rawfiles/vz_llm_ms_rsh_rshIV
keep year msregion rsh rshIVall 
keep if year==1970
bys msregion: g t=_n
keep if t==1
drop t

*Gen stats
_pctile rshIVall, p(50)
scalar rshIVallp50 = r(r1)
_pctile rshIVall, p(25)
scalar rshIVallp25 = r(r1)
_pctile rshIVall, p(75)
scalar rshIVallp75 = r(r1)

*Def dummies: median split: quantile split: 1/4th quantile
g    highistrsh = rshIVall>rshIVallp50
la var highistrsh "Unweighted 1970 RSH median split"

g   	rshIVq = 4 if 	rshIVall>rshIVallp75
replace rshIVq = 3 if 	rshIVall>rshIVallp50 & rshIVall<=rshIVallp75
replace rshIVq = 2 if 	rshIVall>rshIVallp25 & rshIVall<=rshIVallp50
replace rshIVq = 1 if 	rshIVall<=rshIVallp25 
la var rshIVq "Unweighted 1970 RSH quartile split"

gen 	rshIVq1q4 = 1 if rshIVq==4
replace rshIVq1q4 = 0 if rshIVq==1
replace rshIVq1q4 = . if rshIVq==2 | rshIVq==3
la var rshIVq1q4 "Unweighted 1970 RSH 1 and 4th quartile"

*merge back to full data 
keep msregion rshIVq highistrsh rshIVq1q4
merge 1:m msregion using _rawfiles/vz_llm_ms_rsh_rshIV , nogen keepusing(rsh rshIVall canton year)
*keep if year>1980

*Onlz first RSH for wage graphs
*g temp= rsh if year==1990
*bys msregion: egen rsh1990=max(temp)
*drop temp 
*la var rsh1990 "RSH in 1990"

order msregion canton year rsh rshIVall highistrsh rshIVq rshIVq1q4 
compress
save _temp/rsh , replace
