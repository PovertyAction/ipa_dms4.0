* check for duplicate values
clear all


program dupscheck

	syntax varlist, id(varname) enum(varname) date(varname) outfile(string) [KEEPvars(varlist)]

	qui {

	lab val `id'
	tostring `id' `enum', replace

	gen subdate = dofc(`date'), after(`date')
	drop `date'
	g `date' = string(subdate, "%td")
	drop subdate 


	foreach var in `varlist' {
		duplicates tag `var' if !mi(`var'), gen(dup`var')
	}

	egen dups = rowtotal(dup*)
	drop if dups == 0


	bysort `varlist'(`id') : gen serial = _n


	gen variable 	= 	""
	gen label 		= 	""
	gen value 		= 	""

	foreach var in `varlist' {
		loc vallab `: var l `var''
		replace variable = "`var'" if !mi(`var')
		replace label = "`vallab'" if !mi(`var')
	 	replace value = `var' if !mi(`var')
	}

	drop `varlist'

	order serial `date' `id' `enum' variable label value `keepvars' 

	export excel serial `date' `id' `enum' variable label value `keepvars' using "C:/users/rsandino/Desktop/upgp.xlsx", first(var) sheet("Duplicates") sheetreplace

} //end qui
end 


use "C:/users/Rsandino/Desktop/HFCs Exercise/05_data/02_survey/survey_data.dta", clear
dupscheck language_other occupation_other, id(id) enum(enumid) date(submissiondate) keepvars(consent) outfile("C:/users/rsandino/Desktop/upgp.xlsx")

