#!/system/bin/sh
PARTED="/sbin/parted_static"
MBF="/sdcard/cosmo-customos-installer"
LS="/system/bin/ls"
OUTPUT="/tmp/output.txt"
PARTITION_FILE="/tmp/part_name.txt"
INSTALLER_FILE="/tmp/installers.txt"
ERROR="/tmp/error.txt"

echo "Detect Installers..." > $OUTPUT

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

part_name() {
PART=`$PARTED /dev/block/mmcblk0 p | grep "$1   " | awk '{ print $5 }'`
if [ $PART = "ext2" ] || [ $PART = "ext4" ]
then
	$PARTED /dev/block/mmcblk0 p | grep "$1   " | awk '{ print $6 }' >> $PARTITION_FILE
else
	echo $PART >> $PARTITION_FILE
fi
}

# Write installer list in $INSTALLER_FILE
# Format: Name,Installer file
echo "Rooted Android,$MBF/Cosmo_Installer_Rooted_Android.sh" >> $INSTALLER_FILE

# Write partition list in $PARTITION_FILE
# Format: partition_name
#				  partition_number  (partition name followed by \n followed by partition_name)
rm -f $PARTITION_FILE
part_name 38
part_name 41
part_name 42
