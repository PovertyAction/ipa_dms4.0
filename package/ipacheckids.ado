
program ipacheckids, rclass sortpreserve
	
	#d;
	syntax, id(varname) 
			enumerator(varname) 
			datevar(varname) 
			key(varname) 
			outfile(string) 
			[outsheet(string)]
			[KEEPvars(varlist) dupfile(string)]
			[save(string)]
			[SHEETMODify SHEETREPlace]
		;
	#d cr
		
	qui {
	    
		*** preserve data ***
		preserve
	
		tempvar subdate serial index min max 
		
		* save a de-duplicated dataset
		if "`save'" ~= "" {
		    duplicates drop `id', force
			save "`save'", replace
			
			* restore data
			restore, preserve
		}
 		
		* datevar: format datevar in %td format
		if lower("`:format `datevar''") == "%tc"	{
			gen `subdate' = dofc(`datevar')
			format %td `subdate'
			drop `datevar'
			ren `subdate' `datevar'
		}
		else if lower("`:format `datevar''") ~= "%td" {
			disp as err `"variable `datevar' is not a date or datetime variable"'
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			list `datevar' in 1/`limit'
		}
		
		* set outsheet
		if "`outsheet'" == "" loc outsheet "id duplicates"

		* creates only duplicates dataset
		duplicates tag `id', gen(dups)
		count if dups
	
		if `r(N)' == 0 noi display "There are no duplicates of `id' in the data." 
		else {
			keep if dups
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
			gen `max' = cond(`index' == `min', ., `index')
					
			forval j = 2/`=_N' { 
				loc minval = `min'[`j']
				loc maxval = `max'[`j']

				foreach var in `compvars' { // compare all variables
					if `j' == 2 gen `var'_c = .
					replace `var'_c = `var'[`minval'] != `var'[`maxval'] if _n == `maxval'
				}
			}


			egen differences 	= 	rowtotal(*_c)
			gen percent_difference = differences / total_compared
			replace differences = . if !differences
			format percent %8.4f
			drop *_c
			
			foreach var of varlist * {
				lab var `var' ""
			}

			lab var differences 		"Differences"
			lab var total_compared 		"Total Compared"
			lab var percent_difference 	"Percent Difference"
			lab var `serial' 			"Serial"

		}

		frame put `serial' `datevar' `id' `enumerator' `key' differences total_compared percent_difference `keepvars', into(frm_subset)
		frame frm_subset {

			export excel using "`outfile'", first(varl) sheet("`outsheet'") `sheetreplace' `sheetmodify'
			mata: colwidths("`outfile'", "`outsheet'")
			mata: colformats("`outfile'", "`outsheet'", "percent_difference", "percent_d2")	
						
			bys `id' (`serial'): gen _dp_count = _N
			gen _dp_row = _n + 1
			levelsof _dp_row if `serial' == _dp_count, loc (rows) clean sep(,) 
			
			drop _dp_*
		
			mata: add_lines("`outfile'", "`outsheet'", (`rows'), "thin")
			mata: add_lines("`outfile'", "`outsheet'", (1, `=_N' + 1), "medium")
		}
		
		* display number of duplicates founds
		tab `id'
		noi disp "Found {cmd:`=_N'} duplicates observations in `r(r)' duplicate pairs."
		
		*** store r return values *** 
		* number duplicate observations
		return scalar N_dups = `=_N'

		* total outdate submissions
		return scalar N_pairs = `r(r)'
		

	} 

end 

