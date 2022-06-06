{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 25apr2022}{...}
{title:Title}

{phang}
{cmd:ipacheckcomments} {hline 2}
Exports comments from SurveyCTO's {it:comment} field type.
 
{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:ipacheckcomments} {it:{help varname}}{cmd:,}
{opth comments:data(filename)}  
{opth enum:erator(varname)}
{opth outf:ile(filename)} 
[{it:{help ipacheckcomments##options:options}}]

{marker options}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth comments:data(filename)}}dta dataset of collated field comments data{p_end}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet("sheetname")}}save comments to Excel worksheet{p_end}
{synopt:{opth keep(varlist)}}additional variables to export to Excel worksheet{p_end}
{synopt:{opt sheetmod:ify}}modify Excel worksheet{p_end}
{synopt:{opt sheetrep:lace}}overwrite Excel worksheet{p_end}
{synopt:{opt nol:abel}}export variable values instead of value labels{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}* {opt commentsdata()}, {opt enumerator()} and {outfile id()} are required.

{title:Description}

{pstd}
{cmd:ipacheckcomments} creates an output sheet of all comments made using the SurveyCTO 
{it:comment} feature. {cmd:ipachecktcomments} requires an input dataset generated by {help ipasctocollate}. 


{title:Options}

{dlgtab:Main}

{phang}
{opt commentsdata("filename.dta")} specifies the dta file to load. This dta file 
contains a dataset collated by {help ipasctocollate} command. 


{pstd}
{opt outfile("filename.xlsx")} specifies Excel workbook to export the text audit report into. 
{cmd:outfile()} is required. Excel formats xls and xlsx are supported in {cmd:outfile()}. 
If a file extension is not specified with {cmd:outfile()}, .xls is assumed, because 
this format is more common and is compatible with more applications that also can read from Excel files.


{dlgtab:Specifications}

{pstd}
{opt outsheet("sheetname")} specifies the Excel worksheet to export the field 
comments values to the {opt outfile()} specified. The default is to save to Excel 
sheet "field comments".

{pstd}
{opth keepvars(varlist)} specifies additional variables to export to the {cmd:outfile}.

{pstd}
{opt sheetmodify} specifies that the output sheet should only be modified 
but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} specifies that the output sheet should be replaced if 
it already exist.  

{pstd}
{opt nolabel} nolabel exports the underlying numeric values instead of the value labels.

{title:Stored results}

{p 6} {cmd:ipacheckcomments} stores the following in r():{p_end}

{synoptset 25 tabbed}{...}
{syntab:{opt Scalars}}
{synopt:{cmd: r(N_comments)}}number of comments found{p_end}
{p2colreset}{...}

{title:Remarks}

{pstd}
{cmd:ipacheckcomments} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into 
an globals do file and outputs are formatted in a .xlsx file or used directly 
from the command window or other do-files. See {help ipacheck} for more details 
on how to use the Data Management System. 

{title:Examples}

{synoptline}
  {text:Setup}
	{phang}{com}   . use "https://raw.githubusercontent.com/PovertyAction/ipa_dms4.0/final/data/household_survey.dta", clear{p_end}
	{phang}{com}   . unzipfile "https://raw.githubusercontent.com/PovertyAction/ipa_dms4.0/final/data/media.zip", replace{p_end}
	
  {text:Collate field comments}
	{phang}{com}   . ipasctocollate comments field_comments, folder("./media") save("comments_data.dta") replace{p_end}
	
  {text:Export field comments}
    {phang}{com}   . ipacheckcomments field_comments, comments("comments_data.dta") enum(a_enum_name) outf("field_comments.xlsx") sheetrep{p_end}
	
{synoptline}
{txt}{...}
	
{title:Authors}

{pstd}
Ishmail Azindoo Baako
(Innovations for Poverty Action){p_end}
{pstd}{it:Last updated: May 11, 2022}{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}

{title:Also see}

User-written: {helpb ipasctocollate:ipasctocollate}