cap end
clear
set more off
cd "/Users/chan/Documents/Econ 534/"

* In this week's session, I will demonstrate 
* a simple Monte Carlo simulation of OLS and check the unbiased
* result. Along the way I will introduce some programming basics
* in Stata. Knowing the basic simulation might be helpful when
* we read things like bootstrape s.e. or simulation-based 
* hypothesis testing in the future.

* 1. Macros: 
* They are just like variable names. 
* We can also use them to store statements, texts, expressions.

sysuse nlsw88
local controls ttl_exp south smsa, if married == 1
global controls ttl_exp south smsa i.race
reg wage grade `controls', r // call for the local controls
reg wage grade $controls, r // call for the global controls

* 2. 
