***********************************************
* Econ 534: W10, Fall 2014
* The purpose this do-file is to introduce
* some commands that might be useful for your
* problem set. These are all simple examples
* for illustration, so don't take these regressions
* too seriously. You can read documents for these 
* commands for details if you are using Stata to do 
* your homework.
************************************************

clear
set more off
set showbaselevels on, permanently
sysuse nlsw88, clear
codebook, compact

* 0. Some categorical variables

tab race 
tab industry
tab occupation

* 1. The magins and marginsplot command

reg wage i.married, nohe
margins married // it gives the average wage of married and unmarried in the sample
marginsplot

reg wage i.race, nohe
margins race
marginsplot, recast(scatter)

* 2. Categorical variable: i. operator

* (1) use i. operator read the data
su i.race i.industry i.occupation
l race i.race in 1/52

* 1b.race is the based level, by default asssigned to the
* smallest value. In regression, the based group would
* be omitted.

* (2) use i. operator to generate dummy varibales
xi i.race, noomit
su _I*

* 3. Interaction: # and ## operators

su i.race#married //note that one group is omitted 
reg wage i.race married i.race#married, nohe

* (1) categorical with categorical variable

reg wage i.race i.industry i.race#i.industry, nohe
reg wage i.race##i.industry, nohe 

* (2) categorical with continous variable

reg wage i.race grade i.race#c.grade, nohe
reg wage i.race##c.grade, nohe

* (3) a quadratic term in age

qui gen age2 = age * age
reg wage collgrad age age2, nohe

reg wage i.collgrad c.age c.age#c.age, nohe
margins, dydx(collgrad age) // we can then use margins

** Q: What's the average wage for a woman aged 40 (in this sample),
** all other things (here is just collgrad) being equal?

** One answer: average predictive margins
** (Why average? We hold collgrad constant at its mean.)
margins, at(age == 40)

** Q: How (average) earnings change by women's age?
qui margins, at(age == (30 (3) 45) )
marginsplot

** Q: How would a college degree interact with age?
qui margins collgrad, at(age == (30 (3) 45))
marginsplot

