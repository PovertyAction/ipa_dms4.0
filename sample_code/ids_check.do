* check for duplicate IDs
clear all

use "C:/users/Rsandino/Desktop/HFCs Exercise/05_data/02_survey/survey_data.dta", clear

loc idvar id 
loc enumvar enumid
loc datevar submissiondate
loc keyvar key
loc keepvars consent 
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
bysort `idvar' : egen min = min(index)
gen max = cond(index == min, ., index)
		
forval j = 2/`=_N' { 
	loc minval = min[`j']
	loc maxval = max[`j']

	foreach var in `compvars' { // compare all variables
		if `j' == 2 gen `var'_c = .
		replace `var'_c = `var'[`minval'] != `var'[`maxval'] if _n == `maxval'
	}

}


egen diff 	= 	rowtotal(*_c)
gen percent = 	diff / tot
drop *_c

foreach var of varlist * {
	lab var `var' ""
}

lab var diff "Differences"
lab var tot "Total Compared"
lab var percent "Percent Difference"

export excel serial submissiondate `idvar' `enumvar' `keyvar' diff tot percent `keepvars' using "C:/users/rsandino/Desktop/upgp.xlsx", first(varl) sheet("ID Duplicates") replace
