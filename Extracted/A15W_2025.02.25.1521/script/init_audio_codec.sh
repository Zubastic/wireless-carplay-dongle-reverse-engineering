#!/bin/sh

audioCodec=none
i2cdetect -y -a 0 0x1a 0x1a | grep "1a" && audioCodec=wm8960
i2cdetect -y -a 0 0x15 0x15 | grep "15" && audioCodec=ac6966
echo "audio codec: $audioCodec"
if [ $audioCodec == "wm8960" ]; then
	test -e /tmp/snd-soc-wm8960.ko && insmod /tmp/snd-soc-wm8960.ko
	test -e /tmp/snd-soc-imx-wm8960.ko && insmod /tmp/snd-soc-imx-wm8960.ko
	/script/set_wm8960_mix.sh
elif [ $audioCodec == "ac6966" ]; then
	test -e /tmp/snd-soc-bt-sco.ko && insmod /tmp/snd-soc-bt-sco.ko
	test -e /tmp/snd-soc-imx-btsco.ko && insmod /tmp/snd-soc-imx-btsco.ko
	# 1: open record, 0: close record
	i2cset -f -y 0 0x15 0x01 1
else
	echo "Box No Mic!"
fi

