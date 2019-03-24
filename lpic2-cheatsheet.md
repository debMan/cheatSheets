# LPIC2: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **lpic2** cheatsheet.

## System startup

Order of tasks which done after startup of machine:  
1. Firmware -> POST(Power-On Self Test) -> bootloader (grub)
2. Bootloader finds Kernel
3. Other processes which run by kernel

```  bash
dmesg -H -k      # shows boot process info, -H pagination, -k shows kernel log
# It is a bufer in the kernel (kernel ring buffer )which holds messages while 
# boot, which is independent of hard disk
```

In RHEL family, we will have `/var/log/boot.log` and in Debian family, 
`/var/log/boot`, which stores boot messages.

### Types of boot (based on IBM architecture):

1. BIOS:  
   After POST, it reads OS info from first sector of HDD which named MBR
   (Master Boot Record). The boot loader programms place themselves in the MBR
   which is very small and then boot loader finds kernel and run it.
2. UEFI:  
   Computers which based on UEFI (Unified Extensible Firmware Interface) has an
   ESP (EFI System Partition). Windows used this abiity very well, but in linux
   still prefared to using boot loader. Usually thr ESP has FAT partition type
   and mounted at `/boot/efi`. EFI has a mini boot loader which named **Boot
   Manager** and in linux the `efibootmgr` could manage EFI menues. Linux
   kernel at version `v3.3.0` and upper supports loading directly by UEFI but
   as noted above, it is not used. The feature of using boot loaders like:
   having multi OS, having multi kernels, and etc.

### Bootloaders

1. LILO (Linux Loader):  
   Released at 1990's together with Linux which is
   depreceated now. Lilo doesn't support UEFI. It's configurations available at 
   `/etc/lilo.conf`.  
2. GRUB (Grand Unified Bootloader):  
   grub has two versions: grub1 (legacy, 1999) and grub2 (2005) which suports
   UEFI.

#### GRUB legacy

Its configurations at `/boot/menu.lst` which have global and per OS configs. 
Main keywords of global its config are  :  
`color`: foreground and background color  
`default`: default OS to load  
`fallback`: second OS if default fails  
`hiddenmenu`: don’t display the menu selection options  
`splashimage`: image file to use as the background for the boot menu  
`timeout`: amount of time to wait for a menu selection before default   

And for each OS we have:  
`title`: a simple name for OS  
`root`: disk and partition where the GRUB `/boot` folder partition is located 
with syntax like: `(hd0,0)`  
`kernel`: kernel image file located at `/boot` with syntax like: 
`(hd0,0)/boot/vmlinuz`  
`initrd`: initial RAM disk file, which contains drivers necessary for the 
kernel to interact with the system hardware.  
`rootnoverify`: non-Linux boot partitions, such as Windows  

And a sample config file is like:  

```
default 0
timeout 10
color white/blue yellow/blue
title CentOS Linux
root (hd1,0)
kernel (hd1,0)/boot/vmlinuz
initrd /boot/initrd
title Windows
rootnoverify (hd0,0)
```

To install grub on MBR:

``` bash
grub-instal /dev/sda 
# or
grub-install '(hd0)'
```

#### GRUB 2

_**NOTE:**_ Anything related to **grub legacy** is in `/boot/menu.lst` and the
**grub 2** files stored in `/boot/grub/`.

Also, other grub2 files are:  
`/etc/grub.d/`  
`/etc/default/grub`  
`/boot/grub/grub.cfg`  

The last item content is like: 

```
menuentry "CentOS Linux" {
set root=(hd1,1)
linux /boot/vmlinuz
initrd /initrd
}
menuentry "Windows" {
set root=(hd0,1)
}
```

_**Note:**_ Notice to the different syntax of grub and grub2.  
_**Note:**_ the partition numbers started from `1` in grub2 instead of `0` in 
grub.  
_**Note:**_ The `/boot/grub/grub.cfg` file shouldn't be modified directly by
user. This file updates dynamicaly.  
_**Note:**_ The default global config stored at `/etc/default/grub`.  
 
We use `grub-mkconfig` to create `/boot/grub/grub.cfg` file.

``` bash
grub-mkconfig > /boot/grub/grub.cfg       # prints grub config to stdout
grub-install /dev/sda                     # install grub on /dev/sda MBR sector
```

Also, on grub boot menue, we can use `e` to edit config, and `c`, to open grub
command mode.

Linux systems had problem with UEFI Secure boot. Three solutons are:
Disable  secure boot on BIOS, Sign kernel, Use signed bootloaders (mini
bootloaders).  
Signed bootloaders are *preloader* from Linux Fundation, and *shim* from
fedore. This bootloaders can load grub after start.

## Process initialization

After loading kernel, `init` proccess starts. Kernel searchs for `init` first
at `/sbin/init` or `/etc/init` on failure, and `/bin/sh` as last option.  
`init` should load further proccesses one by one or some at once, 

Main initiation programms are:
sysV  
systemd  
upstart  

### sysV

We have 7 runlevels.

| level | RHEL     | DEB |
| ----- | -------- | --- |
| 0 | shutdown     | shutdown |
| 1 | single user  | single user |
| 2 | -            | GUI + multi user TTY + Network |
| 3 | multi user TTY + Network | - |
| 4 | -            | - |
| 5 | GUI + multi user TTY + Network | - |
| 6 | reboot       | reboot |

``` bash
init <N>
telinit <N>                    # Change SysV runlevel
runlevel                       # Print previous and current SysV runlevel
```

On ubuntu we have:

```
       ┌─────────┬───────────────────┐
       │Runlevel │ Target            │
       ├─────────┼───────────────────┤
       │0        │ poweroff.target   │
       ├─────────┼───────────────────┤
       │1        │ rescue.target     │
       ├─────────┼───────────────────┤
       │2, 3, 4  │ multi-user.target │
       ├─────────┼───────────────────┤
       │5        │ graphical.target  │
       ├─────────┼───────────────────┤
       │6        │ reboot.target     │
       └─────────┴───────────────────┘
```

In some old systems, there is `/etc/inittab` whichcontains:
```
id:runlevel:action:process
id:3:initdefault               # it is default runlevel of system
```

actions are:  
boot: start at boot  
bootwait: start and wait till finished  
initdefault: enter this runlevel by default after boot up  
once: run when the runlevel is entered  
powerfail: start when powered down  
powerwait: start when powered down and wait for it  
respawn: start if terminated  
sysinit: start before any other at boot  
wait: start and wait for finish  

Also, more files located at `/etc/init.d/rc[0-6]` which says what to be 
happened on each level.  
We can handle services in sysV like below:
``` bash
/etc/init.d/network stop
```

Also files located at `/etc/rc3.d/s00network  -> /etc/init.d/network` whic
is a symbolic link and means start network servic with 00 priority after
switching to runlevel 3. Also it can benamed like `/etc/rc3.d/k21logd` which
measn stopping `logd` service after runlevel 3.

These steps is hard to manage. So we used `chkconfig` on RHEL or `update-rc.d` 
on DEB family to view services status on each runlevel. 
``` bash
chkconfig
# Check if the program is set to start at the current runlevel.
chkconfig program
# Start/doesn't start the program at the default runlevel.
chkconfig program [on|off]
# Add/remove the program to start at boot.
chkconfig -add program | chkconfig --del program
chkconfig --list
# Display the current runlevel settings for the program.
chkconfig --list program
# turn on network on 1,2,3 runlevels
chconfig --levels 123 network on
# remove network from default runlevel
update-rc.d network remove
# star network on runlevels 2,3,4 with 40 priority 40
update-rc.d -f network start 40 2 3 4
# like above and also stop on 0,5,6
update-rc.d -f network start 40 2 3 4 . stop 80 0 5 6
```

### systemd

It's very controvertial, which steps away from unix baics. Any program should
don a special simple task, not multi task.But `systemd` is monolitic. Its log 
is not in text format, commands output shows like `less` and colored by 
default, and etc.  
But it's a good choice and many distributions use this.  
`Systemd` contains:  
units: services or actions (name + type + config)
targets: 

``` bash
systemctl
systemctl command nginx
# commands: status, start, stop, restart, reload, enable, disable, is-enabled
systemctl list-units
systemctl default              # jump to default mode
systemctl isolate TARGET       # isolate to special target
jjournalctl                    # view systemctl logs
```

All units stored at `/lib/systemd/system/` and also `/etc/systemd/system`
contains more configuration for `wants` and `target`.  
For example, `/lib/systemd/system/ssh.service` is:
```
[Unit]
Description=OpenBSD Secure Shell server
After=network.target auditd.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
EnvironmentFile=-/etc/default/ssh
ExecStartPre=/usr/sbin/sshd -t
ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
ExecReload=/usr/sbin/sshd -t
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartPreventExitStatus=255
Type=notify
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
Alias=sshd.service
```

### upstart

`upstart` introduced on 2006 by Ubuntu and put away on 2015. Its config files
stored at `/etc/init/name.conff`. It was not depended to runlevels, and had an
interesting feature which allows service control when devices connected or
dicconeccted. 

```bash
start bluetooth
stop cups
```

## System recovery

Two main type of failures:  
Kernel failures  
Drive failures  

The GRUB menu allows you to start the system in single-user mode by adding the
`single` or `1` parameter to the `linux` line in the boot menu commands. To get 
there, press the `E` key on the boot option in the GRUB boot menu (press and
hold `Shift` key, if grub menu is hidden).  
Also you can use rescue disk, like CD, DVD, or USB and run live linux and make
prepare changes.  
Also you can use `fsck` command.

## System maintain

### Informing users

Main tools are:  
■  /etc/issue  
■  /etc/issue.net  
■  /etc/motd  
■  /sbin/shutdown  
■  /bin/usr/notify-send (/usr/bin/notify-send)  
■  /bin/wall (/usr/bin/wall)  

#### fluid messaging

At first we can find out a user can recieve messages by:
```
/bin/mesg
# output:
# is y
# Also with who comand, the + sign means user mesg is yes
who -T
```
and disable/enable getting messages:
```
mesg n
mesg y
```
Some messaging commands: 

``` bash
# To send a message to a user on special session: 
write mrht74 pts/4
salam
# To broadcast a message to anyone:
wall salammmmm
# To send graphical notification:
notify-send TITLE MESSAGE
# Issuing the notify-send command to another user
DISPLAY=:0 sudo su -c " notify-send \"TITLE\" \"BODY\" " user2
shutdown -h +5 "please leave in 5 minutes"
shutdown -h 22:00 "please leave at 22:00"
# -H: halt, -h: halt and poweroff, -r: reboot, -P: poweroff, -c: cancel shutdown
# -k: Do not halt, power-off, reboot, disables logins and just write wall message
# --no-wall: Do not send wall message before halt, power-off, reboot.
```

#### Static messaging

To pin a static message we can edit:  
`/etc/issue.net` for incoming connections from far away  
`/etc/issue` for a real local console
`/etc/motd`: Message Of The Day which appears after issue

_**Note:**_ The `motd` message displayed after login, but `issue.net` mesage
displayed before login.

### Backing the system up

Key objectives on bakup:
1. Categorying the data  
2. RTO: Recovery Time Objective  
3. Media: 
    - CD
    - HDD
    - NAS
    - Cloud
    - Tape
    - ...
4. Safety: 
    - Put backups far away of server
    - Encryption
    - ...
5. Type: 
    - Full backup
    - Incrimental
    - Differential
    - Snapshot
    - ...
6. Recovery:
    - File
    - Partition
    - System
    - ...

Suggest directorys to backup:  
/home  
/opt  
root  
/usr  
/var  
/etc  

Some backup tools:
`tar`: learned on lpic1  
`mt`: work with tape  
`rsync`: very useful  
`dd`  
`cpiio`  

Some commands

``` bash
# mt  /f /dev/st0 OPERATION [count] [arg]
# OPERATIONS: status, load, tell (says current place), eod (end of current data),
# OPERATIONS: erase (erases whole tape), fsf4 (skip 4 files forward), bsf4 (skips 4 files backward)
# OPERATIONS: rewind (jump to startpoint of tape), eject, offline

mt -f /dev/st0 load
mt -f /dev/st0 erase
mt -f /dev/st0 rewind 
tar -cf /dev/st0 /home
mt -f /dev/st0 eject
# some days latter
mt -f /dev/st0 rwwind
mt -f /dev/st0 fsf1
tar -cf /dev/mt0 /home
# some days later to restore first backup
mt -f /dev/st0 load
mt -f /dev/st0 rewind 
mt -f /dev/st0 fsf1
tar -xf /dev/st0 /home
###############################
# rsync: like cp, -a: archive (not copy existing files), -v: verbose, -h: human readable
rsync -avh /home/mrht74/Documents /tmp/docs
rsync -avh /home/mrht74/Documents  user@host:/var/backups
###############################
# dd gets input and output and writes input to output, bs: block size, count count of action
dd if=/dev/sda of=/dev/sdb
dd if=/home/debman/iso/ubuntu.iso of=/dev/sdb bs=4M count=10
dd if=/dev/zero of=/dev/sdb   # to wipe your hard disk
```

### Compile from source

At first, read README, TODO, and etc. Usually, we use three commands to make 
compile from source:

``` bash
./configure                    # check prerequisits
make                           # compile
make install                   # install this
```

### Monitoring resources

> **You can not manage something which you can not monitor**  

We should monitor: CPU, memory, IO, network

``` bash
sar                            # very complete tool
sar 10 5                       # print results each 10 seconds for 5 times
# we can use sar, should be enabled at /etc/default/sysstat and make 
# ENABLED="true", its service named `sysstat`
###############
ps -ef | grep SOMETHING
pstree
pmap
free -h  
top
htop
mpstat
###############
vmstat                         # shows vrtual buffers, virtual memories
iostat
iotop
lsof
################
w
who
################
ntop
ip
ifconfig
iftop
iptraf-ng  # or iptraf
netstat
netstat -nr    # show routes
netstat -na    # show listening and nnonlistening
netstat -lntp  # show listening ports
ss             # stablished sockets
tcpdump
```

Also, some third-party applications could help us monitoring system:
* collectd
* cacti
* MRTG
* Nagios
* munin
* RRDTool

## Kernel

Main purpose of kernel is connectioon to the hardware and understand high level

> Applications  
GNU | GUI  
kernel  
Hardware  

