++++++++++++++++
DO FILES
++++++++++++++++

This folder is designed to store all do files needed to import, prep, and run checks on your data. The IPA HFC package comes with a template data flow for running this process; these will be automatically downloaded as do files and saved in the do files folder.

The master do file runs all do files in this folder. You will need to adjust the master do file to turn on/off different sections, and fill out the names of your datasets. Remember to never overwrite datasets and rename datasets when you make changes. 

This is the expected data flow if you run all files/turn on all sections:

00_master: Once this is filled out with appropriate filenames, locals, and documentation, you can choose to import your data using the surveycto_api command. If you change the local "download" to 0 (or do not correctly fill out the locals associated with the API download), your data will not download from the API and you will need to download the file manually through SurveyCTO. Then, this do file will run all other do files listed. When you write your own do files, be sure to add them into the appropriate order in your master do file. 

01_globals: If you are using the recommended folder structure, you do not need to change the file globals. Otherwise, adjust the file paths to the appropriate folders for each global. Then, add all variables that you would like to destring/tostring in your prep file. The other files will use these globals. 

02_import: Does not exist when you download these do files because it is specific to your data. This is normally the SurveyCTO-created import do file that automatically imports the raw .csv file, adds variable and value labels, adjusts date variables, and converts data to a .dta file. 

02_import_bc: Does not exist when you download these do files because it is specific to your backchceck data. This is normally the SurveyCTO-created import do file that automatically imports the raw .csv file, adds variable and value labels, adjusts date variables, and converts data to a .dta file.  

03_prep: Takes imported .dta file and run any cleaning/preparation necessary to run checks. While there are basic cleaning steps already within this do file, you must add any other cleaning specific to your project to this file. 

03_prep_bc: Takes your imported backcheck .dta file and run any cleaning/preparation necessary to run checks. While there are basic cleaning steps already within this do file, you must add any other cleaning specific to your project to this file. This should look very similar to your 03_prep file so that the backcheck and survey data are in the same format when checks are run. 

04_master_check: Runs high-frequency checks and backchecks, referencing specifications entered into 04_checks/01_inputs/hfc_inputs.xlsm and 04_checks/01_inputs/hfc_replacements.xlsm. If you are using the ipacheck input files, you only need to confirm that the filepath to the hfc_inputs file is correct. Otherwise, you will need to adjust the globals in 04_master_check to your specifications. 
