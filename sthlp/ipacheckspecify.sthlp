{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 24apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckspecify} {hline 2}
Checks for recodes of other specify variables by listing all values specified. 

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckspecify} {it:{help using}}{cmd:,}
{opth sheet:name("sheetname")}
{opth id(varname)} 
{opth enum:erator(varname)}
{opth date:var(varname)}
{opth outfile(filename)}
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth sheet:name("sheetname")}}Excel worksheet to load{p_end}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth id(varname)}}unique Survey ID variable{p_end}
{synopt:* {opth date:var(varname)}}date/datetime variable indication date of survey{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet1("sheetname")}}save other specify values to Excel worksheet{p_end}
{synopt:{opt outsheet2("sheetname")}}save choice value and labels to Excel worksheet{p_end}
{synopt:{opt sheetmod:ify}}modify Excel worksheet {cmd:outsheet}{p_end}
{synopt:{opt sheetrep:lace}}overwrite Excel worksheet {cmd:outsheet}{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}

{synoptline}
{p2colreset}{...}
{* Using -help heckman- as a template.}{...}
{p 4 6 2}* {opt sheetname()}, {opt id()}, {opt enum()}, {opt datevar()} and {opt outfile()} are required.


{title:Description}

{pstd}
{cmd:ipacheckspecify} exports to {opt outsheet1} the values that are entered when a question has an "other, specify" option.
This shows possible recodes or enumerator performance issues with utilizing the "other, specify" option. {opt outsheet2} contains the value and value labels of the parent variable.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt sheetname("sheetname")} specifies the Excel worksheet to load from the {help using} file. This is required if the using file is {opt .xls} or {opt .xlsx} formats. option {opt sheetname()} is ignored if the using file is {opt .csv} or {opt .dta} file.

{phang}
{opth enumerator(varname)} specifies the enumerator variable for the dataset in memory. This variable must have non-missing values for all observations and can either be {help string} or {help numeric}. The {opt enumerator()} variable is automatically included in the output file. 

{phang}
{opt id} specifies the id variable for matching observations between the using file and the dataset in memory.

{phang}
{opth date:var(varname)} specifies a date or datetime variable for the dataset in memory. This variable must have non-missing values for all observations and must either be in {help %td} or {help %tc} formats. The {opt datevar()} variable is automatically included in the output file. 

{phang}
{opth out:file(filename)} specifies the Excel workbook for saving the output of the {cmd ipacheckspecify} check. 


{dlgtab:Specifications}

{pstd}
{opt outsheet1("sheetname")} specifies the Excel worksheet to export the other specify values to the {opt outfile()} specified. The default is to save to Excel sheet "other specify".

{pstd}
{opt outsheet2("sheetname")} specifies the Excel worksheet to export the choice values and labels of the parent variable to the {opt outfile()} specified. The default is to save to Excel sheet "other specify (choices)".

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckspecify} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into an inputs file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System. 

{pstd}
Below, an example {opt inputs file} is shown:
The variabels {cmd:parent}, {cmd:child} and {cmd:keepvars} are required. The inputs file may also include additional variables which contain information that are useful for tracking, although these additional variables will not be used. 

{cmd}{...}
    {c TLC}{hline 17}{c -}{hline 25}{c -}{hline 26}{c TRC}
    {c |}  parent          child    keepvars{c |}
    {c LT}{hline 17}{c -}{hline 25}{c -}{hline 26}{c RT}
    {c |} ed11b_? ed11b_??    ed11b_osp_? ed11b_osp_??    enum_name fmemb_fullname1{c |}
    {c |}           tn12_?                  tn12_osp_?                             {c |}
    {c |}              eu1                     eu1_osp                             {c |}
    {c |}             ws10                    ws10_osp                             {c |}
    {c |}              hw1                     hw1_osp                             {c |}
    {c |}              hw4                     hw4_osp                             {c |}
    {c BLC}{hline 17}{c -}{hline 25}{c -}{hline 26}{c BRC}
{txt}{...}

{pstd}
{opt parent} column/variable indicates the {cmd:parent} variable(s). The {opt parent} variable(s) are the variables which contain the "other specify" option. This column only accepts a {help varlist}. The parent column is required.  

{pstd}
{opt child} column/variable indicates the {cmd:child} variable(s). The {opt child} variable(s) is the variable that actually stores the "other specify" value. {cmd:ipacheckspecify} collates and exports a list of "other specify" values to the {opt outfile()} 


{pstd}
{opt keepvars} column/variable indicates the additional variables to export to the {opt outfile} sheet. 

{marker examples}{...}
{title:Examples}

{pstd}
In IPA's master_check.do file created when using the Data Management System, the inputs you enter into
hfc_inputs.xlsm are used as globals through {cmd:ipacheckimport} to fill in this command:
{p_end}{cmd}{...}

{phang2}
.   ipacheckspecify using "hfc_inputs.xlsm",
    id(hhid)
    enum(enum_id)
    date(submissiondate)
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

