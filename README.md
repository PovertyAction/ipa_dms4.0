# Template for user-written Commands

## Overview

This is a template repository that can be used to create a user-written command repository. The following components should exist in all user-written command repositories:

1. A readme file consisting of the followings:  

      a. **Overview**: The overview section should describe command including the purpose, dependencies, relevant files and any other important notes.  
      b. **Installation**: The instllation section should include the installation process. If it is Stata command, the Stata syntax to install the program should be mentioned here.  
      c. **Syntax**: Here the Syntax of the user-written command should be explained.  
      d. **Options**: If the user-written command allows options, the options should be explained here.  
      e. **Example Syntax**: This section should include one or more example syntax.  
      f. Direction to the issue page for the users to report any issues.  

2. The [ado file](https://www.stata.com/manuals13/u17.pdf), [help file](https://www.stata.com/manuals13/rhelp.pdf), [toc file, pkg file](https://www.stata.com/manuals13/rnet.pdf) and any other supporting files for the command should be at the root. 

3. Any additional files those are not part of the user-written command, should be placed in a separate folders. 

4. The folder and file structure can be changed to facilitate any specific purpose.


### To use this repository as a template, click this button: 
<div align="center">
<a href="https://github.com/PovertyAction/Template-user-written-command/generate" target="_blank">
	<img  align="center" src="extras/button.png" width="200">
</a>
</div>

 

![Template](https://i.postimg.cc/L8PKCHx0/New-Template.gif)


## Installation
```stata
* userwrittencommand can be installed from github

net install userwrittencommand, all replace ///
	from("https://raw.githubusercontent.com/PovertyAction/Template-user-written-command/master")
```

## Syntax
```stata
userwrittencommand using filename, [options]
```

To open dialogue box, type: ``db userwrittencommand``



``filename`` can be xls or xlsx. If ``filename`` is specified without an extension, .xls or xlsx is assumed. 


## Options
| Options      | Description |
| ---        |    ----   |
 | replace |  Replace ``outfile`` if already exists. | 
 
## Example Syntax
```stata
userwrittencommand using "Endline Survey.xlsx", replace

```

Please report all bugs/feature request to the <a href="https://github.com/PovertyAction/ipachecksetup/issues" target="_blank"> github issues page</a>
