* a1-110-create-variables.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
*

use w120-r.dta , replace
cap erase w130-r.dta
cap confirm file w130-r.dta

if _rc~=0 {
   local covsare "vdfemale vdagesurg vdnonwhite vdesl vdsurg vd3ms vdgcp vdgds15 vdsf12pcs"
   local reservevars "vdeduc_r wtar01 vdcasall vdp4occf3 vdp4occf4 vdhcm mriicv_fsman vdbpv_spm8 vdbtf_fs vdmlta_metmins"
   local descvars "marstat vdiadlany vdadlany vdanesth"
   local npvarsare "vdhvlt vdhvdel vdtrailb vdtrailb_err vdvsat vdbnttot vdrbans"

   * labels 
   vlabel vdfemale Men Women
   vlabel vdnonwhite White "All other race and ethnicity groups"
   vlabel vdesl "English as first language" "English not first language"
   lab var vdp4occf3 "Occupational substantive complexity"
   lab var vdp4occf4 "Occupational management demand"
   cap label define vdsurg 1 "Orthopedic" 2 "Vascular" 3 "Gastrointestinal"
   la values vdsurg vdsurg


   local       vdfemalelab "Sex"
   local      vdagesurglab "Age (years)"
   local     vdnonwhitelab "Race"
   local          vdesllab "English a second language"
   local         vdsurglab "Sugery type"
   local          vdgcplab "General cognitive performance (T)"
   local       vdeduc_rlab "Education (years)"
   local         wtar01lab "Vocabulary (WTAR [0-50])"
   local       vdcasalllab "Cognitive activities score (CAS, z)"
   local      vdp4occf3lab "Occupational substantive complexity (z)"
   local      vdp4occf4lab "Occupational management demand (z)"
   local          vdhcmlab "Head circumfrence (cm)"
   local   mriicv_fsmanlab "Intracranial cavity volume"
   local     vdbpv_spm8lab "Parenchymal volume"
   local     vdbtf_fslab "Brain tissue fraction"
   local vdmlta_metminslab "Activity level (MLTA, kcal)"
   local vdgds15lab "Geriatric Depression Scale (GDS [0-15])"
   local vdsf12pcs "Physical Component Summary Score (MOS SF-12 PCS, [0-100])"
   
      *added 20180925
   
   		*VDS code for anesthesia type
			gen     vdanesth=1 if op04a==1 & op04b==2 
			replace vdanesth=2 if op04a==2 & op04b==1
			replace vdanesth=3 if op04a==1 & op04b==1
			replace vdanesth=2 if op04c==1 & op04a==2 & op04b==2
			label var vdanesth "Anesthesia type"
			label define labvdanesth 1 "General alone" 2 "Spinal alone" 3 "General and Spinal" 
			label values vdanesth labvdanesth
			drop op04a-op04c
		
		*rename blood loss
			rename op10 bloodloss
		
		*Date of surgery
			generate surgdate=date([dosdate],"YMD")
			 format surgdate %td
			 
		*Fix one participant that end end times not in military time
			replace op07  = "14:45" if studyid=="SW003197"
			replace op08  = "15:00" if studyid=="SW003197"
			
		*Surgery duration
			gen double surgstarttime = clock(op06, "hm")
			format surgstarttime %tc
			gen double surgendtime = clock(op07, "hm")
			format surgendtime %tc
			gen surgdurmin = hours(surgendtime - surgstarttime)*60
			format surgdurmin %9.3f
			label var surgdurmin "Duration of Surgery (minutes)"

		*Anesthesia duration
			gen double anesthstarttime = clock(op05, "hm")
			format anesthstarttime %tc
			gen double anesthendtime = clock(op08, "hm")
			format anesthendtime %tc
			gen anesthdurmin = hours(anesthendtime - anesthstarttime)*60
			format anesthdurmin %9.3f
			label var anesthdurmin "Duration of Anesthesia (minutes)" 
		
		*Recode intraop complications 
			gen intraopcomp = 0 if inop01==2
			replace intraopcomp = 1 if inop01==1
			
		*Calculate average (or median IQR) for time since surgery at visit 1, 2, 6
			*Note: age at each visit (vdage) missing for some reason in a ton of people
			cap drop arid
			encode studyid, gen(arid)
			xtset arid timefr
			xfill date_su, i(arid)
			foreach visit in 1 2 6 {
				cap drop basetov`visit'
				gen basetov`visit' = (date - date_su) if timefr==`visit'
				xfill basetov`visit', i(arid) 
				replace basetov`visit'=. if timefr>0
				label var basetov`visit' "Days from baseline to Visit `visit'"
			}
			summ basetov* if timefr==0, det
			summ basetov* if timefr==0
			replace vdagesurg=. if timefr>0

   recode vdeduc_r (0/11=1) (12=2) (13/15=3) (16=4) (17/max=5) , gen(edcat)
   la def edcat ///
      1 "Less than high school" ///
      2 "High school graduate" ///
      3 "Some college" ///
      4 "Four years of college" ///
      5 "More than four years of college"
   la values edcat edcat

   local descvars "edcat `descvars' vdcci vdcci_cat"   

   foreach x in `covsare' `reservevars' `descvars' {
   if "``x'lab'"~="" {
      la var `x' "``x'lab'"
   }
   cap la values `x' `x'
   }

   la def marstat ///
      1 "Never married" ///
      2 "Married or living with partner" ///
      3 "Widowed" ///
      4 "Divorced" ///
      5 "Separated"
   la values marstat marstat

   la def noyes 0 "No" 1 "Yes"
   la values vdadlany noyes
   la values vdiadlany noyes

   * add jitter to vdcci for tab1alt to force continuous
   replace vdcci=vdcci+uniform()/1000
   
   la def vdcci_cat 0 "0" 1 "1" 2 "2 or more"
   la values vdcci_cat vdcci_cat

   la var edcat "Education level"
   
   gen vdiqc_ge=(vdiqc_proxy>3.2)
   replace vdiqc_ge=. if vdiqc_proxy==.
   la var vdiqc_ge "Proxy IQCODE Impairment [$>$3.2]"
   la values vdiqc_ge noyes
   la var vdiqc_proxy "Proxy IQCODE"

   local tab1varsare "vdagesurg vdnonwhite marstat edcat vdesl "
   local tab1varsare "`tab1varsare' vdsurg vdcci vdcci_cat "
   local tab1varsare "`tab1varsare' vdgds15 vdsf12pcs vdanesth"
   local tab1varsare "`tab1varsare' vdiadlany vdadlany vdgcp vdiqc_ge vdiqc_proxy"
   local tab1varsare "`tab1varsare' vdanesth bloodloss surgdurmin anesthdurmin"
   local tab1varsare "`tab1varsare' basetov1 basetov2 basetov6"
   local reservevars "vdeduc_r wtar01 vdcasall vdp4occf3 vdp4occf4 vdhcm mriicv_fsman vdbpv_spm8 vdbtf_fs vdmlta_metmins"
   
   save w130-r.dta , replace
   
}

* have a nice day








   
