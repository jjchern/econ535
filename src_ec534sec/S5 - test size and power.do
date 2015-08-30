cap end
clear
set more off
cd "/Users/chan/Google Drive/Econ 534 Fall 2014/"

* In this week's session, we will use simulation to 
* see test size and test power. The first goal is this
* exercise is to capture the idea of test size and power,
* and the second goal is to review the tool of simulation
* we covered in last session.

****************
* 1 test command
****************

* To begin with, let's take a look at Stata's test command:

sysuse nlsw88
reg wage grade race union

test grade
test (race) (union + grade = 1) // just an meaningless test
test grade race union // overall test 

* The meaningless test actually tells something

*****************
* 2 test size
*****************

* The size of a test is the probability 
* of falsely rejecting the null hypothesis.

* In this section, we will write some short program to make
* the idea clearer. I would also hard code some paramater,
* which is not a good practice. You will also see why is not
* a good habit to hard code parameters.

* Now let's write a program to generate some data

cap pr drop dgp
pr dgp
    drop _all
    set obs $numobs
    gen x = runiform()
    gen error = rnormal(0,1)
    gen y = 1 + 2*x + error 
end

global numobs 100
dgp
su // check out the data

* Now let's write another problem to see the size

cap pr drop savep
pr savep, rclass
    dgp
    reg y x
    test x = 2
    return scalar p = r(p) 
end

savep
return list

simulate pvalues = r(p), reps(1000) saving(size,replace): savep
use size, replace
count if pvalues < 0.05
dis "Test size from 1000 simulations" r(N) / 1000

*****************
* 3 test power
*****************

* The power of a statistical test is the probability that
* it correctly rejects the null hypothesis when the 
* null hypothesis is false.

cap pr drop savep2 
pr savep2, rclass
    dgp
    reg y x
    test x = 2.2
    return scalar p2 = r(p) 
end

* Hopefully from savep2, you will see the inefficiency of 
* hard coding parameters

savep2
return list

simulate pvalues2 = r(p2), reps(1000) saving(power, replace): savep2
use power, replace
count if pvalues2 < 0.05
dis "Test power from 1000 simulations" r(N) / 1000

******************
* 4 exercise
******************

* try to simplify the code by yourself and try other sample size
* and number of simulations
