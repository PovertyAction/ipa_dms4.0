program ipacheckdups, rclass sortpreserve
	
	#d;
	syntax varlist, 
		id(varname) 
		enumerator(varname) 
		DATEvar(varname) 
		outfile(string) 
		[outsheet(string)]
		[KEEPvars(varlist)]
		[SHEETMODify SHEETREPlace]
		;
	#d cr
	
	*** preserve data ***
	preserve

	qui {
	    
		* check that ID var is unique
		cap isid `id'
		if _rc == 459 {
		    disp as err "id() variable `id' does not uniquely identify the observations"
			exit 459
		}
		
		* create default for outsheet if not specified
		if "`outsheet'" == "" loc outsheet "duplicates"
	    
		* declare tempvars
		#d;
		tempvar subdate 
				dv_check dv_flag 
				serial max_serial index 
				value variable label
			;
		#d cr
		
		* keep only variables of interest
		keep `datevar' `varlist' `id' `enumerator' `datevar' `keepvars'
		
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
		
		* check for duplicates 
		gen `dv_check' = 0
		foreach var in `varlist' {
			duplicates tag `var' if !mi(`var'), gen(`dv_flag')
			replace `dv_check' = 1 if `dv_flag' & !mi(`dv_flag')
			drop `dv_flag'
		}
		
		* keep only observations with at least one duplicate
		drop if !`dv_check'
		
		if `=_N' > 0 {
		
			* save variable information in locals
			loc vl_cnt 1
			foreach var of varlist `varlist' {
				loc var`vl_cnt' 		"`var'"
				loc varlab`vl_cnt'		"`:var lab `var''"
				
				cap confirm numeric var `var'
				if !_rc {
					gen _v`vl_cnt' 	= string(`var')
				}
				else gen _v`vl_cnt' = `var'
				drop `var'
				
				loc ++vl_cnt
			}
			
			* reshape data
			reshape long _v, i(`id') j(`index')
			drop if mi(_v)
			ren _v `value'
			
			gen `variable' = "", before(`value')
			gen `label' = "", after(`variable')
			forval i = 1/`vl_cnt' {
				replace `variable' 	= "`var`i''" 	if `index' == `i'
				replace `label' 	= "`varlab`i''" if `index' == `i'
			}
			
			drop `index'
			sort `variable' `value' `id'
			
			bys `variable' `value' (`id')		: gen `serial' 		= _n
			bys `variable' `value' (`serial')	: gen `max_serial' 	= _N
			
			* remove variable labels from all vars
			foreach var of varlist _all {
				lab var `var' ""
			}
			
			* label tmp vars
			foreach var in variable label value serial {
				lab var ``var'' "`var'"
			}
			
			gen `index' = _n + 1
			levelsof `index' if `serial' == `max_serial', loc(rows) sep(,) clean
			
			keep `serial' `datevar' `id' `enumerator' `variable' `label' `value' `keepvars'
			order `serial' `datevar' `id' `enumerator' `variable' `label' `value' `keepvars'
						
			export excel using "`outfile'", sheet("`outsheet'") first(varl) `sheetmodify' `sheetreplace'
			
			mata: colwidths("`outfile'", "`outsheet'")
			mata: add_lines("`outfile'", "`outsheet'", (`rows'), "thin")
			mata: add_lines("`outfile'", "`outsheet'", (1, `=_N' + 1), "medium")


			tab `variable'
			loc var_cnt `r(r)'
			loc obs_cnt `r(N)'
			
			* display number of outdated submissions
			noi disp "Found {cmd:`obs_cnt'} duplicates in `var_cnt' variable(s)."
		
		}
		else {
		    loc var_cnt `r(r)'
			loc obs_cnt `r(N)'
			
			* display number of outdated submissions
			noi disp "Found {cmd:0} duplicates."
		}
		
		*** store r return values *** 
		* number duplicate observations
		return scalar N_obs = `obs_cnt'

		* number of variables with duplicates
		return scalar N_vars = `var_cnt'
	}
end 
