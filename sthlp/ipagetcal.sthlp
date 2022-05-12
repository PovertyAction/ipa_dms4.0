{smcl}
{* *! version 4.0.0 Innovations for Poverty Action 11may2022}{...}

{cmd:ipagetcal} {c -} create a calendar dataset

{title:Syntax}

{pmore}
{cmd:ipagetcal}
{help varname}
{cmd:, clear}

{title:Description} 

{pstd}
{cmd:ipagetcal} creates a calendar dataset spanning the dates in {cmd:varname}.
The resulting dataset includes the variable {cmd:index} which contains the number 
for the current observation, {cmd:varname}, which contains the day date as well 
as {cmd:week}, {cmd:month} and {cmd:year} which contains the week month and year 
respectively for each date.  
 
{hline}

{title:Examples} 

{synoptline}
  {text:Setup}
	{phang}{com}   . use "https://raw.githubusercontent.com/PovertyAction/ipa_dms4.0/final/data/household_survey.dta", clear{p_end}

  {text:create a calendar dataset from submissiondate}
	{phang}{com}   . ipagetcal submissiondate{p_end}
{synoptline}

{text}
{title:Author}

{pstd}Ishmail Azindoo Baako, GRDS, Innovations for Poverty Action{p_end}
{pstd}{it:Last updated: May 11, 2022}{p_end}

{title:Also see}

Help: {help day:day}, {help week:week}, {help month:month}, {help year:year}

Other commands in ipacheck: {help ipagettd:ipagettd}