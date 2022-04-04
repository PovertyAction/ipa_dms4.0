********************************************************************************
** 	TITLE	: 00_master.do
**
**	PURPOSE	: Master do file
**				
**	AUTHOR	: 
**
**	DATE	: 
********************************************************************************

**# setup Stata
*------------------------------------------------------------------------------*

	clear 			all
	macro drop 		_all
	version 		17
	set min_memory 	1g
	set maxvar 		32000
	set more 		off
	
	set seed 		87235
	set sortseed 	98237

**# setup working directory
*------------------------------------------------------------------------------*
	
	if "$cwd" ~= "" cd "$cwd"
	else global cwd "`c(pwd)'" 
	
**# Survey 1
*------------------------------------------------------------------------------*

	do "2_dofiles/1_globals.do"													// globals do-file
	do "2_dofiles/2_import_wbnp_hhs_2021.do"									// import do-file
	do "2_dofiles/3_prep.do"													// prep do-file
	do "2_dofiles/4_hfc.do"														// hfcs do-file

	
**END**