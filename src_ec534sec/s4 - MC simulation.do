cap end
clear
set more off
cd "/Users/chan/Google Drive/Econ 534 Fall 2014/"

* In this week's session, I will demonstrate 
* a simple Monte Carlo simulation of OLS and check the unbiased
* result. Along the way I will introduce some programming basics
* in Stata. Knowing the basic simulation might be helpful when
* we read things like bootstrape s.e. or simulation-based 
* hypothesis testing in the future. It would also be handy when
* we look at robust s.e. or multicollinearity. 

* 1. Macros: 
* They are just like variable names. 
* We can also use them to store statements, texts, expressions.
* Example:

sysuse nlsw88
local controls ttl_exp south smsa if married == 1
global controls ttl_exp south smsa i.race
reg wage grade `controls' // call for the local controls
reg wage grade $controls // call for the global controls

* 2. Looping
* There are many values to do a loop. 
* For now let's just consider forvalues.
* Example:

forvalues i = 1/5{
  display "Hello"
}


* 3. Monte Carlo simulation using the command `simulate`

* 3.1. Write a Program in Stata:

cap prog drop gendata
pr gendata
  drop _all
  set obs $obs // sample size
  gen double x = runiform()
  gen double error = rnormal(0,1)
  gen double y = 1 + 2*x + error // structual equation
  end

cap prog drop ols
pr ols, rclass
  drop _all
  gendata
  reg y x
  return scalar b =_b[x]
end

* 3.2. Use the program

global obs 50
ols
simulate b = r(b), reps(100): ols

* 3.3. See the Unbiased result
kdensity b, nodraw
su b

* 4. Monte Carlo simulation using the command `postfile`

clear

tempname sim
postfile `sim' b using simdata, replace
  quietly {
    forvalues i = 1/100 {
    drop _all
    set obs 100 // sample size
    gen y = runiform()
    gen error = rnormal(0,1)
    gen y = 1 + 2*x + error // structual equation
    reg y x
    scalar b = _b[x]
    post `sim' (b)
    }
  }
postclose `sim'

use simdata, clear
kdensity b, nodraw
su b
