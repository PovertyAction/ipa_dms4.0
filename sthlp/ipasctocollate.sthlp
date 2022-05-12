{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 11may2022}{...}

{cmd:ipasctocollate} {c -} collate and export a dataset of SurveyCTO generated text audit or comment files.

{title:Syntax}

{pmore}
{cmd:ipasctocollate comments|textaudit}
{help varname:mediavar} 
{help if:[if]} {help in:[in]}
{cmd:, folder("folder path") save("filename")}
[{it:{help ipasctocollate##options:options}}]

{marker options}
{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:* {opt folder("folder path")}}folder containing comments/textaudit files{p_end}
{synopt:* {opt save("filename")}}save dta file{p_end}
{synopt:  {opt replace}}overwrite saved dta file{p_end}
{synoptline}
{p2colreset}{...}

{phang}* options {opt folder()} and {opt save()} is required.

{title:Description} 

{pstd}
{cmd:ipasctocollate} imports, appends and exports a single .dta dataset for text 
audit and comments data. This data is prepared for use by the {helpb ipachecktextaudit}
and {helpb ipacheckcomments} commands. {cmd:ipasctocollate} requires the data in memory
to have a "mediavar" which contains strings matching the names of files to import 
from {cmd:folder()}
 
{title:Options}

{phang}
{cmd:folder("folder path"} specifies the folder that contains the text audit and comments files. 
{cmd:ipasctocollate} will cross check for files in {cmd:folder()} using the values
specified as {cmd:mediavar}. {cmd:ipasctocollate} will display a message if some of
files are not cound in the folder specified. 

{phang}
{cmd:save("filename"} specifies the .dta file to save after collating and appending
the text audit or comments files.   

{phang}
{cmd:replace} overwrites an existing .dta file.

{hline}

{title:Examples} 

{synoptline}
  {text:create a dataset of text audits from the variable text_audit}
	{phang}{com}   . ipasctocollate textaudit text_audit, folder(X:DMS/4_data/2_survey/media) 
	save(X:DMS/4_data/2_survey/ta_data) replace{p_end}
{synoptline}
  {text:create a dataset of comments from the variable field_comments}
	{phang}{com}   . ipasctocollate comments field_comments, folder(X:DMS/4_data/2_survey/media) 
	save(X:DMS/4_data/2_survey/field_comments) replace{p_end}
{synoptline}

{title:Stored results}

{p 6} {cmd:ipasctocollect} stores the following in r():{p_end}

{synoptset 25 tabbed}{...}
{syntab:{opt Scalars}}
{synopt:{cmd: r(N_total)}}number of text audit or field comment files expected{p_end}
{synopt:{cmd: r(N_allmiss)}}number of files found and imported{p_end}
{synopt:{cmd: r(N_miss)}}number of not found{p_end}
{p2colreset}{...}
	
{text}
{title:Author}

{pstd}Ishmail Azindoo Baako, GRDS, Innovations for Poverty Action{p_end}
{pstd}{it:Last updated: May 11, 2022}{p_end}

{title:Also see}

Other commands in ipacheck: {help ipachecktextaudit:ipachecktextaudit}, {help ipacheckcomments:ipacheckcomments}