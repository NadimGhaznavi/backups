#!/bin/bash
#
# Script to ensure that the data is synced between the 4 external
# USB hard drives. Note that USB1 has a smaller capacity and is
# therefore treated differently.
#

### Global variables
# A flag for each USB hard drive, valid values are 'online' or 
# 'offline'. We'll initialize all drives to being offline.
BLUE=offline
HD1=offline
HD2=offline
HD3=offline
SATA1=offline
SATA2=offline

echo "Synchronizing ..."


#####################################################################
#
# Function definitions
#

#--------------------------------------------------------------------
# Figure out which drives are connected to determine what can be
# synchronized
function checkDrives() {
	# The mount points of the 4 drives
	MOUNTPOINTS="blue sata1 sata2 hd1 hd2 hd3"
	for MT in $MOUNTPOINTS; do
		DEVICE=$(df /mnt/$MT | tail -1 | gawk '{ print $1 }')
		if [ "$DEVICE" != "/dev/mapper/centos-root" ]; then
			if [ "$MT" == "blue" ]; then
				BLUE=online
			elif [ "$MT" == "hd1" ]; then
				HD1=online
			elif [ "$MT" == "hd2" ]; then
				HD2=online
			elif [ "$MT" == "hd3" ]; then
				HD3=online
			elif [ "$MT" == "sata1" ]; then
				SATA1=online
			elif [ "$MT" == "sata2" ]; then
				SATA2=online
			fi
		fi
	done
	# Check that the source, BLUE, was found
	if [ "$SATA1" == "offline" -a "$SATA2" == "offline" ]; then
		echo "Unable to synchronize drives, USB SATA drives not found..."
		exit 1
	fi
} #------------------------------------------------------------------


#####################################################################
### Script starts here

# Check which USB drives are connected
checkDrives

# Sync from SATA2 to HD1
if [ "$SATA2" == "online" -a "$HD1" == "online" ]; then
	echo "Synchronizing data between USB BLUE drive and USB HD1"
	rsync -avr --delete --exclude archive/film/* /mnt/sata2/* /mnt/hd1
	echo "Synchronization of USB BLUE to USB HD1 complete"
fi

# Sync from SATA2 to HD2
if [ "$SATA2" == "online" -a "$HD2" == "online" ]; then
	echo "Synchronizing data between USB BLUE drive and USB HD2"
	rsync -avr --exclude archive/film/* /mnt/sata2/* /mnt/hd2
	echo "Synchronization of USB BLUE to USB HD2 complete"
fi

# Sync from SATA2 to HD3
if [ "$SATA2" == "online" -a "$HD3" == "online" ]; then
	echo "Synchronizing data between USB BLUE drive and USB HD3"
	rsync -avr --delete --exclude archive/film/* /mnt/sata2/* /mnt/hd3
	echo "Synchronization of USB BLUE to USB HD3 complete"
fi

# Sync from SATA2 to BLUE
if [ "$SATA2" == "online" -a "$BLUE" == "online" ]; then
	echo "Synchronizing data between USB SATA2 drive and USB BLUE drive"
	rsync -avr --delete --exclude archive/film/* /mnt/sata2/* /mnt/blue
	echo "Synchronization of USB SATA2 to USB BLUE complete"
fi

echo "Synchronization of data between external drives complete"
