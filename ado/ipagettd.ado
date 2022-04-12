*! version 4.0.0 Innovations for Poverty Action 18apr2020
* ipagettd: Convert datetime vars to %td

program define ipagettd
	
	syntax varname
	
	tempvar tmv_date
	
	qui {
		* datevar: format datevar in %td format
		if lower("`:format `varlist''") == "%tc"	{
			gen `tmv_date' = dofc(`varlist'), after(`varlist')
			format %td `tmv_date'
			drop `varlist'
			ren `tmv_date' `varlist'
		}
		else if lower("`:format `varlist''") ~= "%td" {
			disp as err `"variable `varlist' is not a date or datetime variable"'
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			noi list `varlist' in 1/`limit'
		}
	}
end