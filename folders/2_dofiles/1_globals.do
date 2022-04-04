********************************************************************************
** 	TITLE	: 1_globals.do
**
**	PURPOSE	: Globals do-file
**				
**	AUTHOR	: 
**
**	DATE	: 
********************************************************************************

**# Run/Turn Off Specific Checks
*------------------------------------------------------------------------------*


	* NB: Edit this section: Change value to 0 to turn off specific checks
	
	gl run_version		1	//	Check for outdate survey form versions
	gl run_ids			1	//	Check Survey ID for duplicates
	gl run_dups			1	//	Check other Survey variables for duplicates
	gl run_missing		1	//	Check variable missingness
	gl run_outlier		1	//	Check numeric variables for outliers
	gl run_specify		1	//	Check for other specify values
	gl run_comments		1	//	Collate and output field comments
	gl run_textaudit	1	//	Check Survey duration using text audit data
	gl run_timeuse		1	//	Check active survey hours using text audit data
	gl run_surveydb		1	//	Create survey Dashboard
	gl run_enumdb		1	//	Create enumerator Dashboard
	gl run_track		1	// 	Report on survey progress	
	
**# Inputs
*------------------------------------------------------------------------------*
	
	gl inputfile			"$cwd/3_checks/1_inputs/hfc_inputs.xlsm"			// HFC inputs file
	gl corrfile 			"$cwd/3_checks/1_inputs/corrections.xlsm"			// Corrections
	
**# Datasets
*------------------------------------------------------------------------------*
	
	gl rawdata 				"${cwd}/4_data/2_survey/WB Nutrition Project - Household Survey" 	// Raw Survey Data
	gl preppeddata			"${cwd}/4_data/2_survey/wb_hhs_prepped"								// Prepped Survey Data
	gl checkeddata			"${cwd}/4_data/2_survey/wb_hhs_checked"								// Post HFC de-duplicated dataset
	
	gl masterdata 			""													// Master Dataset containing respondent information
	gl trackingdata 		"${cwd}/4_data/1_preloads/tracking_data.xlsx"		// Tracking Dataset containing target respondents per group
	
**# SurveyCTO media folder
*------------------------------------------------------------------------------*
	
	gl media_folder 		"$cwd/4_data/2_survey/media"						// Folder containing SurveyCTO text audit/comments files
	
**# Output files
*------------------------------------------------------------------------------*
	
	gl folder_date			= string(year(today())) + "-`:disp %tdNN today()'-`:disp %tdDD today()'"
	cap mkdir				"$cwd/3_checks/2_outputs/$folder_date"

	gl id_dups_output 		"$cwd/3_checks/2_outputs/$folder_date/survey_duplicates.dta"	// [.dta] Raw Duplicates file 
	gl hfc_output			"$cwd/3_checks/2_outputs/$folder_date/hfc_output.xlsx"			// HFCs Output file
	gl textaudit_output 	"$cwd/3_checks/2_outputs/$folder_date/textaudit.xlsx"			// Text Audit Output
	gl timeuse_output		"$cwd/3_checks/2_outputs/$folder_date/timeuse.xlsx"				// Time Use Output
	gl surveydb_output		"$cwd/3_checks/2_outputs/$folder_date/surveydb.xlsx"			// Surveyor Dashboard Output
	gl enumdb_output		"$cwd/3_checks/2_outputs/$folder_date/enumdb.xlsx"				// Enumerator Dashboard Output
	gl tracking_output      "$cwd/3_checks/2_outputs/$folder_date/tracking.xlsx"			// Tracking Output

**# Admin variables
*------------------------------------------------------------------------------*
	
	gl key					"key"												// Unique key
	gl id 					"hhid"												// Survey ID
	gl enum					"enum_name"											// Enumerator variable
	gl team 				""													// Team Variable
	gl date					"starttime"											// Date Variable (date or datetime variable)
	gl starttime 			"starttime"											// Starttime Variable (datettime variable)
	gl duration				"duration"											// duration (numeric variable) 
	gl formversion 			"formdef_version"									// formversion variable (numeric variable)
	gl fieldcomments 		"field_comments"									// SurveyCTO field comments variable
	gl textaudit 			"textaudit"											// SurveyCTO text audit variable
	gl keepvars 			""													// Global keep variables
	gl consent 				"consent"											// Consent Variable
	gl outcome 				"outcome"											// Survey outcome variable
	
**# Missing values
*------------------------------------------------------------------------------*	
	
	gl consent_vals			"1"													// space seperated list of values indicating consent
	gl outcome_vals 		"1 2"												// space seperated list of outcome variables indicating completeness
	gl dontknow_num 		"-999 999"											// space seperated list of num don't know values
	gl dontknow_str 		"-999"												// space seperated list of string don't know values
	gl refuse_num			"-888 888"											// space seperated list of num refuse values											
	gl refuse_str			"-888"												// space seperated list of str refuse values	
	
	
/* ============================================================================= 
   =========================== Additional Options ============================== 
   ============================================================================= */ 	
	
**# Form Versions
*------------------------------------------------------------------------------*
	
	gl vers_keepvars		""														// Additional variables to keep

**# ipacheckids
*------------------------------------------------------------------------------*
	
	gl ids_keepvars			""													// additional keep variables

**# ipacheckdups
*------------------------------------------------------------------------------*

	gl dups_vars			"gpslatitude gpslongitude"							// variables to check
	gl dups_keepvars		""													// additional keep variables

**# ipacheckmissing
*------------------------------------------------------------------------------*
	
	gl miss_vars	 		"_all"												// variables to check		
	gl miss_imp_vars		""													// important variables: Will show at the top of output	
	
**# ipacheckspecify
*------------------------------------------------------------------------------*

	* NB: Set-up this check in the input file

**# ipacheckcomments
*------------------------------------------------------------------------------*
	
	gl comm_save 			"$cwd/4_data/2_survey/fieldcomments_data.dta"		// filename for saving appended comments files
	
**# ipachecktextaudit
*------------------------------------------------------------------------------*
	
	gl ta_save 				"$cwd/4_data/2_survey/textaudit_data.dta"			// filename for saving appended text audit files
	gl ta_stats 			"count min max mean sd iqr p25 p50 p75"				// Statistics to show per field

**# ipachecktimeuse
*------------------------------------------------------------------------------*

	* NB: No additional setup required

**# ipachecksurveydb
*------------------------------------------------------------------------------*
	
	gl sdb_period  			"auto"												// Interval for showing productivity (daily, weekly, monthly, auto)
	gl sdb_byvar 			"phu"												// variable for disaggregating survey statictics 
	gl sdb_osp_vars 		"*osp*"												// Other specify child variables
	
**# ipacheckenumdb
*------------------------------------------------------------------------------*

	gl enumdb_period        "auto"												// Interval for showing enum productivity (daily, weekly, monthly, auto)
	gl enumdb_osp_vars 		"*osp*"												// Other specify child variables


**# ipatracksurveys
*------------------------------------------------------------------------------*
	
	gl track_groupby 			"phu"											// Group variable for survey tracking
	gl track_target 			"target"										// Target variable in tracking data
	gl track_keepmaster			"phu ea_shortcode"								// variables to keep in master data
	gl track_keeptracking		"phu ea_shortcode treatment_status"				// variables to keep in tracking data
	gl track_keepsurvey 		"startdate enddate enum_name"					// variables to keep in survey dataset
	gl track_summaryonly 		"summaryonly"									// indicate "summaryonly" to show summary sheet only
	gl track_workbooks 			"workbooks"										// indicate "workbooks" to show tracking sheets for groups as seperate books. This is required if values in groupby is more than 30
	gl track_surveyok 			"surveyok"										// indidate "surveyok" to show allow ids/groups in survey data only

