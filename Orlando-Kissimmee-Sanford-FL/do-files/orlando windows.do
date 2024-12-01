* Name: Marie Hasegawa
* Date: 4/3/2021
* Title: Hasegawa Orlando Project
clear
set more off
cd "C:\Users\Jing Jing\Desktop\Orlando Time Series Project"
log using "Hasegawa Orlando Project", replace
import delimited using "Time_Series_Orlando_Project_Monthly.txt" 

*smu12367400500000001 refers to All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA)

*smu12367400500000002 refers to Average Hourly Earnings of All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA)

*smu12367400500000003 refers to Average Weekly Earnings of All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA)

*smu12367400500000011 refers to Average Weekly Hours of All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA)

** data prep
rename date datestring
gen dateday=date(datestring,"YMD")
gen date=mofd(dateday)
format date %tm
tsset date
tsappend, add(1) 
generate month=month(dofm(date)) 
keep if date>=tm(1990m1)

*All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA), source: Federal Reserve Bank of St. Louis, U.S. Bureau of Labor Statistics, Thousands of Persons      
rename smu12367400500000001 total_priv_emp1000
*generate month=month(dateday)

* Average Weekly Hours of All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA), Federal Reserve Bank of St. Louis U.S. Bureau of Labor Statistics, Hours per Week     
rename smu12367400500000002 avg_weekly_hourly

*Average Hourly Earnings of All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA), Federal Reserve Bank of St. Louis U.S. Bureau of Labor Statistics, Dollars per Hour   
rename smu12367400500000003 avg_hourly_dollar

*Average Weekly Earnings of All Employees: Total Private in Orlando-Kissimmee-Sanford, FL (MSA), Federal Reserve Bank of St. Louis U.S. Bureau of Labor, Dollars per Week   Statistics                                     
rename smu12367400500000011 avg_weekly_dollar

gen lnemp1000=ln(total_priv_emp1000)
gen lnavg_WeekHour=ln(avg_weekly_hour)
gen lnavg_HourDolla=ln(avg_hourly_dollar)
gen lnavg_WeekDolla=ln(avg_weekly_dollar)

tab month, generate(m) 


*summary statistics
summarize date lnemp1000 lnavg_WeekDolla lnavg_HourDolla lnavg_WeekHour
*estat ic

*regression
reg d.lnavg_WeekDolla l(1,2,3,6,12,24)d.lnavg_WeekDolla l(1,2,3)d.lnemp1000 l(1,2,3)d.lnavg_HourDolla l(1,2,3)d.lnavg_WeekHour

reg d.lnemp1000 l(1,2,3,6,12,24)d.lnemp1000 l(1,2,3)d.lnavg_WeekDolla l(1,2,3)d.lnavg_HourDolla l(1,2,3)d.lnavg_WeekHour

*ACs and PACs
ac lnavg_WeekDolla if tin(1980m1,2021m2)
pac lnavg_WeekDolla if tin(1980m1,2021m2)

ac lnemp1000 if tin(1980m1,2021m2)
pac lnemp1000 if tin(1980m1,2021m2)

**So, need to difference
pac d.lnemp1000 if tin(1980m1,2021m2)
**So, need to difference
ac d.lnemp1000 if tin(1980m1,2021m2)


**So, need to difference
pac d.lnavg_WeekDolla if tin(1980m1,2021m2)
**So, need to difference
ac d.lnavg_WeekDolla if tin(1980m1,2021m2)


*tslines
tsline lnemp1000 lnavg_WeekDolla lnavg_HourDolla lnavg_WeekHour
tsline total_priv_emp1000 avg_weekly_hourly avg_hourly_dollar avg_weekly_dollar


*generate differences and lags thereof for use with gsreg 
*lnemp1000 ***
gen dlnemp1000=d.lnemp1000 
gen ldlnemp1000=ld.lnemp1000 
gen l2dlnemp1000=l2d.lnemp1000 
gen l3dlnemp1000=l3d.lnemp1000 
gen l6dlnemp1000=l6d.lnemp1000 
gen l12dlnemp1000=l12d.lnemp1000 
gen l24dlnemp1000=l24d.lnemp1000 

*lnavg_WeekDolla ***
gen dlnavg_WeekDolla=d.lnavg_WeekDolla
gen ldlnavg_WeekDolla=ld.lnavg_WeekDolla 
gen l2dlnavg_WeekDolla=l2d.lnavg_WeekDolla 
gen l3dlnavg_WeekDolla=l3d.lnavg_WeekDolla 
gen l6dlnavg_WeekDolla=l6d.lnavg_WeekDolla 
gen l12dlnavg_WeekDolla=l12d.lnavg_WeekDolla 
gen l24dlnavg_WeekDolla=l24d.lnavg_WeekDolla 


*lnavg_HourDolla
gen ldlnavg_HourDolla=ld.lnavg_HourDolla 
gen l2dlnavg_HourDolla=l2d.lnavg_HourDolla 
gen l3dlnavg_HourDolla=l3d.lnavg_HourDolla 

*lnavg_WeekHour
gen ldlnavg_WeekHour=ld.lnavg_WeekHour 
gen l2dlnavg_WeekHour=l2d.lnavg_WeekHour 
gen l3dlnavg_WeekHour=l3d.lnavg_WeekHour 

* FOR dlnemp1000
*gsreg dlnemp1000 ldlnemp1000 l2dlnemp1000 l3dlnemp1000 l6dlnemp1000 l12dlnemp1000 l24dlnemp1000 ldlnavg_WeekDolla l2dlnavg_WeekDolla l3dlnavg_WeekDolla ldlnavg_HourDolla l2dlnavg_HourDolla l3dlnavg_HourDolla ldlnavg_WeekHour l2dlnavg_WeekHour l3dlnavg_WeekHour, results(ps5models_dlnemp1000.dta) replace fix(m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12) ncomb(1,9) aic outsample(24) nindex( -1 aic -1 bic -1 r_sqr_a) samesample

* FOR dlnavg_WeekDolla
* gsreg dlnavg_WeekDolla ldlnavg_WeekDolla l2dlnavg_WeekDolla l3dlnavg_WeekDolla l6dlnavg_WeekDolla l12dlnavg_WeekDolla l24dlnavg_WeekDolla ldlnemp1000 l2dlnemp1000 l3dlnemp1000 ldlnavg_HourDolla l2dlnavg_HourDolla l3dlnavg_HourDolla ldlnavg_WeekHour l2dlnavg_WeekHour l3dlnavg_WeekHour, results(ps5models_dlnavg_WeekDolla.dta) replace fix(m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12) ncomb(1,9) aic outsample(24) nindex( -1 aic -1 bic -1 r_sqr_a) samesample


/* 
Checking the gsreg output, the best model for dlnemp1000: 


GRSEG Rank NORMAL: 
	d.lnemp1000 l(1,2,3,6,12,24)d.lnemp1000 l(1,2,3)d.lnavg_WeekDolla l(1,2,3)d.lnavg_HourDolla l(1,2,3)d.lnavg_WeekHour

GRSEG Rank 1 has aic, bic, and r_sqr_a of -1195.081, -1147.676, and .810672: 
	d.lnemp1000 l(1,2,3)d.lnemp1000 ld.lnavg_WeekHour

GRSEG Rank 2 has aic, bic, and r_sqr_a of -1195.752, -1145.384, and .812701:
	d.lnemp1000 l(1,2,3)d.lnemp1000 l(2)d.lnavg_WeekDolla ld.lnavg_WeekHour

GRSEG Rank 5 has aic, bic, and r_sqr_a of -1198.513, -1145.181, and .8173841:
	d.lnemp1000 l(1,2,3)d.lnemp1000 ld.lnavg_WeekDolla ld.lnavg_HourDolla ld.lnavg_WeekHour

GRSEG Rank 13 has aic, bic, and r_sqr_a of -1199.434, -1143.14, and .819634:
	d.lnemp1000 l(1,2,3)d.lnemp1000 l(1,2)d.lnavg_WeekDolla ld.lnavg_HourDolla ld.lnavg_WeekHour

	



Checking the gsreg output, the best model for dlnavg_WeekDolla: 

GRSEG Rank NORMAL: 
	d.lnavg_WeekDolla l(1,2,3,6,12,24)d.lnavg_WeekDolla l(1,2,3)d.lnemp1000 l(1,2,3)d.lnavg_HourDolla l(1,2,3)d.lnavg_WeekHour

GRSEG Rank 1 has aic, bic, and r_sqr_a of -658.9932, -622.5409, and .0889874: 
	d.lnavg_WeekDolla ld.lnavg_WeekDolla 

GRSEG Rank 2 has aic, bic, and r_sqr_a of -660.822, -621.5657, and .1089599: 
	d.lnavg_WeekDolla l(1,2)d.lnavg_WeekDolla 

GRSEG Rank 13 has aic, bic, and r_sqr_a of -660.6411, -618.5807, and .1139424: 
	d.lnavg_WeekDolla ld.lnavg_WeekDolla l(2)d.lnemp1000 l(2)d.lnavg_WeekHour

GRSEG Rank 18 has aic, bic, and r_sqr_a of -660.3221, -618.2617, and .1116227: 
	d.lnavg_WeekDolla l(1,2)d.lnavg_WeekDolla l(2)d.lnemp1000 l(2)d.lnavg_WeekHour
	
*/ 
*************************************************************************************
*Rolling window program for GSREG Normal for dlnemp1000
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/722 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnemp1000 l(1,2,3,6,12,24)d.lnemp1000 l(1,2,3)d.lnavg_WeekDolla l(1,2,3)d.lnavg_HourDolla l(1,2,3)d.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 


	
*Rolling window program for GSREG Rank 1 for dlnemp1000
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/722 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnemp1000 l(1,2,3)d.lnemp1000 ld.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG Rank 2 for dlnemp1000
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/722 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnemp1000 l(1,2,3)d.lnemp1000 l(2)d.lnavg_WeekDolla ld.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG Rank 5 for dlnemp1000
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/722 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnemp1000 l(1,2,3)d.lnemp1000 ld.lnavg_WeekDolla ld.lnavg_HourDolla ld.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG Rank 13 for dlnemp1000
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/722 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnemp1000 l(1,2,3)d.lnemp1000 l(1,2)d.lnavg_WeekDolla ld.lnavg_HourDolla ld.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 


* Normal for dlnemp1000: RWrmse96 =  .00308708
* GSREG Rank 1 for dlnemp1000: RWrmse96 =  .00249426
**** BEST SELECTION: GSREG Rank 2 for dlnemp1000: RWrmse72 =  .00244325****
* GSREG Rank 5 for dlnemp1000: RWrmse96 =  .00263625
* GSREG Rank 13 for dlnemp1000: RWrmse72 =  .00267527


*************************************************************************************
*Rolling window program for GSREG Normal for dlnavg_WeekDolla
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/722 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnavg_WeekDolla l(1,2,3,6,12,24)d.lnavg_WeekDolla l(1,2,3)d.lnemp1000 l(1,2,3)d.lnavg_HourDolla l(1,2,3)d.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG 1 for dlnavg_WeekDolla
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/720 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnavg_WeekDolla ld.lnavg_WeekDolla m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG 2 for dlnavg_WeekDolla
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/720 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnavg_WeekDolla l(1,2)d.lnavg_WeekDolla m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG 13 for dlnavg_WeekDolla
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/720 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnavg_WeekDolla ld.lnavg_WeekDolla l(2)d.lnemp1000 l(2)d.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

*Rolling window program for GSREG 18 for dlnavg_WeekDolla
scalar drop _all
quietly forvalues w=36(12)180 {
gen pred=. 
gen nobs=.
	forvalues t=696/720 {
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnavg_WeekDolla l(1,2)d.lnavg_WeekDolla l(2)d.lnemp1000 l(2)d.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnemp1000)^2
summ errsq 
scalar RWrmse`w'=r(mean)^.5 
summ nobs 
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max) 
drop errsq pred nobs 
}
scalar list 

* Normal for dlnavg_WeekDolla: RWrmse96 =  .01143803 
*GSREG Rank 1 for dlnavg_WeekDolla: RWrmse120 =  .00885828 
* GSREG Rank 2 for dlnavg_WeekDolla: RWrmse132 =  .00949921
**** BEST SELECTION:  GSREG Rank 13 for dlnavg_WeekDolla: RWrmse120 =  .00862317
* GSREG Rank 18 for dlnavg_WeekDolla: RWrmse120 =  .00980841

*******************************************************************************
**** BEST SELECTION: GSREG Rank 2 for dlnemp1000: RWrmse72 =  .00244325****

*GRSEG Rank 2 has aic, bic, and r_sqr_a of -1195.752, -1145.384, and .812701:
*	d.lnemp1000 l(1,2,3)d.lnemp1000 l(2)d.lnavg_WeekDolla ld.lnavg_WeekHour


*Rolling window program for GSREG Rank 2 for dlnemp1000
scalar drop _all

gen pred=. 
gen nobs=.
	forvalues t=663/733 {
	gen wstart=`t'-96
	gen wend=`t'-1
	reg d.lnemp1000 l(1,2,3)d.lnemp1000 l(2)d.lnavg_WeekDolla ld.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen res=d.lnemp1000-pred
gen errsq=res^2
summ errsq 
scalar RWrmse96=r(mean)^.5 
summ nobs 
scalar RWminobs96=r(min) 
scalar RWmaxobs96=r(max) 

scalar list 

*Forecast from selected model for dlnemp1000

reg d.lnemp1000 l(1,2,3,6,12,24)d.lnemp1000 l(1,2,3)d.lnavg_WeekDolla m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if tin(2017m1,2021m2) 
predict temp if date==tm(2021m3) 
replace pred=temp if date==tm(2021m3) 

*Empirical forecast and interval for dlnemp1000 
gen expres=exp(res) 
summ expres 
gen epy=exp(l.lnemp1000+pred)*r(mean) 
_pctile res, percentiles(2.5,97.5) 

gen eub=epy*exp(r(r2)) 
gen elb=epy*exp(r(r1)) 
twoway (scatter total_priv_emp1000 date if tin(2017m1,2021m2) , m(Oh) ) (tsline epy eub elb if tin(2017m1,2021m3) , lpattern(solid dash dash) lcolor(black gs10 gs10) ) , saving(ps5_fcst, replace) scheme(s1mono) ylabel(,grid) xtitle("") legend(label(1 "Private Employment") label(2 "Forecast") label(3 "95% Upper Bound") label(4 "95% Lower Bound") )  title("Florida Private Employment" "One Month Ahead Emprical Forecast")

graph export ps5empfcst.emf, replace

list epy eub elb if date==tm(2021m3)



*Normal forecast and interval for dlnemp1000
* 2 sigma interval
gen npy=exp(l.lnemp1000+pred+(RWrmse96^2)/2)
gen nub=npy*exp(2*RWrmse96)
gen nlb=npy/exp(2*RWrmse96)
	
	

	
twoway (scatter total_priv_emp1000 date if tin(2017m1,2021m2) , m(Oh) ) 	(tsline npy nub nlb if tin(2017m1,2021m3) , lpattern(solid dash dash) lcolor(black gs10 gs10) ) , saving(ps5_fcst, replace) scheme(s1mono) ylabel(,grid) xtitle("") legend(label(1 "private Employment") label(2 "Forecast") label(3 "95% Upper Bound") label(4 "95% Lower Bound") ) title("Florida Private Employment" "One Month Ahead Normal Forecast") note("1) All forecasts are out of sample based on a 96 month rolling window." "2) Inteval based on percentiles +-1.95 RMMSE from the rolling window procedure." "3) Predictors are lags 3, 4, 12, 24 of private employment and lag 4 of the US emp:pop ratio." )

graph export ps5normfcst.emf, replace

list npy nub nlb if date==tm(2021m3)


hist res, frac normal scheme(s1mono)  title("Private Employment Empirical Forecast Error Distribution") xtitle("") note("Private Employment for March For 96 month rolling window forecasts.")
graph export ps5errdist.emf , replace

summ res
gen nres=(res-r(mean))/r(sd)

qnorm nres, scheme(s1mono)  title("Private Employment Quantile-Normal Plot of Forecast Error") xtitle("Inverse Standard Normal of Residual Percentile") ytitle("Residual Z-Score") xlabel(-6(2)4,grid) ylabel(-6(2)4,grid) note("Private Employment for March For 96 month rolling window forecasts.")
graph export ps5qnorm.emf , replace


*check the information
_pctile res, percentiles(2.5,97.5)
return list
summarize date
summarize date if res>=.2055689990520477
summarize date if res==.2055689990520477
summarize date if res==-.1121157556772232
tsline res if tin(2019m6, 2021m1)
*******************************************************************************
**** BEST SELECTION: GSREG Rank 13 for dlnavg_WeekDolla: RWrmse120 =  .00862317 since it is the 2nd smallest RWMSE and has more variables 


*Rolling window program for GSREG Rank 2 for dlnavg_WeekDolla
scalar drop _all

gen pred=. 
gen nobs=.
	forvalues t=663/733 {
	gen wstart=`t'-96
	gen wend=`t'-1
	reg d.lnavg_WeekDolla ld.lnavg_WeekDolla l(2)d.lnemp1000 l(2)d.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen res=d.lnemp1000-pred
gen errsq=res^2
summ errsq 
scalar RWrmse96=r(mean)^.5 
summ nobs 
scalar RWminobs96=r(min) 
scalar RWmaxobs96=r(max) 

scalar list 
*************************************
*Forecast from selected model for dlnavg_WeekDolla

reg d.lnavg_WeekDolla ld.lnavg_WeekDolla l(2)d.lnemp1000 l(2)d.lnavg_WeekHour m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if tin(2017m1,2021m2)
predict temp if date==tm(2021m3) 
replace pred=temp if date==tm(2021m3) 

*Empirical forecast and interval for dlnavg_WeekDolla 
gen expres=exp(res) 
summ expres 
gen epy=exp(l.lnavg_WeekDolla+pred)*r(mean) 
_pctile res, percentiles(2.5,97.5) 

gen eub=epy*exp(r(r2)) 
gen elb=epy*exp(r(r1)) 
twoway (scatter avg_weekly_dollar date if tin(2017m1,2021m2) , m(Oh) ) (tsline epy eub elb if tin(2017m1,2021m3) , lpattern(solid dash dash) lcolor(black gs10 gs10) ) , saving(ps5_fcst, replace) scheme(s1mono) ylabel(,grid) xtitle("") legend(label(1 " Average Weekly Earnings") label(2 "Forecast") label(3 "95% Upper Bound") label(4 "95% Lower Bound") )  title(" Average Weekly Earnings" "One Month Ahead Emprical Forecast")

graph export ps5empfcst.emf, replace

list epy eub elb if date==tm(2021m3)



*Normal forecast and interval for dlnavg_WeekDolla
* 2 sigma interval
gen npy=exp(l.lnavg_WeekDolla+pred+(RWrmse96^2)/2)
gen nub=npy*exp(2*RWrmse96)
gen nlb=npy/exp(2*RWrmse96)
	
	

	
twoway (scatter avg_weekly_dollar date if tin(2017m1,2021m2) , m(Oh) ) 	(tsline npy nub nlb if tin(2017m1,2021m3) , lpattern(solid dash dash) lcolor(black gs10 gs10) ) , saving(ps5_fcst, replace) scheme(s1mono) ylabel(,grid) xtitle("") legend(label(1 " Average Weekly Earnings") label(2 "Forecast") label(3 "95% Upper Bound") label(4 "95% Lower Bound") ) title(" Average Weekly Earnings" "One Month Ahead Normal Forecast") note("1) All forecasts are out of sample based on a 96 month rolling window." "2) Inteval based on percentiles +-1.95 RMMSE from the rolling window procedure." "3) Predictors are lags 3, 4, 12, 24 of private employment and lag 4 of the US emp:pop ratio." )

graph export ps5normfcst.emf, replace

list npy nub nlb if date==tm(2021m3)


hist res, frac normal scheme(s1mono)  title(" Average Weekly Earnings Empirical Forecast Error Distribution") xtitle("") note("Private Employment for March For 96 month rolling window forecasts.")
graph export ps5errdist.emf , replace

summ res
gen nres=(res-r(mean))/r(sd)

qnorm nres, scheme(s1mono)  title(" Average Weekly Earnings Quantile-Normal Plot of Forecast Error") xtitle("Inverse Standard Normal of Residual Percentile") ytitle("Residual Z-Score") xlabel(-6(2)4,grid) ylabel(-6(2)4,grid) note("Private Employment for March For 96 month rolling window forecasts.")
graph export ps5qnorm.emf , replace










