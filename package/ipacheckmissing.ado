*! version 4.0.0 Innovations for Poverty Action 27jul2020
* ipacheckmissing: Outputs a table showing information missing data in survey

program ipacheckmissing, rclass sortpreserve
	
	version 17

	#d;
	syntax 	[varlist] [using],
        	[IMPortantvars(varlist)] 
        	OUTFile(string)
        	[show(string)]
        	[OUTSheet(string)]  
			[SHEETMODify SHEETREPlace]
		;	
	#d cr

	qui {

		*** Check syntax ***

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

		* inputs: varlist | using must be specified specified
		if mi("`varlist'") & mi("`using'") {
			disp as err `"varlist or using is required"'
			ex 198
		}

		* inputs: varlist & using are mutually exclusive
		if !mi("`varlist'") & !mi("`using'") {
			disp as err `"varlist or using are mutually exclusive"'
			ex 198
		}

		* important vars: using and importantvars are mutually exclusive
		if !mi("`using'") & !mi("`important'") {
			disp as err `"using() and options importantvars() are mutually exclusive"'
			ex 198
		}

		*** set default values ***

		* outsheet: default to "missing" if not specified
		if "`outsheet'" == "" loc outsheet "missing"

		*** create frames ***

		* output frame
		#d;
		frames 	create 	missing 
				str32  	variable 
				str80 	label 
				double  (number_missing percent_missing number_unique) 
				byte    important_var
			;
		#d cr

		*** create output ***

		* list important vars
		if !mi("`importantvars'") unab importantvars: `importantvars'

		* unabbrev varlist
		unab vars: `varlist'

		* list vars to check
		loc vars: list vars | importantvars

		* create & post stats for each variable
		foreach var of varlist `vars' {
			
			* count missing values for var
			qui count if missing(`var')
			loc missing_cnt `r(N)'
			
			* count number of unique nonmissing values for var
			qui tab `var'
			loc unique_cnt `r(r)'

			* check if var is an important var
			if !missing("`importantvars'") loc important_var: list var in importantvars

			* post results to frame
			frames post ///
					missing ("`var'") 				///
							("`:var lab `var''") 	///
							(`missing_cnt') 		///
							(`missing_cnt'/`=_N') 	///
							(`unique_cnt') 			///
							(`important_var')
		}

		* export results
		frames missing {

			* count number of variables to check
			loc varscount = wordcount("`vars'")

			* count number of variables that are all missing
			count if percent_missing == 1
			loc allmisscount `r(N)'

			* count number of vars with at least 1 missing variables
			count if percent_missing ~= 1
			loc misscount `r(N)'

			* apply show option
			if regexm("`show'", "%") {
				drop if float(percent_missing) < float(`show_val')
			}
			else if "`show'" ~= "" drop if missing_cnt < `show'
			
			* sort data by importance & percent missing
			gsort -important_var -percent_missing -number_missing variable

			* convert important_var to string
			tostring important_var, replace
			replace important_var = cond(important_var == "1", "yes", "")
			
			* export & format output
			export excel using "`outfile'", first(var) replace sheet("`outsheet'") `sheetmodify' `sheetreplace'
			mata: colwidths("`outfile'", "`outsheet'")
			mata: colformats("`outfile'", "`outsheet'", "percent_missing", "percent_d2")
			mata: add_lines("`outfile'", "`outsheet'", (1, `=_N' + 1), "medium")
		}
	}

	* show information on missing vars
	noi disp "Found {cmd:`allmisscount'} of `varscount' variables with all missing values."
	noi disp "Found {cmd:`misscount'} of `varscount' variables with at least 1 missing values."

	*** store r return values *** 
		* number variables checked
		return scalar N = `varscount'

		* number of variables all missing
		return scalar N_allmiss = `allmisscount'

		* number of vars with at least 1 missing
		return scalar N_miss = `misscount'
	
end
