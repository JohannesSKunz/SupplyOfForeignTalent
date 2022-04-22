********************************************************************************
** 	Prepare Data for Beerli, Indergand & Kunz 2022
**	Generate Oc-Wage Percitiles adjusted from Autor Dorn
**
********************************************************************************
*Settings
clear all
set more off
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 


********************************************************************************
** Wage graphs
*---------------------------------------- 

** Percentile ranks
//Pool 1991-1993 and 2009-2011 
use _rawfiles/sake19912014_allvariables.dta

replace year= 1990 if year==1991 | year==1992 | year==1993
keep if year==1990
drop if LNnetwage_rhrl==.
drop if isco084==. 
keep if wklhrs > 0 & wklhrs < .
replace wklhrs= wklhrs * weight_cross
collapse (count) num_obs = LNnetwage_rhrl (mean) LNnetwage_rhrl [aw = wklhrs] , by(isco084)
* Rank occupations in increasing order of mean log wage
sort LNnetwage_rhrl
gen occ_rank = _n
keep isco084 occ_rank
tempfile ranks
saveold "`ranks'.dta", replace

*Restart
use _rawfiles/sake19912014_allvariables.dta , clear

replace wklhrs= wklhrs * weight_cross
collapse (sum) wklhrs, by(isco084)
drop if isco084 == .
drop if wklhrs== . | wklhrs==0 
merge m:1 isco084 using "`ranks'.dta", 
keep if _merge==3
drop _merge

* Determine the interval taken up by each occupation
egen totlswt = total(wklhrs)
sort occ_rank
gen sumlswt = sum(wklhrs)
gen perc = 100 * (sumlswt/totlswt)
keep isco084 perc
sort perc
gen perc_start = perc[_n - 1]
replace perc_start = 0 in 1
rename perc perc_end
order isco084 perc_start perc_end

* Determine the minimum and maximum percentiles straddled by each occupation
gen min_perc = max(1, ceil(perc_start))
gen max_perc = max(1, ceil(perc_end))

* Determine the number of percentiles to which an occupation contributes
gen num_percs = max_perc - min_perc + 1

* One observation per occupation x percentile
expand num_percs
bysort isco084: gen n = _n

gen perc = min_perc + (n - 1)
sort perc_start perc
keep isco084 perc_start perc_end perc

* Determine what fraction of the occupation to map into this percentile
gen perc_span = min(perc_end, perc) - max(perc_start, perc - 1)

gen frac = perc_span/(perc_end - perc_start)
keep isco084 perc frac
bysort isco084: egen tot_frac = total(frac)
assert abs(tot_frac - 1) < .01
drop tot_frac

* Save as a crosswalk
sort isco084 perc
compress
save _temp/percentiles.dta, replace
