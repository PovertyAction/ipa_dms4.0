*! version 4.0.0 Innovations for Poverty Action 27jul2020

program ipacheckoutliers, rclass sortpreserve
	
	* This program flags outliers in numeric variables
	version 17

	#d;
	syntax 	using/,
			sheetname(string)
        	OUTFile(string)
        	[OUTSheet(string)]  
			id(varname) 
			[keepvars(varlist)]
        	ENUMerator(varname) 
        	DATEvar(varname) 
			[SHEETMODify SHEETREPlace NOLabel]
		;	
	#d cr
	
	* get variable details from input sheet

	qui {

		*** preserve data ***
		preserve

		*** import inputs ***

		* import input data	
		import excel using "`using'", clear sheet("`sheetname'") first case(l) allstr

		* check for duplicates in variable comlumn
		drop if missing(variable)
		cap isid variable
		if _rc == 459 {
			duplicates tag variable, gen (dups)
			di as err "Duplicates found in inputs sheet:"
			noi list variable label by combine keep method multiplier if dups
			exit 459 
		}

		* save keep variables in local and drop
		levelsof keep, clean loc(keepvars_inp)

		* save a list of variables
		levelsof variable, clean loc (vars)

		* save byvars 
		levelsof by, clean loc (byvars)

		keep variable by combine method multiplier

		* include default values method and multiplier
			* if no method is supplied, assume iqr
			* if no multiplied is supplied, assume 1.5 for iqr & 3 for SD

		replace method = "iqr" if missing(method)
		replace multiplier = cond(method == "iqr" & missing(multiplier), "1.5", ///
							 cond(method == "sd" & missing(multiplier), "3", multiplier))

		* convert multiplied to numeric
		destring multiplier, replace 

		* check that all multpliers supplied are numeric
		cap confirm numeric var multiplier
		if _rc == 7 {
			disp as err "Multiplier contains non-numeric variables"
			destring multiplier, force gen(flag)
			gen row = _n, before(variable)
			noi list row variable method multiplier if mi(flag), abbreviate(32) noobs
			ex 198
		}

		loc cnt `=_N'

		* copy inputs into data frame
		frames copy default frm_inputs

		* use original data
		restore, preserve 
		
		* check keepvars
		if !missing("`keepvars'`keepvars_inp'") {
			unab keepvars: `keepvars' `keepvars_inp' 
			loc keepvars: list uniq keepvars
		}


		* expand and replace vars in input sheet
		forval i = 1/`cnt' {

			frames frm_inputs: loc vars`i' = variable[`i']
			unab vars`i': `vars`i''
			frames frm_inputs: replace variable = "`vars`i''" in `i'

			* check that the variable specified is not also a keep var
			if "`keepvars'" ~= "" {
				loc viol: list vars`i' in keepvars
				if `viol' {
					disp as err "Variables in varlist and keepvars are mutually exclusive. `vars`i'' is in both"
					ex 198
				}
			}
		}


		* rename and reshape outlier vars
		loc i 1
		foreach var of varlist `vars' {
			* check that variable is numeric
			cap confirm numeric var `var'
			if _rc == 7 {
				disp as err "Variable `var' must be a numeric variable"
				ex 7
			}

			ren `var' ovvalue_`i'
			gen ovname_`i' = "`var'" if !missing(ovvalue_`i')
			gen ovlabel_`i' = "`:var lab ovvalue_`i''" if !missing(ovvalue_`i'), after(ovvalue_`i')
			loc ++i
		}
		
		* keep only relevant variables
		keep `id' `enumerator' `datevar' `keepvars' `byvars' ovvalue_* ovname_* ovlabel_*

		gen reshape_id = _n

		reshape long ovvalue_ ovname_ ovlabel_, i(reshape_id) j(index)
		ren (ovvalue_ ovname_ ovlabel_) (value variable varlabel)

		drop if missing(value)
		drop reshape_id index

		* gen placeholders for important vars
		loc statvars "value_count value_min value_max value_mean value_median value_sd p25 p75 iqr"
		foreach var of newlist `statvars' {
			gen `var' = .
		}

		gen byvar 		= ""
		gen method 		= ""
		gen multiplier 	= .
		gen combine 	= variable
		gen combine_ind = 0
		
		* calculate outliers
		forval i = 1/`cnt' {
			frames frm_inputs {
				loc vars`i' 		= variable[`i']
				loc by`i' 			= by[`i']
				loc method`i' 		= method[`i']
				loc multiplier`i' 	= multiplier[`i']
				loc combine`i' 		= combine[`i'] 
			}

			* check if vars are combined
			if lower("`combine`i''") == "yes" {
				foreach var in `vars`i'' {
					replace combine = "`vars`i''" if variable == "`var'"
					replace combine_ind = 1 if variable == "`var'"
				}
				
				if "`by`i''" ~= "" {
					bys `by`i'': egen vcount  = count(value)  if combine == "`vars`i''"
					bys `by`i'': egen vmin 	  = min(value) 	  if combine == "`vars`i''"
					bys `by`i'': egen vmax 	  = max(value) 	  if combine == "`vars`i''"
					bys `by`i'': egen vmean   = mean(value)   if combine == "`vars`i''"
					bys `by`i'': egen vmedian = median(value) if combine == "`vars`i''"
					bys `by`i'': egen vsd     = sd(value)     if combine == "`vars`i''"
					bys `by`i'': egen vp25 	  = pctile(value) if combine == "`vars`i''", p(25)
					bys `by`i'': egen vp75 	  = pctile(value) if combine == "`vars`i''", p(75)
					bys `by`i'': egen viqr 	  = iqr(value)    if combine == "`vars`i''"
				}
				else {
					egen vcount   = count(value)  if combine == "`vars`i''"
					egen vmin 	  = min(value) 	  if combine == "`vars`i''"
					egen vmax 	  = max(value) 	  if combine == "`vars`i''"
					egen vmean    = mean(value)   if combine == "`vars`i''"
					egen vmedian  = median(value) if combine == "`vars`i''"
					egen vsd 	  = sd(value)     if combine == "`vars`i''"
					egen vp25 	  = pctile(value) if combine == "`vars`i''", p(25)
					egen vp75 	  = pctile(value) if combine == "`vars`i''", p(75)
					egen viqr 	  = iqr(value)    if combine == "`vars`i''"
				}

				replace value_count 	  = vcount 		  if combine == "`vars`i''"
				replace value_min 		  = vmin 		  if combine == "`vars`i''"
				replace value_max 		  = vmax 		  if combine == "`vars`i''"
				replace value_mean 		  = vmean 		  if combine == "`vars`i''"
				replace value_median 	  = vmedian 	  if combine == "`vars`i''"
				replace value_sd 	  	  = vmedian 	  if combine == "`vars`i''"
				replace p25 			  = vp25       	  if combine == "`vars`i''"
				replace p75 			  = vp75 		  if combine == "`vars`i''"
				replace iqr 			  = viqr 		  if combine == "`vars`i''"

				replace byvar 		= "`by`i''" 		if combine == "`vars`i''" 
				replace method 		= "`method`i''"		if combine == "`vars`i''"
				replace multiplier 	= `multiplier`i''   if combine == "`vars`i''"

				drop vcount vmin vmax vmean vmedian vsd vp25 vp75 viqr
			}
			else {
				foreach var in `vars`i'' {
					if "`by`i''" ~= "" {
						bys `by`i'': egen vcount  = count(value)  if variable == "`var'"
						bys `by`i'': egen vmin 	  = min(value) 	  if variable == "`var'"
						bys `by`i'': egen vmax 	  = max(value) 	  if variable == "`var'"
						bys `by`i'': egen vmean   = mean(value)   if variable == "`var'"
						bys `by`i'': egen vmedian = median(value) if variable == "`var'"
						bys `by`i'': egen vsd     = sd(value)     if variable == "`var'"
						bys `by`i'': egen vp25 	  = pctile(value) if variable == "`var'", p(25)
						bys `by`i'': egen vp75 	  = pctile(value) if variable == "`var'", p(75)
						bys `by`i'': egen viqr 	  = iqr(value)    if variable == "`var'"
					}
					else {
						egen vcount   = count(value)  if variable == "`var'"
						egen vmin 	  = min(value) 	  if variable == "`var'"
						egen vmax 	  = max(value) 	  if variable == "`var'"
						egen vmean    = mean(value)   if variable == "`var'"
						egen vmedian  = median(value) if variable == "`var'"
						egen vsd 	  = sd(value)     if variable == "`var'"
						egen vp25 	  = pctile(value) if variable == "`var'", p(25)
						egen vp75 	  = pctile(value) if variable == "`var'", p(75)
						egen viqr 	  = iqr(value)    if variable == "`var'"
					}

					replace value_count 	  = vcount 		  if variable == "`var'"
					replace value_min 		  = vmin 		  if variable == "`var'"
					replace value_max 		  = vmax 		  if variable == "`var'"
					replace value_mean 		  = vmean 		  if variable == "`var'"
					replace value_median 	  = vmedian 	  if variable == "`var'"
					replace value_sd 	  	  = vmedian 	  if variable == "`var'"
					replace p25 			  = vp25       	  if variable == "`var'"
					replace p75 			  = vp75 		  if variable == "`var'"
					replace iqr 			  = viqr 		  if variable == "`var'"

					replace byvar 		= "`by`i''" 		if variable == "`var'" 
					replace method 		= "`method`i''"		if variable == "`var'"
					replace multiplier 	= `multiplier`i''   if variable == "`var'"

					drop vcount vmin vmax vmean vmedian vsd vp25 vp75 viqr
				}
			}
		}

		* clean up and rename combine variables
		replace combine = "" if !combine_ind
		ren 	combine combine_vars
		drop 	combine_ind

		gen range_min = cond(method == "iqr", p25 - (1.5 * iqr), value_mean - (multiplier * value_sd))
		gen range_max = cond(method == "iqr", p75 + (1.5 * iqr), value_mean + (multiplier * value_sd)) 
		
		keep if !inrange(value, range_min, range_max)

		if lower("`:format `datevar''") == "%tc"	{
				gen _datevar = dofc(`datevar'), after(`datevar')
				format %td _datevar

				drop `datevar'
				ren _datevar `datevar'
		}
		else if lower("`:format `datevar''") != "%td" {
			disp as err "variable `datevar is not a date or datetime variable'"
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			list _datevar in 1/`limit'

		}

		order `datevar' `id' `enumerator' variable varlabel value byvar `byvars' method multiplier combine range_min range_max value_count value_sd iqr value_mean value_min p25 value_median p75 value_max `keepvars'

		export excel using "`outfile'", first(var) sheet("`outsheet'") `nolabel' `sheetreplace'

		mata: colwidths("`outfile'", "`outsheet'")
		mata: add_lines("`outfile'", "`outsheet'", (1, `=_N' + 1), "medium")
	}
	
end
