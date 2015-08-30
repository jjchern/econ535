clear
set more off
cd "/Users/chan/Documents/Econ 534/"

* load the data

sysuse nlsw88 // national longitudinal survey of women

* get to know the data

describe
browse
summarize
twoway scatter wage grade 

* generate new variables

gen lnwage = ln(wage) // generate dep var
gen expr = age - grade - 6 // generate experience
gen expr2 = expr * expr // generate expr squared
tab race, gen(racedum) // generate race dummies

local controls "racedum1 racedum2 married smsa" 

* run regressions and make a table
* ssc install estout
eststo: reg lnwage grade expr expr2, reststo: reg lnwage grade expr expr2 `controls', resttab, se(3) b(3) r2 ar2 ///
  varlabels(_cons Constant) ///
  ti("The Mincer Regressions") 
