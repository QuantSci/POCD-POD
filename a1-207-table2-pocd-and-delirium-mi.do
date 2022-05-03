* a1-205-table1.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
* -------------------

tex \newpage
tex \section{Post-operative delirium and POCD - Multiple Imputation}
tex In this section, we take each of the 10 different ways in which
tex we could have constructed our set of 7 neuropsychological tests
tex taking 2 from 5 ambiguously matched tests to R\&S04 and 
tex generate 10 versions of POCD. Each of the 10 is taken as one of 
tex a possible imputation of POCD, and the data are analyzed
tex as if they were generated from a multiple imputation
tex algorithm.\\[0.5cm]

foreach month in 1 2 6 {
   
   tex \newpage
   tex \subsection{Month `month' computations}
   
   
   **** tex Call up the month-specific data file created in command file \verb+131+.
   **** tex make doubly sure it includes only the baseline and target month
   use w131`month'.dta if inlist(timefr,0,`month') & substr(lower(trim(studyid)),1,1)~="n"  , clear
   
   **** tex Generate a new variable \verb+ssdever+ that identifies people who were
   **** tex ever with subsyndromal delirium, and define a delirium outcome that is 1
   **** tex if the delirium VDS indicates delirium (it is coded 0 no, 
   **** tex 1 subsyndromal, 2 delirium) and 0 if otherwise nonmissing
   **** tex as \verb+delirium+
   *** **** texdoc stlog // 2
   gen ssdever=vdsagesdeliriumever==1
   gen delirium=vdsagesdeliriumever==2 if inlist(vdsagesdeliriumever,0,1,2)
   *** **** texdoc stlog close

   **** tex Forward fill (using \verb+xtfill+) covaraites
   **** tex and backwards fill post-operative cognitive decline.
   **** tex Carry backwards puts the pocd outcome at 1 month
   **** tex on the same row as baseline data. 
   **** texdoc stlog // 3
   xtset , clear
   egen rnjid=group(studyid)
   gen vdgcp0=vdgcp if timefr==0
   xfill vdgcp0 , i(rnjid)
   xfill edcat , i(rnjid)
   xfill vddriskgroup , i(rnjid)
   xfill vdcci_cat , i(rnjid)
   xfill pocd*
   xtset , clear
   **** texdoc stlog close
   
   **** tex Now, we convince Stata that pocd0-pocd9 are
   **** tex imputed values for pocd. We rename pocd0 as pocd10
   **** tex because the 10th version is the main (rationally considered)
   **** tex version. When we treat these as multiply imputed versions
   **** tex of POCD, Stata will (with proper encouragement) estimate model
   **** tex parameters over all imputations and combine the results.
   **** texdoc stlog // 4
   cap mi set , clear
   gen pocd10=pocd0 
   drop pocd
   **** texdoc stlog close
   
   **** tex Now we can limit to the baseline data because we
   **** tex have carried back the POCD outcome. We'll expand
   **** tex (reshape as long) the data set to have each
   **** tex "imputed" outcome appear on a separate line.
   **** texdoc stlog // 5
   keep if timefr==0
   keep pocd* delirium  studyid 
   reshape long pocd , i(studyid) j(_mj)
   **** texdoc stlog close

   
   **** tex Listwise complete restriction. Because
   **** tex Stata will look for all data sets used in the 
   **** tex multiple imputation estimation to be the same
   **** tex except for the imputed values, I must 
   **** tex carry out a listwise complete restriction on
   **** tex the predictor (SAGES delirium) and outcome
   **** tex (POCD). 
   ********* **** texdoc stlog ,    nocmdstrip  
   foreach y in pocd delirium {
      qui levelsof studyid if pocd==. , clean
      foreach x in `r(levels)' {
         qui drop if studyid=="`x'"
      }
   }
   ********* **** texdoc stlog close

   **** tex More instructions for convincing Stata the data were
   **** tex imputed using ICE: I have to create some
   **** tex ICE-specific variables that describe
   **** tex the imputations. 
   **** texdoc stlog
   egen _mi = group(studyid)
   mi import ice , automatic clear
   **** texdoc stlog close
  
   
   
   **** tex {\bf Results computations}\\
   **** tex Multiple imputation estimate of effect of 
   **** tex post-operative delirium on post-operative
   **** tex cognitive decline. Please note these are 
   **** tex non-exponentiated coefficients.
   **** texdoc stlog
   mi estimate: glm pocd delirium , fam(poisson) link(log) nolog vce(robust) 
   mat b=e(b_mi)
   mat V=e(V_mi)
   local ll : di %4.2f exp(b[1,1]-1.96*sqrt(V[1,1]))      // WANT TO REPORT FOR TABLE
   local ul : di %4.2f exp(b[1,1]+1.96*sqrt(V[1,1]))      // WANT TO REPORT FOR TABLE
   local pemi : di %4.2f exp(b[1,1])                        // WANT TO REPORT FOR TABLE
   ztestr , est(b[1,1]) se(sqrt(V[1,1]))
   local pmi  : di %4.3f `r(p)'
   **** texdoc stlog close
   
   **** tex From the above we have the risk ratio (`pemi') and confidence interval (`ll',`ul') and
   **** tex significance level (`pemi') that describes the association of POD and POCD **** tex at 
   **** tex `month' month follow-up. This estimate is obtained over all 10 "imputed" definitions
   **** tex of POCD.\\[0.5cm]
   
   **** tex Now we'll get the estimates we need to generate a \(2\times2\) table for 
   **** tex POCD \(\times\) POD. We will use logistic regression to estimate the
   **** tex proportion in each cell of the \(2\times2\) table, where the logistic
   **** tex regression model is estimated using (and respecting) the "imputed"
   **** tex data. I run a separate logistic regression model for each
   **** tex cell of the \(2\times2\) table and use the constant (intercept)
   **** tex term to compute the proportion using the inverse logit transformation.
   
   
   mi estimate : logit pocd
   mat b`month'=e(b_mi)
   local pPOCD`month' : di %6.3f invlogit(b`month'[1,1])  // WANT TO REPORT FOR TABLE
   mi estimate : logit delirium
   mat b`month'=e(b_mi)
   local pDEL`month' : di %6.3f invlogit(b`month'[1,1])
   mi estimate : logit pocd delirium
   mat b`month'=e(b_mi)
   local pPOCD1DEL1`month' : di %6.3f invlogit(b`month'[1,2]+b`month'[1,1])
   local qDEL`month' : di %8.3f  1-`pDEL`month''
   local qPOCD`month' : di %8.3f  1-`pPOCD`month''
   local d`month' : di %8.3f `pPOCD1DEL1`month''*`pDEL`month''
   local b`month' : di %8.3f `pPOCD`month''-`d`month''
   local c`month' : di %8.3f `pDEL`month''-`d`month''
   local a`month' : di %8.3f 1-(`d`month''+`b`month''+`c`month'')
   
   qui {
      noisily {
         di _col(10)    "POCD=0" _col(20) "POCD=1" _n ///
            "  DEL=0" _col(10) `a`month'' _col(20) `b`month'' _n ///
            "  DEL=1" _col(10) `c`month'' _col(20) `d`month''
      }
   }
   
   **** tex With the proportions in each cell of the \(2\times2\) table
   **** tex known, I can compute some things like the
   **** tex kappa coefficient. Since these are proportions
   **** tex estimated from the "imputed" data, the estimated
   **** tex kappas also reflect the "imputed" data.
   **** texdoc stlog
   local po=`a`month''+`d`month''
   local pe = ((`a`month''+`b`month'')*(`a`month''+`c`month'')) ///
      + ((`c`month''+`d`month'')*(`b`month''+`d`month'')) 
   local kappami`month' : di %4.2f (`po'-`pe')/(1-`pe')     // WANT THIS FOR TABLE 3
   **** texdoc stlog close
   
   **** tex The tetrachoric is estimated with the Stata function \verb+polychoric+ which does
   **** tex not handle multiply imputed data. I could use Mplus software to get a
   **** tex tetrachoric correlation estimate that respected the "multiply imputed"
   **** tex data but I don't think it is that important.
   **** texdoc stlog
   sort _mi_m
   gen rtet=.
   forvalues i=1/10 {
      polychoric delirium pocd if _mi_m==`i'
      local rtet`i'`month' : di %4.2f `r(rho)'
      replace rtet=`rtet`i'`month'' in `i'
   }
   su rtet , detail
   local rtetmed`month' : di %4.2f `r(p50)' // median tetrachoric
   di `rtetmed`month''
   foreach x in min max {
      local `x'rtet`month'=`x'(`rtet1`month'',`rtet2`month'',`rtet3`month'',`rtet4`month'',`rtet5`month'',`rtet6`month'',`rtet7`month'',`rtet8`month'',`rtet9`month'',`rtet10`month'')
   }
   **** texdoc stlog close

   mf {\bf Results (month `month')}
   
   mf The (tetrachoric) correlation between POCD and
   mf POD at month `month' had a range of `minrtet`month'' - `maxrtet`month'' over 10 test combinations,
   mf and a median value of `rtetmed`month''). 


   foreach x in **** tex mf {
      `x' Below is the implied cross-tab of POCD and post-operative
      `x' delirium from the multiply-imputed data (cell entries are
      `x' proportions) at month `month':
      `x' \begin{center}
      `x' \begin{tabular}{l |c |c |l}
      `x' & \multicolumn{2}{c}{POCD}\\
      `x' Delirium & No & Yes & Total \\
      `x' \hline
      `x' No & `a`month'' & `b`month'' & `qDEL`month'' \\
      `x' Yes & `c`month'' & `d`month'' & `pDEL`month'' \\
      `x' \hline
      `x' Total & `qPOCD`month'' & `pPOCD`month'' & 1.000 \\
      `x' \hline
      `x' \end{tabular}
      `x' \end{center}
   }

   save w207`month'.dta , replace
   use w207`month'.dta , clear

   ***** tex \newpage
   tex \begin{center}
   tex {\bf Table `++t'}\\
   tex {\bf Different ways of composing neuropsychological test battery to define }\\
   tex {\bf POCD and summary statistics capturing association and agreement }\\
   tex {\bf with post-operative delirium. SAGES study, month `month'.}\\[0.25cm]
   tex \begin{tabular}{p{7cm}rrrrr}
   tex {\bf Component neuropsychological tests} &
   tex {\bf P(POCD)} &
   tex {\bf R } &
   tex {\(\boldsymbol{\kappa}\)} &
   tex {\bf RR (95\% CI)} &
   tex {\bf p-value} \\
   tex \hline
   foreach i in 4 8 7 1 6 9 5 10 2 3 {
      tex `testsare`i'' &
      su pocd if _mi_m==`i'
      local foo : di %5.2f `r(mean)'
      tex `foo' &
      tex `rtet`i'`month'' & 
      qui kap pocd delirium if _mi_m==`i'
      local kap`i'`month' : di %5.2f `r(kappa)' 
      tex `kap`i'`month'' & 
      glm pocd delirium if _mi_m==`i' , fam(poisson) link(log) nolog vce(robust) 
      mat b=e(b)
      mat V=e(V)
      local rr`i'`month' : di %4.2f exp(b[1,1])
	   local ll`i'`month' : di %4.2f exp(b[1,1]-1.96*sqrt(V[1,1]))
      local ul`i'`month' : di %4.2f exp(b[1,1]+1.96*sqrt(V[1,1]))
      local p`i'`month'  : di %4.3f 2*normal(-abs(b[1,1]/sqrt(V[1,1])))
  
      tex `rr`i'`month'' (`ll`i'`month'' - `ul`i'`month'') & `p`i'`month'' \\
   }
   
   
   local pemi  : di %4.2f `pemi' 
   local pPOCD`month' : di %4.2f `pPOCD`month''
   
   tex Overall & 
   tex   `pPOCD`month'' &
   tex   `rtetmed`month'' &
   tex   `kappami`month'' &
   tex   `pemi' (`ll' - `ul') &
   tex   `pmi' \\

   foreach x in min max {
      local `x'kap`month'=`x'(`kap1`month'',`kap2`month'',`kap3`month'',`kap4`month'',`kap5`month'',`kap6`month'',`kap7`month'',`kap8`month'',`kap9`month'',`kap10`month'')
   }

   mf At month `month' the agreement of POCD and POD ranged from \(\kappa=\)`minkap`month'' to \(\kappa=\)`maxkap`month''
   mf across the 10 imputations of POCD. 
   mf (Remember that values less than 0.20 fall 
   mf in the "poor" agreement range of Landis and Koch (1977)).\\[0.25cm]

   *mf \begin{description}
   *mf \item[{\bf Finding}] POD and POCD do not overlap much
   *mf \bi
   *mf \item POD is a risk factor for POCD, and POD and POCD are positively correlated
   *mf       but the strength of the association is weak
   *mf \item The strength of association varies considerably according to how POCD is
   *mf       defined (which neuropsychological tests are used to operationalize POCD)
   *mf       but is, however defined, not a strong association.
   *mf \ei
   *mf \end{description}

   tex \hline
   tex \multicolumn{6}{p{15cm}}{\footnotesize{Notes: P(POCD), prevalence of post-operative
   tex cognitive decline; R, \(\boldsymbol{\kappa}\) 
   tex and RR are
   tex the  tetrachoric correlation, kappa coefficient, and relative risk
   tex respectively, 
   tex for post-operative cognitive decline and (or given) post-operative delirium,
   forvalues i=5/9 {
      tex `nbcall`i'', `nbname`i'';
   }
   tex `nbcall10', `nbname10'.
   tex {\bf All versions include } the following tests: 
   tex `nbname1', 
   tex `nbname2',
   tex `nbname3',
   tex `nbname4'.}}
   tex \end{tabular}
   tex \end{center}

   
}
