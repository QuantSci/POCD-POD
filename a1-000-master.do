* pocd cedartree project
* a1-000-master.do
* Rich Jones 
*  17 Jun 2014
* -------------------
* wfenv p:\projects\pocd 
set linesize 120

*SET THRESHOLD TO DEFINE POCD main analysis = 1.96, sensitivity analysis = anything else, e.g. 1SD
local threshold "1.96" // main analysis
*local threshold "1.00" // sensitivity analysis

wfenv s:\sages\projects\pocd_copy2

*global frozenfiles "/users/rnj/Documents/DWork/SAGES/POSTED/DATA/DERIVED/clean/frozenfiles/freeze10312016"
global frozenfiles "S:/sages/POSTED/DATA/DERIVED/clean/frozenfiles/freeze10312016/"

include $analysis/a1-001-preambling.do // date seed etc
include $analysis/a1-005-start-latex.do
include $analysis/a1-105-call-source.do
include $analysis/a1-120-select-cases-for-analysis.do
include $analysis/a1-130-create-variables.do
include $analysis/a1-131-create-variables-pocd.do
include $analysis/a1-205-table1-participant-characteristics.do
include $analysis/a1-207-table2-pocd-and-delirium-mi.do
include $analysis/a1-420-table1-participant-characteristics-mi.do
include $analysis/pocd_concordance_amr20180926.do
include $analysis/a1-990-close-latex.do





 
