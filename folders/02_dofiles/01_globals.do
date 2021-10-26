********************************************************************************
** 	TITLE: 02_globals.do
**
**	PURPOSE: Specify globals for files, folders and variables
**				
**	AUTHOR: 
**
**	CREATED: 
********************************************************************************


* project backup folder
gl dir_backup ""

* gl Directories: DO NOT EDIT

gl dir_xls				"$cwd/01_instruments/03_xls"
gl dir_do				"$cwd/02_dofiles" 
gl dir_inp				"$cwd/04_checks/01_inputs"	
gl dir_out				"$cwd/04_checks/02_outputs"
gl dir_track_inp		"$cwd/03_tracking/01_inputs"
gl dir_track_out		"$cwd/03_tracking/02_outputs"
gl dir_survey			"$cwd/05_data/02_survey"
gl dir_bc				"$cwd/05_data/03_bc"
gl dir_master			"$cwd/05_data/01_preloads"
gl dir_mon				"$cwd/05_data/04_monitoring"
gl dir_media			"$cwd/06_media_encrypted/06_media"

gl rawsurveydata 		"$dir_survey/"
gl bcdata				"$dir_bc/"
gl prepsurveydata		"$dir_survey/"
gl masterdata			"$dir_master/"
gl hfcout				"$dir_out/hfc_outputs.xlsx"
gl trackout 			"dir_track_out/hfc_tracking.xlsx"

gl surveyid				""
gl enumid				""
gl datevar 				""
gl keepvars				""
gl textaudit			""
gl comments				""

* variables to change to string
gl strvars 		""

* variables to destring
gl numvars 		""

* import globals from hfc_inputs -- adjust filename if hfc_inputs file renamed
if $checks ipacheckimport using "$dir_inp/hfc_inputs.xlsm"
