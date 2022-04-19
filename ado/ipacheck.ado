*! version 4.0.0 Innovations for Poverty Action 18apr2022
* ipacheck: Update ipacheck package and initialize new projects

program ipacheck, rclass
	
	version 17
	
	#d;
	syntax 	name, 
			[branch(name)] 
			[surveys(namelist min = 2 max = 10)] 
			[DIRectory(string)] 
			[SUBfolders] 
			[FILESonly] 
			[exercise]
			;
	#d cr
	
	if "`namelist'" == "" | !inlist("`namelist'", "new", "version", "update", "exercise") {
		if "`namelist'" == "" disp as err "missing ipacheck subcommand"
		else 				  disp as err "illegal ipacheck subcommand. Subcommands are:"
		di as txt 	"{cmd:ipacheck new}"
		di as txt 	"{cmd:ipacheck update}"
		di as txt 	"{cmd:ipacheck version}"
		di as txt 	"{cmd:ipacheck exercise}"
		ex 198
	}
	if inlist("`namelist'", "update", "version") {
		if "`surveys'" ~= "" {
			disp as error "subcommand `namelist' and surveys options are mutually exclusive"
			ex 198
		}
		if "`directory'" ~= "" {
			disp as error "subcommand `namelist' and directory options are mutually exclusive"
			ex 198
		}
		if "`subfolders'" ~= "" {
			disp as error "subcommand `namelist' and subfolders options are mutually exclusive"
			ex 198
		}
		if "`filesonly'" ~= "" {
			disp as error "subcommand `namelist' and files options are mutually exclusive"
			ex 198
		}
		if "`exercise'" ~= "" {
			disp as error "subcommand `namelist' and exercise options are mutually exclusive"
			ex 198
		}
 	}
	else if "`namelist'" == "exercise" {
		if "`surveys'" ~= "" {
			disp as error "subcommand `namelist' and surveys options are mutually exclusive"
			ex 198
		}
		if "`subfolders'" ~= "" {
			disp as error "subcommand `namelist' and subfolders options are mutually exclusive"
			ex 198
		}
		if "`filesonly'" ~= "" {
			disp as error "subcommand `namelist' and files options are mutually exclusive"
			ex 198
		}
	}
	else if "`namelist'" == "new" {
		if "`surveys'" == "" & "`subfolders'" ~= "" {
			disp as err "subfolders option & survey options must be specified together"
			ex 198
		}
		if "`exercise'" ~= "" {
			if "`subfolders'" ~= "" {
				disp as err "exercise and subfolders options are mutually exclusive"
				ex 198
			}
			if "`filesonly'" ~= "" {
				disp as err "exercise and filesonly options are mutually exclusive"
				ex 198
			}
		}
	}
	
	loc url 	= "https://raw.githubusercontent.com/PovertyAction/ipa_dms4.0"

	if "`namelist'" == "new" {
		ipacheck_new, surveys(`surveys') directory("`directory'") `subfolders' `filesonly' url("`url'") branch(`branch')
		ex
	}
	else {
		ipacheck_`namelist', branch(`branch') url(`url')
		ex
	}
	
end

program define ipacheck_update
	
	syntax, [branch(name)] url(string)
	loc branch 	= cond("`branch'" ~= "", "`branch'", "master")
	net install ipacheck, replace from("`url'/`branch'")
	qui do "`url'/`branch'/do/ipacheckmata.do"
	noi disp "Mata library lipadms installed"
	noi mata mata mlib index
	
end

program define ipacheck_version
	
	#d;
	local 	programs          
			ipacheckcorrections	
			ipacheckspecifyrecode
			ipacheckversions
			ipacheckids
			ipacheckdups
			ipacheckmissing
			ipacheckoutliers
			ipacheckspecify
			ipacheckcomments
			ipachecktextaudit
			ipachecktimeuse
			ipachecksurveydb
			ipacheckenumdb
			ipatracksurvey
			ipacodebook
			ipaimportsctomedia
			ipalabels
			ipagettd
			ipagetcal
			ipaanycount
		
		;
	#d cr

	foreach prg in `programs' {
		cap which `prg'
		if !_rc {
			mata: get_version("`c(sysdir_plus)'i/`prg'.ado")
		}
	}
	
end

mata: 
void get_version(string scalar program) {
	real scalar fh
	
    fh = fopen(program, "r")
    line = fget(fh)
    printf("  " + program + "\t\t%s\n", line) 
    fclose(fh)
}
end

program define ipacheck_new
	
	syntax, [surveys(string)] [directory(string)] [SUBfolders] [filesonly] [exercise] [branch(name)] url(string)
	
	loc branch 	= cond("`branch'" ~= "", "`branch'", "master") 
	
	if "`directory'" == "" {
		loc directory "`c(pwd)'"
	}
	
	loc surveys_cnt = wordcount("`surveys'")
	
	if "`filesonly'" == "" {
		#d;
		loc folders 
			""0_archive"
			"1_instruments"
				"1_instruments/1_paper"
				"1_instruments/2_scto_print"
				"1_instruments/3_scto_xls"
			"2_dofiles"
			"3_checks"
				"3_checks/1_inputs"
				"3_checks/2_outputs"	
			"4_data"
				"4_data/1_preloads"
				"4_data/2_survey"
				"4_data/3_backcheck"
				"4_data/4_monitoring"
			"5_media"
				"5_media/1_audio"
				"5_media/2_images"
				"5_media/3_video"
			"6_documentation"
			"7_field_manager"
			"8_reports""
			;
		#d cr
		
		noi disp
		noi disp "Setting up folders ..."
		noi disp

		foreach f in `folders' {
			mata : st_numscalar("exists", direxists("`directory'/`f'"))
			if scalar(exists) == 1 {
				noi disp "{red:Skipped}: Folder `f' already exists"
			}
			else {
				mkdir "`directory'/`f'"
				noi disp "Successful: Folder `f' created"
			}
		}
		
		if "`subfolders'" == "subfolders" {
			
			#d;
			loc sfs
				""3_checks/1_inputs"
				"3_checks/2_outputs"
				"4_data/1_preloads"
				"4_data/2_survey"
				"4_data/3_backcheck"
				"4_data/4_monitoring"
				"5_media/1_audio"
				"5_media/2_images"
				"5_media/3_video""
				;
			#d cr
			
			noi disp
			noi disp "Creating subfolders ..."
			noi disp
			loc i 1
			
			foreach survey in `surveys' {
				loc sublab = "`i'_`survey'"
				foreach sf in `sfs' {
					mata : st_numscalar("exists", direxists("`directory'/`sf'/`sublab'"))
					if scalar(exists) == 1 {
						noi disp "{red:Skipped}: Sub-folder `sf' already exists"
					}
					else {
						mkdir "`directory'/`sf'/`sublab'"
						noi disp "Successful: Folder `sf'/`sublab' created"
					}
				}
				loc ++i
			}
		}
	}
	
	loc exp_dir "`directory'"
		
	noi disp
	noi disp "Copying files to `exp_dir' ..."
	noi disp
	
	cap confirm file "`exp_dir'/0_master.do"
	if _rc == 601 {
		copy "`url'/`branch'/do/0_master.do" "`exp_dir'/0_master.do"
		disp "0_master.do copied to `exp_dir'"
	}
	else {
		disp  "{red:Skipped}: File 0_master.do already exists"
	}
	
	if "`filesonly'" == "" 	loc exp_dir "`directory'/2_dofiles"
	else 					loc exp_dir "`directory'"
	
	foreach file in 1_globals 3_prep 4_hfcs {
		if `surveys_cnt' > 0 {
			forval i = 1/`surveys_cnt' {
				loc exp_file = "`file'_" + word("`surveys'", `i')
				cap confirm file "`exp_dir'/`exp_file'.do"
				if _rc == 601 {
					copy "`url'/`branch'/do/`file'.do" "`exp_dir'/`exp_file'.do"
					disp "`exp_file'.do copied to `exp_dir'"
				}
				else {
					disp  "{red:Skipped}: File `file'.do already exists"
				}
			}
		}
		else {
			cap confirm file "`exp_dir'/`file'.do"
			if _rc == 601 {
				copy "`url'/`branch'/do/`file'.do" "`exp_dir'/`file'.do"
				disp "`file'.do copied to `exp_dir'"
			}
			else {
				disp  "{red:Skipped}: File `file'.do already exists"
			}
		}
	}
	
	if "`filesonly'" == "" 	loc exp_dir "`directory'/3_checks/1_inputs"
	else 					loc exp_dir "`directory'"
	
	noi disp
	noi disp "Copying files to `directory'/3_checks/1_inputs ..."
	noi disp
	
	foreach file in hfc_inputs corrections specifyrecode {
		if `surveys_cnt' > 0 {
			forval i = 1/`surveys_cnt' {
				loc exp_file = "`file'_" + word("`surveys'", `i')
				loc exp_dirmult  = cond("`subfolders'" == "", "`exp_dir'", "`exp_dir'/`i'_" + word("`surveys'", `i'))
				cap confirm file "`exp_dirmult'/`exp_file'.xlsm"
				if _rc == 601 {
					copy "`url'/`branch'/excel/`file'.xlsm" "`exp_dirmult'/`exp_file'.xlsm"
					disp "`exp_file'.xlsm copied to `exp_dirmult'"
				}
				else {
					disp "{red:Skipped}: File `file' already exists"
				}
			}
		}
		else {
			cap confirm file "`exp_dir'/`file'.xlsm"
			if _rc == 601 {
				copy "`url'/`branch'/excel/`file'.xlsm" "`exp_dir'/`file'.xlsm"
				disp "`file'.xlsm copied to `exp_dir'"
			}
			else {
				disp "{red:Skipped}: File `file' already exists"
			}
		}
	}

end
