
program ipacheckids 

	syntax, id(varname) enumerator(varname) datevar(varname) key(varname) outfile(string) [KEEPvars(varlist) dupfile(string)]


	qui {
	
	tempvar subdate serial index min max 
	frame change default
	tostring `id' `enumerator', replace

	gen `subdate' = dofc(`datevar'), after(`datevar')
	drop `datevar'
	g `datevar' = string(`subdate', "%td")
	drop `subdate' 


	* creates only duplicates dataset
	duplicates tag `id', gen(dups)
	drop if dups == 0

	if `=_N' == 0 noi display "There are no duplicates of `id' in the data." 
	else {


	bysort `id' (`datevar') : gen `serial' = _n
	drop dups 

	* save duplicates dta
	if !mi("`dupfile'") save "`dupfile'", replace


	ds `id' `datevar' `key' `serial', not 
	loc compvars `r(varlist)'
	gen total_compared = `: word count `compvars''

	* use this value to find the first row for each ID
	gen `index' = _n 
	bysort `id' : egen `min' = min(`index')
	gen `max' = cond(`index' == min, ., `index')
			
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

	cap confirm frame frm_subset
	if !_rc {

		frame drop frm_subset
	}

	frame put `serial' `datevar' `id' `enumerator' `key' differences total_compared percent_difference `keepvars', into(frm_subset)
	frame change frm_subset

	export excel using "`outfile'", first(varl) sheet("ID Duplicates") sheetreplace
	mata: colwidths("`outfile'", "ID Duplicates")
	mata: colformats("`outfile'", "ID Duplicates", "percent_difference", "percent_d2")	

	frame change default
	frame drop frm_subset
	*tostring *, replace
} // end else 


} // end qui
end 

