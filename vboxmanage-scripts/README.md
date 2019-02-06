# vboxmanage personal scipts

Here I made some scipts to make a VM automatically.

To create a VM and run it:

``` bash
./vbox-new-NOCMPNDSI.sh <VM_Name> <OS_Name> <Number_of_CPUs> <RAM_Size_in_MB> \
<VRDE_Port> <Host_Bridge_Network_Interface> <PATH_TO_DISK> <DISK_SIZE> <OS_ISO>
```

And then you should see:

```
Virtual machine '$NAME' is created and registered.
UUID: 3027c4ce-fdd5-481b-97a5-22d96199bac4
Settings file: '/home/USER/VirtualBox VMs/$NAME/$NAME.vbox'
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Medium created. UUID: 816631f8-75e6-4e72-adb0-096c4ca1d7a2
Waiting for VM "$NAME" to power on...
VM "$NAME" has been successfully started.

  --- Done. virtual machine $NAME is started on VRDE port $VRDE_PORT ---
```

And after installation was complete, you can set `ssh` and disable `VRDE` and 
run machine again with:

``` bash
./vbox-done.sh <VM_NAME>
```

And then you should see:

```
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%

  --- Done. virtual machine mymediaserver VRDE port removed ! ---

Waiting for VM "mymediaserver" to power on...
VM "mymediaserver" has been successfully started.

  --- Done. virtual machine mymediaserver started headless ---
```

