#!/bin/bash

NAME=$1

vboxmanage controlvm "$NAME" poweroff
vboxmanage modifyvm "$NAME" --vrde off
if [[ $? -eq 0 ]] ; then
  logger "virtual machine "$NAME" VRDE port removed "
  echo "
  --- Done. virtual machine "$NAME" VRDE port removed ! ---
  "
fi

if [[ $? -eq 0 ]] ; then
  vboxmanage startvm "$NAME" --type headless
  logger "virtual machine "$NAME" started headless"
  echo "
  --- Done. virtual machine "$NAME" started headless ---
  "
fi

