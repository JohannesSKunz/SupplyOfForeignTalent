********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate master file, merge individual datasets
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 

tempfile pop pop_age26_49
tempfile worker

********************************************************************************
** Destination dataset
*----------------------------------------
use _rawfiles/vz_msregion_originPLUSNA_recentimmigrant_pop1599 , clear 
drop edush1high edush2mid edush3low
*keep if year>1980
sort msregion  countryab year 
egen id=group(msregion countryab year)
reshape long pop , i(id) j(edu) string
g indcat="pop"
save `pop', replace

*----------------------------------------
use _rawfiles/vz_msregion_originPLUSNA_recentimmigrant_pop2649.dta , clear 
drop edush1high edush2mid edush3low
*keep if year>1980
sort msregion  countryab year 
egen id=group(msregion countryab year)
reshape long pop , i(id) j(edu) string
g indcat="age26_49"
save `pop_age26_49', replace


*----------------------------------------
*Workers
use _rawfiles/vz_msregion_origin_indcatMANNMAN_19702010_recentimmigrant_workers , clear 
keep indcat year msregion countryab worker1high worker2mid worker3low 
egen id=group(countryab msregion indcat year)
foreach v in 1high 2mid 3low { 
		rename worker`v' pop`v'
		}
reshape long pop , i(id) j(edu) string

append using `pop'
append using `pop_age26_49'

replace pop=round(pop,1)
g pop_plus1=pop+1
g lnpop_plus1=ln(pop_plus1)
g lnpop_noplus1=ln(pop)
g zeroflows=pop==0

g pop_pluseplison=pop+0.000000001
g lnpop_pluseplison=ln(pop_pluseplison)
g double neglnpop =  log(pop + sqrt(pop^2+1))

drop id
egen id=group(indcat msregion countryab year)

foreach cate in 1high 2mid 3low {
	g temp=lnpop_plus1 if edu=="`cate'"
	bys id: egen lnpop_plus1_`cate'=max(temp)
	la var lnpop_plus1_`cate' "LN Population + 1, `cate' "
	drop temp
	}

	* 	Plus epsilon
foreach cate in 1high 2mid 3low {
	g temp=lnpop_pluseplison if edu=="`cate'"
	bys id: egen lnpop_pluseplison_`cate'=max(temp)
	la var lnpop_pluseplison_`cate' "LN Population + epsilon, `cate' "
	drop temp
	}	
	
	* Log no plus 1 (Zeros dropped)
foreach cate in 1high 2mid 3low {
	g temp=lnpop_noplus1 if edu=="`cate'"
	bys id: egen lnpop_noplus1_`cate'=max(temp)
	la var lnpop_noplus1_`cate' "LN Population, `cate' "
	drop temp
	}	

	* Hyperbolic 
foreach cate in 1high 2mid 3low {
	g temp=neglnpop if edu=="`cate'"
	bys id: egen neglnpop_`cate'=max(temp)
	la var neglnpop_`cate' "LN Population hyperbolic, `cate' "
	drop temp
	}		
	
g lnpop_plus1_1high_2mid = lnpop_plus1_1high-lnpop_plus1_2mid	
g lnpop_plus1_2mid_3low = lnpop_plus1_2mid-lnpop_plus1_3low

g lnpop_noplus1_1high_2mid = lnpop_noplus1_1high-lnpop_noplus1_2mid	
g lnpop_noplus1_2mid_3low  = lnpop_noplus1_2mid-lnpop_noplus1_3low

g lnpop_pluseplison_1high_2mid = lnpop_pluseplison_1high-lnpop_pluseplison_2mid	
g lnpop_pluseplison_2mid_3low  = lnpop_pluseplison_2mid-lnpop_pluseplison_3low

g neglnpop_1high_2mid = neglnpop_1high-neglnpop_2mid	
g neglnpop_2mid_3low  = neglnpop_2mid-neglnpop_3low

	
la var edu 					    "Education categories"
la var pop 					    "Population, incl zero flows"
la var pop_plus1 			    "Population+1"
la var lnpop_plus1 			    "LN Population + 1"
la var lnpop_noplus1 		    "LN Population "
la var zeroflows 			    "Indicat for population 0"
la var lnpop_plus1_1high_2mid   "Delta LN Population + 1, high-mid"
la var lnpop_plus1_2mid_3low    "Delta LN Population + 1, mid-low"
la var lnpop_noplus1_1high_2mid "Delta LN Population , high-mid"
la var lnpop_noplus1_2mid_3low  "Delta LN Population , mid-low"
la var lnpop_pluseplison_1high_2mid "Delta LN Population + epsilon, high-mid"
la var lnpop_pluseplison_2mid_3low  "Delta LN Population + epsilon, mid-low"
la var neglnpop_1high_2mid  "Delta Hyperbolic Population , high-mid"
la var neglnpop_2mid_3low  "Delta Hyperbolic Population , mid-low"
*----------------------------------------
** MSNR 
*----------------------------------------
merge m:1 msregion using _temp/msnr , keep(1 3) nogen 
*----------------------------------------
** RSH 
*----------------------------------------
merge m:1 msregion year using _temp/rsh.dta , keep(1 3) nogen
*----------------------------------------
** OFFSHORING 
*----------------------------------------
merge m:1 msregion year using _rawfiles/vz_llm_offshoring_BI2015.dta , keep(1 3) nogen
drop off_occ_mean off_ad
*----------------------------------------
** ADH controls 
*----------------------------------------
merge m:1 msregion year using _rawfiles/vz_ADH2015_controls_BI2015.dta, keep(1 3) nogen

*----------------------------------------
** Wages
*----------------------------------------
merge m:1 msregion year using _temp/dest_characterisitcs.dta , keep(1 3) nogen

*----------------------------------------
** Schengen 
*----------------------------------------
merge m:1 countryab year using _rawfiles/EU_Schengen_BI2015.dta ,  keep(1 3) nogen keepusing(EU EU10 group2)

*----------------------------------------
** Source-Dest controls 
*----------------------------------------
merge m:1 countryab year using  _temp/source_characterisitcs.dta, keep(1 3) nogen

*----------------------------------------
** Source-Dest controls 
*----------------------------------------
merge m:1 msregion countryab year using  _temp/sourcedest_charaterisitcs.dta, keep(1 3) nogen

*----------------------------------------
** generate variables 
*----------------------------------------
egen id_cat=group(edu indcat msregion countryab)
xtset id_cat year 
g dlnpop=F10.lnpop_plus1-lnpop_plus1
g dlnpop_noplus1=F10.lnpop_noplus1-lnpop_noplus1
g dlnpop_pluseplison=F10.lnpop_pluseplison-lnpop_pluseplison
order id msregion countryab year edu indcat pop pop_plus1 lnpop_plus1 dlnpop  zeroflows

g dlnpophigh_mid = F10.lnpop_plus1_1high_2mid-lnpop_plus1_1high_2mid
g dlnpopmid_low  = F10.lnpop_plus1_2mid_3low-lnpop_plus1_2mid_3low

g dlnpop_noplus1_high_mid = F10.lnpop_noplus1_1high_2mid-lnpop_noplus1_1high_2mid
g dlnpop_noplus1_mid_low   = F10.lnpop_noplus1_2mid_3low -lnpop_noplus1_2mid_3low

g dlnpop_pluseplison_high_mid = F10.lnpop_pluseplison_1high_2mid-lnpop_pluseplison_1high_2mid
g dlnpop_pluseplison_mid_low   = F10.lnpop_pluseplison_2mid_3low -lnpop_pluseplison_2mid_3low

g dneglnpop_high_mid = F10.neglnpop_1high_2mid-neglnpop_1high_2mid
g dneglnpop_mid_low   = F10.neglnpop_2mid_3low -neglnpop_2mid_3low

* Long run differences
g dldlnpophigh_mid = F20.lnpop_plus1_1high_2mid-lnpop_plus1_1high_2mid
g dldlnpopmid_low  = F20.lnpop_plus1_2mid_3low-lnpop_plus1_2mid_3low

g NONEU=1-EU

g EUonly=EU
replace EUonly=0 if EU10==1
tab EUonly EU10
g treat=0
replace treat=EUonly*(year==2000)/100
g treat2=EU10*(year==2000)/100
g rshtreat=rsh*treat*100
g rshIValltreat=rshIVall*treat
g rshtreat2=rsh*treat2*100
g rshIValltreat2=rshIVall*treat2

la var indcat  			 "subsample indicator"
la var dlnpop			 "10-year difference in ln(pop+1) "
la var dlnpophigh_mid	 "10-year difference in ln(pop+1), high vs mid"
la var dlnpopmid_low  	 "10-year difference in ln(pop+1), mid vs low"
la var dldlnpophigh_mid  "20-year difference in ln(pop+1), high vs mid"
la var dldlnpopmid_low   "20-year difference in ln(pop+1), mid vs low"
la var dneglnpop_high_mid   "10-year difference in hypsine(pop), high vs mid"
la var dneglnpop_mid_low   "10-year difference in hypsine(pop), mid vs low"

la var dlnpop_noplus1			 "10-year difference in ln(pop) "
la var dlnpop_noplus1_high_mid	 "10-year difference in ln(pop), high vs mid"
la var dlnpop_noplus1_mid_low  	 "10-year difference in ln(pop), mid vs low"

la var NONEU		     "One if not EU"

g source_miss=countryab=="ZZ"
foreach var in edush21high1970 edush22mid1970 originimmsh70 {
replace `var'=0 if source_miss==1
}

foreach var in off_skill ADHmanufacturingshare {
g `var'_m=`var'==.
replace `var'=1 if `var'_m==1
}

tab off_skill_m countryab

compress 
save 2021_04_01_main.dta, replace

