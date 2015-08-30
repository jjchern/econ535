cap end
clear
set more off
cd "/Users/chan/Documents/Econ 534/"

* 1. Visualize variance covariance matrix

sysuse nlsw88

* ssc install ellip

// plot the variance ellipse of wage and grade
// ellip wage grade, c(sd 1) plot(sc wage grade) 

// plot the variance ellipse of OLS estimates
reg wage grade ttl_exp
// ellip grade ttl_exp, coefs c(sd 2)

* 2. Assess information stored in Stata

corr wage grade, cov
return list

reg wage grade ttl_exp
return list
ereturn list

dis "R square is " e(r2)
dis "The OLS coefficient on grade and is" _b[grade] 
dis _se[grade]
mat list e(b)

* 3. Variance Covariance matrix

mat list e(V)
estat vce
