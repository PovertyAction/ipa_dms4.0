* check for duplicate values
clear all

use "C:/users/Rsandino/Desktop/HFCs Exercise/05_data/02_survey/survey_data.dta", clear

loc idvar id 
loc enumvar enumid
loc datevar submissiondate
loc dupvars language_other occupation_other
loc keepvars consent 
lab val `idvar'
tostring `idvar' `enumvar', replace

gen subdate = dofc(`datevar'), after(`datevar')
drop submissiondate
g submissiondate = string(subdate, "%td")
drop subdate 


foreach var in `dupvars' {
	duplicates tag `var' if !mi(`var'), gen(dup`var')
}

egen dups = rowtotal(dup*)
drop if dups == 0


bysort `dupvars'(`idvar') : gen serial = _n


gen variable 	= 	""
gen label 		= 	""
gen value 		= 	""

foreach var in `dupvars' {
	loc vallab `: var l `var''
	replace variable = "`var'" if !mi(`var')
	replace label = "`vallab'" if !mi(`var')
 	replace value = `var' if !mi(`var')
}

drop `dupvars'

order serial submissiondate `idvar' `enumvar' variable label value `keepvars' 

export excel serial submissiondate `idvar' `enumvar' variable label value `keepvars' using "C:/users/rsandino/Desktop/upgp.xlsx", first(var) sheet("Duplicates") sheetreplace
