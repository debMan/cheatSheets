# A guide for `etckeeper`

_**NOTE:**_ This document is incomplete.

## Basics

Before `apt` installs packages, `etckeeper pre-install` will check that `/etc` 
contains no uncommitted changes. After `apt` installs packages, 
`etckeeper post-install` will add any new interesting files to the repository, 
and commit the changes.  
You can also run `etckeeper commit` by hand to commit changes.  
There is also a `cron` job, that will use etckeeper to automatically commit any 
changes to `/et`c each day.

Due to VCS limits on file metadata storage, empty directories, and special
files, file metadata is stored separately. Among other chores, `etckeeper init` 
sets up a `pre-commit` hook that stores metadata about file owners and 
permissions into a `/etc/.etckeeper` file. This metadata is stored in version 
control along with everything else. The `pre-commit` hook also stores 
information that can be used to recreate the empty directories in the 
`/etc/.etckeeper` file.

Most VCS don't support several special files that you probably won't have in 
`/etc`, such as unix sockets, named pipes, hardlinked files (but symlinks are 
fine), and device files. The `pre-commit` hook will warn if your `/etc` 
contains such special files.

etckeeper hooks into apt (and similar systems) so changes to interesting 
files in `/etc` caused by installing or upgrading packages will automatically 
be committed.


You can use any git commands you like, but do keep in mind that, if you check 
out a different branch or an old version, git is operating directly on your 
system's `/etc`. If you do decide to check out a branch or tag, make sure you 
run `etckeeper init` again, to get any metadata changes:

## Security issues

- etckeeper is careful about file permissions, and will make sure that 
  repositories it sets up don't allow anyone but root to read their contents.
- take care when cloning or copying these repositories.
- the whole .git directory content needs to be kept secret.

## Tutorial

It will depends on:

```
libpython-stdlib libpython2.7-minimal libpython2.7-stdlib python python-minimal 
python2.7 python2.7-minimal python-doc python-tk python2.7-doc binutils 
binfmt-support etckeeper libpython-stdlib libpython2.7-minimal 
libpython2.7-stdlib python python-minimal python2.7 python2.7-minimal
```

``` bash
apt install etckeeper
cd /etc
etckeeper init
```

To commit changes which track the commiting user, use `etckeeper` instead of raw
`git` command. Raw `git` command logs root user info on commit, but `etckeeper`
saves who logged as `sudo`.  
Also, it tracks metadata changes.

``` bash
etckeeper commit "some chaanges"
```

To save metadata file changes when using git

``` bash
etckeeper pre-commit
# then
git commit -am "some changes"
```

Also, `.gitignore` file like

```
# new and old versions of conffiles, stored by dpkg
*.dpkg-*
# new and old versions of conffiles, stored by ucf
*.ucf-*

# old versions of files
*.old

# mount(8) records system state here, no need to store these
blkid.tab
blkid.tab.old

# some other files in /etc that typically do not need to be tracked
nologin
ld.so.cache
prelink.cache
mtab
mtab.fuselock
.pwd.lock
*.LOCK
network/run
adjtime
lvm/cache
lvm/archive
X11/xdm/authdir/authfiles/*
ntp.conf.dhcp
.initctl
webmin/fsdump/*.status
webmin/webmin/oscache
apparmor.d/cache/*
service/*/supervise/*
service/*/log/supervise/*
sv/*/supervise/*
sv/*/log/supervise/*
*.elc
*.pyc
*.pyo
init.d/.depend.*
openvpn/openvpn-status.log
cups/subscriptions.conf
cups/subscriptions.conf.O
fake-hwclock.data
check_mk/logwatch.state

# editor temp files
*~
.*.sw?
.sw?
\#*\#
DEADJOE

```

## Source

You can clone `etckeeper`

``` bash
cd ~/workspace
git clone git://git.joeyh.name/etckeeper.git
```


