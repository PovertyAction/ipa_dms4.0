*! version 4.0.0 11may2022
*! Innovations for Poverty Action
* ipagetcal: Generate date calendar data

program define ipagetcal 

	syntax varname, clear
	
	* temp var
	tempvar tmv_date
	
	ipagettd `varlist'	
	
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