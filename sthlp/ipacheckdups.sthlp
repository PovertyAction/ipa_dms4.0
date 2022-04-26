{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckdups} {hline 2}
Check for duplicate values of variables that should be unique. 

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckdups} {it:{help varlist}} {help if:[if]} {help in:[in]}{cmd:,}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth id(varname)}}unique Survey ID variable{p_end}
{synopt:* {opth date:var(varname)}}date/datetime variable indication date of survey{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet("sheetname")}}save summary of duplicates to excel sheet{p_end}
{synopt:{opth keep:vars(varlist)}}additional variables to export to {opt outsheet}{p_end}
{synopt:{opt sheetmod:ify}}modify excel sheet {cmd:outsheet}{p_end}
{synopt:{opt sheetrep:lace}}overwrite excel sheet {cmd:outsheet}{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt enumerator()}, {opt id()}, {opt datevar()}, and {opt outfile()} are required.

{title:Description}

{pstd}
{cmd:ipacheckdups} checks for duplicates of variables that should be unique, such as GPS points and other household indicators for enumerator monitoring. 
Note this check should not be used for the ID variable when runnning within IPA's Data Management System, since
other checks in the Data Management System require a unique ID variable. {help ipacheckids} is used to summarize duplicates
and differences between interviews with the same value for the ID variable.

{marker optionsdesc}{...}
{title:Options for ipacheckdups}

{pstd}
{opt outsheet("sheetname")} option saves output to Excel sheet specified. The default is to save to Excel sheet "duplicates".

{pstd}
{opth keepvars(varlist)} option specifies additional variables that should be included in output sheet. The Survey ID and the variables specified in the {cmd:enumerator()} and {cmd:datevar} will automatically be added to the output. {cmd:keepvars} is therefore only neccesary to include other variables in the output as well.   

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{pstd}
{opt nolabel} nolabel exports the underlying numeric values instead of the value labels.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckdups} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System.

{marker examples}{...}
{title:Examples}

{pstd}
Check for duplicates in GPS coordinates & phone number for a household survey with hhid as Survey ID:
{p_end}{cmd}{...}
{phang2}. ipacheckdups gps phonenumber,  
    enumerator(enum_id)
    id(hhid) 
    datevar(submissiondate)
    outfile("hfc_outputs.xlsx")
    keepvars(starttime endtime district)  
    sheetreplace 
    nolabel
{p_end}
{txt}{...}

{marker authors}{...}
{title:Authors}

{pstd}
Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}