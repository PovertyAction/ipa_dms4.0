*! version 4.0.0 Innovations for Poverty Action 27jul2020

program ipacheckversion, rclass sortpreserve
	
	* This program collates and list all other values specified.
	version 17

	#d;
	syntax 	varname,
        	id(varname) 
        	ENUMerator(varname) 
        	DATEvar(varname)
        	outfile(string) 
        	[outsheet(string)]  
			[SHEETMODify SHEETREPlace]
		;	
	#d cr

	* create frame for output
	#d;
	frames 	create  frm_version 
			str10 	formdef_version 
			str5 	(submitted outdated) 
			str10 	(first_date last_date)
		;
	#d cr

	* check that version variable has no missing values

	qui {
		cap assert !missing(`varlist')
		if _rc == 9 {
			count if missing(`varlist')
			disp as err `"variable `varlist' has `r(N)' missing values. Version variable should not contain missing values"'
			ex 9
		}

		* if outsheet is not specified assume a default

		if mi("`outsheet'") loc outsheet "form versions"
		* set trace on
		* check that datevar if in %td format
		if lower("`:format `datevar''") == "%tc"	{
			gen _datevar = dofc(`datevar')
			format %td _datevar
			drop `datevar'
			ren _datevar `datevar'
		}
		else if lower("`:format `datevar''") ~= "%td" {
			disp as err "variable `datevar' is not a date or datetime variable"
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			list `datevar' in 1/`limit'
		}
		
		* get current version
			
		summ `varlist'
		loc curr_ver `r(max)'

		* get first date of latest version

		summ `tmn_date' if formdef_version == `curr_ver'
		loc   curr_ver_fdate `r(min)'

		levelsof `varlist', loc (vers) clean

		loc vers_cnt = wordcount("`vers'")

		foreach ver in `vers' {
			
			* number submitted
			count if formdef_version == `ver'
			loc submitted `r(N)'

			* number outdate
			count if formdef_version == `ver' & `tmn_date' >= `curr_ver_fdate'
			loc outdated `r(N)'

			* first and last dates
			summ `tmn_date' if formdef_version == `ver'
			loc firstdate "`r(min)'"
			loc lastdate  "`r(max)'"

			* post results 
			frames post frm_version 	("`ver'") 		 ///
									("`submitted'")  ///
									("`outdated'")   ///
									("`:disp %td `firstdate''") ///
									("`:disp %td `lastdate''")

			
		}

		* post totals column
		count if `tmn_date' >= `curr_ver_fdate' & `varlist' != `curr_ver'
		loc outdated `r(N)'

		* add totals

		frames post frm_version ("Total") 		 ///
								("`=_N'")  		 ///
								("`outdated'")   ///
								("") 			 ///
								("")

		frames frm_version {
			
			* replace outdate count for last version
			replace outdated = "-" if `varlist' == "`curr_ver'"

			* add labels
			lab var submitted  "# submitted"
			lab var outdated   "# outdated"
			lab var first_date "first date"
			lab var last_date  "last date"

			export excel using "`outfile'", first(varl) replace sheet("`outsheet'")
		}

		disp "Found {cmd:`outdated'} submissions with outdated forms."
		return scalar nversions = `vers_cnt'
		return scalar noutdated = `outdated'

	}
	
end
