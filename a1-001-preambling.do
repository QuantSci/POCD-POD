* a1-001-preambling.do
* Rich Jones and Jane Saczynski
*  6 Mar 2014
* -------------------
date // today : RNJ ado's that provide locals for date
local today = "`r(date2)'" // e.g., "11 JAN 2011"
local datestr = "`r(datestr)'" // e.g., "20110111"
* Settings --------------------------------------------------
set seed 3481 // even if not sure needed, set it anyway
set more off // unless you really want it
local t=0
local f=0

cap log close
cap file close 
cap erase mainfindings.tex
mfdoc init mainfindings.tex
mf %This is a summary of the main findings
