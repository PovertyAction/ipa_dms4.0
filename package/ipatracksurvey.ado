*! version 4.0.0 Innovations for Poverty Action 27jul2020
* ipasurveyprogress: Show survey progress

program ipatracksurvey, rclass
	
	#d;
	syntax, 					
		Surveydata(string)
		[ID(name)]
		DATEvar(name)
		[GROUPby(name)]
		[MASTERdata(string)]
		[TRACKingdata(string)]
		[KEEPMaster(namelist)]
		[KEEPTracking(namelist)]
		[KEEPSurvey(namelist)]
		[masterid(name)]
		[OUTFile(string)]
		[TARGet(name)]
		[OUTCome(string)]
		[save(string)]	
		[NOLabel]		
		[SUMMARYonly]
		[WORKbooks]
		[SURVEYok]
	;
	#d cr
		
	version 17

	qui {

		*** preserve data ***
		* preserve

		* tempvars
		tempvar tmv_survey tmv_survey_perc tmv_complete tmv_complete_sum tmv_complete_perc
		tempvar tmv_fdate tmv_ldate tmv_subdate tmv_target tmv_status

		* tempfiles
		tempfile tmf_main_data tmf_input_data tmf_summary tmf_summary_master tmf_surveyonly
		
		* check syntax
		if "`trackingdata'`masterdata'" == "" {
			disp as error "must specify either trackingdata or masterdata option"
			ex 198
		}
		
		if "`trackingdata'" ~= "" & "`masterdata'" ~= "" {
		    disp as error "options trackingdata and masterdata are mutually exclusive"
			ex 198
		}
		
		if "`trackingdata'" ~= "" & "`keepsurvey'" ~= "" & "`surveyok'" == "" {
			disp as error "options trackingdata and keepsurvey are mutually exclusive if option surveyok is not used"
			ex 198
		}

		loc tracking = "`trackingdata'" ~= ""
		loc master   = "`masterdata'"   ~= ""
		
		use "`surveydata'", clear
			
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
		
		if "`outcome'" ~= "" {
			token "`outcome'", parse(",")
			loc outcome_var "`1'"
			loc outcome_vals "`3'"
			
			cap confirm numeric var `outcome_var'
			if _rc == 7 {
				disp as err "`outcome_var' found in option outcome where numeric variable expected"
				ex 7
			}
		
			gen `tmv_complete' = 0
			foreach val in `outcome_vals' {
				replace `tmv_complete' = 1 if `outcome_var' == `val'
			}
		}
		else {
			gen `tmv_complete' = 0
		}
		
		cap assert !missing(`groupby')
		if _rc == 9 {
			disp as err "variable `groupby' in option groupby should never be missing"
			ex 9
		}
		
		if "`keepsurvey'" ~= "" unab keepsurvey: `keepsurvey' 
		keep `datevar' `id' `tmv_complete' `groupby' `keepsurvey'
		
		save "`tmf_main_data'"
			
		* import using data
		loc input_data = cond(`tracking', "`trackingdata'", "`masterdata'")
		loc ext = substr("`input_data'", -strpos(reverse("`input_data'"), "."), .)
		
		if "`ext'" == ".xlsx" | "`ext'" == ".xls" {
			import excel using "`input_data'", first clear 
		}
		else if "`ext'" == ".csv" {
			import delim using "`input_data'", clear varnames(1)
		}
		else {
			use "`input_data'", clear
		}
		
		if `tracking' {
		    
			unab keeplist: `keeptracking'
			keep `groupby' `keeplist' `target'
			cap isid `groupby'
			if _rc == 459 {
				disp as err "variable `groupby' does not uniquely identify the observations in trackingdata"
				ex 459
			}
			
			* check expected
			destring `target', replace
			cap confirm numeric var `target'
			if _rc == 7 {
			    disp as err "'`target'' found where numeric variable expected at target"
				ex 9
			}
			
			save "`tmf_input_data'"

			use "`tmf_main_data'"
			
			if "`surveyok'" ~= "" {
			    save "`tmf_surveyonly'"
			}
			
			gen `tmv_survey' = 1
			collapse 	(sum) `tmv_survey' `tmv_complete' 	///
						(min) `tmv_fdate' = `datevar' 		///
						(max) `tmv_ldate' = `datevar', by(`groupby')
								
			format %td `tmv_fdate' `tmv_ldate'
			save "`tmf_main_data'", replace
			
			use "`tmf_input_data'", clear
			
			merge 1:1 `groupby' using "`tmf_main_data'", gen (_track_merge)
			gen `tmv_survey_perc'	= `tmv_survey'/`target'
			gen `tmv_complete_perc' = `tmv_complete'/`target'
			
			lab var `target'			"target"
			lab var `tmv_survey' 		"# submitted"
			lab var `tmv_survey_perc'	"% submitted"
			lab var `tmv_complete' 		"# completed"
			lab var `tmv_complete_perc' "% completed"
			lab var `tmv_fdate' 		"first date"
			lab var `tmv_ldate'			"last date"
			
			order `groupby' `keeplist', first
			order `tmv_survey_perc', after(`tmv_survey')
			order `tmv_complete_perc', after(`tmv_complete')
			
			if "`outcome'" == "" {
				drop `tmv_complete' `tmv_complete_perc'
			}
			
			if "`surveyok'" == "" {
				count if _track_merge == 2
				if `r(N)' > 0 {
				    disp as err "The following `r(N)' values in `groupby' are not in tracking data"
					noi list `groupby' if _track_merge == 2, noobs abbrev(32)
					ex 9
				}
			}
			
			foreach var of varlist `groupby' `keeplist' {
				lab var `var' "`var'"
			}
			
			drop _track_merge	
			
			if "`outcome'" ~= "" gsort `tmv_survey_perc' `tmv_survey' `tmv_complete_perc' `tmv_complete' `groupby'
			else 				 gsort `tmv_survey_perc' `tmv_survey' `groupby'
			
			* add totals
		
			set obs `=`c(N)' + 1'
			mata: st_numscalar("sum", colsum(st_data(., "`target'")))
			loc target_total = scalar(sum)
			replace `target' = `target_total' in `c(N)'
			mata: st_numscalar("sum", colsum(st_data(., "`tmv_survey'")))
			loc survey_total = scalar(sum)
			replace `tmv_survey' = `survey_total' in `c(N)'
			replace `tmv_survey_perc' = (`survey_total'/`target_total') in `c(N)'
			
			if "`outcome'" ~= "" {
			    mata: st_numscalar("sum", colsum(st_data(., "`tmv_complete'")))
				loc complete_total = scalar(sum)
				replace `tmv_complete' = `complete_total' in `c(N)'
				replace `tmv_complete_perc' = (`complete_total'/`target_total') in `c(N)'
				recode `tmv_survey' `tmv_survey_perc' `tmv_complete' `tmv_complete_perc' (. = 0)
			}
			else {
				recode `tmv_survey' `tmv_survey_perc' (. = 0)
			}

			export excel using "`outfile'", first(varl) sheet("survey progress") replace
			mata: colwidths("`outfile'", "survey progress")
			mata: setheader("`outfile'", "survey progress")
			mata: settotal("`outfile'", "survey progress")
			mata: colformats("`outfile'", "survey progress", ("`tmv_fdate'", "`tmv_ldate'"), "date_d_mon_yy")
			if "`outcome'" ~= "" {
			    mata: colformats("`outfile'", "survey progress", ("`target'", "`tmv_survey'", "`tmv_complete'"), "number_sep")
				mata: colformats("`outfile'", "survey progress", ("`tmv_survey_perc'", "`tmv_complete_perc'"), "percent_d2")
			}
			else {
			    mata: colformats("`outfile'", "survey progress", ("`target'", "`tmv_survey'"), "number_sep")
				mata: colformats("`outfile'", "survey progress", ("`tmv_survey_perc'"), "percent_d2")
			}
			
			if "`surveyok'" ~= "" {
			    use "`tmf_input_data'", clear
				merge 1:m `groupby' using "`tmf_surveyonly'", gen (_surveyonly_merge)
				keep if _surveyonly_merge == 2
				if `c(N)' > 0 {
					keep `id' `datevar' `keepsurvey'
					export excel using "`outfile'", sheet("Unmatched IDs from Survey") first(varl)
					mata: colwidths("`outfile'", "Unmatched IDs from Survey")
					mata: setheader("`outfile'", "Unmatched IDs from Survey")
					ds, has(format %td) 
					foreach var of varlist `r(varlist)' {
						mata: colformats("`outfile'", "Unmatched IDs from Survey", "`var'", "date_d_mon_yy")
					}
				}
			}
			
		}
		
		if `master' {
		    if "`masterid'" ~= "" {
				cap confirm var `masterid'
				if _rc {
					disp as err "variable `masterid' not found in master data"
					ex 111
				}
				cap confirm var `id'
				if _rc {
					disp as err "variable `id' not allowed in master dataset if masterid option is specified."
					ex 111
				}
				ren `trackingid' `id'
			}
			
			save "`tmf_input_data'"
			
			unab keepmaster: `keepmaster'
		
			bys `groupby': gen `tmv_target' = _N
			bys `groupby': keep if _n == _N
			
			keep `id' `groupby' `keepmaster' `tmv_target'
		
			save "`tmf_summary_master'"
			
			use "`tmf_main_data'", clear
			
			* generate summary page
			gen `tmv_survey' = 1
			collapse 	(sum) `tmv_survey' `tmv_complete' 	///
						(min) `tmv_fdate' = `datevar' 		///
						(max) `tmv_ldate' = `datevar', by(`groupby') 
			
			save "`tmf_summary'", replace
			
			use "`tmf_summary_master'", clear
			drop `id'
			
			merge 1:1 `groupby' using "`tmf_summary'", gen (_master_merge) ///
					keepusing(`tmv_survey' `tmv_complete' `tmv_fdate' `tmv_ldate')
			
			gen `tmv_survey_perc'	= `tmv_survey'/`tmv_target'
			gen `tmv_complete_perc' = `tmv_complete'/`tmv_target'
			
			lab var `tmv_target'		"target"
			lab var `tmv_survey' 		"# submitted"
			lab var `tmv_survey_perc'	"% submitted"
			lab var `tmv_complete' 		"# completed"
			lab var `tmv_complete_perc' "% completed"
			lab var `tmv_fdate' 		"first date"
			lab var `tmv_ldate'			"last date"
			
			order `groupby' `keeplist', first
			order `tmv_survey_perc', after(`tmv_survey')
			order `tmv_complete_perc', after(`tmv_complete')
			
			if "`outcome'" == "" {
				drop `tmv_complete' `tmv_complete_perc'
			}

			count if _master_merge == 2
			loc nomerge `r(N)'
			if "`surveyok'" == "" & `nomerge' {
				disp as err "The following `nomerge' vaues in `groupby' are not in the master data"
				noi list `groupby' if _master_merge == 2, noobs abbrev(32)
				ex 9
			}
	
			order `groupby' `keeplist', first
			
			foreach var of varlist `groupby' `keeplist' {
				lab var `var' "`var'"
			}
			
			save "`tmf_summary'", replace
			keep if inlist(_master_merge, 1, 3)
			drop _master_merge
			
			if "`outcome'" ~= "" gsort `tmv_survey_perc' `tmv_survey' `tmv_complete_perc' `tmv_complete' `groupby'
			else 				 gsort `tmv_survey_perc' `tmv_survey' `groupby'
			
			* add totals
			set obs `=`c(N)' + 1'
			mata: st_numscalar("sum", colsum(st_data(., "`tmv_target'")))
			loc target_total = scalar(sum)
			replace `tmv_target' = `target_total' in `c(N)'
			mata: st_numscalar("sum", colsum(st_data(., "`tmv_survey'")))
			loc survey_total = scalar(sum)
			replace `tmv_survey' = `survey_total' in `c(N)'
			replace `tmv_survey_perc' = (`survey_total'/`target_total') in `c(N)'
			
			if "`outcome'" ~= "" {
			    mata: st_numscalar("sum", colsum(st_data(., "`tmv_complete'")))
				loc complete_total = scalar(sum)
				replace `tmv_complete' = `complete_total' in `c(N)'
				replace `tmv_complete_perc' = `complete_total'/`target_total' in `c(N)'
				recode `tmv_survey' `tmv_survey_perc' `tmv_complete' `tmv_complete_perc' (. = 0)
			}
			else {
				recode `tmv_survey' `tmv_survey_perc' (. = 0)
			}
		
			export excel using "`outfile'", first(varl) sheet("summary") replace
			
			mata: colwidths("`outfile'", "summary")
			mata: setheader("`outfile'", "summary")
			mata: settotal("`outfile'", "summary")
			mata: colformats("`outfile'", "summary", ("`tmv_fdate'", "`tmv_ldate'"), "date_d_mon_yy")
			if "`outcome'" ~= "" {
			    mata: colformats("`outfile'", "summary", ("`tmv_target'", "`tmv_survey'", "`tmv_complete'"), "number_sep")
				mata: colformats("`outfile'", "summary", ("`tmv_survey_perc'", "`tmv_complete_perc'"), "percent_d2")
			}
			else {
			    mata: colformats("`outfile'", "summary", ("`target'", "`tmv_survey'"), "number_sep")
				mata: colformats("`outfile'", "summary", ("`tmv_survey_perc'"), "percent_d2")
			}
			
			use "`tmf_input_data'", clear
			merge 1:1 `id' using "`tmf_main_data'", gen (_master_merge) keepusing(`datevar' `keepsurvey')
			save "`tmf_summary_master'", replace
			if "`save'" ~= "" {
			    gen _survey_status = cond(_master_merge == 3, "submitted", cond(_master_merge == 1, "master data only", "survey data only"))
				lab var _survey_status "status"
				keep `groupby' `keepmaster' `id' `tmv_status' `datevar' `keepsurvey' 
				order `groupby' `keepmaster' `id' `tmv_status' `datevar' `keepsurvey'
				save "`save'", replace
			}
			if "`surveyok'" ~= "" {
				use "`tmf_summary_master'", clear
				keep if _master_merge == 2
				if `c(N)' > 0 {
				    keep `id' `datevar' `keepsurvey'
					export excel using "`outfile'", sheet("Unmatched IDs from Survey") first(varl)
					mata: colwidths("`outfile'", "Unmatched IDs from Survey")
					mata: setheader("`outfile'", "Unmatched IDs from Survey")
					ds, has(format %td) 
					foreach var of varlist `r(varlist)' {
						mata: colformats("`outfile'", "Unmatched IDs from Survey", "`var'", "date_d_mon_yy")
					}
				}
			}
			use "`tmf_summary_master'", clear
			keep if inlist(_master_merge, 1, 3)
			gen `tmv_status' = cond(_master_merge == 3, "submitted", "not submitted")
			lab var `tmv_status' "status"
			gsort `groupby' `tmv_status' `datevar'
			keep `groupby' `keepmaster' `id' `tmv_status' `datevar' `keepsurvey'
			order `groupby' `keepmaster' `id' `tmv_status' `datevar' `keepsurvey'
			save "`tmf_summary'", replace
			
			if "`summaryonly'" == "" {
			    
				tab `groupby'
				loc group_cnt `r(r)'
				if `group_cnt' > 30 & "`workbooks'" == "" {
					disp as err "`groupby' has more than 30 unique values. Please use the workbooks option to create seperate workbooks for each group."
					ex 198
				}
				
				if "`workbooks'" ~= "" {
					noi _dots 0, title(Creating `group_cnt' workbooks from `groupby') reps(`group_cnt')
					loc ext = substr("`outfile'", -strpos(reverse("`outfile'"), "."), .)
					loc filename = substr("`outfile'", 1, length("`outfile'") - length("`ext'"))
				}
				
				cap confirm numeric var `groupby'
				if !_rc {
					levelsof `groupby', loc (groups) clean
					loc i 1
					foreach group in `groups' {
						use "`tmf_summary'", clear
						keep if `groupby' == `group'
						if "`workbooks'" ~= "" {
							cap rm "`filename'_`group'.xlsx"
							export excel using "`filename'_`group'.xlsx", first(varl) sheet("status") replace
							loc file 	"`filename'_`group'.xlsx"
							loc sheet 	"status"
						}
						else {
							export excel using "`outfile'", first(varl) sheet("`group'") sheet("status") sheetreplace
							loc file 	"`outfile'"
							loc sheet "`group'"
						}
						
						mata: colwidths("`file'", "`sheet'")
						mata: setheader("`file'", "`sheet'")
						ds, has(format %td) 
						foreach var of varlist `r(varlist)' {
							mata: colformats("`file'", "`sheet'", "`var'", "date_d_mon_yy")
						}
						
						loc ++i
						noi _dots `i' 0
					}
				}
				else {
					levelsof `groupby', loc (groups)
					loc i 1 
					foreach group in `groups' {
						use "`tmf_summary'", clear
						keep if `groupby' == "`group'"
						if "`workbooks'" ~= "" {
							cap rm "`filename'_`group'.xlsx"
							export excel using "`filename'_`group'.xlsx", first(varl) sheet("status")
							loc file 	"`filename'_`group'.xlsx"
							loc sheet 	"status"
						}
						else {
							export excel using "`outfile'", first(varl) sheet("`group'") sheet("status") sheetreplace
							loc file 	"`outfile'"
							loc sheet 	"`group'"
						}
						
						mata: colwidths("`file'", "`sheet'")
						mata: setheader("`file'", "`sheet'")
						ds, has(format %td) 
						foreach var of varlist `r(varlist)' {
							mata: colformats("`file'", "`sheet'", "`var'", "date_d_mon_yy")
						}
						
						loc ++i
						noi _dots `i' 0
					}
				}

			}
		}
	}	
end