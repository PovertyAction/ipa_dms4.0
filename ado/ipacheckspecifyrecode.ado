*! version 4.0.0 Innovations for Poverty Action 18apr2022
* ipacheckspecifyrecode: Recode other specify

program define ipacheckspecifyrecode, rclass
	
	#d;
	syntax using/, 
			[SHEETname(string)]
			parent(name) 
			child(name) 
			MATCHType(name) 
			MATCHText(name) 
			RECODEFrom(name)
			RECODETo(name)
			NEWLabel(string)
			id(varname)
			[KEEPvars(varlist)]
			[LOGFile(string)]
			[LOGSheet(string)]
			[NOLABel]
		;
	#d cr
	
	cap version 17 

	qui {
	    
		preserve
		
		tempvar tmv_modified tmv_oldval tmv_newval tmv_oldval_lab tmv_newval_lab
		
		tempfile tmf_main_data tmf_recodelog
		
		save "`tmf_main_data'", replace
		
		clear
		save "`tmf_recodelog'", emptyok
				
		* Get file extension
		loc ext = substr("`using'", -(strpos(reverse("`using'"), ".")), .)
		* if extension is valid, import data
		if "`ext'" == ".xlsx" | "`ext'" == ".xls" | "`ext'" == ".xlsm" {
		    if "`sheetname'" == "" {
			    disp as err "sheetname option required with .xlsx, .xls or .xlsm files"
				ex 198
			}
			import excel using "`using'", sheet("`sheetname'") firstrow clear
		}
		else if "`ext'" == ".csv" {
			import delim using "`using'", clear varnames(1)
		}
		else {
		    cap use "`using'", clear
			if _rc == 601 {
			    di as err "file `using' not found""
				ex 609 
			}
		}
		
		if "`logfile'" ~= "" & "`logsheet'" == "" {
		    disp as err "option logsheet required with option logfile"
			ex 198
		}
		
		* Clean data and check for errors
		keep if !missing(`parent') & !missing(`child')
		loc recode_cnt `c(N)'
		if `recode_cnt' > 0 {
		    foreach var of varlist `parent' `child' `matchtype' `matchtext' `recodefrom' {
			    cap confirm string var `var'
				if _rc == 7 {
					tostring `var', replace
				}
				
				cap assert !missing(`var')
				if _rc == 9 {
				    disp as err "`var' should never be missing"
					noi list if missing(`var')
					ex 9
				}
			}
			
			tostring `newlabel', replace	
			
			replace `matchtext' = 	"^" + `matchtext' if `matchtype' == "begins with"
			replace `matchtext' = 	`matchtext' + "$" if `matchtype' == "ends with" 
			
			cap frame drop frm_recode
			frame put *, into(frm_recode)
			
			use "`tmf_main_data'", clear
			
			* expand keepvars
			if "`keepvars'" ~= "" unab keepvars: `keepvars'
			
			gen `tmv_modified' 	= 0
			gen `tmv_oldval'   	= ""
			gen `tmv_newval'		= ""
			forval i = 1/`recode_cnt' {
				
				frame frm_recode {
				    loc pvars 	= `parent'[`i']
					loc cvars 	= `child'[`i']
					loc vfrom 	= `recodefrom'[`i']
					loc vto		= `recodeto'[`i']
					loc mtype 	= `matchtype'[`i']
					loc mtext 	= `matchtext'[`i']
					loc nlab 	= `newlabel'[`i']
				}
	
				unab pvars: `pvars'				
				unab cvars: `cvars'
				
				if wordcount("`pvars'") ~=  wordcount("`cvars'") {
					disp as err "number of vars specified in parent (`parent') does not" , 	///
								"does not match the number of vars specified in ", 			///
								"child (`child') on row `=`i'+1'"
								
					noi disp "{p}parent vars: `pvars'{p_end}"
					noi disp
					noi disp "{p}child vars: `cvars'{p_end}" 
					ex 198
				}
				
				loc p_cnt = wordcount("`pvars'")
				forval j = 1/`p_cnt' {
				    loc pvar = word("`pvars'", `j')
					loc cvar = word("`cvars'", `j')
					
					count if !missing(`cvar')
					if `r(N)' > 0 {
						replace `tmv_modified' = 0	
					    cap confirm string var `pvar'
						if !_rc {
							replace `tmv_oldval' = `pvar'
						    replace `pvar' = trim(itrim(`pvar'))
							replace `pvar' = "//" + subinstr(`pvar', " ", "//", .)   + "//"
							if "`mtype'" == "exact" {	
								replace `tmv_modified' = 1 if `cvar' == "`mtext'"
								replace `pvar' = subinstr(`pvar', "//`vfrom'//", "//`vto'//", 1) ///
									if `cvar' == "`mtext'"
							}
							else {
								replace `tmv_modified' = 1 if regexm(`cvar', "`mtext'")
								replace `pvar' = subinstr(`pvar', "//`vfrom'//", "//`vto'//", 1) ///
									if regexm(`cvar', "`mtext'")
							}
															
							replace `pvar' = subinstr(`pvar', "//", " ", .)	
							replace `tmv_newval' = `pvar'						
						}
						else {
							loc plab "`:val lab `pvar''"
							cap drop `tmv_oldval_lab'
							if "`plab'" ~= "" decode `pvar', gen(`tmv_oldval_lab')
							else gen `tmv_oldval_lab' = ""
							replace `tmv_oldval' = string(`pvar')
							if "`mtype'" == "exact" {
								replace `tmv_modified' = 1 if `cvar' == "`mtext'"
								recode `pvar' (`vfrom' = `vto') if `cvar' == "`mtext'"
							}
							else {
								replace `tmv_modified' = 1 if regexm(`cvar', "`mtext'")
								recode `pvar' (`vfrom' = `vto') if regexm(`cvar', "`mtext'")
							}
							
							if "`nlab'" ~= "" {
								loc n_vlab = "`:val label `pvar''"
								if "`n_vlab'" ~= "" {
									lab define `n_vlab' `vto' "`nlab'", modify
								}
							}
							
							cap drop `tmv_newval_lab'
							if "`plab'" ~= "" decode `pvar', gen(`tmv_newval_lab')
							else gen `tmv_newval_lab' = ""
							replace `tmv_newval' = string(`pvar')
						}
						
						count if `tmv_modified'
						if `r(N)' > 0 {
							cap frames drop frm_recodelog
							frames put `id' `keepvars' `tmv_oldval' `tmv_oldval_lab' `tmv_newval' `tmv_newval_lab' `pvar' `cvar' if `tmv_modified', into(frm_recodelog)
							replace `cvar' = "" if `tmv_modified'
							
							frame frm_recodelog {
								ren (`tmv_oldval' `tmv_oldval_lab' `tmv_newval' `tmv_newval_lab' `cvar') ///
									(`recodefrom' `recodefrom'_lab `recodeto' `recodeto'_lab `matchtext')
								gen `parent' = "`pvar'"
								gen `parent'_lab = "`:var label `pvar''"
								gen `child'  = "`cvar'"
								gen `child'_lab = "`:var label `matchtext''"
								loc vallab "`:val lab `pvar''"
								drop `pvar'
								
								append using "`tmf_recodelog'"
								save "`tmf_recodelog'", replace
								
								loc recoded `c(N)'
							}
						}
					}
				}
			}
			
			if "`logfile'" ~= "" {
				use "`tmf_recodelog'", clear	
				
				if `c(N)' > 0 {
					order `id' `keepvars' `parent' `parent'_lab `child' `child'_lab `matchtext' `recodefrom' `recodefrom'_lab `recodeto' `recodeto'_lab
				
					foreach var of varlist `id' `keepvars' `parent' `child' `matchtext' `recodefrom' `recodeto' {
						lab var `var' "`var'"
					}
					foreach var of varlist `parent' `child' `recodefrom' `recodeto' {
						lab var `var'_lab "`var' label"
					}
					
					if "`keepvars'" ~= "" ipalabels `id' `keepvars', `nolabel'
					
					export excel using "`logfile'", sheet("`logsheet'") first(varl) replace
					mata: colwidths("`logfile'", "`logsheet'")
					mata: setheader("`logfile'", "`logsheet'")
				}
			}
		}
		else {
			loc recoded `c(N)'
		}
		
		return local N_recoded = `recoded'
		
	}
end