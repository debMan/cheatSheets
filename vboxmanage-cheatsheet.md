# vboxmanage: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **virtualbox command line interface** `vboxmanage`
cheatsheet.

**Tip:** the `VBoxManage` command also works.

## Setup VM:

``` bash
vboxmanage list ostypes  
vboxmanage list vms  
vboxmanage list runningvms  
vboxmanage startvm "$NAME"  --type headless
vboxmanage controlvm "$NAME" poweroff
vboxmanage unregister "$NAME" --delete
vboxmanage unregister "$NAME"
vboxmanage modifyvm "$NAME" --name
vboxmanage modifyvm "$NAME" --memory 2048 --cpus 2 --vram 64  --vrde on \
  --vrdemulticon on --vrdeport 5555
vboxmanage modifyvm "$NAME" --nicpromisc1 allow-all
vboxmanage createhd --filename "$PATH_TO_DISK.vdi" --size 4000 
vboxmanage storagectl "$NAME" --name "IDE" --add ide
vboxmanage storagectl "$NAME" --name "SATA" --add sata
vboxmanage storageattach "$NAME" --storagectl "SATA" --port 0 --type hdd \
 --medium "$PATH_TO_DISK.vdi"
vboxmanage storageattach "$NAME" --storagectl "IDE" --port 0 --device 0 \
 --type dvddrive --medium "$PATH_TO_OS_SETUP_DISK.iso"
vboxmanage modifyvm "$NAME" --nic1 nat --natpf1 "ssh,tcp,,2222,,22"
vboxmanage modifyvm "$NAME" --nic2 bridged --bridgeadapter1 enp2s0
```

## After install os:

``` bash
vboxmanage storageattach "$NAME" --storagectl "IDE" --port 0 --device 0 \
  --type dvddrive --medium none
# vboxmanage modifyvm "$NAME" --natpf1 delete "ssh"
vboxmanage modifyvm "$NAME" --boot1 disk --boot2 dvd --boot3 none --boot4 none
```

## Running VM modifly

``` bash
vboxmanage controlvm "$NAME" setlinkstate1 off
vboxmanage controlvm "$NAME" setlinkstate1 on 
vboxmanage controlvm "$NAME" nicpromisc2 allow-all
vboxmanage controlvm "$NAME" nic2 hostonly
```

## Snapshots

``` bash
vboxmanage snapshot "$NAME" take "$SNAPSHOT_NAME" --description "$DESCRIPTION"
vboxmanage snapshot "$NAME" delete ""$SNAPSHOT_NAME""
vboxmanage snapshot "$NAME" list
vboxmanage snapshot "$NAME" restore "$SNAPSHOT_NAME" 
```

## Backups

``` bash
vboxmanage export "$NAME" --output "$PATH_TO_EXPORT.ova>"
vboxmanage import "$NAME" "$PATH_TO_IMPORT_FILE.ova>"
```

## Scripts:

The scripts are available at [vboxmanage-scripts](vboxmanage-scripts) directory.

## More info:

For more detailes [click here](https://www.golinuxhub.com/2017/08/how-to-configure-different-types-of.html).  
For more detailes [click here](https://technology.amis.nl/2018/07/27/virtualbox-networking-explained/#prettyPhoto).

