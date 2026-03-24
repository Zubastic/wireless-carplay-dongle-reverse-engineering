########################
# Copyright(c) 2014-2015 DongGuan HeWei Communication Technologies Co. Ltd.
# file    mount-SK.sh
# brief   
# author  Shi Kai
# version 1.0.0
# date    12Jul15
########################
#!/bin/bash
killall adbd
killall mtp-server 

echo 0 > /sys/class/android_usb_accessory/android0/enable
# HUAWEI ncm feature, some car use it
echo 239 > /sys/class/android_usb_accessory/android0/bDeviceClass
echo 2 > /sys/class/android_usb_accessory/android0/bDeviceSubClass
echo 1 > /sys/class/android_usb_accessory/android0/bDeviceProtocol
echo ncm > /sys/class/android_usb_accessory/android0/functions
echo 1 > /sys/class/android_usb_accessory/android0/enable

# hicar ip should be 192.168.66.x
ifconfig ncm1 192.168.66.2 netmask 255.255.255.0 mtu 1500 up
