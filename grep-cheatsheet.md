# grep: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal `grep` command cheatsheet.

## Basic commands:

``` bash
grep -n word                    # print line numbers
grep -i word                    # case insensative
grep -c word                    # ount match times
grep -v word                    # invert match (non match)
grep -w words                   # exact words match
grep -x words                   # exact line match
grep -rR                        # recursively whole dir and symlinks

grep ^word
grep word$
grep w.rd
# any words that start with either “l” or “o”.
egrep '^(l|o)' file.txt 
# start with any character range between “l” to “u”.
egrep '^[l-u]' file.txt
# to display all the lines that starts with both upper and lower case letters:
egrep '^[l-u]|[L-U]' file.txt
egrep '^([l-u]|[L-U])' file.txt
fgrep
# use non-regex, special chars are theirorigin

grep -E                             # grep with extended regex
egrep                               # grep with extended regex
egrep ^s                            # grep string starting with s
egrep d$                            # grep string ending to d
egrep ^.$                           # grep string any SINGLE char
egrep ^F.$                          # any dual char string with first char = F
egrep ^F[0123456789]$               # match only with F1,F2,F3,...F9,F0
egrep "^F[0-9]$"                    # match only with F1,F2,F3,...F9,F0
egrep "^[FX][0-9]{4}$"              # any string starting with F or X, with 4 numbers afer that
egrep "^aaa$" = "^a{3}$"            # these are equal
egrep "^z{2,5}$"                    # matchs to zz or zzzz or zzzz or zzzzz
egrep "^5a*5$"                      # matches to 55, 5a5, 5aa5, 5aaa5, ...
egrep "^5a+5$"                      # matches to 5a5, 5aa5, 5aaa5, 5aaaa5, ...
egrep "^5a?5$"                      # matches to 55 and 5a5
egrep "^a[^0-9]*a$"                 # matches with aa, a[anything is not char]*a
egrep "^(ahmad|nima)$"              # matches only to nima or ahmad
egrep "^(s[0-9]{2}|xff)[0-9]{4}$"   # matches with s###### or xff#### (# means a number)
```

## More info:

For more info about regex [click here](https://www.computerhope.com/unix/regex-quickref.htm)
