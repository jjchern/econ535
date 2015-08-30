clear
set more off

sysuse nlsw88, clear

/* 
1. Linear Prediction Plots with CIs
We will make two graphs of prediction confidence
interval, one for typical persons and one for specific
persons. 
*/

drop if wage == . | grade == .
qui reg wage grade
twoway (lfitci wage grade, stdp) (sc wage grade) 
twoway (lfitci wage grade, stdf) (sc wage grade) 

/*
2. Prediction Intervals
In this part we make prediction intervals by
creating a lower bound and upper bound, plus or minus
2 standard errors. It would give an approximation of 95%
confidence interval.
*/

qui reg wage grade

predict wagehat, xb
predict SEtypical, stdp
predict SEspecific, stdf
list grade wagehat SEtypical SEspecific in 5

generate Ltypical = wagehat - 2 * SEtypical
generate Htypical = wagehat + 2 * SEtypical
generate Lspecific = wagehat - 2 * SEspecific
generate Hspecific = wagehat + 2 * SEspecific
list wage grade wagehat ///
     Ltypical Htypical ///
     Lspecific Hspecific in 5

/* 
3. Another prediction interval for multivariate regression
Finally, let's use Stata's old `adjust` coomand to
get a nice table of confidence interval for the conditional
expectation function and a graph.
*/

gen exp2 = ttl_exp^2
qui reg wage grade ttl_exp exp2

preserve
adjust ttl_exp exp2, by(grade) xb se ci replace
tw (rarea lb ub grade, sort) ///
   (line xb grade, sort), legend(off)
restore
