program ipacheckdups

	syntax varlist, id(varname) enumerator(varname) datevar(varname) outfile(string) [KEEPvars(varlist)]

	qui {

	lab val `id'
	tostring `id' `enumerator', replace

	gen double date_new = dofc(`datevar')
	drop `datevar'
	ren date_new `datevar'
	format `datevar' %td

	*drop subdate 
	*g `datevar' = string(subdate, "%td")
	*gen subdate = dofc(`datevar'), after(`datevar')
	
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

	order serial `datevar' `id' `enumerator' variable label value `keepvars' 

	export excel serial `datevar' `id' `enumerator' variable label value `keepvars' using "`outfile'", first(var) sheet("Duplicates") sheetreplace
			mata: colwidths("`outfile'", "Duplicates")
} //end qui
end 
