*! version 4.0.0 Innovations for Poverty Action 27jul2020
* ipacheckmissing: Outputs a table showing information missing data in survey

program ipacheckmissing, rclass
	
	version 17

	#d;
	syntax 	varlist,
        	[IMPortantvars(varlist)] 
        	OUTFile(string)
        	[show(string)]
        	[OUTSheet(string)]  
			[SHEETMODify SHEETREPlace]
		;	
	#d cr

	qui {

		preserve
	
		* show(): if % -- check that value is within 0 to 100
		* 		  if not specified, default to 0
		if "`show'" ~= "" {
			if regexm("`show'", "%") {
				loc show_val = real(subinstr("`show'", "%", "", .))/100
				if !inrange(`show_val', 0, 1) {
					dis as err "option show(`show') must be in range 0% to 100%.", 				///
					           "Use appropraite percentage value or use an absolute number.",	///
					           "eg. show(10%) or show(15)"
					ex 198
				}
			}
		}
		else loc show_val = 0

		* set default outsheet
		if "`outsheet'" == "" loc outsheet "missing"

		* create output frame
		#d;
		frames 	create 	missing 
				str32  	variable 
				str80 	label 
				double  (number_missing percent_missing number_unique) 
				str3    important_var
			;
		#d cr

		* list important vars
		if "`importantvars'" ~= "" unab importantvars: `importantvars'

		* unabbrev varlist
		unab vars: `varlist'

		* list vars to check
		loc vars: list vars | importantvars

		* create & post stats for each variable
		foreach var of varlist `vars' {
			
			qui count if missing(`var')
			loc missing_cnt `r(N)'
			
			qui tab `var'
			loc unique_cnt `r(r)'

			if "`importantvars'" ~= "" loc important_var: list var in importantvars

			* post results to frame
			frames post ///
					missing ("`var'") 				///
							("`:var lab `var''") 	///
							(`missing_cnt') 		///
							(`missing_cnt'/`=_N') 	///
							(`unique_cnt') 			///
							("`important_var'")
		}

		* export results
		frames missing {
		    
			loc varscount = wordcount("`vars'")
			
			count if percent_missing == 1
			loc allmisscount `r(N)'

			count if percent_missing ~= 1
			loc misscount `r(N)'

			* apply show option
			if regexm("`show'", "%") {
				drop if float(percent_missing) < float(`show_val')
			}
			else if "`show'" ~= "" drop if number_missing < `show'
			
			* sort data by importance & percent missing
			gsort -important_var -percent_missing -number_missing variable
			
			lab var number_missing 	"# missing"
			lab var percent_missing "% missing"
			lab var important_var 	"important var?"
			lab var number_unique   "# distinct"

			* convert important_var to string
			replace important_var = cond(important_var == "1", "yes", "")
			
			* replace distinct values with missing of all is missing
			replace number_unique = . if percent_missing == 1
			
			* export & format output
			export excel using "`outfile'", first(varl) sheet("`outsheet'") `sheetmodify' `sheetreplace'
			mata: colwidths("`outfile'", "`outsheet'")
			mata: colformats("`outfile'", "`outsheet'", "percent_missing", "percent_d2")
			mata: setheader("`outfile'", "`outsheet'")
		}
	}

	noi disp "Found {cmd:`allmisscount'} of `varscount' variables with all missing values."
	noi disp "Found {cmd:`misscount'} of `varscount' variables with at least 1 missing values."

	return scalar N_vars = `varscount'
	return scalar N_allmiss = `allmisscount' 	// all missing values
	return scalar N_miss = `misscount'			// at least one missing value
	
end