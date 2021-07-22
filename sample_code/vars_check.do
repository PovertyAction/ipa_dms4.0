* sample missing check

clear all
frames reset
frames create missing str32 variable str80 label double (missing_cnt missing_perc unique_cnt) byte important_var

use "X:\Box\DM Setup Support\tracta\05_data\02_survey\tractor_baseline_full_farmer_prepped.dta", clear

foreach var of varlist _all {
	qui count if missing(`var')
	loc missing_cnt `r(N)'
	qui tab `var'
	loc unique_cnt `r(r)'
	loc important_var = runiform() <= 0.1 
	frames post missing ("`var'") ("`:var lab `var''") (`missing_cnt') (`missing_cnt'/`=_N') (`unique_cnt') (`important_var')
}

frames missing {
	label define yesno 0 "No" 1 "Yes"
	label var important_var yesno
	gsort -important_var -missing_perc -missing_cnt variable
	export excel using "var_check.xlsx", first(var) replace sheet(missing)
}


gen subdate = dofc(submissiondate), after(submissiondate)
drop submissiondate
ren subdate submissiondate
format %td submissiondate

keep submissiondate respondent_id enumerator_id *_cost_* district

order submissiondate respondent_id, first

loc i 1
foreach var of varlist *_cost_* {
	loc var`i'_name "`var'"
	loc var`i'_lab "`:var lab `var''"
	ren `var' value`i'
	loc ++i
}

gen reshape_id = _n

reshape long value, i(reshape_id) j(index)
gen variable = ""
gen label = ""

forval i = 1/6 {
	replace variable 	= "`var`i'_name'"
	replace label 		= "`var`i'_lab'"
}

levelsof respondent_id, loc(ids) clean
foreach id in `ids' {
	replace respondent_id = `=runiformint(1000, 9999)' if respondent_id == `id' 
}

drop if missing(value)
drop reshape_id index

bys variable district: egen value_min = min(value)
bys variable district: egen value_max = max(value)
bys variable district: egen value_mean = mean(value)
bys variable district: egen value_median = median(value)
bys variable district: egen p25 = pctile(value), p(25)
bys variable district: egen p75 = pctile(value), p(75)
bys variable district: egen iqr = iqr(value)

gen range_min = p25 - (1.5 * iqr) 
gen range_max = p75 + (1.5 * iqr) 

keep if !inrange(value, range_min, range_max)

gen group_variable = "district"
gen group_value = district

drop district p25 p75 
order submissiondate respondent_id enumerator_id variable label value group_variable group_value value_min value_max value_mean value_median iqr range_min range_max

export excel using "var_check.xlsx", first(var) sheet(outlier)
