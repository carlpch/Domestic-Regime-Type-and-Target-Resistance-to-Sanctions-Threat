* 2019/03/16 
* The goal of this do file is to update the TIES 4.0 dataset with the 
* correction code provided by http://bapat.web.unc.edu/files/2018/09/TIESCorrection.txt
clear all

cd /Users/Carl/Projects/sanctions/_data/
import excel using TIESv4.xls, firstrow

replace threat = 1 if caseid == 1990999901  /* the problem is threat = 0 and imposition = 0 at the same time */
replace imposition = 1 if caseid == 1983011301  /* the problem is threat = 0 and imposition = 0 at the same time */
replace startmonth = 1 if caseid == 1973070501  /* startdates & imposition dates miscoded */ 
replace startday = 9 if caseid == 1973070501
replace sancimpositionstartmonth = 1 if caseid == 1973070501
replace sancimpositionstartday = "9" if caseid == 1973070501 
replace finaloutcome= 8 if caseid== 1973070501
replace endyear = 2004 if caseid == 2002041106 /* endyear 2002->2004*/
replace targetstate = 490 if caseid == 2002041103 /* target missing */

export delimited TIESv4.csv
clear all
