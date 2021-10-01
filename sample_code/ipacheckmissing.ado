*! version 4.0.0 Innovations for Poverty Action 27jul2020

program ipacheckmissing, rclass
	
	* This program collates and list all other values specified.
	version 17

	#d;
	syntax 	[varlist] [using],
        	[IMPortantvars(varlist)] 
        	OUTFile(string)
        	[show(string)]
        	[OUTSheet(string)]  
			[SHEETMODify SHEETREPlace]
		;	
	#d cr

	qui {
		* set frame for writing results
		#d;
		frames 	create 	missing 
				str32  	variable 
				str80 	label 
				double  (missing_cnt missing_perc unique_cnt) 
				byte    important_var
			;
		#d cr

		* check that specified show is not greater than 100% if specified in %
		if "`show'" ~= "" {
			if regexm("`show'", "%") {
				loc show_val = real(subinstr("`show'", "%", "", .))/100
				if `show_val' > 1 {
					dis as err "option show(`show') cannot be higher than 100%. Use a lower percentage or use an absolute number."
					ex 198
				}
			}
		}
		else loc show_val = 0

		* check that varlist | using is specified
		if mi("`varlist'") & mi("`using'") {

			disp as err `"varlist or using is required"'
			ex 198
		}

		* assume default if outsheet is not specified
		if "`outsheet'" == "" loc outsheet "missing"

		* check that using and importantvars are not specified together
		if !mi("`using'") & !mi("`important'") {
			
			disp as err `"using() and options importantvars() are mutually exclusive"'
			ex 198
		}

		* get a list if important vars
		if !mi("`importantvars'") unab importantvars: `importantvars'

		* get an unabbrev list of varlist
		unab vars: `varlist'

		* get a unique list of vars to check
		loc vars: list vars | importantvars

		foreach var of varlist `vars' {
			qui count if missing(`var')
			loc missing_cnt `r(N)'
			qui tab `var'
			loc unique_cnt `r(r)'
			if !missing("`importantvars'") loc important_var: list var in importantvars
			frames post missing ("`var'") ("`:var lab `var''") (`missing_cnt') (`missing_cnt'/`=_N') (`unique_cnt') (`important_var')
		}

		frames missing {
			label define yesno 0 "No" 1 "Yes"
			label var important_var yesno
			
			* apply show option
			if regexm("`show'", "%") {
				drop if float(missing_perc) < float(`show_val')
			}
			else drop if missing_cnt < `show'
			
			gsort -important_var -missing_perc -missing_cnt variable
			export excel using "`outfile'", first(var) replace sheet("`outsheet'")
		}
	}
	
end
