*! version 4.0.0 Innovations for Poverty Action 27jul2020
* ipagetcal: Generate date calendar data

program define ipagetcal 

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