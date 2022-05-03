
* a1-120-select-cases-for-analysis.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
* -------------------
***
***cap confirm file w120-r.dta
***if _rc~=0 {
  use w105-r.dta, clear
  keep if timefr<=6
  keep if vdsagesdeliriumever~=. 
  cap drop merge
  *merge m:1 studyid using $frozenfiles/N560.dta 
  *keep if _merge==3 | substr(lower(studyid),1,1)=="n"
  drop if dispo_ccbl==2
  *drop _merge
  save w120-r.dta , replace
*** }


*amr 11/8/18 -- need to add this so dementia patients aren't included 

*foreach dem in SD002290 SD002858 SW000107 SW003059 SW003246 SW003277 {
*	drop if studyid=="`dem'"
*}
