{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckmissing} {hline 2}
Create statistics or missingness and distinctness of variables. 

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckmissing} {it:{help varlist}}{cmd:,}
{opth outfile(filename)} 
[{it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outs:heet("sheetname")}}save summary of duplicates to excel sheet{p_end}
{synopt:{opth imp:ortantvars(varlist)}}important variables to show in output{p_end}
{synopt:{opth show(integer[%])}}show variables statistics if variable is at least integer[%] missing values/percentage{p_end}
{synopt:{opt sheetmod:ify}}modify excel sheet {cmd:outsheet}{p_end}
{synopt:{opt sheetrep:lace}}overwrite excel sheet {cmd:outsheet}{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt outfile()} is required.

{title:Description}

{pstd}
{cmd:ipacheckmissing} creates and outputs missingness and distinctness statatics for specified variables, where missing indicates a skip. 
Note that IPA's Data Management System changes values to missing as specified in the input sheet 
(i.e. -999 = .d), which will also be considered missing in this check. 

{marker optionsdesc}{...}
{title:Options for ipacheckdups}

{pstd}
{opt outsheet("sheetname")} option saves output to Excel sheet specified. The default is to save to Excel sheet "missing".

{pstd}
{opt show(integer[%])} option shows only variables that have a minimum number of percentage specified. The default is {opt show(0)} which will show statistics for all variables.

{pstd}
{opth importantvars(varlist)} option specifies variables to prioritize in the outputs. If specified, these variables will be sorted at the top of the output. By default the variables with the highest missingness rate was sorted to the top of the output. 

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckmissing} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System.


{marker examples}{...}
{title:Examples}

{pstd}
Create missigness statistics of all variables, flagging the enumerator variables as important variables:
{p_end}{cmd}{...}

{phang2}. ipacheckmissing _all,
important(enum_id enum_name team_id team_name) 
outfile("hfc_output.xlsx")
sheetreplace
{txt}{...}

{marker acknowledgement}{...}
{title:Acknowledgement}

{pstd}
{cmd:ipacheckmissing} is based on {cmd:ipachecknomiss} & {cmd:ipacheckallmiss} written by Chris Boyer of Innovations for Poverty Action.

{marker authors}{...}
{title:Authors}

{pstd}
Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}
