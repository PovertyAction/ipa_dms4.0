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

* gl Directories:

gl dir_xls				"$cwd/01_instruments/03_xls"
gl dir_do				"$cwd/02_dofiles" 
gl dir_inp				"$cwd/04_checks/01_inputs"	
gl dir_out				"$cwd/04_checks/02_outputs"
*gl dir_track_inp		"$cwd/03_tracking/01_inputs"
gl dir_track_out		"$cwd/03_tracking/02_outputs"
gl dir_survey			"$cwd/05_data/02_survey"
gl dir_bc				"$cwd/05_data/03_bc"
gl dir_master			"$cwd/05_data/01_preloads"
gl dir_mon				"$cwd/05_data/04_monitoring"
gl dir_media			"$cwd/06_media"

gl rawsurveydata 		"$dir_survey/survey_data.dta"
gl bcdata				"$dir_bc/"
gl prepsurveydata		"$dir_survey/survey_data_prep.dta"
gl masterdata			"$dir_master/sample.dta"
gl hfcout				"$dir_out/hfc_outputs.xlsx"
gl trackout 			"$dir_track_out/hfc_tracking.xlsx"
gl textout				"$dir_out/text_audits.xlsx"
gl hfcin				"$dir_inp/hfc_inputs.xlsx"

gl key					key
gl surveyid				id
gl enumid				enumid
gl datevar 				submissiondate
gl versionvar			formdef_version
gl target				500
gl keepvars				age
gl textaudit			""
gl comments				""

* values to recode
gl dontknow "-999"
gl refuse	"-888"
gl na 		"-555"

* variables to change to string
gl strvars 		""

* variables to destring
gl numvars 		""


* progreport specifications
gl sortby "ward"
gl keepmaster "age"

* important variables
gl impvars "gender"

* variables for duplicates
gl dupvars "gpsLatitude"


