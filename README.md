# DMS 4.0


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
