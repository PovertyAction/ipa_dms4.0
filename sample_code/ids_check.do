* check for duplicate IDs
clear all

* data changes a lot (subset of data to only duplicates, new vars, etc.) should this be its own frame?


program idscheck // will rename, just didn't want to override existing ipacheckids on my computer

	syntax, id(varname) enum(varname) date(varname) key(varname) outfile(string) [KEEPvars(varlist) dupfile(string)]

	qui {
	* variable formatting
	lab val `id'
	tostring `id' `enum', replace

	gen subdate = dofc(`date'), after(`date')
	drop `date'
	g `date' = string(subdate, "%td")
	drop subdate 


	* creates only duplicates dataset
	duplicates tag `id', gen(dups)
	drop if dups == 0

	if `=_N' == 0 noi display "There are no duplicates of `id' in the data." 
	else {


	bysort `id' (`date') : gen serial = _n
	drop dups 

	* save duplicates dta
	if !mi("`dupfile'") save "`dupfile'", replace


	ds `id' `date' `key' serial, not 
	loc compvars `r(varlist)'
	gen total_compared = `: word count `compvars''

	* use this value to find the first row for each ID
	gen index = _n 
	bysort `id' : egen min = min(index)
	gen max = cond(index == min, ., index)
			
	forval j = 2/`=_N' { 
		loc minval = min[`j']
		loc maxval = max[`j']

		foreach var in `compvars' { // compare all variables
			if `j' == 2 gen `var'_c = .
			replace `var'_c = `var'[`minval'] != `var'[`maxval'] if _n == `maxval'
		}

	}


	egen differences 	= 	rowtotal(*_c)
	gen percent_difference = differences / total_compared
	format percent %8.4f
	drop *_c

	foreach var of varlist * {
		lab var `var' ""
	}

	lab var differences "Differences"
	lab var total_compared "Total Compared"
	lab var percent_difference "Percent Difference"

	frame put serial `date' `id' `enum' `key' differences total_compared percent_difference `keepvars', into(subset)
	frame change subset

	export excel using "`outfile'", first(varl) sheet("ID Duplicates") sheetreplace
	tostring *, replace
} // end else 


} // end qui
end 

 
use "C:/users/Rsandino/Desktop/HFCs Exercise/05_data/02_survey/survey_data.dta", clear 
idscheck , id(id) enum(enumid) key(key) date(submissiondate) keepvars(consent) outfile("C:/users/rsandino/Desktop/upgp.xlsx")

loc outfile "C:/users/rsandino/Desktop/upgp.xlsx"
