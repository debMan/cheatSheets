# LPIC1: A simple personal handbook

_**Note:**_ All of this document is temporary created and should be edited

### shell variables

``` bash
export				    # export a VAR to sub shels and sob processe
psrintenv  			    # list all variables on bash like $PATH, $HOME, $DISPLAY
unset VAR_NAME			# drop VAR_NAME from bash
env 				    # list all variables on bash like $PATH, $HOME, $DISPLAY
env VAR=value cmd 		# Run cmd with new value of VAR 
echo $?                 # returns exit status code of last command
```

### shell I/O

``` bash
cat 				# prints a file to stdout
cat -b              # prints non-blank numbered lines
cut -d <seprator> -f <col NO> /etc/passwd
# seprate a file with seprator and send specified column
echo				# shows a msg or variable 
less                # show stdout in nice way, it should be piped after other commands
cmd1 ; cmd2 ; cmd3	# run multi commands 
cmd1 && cmd2		# cmd2 runs if cmd1 runned success
cmd1 || cmd2		# cmd2 runs if cmd1 NOT runned success
cmd  > filename		# send output to filename (ovewwrite)
cmd >> filename		# append output to filename
cmd < filename		# send input data to cmd from filename
wc 					# print newline, word, and byte counts from std input or file (-l , -c, -w)
grep -i				# find something from std input or file (-i for ignore case)
uniq                # report or omit repeated lines
tr                  # Translate, squeeze, and/or delete characters from standard input

# Example
# $ sort < temp.txt | uniq -c | sort -nr
#  5 mina
#  3 ali
#  2 sara
#  2 reza
#  2 keyvan
#  1 jafar

sed 's/old/new/'    # it replaces first old word of each line wiith new like vim 
sed 's/old/new/g'   # it replaces globaly
sed -E 's/old/new/' # it support regex
```

### shell 

``` bash
# dir starting with / called absulute and without / called relative
# file namein linux is consist of full path (dirname + basename)
uname -a            # display linux system info
hostname            # display hostname (it shows ip with -i switch)
last reboot         # it can show more things last {reboot, syslog, ...}
whoami              # returns current user logged in
basename FILE       # returns base name of file
dirname FILE        # returns dir name of file
du -ha				# shows disk usage by files in human readable
whereis				# shows bin file of a cmd
which 				# where is executable file 
head				# open first lines of file (default 10 lines)
tail				# open last lines of file (default 10 lines)
tail -f             # open last lines of file in live mode (update changes)
ls -ltrha           # list all files and folders time sorted reversed human readable mode
mkdir -p 			# make dirs with their parrents
cp -r 				# copy folders and its files recursively
stat filename		# view Inode details
dd			 		# make image byte by byte to a file
time CMD 			# calculate time for proccessing CMD
date                # returns date and time
date +"%Y%m%d%H%M"  # returns date and time formated
cal                 # show calendar
id                  # show the active user id with login and group
who                 # show who is logged on the system
w                   # like who with more details
pwd                 # returns current dir
touch               # create file or update access time of file
gpg -c FILE         # encrypt file
gpg FILE.gpg        # decrypt file
ssh <username>@<host>  -p1234 
scp SOURCE_FILE user@host:DEST_FILE
```

### expansion

```
*					# anything with any length
?					# anything with static kength in number of ? signs
[]					# anything with one of chars in []
{}					# all of args in {}
```

### find

``` bash
find . -iname foo\* 				# find NOT case sensative starting with foo files
find . -type d,l,f  				# find directorys , links and files
find . -size +1k    				# size of result is > 1kB
find . -exec CMD {} \; 				# execute a CMD on each result
find . -type f -inum 123456			# find files with Inode number
# other switches:
#	-atime, -ctime, -mtime # acces , change , modif fime bye day
#	-amin,	-cmin,	-mmin  # acces , change , modif fime bye minute
# find . -amine -4  				# files has acces time less than 4 minutes
# find . -regex                     # find with regex pattern
```

### partitioning

``` bash
fdisk								# partitioning tool for MBR
gdisk								# partitioning tool for GPT
#cmds : p , l L , m ? , n , 
mkfs -t /dev/sdb1 {vfat,ntfs,ext3}	# format partitions
mkfs. -# + Tab key 				# shows all filesystems work with mkfs
blkid /dev/sdb1						# shows partition detalis
mount DEVICE MOUNT_POINT -o {rw,ro}	# mounts a disk partition to a mount point
# mount could be done with just DEVICE or MOUNT_POINT if it has been defined in /etc/fstab
# mount -a 							# mount all devices defined in /etc/fstab
umount DEVICE or MOUNT_POINT		# un-mount a partition from mount point
mount 								# shows any mounted device with mount options & filesystem
df -h 								# shows any mounted device with sizes
du -ah                              # show disk usages for files and directorys (-s switch show only totals)

cat /etc/fstab						# auto mounting config file
Example : 
# /dev/sda4    /media/mrht74/c    auto    defaults,rw,users    0    0
# the above line points that any user can mount
```

### user management

``` bash
# /etc/group							# groups db
# groupname:x:gid:users joined this group
groupadd new
groupdel new
groupmod -g [gid] -n[name]
#groupmod -go [gid] -n[name] 		# overwrite gid

# ...............

# /etc/passwd							# users db
# username:x:uid:primary_gid:details:$HOME_addr:shell_name
# we could disable user from logging in by setting shell_name to another program

useradd -m -s [shell_name] username # creates a new user
useradd username -g [pg_name] 		# adds user to group_name as primary group
# -m careates home dir for user , -s changes the shell , -G adds user to some other groups , -d chages home folder addr
# useradd config file at : /etc/default/useradd

gpasswd -a user_name group_name 	# adds user_name to group_name
# gpasswd used to administer /etc/group, and /etc/gshadow. Every group can have administrators, members and a password. -d deletes group from user Groups which memebered
groups user_name					# returns groups user_name is memeb of them
usermod -l new_name					# modify user name #
 -L: Lock  -U: unlock  -d: chage home dir 
userdel -r 							# delete user with its Home folder


# /etc/shadow							# passwords db
# username:pass:
# pass field types:
#	user::							# user without pass
#	user:!:							# disabled account
#	user:*:							# disabled account
#	user:!_ENCRYPTED_PASS_:			# dissable account temporary  , it wil chage with usermod -L -U
#	user:djnaskdbajdshbjasdh_ENCRYPTED_PASS_djhsbajhbdajdhbajd:
#
passwd user_name					# change password for username

# IMPORTANT #
#└── sudo vs su direct acces , which one ? # at video 
#   └─────────────────────────────────────────────────

```

### basic permission

``` bash
# a file made up from user , group , acces , file
# access: owner+group+other             # rw-rw---x = 661
# w acces to folder makes it possible to move and delete ist files
# each set :
#		---	> 0
#		--x	> 1
#		-w-	> 2
#		-wx	> 3
#		r--	> 4
#		r-x	> 5
#		rw-	> 6
#		rwx	> 7

chown newowner:newgroup  filename	# change file owner:group
chgrp newgroup filename				# change file group
chmod 777 filename					# change file access
chmod g-w filename
chmod [ugo][+-=][rwx] filename
# all of 3 commands above can be used with -R switch
```

### stickyBit

``` bash
# applies to folders only
# it can prevent delete, rename or movev files in folder by useres with same group access
# /tmp is an example with 777 access and stickybit only
# 4 numbers on Access: 
#			1 	# --t = SUID +  SGID + stickyBit
chmod +t file 						# adds stickyBit to file

# ➜  Desktop ls -l    
# drwxr-xr-x 2 mrht74 mrht74 4096 Jan 22 17:25 new 	# folder access code : 755
# ➜  Desktop chmod +t new && ls -l 					# chmod 1755 new
# drwxr-xr-t 2 mrht74 mrht74 4096 Jan 22 17:25 new    $ x changed to t
# ➜  Desktop chmod -x new && ls -l 					# chmod 1644 new
# drw-r--r-T 2 mrht74 mrht74 4096 Jan 22 17:25 new    # x changed to T
# ➜  Desktop chmod -t new && ls -l 					# chmod 0644 new
# drw-r--r-- 2 mrht74 mrht74 4096 Jan 22 17:25 new    # T changed to -
```

### SUID

``` bash
# applies to executable files
# if it SUID set, file will execute by its owner although run by any user
# /usr/bin/passwd is an example with (4755/-rwsr-xr-x) access
# 4 numbers on Access: 
#			4 	# s-- = SUID +  SGID + stickyBit
# it goes on x place at ls -l , like above , nad switches between s and S if x or -
chmod u+s filename					# adds SUID to file
```

### SGID

``` bash
# applies to exec files and folders
# on exec files SGID works like SUID and set runs exec file as its group access
# on folder if enabled, any files creates on this folder, gets group of folder (not file maker group)
# 4 numbers on Access: 
#			2 	# s-- = SUID +  SGID + stickyBit
# it goes on x place at ls -l , like above , nad switches between s and S if x or -
chmod g+s filename					# adds SGID to file
```

### links

``` bash
ln SOURCE DEST 						# crate link to first file inode on target
# this is hard link not working on directorys and cross partition
# single file with multi names (dir name + base name), takes unique Inode and disk space
# this is a link from name to Inode

ln -s SOURCE DST 	 				# crate symbolic link to first file inode on target
# this is symbolic link working on directorys and cross partition
# this is another file from source file , linked to source
# this is a link from name to another name
# -d switches make link to directories
```

### compression & archiving

``` bash
# gzip not working on pre-comprssed files preparely, 
gzip    filename 					# zip wiith d alg filename
# overwrites new file to old file
gzip -c[1-9] oldfilename > newfile.gz
# create zip on new file with power in 1-9
gzip -d filename.gz					# unzip filename

bzip2    filename 					# zip with b alg filename
# better time and comppressing
# other cmmds like gzip

xz -c oldfilename > newfile	 		# zip with b alg filename
# long time in compression and fast time in decompression

# Example:
# ➜   ls -lh
# -rwxr-xr-x 1 mrht74 mrht74 33M Jan 23 14:35 test.so
# ➜   time gzip -c test.so > test.so.gz
# gzip -c test.so > test.so.gz  3.51s user 0.03s system 99% cpu 3.538 total
# ➜   time bzip2 -c test.so > test.so.bz2
# bzip2 -c test.so > test.so.bz2  6.74s user 0.03s system 99% cpu 6.774 total
# ➜   time xz -c test.so > test.so.xz  
# ls -lh
# xz -c test.so > test.so.xz  32.27s user 0.12s system 99% cpu 32.399 total
# ➜   ls -lh
# -rwxr-xr-x 1 mrht74 mrht74  33M Jan 23 14:35 test.so
# -rw-rw-r-- 1 mrht74 mrht74  11M Jan 23 14:39 test.so.bz2
# -rw-rw-r-- 1 mrht74 mrht74  12M Jan 23 14:38 test.so.gz
# -rw-rw-r-- 1 mrht74 mrht74 8.2M Jan 23 14:40 test.so.xz

tar -cvf  OUTPUT_TAR_FILE				# archive files to putput file
tar -cvzf OUTPUT_TAR_FILE				# archive and compress using gzip files to putput file
tar  -xf  INPUT_TAR -C OUTPUT_DIR 		# extract archive to output dir
tar -xzf  INPUT_TAR -C OUTPUT_DIR 		# extract compressed archive to output dir
# -z , -j , -J are switches for gzip, bz2 and xz for compression
# if set  OUTPUT_DIR to / , then the files go to their default foldder
tar  -tf  INPUT_TAR 					# list archive content

find /etc/apache2 | cpio -o > OUTPUT 	# creates cpio file
cpio -di < INPUT_FILE					# extracts cpio file 
# if input files when archiving has relative addresses , then extracting will be relative

rar x FILE.rar  						# extract file in current directory
rar x tecmint.rar /des/dir				# extract file in dest directory
rar a OUT.rar SOURCE 					# create archive from source on out
# switches: -hp set password for names and content with prompt
#			-p set password for content with prompt
#			-rr[N] set recovery level
#			-v<size>[k|b|f]Create volumes with size=<size>*1000 [*1024, *1]
```
			
### proccess

``` bash
# any proccess made of PID, PPID, Prioty, Owner (user or UID), state, pmem, pcpu, 
ps 										# shows proccesses on current shell
ps -e 									# shows entire system proccesses
ps aux 									# BSD switches, shows another list of details
# ps -f # shows more details
# ps -l # shows long list
# ps -H # shows as tree
# ps -eo pid,ppid,uid,user,pcpu,pmem,state,stat,cmd,comm,priority,psr,f,fname,stime,etime,mlwp
# above cmd formats output result 
# proccess states: S, R, T, Z,
pstree									# shows ps tree
pgrep -a PS_NAME						# finds proccess PID
kill -SIG PID							# send signal SIG to ps
pkill PS_NAME                           # kill prossess name
# any signals could bee handled bye programm , but SIGKILL ( -9 ) could not be hanled
# some signals : 
# INT = ctrl+C = -2 , TERM = -15 , KILL = -9 , STOP = -19 , CONT = 18
killall PS_NAME							# kill all ps named PS_NAME	
pkill PS_NAME 							# kill ps named PS_NAME

# prioty is in 0-39
# default is 20
# just root can run a ps with priority lower than 20
nice -n+19 cmd 							# runs CMD with 39 priority code
# nice number is in -20,+19 equal to 0,39
renice -n PRI_NUM -p PID -u USER		# change a ps priority

top 									# intractive ps manager
htop									# intractive ps manager

CMD & 				# send cmd to background
jobs 				# show active jobs
fg JOB_ID 			# come JOB_ID to foregrounds
ctrl + Z 			# stops current ps and sends it to bg
bg JOB_ID 			# cantinue a bg ps
uptime 				# to view load average and uptime
w                   # show who is online with load averige
watch -n1 CMD 		# runs a cmd periodic
free -m 			# RAM status
swapon -s 			# swap summery
# /proc/cpuinfo is cpu status file

screen -S SCR_NAME	# create a screen
ctrl A+D 			# deatach from a screen
screen -r SCR_NAME  # return to screen
nohup CMD 			# runs cmd under init ps
# not advised to use nohup
```

### packages

``` bash
# RedHat based packages are .rpm files and Debian based packages are .deb files
# Alien converts this packages together
# package naming pattern: package_name-version-release-cpu_arch
rpm -i PACKAGE_NAME 					# install package on rpm based system
rpm -qa  								# query all installed packages 
rpm -ql PACKAGE_NAME 					# list all files of PACKAGE_NAME
rpm -qi PACKAGE_NAME 					# view information of PACKAGE_NAME
rpm -qR PACKAGE_NAME 					# view requirements of PACKAGE_NAME
#any of above query commands could run on .rpm file with switch -p
rpm -q --whatrequires PACKAGE_NAME 		# view which packages requires PACKAGE_NAME to work
rpm -e PACKAGE_NAME 					# removes PACKAGE_NAME
rpm -qf FILE_NAME 						# finds parent package of a single file
rpm2cpio 								# converts rpm to cpio

dpkg -i PACKAGE_NAME 					# install package on rpm based system
dpkg -P PACKAGE_NAME 					# removes PACKAGE_NAME and its config files
dpkg -r PACKAGE_NAME 					# just removes PACKAGE_NAME
dpkg -L PACKAGE_NAME					# view all files of a PACKAGE_NAME 
dpkg -l PACKAGE_NAME 					# ensure a PACKAGE_NAME is installed or not
dpkg -s PACKAGE_NAME 					# view information of PACKAGE_NAME
dpkg -i PACKAGE_FILE 					# view information of PACKAGE_FILE
dpkg -c PACKAGE_FILE					# view all files of a PACKAGE_FILE
dpkg -S FILE_NAME 						# searchs parent package of a single file
dpkg -X PACKAGE_FILE OUTPUT 			# extract dpkg file 

# repositories are set in /etc/apt/sources.list
apt update 								# updates apt cache
apt install PACKAGE_NAME 				# install a package
apt-get clean 							# deletes downloaded .deb archive folder
# downloaded .deb archives in /var/cache/apt/archives
apt-get clean 							# deletes downloaded .deb archive folder
apt autoremove 							# autoremoves unneccesary packages installed
apt upgrade 							# update all packages
apt-mark hold PACKAGE_NAME 				# prevent PACKAGE_NAME from updatingsssssssssssssssssss
# other commands are: unhold, showhold 
apt search KEY 							# search on apt local cache for KEY
apt show PACKAGE_NAME					# shows more infor about pckage
apt-cache depends PACKAGE_NAME			# shows dependencys of a PACKAGE_NAME
apt-cache rdepends PACKAGE_NAME			# shows packages depends to PACKAGE_NAME

# yum config file in /etc/yum.conf
# yum repos are in /etc/yum.repo.d/*.repo

yum install PACKAGE_NAME 				# install a package
yum remove PACKAGE_NAME # don't use 	# remove package and any pckage depends to PACKAGE_NAME
yum upgrade 							# upgrade all of your packages
yum clean packages 						# deletes downloaded .rpm archive folder
# by default is in /var/cache/yum
yum search KEY 							# search on yum local cache for KEY 			
yum list {all,available} 				# lists {all,not-installed} packages
yum info PACKAGE_NAME 					# shows more infor about pckage
# IMPORTANT #
# └── yum config file edit # at video 
#    └────────────────────────────────
```

### vim skill

#### basics
```
# by default in command mode
# i		insert mode
# v		visual mode
# a		append mode (insert after curser)
# A		append mode at end of line (shift + a)
# o		open new blank line below curser and switch to insert mode
# O 		open new blank line above curser and switch to insert mode (shift + o)
# :q! 		quite without save
# :wq		save and exit
# :x		save and exit
# ZZ		save and exit (shift + z + z)
# :w		save
# :wq FILE_NAME	saves as new file 
# ctrl + g	print current file status and curser location
# :f            print current file status and curser location
# :! CMD	execute externam terminal command CMD
# :r FILENAME	retrieves disk file FILENAME and puts it below the cursor position
# :r !CMD	reads the output of the command and puts it below the cursor position
# :syntax off	turn off syntax highlighting
# :set nu 	show line numbers (:set nonu to hide line numbers)
```

#### movement
```
# Typing a number before a motion repeats it that many times example: 2w, 3e, 
# h,j,k,l	to move curser by char
# w,b,e 	to move curser by word
# %         jump to matching (,{,[ or ],},)
# (also can use W,B,E which jump only on spaces, not _ , - )
# :LINE_NO 	jumps to line number
# 0 		jumps at start of of line = home
# $		jumps to end of line = end
# G		jump to last line (shift + g)
# gg		jump to first line
# ctrl + f	page down
# ctrl + b 	page up
```

#### delete text
```
# x		        delete char under curser like Delete key
# X		        delete char before curser like back space (shift + x)
# dw		    delete word from curser until next word
# de		    delete word from curser until last char of current word
# D		        white the line from curser to end of line (shift + d)
# dd		    delete current line
# Number + dd 	delete some lines from current line to down count number
# dG 		    deletes entire lines below (d + shift+g)
```

#### replace text
```
# r + New_char	replace current char with new_char
# cw		delete current word and go to insert mode
# R 		switch to replace mode (shft + r), replace inserted char until esc
```

#### history
```
# u		undo one step (:undo)
# U		undo total chages of current line (shift + u)
# ctrl + r	redo one step (:redo)
```

#### copy, paste
```
# yy 		copy current line
# yw		copy one word,
# Number + yw	copy Number of words (also can press y+Number+w)
# Number + yy	copy number of lines below curent curser
# p 		paste after current line
# P 		paste befor current line (shift + p)
```

#### visual mode
```
# all movement keys also work in this mode
# v		switch to visual mode
# y 		copy selected text
# d		copy and delete selected text (cut)
# :w		after selecting press :w FILENAME to save selected part as new FILENAME
```

#### search and replace
```
# /WORD			search forward
# ?WORD			search backward
# / + enter		jump to next word found (also can press n)
# ? + enter		jump to previous found  (also can press N)
# :s/old/new/g		to substitute 'new' for 'old' in current line (delete g to apply for first word found)
# :#,#s/old/new/g	#,# are the range of lines where the substitution is to be done.
# :%s/old/new/g		to change every occurrence in the whole file.
# :%s/old/new/gc	to find every occurrence in the whole file, with a prompt to substitute or not
# :set xxx		sets the option "xxx".  Some options are:
#	'ic' 'ignorecase'	ignore upper/lower case when searching
#	'is' 'incsearch'	show partial matches for a search phrase
#	'hls' 'hlsearch'	highlight all matching phrases
#	'no+xxx'		disables xxx option
```

### hardware and network

``` bash
dig DOMAIN              # get DNS info for domain
dig -x host             # reverse lookup host
host google.com         # lookup DNS ip address for name
sudo netstat -tulpn     # view open ports in ubuntu
sudo netstat -ntlp 		# like above
sudo netstat -vatn      # like above
sudo ufw allow 6880     # open a port
dmesg                   # dmesg is used to examine or control the kernel ring buffe
cat /proc/cpuinfo       # display cpu info
cat /proc/meminfo       # display memory info 
cat /proc/interrupts    # show interrupts per cpu per I/O 
free -t                 # show free and used memory (-m, -g, -mega, --giga, --si ,-t)

lshw                    # display info about hardware configurations
lsblk                   # show block device related info in linux
lspci   			    # list all pci slotss (-t -v, -k, -vv, -vvv )
lsusb                   # list all usb slots  (-t -v)
lshw -class network     # list all network hardwares
lsmod                   # view which modules loaded on kernel
modinfo MODULE_NAME     # Show information about a Linux Kernel module
dmidecode               # show hardware info from the BIOS
hdparm                  # get/set SATA/IDE device parameters
# Example :
hdparm -i /dev/sda      # show info about sda
hdparm -tT /dev/sda     # read speed test on sda

ifconfig -a             # list all network interfaces
# Examples:
# ifconfig eth0 up [or down]
# ifconfig eth0 192.168.1.100/24 up 
ethtool eth0            # view [and edit] network interfaces properties of eth0 interface
# -i shows driver info, -S shows statistics, -p blink network card light
# -s change settings (see man ethtool)
# Example: ethtool -s eth0 speed 100 duplex full autoneg off
ip                      # main network tools alternative to ifconfig
# Examples:
ip link show                # show interfaces
ip link show dev eth0       # show interface eth0
ip link set down dev eth0   # set down eth0
ip addr show dev eth0       # show ip address of eth0
ip addr flush dev eth0      # clear ips of eth0
ip addr add 192.168.1.100/255.255.255.0 dev eth0    # add ip to eth0
ip addr add 192.168.1.101/24 dev eth0               # add ip to eth0
ip addr del 192.168.1.101/24 dev eth0               # delete ip from eth0

# if primary ip got deleted , all secondary ips will delete too
# but secondary ips could be deleted one by one
# ifconfig only shows primary ip address, but ip shows all
# ip supports shortened commands like ro=route, sh=show, del=delete, ...

ip route show               # shows routing table
route -n                    # shows routing table
ip route add 8.0.0.0/8 via 10.1.1.201
ip route add 0.0.0.0/0 via 192.168.1.1      # set default gateway 
ip ro add default via 192.168.1.1           # set default gateway 
ip ro del 8.0.0.0/8         # delete route
# if main route got deleted, althogh existance of ip and link UP, but can not ping anyone

# DNS is in /etc/resolv.conf
nslookup            # obtain an domain ip from DNS servers in /etc/resolv.conf
host                # obtain an domain ip from DNS servers in /etc/resolv.conf
dhclient -v         # set network config by DHCP 

ifup eth0           # up a network interface with default config in /etc/network/interfaces
# Debian network script
# permanent ip configs stored on /etc/network/interfaces
# this file used on ifup eth0
# Example:
# auto eth0       # this line must add to enable this config on boot
# iface eth0 inet static
# address 192.168.1.20/24 
# gateway 192.168.1.1
# dns-nameservers 4.2.2.4
# up CMD              # run CMD when this interface get UP
# down CMD            # run CMD when this interface come DOWN
# or we can use DHCP
i# face eth0 inet dhcp 

# RedHat network script
# permanent ip configs stored on /etc/sysconfig/network-scripts/ folder
# there is ifcfg-* files for each interface 
# on boot any file starting with ifcfg- in this folder loaded, names not important
# Example:
# DEVICE=eth0
# HWADDR=00:00:00:ff:ff:ff
# TYPE=Ethernet
# UUID=xxxxxxxxxxx
# ONBOOT=yes      # equels to auto eth0 on Debian
# BOOTPROTO=dhcp

#--or we can use static

# BOOTPROTO=none
# IPADDR=192.168.4.37
# PREFIX=24   # or we can use   NETMASK=255.255.255.0
# GATEWAY=192.168.4.1
# DNS1=8.8.4.4
# DNS2=4.2.2.4
# NM_CONTROLLED=yes
```

### boot loader

``` 
# Firmware -#> MBR at boot (Master Boot Record )
# Sector 0 - first 512 bytes of Hard Disk , contains boot loader + PT + Reserved
# 446 bytes -#> code , 64 bytes -#> PT (Partition Table) , 2 bytes -#> Reserved
# boot loaders programs :  
#   LILO (Linux Loader)
#   GRUB Legacy
#   GRUB2
#
# boot loader should : (LILO work like this)
# 1.know partitions
# 2.know filesystems (ext4)
# 3.Load kernel
#
# GRUB work like this : GRUB stage 1, GRUB stage 2
# 1.know partitions 
# 2.know filesystems (ext4)
# 3.Load Grub stage 2
#
# grub has features like: password, iso file OS load, dual boot support, ...

# EFI 
# EFI has native boot manager can load other boot loaders
# EFI allow you to select a boot loader to run after boot
# EFI installed on first sector (boot sector) of a partition (not entire Hard)
# EFI -#> ESP (EFI System Partition) -#> mount /boot/efi/.../... .efi

# on grub menu: 
#   press e to edit grub options
#   press c to open grub shell
# we can use grub shell to load linux kernel manualy
# we should go and find kernel
# kernel usualy located on /boot/kernel* or /boot/vmlinuz*
# kernel has some parameters on load
#
#
# grub shell commands
ls                                  # list hard disks and partitions
ls (hd0,1)/                         # list (hd0,1) partition files
set root =(hd0,1)                   # by setting this next time we can use ls /
ls -l /boot                         # list boot partition to find kernel
linux /boot/vmlinuz* root=/dev/sda1 # load kernel and add root parameter 
linux /boot/vmlinuz* root=/dev/sda1 ro # loads kernel read only (security option)
initrd /boot/initrd.img*            # load kernel loading dependencies like ext4,...
boot                                # start booting
```

### linux startup

``` bash
# Firmware -#> boot loader -#> kernel -#> initialization process (init)
# initialization process programs:
#   systemV (sysV) , system-d, ...
# /sbin/init is first and only program runs by kernel with PID=1 with a runlevel
# /etc/rc[0-5].d files are runlevel config files used by init
# runs any script file on /etc/rc2.d/* (these files linked to a script on /etc/init.d/FILE)
# scripts with name starting with s* , runs by "start" parameter
# scripts with name starting with k* , runs by "stop" parameter
runlevel                            # prints current runlevel
# runlevels 0,1,6 are predefined on different distros, runlevel descriptions are:
# 0 shutdown                        -any distro
# 1 Single, S, s, Single User Mode  -any distro     # only root login without pass for troubleshooting
# 2
# 3 -RedHat based uses this         GUI not loaded
# 4
# 5 -RedHat based uses this         GUI
# 6 reboot                          -any distro
#
# Debian based not use runlevels
#
# on Debian based we can use:
update-rc.d                         # manage runlevels configs
# on RedHat based we can use:
chkconfig                           # manage runlevels configs
chkconfig --list sshd               # shows sshd services status on each runlevel
chkconfig --level 34 sshd off       # turn off ssh on runlevels 3 and 4
```

### graphical enviroment

``` bash
# X-Server : controls input and output (display, mouse, keyboard) work on TCP
# before 2004 linux used X-free 86
# now using X-org 
# any graphical app connects to x-server and uses x-libs
# we name any app connects to x-server as x-client
# we use widget library codes and widgets connect to x11 lib 
# @ using widget has feateres : 1) coding easier, uniform applications
# widgets like gtk+, Qt, Motif, Xaw, ...
#
# window manager is only service connected to x-server
# other applications using window manager
# window manager can handle multiple app windowses
# popular window managers: Metacity, Compiz, kvin, kwm, sawfish
#
# Graphical Login (Display Manager)
# runs before any process, 
# it uses pure x-server to display login
# it runs x-server, then window manager
# popular display managers: lightdm, gdm, kdm, .... 
#
# to make these steps easier , some projects like gnome, kde, unity, xfce, lxde, mate, ... started
# they install x-server, widgets, display manager, window manager, 
# we call these projects Desktop Enviroment (DE)
# gnome, kde, unity are large and high weight
# xfce and lxde are light weight
```

### window & desktop sharing

``` bash
echo $DISPLAY                   # returns display ip and number, default is 127.0.0.1:0
# by changing this var to another ip we can share applications windows on another machine
export DISPLAY=192.168.1.3:0.0  # set destination system to display home system windows
# now we should set destination machine
# we should change display manager config of destination
# on ubuntu
vim /etc/lightdm/lightdm.conf.d/my.conf
# should edit like this
# [SeatDefaults]
# xserver-allow-tcp=true
# now shuld restart lightdm service
service lightdm restart         # restart window manager to take effect accepting external windows to display
# now we should set access control list of destination system's xserver
xhost +192.168.1.2              # add ip to allowed source for display wndows
xhost +                         # allow any ip

# we can use xserver on Microsoft Windows using Xming
# above method is NOT secured
# the secured method is:
ssh -X user@server-ip           # ssh to server allowing xserver forwarding
# xserver forwarding should be enabled on server like this:
# edit /etc/ssh/sshd_config and set X11Forwarding yes and restart ssh service
# on RedHat we can restart ssh like this
# systemctl restart sshd.service
#
#
# --- total desktop sharing
#
# we can use remote desktop with XDMCP by editing display manager config
# in ubuntuwe can edit /etc/lightdm/lightdm.conf.d/my.conf
# [SeatDefaults]
# xserver-allow-tcp=true
# [XDMCPServer]
# enable=true
# now we configed server
# now restart lightdm service #service lightdm restart
# on RedHat based client we should install:
yum install xorg-x11-Xephyr
# on Debian based client we should install:
apt install xserver-xephyr
# then we could user this command
Xephyr -ac -query 192.168.1.2 -br -reset -terminate :2
```

### logging

``` bash
# each log has a facility
# popular facilities: cron, kern, mail, news, syslog, local [0-7], 
# each log has a priority
# priority levels: debug, info, notice, warning, err, crit, alert, emerg
# log has selectors contains facility.priority
# mail.err      /dest/to/file       # log mail err and above err messages on DEST
# mail.!err     DEST                # log mail err and below err messages on DEST
# mail=err      @10.1.1.1           # log only mail err messages on 10.1.1.1 ip
# kern.emerg     *                  # send message to any user logged in 
# /etc/rsyslog.conf is rsyslog config file
# /etc/rsyslog.d/50-default.conf also included 

logger -p kern.emerg 'OOrjansi Residegi KON '      # can send logs for test and for send log on our scripts

# we store security logs on another machine named rsysog server
# we should enable TCP and UDP syslog reception on rsyslog server

dmesg                               # all the messages from the kernel’s buffer
```
#### impoetant logs:

* `/var/log/messages` (RHEL)  -  `/var/log/syslog` (DEB) 

 - This log file contains generic system activity logs.
 - It is mainly used to store informational and non-critical system messages.
 - non-kernel boot errors, application-related service errors, messages logged
   during system startup
 - first log file to check on any problem
 
* `/var/log/auth.log` (DEB)  -  `/var/log/secure` (RHEL)

 - authentication related events in Debian
 - failed login attempts
 - All user authentication events are logged at /var/log/secure

* `/var/log/boot.log`

 - system initialization script, /etc/init.d/bootmisc.sh, sends all bootup messages to this log file
 - Can also be useful to determine the duration of system downtime caused by an unexpected shutdown.
 - issues related to improper shutdown, unplanned reboots or booting failures

* `/var/log/dmesg` (RHEL)

 - Kernel ring buffer messages, Information related to hardware devices and their drivers
 - useful for dedicated server customers mostly

* `/var/log/kern.log`

 - logged by kernel, troubleshooting kernel related errors

* `/var/log/apt/history.log`

 - package installation and removal information 

* `/var/log/apport.log`

 - saves information about crashes

* `/var/log/installer`

 - created during installation
 
* `/var/log/dist-upgrade/apt.log`

 - information during distribution upgrades

* `/var/log/dpkg.log`

 - low level details of package install and remove with dpkg

* `/var/log/Xorg.log`

 - information of the graphics driver, its failures, warnings etc

* `/var/log/faillog`
* `/var/log/cron`
* `/var/log/yum.log`
* `/var/log/mail.log`  -  `/var/log/maillog`

 - information about postfix, smtpd, MailScanner, SpamAssassain or any other
   email related services

* ` /var/log/httpd/`

 - Apache serverlogs , main logs are: error_log and access_log.
 - All access requests received over HTTP are stored in the access_log file.
 - Logs the IP address and user ID of all clients that make connection requests
   to the server.

* `/var/log/mysqld.log` (RHEL)  -  `/var/log/mysql.log` (DEB)


### regex

``` bash
# regex engines may be different
# we read pattern char by char
# regex is case sensitive by default
# dash (-) has meaning only at bracket [character class] like [0-9]
# we use \ to use literal meaning of metacharacters
# we should usualy place pattern in ""
# [] means character class, it mean only one char equel on of char inside it
# {k} refers to previous char, means k repeat of prev char
# {n,m} refers prev char should repeat between m and n times
# {,3} and {4,} are valid , setting only min or max repeat times
# ^ means start with
# $ means wnd to
# * equels to {0,}
# + equels to {1,}
# ? equels to {0,1}
# [^SOME_THING] means not having SOME_THING # ^ in the [] means NOT
# \d means [0-9] (not work in bash )
# | means or
# ( uses for sub pattern)

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

# in find command , it has ^ and $ by default
# Example:
find . -regex ".*ser.*"             # it finds file named insert.py
```

### cron 

``` bash
# it automaticly do something
crontab -e                          # to edit cron file
# crontab -r                        # clears the crontab file -#> WARNING! 
# cron files stored in /var/spool/cron/crontabs
# each line in this file is for one schedule
# each schedule has 6 parameters seprated by white space
# a cron task syntax like this :
# * * * * * mkdir /home/mrht74/Desktop/AAA   # executes every minute
# Minute  Hour  Day  Monthr  WeekDay  Command
# columns be anded together
# each column number refers to number of that fied
# we can use , in each columnt to use multiple values (usualy use this)
# we can use */10 to set periodic time
# Example:
# 5     6  *  *  *      ls                  # ls every day on 06:05
# *     8  *  *  *      ls                  # ls every minute from 08:00 to 06:59 every day 
# 0,30  7  *  *  tue    ls                  # every week on tuesday at 07:00 and 07:30
# */10  4  *  *  *      ls                  # runs at 4:00, 4:10, 4:20, 4:30, 4:40, 4:50
# $PATH variable value is different from local in cron jobs
# in cron path is  $PATH=/usr/bin:/bin
# we have 2 solutions:
# 1) copy user PATCH at begining of script
# 2) use complete command names like /sbin/iptables

# we have some folders in /etc/cron.*
# cron.daily/    cron.hourly/   cron.monthly/   cron.weekly/ 
# which are for packages automatic jobs
# we can not use interactive scripts on cron
```

### mysql database

#### mysql basics 

``` bash
# we can use mariadb-server alternative to mysql
service mysql start         # start mysql service (start/stop/restart/status)
mysql -u root -p            # open mysql as root and prompt for pasword
mysql -u root -pPASS        # open mysql as root and PASS
mysql_secure_installation   # some step by step prompts to secure mysql

# we can run sql script like this:
cat script.sql | mysql TABLE_NAME -u root -pPASS -t    # -t draws tables on stdout
mysql TABLE_NAME -u root -pPASS -t < script.sql
```

#### some mysql shell commands

``` sql
-- this is a comment
SHOW DATABASES;             
-- commands are case sensitive but we type upper case
CREATE DATABASE test;       
-- DB name is case sensitive on GNU/Linux and solaris and BSD (not MS Windows)
USE school                  
-- WARNING! we shouldn't place USE on sql scripts, we should send db name as
-- mysql command parameter
SHOW TABLES
DROP TABLE IF EXISTS students

-- CRUD commands are: create, select, update, delete
CREATE TABLE students
(
ID INT AUTO_INCREMENT PRIMARY KEY,
FN TEXT,
LN TEXT,
GENDER ENUM('F','M'),
SCORE INT
);

DESCRIBE students       
-- draw table structre
INSERT INTO students (FN,LN,GENDER,SCORE) VALUES ('Ali','Sadeghi','M',90)
INSERT INTO students (FN,LN,GENDER,SCORE) VALUES ('Azar','Hosseini',FM',95)

SELECT * FROM students 
SELECT FN,LN FROM students;
SELECT CONCAT( IF(GENDER='F','Ms. ','Mr. ') , FN,' ',LN) AS FULL_NAME , SCORE FROM students

UPDATE students SET SCORE=94 WHERE ID = 2
DELETE FROM students WHERE ID = 1
```

#### mysql backup and restore

``` bash
# we can create backup of a database like this:
mysqldump -u root -pPASS school_db > ~/Backups/school_sql_backup.sql

# we can restore like this
mysql resotre_db -u root -pPASS < ~/Backups/school_sql_backup.sql
```

### utility

``` bash
sudo apt install moc
mocp
sudo apt install links
links digikala.com
eog path/to/picture
sudo apt install mplayer
sudo apt install finger
finger USER
```

### fun commands

``` bash
figlet "something"					# word art "something"
figlet `COMMAND`					# word art result of COMMAND
echo "1234" | rev 					# reverse string
tac 								# like cat but from botton to top
sl 									# animation
yes WORD
factor NUMBER
lolcat
cmatric
toilet
echo "SALAM" | toilet | lolcat
```

## VPS

After buy a vps todo:
1. change root pass 
2. add new user
``` bash
gpasswd -a mrht74 sudo 
usermod -aG sudo mrht74
```
3. update and upgrade
4. install python3-pip and python-pip and git and htop
5. install vim and vundle
``` bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
6. change the default SSH port
``` bash
sudo vim /etc/ssh/sshd_config
```
7. Enable 2FA (optional)
8. Use SSH keys 
``` bash
ssh-copy-id mrht74@IP
```
9. set ssh config on client
``` bash
# cat .ssh/config 			
```
10. set webmin (www.webmin.com)
11. Set up a firewall
12. Backup your server
13. Set up monitoring
14. Set up a mail server
15. Install an (S)FTP server
16. Telegram MTProto
  * [Click here](https://github.com/TelegramMessenger/MTProxy)
17. start vpn server
  * [link 1](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04)
  * [link 2](https://www.linuxbabe.com/ubuntu/openconnect-vpn-server-ocserv-ubuntu-16-04-17-10-lets-encrypt)

