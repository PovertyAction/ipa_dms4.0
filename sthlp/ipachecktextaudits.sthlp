{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipachecktextaudit} {hline 2}
Merges and summarizes text audit media files from SurveyCTO.
 
{p 8 10 2}
{cmd:ipachecktextaudit} {it:{help varname}}{cmd:,}
{opth textaudit:data(filename)}  
{opth enum:erator(varname)}
{opth outfile(filename)} 
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth textaudit:data(filename)}}dta dataset of collated text audits data{p_end}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt stat:istics(statsname)}}Statistics to show in report. {p_end}
{synopt:{opt sheetmod:ify}}modify Excel worksheet{p_end}
{synopt:{opt sheetrep:lace}}overwrite Excel worksheet{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt textauditdata()}, {opt enumerator()} and {opt outfile()} are required.

{title:Description}

{pstd}
{cmd:ipachecktextaudit} creates an output sheet analysis data from media files created when using the SurveyCTO
{it:text audit} features. Since these are downloaded as separate media files per observation, user must first run the {help ipaimportsctomedia} command and parse the collated dataset to this command. 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt textauditdata(filename)} specifies the .dta file to load. This .dta file contains a dataset collated by {help ipaimportsctomedia} command. 

{phang}
{opth out:file(filename)} specifies the Excel workbook for saving the output. 


{dlgtab:Specifications}

{pstd}
{opt statistics(statname1 [startname2 ...])} Specifies the statistics to show in the report. The default is show all stats.

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.

{pstd}
{cmd:ipachecktextaudit} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into an globals do file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System. 


{marker examples}{...}
{title:Examples}

{pstd}
In IPA's master_check.do file created when using the Data Management System, the inputs you enter into
hfc_inputs.xlsm are used as globals through {cmd:ipacheckimport} to fill in this command:
{p_end}{cmd}{...}


{pstd}
Collate text audit data in text_audit variable with {help ipaimportsctomedia} and analyse and export data using {cmd:ipachecktextaudit}:
{p_end}{cmd}{...}

{phang2}
.    ipachecktextaudit textaudit,
    mediavar(text_audit)
    mediafolder("X/data/media")
    save("X/data/text_audit_data.dta")
    replace

.    ipachecktextaudit ftextaudit,
    textaudit("X/data/text_audit_data.dta")
    enum(enum_id)
    outfile("hfc_output.xlsx")
    sheetreplace
    nolabel
{txt}{...}	
 

{marker authors}{...}
{title:Authors}

{pstd}Innovations for Poverty Action{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}

