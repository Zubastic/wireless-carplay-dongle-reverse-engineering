
![Carlinkit V2](https://i.imgur.com/ZL3dq41.png)

## Carlinkit / Carplay2Air Reverse Engineering

## Hardware

| Hardware | Part |
|--|--|
| Flash | Macronix 25L12835F (16MB) |
| SoC | Freescale i.MX6 UltraLite |
| CPU | ARM Cortex-A7 (ARMv7) *- **Fake** ATMEL AT91SAM9260 marking -* |
| RAM | Micron/SK Hynix 1Gb (64x16) |
| Wi-Fi/BT | RTL8822BS or RTL8822CS or RTL8733BS (Realtek) or Fn-Link L287B-SR (Marvell) or LGX4358 (Broadcom) or LGX8354S (Broadcom) |

## Hardware differences

Hardware base remains almost exactly the same since the beginning, only device case / design changed (Thermal pads on V4 / Holes for air flow on V5)

Wifi chip only seems to be changed depending on the stock of the manufacturer. Whatever Wifi chip is being used, is connected over SDIO Protocol (High Speed 4-Bit SD) at 50Mhz, for a maximum speed of 25MB/s (200 Mbps)

Carlinkit created its own segmentation mainly for marketing using different softwares:
- 1.0 / 2.0 / 3.0 = U2W : Only Carplay Wired OEM for Wireless Carplay
- 4.0 = U2AW : Only Carplay Wired OEM for Wireless Carplay + Wireless Android Auto
- 5.0 = U2AC : Carplay Wired OEM or Android Auto Wired OEM for both Wireless Carplay and Wireless Android Auto

![Box Types](https://github.com/ludwig-v/wireless-carplay-dongle-reverse-engineering/blob/master/Pictures/BoxTypes.png?raw=true)

## Software

This repository started when I gained root access by flashing a custom image back in 2020.
Firmware images were just obfuscated tarball archives, building a dictionary was enough to unpack and repack firmware images.

Unfortunately, it didn't last long. Carlinkit has been made aware of this repo, they changed the firmware images packing in firmware 2021.03.06 with a new binary (now pwned in 2025), they also hardened the kernel in next firmwares to block any usage of "strace" to reverse binaries.

### Rooting the device via software

It is possible to gain root access from Carlinkit devices without any hardware method by flashing any Custom Firmware available.

### Switch device firmware via hardware

It is possible to switch from one to another by rewriting the flash chip using a programmer (ASProgrammer, XGEcu devices, Raspberry Pi) 
Tested so far:
 - 1.0 to U2AW ☑️
   - *Up to 2022.07.29.1635 for Realtek RTL8822BS Wifi chip*
 - 2.0 to U2AW ☑️
   - *Up to 2022.07.29.1635 for Realtek RTL8822BS Wifi chip*
   - *Up to 2022.06.17.1439 for Broadcom LGX8354S Wifi chip*
   - *Any firmware for Fn-Link L287B-SR (Marvell) Wifi chip*
 - 3.0 to U2AW ☑️ 
   - *From 2023.10.16.0952 for Realtek RTL8822CS Wifi chip*
   - *Any firmware for Fn-Link L287B-SR (Marvell) Wifi chip*
 - 2.0 to U2AC ❌ *(Not booting)*
 - 3.0 to U2AC ❓ *(Might work with 2023.10.14.1711)*
 - 4.0 to U2W ☑️ 
   - *From 2023.10.31.1425 for Realtek RTL8822CS Wifi chip*
   - *From 2022.07.29.1625 for Broadcom LGX4358 Wifi chip*
   - *Any firmware for Realtek RTL8822BS Wifi chip* *
 - 4.0 to U2AW ❌ *(Not booting)*
 - 5.0 to U2W ☑️ 
   - *From 2023.10.31.1425 for Realtek RTL8822CS Wifi chip*
   - *From 2022.07.29.1625 for Broadcom LGX4358 Wifi chip*
   - *❌ Not possible for Realtek RTL8733BS Wifi chip*
 - 5.0 to U2AW ❌ *(Not booting)*

Please note that **Carlinkit controls devices activation** (via /etc/uuid_sign), your device will work but will be blocked in activation mode, new activations now require a login / password that nobody has, **save your original flash in a safe place** before trying this.

### Rooting the device via hardware

Check https://github.com/ludwig-v/wireless-carplay-dongle-reverse-engineering/tree/master/Flash_Dump to dump the flash using a Raspberry Pi (you can also use any other programmer with a clip)

Check https://github.com/ludwig-v/wireless-carplay-dongle-reverse-engineering/tree/master/Flash_Dump/Tools for rootFS extraction

Once you restored Custom Firmware behavior you can install Dropbear (SSH) and gain root access to Carlinkit device

## Filesystem


```bash
$ cat /proc/cmdline
console=ttyLogFile0 root=/dev/mtdblock2 rootfstype=jffs2 mtdparts=21e0000.qspi:256k(uboot),3328K(kernel),12800K(rootfs) rootwait quiet rw

$ cat /proc/mtd
dev:    size   erasesize  name
mtd0: 00040000 00010000 "uboot"
mtd1: 00340000 00010000 "kernel"
mtd2: 00c80000 00010000 "rootfs"

$ df -T
Filesystem           Type       1K-blocks      Used Available Use% Mounted on
/dev/root            jffs2          12800     10940      1860  85% /
devtmpfs             devtmpfs       61632         0     61632   0% /dev
tmpfs                tmpfs          61732      6324     55408  10% /tmp
/dev/sda1            vfat        62498880     42304  62456576   0% /mnt/UPAN
```

## u-boot compilation

	apt-get install device-tree-compiler gcc-arm-linux-gnueabihf
	export ARCH=arm
	export CROSS_COMPILE=arm-linux-gnueabihf-
	git clone https://github.com/ARM-software/u-boot.git
	make mx6ull_14x14_evk_defconfig
	make all
	
The device can be seen as "SP Blank 6ULL" when powered by USB-OTG but it is not possible to flash a custom u-boot using imx_usb because it is signed

## Links to interesting repos

https://github.com/segfly/carlinkit-modding

https://github.com/Henkru/cplay2air-wifi-passphrase-patch

https://github.com/Quikeramos1/Unbrik-Carlinkit-V3
