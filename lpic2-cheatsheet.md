# LPIC2: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **lpic2** cheatsheet.

## System startup

Order of tasks which done after startup of machine:  
1. Firmware -> POST -> bootloader (grub)
2. Kernel
3. Other processes which run by kernel

```  bash
dmesg -H -k      # shows boot process info, -H pagination, -k shows kernel log
# It is a bufer in the kernel (kernel ring buffer )which holds messages while 
# boot, which is independent of hard disk
# In RHEL family, it we will have /var/log/boot.log
```

#### Types of boot (based on IBM architecture):

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

#### Bootloaders

1. LILO (Linux Loader):  
   Released at 1990's together with Linux which is
   depreceated now. Lilo doesn't support UEFI. It's configurations available at 
   `/etc/lilo.conf`.  
2. GRUB (Gradn Unified Boot loader):  
   grub has two versions: grub1 (legacy, 1999) and grub2 (2005) which suports
   UEFI.
    * **grub legacy:**  Its configurations at `/boot/menu.lst` which have global
      and per oS configs. Main keywords of global its config is:  
    `color`: foreground and background color  
    `default`: default OS to load  
    `fallback`: second OS if default fails  
    `hiddenmenu`: don’t display the menu selection options  
    `splashimage`: image file to use as the background for the boot menu  
    `timeout`: amount of time to wait for a menu selection before default   

    And for each OS we have:  
    `title`: a simple name for OS  
    `root`: disk and partition where the GRUB `/boot` folder partition is 
    located with syntax like: `(hd0,0)`  
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


