* a1-420-table1.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
* -------------------

local tab1varsare "vdagesurg vdfemale marstat vdnonwhite vdesl vdeduc_r edcat "
local tab1varsare "`tab1varsare' vdadlany vdiadlany vdmlta_metmins vdsf12pcs vdgds15 "
local tab1varsare "`tab1varsare' vddrisk93_1 vddrisk93_2 vddrisk93_3 vddrisk93_4 vddriskgroup "
local tab1varsare "`tab1varsare' vdsurg vdanesth vdcci "
local tab1varsare "`tab1varsare' vd3ms vdgcp vdiqc_ge vdiqc_proxy"
local tab1varsare "`tab1varsare' vdbtf_fs "
local tab1varsare "`tab1varsare' vdanesth bloodloss surgdurmin anesthdurmin "
local tab1varsare "`tab1varsare' basetov1 basetov2 basetov6 "

*** POCD at two months
use w2072.dta , clear
sort studyid 
tempfile mi
save `mi',replace

use w205.dta,clear
su vdsagesdeliriumever
recode vdsagesdeliriumever (`r(max)'=1) (nonm=0) 
clonevar delirium=vdsagesdeliriumever 
keep studyid `tab1varsare' delirium
sort studyid
merge 1:m studyid using `mi'
keep if _merge==3

qui tab _mi_m if _mi_m==0
local n=`r(N)'
local N=_N
local iw=`n'/`N'

gen     pod_pocd=0 if delirium==0 & pocd==0
replace pod_pocd=1 if delirium==1 & pocd==0
replace pod_pocd=2 if delirium==0 & pocd==1
replace pod_pocd=3 if delirium==1 & pocd==1
lab define podd 0 "No POD No POCD" 1 "POD Only" 2 "POCD Only" 3 "POD*POCD"
lab values pod_pocd podd

tex \clearpage
tex \addcontentsline{toc}{section}{Table 1}
tab1alt `tab1varsare' [iweight=`iw'],  by(pod_pocd) num(`++t')  ///
   title(Participant sociodemographic and clinical characteristics by POD and POCD) ///
   p(p{5cm}) scriptsize 



* have a nice day
