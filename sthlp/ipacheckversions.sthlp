{smcl}
{* *! version 3.0.0 Innovations for Poverty Action 30oct2018}{...}
{title:Title}

{phang}
{cmd:ipacheckversions} {hline 2}
Create a summary sheet detailing versions used by day, and flags interviews using outdated form versions. 

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckversions} {it:{help varname}}{cmd:,}
{opth enum:erator(varname)}
{opth date:var(varname)}
{opth outfile("filename.xlsx")}
[{it:{help ipacheckversions##options:options}}]

{marker options}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth date:var(varname)}}date/datetime variable indicating date of survey. {p_end}
{synopt:* {opth outf:ile("filename.xlsx")}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet1("sheetname1")}}save "version control" summary to excel sheet{p_end}
{synopt:{opt outsheet2("sheetname2")}}save observations with "outdated form versions" to excel sheet{p_end}
{synopt:{opth keep:vars(varlist)}}additional variables to export to {opt outsheet2}{p_end}
{synopt:{opt sheetmod:ify}}modify {cmd:outsheet1} & {cmd:outsheet2}{p_end}
{synopt:{opt sheetrep:lace}}replace {cmd:outsheet1} & {cmd:outsheet2}{p_end}
{synopt:{opt nol:abel}}export values instead of value labels to {opt sheetname2}{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt enumerator()}, {opt datevar()} and {opt outfile()} are required.


{title:Description}

{pstd}
{cmd:ipacheckversions} exports a table of versions used by date and if applicable, 
a list of all observations that are using a form beside the most recent form version 
available by date. Optionally, the user can specify additional variables to show in 
{opt outsheet2}. 

{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckversions} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window 
or other do-files. See {help ipacheck} for more details on how to use the Data Management System.
It is important to note that ipacheckversions was written to take advantage 
of the SurveyCTO form versions format and therefore experts that the form versions 
values are numeric and in ascending order from the oldest to the most recent form.

{marker examples}{...}
{title:Examples}

{synoptline}
  {text:Setup}
	{phang}{com}   . use "https://raw.githubusercontent.com/PovertyAction/ipa_dms4.0/final/data/household_survey.dta", clear{p_end}

  {text:Run check}
	{phang}{com}   .ipacheckversions formdef_version, enum(a_enum_id) date(starttime) outfile("hfc_outputs.xlsx") keep(a_enum_name hhid a_pl_hhh_fn) sheetreplace{p_end}
	
{synoptline}

{txt}{...}
{marker acknowledgement}{...}
{title:Acknowledgement}

{pstd}
{cmd:ipacheckversions} is is based on {help ipatrackversions} written by Chris Boyer of Innovations for Poverty Action.
	
{marker authors}{...}
{title:Authors}

{pstd}
Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}
