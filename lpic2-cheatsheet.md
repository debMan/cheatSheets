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

Signed bootloaders are:  
**preloader** from Linux Fundation.  
**shim** from fedore. This bootloaders can load grub after start.  

### Process initialization

After loading kernel, `init` proccess starts. Kernel searchs for `init` first
at `/sbin/init` or `/etc/init` on failure, and `/bin/sh` as last option.  
`init` should load further proccesses one by one or some at once, 

Main initiation programms are:  
sysV  
systemd  
upstart  

#### sysV

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
`boot`: start at boot  
`bootwait`: start and wait till finished  
`initdefault`: enter this runlevel by default after boot up  
`once`: run when the runlevel is entered  
`powerfail`: start when powered down  
`powerwait`: start when powered down and wait for it  
`respawn`: start if terminated  
`sysinit`: start before any other at boot  
`wait`: start and wait for finish  

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

#### systemd

It's very controvertial, which steps away from unix baics. Any program should
don a special simple task, not multi task.But `systemd` is monolitic. Its log 
is not in text format, commands output shows like `less` and colored by 
default, and etc. But it's a good choice and many distributions use this.

`Systemd` contains:  
- units: services or actions (name + type + config)  
- targets

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
contains more configuration for `wants` and `target`. For example, 
`/lib/systemd/system/ssh.service` is:
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

#### upstart

`upstart` introduced on 2006 by Ubuntu and put away on 2015. Its config files
stored at `/etc/init/name.conff`. It was not depended to runlevels, and had an
interesting feature which allows service control when devices connected or
dicconeccted. 

```bash
start bluetooth
stop cups
```

### System recovery

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
/etc: System configuration files.  
/home: Typically, the user’s home directory.  
/opt: Third-party application software.  
/root: The root user’s home directory.  
/srv: System-specific files for various services.  
/usr: Stores binaries, documentation, source code, libraries, and so on.  
/var: Contains log, lock, spool, mail, and temp files.  

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
# OPERATIONS: rewind (jump to startpoint of tape), eject, offline, end (end of current file)

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

At first, read README, TODO, INSTALL, and etc. Usually, we use three commands 
to make compile from source:

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
otop
iostat
iotop
lsof                            # can get a directory path as argument
fuser
# fuser Show which processes use the named files, sockets, 
# or filesystems which gets as argument
udisksctl monitor               # monitor block devices
################
w
who
################
ntop
mtr
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
#################
# man -k monitor
# man -k performance
```

Also, some third-party applications could help us monitoring system:
* collectd
* cacti
* MRTG
* Nagios
* Icinga
* munin
* RRDTool

## Mastering the kernel

Main purpose of kernel is connectioon to the hardware and understand high level
tools. **Drivers** are relation between hardware and kernel.  
The kernel handles:  
memory  
file-ssytem  
hardware  
application management  

``` bash
cat /proc/meminfo | less
ipcs | less                     # show information on IPC facilities
```

The Linux system identifies hardware devices as special files, called device 
files. There are three classifications of device files:
* Character
* Block
* Network

kernel binary filenames:  
vmlinuz: A generic compressed kernel binary filename  
vmlinux: An uncompressed kernel binary file, not usually used as the final boot 
version  
bzImage: A larger kernel binary file compressed using the GNU zip utility  
kernel: A generic name for an uncompressed kernel binary file  
zImage: A small kernel binary file compressed using the GNU zip utility  

``` bash
ls -lh /lib/modules      # list of kernel modules
insmod                   # Simple program to insert a module into the Kernel
cd /usr/src/kernels      # source of kernel headers on redhat based 
cd /usr/src/linux*       # source of kernel headers on debian based
```

The kernel versionings:  
0.01 ... 0.95  
1.x.y     even numbers are release prepared. like: 1.2.2, 1.2.4, 1.4.0, ...   
2.x.y ... 2.6.x.y (2003) ...   `-rc` flag means **release candidate**  
3.x.y -rc  
4.x.y -rc (2015)  

### Compile kernel

Go to the [kernel](https://www.kernel.org/) website, download a tarball. Then: 

``` bash
cd \tmp
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.4.tar.xz
tar -xvf linux-5.0.4.tar.xz
mv ./linux-5.0.4 /usr/src/
cd /usr/src
ln -s linux-5.0.4 linux
cd linux
# make config                   # asks several questions
make defconfig                  # makes .config file with default values or:
# make menuconfig
# make xconfig
# make gconfig

# make bzImage                  # or  
# make vmlinuz
make
# Then copy kernel image to /boot, also sugested to copy System.map to /boot
make install                    
# or manualy copy vmlinuz and initrc to /boot and install drivers
##############
make modules                    # manual install modules
make modules_install
# make initial ram disk file on DEB
mkinitramfs -o /boot/initrd.img-5.0.4-generic 5.0.4
mkinitrd  OUTPUT_FILE VERSION             # make initial ram disk file on RHEL

update-grub
```

### Maintain the kernel

Main directories are:  
`/lib/modules/<VERSION>` modules files
`/etc/modules` on DEB family, kernel modules to load at boot time config.  
`/etc/modules-load.d/`on RHEL family, kernel modules to load at boot time
config.  
`/etc/conf.modules` module configurations to customize a kernel module to 
define unique parameters required, 

We use `DKMS` to keeping modules update when new kernel installed.
``` bash
lsmod                           # list of modules
modinfo                         # information about special module
insmod  EXACT-<PATH-TO-MODULE>  # exact module address obtained from modinfo
modprobe -v iwlwifi             # loads module (-v: verbose)
modeprobe -r iwlwifi            # removes module
modeprobe -n iwlwifi            # dry run (just test run, not complete run)
modeprobe -c                    # shows current confi

########

lspci                           # list PCI devices, main swothces: -k,-v,-t
lsusb                           # main switches: -t, -v, -s, -D

# udev rules files stored at /etc/udev/rules.d, /lib/udev/rules.d 
# and config file /etc/udev/udev.conf
udevadm monitor
udisksctl monitor
cat /proc/filesystems
# in /proc: assigned interrupt requests ( /proc/interrupts ), 
# I/O ports (/proc/ioports), direct memory access (DMA) channels (/proc/dma).
# Kernel information ( /proc/sys/kernel )
ls /proc/sys
# sysctl: /etc/sysctl.conf, /etc/sysctl.d/*
sysctl -a
lsdev
uname 
```

## Filesystem

You should know journaling concept, inode concept, and some filesystems:  
btrfs: uses COW and B-tree, has RAID(0,1,10), snapshots, sub-volumes, 
checksums, ... . It is future FS.  
ext2,3,4: 3 and 4 has journaling  
reiserFS  
ntfs: microsoft's fs with journaling  
vfat: microsoft's fs for flash drives  
xfs: has journaling prepared for large files  
zfs: has COW feature developed by Oracle

### Mounting

``` bash
# get informations
mount                   # view mounted devices, -l -t
mountpoint /            # check if / is a mountpoint or not. switches: -x, -d
sudo blkid              # show block devices, main switches: -U, -L
sudo blkid /dev/sda1a
lsblk                           # -J -f -a -b -i -z -m -n -p -r -s -S -t
findfs LABEL=Extra              # find a filesystem
findfs UUID="82558d44–16af-4f2c-8670–6f54732bb31b"
findmnt
df

# create
fdisk -l /dev/sdb
fdisk /dev/sdb
# m: help mennu
# p: partition table print
# d: delete partition
# w: write changes to disk
# n: new partition
# use p for primary and eneter default or add some value, use +2G to add 2 GB
# w: write changes
sudo parted -l                  # show partition info
mkfs -t ext4 /dev/sdb1          # or 
mkfs.ext4 /dev/sdb2
mount -t FILESYSTEM-TYPE /dev/sdb1 /mnt
# The lost+found directory is used for recovering files on ext[2-4] filesystems
cat /proc/filesystems           # some supported flesystem types
umount /dev/sdb1 -l             # -l means do it as soon as possible
cat /etc/fstab                  # auto mount on system startup

# /dev/mapper|UUID|label  /mount/point    filesystem    options  dump(backup)  fsck-check (disable:0, /:1, and others:2)
# /dev/sda1                     /               ext4    defaults        0    1
# Label=Temp                    /home/temp      xfs     users, noauto   0    0
# server01:/nfsshare            /tmp/share      nfs     defaults        0    0

# Also other options are: ro, rw, sync, user, users. check, group, owner
# (users option allows any user authorized to use this system, not just those 
# with super user privileges, to mount or unmount this labeled partition.)

mount -a                        # mounts anything on fstab
# Use sync to forces the data commitment process to take place immediately. 
# This allows you to detach removable media safely. Before umount use:
sync -f  # or 
sync --file-system
# Then:
umount /dev/sdc1a

# After all, you can eject
eject /dev/sdc

# Also you can power off devices like this:
udisksctl power-off  --block-device /dev/sdb
# udiskctl is a powerful tool
```

_**Note:**_ `systemd` can handle mounts, currently controls `fstab` and can
have seperate `*.mount` units itself at `/etc/systemd/system/*.mount`. For 
example, the mount point, /home/temp/ , would have a mount unit file named 
`home-temp.mount`.
``` 
$ cat /etc/systemd/system/home-temp.mount

[Unit]
Description=Test Mount Units
[Mount]
What=/dev/sdo1
Where=/home/temp
Type=ext4
Options=defaults
SloppyOptions=on
# ignores any mount options not supported by a particular filesystem type. 
# off by default 

TimeOutSec=4
# returns failed operation after 4 sec if not mounted
[Install]
WantedBy=multi-user.target

$ sudo systemctl daemon-reload
$ sudo systemctl start home-temp.mount
$ sudo systemctl status home-temp.mount
$ sudo systemctl enable home-temp.mount
$ sudo systemctl is-enabled home-temp.mount
enabled
```

### Virtual filesystems

Usually **memory based** filesystems mounted on following list, which are 
**not** stord on hard disk:  
/dev/  
/run/  
/proc/  
/sys/  

A few memory-based filesystem examples are:  
devpts  
proc  
sysfs  
tmpfs  

For example:

``` bash
cat /proc/cpuinfo
```

On new GNU/Linux systems, devices mounted automatically on 
`/run/media/username/<DEVICE-LABEL>`, and on older systems mounted to `/media/`
or `/mnt/.`  

``` bash
sswapon -s              # displays a summery
# also with:
free -h
# you can create a swap partition
mkswap /dev/sdd1
swapon -p 0 /dev/sdd1   # enables swap usage with 0 priority
swapon                  # show info 
# NAME      TYPE       SIZE USED PRIO
# /dev/sda7 partition 1000M   0B   -2
# /dev/sdc3 partition  3.1G   0B    0
swapoff /dev/sdd1
```
You can also create a file using the `dd` command to make it the proper size 
and then turn it into a swap file to be used as swap space.

### BTRFS

To make BTRFS we add two partitions with btrfs:

``` bash
sudo mkfs.btrfs /dev/sdc1 /dev/sdc2 -f
# created RAID 0 for data and RAID 1 for metadata because of two arguments
mount -t btrfs /dev/sdc1 /mnt/cool-disk
cd /mnt/cool-disk
touch test-file 
btrfs filesystem show
# btrfs is a tools with many features

# subvolumes
btrfs subvolume create Mount_Point/Subvolume_Name
sudo btrfs subvolume get-default new_sub/  # or
sudo btrfs subvolume get-default /mnt/cool-disk
# now we can mount subvolume separately
btrfs subvolume list /mnt/cool-disk
btrfs subvolume list -t /mnt/cool-disk 
# -t displays the information in table format
# output: 
# ID 259 gen 17 top level 5 path new_sub
#
# ID	gen	top level	path
# --	---	---------	----
# 259	17	5		new_sub
sudo umount /dev/sdc1 
sudo mount -o subvol=new_sub /dev/sdc1  /tmp/test
# By default all subvolumes mounted automatically with mounting the parent
# Also, subvolumes can be mounted separately
# Too delete a subvolume:
# also to mount a subvolume by default we can change default subvolume id to
# the special subvolume:
btrfs subvolume set-default 259 /mnt/cool-disk
# next time, by mounting /dev/sdc1, the new_sub will be mounted

# to remove the subvolume after it is mounted
btrfs subvolume delete /mnt/cool-disk/new_sub

# snapshots
# change directory to root of BTRFS filesystem
cd /mnt/cool-disk
btrfs subvolume snapshot new_sub new_sub_snapshot
```

To get more information, please read:

``` bash
man btrfs-filesystem
man mkfs.btrfs
```

### Optical filesystems

Main optical filesystems are:  
El Torito: CD Boot  
HFS: for CD on mac, read-only on linux  
HFS+: Advanced HFS  
9660: iso standard for CD/DVD  
Joliet: advanced of 9660 prepared by Microsoft  

On linux systems, usually, we can mount CD/DVD from `/dev/cdrom` to a `/mnt` or
somewhere else. Also, we can mount an `*.iso` file directly to a mount point.

Also, to create ISO file, we can do like this:

``` bash
mkisofs -o my.iso Temp/
genisoimage -o my.iso Temp/

ls
# AUTORUN.INF    initrd.trk      memdisk      syslinux.cfg   
# boot.cat       isolinux.bin    memtest.x86  trinity.ico

# This will create a bootable ISO file called myBoot.iso
mkisofs -b isolinux.bin -c boot.cat -no-emul-boot \
 -boot-load-size 4 -boot-info-table -JR \
 -o ../../myBoot.iso ../Temp

# double-check that the ISO file is bootable
file myBoot.iso
# myBoot.iso: # ISO 9660 CD-ROM filesystem data
# 'CDROM              ' (bootable)

cdrecord -tao speed=0 dev=/dev/cdrom myBoot.iso 
# -tao: Track At Once mode to write, speed=0: lowest speed
# cdrecord is available by CDRTools package.

# finaly
eject cdrom
```

### Network-Based filesystems

- AutoFS:  
  Handles remote filesystems, it be used on `fstab` and its files stored 
  at `/etc/auto.master` which called **Master Map**.
  By adding NFS to `fstab` may face problems. By using AutoFS this problems
  will be solved. For example, NFS filesystems are mounted when they are 
  accessed instead of at system boot time. Its package name is `autofs`.
  Its configurations files stored at `/etc/default/autofs` or
  `/etc/sysconfig/autofs`.
- NFS (Network File System)
- CIFS (Common Internet File System)
- SMB (Samba, windows file sharing on linux)
- NAS (Network Attach Storage)
- SAN (Storage Area Network):  
  Usually working with **ISCSI** protocol.

### Encrypted filesystems

- dm-crypt:  
  Available with `cryptsetup` package. Its a little confusing. The dm-crypt 
  encrypted filesystems use Device Mapper. It is **not** recommended.
- eCryptfs:  
  A newer encrypted filesystem type, eCryptfs, is actually a pseudo-filesystem 
  in that it is layered on top of a current filesystem. Allow picking which 
  cipher algorithm to use, such as AES, Blowfish, des3_ede, and so on. After
  installing `ecryptfs-utils`, you can simply use:
``` bash
# with ecryptfs we can encrypt mounted filesystem again, like:
mount -t ext4 /dev/sda1 /mnt
mount -t ecryptfs  /mnt /mnt
```
  The encrypted files can be copied between various systems, because eCryptfs 
  metadata is stored in each file’s header. It has options like key byte size, 
  cipher choice, file name encryption, ... usable with `-o` on mount. Also it
  can be written in `fstab`. You may not find documentation on your os, please
  see [linux.die.net/man/7/ecryptfs](http://linux.die.net/man/7/ecryptfs).

### Maintaining filesystems

#### Adjusting a filesystem

``` bash
# ext family (ext2, ext3, ext4)
debugfs             # An interactive utility, used to modify metadata
e2label             # Shows and Modifies a filesystem label
resize2fs           # Enlarges or shrinks an unmounted filesystem
tune2fs             # Tunes filesystem attributes, including UUIDs and labels
# very versatile utility.
# changing an unmounted dvice UUID:
uuidgen | clip
sudo tune2fs /dev/sdc1 \ 
 -U b77a195a-e5a8–4810–932e-5d9adb97adc6

# xfs
xfs_admin           # Tunes filesystem attributes, including UUIDs and labels
xfs_fsr             # Improves filesystem file layout
xfs_growfs          # Expands filesystem size

# btrfs
btrfs balance       # Reallocates and balances data across the filesystem. 
                    # (It often has the side benefit of reducing the filesystem 
                    # reserved for metadata.)
btrfs-convert       # Convert an ext family filesystem to btrfs and vice versa.
btrfstune           # Tunes filesystem attributes and enables/disables extended features.
btrfs property set  # Sets various filesystem properties, such as the label.
# also use man -k btrfs to view more tools.
```

#### Checking and repairing a filesystem

``` bash
# ext family (ext2, ext3, ext4)
fsck.*          # Checks and repairs Linux filesystems. Replace the * with
fsck -t ext4    # the filesystem type that you wish to check, like fsck.ext4.
fsck            # NOTE: fsck.xfs and fsck.btrfs utilities do nothing!!
                # dun fsck itself uses fstab last column check numbers

debugfs         # An interactive utility that can be used to extract data 
                # in order to move it to a new location.

dumpe2fs        # Displays filesystem information.
tune2fs -l      # Displays filesystem attributes with the -l option.

# xfs
xfs_check       # Checks filesystem’s consistency but does no repairs. 
                # Considered the “dry run” of an xfs_repair . No longer 
                # included in many current distributions.

xfsdump         # Creates a backup (dump) of the filesystem’s data and its 
                # attributes, which can be directed to either storage media, 
                # a file, or standard output.

xfs_info        # Displays and checks filesystem information. Equivalent to 
                # running xfs_grow -n .

xfs_metadump    # Copies filesystem metadata to a file.
xfs_repair      # Checks filesystem’s consistency and does any needed repairs. 
                # If the xfs_check command is not on your system, use xfs_repair
                # -n to perform a “dry run” instead.

xfsrestore      # Restores filesystem’s data and its attributes from a backup 
                # dump created by the xfsdump utility.

# also use man -k xfs to view more tools.

# btrfs
btrfs check         # Checks and optionally repairs an unmounted filesystem.
btrfs property get  # Gets various filesystem properties, such
btrfs rescue        # Recovers a damaged filesystem.
btrfs restore       # Restores files from a damaged filesystem. This is the
                    # most powerful of the three repair utilities ( check , rescue , and restore ).
btrfs scrub         # Reads all data from disk and checks for consistency.
btrfsck             # older version of  the btrfs check
```

#### Using SMART

The **SMART** stands for Self-Monitoring Analysis and Reporting Technology. 
SMART devices are usually HDD or SSD, but may be SCSI Tapes.  
Packae name: `smartmontools` (may not be installed by default)  
`smartd` daemon: enables monitoring on any attached SMART devices.  
config files: `/etc/smartd.conf` or `/etc/smartmontools/smartd.conf`  
log files: `/var/log/smartd.log` or `/var/log/messages` or `/var/log/syslog`  
`smartctl`: Its comman-line tool

``` bash
sudo smartctl -i /dev/sda1  # view an individual device’s information,
# It may your device have SMART but not be supported by the smartctl command.
# To see what device types are supported,
smartctl -P showall | less 

# The device does not have to be mounted on the system
smartctl -s on /dev/sdb1       # enable SMART feature of device

# conduct a number of tests on your hard drive with -t 
smartctl -t [selftest, short, long] /dev/sdb1
# No output will be shown when the test is complete. You can check this with:
sudo smartctl -a /dev/sda6 | grep -A1 "Self-test execution"
# -a option shows a great deal of information

# drive’s summary health status:
sudo smartctl -H /dev/sda6

# view the device’s error logs
smartctl -l error device
```

Also, you can use `smartd`. You can set up scheduled device tests with the 
`smartd` daemon. Its config available at `/etc/smartd.conf` or 
`/etc/smartmontools/smartd.conf`  
For example by adding following line to `smartd` config:  
Runs a long test on all of your system’s SMART devices on Sundays from 1 a.m. to 2 a.m.  
```
DEVICESCAN -s L/../../7/01
```

You can also visit the website 
[smartmontools.org/wiki/Supported_USB-Devices](https://www.smartmontools.org/wiki/Supported_USB-Devices) 
to see what USB devices are supported by the smartctl command.

## Advanced Storage Devices

> RAID can give us performance and reliability, LVM cause flexibility

### RAID

**RAID** stands for Redundant Array of Independent Disks. Depending on the 
chosen RAID structure, this logical drive can achieve improved access 
performance, increased data protection, and reduced down time. RAID support
added on kernel v2.6 and above.  

RAID levels in brief:
- RAID0: disk striping, speed up reads and writes, no fault tolerance, 2 disks
- RAID1: disk mirroring, backed up data, high cost of disks, 2 disks
- RAID2: a form of RAID0, specialized error checking (depreciated)
- RAID3: a form of RAID0, uses parity disk, no regeneration for parity disk 
    failure, 3 disks (depreciated)
  RAID4: like RAID3, but faster access, because RAID 3 processes bytes of data,
    while RAID 4 processes blocks of data (depreciated)
- RAID5: disk striping with parity, parity data is not written to a single
    disk, 3 disks
- RAID6: disk striping with double parity, like RAID 5, except the same parity 
    data chunk is written two times, each on a different disk, 4 disks
- RAID10: RAID(1+0) Combination of RAID1 (mirroring) and RAID0 (striping), 4
    disks

More details available at 
[borosan online book](https://borosan.gitbooks.io/lpic2-exam-guide/content/2041-configuring-raid.html).

Practice with a single cool disk with multiple partitions:

``` bash
# Please make partitions as Linux RAID format (fd on fdisk and fd00 on gdisk)
cat /proc/mdstata           # provides current system RAID status information.
sudo modprobe raid6         # chek kernel raid module existence

# mdadm tool:
# mdadm [--mode] raid-device [options] component-devices
# modes: 
# -A --assemble: Assemble the components of a previously created array into an active array.
# --auto-detect: it requests the Linux Kernel to activate any auto-detected arrays.
# -B --build: Build  an array that doesn't have per-device metadata (superblocks).
# -C --create: Create a new array with per-device metadata (superblocks).
# -F --follow, --monitor: Monitor one or more md devices and act on any state changes. (not work for RAID0)
# -G --grow: Grow (or shrink) an array, or otherwise reshape it in some way.
# -I --incremental: Incremental assembly mode: Adds a single drive to designated RAID array, similar to assemble mode but for one drive at a time.
# --manage: Manages RAID array members, such as adding a new spare drive to a RAID array.
# --misc: everything else. (can be ignored, no need to write --misc)

mdadm -C /dev/md0 -l 5 -n 3 /dev/sdb1 /dev/sdb2 /dev/sdb3
mkfs.ext4  /dev/md0
mdadm [--misc] -detail /dev/md0  # do not have to include --misc

# to view the config
sudo mdadm -v --detail  --scan /dev/md0
# you can copy its output to the mdadm config file (not required)
# mdadm config files stored at:
# /etc/mdadm/mdadm.conf
# /etc/mdadm/mdadm.conf.d/
# /etc/mdadm.conf
# /etc/mdadm.conf.d/
# run man mdadm.conf to check
sudo mdadm --verbose --detail --scan /dev/md0 >> /etc/mdadm/mdadm.conf
# this is not neccesary

# You can use -- help on each section:
mdadm --monitor --helpa
# mdadm --monitor options devices
# options: 
# --daemonise -f : Fork and continue in child, parent exits
# more with --monitor --helpa
# The mdadm monitor mode events:
# DeviceDisappeared: An entire array that was created or assembled has left  array configuration status.
# RebuildStarted: An array has started to rebuild.
# RebuildNN: An array that is rebuilding is NN % done.
# RebuildFinished: An array that is rebuilding is either completely done or was aborted.
# Fail: An active array member has been designated faulty.
# FailSpare: An array spare drive, which was currently being added into full array membership to replace a failed drive, has been designated faulty.
# SpareActive: An array spare drive, which was currently being added into active array membership to replace a failed drive, has been successfully added as an active array member.
# NewArray: A new array has been added in the /proc/mdstat file.
# DegradedArray: A new array appears to have an array member missing.
# MoveSpare: A spare drive has been moved from one array in the same spare group or domain to another array that needs a spare due to a failed drive.
# SparesMissing: The configuration file indicates that an array should have n spare drives, but it is detected that fewer than n spare drives exist in the array.
# TestMessage: At startup, an array is detected with the --test option used for monitor mode.

# Adding spare disk to RAID array:
# checking a drive for array membership
mdadm --misc --examine /dev/sde1
mdadm --misc --detail /dev/md0 | grep Spare
mdadm --manage --add /dev/md0 /dev/sde1
# don't forget to partition spare disk same as the others

# Removing a RAID array
mdadm --manage --stop /dev/md0
mdadm --zero-superblock /dev/sdb1 /dev/sdb2 /dev/sdb3
```

### LVM

Here we have: Physical Volume (PV), Volume Group (VG), Logical Volume (LV), 
Physical Extent (PE), Logical Extent (LE).  

``` bash
lvm                     # main lvm interactive shell
lvmconfig               
# show and manipulate configuration information  or with following:
lvm dumpconfig --type default

lvm> help

lvmdiskscan
pvcreate /dev/sdb[123]      # create 3 PVs
pvck                    # Check the consistency of physical volume
pvscan                  # shows PVs
pvs                     # shows PVs
# PREVENT allocation on a physical volume
pvchange -x n /dev/sdk1
# disallows the allocation of physical extents on /dev/sdk1.
pvdisplay [/dev/sdb1]   # shows details for all PVs or special PV

vgcreate vg00 /dev/sdb0 /dev/sdb1 /dev/sdb3 
# use -s to specify the extent size
vgscan
vgs
vgdisplay
vgextend vg1 /dev/sdf1
# adds the physical volume /dev/sdf1 to the volume group vg1
vgreduce my_volume_group /dev/hda1
# removes the physical volume /dev/hda1 from the volume group my_volume_group
vgchange -l 128 /dev/vg00
# changes the maximum number of logical volumes of volume group vg00 to 128.
vgchange -a n my_volume_group
# deactivates the volume group my_volume_group.
vgremove some_vg
# To remove a volume group that contains no logical volumes,
vgsplit bigvg smallvg /dev/ram15
# splits off the new volume group smallvg from the original volume group bigvg
vgmerge -v databases my_vg
# merges the inactive volume group my_vg into the active or inactive volume group databases giving verbose
# Either of the following commands renames the existing volume group vg02 to my_volume_group
vgrename /dev/vg02 /dev/my_volume_group
vgrename vg02 my_volume_group

lvscan
lvs
lvdisplay -v --maps /dev/vg00/lvol2
# shows the attributes of lvol2 in vg00 and its snapshots and physical mapped places.
lvcreate -L 10G vg1
# creates a logical volume 10 gigabytes in size in the volume group vg1
lvcreate -L1500 -n testlv testvg
# creates a 1500 MB linear logical volume named testlv in the volume group testvg, creating the block device /dev/testvg/testlv
lvcreate -L 50G -n gfslv vg0
# creates a 50 gigabyte logical volume named gfslv from the free extents in volume group vg0.
lvcreate -l 60%VG -n mylv testvg
# creates a logical volume called mylv that uses 60% of the total space in volume group testvg.
lvcreate -l 100%FREE -n yourlv testvg
# creates a logical volume called yourlv that uses all of the unallocated space in the volume group testvg.
lvcreate -L 1500 -ntestlv testvg /dev/sdg1
# creates a logical volume named testlv in volume group testvg allocated from the physical volume /dev/sdg1
lvcreate -l 100 -n testlv testvg /dev/sda1:0-24 /dev/sdb1:50-124
# creates a linear logical volume out of extents 0 through 24 of physical volume /dev/sda1 and extents 50 through 124 of physical volume /dev/sdb1 in volume group testvg
lvcreate -L 50G -i2 -I64 -n gfslv vg0
# creates a striped logical volume across 2 physical volumes with a stripe of 64kB. The logical volume is 50 gigabytes in size, is named gfslv, and is carved out of volume group vg0
lvcreate -l 100 -i2 -nstripelv testvg /dev/sda1:0-49 /dev/sdb1:50-99
# creates a striped volume 100 extents in size that stripes across two physical volumes, is named stripelv and is in volume group testvg. The stripe will use sectors 0-49 of /dev/sda1 and sectors 50-99 of /dev/sdb1
lvcreate -L 50G -m1 -n mirrorlv vg0
# creates a mirrored logical volume with a single mirror. The volume is 50 gigabytes in size, is named mirrorlv, and is carved out of volume group vg0
lvcreate -v -L100M -s -n backup /dev/vg0/lv0
# create a snapshot named backup on lv0 with 100 MB size, because we need only changes, its snapshot

lvchange -pr vg00/lvol1
# changes the permission on volume lvol1 in volume group vg00 to be read-onlya
# Either of the following commands renames logical volume lvold in volume group vg02 to lvnew
lvrename /dev/vg02/lvold /dev/vg02/lvnew
lvrename vg02 lvold lvnew

lvremove /dev/testvg/testlv
#removes the logical volume /dev/testvg/testlv. from the volume group testvg
lvextend -L12G -v /dev/myvg/homevol
# extends the logical volume /dev/myvg/homevol to 12 gigabytes
lvextend -L+1G /dev/myvg/homevol
# adds another gigabyte to the logical volume /dev/myvg/homevol
lvextend -l +100%FREE /dev/myvg/testlv
# extends the logical volume called testlv to fill all of the unallocated space in the volume group myvg

# NOTE: after extending LV, you should extend filesystem too. 
resize2fs /dev/vg0/lv0
```

Also, the Device mapper is a generic interface to the linux kernel that can be 
used by different storage. We can check it using:

``` bash
dmsetup info
dmsetup info vg0-backup
dmsetup help
```

More info available on [Red Hat Logical Volume Manager Administration Page](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html-single/logical_volume_mamanipulate configuration informationnager_administration/).

### Adjusting storage devices

You should know about:  
- ATA/IDE:  
    Advanced Technology Attachment, Integrated Drive Electronics, 133 MB/s  
- SATA:  
    Serial ATA, allows Plug and Play, 6 GB/s  
- ATAPI:  
    optical media and tape interface protocol, based on ATA  
- SCSI:  
    Small Computer System Interface, 80 MB/s, older than SATA  
- iSCSI:  
    internet SCSI, a SCSI storage server’s disk appears as a locally attached 
    client-side disk  
    Learn more about iSCSI at SYBEX Exam 201 and Exam 202 study guide book
    pages 237-244  
    iSCSI addresses can be:  
  * iQN: iSCSI Qualified Name: iqn.yyyy‐mm.com.xyz.aabbccddeeffgghh:
    iqn.date.domain.device-identifier, Device identifier (can be a WWN, the 
    system name, or any other vendorimplemented standard)
  * EUI: IEEE Naming convention: eui.64‐bit WWN: euiFC-WWN-of-the-host  
- LUN:  
    Logical Unit Number, storage indexing on target (remote) on iSCSI  
- SAS:  
    Serial Attached SCSI, It uses a Synchronous Serial Port (SSP) controller 
    that supports the Serial Peripheral Interface (SPI) protocol.  
- AHCI:  
    Advanced Host Controller Interface, allows software communication with SATA 
    devices. provides features like hot-plugging, TRIM, ... .  
- NVMe:  
    Non-Volatile Memory Express, standard for SSDs attached via the PCI Express 
    bus., up at `/dev/nvme*` like `/dev/nmve0n1p1` which means namespace1 and 
    partition 1, another example: `/dev/nvme1n3p2`  
    Its package name is `nvme-cli` and its comands like: `nvme help`
- FC: Fiber Channel  
- ATAOverEthernet:  
- FiberChannelOverEthernet  
- IP  
- DMA:  
    direct memory access, write dirctly to RAM without CPU mediation  
- WBC: write-back caching,   

``` bash
lshw --class disk           # ciew disk connection types
hdparm /dev/sda
hdparm -I /dev/sda
hdparm -B 125 /dev/sda 
# Set the Advanced Power Management, valus <1-255>. While 1-127 permit spin-down, 
# 128-254 no not allow spin-down and 255 disable feature completly
hdparm -S 240 /dev/sda 
# Set standby time.specifies how long to wait in idle (with no disk activity) 
# before turning off the motor to save power. 0 can disbale feature,the values
# from 1 to 240 specify multiples of 5 seconds and values from 241 to 251 specify multiples of 30 minutes.
hdparm -W /dev/sda  
hdparm -W 1 /dev/device             # turn on
# Get/set the IDE/SATA drive´s write-caching feature.
hdparm -d 1 /dev/sda 
# set DMA (Direct Memory Access)on or off,values 0 or 1
hdparm --security-help
# view the various security options with hdparm
hdparm -tT /dev/sda
# test for both its device and cache reads: when device is inactive

sdparm      
# scsi version of hdparm. sdparm manupulate scsi specific attributes of hard drive.
tune2fs 
sysctl 
# kernel configurations, deals with /proc directory
# its config at /etc/sysctl.conf
sysctl -a                            # shows all
sysctl dev.cdrom.autoeject          # show special part
sysctl -w dev.cdrom.autoeject=1     # set special part
cat /proc/sys/dev/cdrom/autoeject   # shows that part
# or you can set this file value withhout sysctl, manualy
```

## Network

To learn network basics, please read SYBEX Exam 201 and Exam 202 study guide book.

we need to configure five main pieces of information in our Linux system to interact on a network:
- The host address
- The network address
- The default router (sometimes called the gateway)
- The system hostname
- A DNS server address for resolving hostnames

There are three different ways to configure this information in Linux systems:
- editing network configuration files permanently
- Using command-line tools
- using GUI

The network configuration files are:  
`/etc/network/interfaces` DEB family  
`/etc/netplan/*.yaml` Ubuntu 18.04 and upper  
`/etc/sysconfig/network-scripts` RHEL family  
`/etc/sysconfig/network` openSUSE family  

Sample Debian network configuration settings:

```
auto eth0
iface eth0 inet static
address 192.168.1.77
netmask 255.255.255.0
gateway 192.168.1.254
iface eth0 inet6 static
address 2003:aef0::23d1::0a10:00a1
netmask 64
gateway 2003:aef0::23d1::0a10:0001

auto eth1
iface eth1 inet dhcp
iface eth1 inet6 dhcp
# If you just want to assign an IPv6 link local address and not retrieve an 
# IPv6 address from a DHCP server, replace the inet6 line with this:
# iface eth1 inet6 auto
```

Sample CentOS `ifcfg-eth0` file configuration settings:

```
DEVICE="eth0"
NM_CONTROLLED="no"
ONBOOT=yes
TYPE=Ethernet
BOOTPROTO=static
NAME="System eth0"
IPADDR=192.168.1.77
NETMASK=255.255.255.0
IPV6INIT=yes
IPV6ADDR=2003:aef0::23d1::0a10:00a1/64
```

And another file named `network`. Sample CentOS network file configuration:


