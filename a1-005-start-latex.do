* a1-005-start-latex.do
* Rich Jones 
*  17 Jun 2014
* -------------------
texdoc_purge a1
cap erase a1.tex
texdoc init a1
starttex , tex(a1.tex) arial listings
tex Rich Jones, Lori Daiello and Dae Kim for the SAGES Investigators \\
tex \emph{A CEDARTREE research project}\\
today
tex  `r(date2)'\\[0.25cm]

tex \begin{center}
tex {\bf The Relationship of Post-Operative Delirium and }\\
tex {\bf Post-Operative Cognitive Decline}:\\
tex The Successful Aging after Elective Surgery (SAGES) Study\\[0.5cm]
tex \end{center}
tex

tex \begin{center}
tex {\bf Summary}
tex \end{center}

tex {\bf Objective:} To examine the overlap of and 
tex contrast risk factors for post-operative delirium (POD) and 
tex post-operative cognitive decline (POCD) in a sample
tex of elderly elective surgery patients.\\[0.25cm]

tex {\bf Methods:} Patient data were obtained from the SAGES cohort (560 elective 
tex surgery patients and 119 non-surgical 
tex comparison patients). POD was identified during the hospital 
tex stay following surgery using daily Confusion Assessment 
tex Method (CAM) and chart review methods.\\[0.25cm]

tex {\bf POCD was defined
tex using performance on neuropsychological tests at pre-operative
tex baseline and 
tex 1-month, 2-month, and 6-month
tex post-operative follow-up.}\footnote{We discussed including
tex the 12-month follow-up in this list. However, because of 
tex neuropsych data not being collected at the 12M outcome time
tex point for the non-surgical comparison group, we would have to
tex inconsistently implement the retest effect correction across
tex time point. Therefore, I limit the analysis to the 6M follow-up.}
tex The ISPOCD definition was used to define POCD: a reliable
tex decline in performance (`threshold' within-person standard deviation
tex units) on two or more tests or a cumulative (within-person)
tex standardized decline of `threshold' or more on seven neuropsychological 
tex tests. Because the SAGES and ISPOCD neuropsychological tests
tex differ and could not be unambiguously matched by content or domain, 
tex we used 10 possible combinations of SAGES neuropsychological
tex tests to complete groups of 7 tests and
tex treated the resulting POCD indicators as multiply imputed
tex data to combine results across test combination.\\[0.25cm]

tex We examined the overlap of POD and POCD, and we examined
tex the strength of association of published risk factors for both
tex POCD and POD.\\[0.25cm]


tex \input{mainfindings.tex}



* have a nice day
