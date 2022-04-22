********************************************************************************
** 	Figure 2 for Beerli, Indergand & Kunz 2022
********************************************************************************

*Settings
clear all 
set more off 
cap cd "/Users/jkun0001/Desktop/_data/Swisscensus_BIK/" // Change path 
global path "/Users/jkun0001/Dropbox/publications/2022_BeerliIndergandKunz/BIK_final/estimation/_figures/"
mat R = J(17,6,.)
set mat 10000


//by quantil
use 2021_04_01_main.dta
keep if year>=1990

collapse (sum)  pop , by(edu year highistrsh rshIVq indcat)

tw (con pop year if edu=="1high"  & indcat=="pop" & rshIVq==4 , xlab(1990(10)2010) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop" & rshIVq==4 , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop" & rshIVq==4 , lpattern(dot)) , ///
   name(gr1)  ysize(5) xsize(4) fysize(70) fxsize(55) ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "Highly educated" 2 "Middle educated" 3 "Low educated") size(medsmall)  row(1) region(lcolor(white))) ///
   ytitle("") ///
   xtitle("") ///
   title("A. 4th quartile: RSH, 1970", size(medsmall))    

tw (con pop year if edu=="1high"  & indcat=="pop" & rshIVq==3 , xlab(1990(10)2010) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop" & rshIVq==3 , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop" & rshIVq==3 , lpattern(dot)) , ///
   name(gr2)  ysize(5) xsize(4) fysize(70) fxsize(55) ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "high" 2 "mid" 3 "low") size(vsmall)  row(1) ) ///
   ytitle("") ///
   xtitle("") ///
   title("B. 3rd quartile: RSH, 1970", size(medsmall))    
   
tw (con pop year if edu=="1high"  & indcat=="pop" & rshIVq==2 , xlab(1990(10)2010) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop" & rshIVq==2 , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop" & rshIVq==2 , lpattern(dot)) , ///
   name(gr3)  ysize(5) xsize(4) fysize(70) fxsize(55) ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "high" 2 "mid" 3 "low") size(vsmall)  row(1) ) ///
   ytitle("") ///
   xtitle("") ///
   title("C. 2nd quartile: RSH, 1970", size(medsmall))     

tw (con pop year if edu=="1high"  & indcat=="pop" & rshIVq==1 , xlab(1990(10)2010) lpattern(solid)) ///
   (con pop year if edu=="2mid"  & indcat=="pop" & rshIVq==1 , lpattern(dash)) ///
   (con pop year if edu=="3low"  & indcat=="pop" & rshIVq==1 , lpattern(dot)) , ///
   name(gr4)  ysize(5) xsize(4) fysize(70) fxsize(55) ///
   scheme(s2mono) graphregion(color(white)) bgcolor(white)  ///
   legend(order(1 "high" 2 "mid" 3 "low") size(vsmall)  row(1) ) ///
   ytitle("") ///
   xtitle("") ///
   title("D. 1st quartile: RSH, 1970", size(medsmall))  
   

grc1leg gr1 gr2 gr3 gr4 , legendfrom(gr1) ycommon scheme(s1mono) row(1) col(4) ysize(8) xsize(12)  l1title("# of recent immigrants") name(g5, replace)  
graph display g5, xsize(9) ysize(4)
cap graph export $path/fig2_inflow.pdf, replace 

