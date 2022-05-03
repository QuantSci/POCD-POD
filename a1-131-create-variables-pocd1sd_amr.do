* Creat POCD

qui {
   foreach month in 1 2 6 12 {
      use w130-r.dta , clear
      keep if timefr==0|timefr==`month'

      gen pcg=substr(lower(studyid),1,1)=="n"

      * Neuropsyc battery
      * What did Rasmusen & Shersma (2004) use?
      * -- matched - HVLT -- Visual Verbal Learning, Cumulated words
      * -- matched - HVLT -- Visual Verbal Learning, delayed recall
      * -- matched - Trails B Time -- Concept Shifting Test, part C, time
      * -- matched - Trails B Errs -- Concept Shifting Test, part C, errors
      * -- matched - XXXX -- Stroop Colour Word Test, part 3, time
      * -- matched - XXXX -- Stroop Colour Word Test, part 3, errors
      * -- matched - RBANS Digit Symbol Test -- Letter-Digit Coding 

      local nbname1 "Hopkins Verbal Learning Test, Revised (HVLT-R) Sum of learning trials"
      local nbdesc1 "A list of words is read to the participant, who is asked to repeat the list back over multiple learning and delayed recall trials."
      local nbdoma1 "Verbal episodic memory"
      local nbstan1 "Visual verbal learning, cumulated number of words"
      local nbvar1 "vdhvlt"
      local nbcall1 "HVLT (learning total)"

      local nbname2 "HVLT-R Delayed Recall"
      local nbdesc2 "(see above)"
      local nbdoma2 "Verbal episodic memory"
      local nbstan2 "Visual verbal learning, delayed recall"
      local nbvar2 "vdhvdel"
      local nbcall2 "HVLT (delayed recall)"

      local nbname3 "DKEFS Trail Making Test (part B time)"
      local nbdesc3 "The participant must connect a sequence of alternating numbers and letters. Score is time to complete (up to 300 seconds)."
      local nbdoma3 "Executive function, visuospatial function"
      local nbstan3 "Concept Shifting Test, part C, time"
      local nbvar3 "vdtrailb"
      local nbcall3 "Trails-B (time)"

      local nbname4 "DKEFS Trail Making Test (part B errors)"
      local nbdesc4 "(see above). Score is number of errors."
      local nbdoma4 "Executive function, visuospatial function"
      local nbstan4 "Concept Shifting Test, part C, errors"
      local nbvar4 "vdtrailb_err"
      local nbcall4 "Trails-B (errors)"

      local nbname5 "Visual Search and Attention Test (VSAT)"
      local nbdesc5 "Four timed visual cancellation tasks where the participant must cross out letters and symbols that are identical to a target."
      local nbdoma5 "Executive, visuospatial function"
      local nbstan5 "No test in Rasmusen and Siersma (2004) (R\&S04). But, Stroop Color Word Test is R\&S04 (errors and time)"
      local nbvar5 "vdvsat"
      local nbcall5 "VSAT"

      local nbname6 "Boston Naming Test (BNT)"
      local nbdesc6 "The participant is presented with drawings of common objects, which then must be named correctly."
      local nbdoma6 "Confrontation naming, language."
      local nbstan6 "No test in R\&S04. Could also have chosen from category fluency, phonemic fluency, or WAIS Digit Span Forward and Backward, to fill the number of tests to 7. There may be a sensitivity analysis in here."
      local nbvar6 "vdbnttot"
      local nbcall6 "BNT"

      local nbname7 "RBANS Digit Symbol"
      local nbdesc7 "Using a key provided, the participant matches symbols to numbers as quickly as possible while being timed."
      local nbdoma7 "Executive function, visuospatial function."
      local nbstan7 "Letter-Digit Coding."
      local nbvar7 "vdrbans"
      local nbcall7 "Digit Symbol"

      * The first 7 are the best matches
      local nbname8 "WAIS Digit Span Forward and Backward"
      local nbdesc8 "Participants are asked to repeat a string of digits forward and in reverse order."
      local nbdoma8 "Attention"
      local nbstan8 "No matching test in R\&S04"
      local nbvar8  "vddstotal"
      local nbcall8 "Digit Span"

      local nbname9 "Category Fluency"
      local nbdesc9 "The participant must generate as many words as possible from a semantic category (animals)."
      local nbdoma9 "Executive function, semantic memory, language"
      local nbstan9 "No matching test in R\&S04"
      local nbvar9  "vdcat"
      local nbcall9 "Category Fluency"

      local nbname10 "Phonemic Fluency"
      local nbdesc10 "The participant must generate as many words as possible beginning with a given letter over 3 trials (F, A, and S)"
      local nbdoma10 "Executive function, semantic memory, language"
      local nbstan10 "No matching test in R\&S04"
      local nbvar10 "vdcowat"
      local nbcall10 "Phenomic Fluency"

      local allcombs "`nbcall1', `nbcall2', `nbcall3', `nbcall4'"


      if `month'==1 {
         tex \newpage
         tex \section{Definition of POCD}
         tex POCD is defined in a series of steps:
         tex \begin{enumerate}
         tex \item Compute, for each of 7 neuropsychological tests, the z-score for the test for a patient. The z-score is defined as 
         tex       the change from baseline to 1 month, less the mean change from baseline in the primary care group (PCG), and
         tex       divided by the within-subject standard deviation from the PCG.
         tex \item Persons with two or more tests showing z-score of \(-1\) or lower meet criteria for POCD.
         tex \item Persons who have a sum of 7 z-scores of \(-1\) or lower meet criteria for POCD.
         tex \end{enumerate}

         tex \subsection{Which tests}
         tex We are modeling our definition of POCD after ISPOCD, specifically as described in Rasmussen, L. S., \& Siersma, V. D. (2004). 
         tex Postoperative cognitive dysfunction: true deterioration versus random variation. \emph{Acta Anaesthesiologica Scandinavica},
         tex 48(9), 1137-1143. \\[0.5cm]

         tex The neuropsychological tests used in SAGES do not exactly match up with those used in Rasmussen \& Siersma (2004) [R\&S04]. Here's how
         tex we make the crosswalk:
         forvalues i=1/7 {
            tex \begin{description}
            tex \item[Name of test] `nbname`i''
            tex \item[Description of test] `nbdesc`i''
            tex \item[Domain of test] `nbdoma`i''
            tex \item[Stands in for R\&S04] `nbstan`i''
            *tex \item[Variable name in SAGES] `nbvar`i''
            tex \end{description}
            tex \noindent\rule{6cm}{0.4pt}
            tex \newline
         }

         tex The following neuropsychological tests don't have an exact match in SAGES and Rasmussen 
         tex \& Siersma (2004) [R\&S04]. But we do use them in a multiply-imputed version
         tex of POCD:
         forvalues i=8/10 {
            tex \begin{description}
            tex \item[Name of test] `nbname`i''
            tex \item[Description of test] `nbdesc`i''
            tex \item[Domain of test] `nbdoma`i''
            *tex \item[Stands in for R\&S04] `nbstan`i''
            *tex \item[Variable name in SAGES] `nbvar`i''
            tex \end{description}
            tex \noindent\rule{6cm}{0.4pt}
            tex \newline
         }


         tex Even 'tho the tests don't line up perfectly, we think it's important to have the same 
         tex count (7) of tests. This is because one of the R\&S04 criteria for POCD uses a sum of 
         tex z-scores indicating greater than 1 decline in neuropsychological test performance as 
         tex an condition for ruling in POCD. If we used 10 SAGES tests, it'd be easier to get to 
         tex the sum of \(-1\) or less. This discrepancy in tests rules out confident replication 
         tex for the R\&S04 POCD definition, however. Wouldn't it be great if everyone used the NIH 
         tex Toolbox or there were at least standards for harmonization across neuropsychological 
         tex tests?\\[0.5cm]

      }

      * within-subject standard deviation in PCG group
      * var(Residual) from xtmixed
      * see http://www.ats.ucla.edu/stat/stata/faq/diparm.htm
      sort studyid timefr
      forvalues i=1/10 {
         noisily di in green _n "#------------------------------------------------------------------#" _n 
         noisily di in white "outcome: `nbvar`i''"
         local cmd `"xtmixed `nbvar`i'' timefr || studyid: if substr(lower(studyid),1,1)=="n""'
         noisily di in white `"`cmd'"'
         `cmd'
         local b`i'=_b[timefr]
         _diparm lnsig_e , f(exp(@)) d(exp(@))
         local wsd`i'=`r(est)'
         by studyid: gen z`i'=((`nbvar`i''-`nbvar`i''[_n-1])-`b`i'')/`wsd`i'' if ///
            substr(lower(studyid),1,1)~="n"
         * check direction, want higher better
         qui corr vdgcp `nbvar`i''
         if `r(rho)'<0 {
            replace z`i'=-1*z`i'
         }
         gen low`i'=z`i'<-1
      }

      aorder
      * sum of z-scores
      scoreit z1-z7 , gen(sumz) prorate minitems(3)
      * sum of low scores
      scoreit low1-low7 , gen(sumlow) prorate minitems(3)

      gen pocd=(sumz<-1|sumlow>=2) if sumz~=.&sumlow~=.
      table pocd

      la var pocd "Post-operative cognitive decline"
      vlabel pocd No_POCD POCD



      * alternative definitions using other tests
      * 1 2 3 4 5 6 7 <- olist : 5 and 6 aren't perfect matches
      * 5 6 8 9 10 <- are alternaties
      * Combinatronics: unique lists of 2 from a set of 5
      * http://www.wolframalpha.com/input/?i=combinations+of+%7B5%2C+6%2C+8%2C+9%2C+10%7D+taking+2+at+a+time
      * combinations of {5, 6, 8, 9, 10} taking 2 at a time
      * {{5, 6}, {5, 8}, {5, 9}, {5, 10}, {6, 8}, {6, 9}, {6, 10}, {8, 9}, {8, 10}, {9, 10}}
      local tests0 "1 2 3 4 7 5 6" // the main one
      local tests1 "1 2 3 4 7 5 8"
      local tests2 "1 2 3 4 7 5 9"
      local tests3 "1 2 3 4 7 5 10"
      local tests4 "1 2 3 4 7 6 8"
      local tests5 "1 2 3 4 7 6 9"   
      local tests6 "1 2 3 4 7 6 10"
      local tests7 "1 2 3 4 7 8 9"
      local tests8 "1 2 3 4 7 8 10"
      local tests9 "1 2 3 4 7 9 10"
      forvalues i=0/9 {
         if "`testsare`i''"=="" {
            foreach x in `tests`i'' {
               local zsare`i' "`zsare`i'' z`x'"
               local lowsare`i' "`lowsare`i'' low`x'"
               if inlist(`x',1,2,3,4,7)~=1 {
                  local testsare`i' "`testsare`i'' `nbcall`x'',"
               }
            }
            lstrfun testsare`i' , reverse("`testsare`i''")
            lstrfun testsare`i' , substr("`testsare`i''",2,99)
            lstrfun testsare`i' , reverse("`testsare`i''")
            lstrfun testsare`i' , ltrim("`testsare`i''")
         }
         noisily di in red "local testsare`i' <- `testsare`i''"
         scoreit `zsare`i'' , gen(sumz`i') prorate minitems(3)
         scoreit `lowsare`i'' , gen(sumlow`i') prorate minitems(3)
         gen pocd`i'=(sumz`i'<-1|sumlow`i'>=2) if sumz`i'~=.&sumlow`i'~=.
         la var pocd`i' "Post-operative cognitive decline"
         vlabel pocd`i' No_POCD POCD
         
      }
      local testsare10 "`testsare0'"

      drop if pcg
      drop pcg
      save w131`month'-164.dta , replace

   }
}

* have a nice day











