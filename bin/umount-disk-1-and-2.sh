#!/bin/bash 

# Unmount Disk 1 & 2

# Disk UUIDs
DISK1UUID="52300fb4-f9a3-4ca9-938e-704de71d62ba"
DISK2UUID="fcdeb5ae-fa98-45ae-a784-059ecc8d9a48"
# Disk mount points
DISK1MNT="/export/disk1"
DISK2MNT="/export/disk2"

# This laptop's root (/) filesystem
ROOTFS="/dev/mapper/centos-root"

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

# Unmount Disk 2
echo "Unmounting Disk 2 from ($DISK2MNT)"
umount $DISK2MNT
# The OS also automounts the drive when it's plugged in: Unmount it.
umount $DISK2DEV > /dev/null 2>&1

# Unmount Disk 1 
echo "Unmounting Disk 1 from ($DISK1MNT)"
umount $DISK1MNT
# The OS also automounts the drive when it's plugged in: Unmount it.
umount $DISK1DEV > /dev/null 2>&1

exit 0 


