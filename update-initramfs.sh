#!/bin/bash
#
# This script will update the halium-boot initramfs to the latest version from GitHub.
# This is needed because the automatic download doesn't work in Halium 10.
#

HALIUM_BOOT_DIR=halium/halium-boot/
DEVICE_DIR=device/samsung/j1xlte/
if [ ! -f "$HALIUM_BOOT_DIR/get-initrd.sh" ]; then
	HALIUM_BOOT_DIR=../../../halium/halium-boot/
	DEVICE_DIR=.

	if [ ! -f "$HALIUM_BOOT_DIR/get-initrd.sh" ]; then
		echo "This script must be run from the build root directory or device/samsung/j1xlte!"
		exit 1
	fi
fi

"$HALIUM_BOOT_DIR/get-initrd.sh" arm "$DEVICE_DIR/initramfs.gz"
rm out/target/product/j1xlte/obj/ROOT/halium-boot_intermediates/halium-initramfs.gz &> /dev/null || true

grep "BOARD_USE_LOCAL_INITRD := true" "$DEVICE_DIR/BoardConfig.mk" > /dev/null
if [ ! $? -eq 0 ]; then
	echo >> "$DEVICE_DIR/BoardConfig.mk"
	echo "### Ubuntu Touch ###" >> "$DEVICE_DIR/BoardConfig.mk"
	echo "BOARD_USE_LOCAL_INITRD := true" >> "$DEVICE_DIR/BoardConfig.mk"
	echo "### End Ubuntu Touch ###" >> "$DEVICE_DIR/BoardConfig.mk"
fi
