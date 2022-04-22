********************************************************************************
** 	Table 3 for Beerli, Indergand & Kunz 2022
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
global fe "_Icanton* _Iyear* _Icountryab* _IcouXyea_* "

drop if year==2010
keep if indcat=="pop" 

cap prog drop 
prog def mytab 
	mat a = e(first)
	est sto reg`1'_`2'
	estadd sca Ffirst =  a[4,1] 	, : reg`1'_`2'
	estadd sca Ffirst_p = a[7,1]	, : reg`1'_`2'
	estadd sca Fendo = e(estat)  	, : reg`1'_`2'
	estadd sca Fendo_p = e(estatp) 	, : reg`1'_`2'
	estadd sca FAR = e(arf)         , : reg`1'_`2'
	estadd sca FAR_p = e(arfp)      , : reg`1'_`2'
end 

 
* Descriptives 
su rsh if edu=="1high"   & 	(year==1990| year==2000)
sca mean_rsh_mun = r(mean)
sca sd_rsh_mun   = r(sd)
su dlnpophigh_mid if edu=="1high"   & 	(year==1990| year==2000)
 

*_______________________________________________________________________________________________________________________
**Estimation 
*Panel a: high-middle (ignore edu=="1high", its equal in all rows, just not to use them twice)
loc regnum=1
loc num=1
ivreg2 dlnpophigh_mid (rsh = rshIVall)  $fe if edu=="1high"   &  year==1990, endog(rsh) ffirst cluster(msregion countryab) partial($fe)
	
	mytab `regnum' `num' 
	loc num=`num' +1 
	mat li a 
		
qui ivreg2 dlnpophigh_mid (rsh = rshIVall)  $fe if edu=="1high"   &  year==2000, endog(rsh) ffirst cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1 
	
qui ivreg2 dlnpophigh_mid (rsh = rshIVall)  $fe if edu=="1high"   & (year==1990| year==2000) , endog(rsh) ffirst cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1 
	
qui ivreg2 dlnpophigh_mid rsh   			$fe if edu=="1high"   & (year==1990| year==2000) , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpophigh_mid (rsh = rshIVall)  $fe if edu=="1high"   &  year==1970 , endog(rsh) ffirst cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	

*Panel b: high-middle (ignore edu=="1high", its equal in all rows, just not to use them twice)
loc regnum=`regnum' +1 
loc num=1 

qui ivreg2 dlnpopmid_low (rsh = rshIVall)  $fe if edu=="1high"   &  year==1990, endog(rsh) ffirst  cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1 
	
qui ivreg2 dlnpopmid_low (rsh = rshIVall)  $fe if edu=="1high"   &  year==2000, endog(rsh) ffirst  cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1 
	
qui ivreg2 dlnpopmid_low (rsh = rshIVall)  $fe if edu=="1high"   & 	(year==1990| year==2000)			  , endog(rsh) ffirst  cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1 
	
qui ivreg2 dlnpopmid_low rsh   $fe if edu=="1high"   & 	(year==1990| year==2000)			  , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpopmid_low (rsh = rshIVall)  $fe if edu=="1high"   &  year==1970, endog(rsh) ffirst  cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1 


*Panel c: high-skilled  
loc regnum=`regnum' +1 
loc num=1 

qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="1high" &  year==1990, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="1high" &  year==2000, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="1high"  & 	(year==1990| year==2000)  	   		 , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop rsh   $fe if edu=="1high"   & 	(year==1990| year==2000) 	   		 , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="1high" &  year==1970 , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 

*Panel d: middle-skilled 
loc regnum=`regnum' +1 
loc num=1 

qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="2mid"   &  year==1990, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="2mid"   &  year==2000, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="2mid"   & 	(year==1990| year==2000)             , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop rsh   $fe if edu=="2mid"   & 	(year==1990| year==2000)             , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="2mid"   &  year==1970, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 

*Panel e: low-skilled 
loc regnum=`regnum' +1 
loc num=1 

qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="3low"   &  year==1990, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 

qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="3low"   &  year==2000, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 

qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="3low"  & 	(year==1990| year==2000) 			 , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 

qui ivreg2 dlnpop rsh   $fe if edu=="3low"   & 	(year==1990| year==2000)			 , cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 

qui ivreg2 dlnpop (rsh = rshIVall)  $fe if edu=="3low"   &  year==1970, cluster(msregion countryab) partial($fe)
	est sto reg`regnum'_`num'
	loc num=`num' +1 
	
	
*_______________________________________________________________________________________________________________________
*Generate Tables
loc stats "stats(N r2 Ffirst Ffirst_p FAR FAR_p Fendo Fendo_p, layout(@ @  `""@(@)""' `""@(@)""' `""@(@)""') fmt(%9.0fc %9.2fc %9.1fc %9.2fc %9.1fc %9.2fc))"
 esttab reg1_* using $path/tab_main.tex, replace b(3) se nostar keep(rsh*) `stats'
 esttab reg2_* using $path/tab_main.tex, append  b(3) se nostar keep(rsh*) `stats'
 esttab reg3_* using $path/tab_main.tex, append  b(3) se nostar keep(rsh*) stats(N r2)
 esttab reg4_* using $path/tab_main.tex, append  b(3) se nostar keep(rsh*) stats(N r2)
 esttab reg5_* using $path/tab_main.tex, append  b(3) se nostar keep(rsh*) stats(N r2)


* Significantly different? 
gen rsh2000 = rsh*(year==2000)
gen rshIVall2000 = rshIVall*(year==2000)
loc regnum=1
loc num=1
ivreg2 dlnpophigh_mid (rsh rsh2000 = rshIVall rshIVall2000)  $fe if edu=="1high"   & (year==1990| year==2000) , endog(rsh) ffirst cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1  

qui ivreg2 dlnpophigh_mid (rsh rsh2000 = rshIVall rshIVall2000) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="1high" & indcat=="pop" & (year==1990| year==2000), cluster(msregion countryab) partial($fe $covars4m $covars5m)
	est sto reg`regnum'_`num'
	local regnum=`regnum'+1	
	
loc num=1
ivreg2 dlnpopmid_low (rsh rsh2000 = rshIVall rshIVall2000)  $fe if edu=="1high"   & (year==1990| year==2000) , endog(rsh) ffirst cluster(msregion countryab) partial($fe)
	mytab `regnum' `num' 
	loc num=`num' +1  	

qui ivreg2 dlnpopmid_low (rsh rsh2000 = rshIVall rshIVall2000) $covars1 $covars2 $covars3 $covars4 $covars5 $fe if edu=="1high" & indcat=="pop" & (year==1990| year==2000), cluster(msregion countryab) partial($fe $covars4m $covars5m)
	est sto reg`regnum'_`num'
	
 esttab reg1_* using $path/R1_tab4_sigdiff.tex , replace keep(rsh*) b(3) se star(* 0.1 ** 0.05 *** 0.01)
 esttab reg2_* using $path/R1_tab4_sigdiff.tex , append keep(rsh*) b(3) se star(* 0.1 ** 0.05 *** 0.01)
 
