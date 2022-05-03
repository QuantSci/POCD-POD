*Annie Racine
*September 26, 2018
*POCD reviewer comment: what is the concordance/discordance between those who met POCD critiera at visit 1 vs. 2 vs. 3

*cd s:\sages\projects\pocd_copy2\posted\analysis

tex \newpage
tex \section{SIMPLE cross-tabs of delirium and POCD}

tex In this section, we do crosstabs using the "pocd" variable
tex instead of additional multiple imputation

texdoc stlog 

*** basic cross tabs of delirium and POCD

*pocd and delirium cross-tabs at 1 month
use w1311.dta, replace
del
tab pocd vdsagesdeliriumever

*pocd and delirium cross-tabs at 2 month
use w1312.dta, replace
del
tab pocd vdsagesdeliriumever

*pocd and delirium cross-tabs at 6 month
use w1316.dta, replace
del
tab pocd vdsagesdeliriumever

texdoc stlog close

program drop del

tex \newpage
tex \section{Concordance of POCD from months 1 to 2 to 6}

tex In this section, we examine the number of people who have POCD at both 
tex 1 month and 2 months, or POCD at all 3 time points (1, 2, and 6 months). 
tex Next we test if those individuals with persistent POCD for either 1 and 2 months
tex or 1, 2, and 6 months were more likely to have been delirious in the hospital. 
tex \\[0.5cm]

foreach month in 1 2 6 {
	use w131`month'.dta, replace
	rename pocd pocd_`month'm
	save w131`month'_amr.dta , replace
}

use w1311_amr.dta, clear

merge m:1 studyid timefr using w1312_amr.dta
cap drop _merge
merge m:1 studyid timefr using w1316_amr.dta
cap drop _merge

label var pocd_1m "POCD at 1 month"
label var pocd_2m "POCD at 2 month"
label var pocd_6m "POCD at 6 month"

table timefr , c(n pocd_1m n pocd_2m n pocd_6m)

cap drop arid
encode studyid, gen(arid)
xtset arid timefr

xfill pocd_1m, i(arid)
xfill pocd_2m, i(arid)
xfill pocd_6m, i(arid)

replace pocd_1m=. if timefr>0
replace pocd_2m=. if timefr>0
replace pocd_6m=. if timefr>0

table timefr , c(n pocd_1m n pocd_2m n pocd_6m)

*create variable for people with pocd at 1 month also have pocd at 2 months

freq pocd_1m if timefr==0
freq pocd_1m if pocd_6m!=. & timefr==0

gen pocd_1and2 = 0 if pocd_1m!=.
*replace pocd_1and2 = 1 if pocd_1m==1 & pocd_2m==. // do this if Sharon needs denominator same as at 1 month?
replace pocd_1and2 = 1 if pocd_1m==1 & pocd_2m==1
label var pocd_1and2 "Persistant POCD at months 1 and 2"

*create variable for  people with pocd at 1 month who also have pocd at 2 months alsohave pocd at 6 months

gen pocd_1and2and6 = 0 if pocd_1m!=.
replace pocd_1and2and6 = 1 if pocd_1m==1 & pocd_2m==. & pocd_6m==.
*replace pocd_1and2and6 = 1 if pocd_1m==1 & pocd_2m==1 & pocd_6m==. // do this if Sharon needs denominator same as at 1 month?
*replace pocd_1and2and6 = 1 if pocd_1m==1 & pocd_2m==1 & pocd_6m==1 // do this if Sharon needs denominator same as at 1 month?
label var pocd_1and2and6 "Persistant POCD at months 1, 2, and 6"

*vdsagesdelirium -- broken into subsyndromal 
cap program drop del
program del 
	replace vdsagesdelirium=0 if vdsagesdelirium==1
	replace vdsagesdelirium=1 if vdsagesdelirium==2
end

*how many people with pocd at 1 month who also have pocd at 2 months alsohave pocd at 6 months

texdoc stlog 

freq pocd_1and2 
freq pocd_1and2 if pocd_2m!=.
freq pocd_1and2 if pocd_2m!=. & pocd_6m!=.

freq pocd_1and2and6
freq pocd_1and2and6 if pocd_2m!=. & pocd_6m!=.

tab pocd_1and2 vdsagesdeliriumever , chi2
tab pocd_1and2and6 vdsagesdeliriumever , chi2

*** restricting to patients who completed all 3 months assessment

tab pocd_1and2 vdsagesdeliriumever if pocd_2m!=. & pocd_6m!=. , chi2
tab pocd_1and2and6 vdsagesdeliriumever if pocd_2m!=. & pocd_6m!=. , chi2

texdoc stlog close

tex \newpage
tex \section{Cross-tabs of POCD at months 1, 2, and 6}

texdoc stlog 

*** cross-tabs 

*concordance of POCD at months 1 and 2
tab pocd_1m pocd_2m if timefr==0

*concordance of POCD at months 1 and 6 
tab pocd_1m pocd_6m if timefr==0

*concordance of POCD at months 2 and 6 
tab pocd_2m pocd_6m if timefr==0

texdoc stlog close











