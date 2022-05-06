{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckenumdb} {hline 2}
Create enumerator dashboard with rates of interviews, duration, don't know, refusal, 
missing, and other by enumerator, and variable statistics by enumerator. 

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckenumdb using} {it:{help filename}}{cmd:,}
{opt sheet("sheetname")}
{opth enum:erator(varname)}
{opth date(filename)}  
{opth outfile(filename)} 
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth sheet("sheetname")}}Excel worksheet to load{p_end}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth date(varname)}}date/datetime variable indication date of survey{p_end} 
{synopt:* {opth formv:ersion(varlist)}}form version variable{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt team(varname)}}team variable{p_end}
{synopt:{opt period(period)}}report by specified period{p_end}
{synopt:{opt cons:ent({help varname}, {help numlist})}}consent variable and values{p_end}
{synopt:{opt dontk:now(#, "string")}}numeric and string values for don't know{p_end}
{synopt:{opt ref:use(#, "string")}}numeric and string values for refuse to answer{p_end}
{synopt:{opth other:specify(varlist)}}other specify variables{p_end}
{synopt:{opth dur:ation(varlist)}}duration variables{p_end}
{synopt:{opt sheetmod:ify}}modify excel sheet {cmd:outsheet}{p_end}
{synopt:{opth sheetrep:lace}}overwrite Excel worksheet{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt sheet()}, {opt enumerator()}, {opt date()}, {opt formversions()} and {opt outfile()} are required.


{title:Description}

{pstd}
{cmd:ipacheckenumdb} creates an Excel workbook with 3 sheets or 6 sheets if {opt team()} is specified: 

{phang2}.  "summary": summary of interviews, missing, don't know, refuse, other, and duration by enumerator. Excel worksheet "summary (team)" showing summary at team lebel will be included if {opt team()} is specified.{p_end}
{phang2}.  "productivity": number of surveys by days/weeks/months. Excel worksheet "productivity (team)" showing productivity at team lebel will be included if {opt team()} is specified.{p_end}
{phang2}.  "enumstats": Summary statistics of numeric variables per enumerator. Excel worksheet "enumstats (team)" showing summary at team lebel will be included if {opt team()} is specified.{p_end}

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt sheet("sheetname")} specifies the Excel worksheet to load from the {cmd:using} file. This is required if the using file is {opt .xls} or {opt .xlsx} formats. option {opt sheetname()} is ignored if the using file is {opt .csv} or {opt .dta} file.

{phang}
{opth enum:erator(varname)} specifies the enumerator variable for the dataset in memory. This variable must have non-missing values for all observations and can either be {help string} or {help numeric}. The {opt enumerator()} variable is automatically included in the output file. 

{phang}
{opth date(varname)} specifies a date or datetime variable for the dataset in memory. This variable must have non-missing values for all observations and must either be in {help %td} or {help %tc} formats. The {opt enumerator()} variable is automatically included in the output file. 

{pstd}
{opth formversion(varname)} option specifies the form definition variable. eg, formversions(formdef_version)

{phang}
{opth out:file(filename)} specifies the Excel workbook for saving the output of the {cmd ipacheckoutliers check}. 

{dlgtab:Specifications}

{phang}
{opth team(varname)} specifies the team variable for the dataset in memory. This variable must have non-missing values for all observations and can either be {help string} or {help numeric}. 

{pstd}
{opt period(period)} option specifies the time frame for showing summaries and statistics in the daashboard. The daily option shows summary by day, weekly by week and monthly by month. The auto option auto adjust the period based on the number of days ie. using days if number of days are less than or equal to 40, weeks if the number of days more than 40 and months if the number of months are greater than 40 weeks.    

{pstd}
{opt consent({help varname},{help numlist})} option specifies variable and the values for consent. eg. consent(consent, 1) or consent(consent, 1 2). When a {help numlist} is specified as values, {cmd:ipacheckenumdb} will assume any of these values to indicate a valid consent. 

{pstd}
{opt dontk:now(numlist, "string")} option specifies values for don't know responses. eg. dontknow(-999, "-999") or consent(-999, "Dont Know").

{pstd}
{opt ref:use(numlist, "string")} option specifies values for refuse to answer responses. eg. dontknow(-999, "-999") or consent(-999, "Dont Know").  

{pstd}
{opth other(varlist} option specifies other specify child variables. If specified, {cmd:ipacheckenumdb} will show statistics on percentage of times enumerator used the other specify option.   

{pstd}
{opth duration(varname)} option specifies the duration variable. If specified, {cmd:ipacheckenumdb} will show statistics on minimimum, maximum, mean and median duration per enumerator.   

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.

{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckenumdb} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System. 

{pstd}
Below, an example {opt inputs file} is shown with an example of inputs for enumstats sheet:

{cmd}{...}
    {c TLC}{hline 9}{c -}{hline 8}{c -}{hline 4}{c -}{hline 5}{c -}{hline 13}{c -}{hline 6}{c -}{hline 3}{c -}{hline 4}{c TRC}
    {c |}  variable   combine    min    mean    show_mean_as    median     sd    max{c |}
    {c LT}{hline 9}{c -}{hline 8}{c -}{hline 4}{c -}{hline 5}{c -}{hline 13}{c -}{hline 6}{c -}{hline 3}{c -}{hline 4}{c RT}
    {c |}     hc16a              yes     yes                       yes    yes    yes{c |}
    {c |}    st1cb*              yes     yes                       yes    yes    yes{c |}
    {c |}      tn4*       yes    yes     yes      percentage                     yes{c |}
    {c |}      tn9*       yes    yes     yes                       yes    yes    yes{c |}
    {c |}       ws4              yes     yes                       yes    yes    yes{c |}
    {c |}      dc0b              yes     yes                       yes    yes    yes{c |}
    {c BLC}{hline 9}{c -}{hline 8}{c -}{hline 4}{c -}{hline 5}{c -}{hline 13}{c -}{hline 6}{c -}{hline 3}{c -}{hline 4}{c BRC}
{txt}{...}

{pstd}
{opt variable} column/variable indicates the variable(s) to display enumerators statistics for. This column only accepts a {help varlist}. The variables specified in this column must be a {cmd:numeric} variable and {cmd:ipacheckenumdb} will return an error if it is not. The variable column is required.  

{pstd}
{opt combine} column/variable indicates if variales specified in the corresponding {opt variables} column should be considered as 1 variable. eg. Assuming the survey has income values for household members stored in 4 different variables {cmd:hhm_income_1}, {cmd:hhm_income_2}, {cmd:hhm_income_3} and {cmd:hhm_income_4}; the {opt combine} column can be used to indicate that thee variables should be considered as the same when calculating summary statistics. Users can combine variables by indicating {cmd:"yes"} in the combine column. The default behaviour is to consider each variable specified in the {cmd:variables} column as individual variables. 

{pstd}
{opt min} column/variable indicates of the minimum value for the corresponding variables in the variable(s) column should be includded in the enumstats report. 

{pstd}
{opt mean} column/variable indicates of the mean/average value for the corresponding variables in the variable(s) column should be includded in the enumstats report.

{pstd}
{opt show_mean_as} column/variable indicates of the mean/average value for the corresponding variables in the variable(s) column should be formatted as a percentage or number. This is useful for displaying percetages for dummy variables. 

{pstd}
{opt sd} column/variable indicates of the standard deviation for the corresponding variables in the variable(s) column should be includded in the enumstats report.

{pstd}
{opt max} column/variable indicates of the maximum value for the corresponding variables in the variable(s) column should be includded in the enumstats report.

{pstd}
{cmd:ipacheckenumdb} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System.

{marker examples}{...}
{title:Examples}

{pstd}
In IPA's master_check.do file created when using the Data Management System, the inputs you enter into
hfc_inputs.xlsm are used as globals through {cmd:ipacheckimport} to fill in this command:
{p_end}{cmd}{...}
{phang2}.    ipacheckenumdb using "hfc_inputs.xlsm",
     sheet("enumstats")
     enum(enum_id)
     team(enum_team)
     date(submissiondate)
     period(daily)
     consent(consent, 1 2)
     dontk(-999, "-999")
     ref(-888, "-888")
     other(*_osp*)
     dur(duration)
     formv(formdef_version)
     outfile("enumdb.xlsx")
     sheetreplace
     nolabel
{txt}{...}
	
{marker authors}{...}
{title:Authors}

{pstd}Innovations for Poverty Action{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}

