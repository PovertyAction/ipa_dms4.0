{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 11may2022}{...}

{cmd:ipacodebook} {c -} Save codebook in excel format

{title:Syntax}

{pmore}
{cmd:ipacodebook}
{help varlist}
{cmd:using}
{help filename}
[{cmd:,}
{it:{help ipacodebook##options:options}}]

{marker options}
{synoptset 50 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{bf:note(#, {opt rep:lace}|{opt coal:esce}|{opt long:er}|{opt short:er})}}use notes as labels{p_end}
{synopt:{opt replace}}overwrite Excel file{p_end}
{synoptline}
{p2colreset}{...}

{title:Description} 

{pstd}
{cmd:ipacodebook} creates a codebook in excel format saving the variable name, variable label, variable type, number and percentage of missing values abd number of distinct values for each variable.
 
{title:Options}

{phang}
{cmd:note(#, replace|coalesce|longer|shorter)} specifies how notes and labels should be treated. {cmd:#} specifies the note number to consider. {replace} specifies that the note should always be used as the variable label, {cmd:coalesce} indicates that the note be used if the variable label is missing, {cmd:longer} specifies that the note be used if it is longer than the variable label and {cmd:shorter} specifies that the note be used if it is shorter than the variable label. 

{phang}
{cmd:replace} overwrites an existing Excel workbook.

{hline}

{title:Examples} 

{synoptline}
  {text:Setup}
	{phang}{com}   . sysuse auto, clear{p_end}
	{phang}{com}   . export excel using "auto.xlsx", sheet("auto") replace first(var){p_end}

  {text:export codebook for all variables}
	{phang}{com}   . ipacodebook _all using "auto_codebook.xlsx", replace{p_end}
{synoptline}

{synoptline}
  {text:Setup}
	{phang}{com}   . sysuse auto, clear{p_end}
	{phang}{com}   . export excel using "auto.xlsx", sheet("auto") replace first(var){p_end}

  {text:export codebook for all variables using the notes as variable labels if notes are longer}
	{phang}{com}   . ipacodebook _all using "auto_codebook.xlsx", note(1, longer) replace{p_end}
{synoptline}
	
{text}
{title:Author}

{pstd}Rosemarie Sandino, GRDS, Innovations for Poverty Action{p_end}
{pstd}Ishmail Azindoo Baako, GRDS, Innovations for Poverty Action{p_end}
{pstd}{it:Last updated: May 11, 2022}{p_end}

{title:Also see}

Help: {help codebook:[D] codebook}

User-written: {help codebookout:codebookouk}, {help iecodebook:iecodebook}