########################
# Copyright(c) 2014-2023 DongGuan HeWei Communication Technologies Co. Ltd.
# file    remove_unnecessary_file.sh
# brief   
# author  Shi Kai
# version 1.0.0
# date    14Apr20
########################
#!/bin/bash

remove_old_file() {
	rm -f /usr/lib/libjpeg*
	rm -f /usr/lib/libturbojpeg*
	#rm -rf /etc/assets && ln -s /tmp /etc/assets
	rm -f /usr/lib/libAirPlay*
	#rm -f /usr/lib/libcarlifevehicle.so*
	rm -f /usr/lib/libprotobuf.so*
	rm -f /usr/lib/libScreenStream.so*
	rm -f /usr/lib/libAudioStream.so*
	rm -f /usr/lib/libmydecodejpeg.so*
	rm -f /usr/lib/libAudioStream.so*
	rm -f /usr/lib/libmydecodejpeg.so*
	rm -f /usr/lib/libav*
	rm -f /usr/lib/libsw*

	rm -f /usr/lib/libimobiledevice.so*
	rm -f /usr/lib/libplist*.so*
	rm -f /usr/lib/libtasn1.so*
	rm -f /usr/lib/libusbmuxd.so*

	rm -f /usr/lib/liblzo2.so*
	rm -f /usr/lib/libdmsdpcrypto.so
	rm -f /lib/libasan.so.1.0.0
	rm -f /lib/libubsan.so.0.0.0
	rm -f /etc/box_brand_name
	rm -f /etc/usb_product_id
	#rm -f /usr/sbin/hciattach
	rm -f /usr/sbin/boxImgTools
	cat /etc/box_product_type |grep UC2HCD && rm -rf /etc/car_logo
	if [ -e /usr/sbin/wpa_supplicant.bak ]; then
		riddleBoxCfg -s WiFiP2PMode 0
		mv /usr/sbin/wpa_supplicant.bak /usr/sbin/wpa_supplicant
	fi
}

remove_log_file() {
	rm -f /var/log/*.log
	rm -f /data/update/*
}

remove_module_file() {
	is_unsupport_list=0
	if [ $# -eq 3 ]; then
		is_unsupport_list=$3
	fi
	product_list=$1
	remove_file_list=`echo $2|tr ',' ' '`
	needRemove=0
	if [ $is_unsupport_list -eq 0 ]; then
		echo $product_list |grep ${productType}, || needRemove=1
	else
		echo $product_list |grep ${productType}, && needRemove=1
	fi
	if [ $needRemove -eq 1 ]; then
		for file in $remove_file_list
		do
			echo remove $filepath/$file
			rm -rf $filepath/$file
		done
	fi
}

remove_phonelink_module_file() {
	if [ $# -ge 2 ];then
		file_path=$1
		support_mdlink=$2
	else
		file_path=""
		support_mdlink=$1
	fi
	needP2P = 0
	needHFP = 0

	if ! echo "$support_mdlink" | grep -qw "HiCar"; then
		echo remove HiCar module on $file_path
		rm -f $file_path/usr/sbin/ARMHiCar
		rm -f $file_path/usr/lib/libdmsdp*
		rm -f $file_path/usr/lib/libHisightSink.so
		rm -f $file_path/usr/lib/libHwDeviceAuthSDK.so
		rm -f $file_path/usr/lib/libHwKeystoreSDK.so
		rm -f $file_path/usr/lib/libmanagement.so
		rm -f $file_path/usr/lib/libsecurec.so
		rm -f $file_path/usr/lib/libauthagent.so
		rm -f $file_path/usr/lib/libnearby.so
		rm -f $file_path/usr/lib/libhicar.so
	fi
	if ! echo "$support_mdlink" | grep -qw "CarPlay"; then
		echo remove CarPlay module on $file_path
		rm -f $file_path/usr/sbin/AppleCarPlay
		rm -f $file_path/usr/sbin/ARMiPhoneIAP2
	fi
	if ! echo "$support_mdlink" | grep -qw "AndroidAuto"; then
		echo remove AndroidAuto module on $file_path
		rm -f $file_path/usr/sbin/ARMAndroidAuto
	else
		needHFP = 1
	fi
	if ! echo "$support_mdlink" | grep -qw "ICCOA"; then
		echo remove ICCOA module on $file_path
		rm -f $file_path/usr/sbin/iccoa
		rm -f $file_path/usr/lib/libcarlink.so
	else
		needP2P = 1
	fi
	if ! echo "$support_mdlink" | grep -qw "CarLife"; then
		echo remove CarLife module on $file_path
		rm -f $file_path/usr/sbin/CarLife
	else
		needP2P = 1
		needHFP = 1
	fi
	if ! echo "$support_mdlink" | grep -qw "AndroidMirror"; then
		echo remove AndroidMirror module on $file_path
		rm -f $file_path/usr/sbin/ARMandroid_Mirror
	fi
	if ! echo "$support_mdlink" | grep -qw "iOSMirror"; then
		echo remove iOSMirror module on $file_path
		rm -f $file_path/usr/sbin/usbmuxd
	fi
	if $needP2P -eq 0; then
		echo remove wpa module on $file_path
		rm -f $file_path/usr/sbin/wpa_supplicant
		rm -f $file_path/usr/sbin/wpa_cli
		rm -f $file_path/usr/sbin/iw
	fi
	if $needHFP -eq 0; then
		echo remove hfp module on $file_path
		rm -f $file_path/usr/sbin/hfpd
		rm -f $file_path/etc/hfpd.conf
		rm -f $file_path/etc/dbus-1/system.d/hfpd.conf
	fi
}

if [ $# -ge 2 ];then
	filepath=$1
	productType=$2
	if [ -e "$filepath/etc/mdlink_modules" ]; then
		supportmdlink=`cat $filepath/etc/mdlink_modules`
		# 打包时删除不需要的互联模块
		remove_phonelink_module_file $filepath $supportmdlink
	fi
else
	productType=`cat /etc/box_product_type | sed 's/_.*//'`
	filepath=/tmp/update
	remove_old_file
	remove_log_file
	if [ -e "$filepath/etc/mdlink_modules" ]; then
		supportmdlink=`cat $filepath/etc/mdlink_modules`
		remove_phonelink_module_file $filepath $supportmdlink
		# 删除盒子原有的互联模块
		remove_phonelink_module_file $supportmdlink
	fi
fi
echo $productType


#remove wpa
support_product="U2IW,U2HI,U2WR,UC2D,A15X,U2D,"
file_list="/usr/sbin/wpa_supplicant,/usr/sbin/wpa_cli,/usr/sbin/iw,/etc/wpa_supplicant.conf,/etc/p2p_supplicant.conf"
remove_module_file $support_product $file_list
#remove hfp
support_product="U2AW,A15W,A15X,O2W,UC2AW,U2AC,UC2CA,UC2AWD,UC2CAD,U2OW,A15U,U2D,"
file_list="/usr/sbin/hfpd,/etc/hfpd.conf,/etc/dbus-1/system.d/hfpd.conf"
remove_module_file $support_product $file_list
#remove fakeAA
support_product="O2W,"
file_list="/usr/sbin/fakeAADevice"
remove_module_file $support_product $file_list
#remove mtp/adb
support_product="UC2W,UC2HW,UC2HP,UC2HC,UC2AW,UC2F,UC2D,UC2WD,UC2HWD,UC2HPD,UC2HCD,U2AC,O2W,UC2CA,UC2AWD,UC2CAD,H2W,"
file_list="/usr/sbin/mtp-server,/usr/sbin/adbd,/usr/sbin/am"
remove_module_file $support_product $file_list
#remove echoDelayTest/car_logo
support_product="UC2W,UC2HW,UC2HP,UC2HC,UC2WD,UC2HWD,UC2HPD,UC2CA,UC2CAD,"
file_list="/usr/sbin/echoDelayTest,/etc/DTMF-14809414327.pcm,/etc/car_logo"
remove_module_file $support_product $file_list
#remove hichain
support_product="A15HW,A15W,A15X,A15U,U2HW,U2HP,U2HC,U2HI,UC2HW,UC2HP,UC2HC,UC2HCD,UC2HWD,UC2HPD,H2W,"
file_list="/etc/hichain"
remove_module_file $support_product $file_list
#remove iccoa
support_product="U2IW,U2HI,A15X,"
file_list="/etc/iccoa"
remove_module_file $support_product $file_list
#remove DVR 
support_product="U2WR,"
file_list="/usr/sbin/DVRServer"
remove_module_file $support_product $file_list
#remove boxUIServer
support_product="A15F,A15U,"
file_list="/usr/sbin/boxUIServer"
remove_module_file $support_product $file_list
#remove boxImgTools
unsupport_product="A15HW,A15W,A15X,A15F,A15U,"
file_list="/usr/sbin/boxImgTools.zip"
remove_module_file $unsupport_product $file_list 1
#remove boxHUDServer 
support_product="U2AC,"
file_list="/usr/sbin/boxHUDServer"
remove_module_file $support_product $file_list
#remove BoxHelper.apk
support_product="Auto,A15HW,A15W,"
file_list="/etc/BoxHelper.apk"
remove_module_file $support_product $file_list
