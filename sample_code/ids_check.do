* check for duplicate IDs
clear all

use "C:/users/Rsandino/Desktop/HFCs Exercise/05_data/02_survey/survey_data.dta", clear

loc idvar id
loc enumvar enumid
loc datevar submissiondate
loc keyvar key
loc keepvars ward gender age 
lab val `idvar'
tostring `idvar' `enumvar', replace

gen subdate = dofc(`datevar'), after(`datevar')
drop submissiondate
g submissiondate = string(subdate, "%td")
drop subdate 

* check if duplicates exist in dataset
duplicates tag `idvar', gen(dups)
drop if dups == 0
bysort `idvar' (submissiondate) : gen serial = _n
drop dups 

/* save duplicates dta
tempfile `duplicatesdta'
save `duplicatesdta', replace
*/

ds `idvar' submissiondate `keyvar' serial, not 
loc compvars `r(varlist)'
gen tot = `: word count `compvars''

* use this value to find the first row for each ID
gen index = _n 
bysort id : egen min = min(index)
bysort id : egen max = max(index)

levelsof min, loc(minvals)
levelsof max, loc(maxvals)
loc levcount `:word count `minvals'' 

forval i = 1/`levcount' {
	foreach var in `compvars' {
		if `i' == 1 gen `var'_c = .
		replace `var'_c = `var'[`:word `i' of `minvals''] != `var'[`:word `i' of `maxvals''] if ( _n == `:word `i' of `minvals'' | _n == `:word `i' of `maxvals'')
	}
}


egen diff 	= 	rowtotal(*_c)
gen percent = 	diff / tot

	foreach var of varlist * {
		lab var `var' ""
	}

lab var diff "Differences"
lab var tot "Total Compared"
lab var percent "Percent Difference"

export excel serial submissiondate `idvar' `enumvar' `keyvar' diff tot percent `keepvars' using "C:/users/rsandino/Desktop/iddups.xlsx", first(varl) sheet("ID Duplicates") replace
