VBoxManage: A simple personal guide

_**NOTE: **_ This document is not completed
```
VBoxManage list ostypes  
VBoxManage list vms  
VBoxManage list runningvms  
VBoxManage startvm test
VBoxManage controlvm test poweroff
VBoxManage unregister test --delete
VBoxManage unregister test
VBoxManage modifyvm test --name
VBoxManage modifyvm test --memory 2048 --cpus 2 --vram 64  --vrde on --vrdemulticon on --vrdeport 5555
VBoxManage modifyvm test --nicpromisc1 allow-all
VBoxManage createhd --filename PATH_TO_DISK.vdi --size 4000 
VBoxManage storageattach test --storagectl "SATA Controller" --port 0  --device 0 --type hdd --medium PATH_TO_DISK.vdi
VBoxManage storagectl test --name "IDE Controller" --add ide
VBoxManage storageattach test --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /path/to/windows_server_2008.iso
# after install os :
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0  --device 0 --type dvddrive --medium none

VBoxManage modifyvm  test --nic1 bridged --bridgeadapter1 enp2s0
VBoxManage modifyvm  test --nic2 nat --natpf1 "guestssh,tcp,,2222,,22"
VBoxManage modifyvm  test --natpf1 delete "ssh"
VBoxManage modifyvm  test --boot1 dvd --boot2 disk --boot3 none --boot4 none

# on the fly modify
VBoxManage controlvm test  setlinkstate1 off
VBoxManage controlvm test  setlinkstate1 on 
VBoxManage controlvm test  nicpromisc2 allow-all
VBoxManage controlvm test  nic2 hostonly

# VBoxManage snapshot test take "$SNAPSHOT_NAME" --description "$SNAPSHOT_DESCRIPTION"
# VBoxManage snapshot test  delete ""$SNAPSHOT_NAME""
# VBoxManage snapshot test list
# VBoxManage snapshot test restore <Name of snapshot>

for more detailes [click here](https://www.golinuxhub.com/2017/08/how-to-configure-different-types-of.html)
for more detailes [click here](https://technology.amis.nl/2018/07/27/virtualbox-networking-explained/#prettyPhoto)
```
