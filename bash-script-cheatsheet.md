# Bash Script: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **bash scripts** cheatsheet.


## Pre reuqisits

* What is shell?  
  Shell is like a Waiter servs your commands. Without a shell, it is not
  possible to utilize machine and OS.
* What are shells types?  
  - Graphical shell: Like sh, bash, zsh, csh, dash, rbash, ...  
    Run `cat /etc/shells` to see available shells on your OS.
  - Command line interface (CLI): Like gnome-shell, ...
  - `bash` uses `POSIX` standards.
* `\` escapes special characters like `!`
* Usually insert text into "double quotation", especially for `echo`.
* Some text formating special cases: `\n`, `\t`, `\v`, `\r`.

## Basic commands

Change directory:

``` bash
cd /var/log
```

Print on screen or to a file:

``` bash
echo -e "Hello \n world" 
# or
echo -e Hello \\n world > test_file
```

Using `>`, overwrites output on a file and using `>>` appends to  the file.  

To get a value from user:

``` bash
read USERNAME
# reads username and saves it on USERNAME variable
echo $USERNAME
```
Use `$` to call variable.

## More info:

You can check [here](https://medium.com/@sauvik_dolui/a-few-git-tricks-tips-b680c3968a9b) for more info about git.
And a [document](https://gist.github.com/rvl/c3f156e117e22a25f242) for pushing to multiple repos.

