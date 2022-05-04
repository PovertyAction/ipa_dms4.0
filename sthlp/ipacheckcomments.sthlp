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
{opth outfile(filename)} 
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:* {opth comments:data(filename)}}dta dataset of collated field comments data{p_end}
{synopt:* {opth enum:erator(varname)}}enumerator variable{p_end}
{synopt:* {opth outf:ile(filename)}}save output to Excel workbook{p_end}

{syntab:Specifications}
{synopt:{opt outsheet("sheetname")}}save comments to Excel worksheet{p_end}
{synopt:{opt sheetmod:ify}}modify Excel worksheet{p_end}
{synopt:{opth keep:vars(varlist)}}additional variables to export to Excel worksheet{p_end}
{synopt:{opt sheetrep:lace}}overwrite Excel worksheet{p_end}
{synopt:{opt nolab:el}}export variable values instead of value labels{p_end}
{synoptline}
{p2colreset}{...}
{* Using -help heckman- as a template.}{...}
{p 4 6 2}* {opt media()}, {opt saving()}, {opt id()}, {opt enumerator()}, and {opt submitted()} are required.


{title:Description}

{pstd}
{cmd:ipacheckcomments} creates an output sheet of all comments made using the SurveyCTO {it:comment} feature. 
Since these are downloaded as separate media files per observation, {help ipaimportsctomedia} collates all comments into a single dataset which is then parsed to {cmd:ipacheckcomments} using the {opt commentsdata()} option.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt commentsdata(filename)} specifies the .dta file to load. This .dta file contains a dataset collated by {help ipaimportsctomedia} command. 

{phang}
{opth out:file(filename)} specifies the Excel workbook for saving the output of the {cmd ipacheckspecify} check. 


{dlgtab:Specifications}

{pstd}
{opt outsheet("sheetname")} specifies the Excel worksheet to export the field comments values to the {opt outfile()} specified. The default is to save to Excel sheet "field comments".

{pstd}
{opth keepvars(varlist)} specifies additional variables to export to the {cmd:outfile}.

{pstd}
{opt sheetmodify} option specifies that the output sheet should only be modified but not be replaced if it already exist.  

{pstd}
{opt sheetreplace} option specifies that the output sheet should be replaced if it already exist.  

{phang}
{opt nolabel} exports the underlying numeric values instead of the value labels.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:ipacheckcomments} is one of the checks run in IPA's Data Management System. 
It can be run within IPA's Data Management System, where inputs are entered into an globals do file 
and outputs are formatted in a .xlsx file or used directly from the command window or other do-files. See {help ipacheck} for more details on how to use the Data Management System. 

{marker examples}{...}
{title:Examples}

{pstd}
Collate field comments data in field_comments variable with {help ipaimportsctomedia} and export data using {cmd:ipacheckcomments}:
{p_end}{cmd}{...}

{phang2}
.    ipacheckcomment comments,
    mediavar(field_comments)
    mediafolder("X/data/media")
    save("X/data/field_comments_data.dta")
    replace

.    ipacheckcomment field_comments,
    comments("X/data/field_comments_data.dta")
    enum(enum_id)
    outfile("hfc_output.xlsx")
    keepvars(hhid hhh_fullname)
    sheetreplace
    nolabel
{txt}{...}
	
 
{marker authors}{...}
{title:Authors}

{pstd}Innovations for Poverty Action{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/high-frequency-checks/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}

