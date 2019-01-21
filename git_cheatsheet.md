# Git Cheatsheet

This is my personal **git** cheatsheet

### Basic commands

``` bash
git init                    
# start a project in a directory
git status                  
# displays status
```

### Basic manapulating commands

Basic git proccess: 
* create/edit files 
* send them to stage mode
* commit them

``` bash
git add FILE                
# adds FILE to be tracked by git or in simple words "stage FILE_NAME"
git add -A                  
# adds ALL files to stage
git commit -m "messege for this commit"
# commit with a message 
git commit -a               
# send any change to stage mode and then commit
git log                     
# shows the git log
git diff HEAD               
# shows latest changes on any file with HEAD (last commit)
git diff --staged           
# shows differences in staged files with HEAD 
git reset FILE_NAME         
# takes out FILE_NAME from stage
git checkout -- FILE        
# revert any chages on FILE to last commit (HEAD) to solve problem
```

### Branches

**TIP:** main branch named `master` in git
branches is important part of git

```bash
git branch                  # shows all branches
git branch NEW_BRANCH       # creates NEW_BRANCH
git checkout NEW_BRANCH     # change working branch to NEW_BRANCH
```

on master branch :

``` bash
git checkout master
git merge NEW_BRANCH        # merges NEW_BRANCH to master
git rm FILE_NAME            # deletes FILE_NAME 
git branch -d BRANCH_NAME   # deletes the branch
```

### Remote projects

on a root directory , we use command `clone` to clone a remote project localy

``` bash
git clone ADDR              # clone repo from server by ADDR
```

after cloning, our local project is origin/master
any change is ahead of origin
after changes and commits, we will push on origin

``` bash
git push origin master      # push on origin from my local master
# if we add -u after push, on next push we don't need origin master keywords
git pull origin master      # pull from origin on my local master

# if a project has not a remote, we couldn't push or pull
git remote add origin ADDR  # create origin on ADDR for current git repo
git remote -v               # shows remote info
```
after adding remote we can use push or pull
a project could have several remotes

### Go deeper

``` bash
git show COMMIT_HASH        # shows details of commit with hash COMMIT_HASH
git tag                     # shows tags of project
git tag -a v2.0 -m "MSG"    
# adds tag v2.0 with message MSG on current state of master
git tag -a v1.8  COMMIT_HASH -m "MSG"
# adds tag v1.8 on COMMIT_HASH with message MSG 
# this is useful to add older versions

git tag -l "KEYWORD"        # search on tags with KEYWORD (accepts regex)
git show v1.8               # shows info about tag v1.8
# tags don't operate automatily on push or pull
# we should push or pull tags manualy
git push origin v1.8        # push v1.8 on origin
git push origin --tags      # push all tags on origin
git checkout v1.8           
# checkouts v1.8 , but NOT like branches, its just a tag !!!!
```
### Sign projects

we could sign our commits by gpg

``` bash
gpg --list-keys             # list all of my keys
gpg --gen-key               # generate a key for me
# after create key we use this to obtain our key to use in git
gpg --list-secret-keys --keyid-format LONG 
```

now we can see the output like this: 

``` bash
# /home/mrht74/.gnupg/pubring.kbx
# -------------------------------
# sec   rsa3072/xxxxxxxxxxxxxxxx 2018-07-24 [SC] [expires: 2020-07-23]
#       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# uid                 [ultimate] Mohamad Ali <mrht74@yahoo.com>
# ssb   rsa3072/xxxxxxxxxxxxxxxx 2018-07-24 [E] [expires: 2020-07-23]
```

uniqe key code is after `/` on `sec rsa3072` part which is `xxxxxxxxxxxxxxxx` here
now we should set git secret key

``` bash
git config --global user.signingkey xxxxxxxxxxxxxxxx

git tag -s v2.1 -m "this is signed tag"
# in this line -s signs the tag with my gpg key
git show v2.1               # shows v2.1 tag which has pgp signed string
git tag -v v2.1             # -v means verify this tag
git commit -S -m "MSG"      # commit with signed gpg key
```

### Blame

blame finds writer of code and time

``` bash
git blame FILE_NAME -L4     # shows history of changes on line 4 of FILE_NAME and who changed them
git blame FILE_NAME -L4,9   # shows last changes on line 4 to 9 of FILE_NAME and who changed them
git blame FILE_NAME         # shows last changes on any line of FILE_NAME and who changed them
```

### Bisect

bisect proccess , which finds the best commit to debug the program

``` bash
git bosect start
git bisect bad
git bisect goof COCMMIT_HASH
```

<<<<<<< HEAD

_**Note:**_ This document is completeing ongoing.

### References:
You can check [here](https://medium.com/@sauvik_dolui/a-few-git-tricks-tips-b680c3968a9b) for more info about git.
And a [document](https://gist.github.com/rvl/c3f156e117e22a25f242) for pushing to multiple repos.


=======
_**Note:**_ This document is completeing ongoing.
>>>>>>> 9ba1c68e87168732f667bd81de26162a5b1b5781
