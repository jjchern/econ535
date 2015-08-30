clear
set more off
cd "/Users/chan/Documents/Econ 534/"

* 1. Partial reg and "holding other var constant"

sysuse nlsw88

reg wage ttl_exp, noheader // bivariate case

reg wage ttl_exp age, nohe // partial effect

qui reg wage age
predict yres, res
qui reg ttl_exp age
predict xres, res // partial out the effect of age
reg yres xres, noconstant nohe // how about `reg wage xres, noc`

* 2. Regression Anatomy: Visualize Partial Effect

* ssc install reganat
reganat wage ttl_exp grade, dis(ttl_exp) biline

* 3. Deviation from means

su wage ttl_exp // check out the means
reg wage, noheader // reg with a constant
predict yres2, res // why `yres2` is the demeaned `wage`
reg ttl_exp, noheader // reg with a constant
predict xres2, res // why `xres2` is the demeaned `ttl_exp`

reg yres2 xres2, noc nohe 
reg wage ttl_exp, nohe // what can you say about the slope coef.