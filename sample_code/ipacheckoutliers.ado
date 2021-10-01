*! version 4.0.0 Innovations for Poverty Action 27jul2020

program ipacheckoutliers, rclass
	
	* This program flags outliers in numeric variables
	version 17

	#d;
	syntax 	using/,
			sheetname(string)
        	OUTFile(string)
        	[OUTSheet(string)]  
			id(varname) 
        	ENUMerator(varname) 
        	DATEvar(varname) 
			[SHEETMODify SHEETREPlace NOLabel]
		;	
	#d cr


	* preseve data

	* preserve
	
	* get variable details from input sheet

	* save data
	frames copy default frm_data

	* import input data	
	import excel using "`using'", clear sheet("`sheetname'") first case(l) allstr

	* save keep variables in local and drop
	levelsof keep, clean loc(keepvars)

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

	* check that all multplies supplied are numeric
	cap confirm numeric var multiplier
	if _rc == 7 {
		disp as err "Multiplier contains non-numeric variables"
		destring multiplier, force gen(flag)
		gen row = _n, before(variable)
		noi list row variable method multiplier if mi(flag), abbreviate(32) noobs
		ex 198
	}

	loc cnt `=_N'
	
	frames copy default frm_inputs

	* switch to main dataset
	frames change frm_data

	* expand and replace vars in input sheet
	forval i = 1/`cnt' {
		frames frm_inputs: loc vars`i' = variable[`i']
		unab vars`i': `vars`i''
		frames frm_inputs: replace variable = "`vars`i''" in `i'
	}

	* rename and reshape outlier vars

	loc i 1
	foreach var of varlist `vars' {
		* check that variable is numeric
		cap confirm numeric var `var'
		if _rc == 7 {
			disp as err "Variable `var' must be a numeric variable"
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
	gen combine 	= ""
	
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
			gen combined_var = 0
			foreach var in `vars`i'' {
				di
				* replace combined_var = 1 if variable == "`var'"
			}
		
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
				replace combine 	= "`combine`i''"	if variable == "`var'"

				drop vcount vmin vmax vmean vmedian vsd vp25 vp75 viqr
			}
		}
	}

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

	export excel using "`outfile'", first(var) sheet("`OUTSheet'") `nolabel' `sheetreplace'
	
end
/*
program define makestats

	syntax anything [if] [in], collate(varname) by(varlist)

	foreach var in `anything' {
		if "`by'" ~= "" {
			bys `by': egen vcount  = count(value)  if variable == "`var'"
			bys `by': egen vmin    = min(value)    if variable == "`var'"
			bys `by': egen vmax    = max(value)    if variable == "`var'"
			bys `by': egen vmean   = mean(value)   if variable == "`var'"
			bys `by': egen vmedian = median(value) if variable == "`var'"
			bys `by': egen vsd     = sd(value)     if variable == "`var'"
			bys `by': egen vp25    = pctile(value) if variable == "`var'", p(25)
			bys `by': egen vp75    = pctile(value) if variable == "`var'", p(75)
			bys `by': egen viqr    = iqr(value)    if variable == "`var'"
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
	}

end
*/
