***********************************************
* Econ 534: W11, Fall 2014
* The purpose this do-file is to compared chi-sq
* distribution with F distribution based on 
* its density plot. Most of the
* inference in today's applied works rely on
* large sample theory, thus it would be helpful
* to "see" these distributions. 
************************************************

clear
set more off

* O. Let's define J: # of restrictions; n: sample size; k: # of regressors

scalar J = 8
scalar n = 10000
scalar k = 5

* 1. Draw some random numbers from chisq(J)

set seed 52563
set obs 10000

gen chisq_J = rchi2(J)
su chisq_J // Note that E(chisq(8)) = 8 and Var(chisq(8)) = 2*8 = 16

* 2. Create some random numbers that follow F(J, n-k)

scalar m = n - k
gen F_J_m = (rchi2(J)/J) / (rchi2(m)/m)

* 3. Recall the asymptotic relationship between chisq and F

gen J_times_F_J_m = J * F_J_m
su J_times_F_J_m chisq_J // E and Var look very similar

* 4. Plot the density

kdensity chisq_J, addplot(kdensity J_times_F_J_m) // they are almost the same
