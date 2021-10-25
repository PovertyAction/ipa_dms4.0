*! version 4.0.0 Innovations for Poverty Action 27jul2020
* ipacheckversion: Outputs a table showing number of submissions per formversion

program ipacheckversion, rclass sortpreserve
	
	version 17

	#d;
	syntax 	varname,
        	id(varname) 
        	ENUMerator(varname) 
        	DATEvar(varname)
        	outfile(string)
        	dta(string) 
        	[outsheet(string)]  
			[SHEETMODify SHEETREPlace]
		;	
	#d cr

	qui {

		*** preserve data ***
		preserve

		*** Check syntax ***

		* check that version variable has no missing values
		cap assert !missing(`varlist')
		if _rc == 9 {
			count if missing(`varlist')
			disp as err `"variable `varlist' has `r(N)' missing values."', 		///
						`"Version variable should not contain missing values"'
			ex 9
		}

		*** set default values ***

		* set outsheet: default to form versions if not specified
		if mi("`outsheet'") loc outsheet "form versions"
		

		*** convert variables to desired format ***

		* datevar: format datevar in %td format
		if lower("`:format `datevar''") == "%tc"	{
			gen _datevar = dofc(`datevar')
			format %td _datevar
			drop `datevar'
			ren _datevar `datevar'
		}
		else if lower("`:format `datevar''") ~= "%td" {
			disp as err `"variable `datevar' is not a date or datetime variable"'
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			list `datevar' in 1/`limit'
		}

		*** create frames ***

		* output frame
		#d;
		frames 	create  frm_version 
				str10 	formdef_version 
				str5 	(submitted outdated) 
				str10 	(first_date last_date)
			;
		#d cr

		*** create output table ***
		
		* current form version
		summ `varlist'
		loc curr_ver `r(max)'

		* first date of latest version
		summ `datevar' if `varlist' == `curr_ver'
		loc   curr_ver_fdate `r(min)'

		* list of form versions
		levelsof `varlist', loc (vers) clean

		* count form versions
		loc vers_cnt = wordcount("`vers'")
		
		* record stats for each version
		foreach ver in `vers' {
			
			* count number of submissions for version
			count if `varlist' == `ver'
			loc submitted `r(N)'

			* count number of outdated submissions for version
			count if `varlist' == `ver' & `datevar' >= `curr_ver_fdate'
			loc outdated `r(N)'

			* first and last dates
			summ `datevar' if `varlist' == `ver'
			loc firstdate "`r(min)'"
			loc lastdate  "`r(max)'"

			* post results 
			frames post 								///
				frm_version ("`ver'") 		 			///
							("`submitted'")  			///
							("`outdated'")   			///
							("`:disp %td `firstdate''") ///
							("`:disp %td `lastdate''")
			
		}

		* create stats for totals rows
		count if `datevar' >= `curr_ver_fdate' & `varlist' != `curr_ver'
		loc outdated `r(N)'

		* post totals

		frames post frm_version ("Total") 		 ///
								("`=_N'")  		 ///
								("`outdated'")   ///
								("") 			 ///
								("")

		* output results
		frames frm_version {
			
			* replace outdated count for last version with missing
			replace outdated = "-" if `varlist' == "`curr_ver'"

			* label variables
			lab var submitted  "# submitted"
			lab var outdated   "# outdated"
			lab var first_date "first date"
			lab var last_date  "last date"

			* export & format results
			export excel using "`outfile'", first(varl) 				///
											replace sheet("`outsheet'") ///
											`sheetmodify' 				///
											`sheetreplace'

			mata: colwidths("`outfile'", "`outsheet'")
			mata: add_lines("`outfile'", "`outsheet'", (1, `=_N', `=_N' + 1), "medium")


			* highlight versions still in use
			gen row = _n
			loc lastdate = last_date[`=_N'-1]
			levelsof row if date(last_date, "DMY") == date("`lastdate'", "DMY") & _n ~= `=_N'-1, ///
				loc(rows) sep(,) clean
			mata: add_flags("`outfile'", "`outsheet'", "lightpink", (1), (`rows'))
		}

		*** export a list of outdate forms: ***

		keep if `varlist' ~= `curr_ver' & `datevar' >= `curr_ver_fdate'
		save "`dta'", replace
		
		* display number of outdated submissions
		noi disp "Found {cmd:`outdated'} submissions with outdated forms."
		
		*** store r return values *** 
		* number of form version
		return scalar N_versions = `vers_cnt'

		* total outdate submissions
		return scalar N_outdated = `outdated'
	}
	
end
