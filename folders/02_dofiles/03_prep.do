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
clear all 
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

if !mi("${dontknow}") recode `numeric' (${dontknow} = .d)
if !mi("${refuse}") recode `numeric' (${refuse} = .r)
if !mi("${na}") recode `numeric' (${na} = .n)



************************************************
* make replacements
************************************************

// to be written

************************************************
* other cleaning
************************************************
* ideas: 
* change duration variable to minutes/hours
* restructure/relabel repeat groups vars
* create new variables, drop temp vars, etc.
set trace on
ipacheckids, id(${surveyid}) enumerator(${enumid}) ///
datevar(${datevar}) key(${key}) outfile("${hfcout}") ///


// resolve duplicates here


* save and rename
save "$prepsurveydata", replace
