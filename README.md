# Ubuntu Touch Device Configuration for the Samsung J1 2016 (samsung_j1xlte)
This **should** work on J120F and similar devices. Tested on a J120W8

**Your warranty is now void. I am not responsible for bricked devices, data loss, or any other adverse effects caused by this rom. Install at your own risk.**

**This port is in a very early state!** Many features don't work, and it cannot currently function as a phone. See the [devices.ubuntu-touch.io](https://devices.ubuntu-touch.io/device/j1xlte/) page for more details.

**The EFS partition MUST be backed up, as it might need to be be restored for the modem to boot correctly (see [#13](https://github.com/j1xlte-gtelwifiue/android_device_samsung_j1xlte/issues/13))!**
You should make an image backup of the EFS partition, as TWRP does not backup hidden files in this partition (including the important `.nv_data.bak`). You can do this in TWRP with the command `dd if=/dev/block/bootdevice/by-name/EFS of=/external_sd/efs.img` (or wherever you want the backup).

## Installing
**BACKUP YOUR DATA, ESPECIALLY EFS, BEFORE CONTINUING!**

You will need a MicroSD card to install Ubuntu Touch on this device, as it's system and userdata partitions are too small.

This guide assumes a linux computer. Steps may not be the same on Windows or MacOS.

1. If you haven't already done so, enable OEM Unlock and USB Debugging in Developer Settings in Android. (You may need to enable Developer Mode first)
2. Get the required files. Precompiled files (rootfs.tar.gz, halium-boot.img, and system.img) can be downloaded from the [releases](https://github.com/j1xlte-gtelwifiue/android_device_samsung_j1xlte/releases) page. For building instructions, see [Building](#Building) and [Rootfs](#Rootfs)
3. Install [Heimdall](https://glassechidna.com.au/heimdall/), [ADB](https://developer.android.com/studio/releases/platform-tools), and clone the [halium-install](https://gitlab.com/JBBgameich/halium-install) repository
4. Install TWRP on your phone from [here](https://forum.xda-developers.com/t/recovery-3-3-1-0-unofficial-teamwin-recovery-project-for-samsung-galaxy-j1-2016.3852578/)
5. Put your MicroSD card into the phone while it is powered off (**BACKUP YOUR DATA** - it will be formatted!).
6. Boot into TWRP by holding Power, Home, and Volume Up while turning on your phone.
7. In TWRP, go to Wipe > Advanced Wipe > Select Micro SD Card > Repair or Change File System > Change File System > EXT4, and swipe to confirm. \*\***THIS WILL FORMAT YOUR SD CARD!**\*\*
8. In TWRP, go to Mount > Unselect external_sd and Data
9. From your computer, with your phone plugged in, run the following commands (this tricks halium into thinking the SD card is the userdata partition)
```
adb shell
tune2fs -L userdata /dev/block/mmcblk1p1
mount /dev/block/mmcblk1p1 /data/
exit
```
10. From your computer, with your phone plugged in, run `path/to/halium-install -p ut -s path/to/rootfs.tar.gz path/to/system.img`. This will ask for a password which will be used to unlock your phone.
11. In TWRP, go to Reboot > Download > Do Not Install
12. From your computer, with your phone plugged in, run `heimdall flash --BOOT path/to/halium-boot.img`
13. That's it! Your phone should reboot into Ubuntu Touch.

## Updating
1. Get the updated rootfs, halium-boot.img and system.img
2. Boot into TWRP
3. From your computer, with your phone plugged in, run the following commands (you will need to specify your password again)
```
adb shell mount /dev/block/mmcblk1p1 /data/
path/to/halium-install -p ut -s path/to/rootfs.tar.gz path/to/system.img
```
4. In TWRP, go to Reboot > Download > Do Not Install
5. From your computer, with your phone plugged in, run `heimdall flash --BOOT path/to/halium-boot.img`
6. That's it! Your phone should reboot into newly updated Ubuntu Touch.

## Fixes to known issues
- WiFi will not reconnect by default. To fix this, run `nmtui` on the device, select Edit a connection, select your WiFi connection, empty the Device field, select <OK> and quit.
- On the first boot, the device may get stuck on the loading screen. Simply restart the device (via ssh with `sudo reboot`).

## Building
These instructions are intended for developers, and may not be perfect. Precompiled files can be downloaded from the [releases](https://github.com/j1xlte-gtelwifiue/android_device_samsung_j1xlte/releases) page.
1. Make a build directory (e.g. `~/samsung-j1xlte/halium`). This will be BUILDDIR in the following commands.
2. From the root of your BUILDDIR, run
```
repo init -u https://github.com/j1xlte-gtelwifiue/halium -b halium-10.0 --depth=1
repo sync -c -j 16
./halium/devices/setup j1xlte
```
3. Remove the file `BUILDDIR/hybris-patches/external/v8/0001-blueprints-Allow-building-on-both-Linux-and-macOS.patch` (it is already applied)
4. From the root of your BUILDDIR, run
```
./hybris-patches/apply-patches.sh --mb
./device/samsung/j1xlte/update-initramfs.sh
source build/envsetup.sh
breakfast j1xlte
export LANG=C USE_HOST_LEX=yes TEMPORARY_DISABLE_PATH_RESTRICTIONS=true
mka mkbootimg
mka halium-boot
mka e2fsdroid
mkdir -p out/target/product/j1xlte/recovery/root/system/etc
mka systemimage
```
5. Done! Your files are `BUILDDIR/out/target/product/j1xlte/halium-boot.img and system.img`

## Rootfs
You can download the premade rootfs from the [releases](https://github.com/j1xlte-gtelwifiue/android_device_samsung_j1xlte/releases) page. These instructions assume you know how to add files to an archive and have a basic knowledge of linux commands.
1. Download the default Ubuntu Touch rootfs from [here](https://ci.ubports.com/job/xenial-hybris-android9-rootfs-armhf/)
2. Add a symbolic link from `/efs/` to `/android/efs/` to the rootfs
3. Add an empty file `/etc/gbinder.conf`
4. Done! You can now use this rootfs instead of the downloaded one.

## Contributors
[@j1xlte-gtelwifiue](https://github.com/j1xlte-gtelwifiue)

Thank you to the following contributors who worked on the [unofficial LineageOS version](https://forum.xda-developers.com/t/rom-10-0-0_r41-beta-lineageos-17-1-for-samsung-galaxy-j1-2016-exynos-3475.4307593/) this Ubuntu Touch port is based off of
- [@lzzy12](https://forum.xda-developers.com/m/8152187/)
- [@TBM 13](https://forum.xda-developers.com/m/9120939/)
- [@bengris32](https://forum.xda-developers.com/m/11364767/)
- [@imranpopz](https://forum.xda-developers.com/m/8241792/)
- [@cıyanogen](https://forum.xda-developers.com/m/7799844/)
- [@deadman96385](https://forum.xda-developers.com/m/4222965/)
- [@FieryFlames](https://forum.xda-developers.com/m/11495171/)

Thanks also to everyone who has contributions on Exynos3475 Nougat.

Special thanks to

- [@ananjaser1211](https://forum.xda-developers.com/m/4637718/)
- [@Stricted](https://forum.xda-developers.com/m/8184192/)
- [@danwood76](https://forum.xda-developers.com/m/6707196/)

and all of the 5433/7580 AOSP developers/contributors.

***You must include this contributor list in any projects created from these sources.***
