* check for duplicate values
program ipacheckdups

	syntax varlist, id(varname) enum(varname) datevar(varname) outfile(string) [KEEPvars(varlist)]

	qui {

	lab val `id'
	tostring `id' `enum', replace

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

	order serial `datevar' `id' `enum' variable label value `keepvars' 

	export excel serial `datevar' `id' `enum' variable label value `keepvars' using "`outfile'", first(var) sheet("Duplicates") sheetreplace

} //end qui
end 

 
mata:
void colformats(string scalar filename, string scalar sheet, string vector varsofinterest, string scalar excelformat) 
{

	class xl scalar b
	real scalar endrow, index 

	b = xl()
	b.load_book(filename)
	b.set_sheet(sheet)

	b.set_mode("open")

	endrow = st_nobs() + 1


	for (i=1; i<=cols(varsofinterest); i++) {
		index = st_varindex(varsofinterest[i])
		b.set_number_format((2, endrow), index, excelformat)		
	} 


	b.close_book()
}


colformats("C:/users/rsandino/Desktop/upgp.xlsx", "Duplicates", "submissiondate", "date")
end 
