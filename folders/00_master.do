********************************************************************************
** 	TITLE: 00_master.do
**
**	PURPOSE: Master do file
**				
**	AUTHOR: 
**
**	CREATED: 
********************************************************************************


clear all
cap log close
set maxvar 10000
set more off
pause on


* check that the file has been run and return to main folder
if "$cwd" ~= "" cd "$cwd"
else global cwd "`c(pwd)'" 

*******************************************
*	0. Setting directories and locals     *
*******************************************
*A. Globals

	loc bc 0 // turn to 1 if back check data do files should be run
	loc checks 1 // turn to 1 if you want to run high-frequency and back checks

*B. Install user-written commands

	*
**B. Add user written programs
		*install ipacheck, from("https://raw.githubusercontent.com/PovertyAction/high-frequency-checks/master/ado")	replace
		qui{
			capture which ipacheck
			if _rc == 111 & `checks' == 1 {
				noi dis as err "Install ipacheck to run checks."
				error 111
			}
	
		*install bcstats, from("https://raw.githubusercontent.com/PovertyAction/bcstats/master/ado")	replace			
			capture which ipabcstats
				if _rc == 111 & `bc' == 1 {
					noi dis as err "Install bcstats to run back checks."
					error 111
				}

		}



*****************************
* Import Globals
*****************************

	qui do "02_dofiles/01_globals.do"

*****************************
* 	01. Run do files		*
*****************************

*A. Import survey SurveyCTO csv file into dta and add value/variable labels
*B. Import SurveyCTO back check csv file into dta and add value/variable labels
*C. Basic cleaning to prepare data for checks
*D.	Basic cleaning to prepare back check data for checks 
*E. Run high-frequency checks and back checks


**A. Import survey SurveyCTO csv file into dta and add value/variable labels
	/*
	**	PURPOSE: Load in raw survey data from SurveyCTO and include variable and 
				 value labels 
	**	INPUTS:	
	**			
	**	OUTPUTS: 			
	*/
	
*	qui do "$dir_do/01_import.do"

		
**B. Import back check SurveyCTO csv file into dta and add value/variable labels (not done)
	/*
	**	PURPOSE: Load in raw survey data from SurveyCTO and include variable and 
				 value labels 
	**	INPUTS:	 
	**			
	**	OUTPUTS: 			
	*/

	if `bc' qui do "$dir_do/02_import_bc.do"	
	

**C. Basic cleaning to prepare data for checks
	/*
	**	PURPOSE: Add value labels for select_multiple questions, remove 
				 unnecessary variables and destring calculated variables
	**	INPUTS:	 
	**	OUTPUTS: 
	*/

	qui do "$dir_do/03_prep.do"


**D. Basic cleaning to prepare back check data for checks (not done)
	/*
	**	PURPOSE: Adjusted 02_prep for back check data to do cleaning before running back check analysis
	
	**	INPUTS:	 
	**	OUTPUTS: 
	*/

*	if `bc' do "$dir_do/03_prep_bc.do"

	
**E. Run high-frequency checks and back checks
	/*
	**	PURPOSE: Run checks on data, make replacements
	
	**	INPUTS:	 
	**			 
	**	OUTPUTS: 
				 
	*/

	if `checks' do "$dir_do/04_master_check.do"
	
	
**END**

