# sed: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal `sed` command cheatsheet.

## Basics:

### The essential command: s for substitution
The substitute command changes all occurrences of the regular expression into
a new value. A simple example is changing "day" in the "old" file to "night"
in the "new" file:

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
* sed editor changes exactly what you tell it to. So if you executed
* sed is line oriented. (First match on each line will be changed)

| part | task |
|------|------|
| s	|  Substitute command |
| /../../ |  Delimiter |
| one |  Regular Expression Pattern Search Pattern | 
| ONE |  Replacement string |



## More info:

For more info about regex [click here](http://www.grymoire.com/Unix/Sed.html)
