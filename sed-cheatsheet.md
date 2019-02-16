# sed: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal `sed` command cheatsheet.

## Basics:

### The essential command:
The substitute command `s`, changes all occurrences of the regular expression
into a new value. A simple example is changing "day" in the "old" file to
"night" in the "new" file:

``` bash
sed s/day/night/ <old >new
# or
sed s/day/night/ old >new
```

I recommend you do use quotes. If you have meta-characters in the command,
quotes are necessary. And if you aren't sure, it's a good habit, and I will
henceforth quote future examples to emphasize the "best practice." Using the
strong (single quote) character, that would be: 

``` bash
sed 's/day/night/' <old >new
```

_**Notes:**_  
* `-r` or `-E` option adds regex extended regex capability.
* sed editor changes exactly what you tell it to:  
    `echo Sunday | sed 's/day/night/'` result in: `Sunnight`
* sed is line oriented. (First match on each line will be changed)
* to use exact slash `/`, should escape it by back-slash `\`:  
  `sed 's/\/usr\/local\/bin\/bash/\/bin\/bash/' <old >new `
* Some other deliniators are available:
  - `sed 's_/usr/local/bin_/common/bin_' <old >new`
  - `sed 's:/usr/local/bin:/common/bin:' <old >new`
  - `sed 's|/usr/local/bin|/common/bin|' <old >new`
* use `&` as the matched string:  
  `sed 's/[a-z]*/(&)/' <old >new`
* Using \1 to keep part of the pattern:  
  - Keep the first word of a line, and delete the rest of the line:  
    `sed 's/\([a-z]*\).*/\1/'`
  - output "abcd" and delete the numbers:  
    `echo abcd123 | sed 's/\([a-z]*\).*/\1/'`
  - switch two words around: `sed 's/\([a-z]*\) \([a-z]*\)/\2 \1/'`
* Use `/g` after the substitution command to indicate you want substitude
    globaly.
* Use a number like `/2` after the substitution command to indicate you only
    want to match that particular pattern.
* Use `/g` and `/2` together like:
    `sed 's/[a-zA-Z]* /DELETED /2g' <old >new`  
_**Notice:**_  Don't get /2 and \2 confused. The /2 is used at the end. \2 is
used in inside the replacement field. 
* Use `/w` to write to a file:  
    `sed -n 's/^[0-9]*[02468] /&/w even' <file `
* When the `-n` option is used, the `p` flag will cause the modified line to be
    printed: `sed -n 's/pattern/&/p' <file`
* Using `/I` makes the pattern match case insensitive:  
    `sed -n '/abc/I p' <old >new`  
    Note that a space after the '/I' and the 'p' (print) command emphasizes
    that the 'p' is not a modifier of the pattern matching process, but a
    command to execute after the pattern matching. 
* You can combine flags. Note that the `w` has to be the last flag:  
    `sed -n 's/a/A/2pw /tmp/file' <old >new`  
    `sed -n 's/PATTERN/&/p' file`:  Nothing is printed, except those lines with
    PATTERN included. 
* One method of combining multiple commands is to use a -e before each command:
    `sed -e 's/a/A/' -e 's/b/B/' <old >new`
* If you have a large number of sed commands, you can put them into a file and
    use: `sed -f sedscript <old >new`
* Restricting to a line number Example: Delete the first number on line 3:  
    `sed '3 s/[0-9][0-9]*//' <file >new` 
* Restricting to a line number and range of lines:  
  - `sed '3 s/old/new/g' <old_file >new_file'`  
  - `sed '3,10 s/old/new/g' <old_file >new_file'`  
  - `sed '3,$ s/old/new/g' <old_file >new_file'`: From line 3 to last line.
  - `sed '3,10 s/old/new/g' <old_file >new_file'`  
* To delete the first number on all lines that start with a `#`:
    `sed '/^#/ s/[0-9][0-9]*//'`
* If the expression starts with a backslash, the next character is the
  delimiter. To use a comma instead of a slash, use:  
    `sed '\,^#, s/[0-9][0-9]*//'`  
  The main advantage of this feature is searching for slashes. Suppose you
  wanted to search for the string "/usr/local/bin" and you wanted to change it
  for `/common/all/bin.` You could use the backslash to escape the slash:  
    `sed '/\/usr\/local\/bin/ s/\/usr\/local/\/common\/all/'`  
  It would be easier to follow if you used an underline instead of a slash as a
  search. This example uses the underline in both the search command and the
  substitute command:
    `sed '\_/usr/local/bin_ s_/usr/local_/common/all_'`
* You can specify two regular expressions as the range. Assuming a `#` starts a
  comment, you can search for a keyword, remove all comments until you see the
  second keyword. In this case the two keywords are "start" and "stop":  
    `sed '/start/,/stop/ s/#.*//'`  
  _**Note that**_ switches are line oriented, and not word oriented.
* You can combine line numbers and regular expressions. For example, remove
  comments from the beginning of the file until it finds the keyword "start":  
    `sed -e '1,/start/ s/#.*//'`  
  Or next one removes everywhere except the lines between the two keywords:  
    `sed -e '1,/start/ s/#.*//' -e '/stop/,$ s/#.*//'`


### sed in shell scripts

If you have many commands and they won't fit neatly on one line, you can break
up the line using a backslash:

``` bash
sed -e 's/a/A/g' \
    -e 's/e/E/g' \
    -e 's/i/I/g' \
    -e 's/o/O/g' \
    -e 's/u/U/g'  <old >new
```

Another way of executing sed is to use an interpreter script. Create a file
that contains: 

``` bash
#!/bin/sed -f
s/a/A/g
s/e/E/g
s/i/I/g
s/o/O/g
s/u/U/g
```

Also it is possible to pass **arguments** to a sed script.

### Comments

Sed comments are lines where the first non-white character is a `#`. Usually
sed scripts have only comment on first line like:  
```
"#!/bin/sed -nf"
```

## More info:

For more info about sed [click here](http://www.grymoire.com/Unix/Sed.html)
