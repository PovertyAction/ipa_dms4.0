*! version 4.0.0 BETA 2 Innovations for Poverty Action 04apr2022

program ipacheck, rclass
	/* This is a utility function to help update the ipacheck package
	   and initialize new projects. */
	version 17
	
	syntax name, [branch(name)] [surveys(string)] [LOCation(string)] [SUBFOLDERS] [files] [exercise]
	
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
		if "`files'" ~= "" {
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
		ipachecknew, surveys(`surveys') location("`location'") `subfolders' `files' url("`url'") 
		ex
	}
	else if "`namelist'" == "update" {
		ipacheckupdate, branch(`branch') url(`url')
	}
	else {
		ipacheckversion, branch(`branch') url(`url')
		ex
	}
end

program define ipacheckupdate
	
	syntax, [branch(name)] url(string)
	loc branch 	= cond("`branch'" ~= "", "`branch'", "master")
	net install ipacheck, replace from("`url'/`branch'/package")

end

program define ipachecknew
	
	syntax, [surveys(string)] [location(string)] [SUBfolders] [files] [exercise] [branch(name)] url(string)
	
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
	
	if "`files'" == "files" & "`surveys'" != "" {
		disp as err "Option for files can only be used with the folders option"
		exit 198 	
	}
	
	if "`exercise'" == "exercise" & "`surveys'" != "" {
		disp as error "Option for exercise can only be used with the folders option"
		exit 198
	}
	
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
	
	if "`files'" == "files" {
		noi disp
		noi disp "saving extra files ..."
		noi disp 
		foreach file in 0_master.do 1_globals.do 3_prep.do 4_hfc.do hfc_inputs.xlsm sample_hfc_inputs.xlsm {
			cap confirm file "`location'/`file'"
			if !_rc {
				noi disp "{red:Skipped}: `file' already exists"
			}
			else {
				copy "`url'/`branch'/extras/`file'" "`location'/`file'", replace
			}
		}
	}
		
end




