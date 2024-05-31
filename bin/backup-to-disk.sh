#!/bin/bash 

# Backup all of the data from this laptop, lightening, which should contain backups from the ldb, lwiki and ldb VMs.

# Disk UUIDs
DISK1UUID="52300fb4-f9a3-4ca9-938e-704de71d62ba"
DISK2UUID="fcdeb5ae-fa98-45ae-a784-059ecc8d9a48"
# Disk mount points
DISK1MNT="/export/disk1"
DISK2MNT="/export/disk2"

# This laptop's root (/) filesystem
ROOTFS="/dev/mapper/centos-root"

# Internal flags for this code
DISK1MOUNTED="true"
DISK2MOUNTED="true"

# Confirm that this script is being run as a root
if [ "$(whoami)" != "root" ]; then
	echo "ERROR: You must be root to run this script, exiting..."
	exit 1
fi

# The output from blkid (it's been arbitrarily ID'd as /dev/sdb1. the UUID is unique
# /dev/sdb1: UUID="fcdeb5ae-fa98-45ae-a784-059ecc8d9a48" TYPE="ext4"

# Disk device IDs (can change between reboots):
DISK1DEV=$( blkid | grep $DISK1UUID | gawk '{ print $1 }' )
DISK2DEV=$( blkid | grep $DISK2UUID | gawk '{ print $1 }' )
#Chop off the trailing colon (:)
DISK1DEV="${DISK1DEV::-1}"
DISK2DEV="${DISK2DEV::-1}"

# Handle mounting Disk 1 on /export/disk1
FS=$(df /export/disk1 | tail -1 | gawk '{ print $1 }')
if [ "$FS" == "$ROOTFS" ]; then
	echo "Mounting Disk 1 on $DISK1MNT"
	mount -U $DISK1UUID $DISK1MNT
	DISK1MOUNTED="false"
elif [ "$FS" == "$DISK1DEV" ]; then
	echo "Disk 1 already mounted on /export/disk1, continuing..."
else
	echo "ERROR: Another filesystem is already mounted ($FS), exiting..."
	exit 1
fi

# Sync Disk 1 to Disk 2?
#echo -n "Would you like to sync Disk 1 and Disk 2 (y/n): "
ANSWER="y"
# read ANSWER
if [ "$ANSWER" == "y" -o "$ANSWER" == "Y" ]; then
	# Sync Disk 1 to Disk 2...

	# Handle mounting Disk 2 on /export/disk2
	FS=$(df /export/disk2 | tail -1 | gawk '{ print $1 }')
	if [ "$FS" == "$ROOTFS" ]; then
		echo "Mounting Disk 2 on $DISK2MNT"
		mount -U $DISK2UUID $DISK2MNT
		DISK2MOUNTED="false"
	elif [ "$FS" == "$DISK2DEV" ]; then
		echo "Disk 2 already mounted on /export/disk2, continuing..."
	else
		echo "ERROR: Another filesystem is already mounted ($FS), exiting..."
		exit 1
	fi

	# Actually sync the drives
	echo "Syncing ($DISK1MNT/vm-backups to $DISK2MNT/vm-backups)"
	rsync -avr --delete $DISK1MNT/vm-backups/ $DISK2MNT/vm-backups
	echo "Syncing ($DISK1MNT/archive to $DISK2MNT/archive)"
	rsync -avr --delete $DISK1MNT/archive/ $DISK2MNT/archive

	# Done!
	echo "Done: Disk 1 synced to Disk 2"
fi

# Unmount Disk 2
if [ "$DISK2MOUNTED" == "false" ]; then
	echo "Unmounting Disk 2 from ($DISK2MNT)"
	umount $DISK2MNT
	# The OS also automounts the drive when it's plugged in: Unmount it.
	umount $DISK2DEV > /dev/null 2>&1
fi

# Unmount Disk 1 
if [ "$DISK1MOUNTED" == "false" ]; then
	echo "Unmounting Disk 1 from ($DISK1MNT)"
	umount $DISK1MNT
	# The OS also automounts the drive when it's plugged in: Unmount it.
	umount $DISK1DEV > /dev/null 2>&1
fi

exit 0 


