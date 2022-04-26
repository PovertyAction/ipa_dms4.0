{smcl}

{* *! version 4.0.0 25apr2022}{...}

{title:Title}

{phang}
{cmd:ipacheckspecifyrecode} {hline 2}
Recode other specify values of the dataset in memory using an external dataset.

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckspecifyrecode using} {it:{help filename}}{cmd:,}
{opth sheet:name(string)} 
{opth id(varlist)} 
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}

{synopt:*{opth sheet:name(string)}}Excel worksheet to load{p_end}
{synopt:*{opth id(varname)}}survey ID variable{p_end}

{syntab:Specifications}

{synopt:{opth logf:ile(filename)}}option to produce log of changes{p_end}
{synopt:{opth logs:heet(string)}}save logfile to excel worksheet{p_end}
{synopt:{opth keep:vars(varlist)}}variables in survey data to keep log file{p_end}
{synopt:{opt nol:abel}}export values instead of value labels to logfile{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}* {opt id()} is always required. {opt sheetname("sheetname")} is required for {opt .xls} and {opt .xlsx} correction files.{p_end} 
{p 4 6 2}Variables {opt parent}, {opt child}, {opt match_type}, {opt match_text}, {opt recode_from} & {opt recode_to} are required in using file.

{title:Description}

{pstd}
{cmd:ipacheckspecifyrecode} recodes variables in the dataset currently in memory by using instructions in an external dataset. 

{pstd}
{cmd:ipacheckspecifyrecode} allows match_type "exact", "contains", "begins with" and "ends with". If no match type is specified, "exact" is assumed. 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt sheetname("sheetname")} imports the worksheet named sheetname in the using input file. This is required if the using file is {opt .xls} or {opt .xlsx} formats. option {opt sheetname()} is ignored if using file is {opt .csv} or {opt .dta} file.

{phang}
{opt id} specifies the id variable for matching observations between the using file and the dataset in memory.

{dlgtab:Specifications}

{phang}
{opt logfile("filename.xlsx")} exports the results of other specify recodes to logfile {opt filename.xlsx}. The default is to not export a log file. The logfile saves information about the status of each observation that was recoded using the specifications in the using file. 

{phang}
{opt logsheet("sheetname")} exports the other specify log to the {opt "sheetname"} of the {opt "filename.xlsx"} workbook. {opt logsheet()} is required if {opt logfile()} is specified.

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.

{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckspecifyrecode} changes the contents of existing variables by
making recoding other specify values in the parent variable based on instructions specified in the using file. The using file should contain one row per pattern for recoding. Replacements are described by a "parent" column/variable that contains
the name of the parent variable to recode, a "child" column/variable that contains the name of the child variable, a "match_type" column/variable that contains the directive for matching, a "match_text" variable/column that contains values to match, a "recode_from" column/variable that contains the original parent value to recode, "recode_to" column/variable that contains the new parent value to recode to and an optional "new_label" column/variable that contains a new label definition if neccesary.

{pstd}
Below, an example using file is shown:

{cmd}{...}
    {c TLC}{hline 10}{c -}{hline 12}{c -}{hline 14}{c -}{hline 14}{c -}{hline 12}{c -}{hline 18}{c -}{hline 18}{c TRC}
    {c |}      parent         child     match_type      match_text    recode_from      recode_to      new_label{c |}
    {c LT}{hline 10}{c -}{hline 12}{c -}{hline 14}{c -}{hline 14}{c -}{hline 12}{c -}{hline 18}{c -}{hline 18}{c RT}
    {c |}   hhh_educ    hh_educ_osp          exact         College           -666              8                {c |}
    {c |}       work       work_osp       contains            farm           -666              1                {c |}
    {c |}   org_type   org_type_osp    begins with      Plan Inter           -666              7          NGO   {c |}
    {c |} relation_* relation_osp_*      ends with          member           -666              8                {c |}
    {c BLC}{hline 10}{c -}{hline 12}{c -}{hline 14}{c -}{hline 14}{c -}{hline 12}{c -}{hline 18}{c -}{hline 18}{c BRC}
{txt}{...}

{pstd}
For each observation of the using file,
{cmd:ipacheckspecifyrecode} checks the value of child value using the values specified in "match_type" & "match_text" and recodes the corresponding parent value from the value in "recode_from" to the value in "recode_to". User can also specify a {helpb varlist} as "parent" & "child" values. However, the number of "parent" or "child" specification per row must match after expansion. 

{pstd}
It is recommended to use the specifyrecode.xlsxm template file from IPA's 
Data Management System. See {help ipacheck} for information on how to download
this file. {cmd:ipacheckspecifyrecode} also accepts .xlsx, .xls, .csv & .dta files.

{marker remarks_multiple}{...}
{title:Remarks for recoding string multiple select variables}

{pstd}
{cmd:ipacheckspecifyrecode} can also be used to recode numeric values stored in a string variables as in the case of select multiple variables. Ex. to recode the value "-666" in the string "1 -666" to "1 3", the user only needs to specify "-666" in the "recode_from" column/variable & "3" in the "recode_to" column/variable. 

{marker remarks_advanced}{...}
{title:Remarks for advanced users}

{pstd}
{cmd:ipacheckspecifyrecode} uses regular expressions when {cmd:match_type} "contains", "begins width" & "ends with" are used. Advanced users can therefore use regular expression functions in the {cmd:match_text} column/variable when needed. This also means that users will need to escape regular expression characters if they want {cmd:ipacheckspecifyrecode} to assume them as literal text. 

{marker examples}{...}
{title:Examples}

{pstd}
Recode using the sample using dataset above. Do not create a logfile. 

{p 8}. {cmd:ipacheckspecifyrecode using "specifyrecode.xlsm", id(hhid)}

{pstd}
Recode using the sample using dataset above. Create a logfile. 

{p 8}. {cmd:ipacheckspecifyrecode using "specifyrecode.xlsm", id(hhid) logfile("specifyrecode_log.xlsx") logsheet("household")}

{text}{...}
{marker stored_results}{...}
{title:Stored results}

{p 6} {cmd:ipacheckcorrections} stores the following in r():{p_end}

{synoptset 20 tabbed}{...}
{syntab:{opt Scalars}}
{synopt:{cmd: r(N_recoded)}}number of values recoded in dataset{p_end}
{p2colreset}{...}

{txt}{...}
{marker authors}{...}
{title:Authors(s)}

{pstd}
Ishmail Azindoo Baako
Innovations for Poverty Action{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}