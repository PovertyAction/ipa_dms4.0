********************************************************************************
** 	TITLE: 02_prep.do
**
**	PURPOSE: Prep do file for survey data to destring numeric variables, recode 
**			 missing values, make replacements, report on duplicates, and other 
**			 cleaning required to run checks. 
**				
**	AUTHOR: 
**
**	CREATED: 
********************************************************************************

use "$rawsurveydata", clear


************************************************
* destring and recode numeric variables
************************************************

* destring variables
if "$numvars" ~= "" destring $numvars, replace
if "$strvars" ~= "" tostring $strvars, replace

* recode don't know/refusal values
ds, has(type numeric)
local numeric `r(varlist)'
if !mi("${mv1}") recode `numeric' (${mv1} = .d)
if !mi("${mv2}") recode `numeric' (${mv2} = .r)
if !mi("${mv3}") recode `numeric' (${mv3} = .n)



************************************************
* make replacements
************************************************

if !mi("${repfile}") {
  ipacheckreadreplace using "${repfile}", ///
    id("key") ///
    variable("variable") ///
    value("value") ///
    newvalue("newvalue") ///
    action("action") ///
    comments("comments") ///
    sheet("${repsheet}") ///
    logusing("${replog}") 
}


************************************************
* other cleaning
************************************************
* ideas: 
* change duration variable to minutes/hours
* restructure/relabel repeat groups vars








* save and rename
save "$prepsurveydata", replace
