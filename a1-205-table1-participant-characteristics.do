* a1-205-table1.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
* -------------------

use w1311.dta , clear

local tab1varsare "vdagesurg vdfemale marstat vdnonwhite vdesl vdeduc_r edcat "
local tab1varsare "`tab1varsare' vdadlany vdiadlany vdmlta_metmins vdsf12pcs vdgds15 "
local tab1varsare "`tab1varsare' vddrisk93_1 vddrisk93_2 vddrisk93_3 vddrisk93_4 vddriskgroup "
local tab1varsare "`tab1varsare' vdsurg vdcci "
local tab1varsare "`tab1varsare' vd3ms vdgcp vdiqc_ge vdiqc_proxy"
local tab1varsare "`tab1varsare' vdbtf_fs vdanesth"

keep if timefr==0
tempfile w
save `w',replace

use w130-r.dta , clear
drop if regexm(studyid,"ND")==1 | timefr==0
duplicates drop studyid,force
keep studyid
merge 1:1 studyid using `w'
keep if _merge==3

save w205.dta,replace


tex \newpage
tex \addcontentsline{toc}{section}{Table 1}
tex \begin{landscape}
tab1alt `tab1varsare' , num(`++t') ///
   title(Participant sociodemographic and clinical characteristics) ///
   scriptsize p(p{10cm})
tex \end{landscape}







* have a nice day



