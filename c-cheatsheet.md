# C development: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **SSL** command cheatsheet.

Here I've noted the points which are not clear to me. Maybe many concepts
missed.

## keywords

C keywords are:

```
auto  double  int  struct  break  else  long  switch
case  enum  register  typedef  char  extern  return  union
continue  for  signed  void  do  if  tatic  while
default  goto  sizeof  volatile  const  float  short  unsigned
```

## variables

Here's a list of commonly used C data types and their format specifiers.

```
Data Type        Format Specifier
---------        ----------------   
int                     %d
char                    %c
float                   %f
double                  %lf
short int               %hd
unsigned int            %u
long int                %li
long long int           %lli
unsigned long int       %lu
unsigned long long int  %llu
signed char             %c
unsigned char           %c
long double             %Lf
```

In C programming, octal starts with a `0`, and hexadecimal starts with a `0x`.
For Example:

``` 
Decimal: 0, -9, 22 etc
Octal: 021, 077, 033 etc
Hexadecimal: 0x7f, 0x2a, 0x521 etc
Floati and double: -2.0
Exponent form: -0.22E-5
```

> _**Note:**_ E-5 = 10-5

Some escape characters:

```
\f  form feed
\b  backspace
\r  return
\t  horizontal tab
\v  vertical tab
\n  newline
```
What's the difference between `float` and `double`?

The size of `float` (single precision float data type) is 4 bytes. And the size 
of `double` (double precision float data type) is 8 bytes.

You can always check the size of a variable using the `sizeof()` operator.

More info about variables is available 

[here](https://www.programiz.com/c-programming/c-data-types).

## More info:

* https://www.programiz.com/c-programming

