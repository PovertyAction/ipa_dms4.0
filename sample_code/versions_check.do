* sample missing check

clear all
tempname tmn_date
frames reset
frames create fr_version str10 formdef_version str5 (submitted outdated) str10 (first_date last_date)

loc versionvar  formdef_version
loc datevar	 	starttime

use "X:\Box\DM Setup Support\tracta\05_data\02_survey\tractor_baseline_full_farmer_prepped.dta", clear

assert !missing(formdef_version)

* generate tempvar to hold date versions of datevar
	
	* check that datevar if in %td format
	if lower("`:format `datevar''") == "%td" 		gen `tmn_date' = `datevar'
	else if lower("`:format `datevar''") == "%tc"	{
		gen `tmn_date' = dofc(`datevar')
		format %td `tmn_date'
	}
	else {
		disp as err "variable `datevar is not a date or datetime variable'"
	}

	list `tmn_date' in 1/5

* get current version
	
	summ `versionvar'
	loc curr_ver `r(max)'

* get first date of latest version

	summ `tmn_date' if formdef_version == `curr_ver'
	loc   curr_ver_fdate `r(min)'


levelsof `versionvar', loc (vers) clean

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
	frames post fr_version 	("`ver'") 		 ///
							("`submitted'")  ///
							("`outdated'")   ///
							("`:disp %td `firstdate''") ///
							("`:disp %td `lastdate''")

	
}

	* post totals column
	count if `tmn_date' >= `curr_ver_fdate' & `versionvar' != `curr_ver'
	loc outdated `r(N)'

	* add totals

	frames post fr_version 	("Total") 		 ///
							("`=_N'")  		 ///
							("`outdated'")   ///
							("") 			 ///
							("")

frames fr_version {
	
	* replace outdate count for last version
	replace outdated = "-" if `versionvar' == "`curr_ver'"

	* add labels
	lab var submitted  "# submitted"
	lab var outdated   "# outdated"
	lab var first_date "first date"
	lab var last_date  "last date"

	export excel using "versions_check.xlsx", first(varl) replace sheet(versions)
}
