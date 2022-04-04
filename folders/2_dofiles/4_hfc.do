*! version 4.0.0 Innovations for Poverty Action 30mar2022

/* =============================================================================
   =============================================================================
   =================== IPA HIGH FREQUENCY CHECK TEMPLATE ======================= 
   =============================================================================
   ============================================================================= */
   
/* ============================================================================= 
   ======================= Remove existing excel files ========================= 
   ============================================================================= */

	foreach file in hfc id_dups textaudit surveydb enumdb timeuse tracking bc {
		cap confirm file "${`file'_output}"
		if !_rc {
			rm "${`file'_output}"
		}
	}
   
/* ============================================================================= 
   ========================== Import Prepped Dataset =========================== 
   ============================================================================= */

	use "$preppeddata", clear
	
/* ============================================================================= 
   ============================== Form versions ================================ 
   ============================================================================= */

   if $run_version {
		ipacheckversion $formversion, 						///
				enumerator($enum) 							///	
				datevar($date)								///
				outfile("$hfc_output") 						///
				outsheet1("form versions")					///
				outsheet2("outdated")						///
				keepvars($keepvars $vers_keepvars)			///
				sheetreplace	
   }
   
/* ============================================================================= 
   ======================= Replacements and Corrections ======================== 
   ============================================================================= */
   
	*NB: Soon

/* ============================================================================= 
   ========================= Resolve Survey Duplicates ========================= 
   ============================================================================= */
   
   if $run_ids {
	   ipacheckids $id,									///
				enumerator($enum) 						///	
				datevar($date) 							///
				key($key) 								///
				outfile("$hfc_output") 					///
				outsheet("id duplicates")				///
				keepvars($keepvars $ids_keepvars) 		///
				dupfile($id_dups_output)				///
				save("$checkeddata")					///
				sheetreplace
   }
   
   use "$checkeddata", clear
   
/* ============================================================================= 
   =========================== Variable Duplicates ============================= 
   ============================================================================= */
   
   if $run_dups {
	   ipacheckdups $dups_vars,							///
				id($id)									///
				enumerator($enum) 						///	
				datevar($date) 							///
				outfile("$hfc_output") 					///
				outsheet("duplicates")					///
				keepvars($keepvars $dups_keepvars) 		///
				sheetreplace
   }
   
/* ============================================================================= 
   ========================== Variable Missingness ============================= 
   ============================================================================= */ 
   
   if $run_missing {
		ipacheckmissing $miss_vars, 					///
			importantvars($miss_imp_vars)				///
			outfile("$hfc_output") 						///
			outsheet("missing")							///
			sheetreplace
   }
   
/* ============================================================================= 
   ================================ Outliers =================================== 
   ============================================================================= */ 

   if $run_outlier {
		ipacheckoutliers using "$inputfile",			///
			id($id)										///
			enumerator($enum) 							///	
			datevar($date) 								///
			sheetname("outliers")						///
        	outfile("$hfc_output") 						///
			outsheet("outliers")						///
			sheetreplace
			
   }
   
/* ============================================================================= 
   ============================== Other Specify ================================ 
   ============================================================================= */ 
   
   if $run_specify {
		ipacheckspecify using "$inputfile",				///
			id($id)										///
			enumerator($enum) 							///	
			datevar($date) 								///
			sheetname("other specify")					///
        	outfile("$hfc_output") 						///
			outsheet1("other specify")					///
			outsheet2("other specify (choices)")		///
			sheetreplace
			
   }
   
/* ============================================================================= 
   ============================= field comments ================================ 
   ============================================================================= */ 
   
    if $run_comments {

		ipaimportsctomedia comments, 					///
			mediavar($fieldcomments)					///
			mediafolder("$media_folder")				///
			save("$comm_save")							///
			replace
		
		ipacheckcomments $fieldcomments,				///
			enumerator($enum) 							///	
			commentsdata("$comm_save")					///
        	outfile("$hfc_output") 						///
			outsheet("field comments")					///
			keepvars($keepvars $id)						///
			sheetreplace
			
   }
   
/* ============================================================================= 
   ========================= text audit & time use ============================= 
   ============================================================================= */ 
 
   if $run_textaudit | $run_timeuse {
       ipaimportsctomedia textaudit, 			///
			mediavar($textaudit)				///
			mediafolder("$media_folder")		///
			save("$ta_save")					///
			replace
   }
  
   if $run_textaudit {
		ipachecktextaudit $textaudit,			///
			enumerator($enum) 					///	
			textauditdata($ta_save)				///
        	outfile("$textaudit_output")		///
			stats("$ta_stats")					///
			sheetreplace
			
   }
   
   if $run_timeuse {
		ipachecktimeuse $textaudit, 			///
			enumerator($enum) 					///	
			starttimevar($starttime)			///
			textauditdata("$ta_save")			///
        	outfile("$timeuse_output")			///
			sheetreplace
   }
   
/* ============================================================================= 
   ============================ Survey Dashboard =============================== 
   ============================================================================= */ 
   
   if $run_surveydb {
		ipachecksurveydb,			 				///
			by($surveydb_byvar)						///
			enumerator($enum) 						///
			datevar($date)							///
			period("$period")						///
			consent($consent, $consent_vals)		///
			dontknow(.d, $dontknow_str)				///
			refuse(.r, $refuse_str)					///
			othervars($sdb_osp_vars)				///
			duration($duration)						///
			formversion($formversion)				///
        	outfile("$surveydb_output")					///
			sheetreplace
   }
   
/* ============================================================================= 
   ========================== Enumerator Dashboard ============================= 
   ============================================================================= */ 
   
   if $run_enumdb {
		ipacheckenumdb using "$inputfile",			///
			sheetname(enumstats)					///		
			enumerator($enum) 						///
			team($team)								///
			datevar($date)							///
			period("$enumdb_period")				///
			consent($consent, $consent_vals)		///
			dontknow(.d, $dontknow_str)				///
			refuse(.r, $refuse_str)					///
			othervars($enumdb_osp_vars)				///
			duration($duration)						///
			formversion($formversion)				///
        	outfile("$enumdb_output")				///
			sheetreplace
   }
  
   
/* ============================================================================= 
   ========================== Track Survey Progress ============================ 
   ============================================================================= */
   
   if $run_track {
       ipatracksurvey,								///
			surveydata($checkeddata)				///
			id($id)									///
			datevar($date)							///
			groupby($track_groupby)					///
			outcome($track_outcome)					///
			target($track_target)					///
			masterdata($masterdata)					///
			masterid($track_masterid)				///
			trackingdata($trackingdata)				///
			keepmaster($track_keepmaster)			///
			keeptracking($track_keeptracking)		///
			keepsurvey($track_keepsurvey)			///
			outfile($tracking_output)				///
			save($track_save)						///
			$track_nolabel 							///
			$track_summaryonly						///
			$track_workbooks 						///
			$track_surveyok
   }