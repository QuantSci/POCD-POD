* a1-105-call-source.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
* -------------------
* call data from source files
* (and process minimally in this file)

* old path to frozen files  <- P:\POSTED\DATA\DERIVED\clean\frozenfiles\freeze10312016\


***cap confirm file w105-r.dta
***if _rc~=0 {
   * Charlson
   use "$frozenfiles/SAGES-Medical-Record-Data-Analysis-File.dta" , clear
   keep studyid vdcci* op04a op04b op04c
   tempfile charlson
   replace studyid=trim(studyid)
   sort studyid
   save `charlson', replace
   
   *surgery vars (added 20180925)
   use "S:\sages\POSTED\DATA\DERIVED\clean\frozenfiles\freeze10312016\SAGES-Medical-Record-Data-Analysis-File.dta" , clear
   keep studyid op01 op04a-op10 inop01 dosdate			
   tempfile surgvars  
		*add descriptors
			   label var op01 "Total Intra-Operative Complications"
			   label var op05 "Anesthesia induction start time (military time)"
			   label var op06 "Surgery start time (military  time)"
			   label var op07 "Surgery stop time (military time)"
			   label var op08 "Anesthesia induction finish time (military time)"
			   label var op09 "Total Intra-operative Fluid Input (cc"
			   label var op10 "Estimated Blood Loss (EBL) (cc)"
			   label var inop01 "Intraoperative complications? (1=yes, 2=no)"
			   label var dosdate "Date of index surgery"
   replace studyid=trim(studyid)
   sort studyid
   merge 1:1 studyid using `charlson'
   cap drop _merge
   save `surgvars', replace

   use "$frozenfiles/SAGES-Proxy-Interview-Data-Analysis-File.dta" , clear
   keep if timefr==0 & regexm(studyid,"ND")==0
   keep studyid vdiqc
   rename vdiqc vdiqc_proxy
   replace studyid=trim(studyid)
   sort studyid
   merge 1:1 studyid using `surgvars'
   cap drop _merge
   tempfile proxy
   save `proxy', replace

   use "$frozenfiles/SAGES-Subject-Interview-Data-Analysis-File.dta", clear
   #d ;
   foreach x in 
      vdeduc_r
      wtar01 
      vdcasall 
      vdp4occf3
      vdp4occf4
      vdhcm
      mriicv_fsman 
      vdbpv_spm8 
      vdbtf_fs
      vdmlta_metmins
	   { ;
      local reservevars "`reservevars' `x'" ;
   } ;
   foreach x in  // date, date_su, and dspo_ccbl added 11/8/18
      vdfemale 
      vdagesurg
	  date 
	  date_su 
      vdnonwhite 
      vdesl 
      vdsurg 
      vd3ms
      vdgcp 
      vdgds15 
      vdsf12pcs
	  dispo_ccbl { ; 
      local covsare "`covsare' `x'" ;
   } ;
   #d cr

   * add descriptors
   clonevar marstat=mar01
   replace marstat=liv01 if marstat==.
   la var marstat "Marital status"

   la var vdadlany "Any ADL Impairment"
   local descvars "marstat vdiadlany vdadlany "

   local npvarsare "vdhvlt vdhvdel vdtrailb vdtrailb_err vdvsat vdbnttot vdrbans vddstotal vdcat vdcowat"

   keep studyid timefr `covsare' `reservevars' `descvars' vddrisk* `npvarsare'
   sort studyid timefr

   drop if trim(studyid)==""|timefr==.
   cap drop _merge
   merge m:1 studyid using `proxy' 
   cap drop _merge
   
   preserve
   use "$frozenfiles/SAGES-Delirium-Assessments-Analysis-File.dta" , clear
   keep studyid vdsagesdeliriumever
   local foo : var lab vdsagesdeliriumever
   collapse (max) vdsagesdeliriumever , by(studyid)
   la var vdsagesdeliriumever "`foo'"
   replace vdsagesdeliriumever=999 if substr(lower(trim(studyid)),1,1)=="n"
   keep studyid vdsagesdeliriumever
   tempfile del
   save `del'
   restore
   
   cap drop _merge
   merge m:1 studyid using `del' 
   cap drop _merge
   replace vdsagesdeliriumever=999 if substr(lower(trim(studyid)),1,1)=="n"
   table vdsagesdeliriumever timefr 
   save w105-r.dta , replace
   
****}

foreach x in covsare reservevars descvars npvarsare {
   di "local `x' %``x''%"
}



