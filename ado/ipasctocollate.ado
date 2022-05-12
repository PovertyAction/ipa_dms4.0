*! version 4.0.0 Innovations for Poverty Action 25apr2022
* ipacheckcomments: Collate & export field comments

program ipaimportsctomedia, rclass
	
	#d;
	syntax name varname,
			FOLDer(string)
			save(string)
			[replace]
		;
	#d cr
		
	qui {
		
		preserve
	    
		* tempfiles
		tempfile tmf_media
		
		* keep only relevant variables and observations
		keep `varlist' `keepvars'
		keep if !missing(`varlist')
		
		cap assert(inlist("`namelist'", "comments", "textaudit"))
		if _rc == 9 {
		    disp as err "`namelist' invalid media type. Specify comments or textaudit"
		}
		
		loc obs_cnt `c(N)' 
		
		loc fail_cnt	0
		loc succ_cnt    0
		
		if `obs_cnt' > 0 {
		 
			* extract id from media file
			* check if data was downloaded from browser or api | from desktop
			cap assert regexm(`varlist', "^https")
			if !_rc {
			    * browser or API 
			    replace `varlist' = substr(`varlist', strpos(`varlist', "uuid:") + 5, ///
							strpos(`varlist', "&e=") - strpos(`varlist', "uuid:") - 5)
							
				if "`namelist'" == "comments" {
				    replace `varlist' = "Comments-" + `varlist'
				}
				else {
				    replace `varlist' = "TA_" + `varlist'
				}
			}
			else if regexm(`varlist', "^media") {
			    * surveycto desktop
			    replace `varlist' = substr(`varlist', strpos(`varlist', "media\") + 6, ///
							strpos(`varlist', ".csv") - strpos(`varlist', "media\") - 6)
			}
		
			cap frame drop frm_subset
			frame put `varlist', into(frm_subset)
			
			* check if saving dataset exist and skip already merged files
			cap confirm file "`save'"
			if !_rc {
			    use `varlist' using "`save'", clear
				duplicates drop `varlist', force
				cap frame drop frm_oldmedia
				frame put `varlist', into(frm_oldmedia)
				
				frame frm_subset {
					frlink 1:1 `varlist', frame(frm_oldmedia)
					count if !missing(frm_oldmedia)
					loc olddata_cnt `r(N)'
					loc import_cnt = `c(N)' - `olddata_cnt'
					
					noi disp "skipping `olddata_cnt' files already imported"
					
					drop if missing(frm_oldmedia)
					keep `varlist'
				}
				
				frame drop frm_oldmedia
			}
			else {
			    loc import_cnt `obs_cnt'
				loc olddata_cnt 0
			}
			
			if `import_cnt' > 0 {
				clear
				save "`tmf_media'", emptyok
			
				noi _dots 0, title(Importing `import_cnt' `varlist' files) reps(`import_cnt')
			
				forval i = 1/`import_cnt' {
					frames frm_subset: loc file = `varlist'[`i']
					cap import delim using "`folder'/`file'.csv", clear stringcols(_all) varnames(1)
					if _rc == 601 {
						loc disptype 1
						loc ++fail_cnt
					}
					else {
						gen `varlist' = "`file'"
						append using "`tmf_media'"
						save "`tmf_media'", replace
						
						loc disptype 0
					}
					noi _dots `i' `disptype'
				}

				if `fail_cnt' == `import_cnt'  {
					disp as err _newline "No Comments files in `media'."
					ex 198
				}
				else if `fail_cnt' > 0 {
					disp as err _newline "{cmd:`fail_cnt'} of {cmd:`obs_cnt'} Comments files not found in `media'"
				}
			
				frame drop frm_subset
				
				if `olddata_cnt' > 0 {
					append using "`save'"
				}
				save "`save'", replace
				
			}
			else {
				noi disp "Imported {cmd:0} new files in `varlist'."
			}
		}
		else {
		    noi disp "Found {cmd:0} files in `varlist'."
		}
	} 
	
	return local N_total 		= `obs_cnt'
	return local N_successful	= `succ_cnt'
	return local N_failed  		= `fail_cnt'
end 