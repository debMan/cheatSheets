# MarkDown: A simple personal cheat sheet

Here is a simple markdown cheatsheet.

_**Note:**_ This document is incomplete.

## Markdown syntax 

### Format Text

``` markdown
_italic_
**bold**
_**italic_bold**_
**_italic_bold_**

# Heade one
## Header two 
...
###### Header six
```

headers can only combine with italic like below:

``` markdown
### this is a _sample_ header
```

### Links

#### inline:

``` markdown
[Visit GitHub!](www.github.com)
[link to google](www.google.com)
####The Latest News from [the BBC](www.bbc.com/news)
```
#### reference:

The other link type is called a reference link. As the name implies, the link
is actually a reference to another place in the document. Here's an example of
what we mean:

``` markdown
     Here's [a link to something else][another place].
     Here's [yet another link][another-link].
     And now back to [the first link][another place].

     [another place]: www.github.com
     [another-link]: www.google.com

Do you want to [see something fun][a fun place]?
Well, do I have [the website for you][another fun place]!

[a fun place]: www.zombo.com
[another fun place]: www.stumbleupon.com
```
### Images

#### Image inline:
``` markdown
![Benjamin Bannekat](https://octodex.github.com/images/bannekat.png)
```

#### Image reference:
``` markdown
![The first father][First Father]
![The second first father][Second FatherFirst Father]

[First Father]: http://octodex.github.com/images/founding-father.jpg
[Second FatherFirst Father]: http://octodex.github.com/images/foundingfather_v2.png
```

### Blockquotes
``` markdown
> start a block using > sign 
and continue on following lines until an empty line

now this paragraph is outside of blockquotes
```

For multiple lines paragraph Notice that even blank lines must contain the
caret character.  
Block quotes can contain other Markdown elements, such as italics, images, or links.

### Lists

This tutorial is all about creating lists in Markdown.  
There are two types of lists in the known universe: unordered and ordered.  
That's a fancy way of saying that there are lists with bullet points, and lists
with numbers.


#### unordered
To create an unordered list, you'll want to preface each item in the list with
an asterisk ( * ). Each list item also gets its own line.  

``` markdown
* Milk
* Eggs
* Salmon
* Butter
```

#### ordered
An ordered list is prefaced with numbers, instead of asterisks. Take a look at
this recipe:  

``` markdown
1. Crack three eggs over a bowl
2. Pour a gallon of milk into the bowl
3. Rub the salmon vigorously with butter
4. Drop the salmon into the egg-milk bowl
```

You can choose to add italics, bold, or links within lists, as you might expect
Occasionally, you might find the need to make a list with more depth, or, to
nest one list within another. Have no fear, because the Markdown syntax is
exactly the same. All you have to do is to remember to indent each asterisk one
space more than the preceding item.

``` markdown
* Tintin
 * A reporter
 * Has poofy orange hair
 * Friends with the world's most awesome dog
* Haddock
 * A sea captain
 * Has a fantastic beard
 * Loves whiskey
   * Possibly also scotch?
```

While you could continue to indent and add sub-lists indefinitely, it's usually
a good idea to stop after three levels; otherwise, your text becomes a mess.

There's one more trick to lists and indentation that we'll explore, and that
deals with the case of paragraphs. Suppose you want to create a bullet list
that requires some additional context (but not another list).  

For example might look like this:

``` markdown
1. Crack three eggs over a bowl.

 Now, you're going to want to crack the eggs in such a way that you don't make a mess.

 If you _do_ make a mess, use a towel to clean it up!

2. Pour a gallon of milk into the bowl.

 Basically, take the same guidance as above: don't be messy, but if you are, clean it up!

3. Rub the salmon vigorously with butter.

   By "vigorous," we mean a strictly vertical motion. Julia Child once quipped:
   > Up and down and all around, that's how butter on salmon goes.
4. Drop the salmon into the egg-milk bowl.

   Here are some techniques on salmon-dropping:

   * Make sure no trout or children are present
   * Use both hands
   * Always have a towel nearby in case of messes
  
```

To create this sort of text, your paragraph must start on a line all by itself
underneath the bullet point, and it must be indented by at least one space

``` markdown
1. Cut the cheese

 Make sure that the cheese is cut into little triangles.

2. Slice the tomatoes

 Be careful when holding the knife.

 For more help on tomato slicing, see Thomas Jefferson's seminal essay _Tom Ate Those_.
```
#### Checklists:

Also checklists are available:

``` markdown
- [x] check 1
- [x] checl 2
- [ ] check 3
- [ ] check 4
```

### Paragraphs

#### Hard Break
to insert new line in markdown 
if u insert a new empty line it will make another paragraph, not a new line  
this called **Hard Break** .

#### Soft Break
to insert a new line in same paragraph, insert **double space** at the end of line  
this called **Soft Break** .

## References

* [markdown-here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

