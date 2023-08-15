#!/system/bin/sh
PARTED="/sbin/parted_static"
DD="/system/bin/dd"
MBF="/sdcard/cosmo-customos-installer"
BOOT_PARTITION="/dev/block/mmcblk0p"
LINUX_ROOTFS="/dev/block/mmcblk0p43"
OUTPUT="/tmp/output.txt"
ERROR="/tmp/error.txt"
INSTALLER_TITLE="Install Rooted Android for Firmware v23"
INSTALLER_ASK_FOR_TARGET_BOOT=1
echo "Installing Rooted Android..." > $OUTPUT

log () {
	echo -n "$1 " >> $OUTPUT
}

execute() {
	log "Running \"$1\""
	R=$($1 2> $ERROR)

	if [ "$?" -eq "0" ]
	then
		log "OK\n"
	else
		log "ERROR: `cat /tmp/error`\n"
	fi
}

# Installing boot image into user-selected boot partition
execute "$DD if=$MBF/root-boot.img of=$BOOT_PARTITION$1 bs=1m"

# Rename partition to specific OS
execute "$PARTED /dev/block/mmcblk0  name $1 ROOTED_ANDROID"
