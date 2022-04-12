*! version 4.0.0 Innovations for Poverty Action 18apr2020
* ipalabels: Removes values or value labels from labelled vars

program define ipalabels
	
	syntax varlist [, NOLABel]
	
	tempvar tmv_varlb
	
	qui {
		foreach var of varlist `varlist' {
			cap confirm numeric var `var'
			if !_rc {
				loc vallab "`:val lab `var''"
				if "`vallab'" ~= "" & "`nolabel'" ~= "" {
					_strip_labels `var'
				}
				else if "`vallab'" ~= "" & "`nolabel'" == "" {
					cap drop `_varlb'
					decode `var', gen (`tmv_varlb')
					order `tmv_varlb', after(`var')
					drop `var'
					ren `tmv_varlb' `var'
				}
			}
		}
	}
	
end