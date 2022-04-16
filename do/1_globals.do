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
	
	gl run_corrections   	1 	//  Apply corrections
	gl run_specifyrecode   	1 	//  Recode other specify
	gl run_version			1	//	Check for outdate survey form versions
	gl run_ids				1	//	Check Survey ID for duplicates
	gl run_dups				1	//	Check other Survey variables for duplicates
	gl run_missing			1	//	Check variable missingness
	gl run_outlier			1	//	Check numeric variables for outliers
	gl run_specify			1	//	Check for other specify values
	gl run_comments			1	//	Collate and output field comments
	gl run_textaudit		1	//	Check Survey duration using text audit data
	gl run_timeuse			1	//	Check active survey hours using text audit data
	gl run_surveydb			1	//	Create survey Dashboard
	gl run_enumdb			1	//	Create enumerator Dashboard
	gl run_tracksurvey		1	// 	Report on survey progress
	
**# Inputs
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change filenames if neccesary
	
	gl inputfile			"${cwd}/3_checks/1_inputs/hfc_inputs.xlsm"			// HFC inputs file
	gl corrfile 			"${cwd}/3_checks/1_inputs/hfc_corrections.xlsm"		// Corrections
	gl recodefile 			"${cwd}/3_checks/1_inputs/specifyrecode.xlsm"		// Other specify recode
	
**# Datasets
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change filenames if neccesary
	
	gl rawdata 				"${cwd}/4_data/2_survey/Household Survey.dta" 		// Raw Survey Data
	gl preppeddata			"${cwd}/4_data/2_survey/wb_hhs_prepped.dta"			// Prepped Survey Data
	gl checkeddata			"${cwd}/4_data/2_survey/wb_hhs_checked.dta"			// Post HFC de-duplicated dataset
	
	gl masterdata 			""													// Respondent level Master Dataset
	gl trackingdata 		"${cwd}/4_data/1_preloads/tracking_data.xlsx"		// Group level Tracking Dataset
	
**# SurveyCTO media folder
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change folder path if neccesary
	
	gl media_folder 		"${cwd}/4_data/2_survey/media"						// Folder containing SurveyCTO text audit/comments files
	
**# Output Date Folder
*------------------------------------------------------------------------------*	
	
	* NB: DO NOT EDIT
	
	gl folder_date			= string(year(today())) + "-`:disp %tdNN today()'-`:disp %tdDD today()'"
	cap mkdir				"${cwd}/3_checks/2_outputs/$folder_date"

**# Output files
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change filenames if neccesary
	
	gl id_dups_output 		"${cwd}/3_checks/2_outputs/$folder_date/survey_duplicates.dta"		// [.dta] Raw Duplicates output
	gl corrlog_output 		"${cwd}/3_checks/2_outputs/$folder_date/hhs_correction_log.xlsx"	// [.xlsx] Log file for Corrections
	gl recodelog_output		"${cwd}/3_checks/2_outputs/$folder_date/specify_recode.xlsx"		// [.xlsx] Log file for other specify recode
	gl hfc_output			"${cwd}/3_checks/2_outputs/$folder_date/hfc_output.xlsx"			// [.xlsx] Output file for HFCs 
	gl textaudit_output 	"${cwd}/3_checks/2_outputs/$folder_date/textaudit.xlsx"				// [.xlsx] Output file for Text Audit 
	gl timeuse_output		"${cwd}/3_checks/2_outputs/$folder_date/timeuse.xlsx"				// [.xlsx] Output file for Time Use 
	gl surveydb_output		"${cwd}/3_checks/2_outputs/$folder_date/surveydb.xlsx"				// [.xlsx] Output file for Surveyor Dashboard 
	gl enumdb_output		"${cwd}/3_checks/2_outputs/$folder_date/enumdb.xlsx"				// [.xlsx] Output file for Enumerator Dashboard
	gl tracking_output      "${cwd}/3_checks/2_outputs/$folder_date/tracking.xlsx"				// [.xlsx] Output file for Survey Tracking

**# Admin variables
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change variable names if neccesary. 
	
	* Required Variables:
	
	gl key					"key"												// Unique key
	gl id 					""													// Survey ID
	gl enum					""													// Enumerator variable
	gl date					"starttime"											// Date Variable (date or datetime variable)
	
	* Optional Variables:

	gl team 				""													// Team Variable
	gl starttime 			"starttime"											// Starttime Variable (datettime variable)
	gl duration				"duration"											// duration (numeric variable) 
	gl formversion 			"formdef_version"									// formversion variable (numeric variable)
	gl fieldcomments 		""													// SurveyCTO field comments variable
	gl textaudit 			""													// SurveyCTO text audit variable
	gl keepvars 			""													// Global keep variables
	gl consent 				""													// Consent Variable
	gl outcome 				""													// Survey outcome variable

**# Missing values
*------------------------------------------------------------------------------*	
	
	* NB: Edit this section: Change values if neccesary. 
	
	gl cons_vals			"1"													// space sep list of values indicating consent
	gl outc_vals 			"1"													// space sep list of outcome variables indicating completeness
	gl dk_num 				"-999"												// space sep list of num don't know values
	gl dk_str 				"-999"												// space sep list of string don't know values
	gl ref_num				"-888"												// space sep list of num refuse values										
	gl ref_str				"-888"												// space seperated list of str refuse values	
	
	
   *========================== Additional Options ==========================* 

**# ipacheckcorrections: Correct HFC errors
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl cr_dupsheet			"duplicates corrections"							// Duplicates corrections sheet
	gl cr_dupslogsheet		"duplicates corrections"							// Sheet for duplicates corrections
	gl cr_othersheet		"other corrections"									// Other corrections sheet
	gl cr_otherlogsheet		"other corrections"									// Sheet for duplicates corrections
	gl cr_nolabel 			""													// Specify "nolabel" to apply nolabel
	gl cr_ignore 			""													// Specify "ignore" to suppress error if correction fails
	
**# ipacheckspecifyrecode: Recode Other Specify values
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl rc_keepvars 			"${keepvars}"										// Specify additional survey variables to show in logfile
	gl rc_sheet				"other specify recode"								// Inputs sheet
	gl rc_logsheet			"other specify recode"								// Sheetname for duplicates corrections logfile
	gl rc_nolabel 			""													// Specify "nolabel" to apply nolabel
   
**# ipacheckversion: Exported form version information & outdated Form Versions
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl vs_datevar			"${date}"											// Change datevar if neccesary
	gl vs_keepvars 			"${keepvars}"										// Specify additional survey variables to show in output
	gl vs_nolabel			""													// Specify "nolabel" to apply nolabel
	
**# ipacheckids: Export duplicates in Survey ID
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl id_datevar 			"${date}"											// Change datevar if neccesary
	gl id_keepvars			"${keepvars}"										// Specify additional survey variables to show in output
	gl id_nolabel			""													// Specify "nolabel" to apply nolabel

**# ipacheckdups: Export variable duplicates
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl dp_vars				""													// Specify variables to check for duplicates
	gl dp_datevar 			"${date}"											// change datevar if neccesary
	gl dp_keepvars			""													// Specify additional survey variables to show in output
	gl dp_nolabel 			""													// Specify "nolabel" to apply nolabel

**# ipacheckmissing: Export variable missingness statistics
*------------------------------------------------------------------------------*
	
	gl ms_vars	 			"_all"												// Specify variables to check for missingness		
	gl ms_imp_vars			"${id} ${key} ${date} ${enum}"						// Specify important variables: Will show at the top of output	
	gl ms_show 				"0"													// Specify minimum missigness threshold for flagging variable. eg 15 or 10%
	
**# ipacheckoutliers: Export outliers for numeric variables
*------------------------------------------------------------------------------*	
	
	* NB: Edit this section: Change values if neccesary.
	
	gl ol_datevar 			"${date}"											// Change datevar if neccesary
	gl ol_nolabel			""													// Specify "nolabel" to apply nolabel
	
	* NB: Set-up required options in the input file
	
**# ipacheckspecify: Export other specify values
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change values if neccesary.
	
	gl os_datevar 			"${date}"											// Change datevar if neccesary
	gl os_nolabel			""													// Specify "nolabel" to apply nolabel

	* NB: Set-up required options in the input file
	
**# ipacheckcomments: Export field comments
*------------------------------------------------------------------------------*
	
	gl cm_keepvars 			"${keepvars}"										// Specify additional survey variables to show in output
	gl cm_save 				"$cwd/4_data/2_survey/fieldcomments_data.dta"		// Specify filename for saving appended comments files
	gl cm_nolabel 			""													// Specify "nolabel" to apply nolabel
	
**# ipachecktextaudit: Export text audit statistics
*------------------------------------------------------------------------------*
	
	gl ta_save 				"$cwd/4_data/2_survey/textaudit_data.dta"			// Specify filename for saving appended text audit files
	gl ta_stats 			"count min max mean sd iqr p25 p50 p75"				// Specify Statistics to show in text audit report
	gl ta_nolabel 			""													// Specify "nolabel" to apply nolabel

**# ipachecktimeuse: Export time use statistics
*------------------------------------------------------------------------------*
	
	gl tu_timevar 			"${starttime}"										// Change Starttime variable if neccesary
	gl tu_nolabel 			""													// Specify "nolabel" to apply nolabel

**# ipachecksurveydb: Export Survey Dashboard
*------------------------------------------------------------------------------*
	
	gl sv_datevar 			"${date}"											// Change datevar if neccesary
	gl sv_period  			"auto"												// Specify interval for showing productivity (daily, weekly, monthly, auto)
	gl sv_by 				""													// Specify variable for disaggregating survey statistics 
	
**# ipacheckenumdb: Export enum dashboard
*------------------------------------------------------------------------------*

	gl en_period        	"auto"												// Interval for showing enum productivity (daily, weekly, monthly, auto)

**# ipatracksurveys: Export tracking sheet
*------------------------------------------------------------------------------*
	
	gl tr_by 				""													// Group variable for survey tracking
	gl tr_target 			""													// Target variable in tracking data
	gl tr_keepmaster		""													// variables to keep in master data
	gl tr_keeptracking		""													// variables to keep in tracking data
	gl tr_keepsurvey 		""													// variables to keep in survey dataset
	gl tr_summaryonly 		""													// indicate "summaryonly" to show summary sheet only
	gl tr_workbooks 		""													// indicate "workbooks" to show tracking sheets for groups as seperate books. 
	gl tr_surveyok 			""													// indidate "surveyok" to show allow ids/groups in survey data only