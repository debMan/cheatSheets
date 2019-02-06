#!/bin/bash

NAME=$1
OS=$2
CPUS=$3
MEMORY=$4
VRDE_PORT=$5
NETWORK_INTERFACE=$6
DISK_PATH=$7
DISK_SIZE=$8
DVD_ISO_PATH=$9

vboxmanage createvm --name "$NAME" --register --ostype "$OS"
vboxmanage modifyvm "$NAME" --cpus $CPUS --memory $MEMORY --vram 16 --vrde on --vrdeport $VRDE_PORT
vboxmanage modifyvm "$NAME" --nic1 bridged --bridgeadapter1 $NETWORK_INTERFACE
vboxmanage createhd disk --filename "$DISK_PATH" --size $DISK_SIZE
vboxmanage storagectl "$NAME" --name SATA --add sata
vboxmanage storagectl "$NAME" --name IDE --add ide
vboxmanage storageattach "$NAME" --storagectl SATA  --port 0 --type hdd --medium \
"$DISK_PATH" --device 0
vboxmanage storageattach "$NAME" --storagectl IDE --port 0 --type dvddrive --medium \
"$DVD_ISO_PATH" --device 0
if [[ $? -eq 0 ]] ; then
  logger "virtual machine "$NAME" created successfuly"
  vboxmanage startvm "$NAME" --type headless
  logger "virtual machine "$NAME" started headless"
  echo "
  --- Done. virtual machine "$NAME" is started on VRDE port $VRDE_PORT ---
  "
fi

