{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipachecktimeuse} {hline 2}
Create a Excel heatmap of enumerator & survey productivity using question-level timestamps captured using SurveyCTO's text audit feature.

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipachecktimeuse}{cmd:,}
{opth enum:erator(varname)}
{opth starttimevar(varname)}
{opth textaudit:data(filename)}
{opth outfile(filename)}
[{it:options}]


{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth enum:erator(varname)}}save "version control" summary to excel sheet{p_end}
{synopt:* {opth starttime:var(varname)}}datetime variable indicating starttime of survey. {p_end}
{synopt:* {opth textaudit:data(filename)}}date/datetime variable indicating date of survey. {p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt sheetmod:ify}}modify {cmd:outsheet1} & {cmd:outsheet2}{p_end}
{synopt:{opt sheetrep:lace}}replace {cmd:outsheet1} & {cmd:outsheet2}{p_end}
{synopt:{opt nol:abel}}export values instead of value labels to {opt sheetname2}{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt enumerator()}, {opt starttimevar()}, {opt textauditdata()} and {opt outfile()} are required.


{title:Description}

{pstd}
{cmd:ipachecktimeuse} exports heatmap of hourly engagement for each survey date to the "timeuse by date" sheet of the specified {opt outfile()} and for each enumerator to the "timeuse by enumerator" sheet as well. The output from {cmd:ipachecktimeuse} gives a visual overview of productivity for the various hours during the day. 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt textauditdata(filename)} specifies the .dta file to load. This .dta file contains a dataset collated by {help ipaimportsctomedia} command. 

{phang}
{opth out:file(filename)} specifies the Excel workbook for saving the output. 


{dlgtab:Specifications}

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.

{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipachecktimeuse} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into an globals do file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System. 


{marker examples}{...}
{title:Examples}

{phang2}
.    ipachecktextaudit textaudit,
    mediavar(text_audit)
    mediafolder("X/data/media")
    save("X/data/text_audit_data.dta")
    replace

.    ipachecktimeuse,
    textaudit("X/data/text_audit_data.dta")
    starttime(starttime)
    enum(enum_id)
    outfile("timeuse.xlsx")
    sheetreplace
    nolabel
{txt}{...}  

{txt}{...}
{marker acknowledgement}{...}
{title:Acknowledgement}

{pstd}
{cmd:ipachecktimeuse} is is based on {help sctotimeuse} written by William Blackmon of Innovations for Poverty Action.
	
{marker authors}{...}
{title:Authors}

{pstd}
Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}

