{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckids} {hline 2}
Search dataset for duplicates in Survey ID

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckids} {it:{help varname}}{cmd:,} [{it:options}]


{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth date:var(varname)}}date/datetime variable indication date of survey{p_end}
{synopt:* {opth key(varname)}}surveys unique key variable{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet("sheetname")}}save summary of duplicates to excel sheet{p_end}
{synopt:{opth dupf:ile(filename)}}save dataset of duplicate observations to dta file{p_end}
{synopt:{opth save(string)}}save dataset of de-duplicated surveys as a dta file, where one of each duplicate group is randomly kept; must be used with {it:force} {p_end}
{synopt:{opth keep:vars(varlist)}}additional variables to export to {opt outsheet}{p_end}
{synopt:{opt sheetmod:ify}}modify excel sheet {cmd:outsheet}{p_end}
{synopt:{opt sheetrep:lace}}overwrite excel sheet {cmd:outsheet}{p_end}
{synopt:{opt replace}}overwrite Excel file {cmd:outfile}{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}
{synopt:{opt force}}force drop all duplicates in a duplicate group except one {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt enumerator()}, {opt datevar()}, {opt key()} and {opt outfile()} are required.

{marker description}{...}
{title:Description}

{pstd}
{cmd:ipacheckids} checks for duplicates of the Survey ID variable specified. If duplicates are found, an export will be 
outfile. The exported sheet will show the summary of each duplicate group including the number of comparison and differences for each duplicate pair. If there are more than two observations with the same ID variable, each will be compared with the first observation
submitted.{cmd:ipacheckids} requires a unique key variable which is unique in the dataset. This unique key variable is different from the Survey ID variable that is checked by {cmd:ipacheckids} for duplicates. The unique key variable will help differenciate between the duplicate observations reported and to help resolve duplicates using the {helpb ipacheckcorrections}. 

{marker optionsdesc}{...}
{title:Options}

{pstd}
{opt outsheet("sheetname")} option saves summary of duplicates to Excel sheet specified. The default is to save to Excel sheet "id duplicates".

{pstd}
{opth dupfile(filename)} option saves a dataset of duplicate observations to dta file. The default is to only save a summary of the duplicates.

{pstd}
{opth save(filename)} option saves a dataset of of de-deplicated observations to dta file where {cmd: ipacheckids} randomly keeps one of the observations. This option must always be used with the {cmd: force} option. 

{pstd}
{opth keepvars(varlist)} option specifies additional variables that should be included in duplicates summary sheet. The Survey ID and the variables specified in the {cmd:enumerator()}, {cmd:datevar} & {cmd:key} will automatically be added to the summary sheet. {cmd:keepvars} is therefore only neccesary to include other variables in the summary output as well.   

{pstd}
{opt sheetmodify} option specifies that the duplicates summary sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the duplicates summary sheet should be replaced if it already exist.  

{pstd}
{opt nolabel} nolabel exports the underlying numeric values instead of the value labels.

{pstd}
{opt replace} overwrites an existing Excel workbook.  replace cannot be specified when modifying or replacing a given worksheet.

{pstd}
{opt force} option uses {help duplicates drop} in order to randomly drop all observations in a duplicate group except one. 
This allows the workflow to continue, since IPA's Data Management System cannot run with duplicates.

{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckids} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System.

{marker examples}{...}
{title:Examples}

{pstd}
Check for duplicates in household ID variable (hhid):
{p_end}{cmd}{...}
{phang2}. ipacheckids hhid,
  enum(enum_id)
  date(submissiondate)
  key(key)
  outfile("hfc_outputs.xlsx")
  dupfile("household_survey_duplicates.dta")
  save("household_survey_checked.dta")
  keepvars(starttime endtime district)
  nolabel
  replace
{text}{...}
  
{marker authors}{...}
{title:Authors}

{pstd}
Rosemarie Sandino & Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}

{pstd}
For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}