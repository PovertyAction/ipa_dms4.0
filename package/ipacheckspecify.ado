*! version 4.0.0 Innovations for Poverty Action 27jul2020

program ipacheckspecify, rclass sortpreserve
	
	* This program collates and list all other values specified.
	version 17

	#d ;
	syntax 	[using/],
			[sheetname(string)] 
			[CHILDvars(string)]
			[PARENTvars(varlist)]
	    	outfile(string) 
        	id(varname) 
        	ENUMerator(varname) 
        	DATEvar(varname) 
			[KEEPvars(varlist)] 
			[SHEETMODify SHEETREPlace NOLabel]
		;	
	#d cr

	qui {

		*** preserve data ***
		preserve

		*** create frames ***

		* create frame for choice_list
		#d;
		frames create 	 frm_choice_list
			   str32 	 (variable vartype choice_label) 
			   str80     (value label)
			   double    (frequency percentage)
			   ;
		#d cr	

		*** check syntax ***

		* using, (childvars, parentvars): either is specified
		if mi("`using'") & (mi("`childvars'") | mi("`parentvars'")) {
			disp as err `"using or option childvars()/parentvars() required"'
			ex 198
		}

		* using, (childvars, parentvars,keepvars): are mutually exclusive
		if !mi("`using'") & (!mi("`childvars'") | !mi("`parentvars'") | !mi("`keepvars'")) {
			disp as err `"using() and options childvars(), parentvars() & keepvars() are mutually exclusive"'
			ex 198
		}

		* check that input sheetname is specified with using() option
		if !mi("`using'") & mi("`sheetname'") {
			disp as err `"option sheetname() is required if using is specified"'
			ex 198
		}

		*** inputs sheet: ***

		* get inputs from inputs sheet if using is specified
		if !mi("`using'") {
			
			import excel child=A parent=B keep=D using "`using'", sheet("`sheetname'") clear

			drop in 1
			drop if missing(child) & missing(parent)

			* keep vars
			levelsof keep, loc(keepvars) clean
			if "`keepvars'" ~= "" unab keepvars: `keepvars'

			* get child and parent vars
			keep if !mi(child) | !missing(parent)

			* save number of paires to check
			loc osp_N `=_N'

			*** check for missing child or parent ***
			count if mi(child) | mi(parent)
			if `r(N)' > 0 {
				disp as err "missing child or parent in input sheet"
				gen row = _n + 1

				noi list if mi(child) | mi(parent)
				ex 198
			}

			* save input data into frame and import survey data
			frame copy default frm_inputs
				
			* change to main data
			restore, preserve


			*** create output ***

			* For each pair, check that # of children and parents match after expansion
			forval i = 1/`osp_N' {

				* save and expand locals
				frame frm_inputs: loc child = child[`i']
				unab child : `child'
				
				frame frm_inputs: loc parent = parent[`i']
				unab parent: `parent'

				if wordcount("`child'") ~= wordcount("`parent'") {
					disp as err "number of vars specified in child (`child') does not" , ///
								"does not match the number of vars specified in parent", ///
								"(`parent') on row `=`i'+1'"
					ex 198
				}
				else {
					loc childvars  "`childvars'  `child'"
					loc parentvars "`parentvars' `child'"
				}

				* save full child and parent varlist in local
				loc unab_child  "`unab_child' `child'"
				loc unab_parent "`unab_parent' `parent'"
			}

		}

		else {
			* expand vars and check that the number of child and parent vars match
			unab unab_child : `childvars'
			unab unab_parent: `parentvars'

			if wordcount("`unab_child'") ~= wordcount("`unab_parent'") {
				disp as err "number of vars specified in childvars(`unab_child') does not" , ///
							"does not match the number of vars specified in parentvars(`unab_parent')"
				ex 198
			}

		}
		
		* keep only variables that are needed for check
		keep `id' `enumerator' `datevar' `keepvars' `unab_child' `unab_parent'
		
		loc child_cnt = wordcount("`unab_child'")

		forval i = 1/`child_cnt' {

			* get child and parent vars
			loc c_var = word("`unab_child'", `i')
			loc p_var = word("`unab_parent'", `i')

			* check that child variable has values. If not skip current iteration
			qui count if !missing(`c_var')
			if `r(N)' == 0 {
				drop `p_var' `c_var'
				continue
			}

			* reset list_vals to empty
			loc list_vals ""

			* get levels of parent var.
			* This is to account for values with missing label codes
			qui levelsof `p_var', loc (vals) clean
			loc vals: list uniq vals

			* get parent label
			loc p_var_vallab "`:val lab `p_var''"

			if !mi("`p_var_vallab'") {
				* get values in actual label.
				qui lab list 		`p_var'
					loc list_min  	`r(min)'
					loc list_max  	`r(max)'
					loc list_miss 	`r(hasemiss)'

				* check labels
				if `r(k)' > 2 {
					loc list_vals ""
					forval j = `list_min'/`list_max' {
						if !mi("`:lab `p_var_vallab' `j', strict'") loc list_vals = "`list_vals' `j'"
					}
				}
				else {
					loc list_vals: list list_min | list_max
				}

				* check for possible extended missing values
				if `list_miss' {
					foreach letter in `c(alpha)' {
						count if `p_var' == .`letter'
						if `r(N)' > 0 loc list_vals = "`list_vals' `i'"
					}
				}

				loc list_vals: list vals | list_vals
				loc list_vals: list uniq list_vals

			}

			if mi("`list_vals'") loc list_vals "`vals'"

			cap confirm string var `p_var'
			if !_rc {
				loc p_var_type "str"
			}
			else loc p_var_type "num"

			foreach val in `list_vals' {

				if "`p_var_type'" == "str" {
					qui count if regexm("_" + subinstr(`p_var', " ", "_", .) + "_", "_`val'_")
					loc val_cnt `r(N)'

					loc val_lab ""
				}
				else {
					qui count if `p_var' == `val'
					loc val_cnt `r(N)'
					
					if !mi("`p_var_vallab'") {
						loc val_lab "`:lab `p_var_vallab' `val''"
					}
					else loc val_lab ""

				}

				qui count if !missing(`p_var')
				loc nm_cnt `r(N)'
			
				#d;
				frames post frm_choice_list 
							("`p_var'") 
							("`:type `p_var''")
							("`p_var_vallab'")
							("`val'")
							("`val_lab'") 
							(`val_cnt')
							(`=`val_cnt'/`nm_cnt'')
					;
				#d cr
				
			}

			* save meta information
			loc p_var_name`i' 	"`p_var'"
			loc p_var_lab`i' 	"`:var lab `p_var''"
			loc c_var_name`i' 	"`c_var'"
			loc c_var_lab`i' 	"`:var lab `c_var''"

			* rename vars
			ren `p_var' parent_value`i' 
			ren `c_var' child_value`i'

			_strip_labels parent_value`i'
			tostring parent_value`i', replace

		}

		* drop rows that contain no osp
		egen noosp = rownonmiss(child*), strok
		drop if !noosp
		drop noosp

		gen reshape_id = _n
		reshape long parent_value child_value, i(reshape_id) j(index)

		keep if !missing(child_value)

		gen parent_label = "", before(parent_value)
		gen parent 		 = "", before(parent_label)
		gen child_label  = "", before(child_value)
		gen child 		 = "", before(child_label)

		forval i = 1/`child_cnt' {
			replace parent 			= "`p_var_name`i''" if index == `i'
			replace parent_label 	= "`p_var_lab`i''" if index == `i'
			replace child 			= "`c_var_name`i''" if index == `i'
			replace child_label 	= "`c_var_lab`i''" if index == `i'
		}

		sort parent child child_value `datevar'

		drop reshape_id index

		compress


		* change date to %td before export

		* check that datevar if in %td format. Convert to %tc if td & show error if not datetime format
		if lower("`:format `datevar''") == "%tc"	{
			gen _datevar = dofc(`datevar'), after(`datevar')
			format %td _datevar

			drop `datevar'
			ren _datevar `datevar'
		}
		else if lower("`:format `datevar''") != "%td" {
			disp as err "variable `datevar is not a date or datetime variable'"
			if `=_N' > 5 loc limit = `=_N'
			else 		 loc limit = 5
			list _datevar in 1/`limit'

		}
	

		order `datevar' `id' `enumvar' parent parent_label parent_value child child_label child_value 


		export excel using "`outfile'", sheet("other specify") replace first(var) `nolabel'
		
		mata: colwidths("`outfile'", "other specify")
		mata: add_lines("`outfile'", "other specify", (1, `=_N' + 1), "medium")
		
		frames frm_choice_list {

			gsort variable value
			gen line_index = _n + 1
			bys variable (value): gen line_index_last = _n == _N
			levelsof line_index if line_index_last, loc (indexes) sep(",")
			drop line_index*

			export excel using "`outfile'", sheet("other specify (choice list)") first(var)

			mata: colwidths("`outfile'", "other specify (choice list)")
			mata: colformats("`outfile'", "other specify (choice list)", "percentage", "percent_d2")
			mata: add_lines("`outfile'", "other specify (choice list)", (1, `=_N' + 1), "medium")


			mata: add_lines("`outfile'", "other specify (choice list)", (`indexes'), "thin")

		}

		disp "Found {cmd:`=_N'} total specified values."
		return scalar N_specify = `=_N'

	}

end
