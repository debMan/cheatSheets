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
`
## More info:

For more info about regex [click here](http://www.grymoire.com/Unix/Sed.html)
