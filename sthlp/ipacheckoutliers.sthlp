{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckoutliers} {hline 2}
Checks for outliers among numeric survey variables.

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckoutliers using} {it:{help filename}}{cmd:,}
{opt sheet:name("sheetname")}  
{opth enum:erator(varname)}  
{opth date:var(varname)} 
{opth id(varname)} 
{opth outfile(filename)}
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth sheet:name(filename)}}Excel worksheet to load{p_end}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth id(varname)}}unique Survey ID variable{p_end}
{synopt:* {opth date:var(varname)}}date/datetime variable indication date of survey{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet("sheetname")}}save summary of duplicates to excel sheet{p_end}
{synopt:{opt sheetmod:ify}}modify excel sheet {cmd:outsheet}{p_end}
{synopt:{opt sheetrep:lace}}overwrite excel sheet {cmd:outsheet}{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt enumerator()}, {opt id()}, {opt datevar()} and {opt outfile()} are required.{p_end}
{p 4 6 2}* Variables {opt variable}, {opt by}, {opt method}, {opt multiplier}, {opt combine} and optare required.{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:ipacheckoutliers} checks for outliers among numeric survey variables. 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt sheetname("sheetname")} specifies the Excel worksheet to load from the {help using} file. This is required if the using file is {opt .xls} or {opt .xlsx} formats. option {opt sheetname()} is ignored if the using file is {opt .csv} or {opt .dta} file.

{phang}
{opt id} specifies the id variable for matching observations between the corrections file and the dataset in memory.

{phang}
{opth enumerator(varname)} specifies the enumerator variable for the dataset in memory. This variable must have non-missing values for all observations and can either be {help string} or {help numeric}. The {opt enumerator()} variable is automatically included in the output file. 

{phang}
{opth date:var(varname)} specifies a date or datetime variable for the dataset in memory. This variable must have non-missing values for all observations and must either be in {help %td} or {help %tc} formats. The {opt enumerator()} variable is automatically included in the output file. 

{phang}
{opth out:file(filename)} specifies the Excel workbook for saving the output of the {cmd ipacheckoutliers check}. 


{dlgtab:Specifications}

{pstd}
{opt outsheet("sheetname")} specifies the Excel worksheet Excel sheet to export the output to for the {opt outfile()} specified. The default is to save to Excel sheet "outliers".

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckoutliers} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System. 

{pstd}
Below, an example {opt inputs file} is shown with additional optional variables:
The variabels {cmd:variable}, {cmd:by}, {cmd:method}, {cmd:multiplier}, {cmd:combine} and {cmd:keepvars} are required. The inputs file may also include additional variables which contain information that are useful for tracking, although these additional variables will not be used. 

{cmd}{...}
    {c TLC}{hline 10}{c -}{hline 9}{c -}{hline 8}{c -}{hline 11}{c -}{hline 8}{c -}{hline 36}{c TRC}
    {c |}  variable          by     method    multiplier    combine                     keepvars{c |}
    {c LT}{hline 10}{c -}{hline 9}{c -}{hline 8}{c -}{hline 11}{c -}{hline 8}{c -}{hline 36}{c RT}
    {c |}     hc16a    district                                        enum_name formdef_version{c |}
    {c |}       tn2                     sd             3                                        {c |}
    {c |}      tn4*                                         yes                                 {c |}
    {c |}      tn9*                                  1.5    yes                                 {c |}
    {c |}       ws4                     sd             2                                        {c |}
    {c |}      dc0b                     sd           1.5                                        {c |}
    {c BLC}{hline 10}{c -}{hline 9}{c -}{hline 8}{c -}{hline 11}{c -}{hline 8}{c -}{hline 36}{c BRC}
{txt}{...}

{pstd}
{opt variable} column/variable stores the variable to check for outliers. This column only accepts a {help varlist}. The variables specified in this column must be a numeric variable and {cmd:ipacheckoutliers} will return an error if it is not. The variable column is required.  

{pstd}
{opt by} column/variable stores the by variable. The {opt by} variables when specifies indicates that values for outliers and should be calculated by groups specified by the values in the {opt by} variables. This coloumn is useful if are generally expected to be different between groups eg. treatment status, gender or location. This column only accepts a {help varname}. The {opt by} variable accepts any type of variable, however, the variable must not contain any missing values and {cmd:ipacheckoutliers} will return an error if missing values are found for the {opt by} variable specified. Default is to flag outliers considering all values in specified for each variable in the {opt variable} column.

{pstd}
{opt method} column/variable stores the method for calculating outliers for the variables specified in the corresponding {opt variables} column. {cmd:ipacheckoutliers} calculates outliers by using the inter-quartile range or the sd. Users can specify if the method to apply by indication {opt iqr} for the inter-quartile range or {opt sd} for standard deviation. The default method is iqr. 

{pstd}
{opt multiplier} column/variable stores the multiplier to use when calculating the outliers for the variables specified in the corresponding {opt variables} column. Users can specify any numeric multiplier in this column. The default is an multiplier of {opt 1.5} for the {opt iqr} method and {opt 3} for the {opt sd} method. 

{pstd}
{opt combine} column/variable indicates if variales specified in the corresponding {opt variables} column should be considered as 1 variable. eg. Assuming the survey has income values for household members stored in 4 different variables {cmd:hhm_income_1}, {cmd:hhm_income_2}, {cmd:hhm_income_3} and {cmd:hhm_income_4}; the {opt combine} column can be used to indicate that thee variables should be considered as the same when calculating the summary statistics required to flag outliers. Users can combine variables by indicating {cmd:"yes"} in the combine column. The default behaviour is to consider each variable specified in the {cmd:variables} column as individual variables. 

{pstd}
{opt keepvars} column/variable indicates the additional variables to export to the {opt outfile} sheet. 

{pstd}
{cmd:ipacheckoutliers} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into a globals do-file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System.


{marker examples}{...}
{title:Examples}

{pstd}
Check for duplicates in dateset using inputs in the input file hfc_inputs.xlsm:
{p_end}{cmd}{...}

{phang2}
.  ipacheckoutliers using "hfc_inputs.xlsm", 
    id(hhid)
    enum(enum_id)
    date(submissiondate)
    outfile("hfc_output.xlsx")
    sheetreplace 
    nolabel
{txt}{...}
	
{marker acknowledgement}{...}
{title:Acknowledgement}

{pstd}
{cmd:ipacheckoutliers} is based on previous versions written by Chris Boyer of Innovations for Poverty Action.

{marker authors}{...}
{title:Authors}

{pstd}
Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}

