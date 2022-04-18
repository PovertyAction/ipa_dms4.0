*! version 4.0.0 Innovations for Poverty Action 25apr2022
* ipacheckcomments: Collate & export field comments

program ipaimportsctomedia, rclass
	
	#d;
	syntax name,
			MEDIAVar(varname)
			MEDIAFolder(string)
			save(string)
			replace
		;
	#d cr
		
	qui {
		
		preserve
	    
		* tempfiles
		tempfile tmf_media
		
		* keep only relevant variables and observations
		keep `mediavar' `keepvars'
		keep if !missing(`mediavar')
		
		cap assert(inlist("`namelist'", "comments", "textaudit"))
		if _rc == 9 {
		    disp as err "`namelist' invalid media type. Specify comments or textaudit"
		}
		
		loc obs_cnt `c(N)' 
		
		if `obs_cnt' > 0 {
		 
			* extract id from media file
			* check if data was downloaded from browser or api | from desktop
			cap assert regexm(`mediavar', "^https")
			if !_rc {
			    * browser or API 
			    replace `mediavar' = substr(`mediavar', strpos(`mediavar', "uuid:") + 5, ///
							strpos(`mediavar', "&e=") - strpos(`mediavar', "uuid:") - 5)
							
				if "`namelist'" == "comments" {
				    replace `mediavar' = "Comments-" + `mediavar'
				}
				else {
				    replace `mediavar' = "TA_" + `mediavar'
				}
			}
			else if regexm(`mediavar', "^media") {
			    * surveycto desktop
			    replace `mediavar' = substr(`mediavar', strpos(`mediavar', "media\") + 6, ///
							strpos(`mediavar', ".csv") - strpos(`mediavar', "media\") - 6)
			}
		
			cap frame drop frm_subset
			frame put `mediavar', into(frm_subset)
			
			* check if saving dataset exist and skip already merged files
			cap confirm file "`save'"
			if !_rc {
			    use `mediavar' using "`save'", clear
				duplicates drop `mediavar', force
				cap frame drop frm_oldmedia
				frame put `mediavar', into(frm_oldmedia)
				
				frame frm_subset {
					frlink 1:1 `mediavar', frame(frm_oldmedia)
					count if !missing(frm_oldmedia)
					loc olddata_cnt `r(N)'
					loc import_cnt = `c(N)' - `olddata_cnt'
					
					noi disp "skipping `olddata_cnt' files already imported"
					
					drop if missing(frm_oldmedia)
					keep `mediavar'
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
			
				noi _dots 0, title(Importing `import_cnt' `mediavar' files) reps(`import_cnt')
				loc fail_cnt	0 
			
				forval i = 1/`import_cnt' {
					frames frm_subset: loc file = `mediavar'[`i']
					cap import delim using "`mediafolder'/`file'.csv", clear stringcols(_all) varnames(1)
					if _rc == 601 {
						loc disptype 1
						loc ++fail_cnt
					}
					else {
						gen `mediavar' = "`file'"
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
				noi disp "Imported {cmd:0} new files in `mediavar'."
			}
		}
		else {
		    noi disp "Found {cmd:0} files in `mediavar'."
		}
	} 

end 