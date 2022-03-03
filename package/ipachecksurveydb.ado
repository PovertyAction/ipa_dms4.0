*! version 4.0.0 Innovations for Poverty Action 27jul2020
* ipachecksurveydb: Outputs general survey statistics

program ipachecksurveydb, rclass sortpreserve
	
	version 17

	#d;
	syntax 	,
        	[by(varlist max = 2)]
        	DATEvar(varname)
        	[PERiod(string)]
        	ENUMerator(varname)
        	[CONSent(string)]
        	[DONTKnow(string)]
			[REFuse(string)]
        	[DURation(varname)]
        	FORMVersion(varname)
        	OUTFile(string)
			REPlace
		;	
	#d cr

	qui {

		*** preserve data ***
		preserve

		* tempvars
		tempvar tmv_subdate tmv_consent_yn
		tempvar tmv_obs tmv_enum tmv_formversion tmv_days tmv_dur tmv_miss tmv_dk tmv_ref

		* tempfiles
		tempfile tmf_main_data tmf_datecal
		
		* save number of obs and vars in local
		
		loc obs_count 	= c(N)
		loc vars_count 	= c(k)
		
		* get list of all vars
		unab allvars: _all
		
		* check missing
		egen `tmv_miss' = rowmiss(_all)
		
		* check for dk, ref. Generate dummies if not specified

		if "`dontknow'" ~= "" 	{
			token `"`dontknow'"', parse(,)
				
			* check numeric number
			if "`1'" ~= "" {
				cap confirm integer number `1'
				if _rc == 7 {
					cap assert regexm("`1'", "^[\.][a-z]$")
					if _rc == 9 {
						disp as err "`1' found where integer is expected in option dontknow()"
						exit 198
					}
				}
			}
			anycount _all, generate(`tmv_dk') numval(`1') strval("`3'")
		}
		else gen `tmv_dk' = 0
		if "`refuse'" ~= "" {
			token `"`refuse'"', parse(,)
			
			* check numeric number
			if "`1'" ~= "" {
				cap confirm integer number `1'
				if _rc == 7 {
					cap assert regexm("`1'", "^[\.][a-z]$")
					if _rc == 9 {
						disp as err "`1' found where integer is expected in option refuse()"
						exit 198
					}
				}
			}

			anycount _all, generate(`tmv_ref') numval(`1') strval("`3'")
		}
		else gen `tmv_ref' = 0

		* datevar: datevar(varname)
		* check  : format datevar in %td format
		if lower("`:format `datevar''") == "%tc"	{
			gen `tmv_subdate' = dofc(`datevar')
			format %td `tmv_subdate'
			drop `datevar'
			ren `tmv_subdate' `datevar'
		}
		else if lower("`:format `datevar''") ~= "%td" {
			disp as err `"variable `datevar' is not a date or datetime variable"'
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			list `datevar' in 1/`limit'
			exit 181
		}
		
		* create dummies for options
		loc _cons 	= "`consent'" ~= ""
		loc _dk 	= "`dontknow'" ~= ""
		loc _ref 	= "`refuse'" ~= ""
		loc _dur 	= "`duration'" ~= ""
		
		* save main dateset
		save "`tmf_main_data'"
	
		* period: period(auto | daily | weekly | monthly) 
		* check : check options in period
		if "`period'" ~= "" & !inlist("`period'", "auto", "daily", "weekly", "monthly") {
			disp as err `"option period incorrectly specified. Expecting auto, daily, weekly or monthly."'
			ex 198
		}
		else if "`period'" == "" loc period "auto"
		if "`period'" == "auto" {
		    su `datevar'
			loc min_date `r(min)'
			loc max_date `r(max)'
			loc days = `max_date' - `min_date'
			loc period = cond(`days' <= 40,  "daily", ///
						 cond(`days' <= 280, "weekly", ///
											 "monthly"))
		}

		* duration: check that duration is a numeric var
		if "`duration'"  ~= "" {
		    cap confirm numeric var `duration'
		    if _rc == 7 {
			    disp as err "variable `duration' found at option duration() where numeric variable is expected"
				ex 7
			} 
			else {
				gen `tmv_dur' = `duration'
			}
		}
		else gen `tmv_dur' = 0

		* consent: consent(consent, 1) or consent(consent, 1 2 3)
		if "`consent'" ~= "" {	
			* check  : check that consent variable is numeric and values is a numlist
			token "`consent'", parse(,)
			* check variable specified
			cap unab consent_var	: `1'
			if _rc == 102 {
				disp as err `"no variables specified for consent() option"'
				ex 198
			}
			else if _rc == 111 {
				disp as err `"variable `1' specifed in consent() option not found"'
				ex 111
			}
			else {
				macro shift
				loc consent_vals = subinstr(trim(itrim("`*'")), ",", "", 1)
				if missing("`consent_vals'") {
					disp as err `"no values specified with consent() option."' ///
								`"expected format is consent(varname, varlist)."' 
					ex 198
				}
				gen `tmv_consent_yn' = 0
				foreach val of numlist `consent_vals' {
					replace `tmv_consent_yn' = 1 if `consent_var' == `val'
				}
			}
		}
		else {
			gen `tmv_consent_yn' = 0
		}
				
		*** summary sheet ***
		
		cap frames drop frm_summary
		#d;
		frames 	create 	frm_summary 
				str10  	blank1 
				str80 	description
				str32   values 
			;
		#d cr
		
		* create additional statistics
		
		count if `datevar' == today()
		loc today = `r(N)'											// total submissions from today
		count if week(`datevar') == week(today()) & year(`datevar') == year(today())
		loc week = `r(N)'											// total submissions for week
		count if month(`datevar') == month(today()) & year(`datevar') == year(today())
		loc month = `r(N)'											// totak submissions for month
		su `tmv_consent_yn'
		loc consent_rate `r(mean)'									// consent rate
		mata: st_numscalar("sum", colsum(st_data(., "`tmv_miss'")))
		loc miss_rate = scalar(sum)/(`obs_count' * `vars_count')	// missing rate
		mata: st_numscalar("sum", colsum(st_data(., "`tmv_dk'")))
		loc dontknow_rate = scalar(sum)/(`obs_count' * `vars_count') 	// dontknow rate
		mata: st_numscalar("sum", colsum(st_data(., "`tmv_ref'")))
		loc refuse_rate = scalar(sum)/(`obs_count' * `vars_count')		// refuse rate
		
		* get unique, non miss and all var count
		* drop tempvars
		
		loc uniq_count 		0
		loc nomiss_count 	0
		loc allmiss_count 	0
		foreach var of varlist `allvars' {
						
			cap assert missing(`var')
			if !_rc {
				loc ++allmiss_count
			}
			else {
				cap assert !missing(`var')
				if !_rc {
					loc ++nomiss_count
					
					cap isid `var'
					if !_rc {
						loc ++uniq_count
					}
				}
			}
		}
		
		* duration
		su `duration', detail
		loc dur_min 	= `r(min)'
		loc dur_mean 	= `r(mean)'
		loc dur_med  	= `r(p50)'
		loc dur_max 	= `r(max)'
		
		* other details
		tab `enumerator'
		loc enum_count 		  = `r(r)'
		tab `formversion'
		loc formversion_count = `r(r)'
		su `datevar'
		loc firstdate 		  = string(`r(min)', "%td")
		loc lastdate  		  = string(`r(max)', "%td")
		tab `datevar'
		loc days_count 		  =	`r(r)'
		

		frames frm_summary {
		 
			set obs 29
			replace description = "Survey Dashboard" 				in 1 
			replace description = "`c(current_date)'" 				in 2
			replace description = "submissions" 					in 3
			replace description = "today" 							in 4
			replace values 		= "`today'" 						in 4
			replace description = "this week" 						in 5
			replace values 		= "`week'" 							in 5
			replace description = "this_month" 						in 6
			replace values 		= "`month'" 						in 6
			replace description = "all" 							in 7
			replace values 		= "`obs_count'"						in 7
			replace description = "consent" 						in 8
			replace description = "consent rate" 					in 9
			replace values 		= "`consent_rate'"					in 9
			replace description = "missingness" 					in 10
			replace description = "% of missing values" 			in 11
			replace values 		= "`miss_rate'" 					in 11
			replace description = "% of don't know value" 			in 12
			replace values 		= "`dontknow_rate'" 				in 12
			replace description = "% of refuse to answer value" 	in 13
			replace values 		= "`refuse_rate'"					in 13
			replace description = "variables" 						in 14
			replace description = "# with only unique values" 		in 15
			replace values 		= "`uniq_count'" 					in 15
			replace description = "# with no missing values" 		in 16
			replace values 		= "`nomiss_count'" 					in 16
			replace description = "# with all missing values" 		in 17
			replace values 		= "`allmiss_count'"					in 17
			replace description = "total number" 					in 18
			replace values 		= "`vars_count'" 					in 18
			replace description = "duration" 						in 19
			replace description = "minimum" 						in 20
			replace values 		= "`dur_min'" 						in 20
			replace description = "mean" 							in 21
			replace values 		= "`dur_mean'" 						in 21
			replace description = "median" 							in 22
			replace values 		= "`dur_med'" 						in 22
			replace description = "maximum" 						in 23
			replace values 		= "`dur_max'" 						in 23
			replace description = "other details" 					in 24
			replace description = "# of enumerators" 				in 25
			replace values 		= "`enum_count'" 					in 25
			replace description = "# of form versions" 				in 26
			replace values 		= "`formversion_count'"				in 26
			replace description = "first date of survey" 			in 27
			replace values 		= "" 								in 27
			replace description = "last date of survey" 			in 28
			replace values 		= "" 								in 28
			replace description = "# of days" 						in 29	
			replace values 		= "`days_count'" 					in 29

			
			destring values, replace
			
			* export partially completed sheet. This is to hold the position of the sheet 
			if "`replace'" ~= "" cap rm "`outfile'"
			export excel using "`outfile'", replace sheet("summary")
			
			mata: format_sdb_summary("`outfile'", "summary", `_cons', `_dk', `_ref', `_dur', "`firstdate'", "`lastdate'")	
		}
		
		*** Summary (by group) ***
		if "`by'" ~= "" {
		    
			save "`tmf_main_data'", replace
		    
			* generate vars to keep track of uniq number of forms, enums days in each group
			
			gen `tmv_enum' 			= 0
			gen `tmv_formversion' 	= 0
			gen `tmv_days'			= 0
			
			cap confirm string var `by'
			if !_rc {
			    levelsof `by', loc (groups)
				foreach group in `groups' {
					tab `enumerator' 						if `by' == "`group'"
					replace `tmv_enum' 			= `r(r)' 	if `by' == "`group'"
					tab `formversion' 						if `by' == "`group'"
					replace `tmv_formversion' 	= `r(r)' 	if `by' == "`group'"
					tab `datevar'							if `by' == "`group'"
					replace `tmv_days' 			= `r(r)' 	if `by' == "`group'"
				}
			}
			else {
			    levelsof `by', loc (groups) clean
				foreach group in `groups' {
					tab `enumerator' 						if `by' == `group'
					replace `tmv_enum' 			= `r(r)' 	if `by' == `group'
					tab `formversion' 						if `by' == `group'
					replace `tmv_formversion' 	= `r(r)' 	if `by' == `group'
					tab `datevar'							if `by' == `group'
					replace `tmv_days' 			= `r(r)' 	if `by' == `group'
				}
			}
			
			gen `tmv_obs' = 1
			#d;
			collapse (count) 	submissions 	= `tmv_obs'
					 (mean)  	consent_rate 	= `tmv_consent_yn'
					 (sum)   	missing_rate   	= `tmv_miss'
					 (sum)   	dontknow_rate  	= `tmv_dk'
					 (sum)	 	refuse_rate		= `tmv_ref'
					 (min)	 	duration_min   	= `tmv_dur'
					 (mean)	 	duration_mean   = `tmv_dur'
					 (median) 	duration_median = `tmv_dur'
					 (max)	 	duration_max   	= `tmv_dur'
					 (first) 	enumerators 	= `tmv_enum'
					 (first) 	formversion 	= `tmv_formversion'
					 (min)   	firstdate 		= `datevar'
					 (max)   	lastdate		= `datevar'
					 (first) 	days 			= `tmv_days'
					 ,
					 by(`by')
				;
			#d cr
			
			* convert missing_rate to actual rates
			replace missing_rate 	= missing_rate/(submissions * `vars_count')
			replace dontknow_rate 	= dontknow_rate/(submissions * `vars_count')
			replace refuse_rate 	= refuse_rate/(submissions * `vars_count')
			
			*label variables
			lab var submissions 	"# of submissions"
			lab var consent_rate 	"% of consent"
			lab var missing_rate   	"% missing"
			lab var dontknow_rate  	"% dont know"
			lab var refuse_rate		"% refuse"
			lab var duration_min   	"min duration"
			lab var duration_mean   "mean duration"
			lab var duration_median "median duration"
			lab var duration_max   	"max duration"
			lab var enumerators 	"# of enumerators"
			lab var formversion 	"# of form versions"
			lab var firstdate 		"first date"
			lab var lastdate		"last date"
			lab var days 			"# of days"
			
			* drop consent, dk, ref, duration
			if !`_cons' drop consent_rate
			if !`_dk' 	drop dontknow
			if !`_ref' 	drop refuse
			if !`_dur' 	drop duration_*

			export excel using "`outfile'", first(varl) sheet("summary (grouped)")
			mata: colwidths("`outfile'", "summary (grouped)")
			mata: format_sdb_summary_grp("`outfile'", "summary (grouped)", `_cons', `_dk', `_ref', `_dur')
		}
		
		*** productivity ***
		
		* generate a calendar dataset
		use "`tmf_main_data'", clear
		getcal `datevar'
		
		merge 1:m `datevar' using "`tmf_main_data'", keepusing(`datevar' `by') gen(datematch)
		gen weight = cond(datematch == 3, 1, 0)
		drop datematch
		
		* save data
		save "`tmf_datecal'"
		
		if "`period'" == "daily" {
		    collapse (sum) submissions = weight, by(`datevar')
			gen day = _n
			order day `datevar' submissions
		}
		else if "`period'" == "weekly" {
		    collapse (min) startdate = `datevar' (max) enddate = `datevar' (sum) submissions = weight, by(year week)
			replace week = _n
			order 	week startdate enddate submissions
			keep 	week startdate enddate submissions
		}
		else {
		    collapse (min) startdate = `datevar' (max) enddate = `datevar' (sum) submissions = weight, by(year month)
			replace month = _n
			order 	month startdate enddate submissions
			keep 	month startdate enddate submissions
		}
		
		export excel using "`outfile'", first(var) sheet("`period' productivity")
		mata: colwidths("`outfile'", "`period' productivity")
		mata: format_sdb_prod("`outfile'", "`period' productivity", "`period'")
		
		*** productivity by group ***
		if "`by'" ~= "" {
			use "`tmf_datecal'", clear
			
			if "`period'" == "daily" {
				collapse (sum) submissions = weight, by(`by' `datevar')
				ren `datevar' jvar
			}
			else if "`period'" == "weekly" {
				collapse (sum) submissions = weight, by(`by' year week)
				sort week
				egen jvar = group(year week)
			}
			else {
				collapse `datevar' (sum) submissions = weight, by(`by' year month)
				sort month
				egen jvar = group(year month)
			}
			
			ren submissions vv_
			keep vv_ `by' jvar
			reshape wide vv_, i(`by') j(jvar)
			recode vv_* (. = 0)
			
			egen submissions = rowtotal(vv_*)
			order submissions, after(`by')
			drop if submissions == 0
			
			* add a total row
			loc add = `=_N' + 1
			set obs `add'
			
			replace `by' = "Total" in `add'
			
			foreach var of varlist vv_* {
					
				loc date = substr("`var'", 4, .)
				
				if "`period'" == "daily" {
					loc lab "`:disp %td  `date''"
					lab var `var' "`lab'"
				}
				else if "`period'" == "weekly" 	lab var `var' "week `date'"
				else 							lab var `var' "month `date'"
				
				mata: st_numscalar("sum", colsum(st_data(., "`var'")))
				replace `var' = scalar(sum) in `add'
			}
			
			mata: st_numscalar("sum", colsum(st_data(., "submissions")))
			replace submissions = scalar(sum) in `add'
			
			export excel using "`outfile'", first(varl) sheet("`period' productivity (grouped)")
			mata: colwidths("`outfile'", "`period' productivity (grouped)")
			mata: format_sdb_prod_grp("`outfile'", "`period' productivity (grouped)")
		}
		
		*** export variable details ***
		* restore data to original and cancel preserve
		restore
		
		* set new frames
		cap frames drop frm_variables
		#d;
		frames 	create 	frm_variables 
				str32  	variable 
				str80 	label
				str32   type
				int		(distinct_count 
						 missing_count 	
						 dk_count 		
						 ref_count 		)
			;
		#d cr
		
		foreach var of varlist _all {
			tab `var'
			loc distinct_count = `r(r)'
			count if missing(`var')
			loc missing_count `r(N)'
			
			if "`dontknow'" ~= "" {
				token `"`dontknow'"', parse(,)
				loc numval `1'
				loc strval "`3'"
				cap confirm string var `var'
				if !_rc & "`strval'" ~= "" {
					count if `var' == "`strval'"
					loc dk_count `r(N)'
				}
				else if "`numval'" ~= "" {
					count if `var' == `numval'
					loc dk_count `r(N)'
				}
			}
			else {
				loc dk_count 0
			}
			if "`refuse'" ~= "" {
				token `"`refuse'"', parse(,)
				loc numval `1'
				loc strval "`3'"
				cap confirm string var `var'
				if !_rc & "`strval'" ~= "" {
					count if `var' == "`strval'"
					loc ref_count `r(N)'
				}
				else if "`numval'" ~= "" {
					count if `var' == `numval'
					loc ref_count `r(N)'
				}
			}
			else {
				loc ref_count 0
			}
			
			#d;
			frames post frm_variables ("`var'") 
									  ("`:var lab `var''")
									  ("`:type `var''")
									  (`distinct_count')
									  (`missing_count')
									  (`dk_count')
									  (`ref_count')
				;
			#d cr
		
		}
		
		* export data
		frames frm_variables {
			
			* generate missing, dk & refuse rates
			gen missing_perc 	= missing_count/`obs_count'	, after(missing_count)
			gen dk_perc 		= dk_count/`obs_count'		, after(dk_count)
			gen ref_perc 		= ref_count/`obs_count'		, after(ref_count)			
			
			lab var distinct_count 	"# distinct"
			lab var missing_count 	"# missing"
			lab var missing_perc 	"% missing"
			lab var dk_count 		"# don't know"
			lab var dk_perc 		"% dont'know"
			lab var ref_count 		"# refuse"
			lab var ref_perc 		"% refuse"
			
			if "`dontknow'" == "" drop dk_count 	dk_perc
			if "`refuse'"	== "" drop ref_count 	ref_perc
			
			* replace distint_count with missing if all vars are missing
			replace distinct_count = . if float(missing_perc) == 1
			
			export excel using "`outfile'", first(varl) sheet("variable details")
			mata: colwidths("`outfile'", "variable details")
			
			loc _dk 	= "`dontknow'" ~= ""
			loc _ref 	= "`refuse'" ~= ""
			mata: format_sdb_var_det("`outfile'", "variable details", `_dk', `_ref')
		}

	}
	
end

*** additional programs ***

* program to count the number of times items in values appear in varlist
program define anycount
	
	syntax varlist, generate(name) [numval(numlist missingokay) strval(string)]
	

	*** check syntax ***
	if "`numval'`strval'" == "" {
	    disp as err "must specify options numval() or strval()"
		ex 198
	}

	* generate count variable
	gen `generate' = 0
	foreach var of varlist `varlist' {
	    cap confirm string var `var'
		if !_rc & "`strval'" ~= "" {
		    replace `generate' = `generate' + 1 if `var' == "`strval'"
		}
		else if !missing("`numval'") {
		    replace `generate' = `generate' + 1 if `var' == `strval'
		}
	}
	
end

* program to generate calendar
program define getcal 

	syntax varname
	
	* temp var
	tempvar tmv_date
	
	*** check syntax***
	* check that varname is date type var
	* check  : format datevar in %td format
	if lower("`:format `varlist''") == "%tc"	{
		gen `tmv_date' = dofc(`varlist')
		format %td `tmv_date'
		drop `valist'
		ren `tmv_date' `varlist'
	}
	else if lower("`:format `varlist''") ~= "%td" {
		disp as err `"variable `varlist' is not a date or datetime variable"'
		if `=_N' > 5 loc limit = `=_N'
		else 		 loc limit = 5
		list `varlist' in 1/`limit'
		exit 181
	}
	
	* check start and enddate
	su `varlist'
	loc startdate = `r(min)'
	loc enddate = `r(max)'
	
	loc days = `enddate' - `startdate'
	
	clear
	set obs `=`days'+1' 
	gen index = _n
	gen `varlist' 	= `startdate' + index - 1
	format %td `varlist'
	gen week 		= week(`varlist') 
	gen month 		= month(`varlist') 
	gen year 		= year(`varlist') 

end
/*
mata: 
mata clear



end

