*! version 4.0.0 Innovations for Poverty Action 18apr2022
* ipacheck: Update ipacheck package and initialize new projects

program ipacheck, rclass
	
	version 17
	
	#d;
	syntax 	name, 
			[branch(name)] 
			[surveys(namelist min = 2 max = 10)] 
			[LOCation(string)] 
			[SUBFolders] 
			[FILESonly] 
			[exercise]
			;
	#d cr
	
	if "`namelist'" == "" | !inlist("`namelist'", "new", "version", "update") {
		if "`namelist'" == "" disp as err "missing ipacheck subcommand"
		else 				  disp as err "illegal ipacheck subcommand. Subcommands are:"
		di as txt "    {cmd:ipacheck new} [{it: filepath}]"
		di as txt "    {cmd:ipacheck update} [{it: branch}]"
		di as txt "    {cmd:ipacheck version}"
		ex 198
	}
	if inlist("`namelist'", "update", "version") {
		if "`surveys'" ~= "" {
			disp as error "subcommand `namelist' and surveys option are mutually exclusive"
			ex 198
		}
		if "`location'" ~= "" {
			disp as error "subcommand `namelist' and locations option are mutually exclusive"
			ex 198
		}
		if "`subfolders'" ~= "" {
			disp as error "subcommand `namelist' and subfolders option are mutually exclusive"
			ex 198
		}
		if "`filesonly'" ~= "" {
			disp as error "subcommand `namelist' and files option are mutually exclusive"
			ex 198
		}
		if "`exercise'" ~= "" {
			disp as error "subcommand `namelist' and exercise option are mutually exclusive"
			ex 198
		}
 	}
	
	loc url 	= "https://raw.githubusercontent.com/PovertyAction/ipa_dms4.0"

	if "`namelist'" == "new" {
		ipacheck_new, surveys(`surveys') location("`location'") `subfolders' `files' url("`url'") 
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
end

program define ipacheck_new
	
	syntax, [surveys(string)] [location(string)] [SUBfolders] [filesonly] [exercise] [branch(name)] url(string)
	
	loc branch 	= cond("`branch'" ~= "", "`branch'", "master") 
	
	if "`location'" == "" {
		loc location "`c(pwd)'"
	}
	if `:word count `surveys'' == 1 & "`subfolders'" != "" {
		disp as err "Option for subfolders is not allowed with only one survey form"
		exit 198
	}
	if "`surveys'" == "" &  "`subfolders'" != "" {
		disp as err "Option for subfolders is not allowed without specifying the surveys option"
		exit 198
	}
	if "`exercise'" == "exercise" & "`surveys'" != "" {
		disp as error "Option for exercise can only be used with the folders option"
		exit 198
	}
	
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
			mata : st_numscalar("exists", direxists("`location'/`f'"))
			if scalar(exists) == 1 {
				noi disp "{red:Skipped}: Folder `f' already exists"
			}
			else {
				mkdir "`location'/`f'"
				noi disp "Successful: Folder `f' created"
			}
		}
		
		if "`subfolders'" == "subfolders" {
			
			#d;
			loc subs
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
			foreach sub in `surveys' {
				loc sublab = "`i'_`survey'"
				foreach sf in `subs' {
					mata : st_numscalar("exists", direxists("`location'/`sf'/`sublab'"))
					if scalar(exists) == 1 {
						noi disp "{red:Skipped}: Sub-folder `sf' already exists"
					}
					else {
						mkdir "`location'/`sf'/`sublab'"
						noi disp "Successful: Folder `sf'/`sublab' created"
					}
				}
				loc ++i
			}
		}
	}
		
	noi disp
	noi disp "Copying files to `location'/02_dofiles ..."
	noi disp
	
	foreach file in 0_master 1_globals 3_prep 4_hfcs {
		cap confirm file "`location'/2_dofiles/`file'.do"
		if _rc == 601 {
			disp as err "{red:Skipped}: File `file' already exists"
		}
		else {
			copy "`url'/`branch'/do/0_master.do" "`location'/2_dofiles/0_master.do"
		}
	}
	
	noi disp
	noi disp "Copying files to `location'/3_checks/1_inputs ..."
	noi disp
	
	foreach file in hfc_inputs corrections specifyrecode {
		cap confirm file "`location'/3_checks/1_inputs/`file'.xlsm"
		if _rc == 601 {
			disp as err "{red:Skipped}: File `file' already exists"
		}
		else {
			copy "`url'/`branch'/excel/`file'.xlsm" "`location'/3_checks/1_inputs/`file'.xlsm"
		}
	}

end