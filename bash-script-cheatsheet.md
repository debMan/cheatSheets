# Bash Script: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **bash scripts** cheatsheet.


## Pre reuqisits

* What is shell?  
  Shell is like a Waiter servs your commands. Without a shell, it is not
  possible to utilize machine and OS.
* What are shells types?  
  - Command line interface (CLI) like sh, bash, zsh, csh, dash, rbash, ...  
    Run `cat /etc/shells` to see available shells on your OS.
  - Graphical shells like gnome-shell, ...
  - `bash` uses `POSIX` standards.
* `\` escapes special characters like `!`
* Usually insert text into "double quotation", especially for `echo`.
* Some text formating special cases: `\n`, `\t`, `\v`, `\r`.
* Use shebang at the first line like this:  
  `#!/bin/bash`
* The `#` at beggining of line indicates a comment.
* Use strict mode: 
``` bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
```
* Use default value for positional args.
``` bash
set -u
name=${1:-}
if [[ -z "$name" ]]; then
    echo "usage: $0 NAME"
    exit 1
fi
echo "Hello, $name"
```
alsom you can use this method for bypasiing undefined vatiables which you know
should be exist. like:
``` bash
name=${someVar:-}
# or
name=""
```
* Commands you expect to have nonzero exit status.
``` bash
count=$(grep -c some-string some-file || true)
```

## Basic commands

Change directory:

``` bash
cd /var/log
```

Print on screen or to a file:

``` bash
clear
# to clear the terminal before any output
echo -e "Hello \n world" 
# or
echo -e Hello \\n world > test_file
```

Using `>`, overwrites output on a file and using `>>` appends to  the file.  

To get a value from user:

``` bash
read -p "Enter username: " USERNAME
# reads username and saves it on USERNAME variable
echo "Hello $USERNAME"
```
Use `$` to call variable.

To seet a variable, just write variable name and append a `=` then value:  

``` bash
VARIABLE="Something new"
```

**Note that** the space, * and ? is forbidden for avariable names.  
**Note that** the variable names can not be bash keywords like `clear` or
`echo` or something likke that.
**Note that** bash is case sensitive.  
Some system reserved variables are:
* `$HOME`: The users home directory.
* `$PWD`: Current working directory.
* `$OSTYPE`: OS type!.
* `$SHELL`: Current shell path.
* `$BASH_VERSION`: Current bash version
* `$SHELL`: Current shell path.

## If statement

Starting with an example:

``` bash
#!/bin/bash
clear
read -p "Enter password: " PassWord
if [ "$PassWord" == "123" ]; then
    echo -e "OK !"
elif [ "$PassWord" == "abc" ]; then
   echo -e "Maybe !"
else
    echo -e "WRONG !"
fi
```

## More info:
* [Rico's cheatsheets](https://devhints.io/bash).  
* [this](http://redsymbol.net/articles/unofficial-bash-strict-mode/#sourcing-nonconforming-document)
* [Bash Reference Manual](http://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion)
* [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash)
* [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

