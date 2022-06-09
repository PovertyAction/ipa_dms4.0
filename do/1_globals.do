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

	
/* Input Files

	Description of globals for input files:
	---------------------------------------

    inputfile		Inputs file for ipacheckoutliers, ipacheckspecify and optional 
					enumstats inputs for ipacheckenumdb
	
	corrfile 		Inputs file for ipacheckcorrections. 
	
	recodefile 		Inputs file for ipacheckspecifyrecode
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change filenames if neccesary
	
	gl inputfile			"${cwd}/3_checks/1_inputs/hfc_inputs.xlsm"			
	gl corrfile 			"${cwd}/3_checks/1_inputs/hfc_corrections.xlsm"		
	gl recodefile 			"${cwd}/3_checks/1_inputs/specifyrecode.xlsm"		
	

/* Datasets
	
	Description of globals for datasets:
	------------------------------------
	
	rawdata 			Raw Survey Data
	
	preppeddata			Prepped Survey Data
	
	checkeddata			Post HFC de-duplicated dataset
	
	masterdata 			Respondent level Master Dataset
	
	trackingdata 		Group level Tracking Dataset
	
	commentsdata		Collated field comments data.
						* Note that this dataset will be saved by ipasctocollate. 
						* leave blank if Survey has no comments data
	
	textauditdata  		Collated text audit data
						* Note that this dataset will be saved by ipasctocollate. 
						* leave blank if Survey has no text audit data
*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change filenames if neccesary
	
	gl rawdata 				"${cwd}/4_data/2_survey/Household Survey.dta" 		
	gl preppeddata			"${cwd}/4_data/2_survey/wb_hhs_prepped.dta"			
	gl checkeddata			"${cwd}/4_data/2_survey/wb_hhs_checked.dta"			
	
	gl masterdata 			""													
	gl trackingdata 		""
	
	gl commentsdata 		""
	gl textauditdata 		""

/* SurveyCTO media folder

	Description of globals for SurveyCTO media folder:
	--------------------------------------------------
	
	media_folder 		Folder containing SurveyCTO text audit/comments files. 
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change folder path if neccesary
	
	gl media_folder 		"${cwd}/4_data/2_survey/media"						
	

**# Output Date Folder
*------------------------------------------------------------------------------*	
	
	* NB: DO NOT EDIT THIS SECTION
	
	gl folder_date			= string(year(today())) + "-`:disp %tdNN today()'-`:disp %tdDD today()'"
	cap mkdir				"${cwd}/3_checks/2_outputs/$folder_date"


/* Output files

	Description of globals for output files:
	----------------------------------------
	
	id_dups_output 		[.dta]  Raw Duplicates output
	
	corrlog_output 		[.xlsx] Log file for Corrections
	
	recodelog_output	[.xlsx] Log file for other specify recode
	
	hfc_output			[.xlsx] Output file for HFCs 
	
	textaudit_output 	[.xlsx] Output file for Text Audit 
	
	timeuse_output		[.xlsx] Output file for Time Use 
	
	surveydb_output		[.xlsx] Output file for Surveyor Dashboard 
	
	enumdb_output		[.xlsx] Output file for Enumerator Dashboard
	
	tracking_output     [.xlsx] Output file for Survey Tracking
	
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change filenames if neccesary
	
	gl id_dups_output 		"${cwd}/3_checks/2_outputs/$folder_date/survey_duplicates.dta"	
	gl corrlog_output 		"${cwd}/3_checks/2_outputs/$folder_date/correction_log.xlsx"
	gl recodelog_output		"${cwd}/3_checks/2_outputs/$folder_date/specify_recode.xlsx"	
	gl hfc_output			"${cwd}/3_checks/2_outputs/$folder_date/hfc_output.xlsx"		
	gl textaudit_output 	"${cwd}/3_checks/2_outputs/$folder_date/textaudit.xlsx"			
	gl timeuse_output		"${cwd}/3_checks/2_outputs/$folder_date/timeuse.xlsx"			
	gl surveydb_output		"${cwd}/3_checks/2_outputs/$folder_date/surveydb.xlsx"			
	gl enumdb_output		"${cwd}/3_checks/2_outputs/$folder_date/enumdb.xlsx"			
	gl tracking_output      "${cwd}/3_checks/2_outputs/$folder_date/tracking.xlsx"			


/* Admin variables

	Description of globals for admin variables:
	-------------------------------------------
	
	Admin variables specified here are variables that will be used multiple 
	times for different checks. Users can also modify variables for specific 
	commands in the master do-file if neccesary. 
	
	* Required Variables: 
	
	key					Unique key. Variable containing unique keys for each 
						submission. Note that this is different from the Survey ID. 
	
	id 					Survey ID. Variable containing the ID for each respondent/
						observation. 
	
	enum				Enumerator variable
	
	date				Survey Date Variable. Must be a DATETIME variable
	
	
	* Optional Variables:

	team 				Enumerator Team variable
	
	starttime 			Survey start time Variable. Must be a DATETIME variable
	
	duration			Duration variable. Must be a numeric variable. 
	
	formversion 		Form version variable. Must be a numeric variable. Note 
						that this is expected to be a numeric variable with higher 
						values representing the most recent form version.  
	
	fieldcomments 		SurveyCTO field comments variable
	
	textaudit 			SurveyCTO text audit variable
	
	keepvars 			Global keep variables. These variables will be applied as 
						keep variables for all checks. User may include or edit 
						these below at the individual sections for each check. 
	
	consent 			Consent Variable. Must be a numeric variable. 
	
	outcome 			Survey outcome variable. Must be a numeric variable.
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change variable names if neccesary. 
	
	* Required Variables:
	
	gl key					"key"												
	gl id 					""													
	gl enum					""													
	gl date					"starttime"											
	
	* Optional Variables:

	gl team 				""													
	gl starttime 			"starttime"											
	gl duration				"duration"											
	gl formversion 			"formdef_version"									
	gl fieldcomments 		""													
	gl textaudit 			""													
	gl keepvars 			""													
	gl consent 				""													
	gl outcome 				""													

	
/* Missing values

	Description of globals for missing values:
	------------------------------------------
	
	Missing values specified here will be used multiple times for different checks. 
	Users can also modify missing values for specific checks in other sections below 
	or in the master do-file. 
	
	cons_vals 		   numlist indicating consent. eg "1 2 3" or "1/4 12". 
					   * Leave blank if global consent is not specified. 
					   * Required of global consent is specified
	
	outc_vals 		   numlist indicating survey completeness. eg. "4 5" or "4/7"
					   * Leave blank if global outcome is not specified. 
					   * Required of global outcome is specified
	
	dk_num 	 		   numlist indicating survey values that represent "don't know" 
					   in numeric variables. eg. "-999 999 .999". 
					   * NB: These values will be recoded as .d in the 3_prep do-file. 
	
	dk_str 	 		   space seperated list indicating survey values that represent 
					   "don't know" in string variables. eg. "-999 999 DK". 
					   * NB: This is primarily aimed to work with select 
					   multiple type questions. 
					   
	ref_num 	 	   numlist indicating survey values that represent "refuses to answer" 
					   in numeric variables. eg. "-888 888 .888". 
					   * NB: These values will be recoded as .r in the 3_prep do-file. 
	
	ref_str 	 	   space seperated list indicating survey values that represent 
					   "refuses to answer" in string variables. eg. "-888 888 REFUSE". 
					   * NB: This is primarily aimed to work with select 
					   multiple type questions. 		
*/
*------------------------------------------------------------------------------*	
	
	* NB: Edit this section: Change values if neccesary. 
	
	gl cons_vals			"1"													
	gl outc_vals 			"1"													
	gl dk_num 				"-999"												
	gl dk_str 				"-999"												
	gl ref_num				"-888"												
	gl ref_str				"-888"												
	
	
	
   *========================== Additional Options ==========================* 

/* ipacheckcorrections: Correct HFC errors

	Description of globals for ipacheckcorrections:
	-----------------------------------------------
	
	ipacheckcorrections makes correction to the dataset in memory using the values 
	specified in an external dataset specified at the global corrfile. The external 
	dataset can be an Excel (xls, xlsx, xlsm), dta or csv file. 

	cr_dupsheet			Duplicates corrections sheet. Sheetname in the file specified
						at global corrfile that contains corrections for survey 
						duplicates. 
						
	cr_dupslogsheet		Sheet for duplicates corrections log. Sheetname in corrections 
						log specified at global correction_log that contains 
						the correction status for duplicate correction. 
						
	cr_othersheet		Other corrections sheet. Sheetname in the file specified
						at global corrfile that contains corrections for other 
						survey issues. 
						
	cr_otherlogsheet	Sheet for other corrections. Sheetname in corrections log 
						specified at global correction_log that contains the 
						correction status for other survey correction.
						
	cr_nolabel 			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
	
	cr_ignore 			Option to suppress error message of correction fails. 
						* Specify "ignore" to suppress error if correction fails
						* Leave blank to get an error and stop execution if correction fails. 
*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl cr_dupsheet			"duplicates corrections"							
	gl cr_dupslogsheet		"duplicates corrections"							
	gl cr_othersheet		"other corrections"									
	gl cr_otherlogsheet		"other corrections"									
	gl cr_nolabel 			""													
	gl cr_ignore 			"ignore"													


/* ipacheckspecifyrecode: Recode Other Specify values

	Description of globals for ipacheckspecifyrecode:
	-------------------------------------------------
	
	ipacheckspecifyrecode recodes the data in memory using values specified in an 
	external dataset specified at global recodefile. The external 
	dataset can be an Excel (xls, xlsx, xlsm), dta or csv file.
	
	rc_keepvars 		Additional survey variables to show in logfile.
						eg. "${keepvars} hhh_fullname"
						
	rc_sheet			Inputs sheet. Sheetname in global recodefile that contains 
						recode instructions. 
						
	rc_logsheet			Log sheet. Sheetname in the file specified at global 
						recodelog_output to export recode logs to.  
	
	rc_nolabel 			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl rc_keepvars 			"${keepvars}"										
	gl rc_sheet				"other specify recode"								
	gl rc_logsheet			"other specify recode"								
	gl rc_nolabel 			""													
   
/* ipacheckversions: Exported form version information & outdated Form Versions

	Description of globals for ipacheckversions:
	--------------------------------------------
	
	ipacheckversions creates a summary sheet detailing versions used by day, 
	and flags interviews using outdated form versions.
	
	vs_keepvars 		Additional survey variables to show in output file.
						eg. "${keepvars} hhh_fullname"
						
	vs_nolabel			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values

*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl vs_keepvars 			"${keepvars}"										
	gl vs_nolabel			""	
	
	
/* ipacheckids: Export duplicates in Survey ID

	Description of globals for ipacheckids:
	---------------------------------------
	
	ipacheckids finds  and exports duplicates in Survey ID. 

	id_keepvars 		Additional survey variables to show in output file.
						eg. "${keepvars} hhh_fullname"
						
	id_nolabel			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values


*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl id_keepvars			"${keepvars}"										
	gl id_nolabel			""													

	
/* ipacheckdups: Export variable duplicates

	Description of globals for ipacheckdups:
	----------------------------------------

	dp_vars 			Variables to check for duplicates. eg, "gps_* phonenumber"

	dp_keepvars 		Additional survey variables to show in output file.
						eg. "${keepvars} hhh_fullname"
						
	dp_nolabel			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl dp_vars				""													
	gl dp_keepvars			""													
	gl dp_nolabel 			""													

	
/* ipacheckmissing: Export variable missingness statistics

	Description of globals for ipacheckmissing:
	-------------------------------------------
	
	ipacheckmissing creates statistics or missingness and distinctness of variables.
	
	ms_vars	 			Variables to check for missingness. eg. "_all"
	
	ms_pr_vars			Priority variables: Will show at the top of output	
						eg. "${id} ${key} ${date} ${enum} consent phonenumber"
	
	ms_show 			Minimum missingness threshold. Specify that variables should 
						only be included in the output if they have a minimum # 
						or % of missing values. eg. "20" or "5%
*/
*------------------------------------------------------------------------------*
	
	gl ms_vars	 			"_all"												
	gl ms_pr_vars			"${id} ${key} ${date} ${enum}"						
	gl ms_show 				"0"													
	
	
/* ipacheckoutliers: Export outliers for numeric variables

	Description of globals for ipacheckoutliers:
	--------------------------------------------
	
	ipacheckoutliers checks for outliers among numeric survey variables.
	
	NB: Set-up is required in global inputfile
	
	ol_nolabel         Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
*/
*------------------------------------------------------------------------------*	
	
	* NB: Edit this section: Change values if neccesary.
	
	gl ol_nolabel			""
	
	* NB: Set-up required options in the input file
	
	
/* ipacheckspecify: Export other specify values

	Description of globals for ipacheckspecify:
	--------------------------------------------
	
	ipacheckspecify checks for recodes of other specify variables by listing 
	all values specified
	
	NB: Set-up is required in global inputfile
	
	os_nolabel			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change values if neccesary.
	
	gl os_nolabel			""													

	* NB: Set-up required options in the input file
	
	
/* ipacheckcomment: Export field comments

	Description of globals for ipacheckcomments:
	--------------------------------------------
	
	ipacheckcomment exports comments from SurveyCTO's comment field type.
	
	cm_keepvars 		Additional survey variables to show in output file.
						eg. "${keepvars} hhh_fullname"
							
	cm_nolabel 			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values

*/
*------------------------------------------------------------------------------*
	
	gl cm_keepvars 			"${keepvars}"										
	gl cm_nolabel 			""													
	
	
/* ipachecktextaudit: Export text audit statistics

	Description of globals for ipachecktextaudit:
	--------------------------------------------
	
	ipachecktextaudit summarizes text audit media files from SurveyCTO.
	
	ta_stats 			Statistics to show in text audit report. eg 
						"count mean sd"
						
	ta_nolabel          Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values

*/
*------------------------------------------------------------------------------*
	
	gl ta_stats 			"count min max mean sd iqr p25 p50 p75"				
	gl ta_nolabel 			""													

	
/* ipachecktimeuse: Export time use statistics

	Description of globals for ipachecktimeuse:
	--------------------------------------------
	
	ipachecktimeuse creates a heatmap of enumerator & survey productivity using 
	question-level timestamps captured using SurveyCTO's text audit feature.
	
	tu_nolabel 			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
*/
*------------------------------------------------------------------------------*
	
	gl tu_nolabel 			""													

	
/* ipachecksurveydb: Export Survey Dashboard

	Description of globals for ipachecksurveydb:
	--------------------------------------------
	
	ipachecktimeuse creates survey dashboard with rates of interviews, duration, 
	don't know, refusal, missing, and other useful statistics.
	
	sv_period  			Interval for showing productivity (daily, weekly, monthly, auto)
	
	sv_by 				Variable for disaggregating survey statistics. eg. "treatment_status"

*/
*------------------------------------------------------------------------------*
	
	gl sv_period  			"auto"												
	gl sv_by 				""													
	
	
/* ipacheckenumdb: Export enum dashboard

	Description of globals for ipacheckenumdb:
	------------------------------------------
	
	ipacheckenumdb creates enumerator dashboard with rates of interviews, duration, 
	don't know, refusal, missing, and other by enumerator, and variable statistics 
	by enumerator.

	en_period  			Interval for showing productivity (daily, weekly, monthly, auto)

*/
*------------------------------------------------------------------------------*

	gl en_period        	"auto"												

	
/* ipatracksurvey: Export tracking sheet

	Description of globals for ipatracksurvey:
	------------------------------------------
	
	ipatracksurvey compares master/tracking data and survey datasets to create a 
	progress report of survey completion rates.
	
	* General options:
	------------------
	
	tr_by 					Group variable for survey tracking. Stratify tracking 
							report using the values of this variable. eg. "district". 
							The by variable must be present in both master/tracking 
							data and the survey data. 
							
	tr_surveyok 			Allow observations in Survey only. 
							* indidate "surveyok" to allow ids/groups in survey data only
							
	* Options for Master Data:
	--------------------------
	
	tr_keepsurvey 			Variables from Survey Data to show in output file.
							eg. "starttime endtime hhh_fullname hhh_age"
							
	tr_keepmaster			Variables from Master Data to show in output file.
							eg. "starttime endtime hhh_fullname hhh_age"
							
	tr_summaryonly 			Export summary sheet only. 
							* indicate "summaryonly" to show summary sheet only
							* Leave blank to include individual sheets for each strata
	
	tr_workbooks 			Export Individual workbooks instead of sheets for each strata
							* indicate "workbooks" to export seperate workbooks.
							* leave blank to export to the same workbook as "summary"
							
							NB: This option is required of the number of groups in 
							by() are 30 and above
	
	* Options for Tracking Data:
	----------------------------
	
	tr_target 				Target variable in tracking data. This variable should 
							contain information on the number of surveys expected 
							for each group. eg. "respondent_count"
	
	tr_keeptracking			Variables from Tracking Data to show in output file.
							eg. "starttime endtime hhh_fullname hhh_age"
*/
*------------------------------------------------------------------------------*
	
	gl tr_by 				""													
	gl tr_target 			""													
	gl tr_keepmaster		""													
	gl tr_keeptracking		""													
	gl tr_keepsurvey 		""													
	gl tr_summaryonly 		""													
	gl tr_workbooks 		""													 
	gl tr_surveyok 			"surveyok"													