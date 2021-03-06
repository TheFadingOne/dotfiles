#!/bin/bash

device=`xinput | grep "Synaptics" | sed -e "s/.*id=\([0-9]*\).*/\1/"`
state=`xinput list-props "$device" | grep "Device Enabled" | grep -o "[01]$"`

if [ $state == '1' ];then
  xinput --disable $device
else
  xinput --enable $device
fi
