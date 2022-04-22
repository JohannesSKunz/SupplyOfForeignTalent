********************************************************************************
** 	Figure 3 for Beerli, Indergand & Kunz 2022
********************************************************************************

*Settings
clear all 
set more off 
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 
global path "/Users/jkun0001/Dropbox/publications/2022_BeerliIndergandKunz/BIK_final/estimation/_figures/"
mat R = J(17,6,.)
set mat 10000

* Start 
use 2021_04_01_main.dta 
tab countryab EU10
keep if year>=1990

drop if EU10==1
collapse (sum)  pop , by(edu year highistrsh EU indcat)
sort edu indcat year highistrsh

tw (con pop year if edu=="1high"  & indcat=="pop" & EU==1  & highistrsh==1 , xlab(1990(10)2010) ylab(0(50000)150000) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop"  & EU==1  & highistrsh==1 , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop"  & EU==1  & highistrsh==1 , lpattern(dot)) , ///
   name(gr1, replace)  ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "Highly educated" 2 "Middle educated" 3 "Low educated") size(medsmall)  row(1) region(lcolor(white))) ///
   ytitle("") ///
   xtitle("") ///
   title("A. Above median RSH, 1970", size(medlarge))    

tw (con pop year if edu=="1high"  & indcat=="pop"  & EU==1  & highistrsh==0 , xlab(1990(10)2010) ylab(0(50000)150000) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop"  & EU==1  & highistrsh==0  , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop"  & EU==1  & highistrsh==0  , lpattern(dot)) , ///
   name(gr2, replace) ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "Highly educated" 2 "Middle educated" 3 "Low educated") size(medsmall)  row(1) region(lcolor(white))) ///
   ytitle("") ///
   xtitle("") ///
   title("B. Below median RSH, 1970", size(medlarge))    
   
tw (con pop year if edu=="1high"  & indcat=="pop" & EU==0 & highistrsh==1  , xlab(1990(10)2010) ylab(0(50000)150000) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop" & EU==0 & highistrsh==1  , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop" & EU==0 & highistrsh==1 , lpattern(dot)) , ///
   name(gr3, replace) ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "High skilled" 2 "Middle skilled" 3 "Low skilled") size(medsmall)  row(1) region(lcolor(white))) ///
   ytitle("") ///
   xtitle("") ///
   title("C. Above median RSH, 1970", size(medlarge))    

tw (con pop year if edu=="1high"  & indcat=="pop" & EU==0 & highistrsh==0 , xlab(1990(10)2010) ylab(0(50000)150000) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop" & EU==0 & highistrsh==0 , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop" & EU==0 & highistrsh==0 , lpattern(dot)) , ///
   name(gr4, replace)   ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "High skilled" 2 "Middle skilled" 3 "Low skilled") size(medsmall)  row(1) region(lcolor(white))) ///
   ytitle("") ///
   xtitle("") ///
   title("D. Below median RSH, 1970", size(medlarge))    
    

grc1leg  gr1 gr2 , title("I. EU immigrants") name(gr5, replace) legendfrom(gr1) ycommon  scheme(s1mono) row(1) col(4) // ysize(6) xsize(6)
grc1leg  gr3 gr4 , title("II. Non-EU immigrants") name(gr6, replace) legendfrom(gr3) ycommon  scheme(s1mono) row(1) col(4) // ysize(6) xsize(6)
grc1leg  gr5 gr6 , title("") legendfrom(gr5) ycommon scheme(s1mono) col(2) altshrink l2title(# of new immigrants) name(g7, replace)
graph display g7, xsize(9) ysize(4)

graph export $path/fig_eunoeu.pdf, replace 



