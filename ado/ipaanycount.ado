*! version 4.0.0 Innovations for Poverty Action 18apr2022
* ipaanycount: Count occurances of numeric & string values in varlist

program define ipaanycount
	
	syntax varlist, GENerate(name) [NUMval(numlist missingokay) STRval(string)]
	

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
		    replace `generate' = `generate' + 1 if trim(itrim(`var')) == "`strval'" | ///
											regexm(trim(itrim(`var')), "^`strval' | `strval' | `strval'")
		}
		else if !missing("`numval'") {
		    replace `generate' = `generate' + 1 if `var' == `numval'
		}
	}
	
end