#!/bin/bash

# Script to sychronize the /home directory to whatever (if any) USB hard drive
# is connected to the laptop.

##### Function definitions

#--------------------------------------------------------------------
# Figure out which drives are connected to determine what can be
# synchronized
function checkDrives() {
	# The mount points of the 4 drives
	MOUNTPOINTS="blue hd1 hd2 hd3"
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
			fi
		fi
	done
} #------------------------------------------------------------------

function syncToBlue() {
	# Synchronize home to blue
	if [ "$BLUE" == "online" ]; then
		echo "Synchronizing /home to USB BLUE (/mnt/blue/home)..."
		rsync -avr --exclude 'nadim/.cache/*' /home/ /mnt/blue/home
	else
		echo "Unable to synchronize /home to USB BLUE, drive not found."
	fi
}


function syncToHd1() {
	# Synchronize home to hd1
	if [ "$HD1" == "online" ]; then
		echo "Synchronizing /home to USB HD1 (/mnt/hd1/home)..."
		rsync -avr --exclude 'nadim/.cache/*' /home/ /mnt/hd1/home
	else
		echo "Unable to synchronize /home to USB HD1, drive not found."
	fi
}


function syncToHd2() {
	# Synchronize home to hd2
	if [ "$HD2" == "online" ]; then
		echo "Synchronizing /home to USB HD2 (/mnt/hd2/home)..."
		rsync -avr --exclude 'nadim/.cache/*' /home/ /mnt/hd2/home
	else
		echo "Unable to synchronize /home to USB HD2, drive not found."
	fi
}


function syncToHd3() {
	# Synchronize home to hd3
	if [ "$HD1" == "online" ]; then
		echo "Synchronizing /home to USB HD3 (/mnt/hd3/home)..."
		rsync -avr --exclude 'nadim/.cache/*' /home/ /mnt/hd3/home
	else
		echo "Unable to synchronize /home to USB HD3, drive not found."
	fi
}


########### Script starts here

##### Global variables

# A flag for each USB hard drive, valid values are 'online' or 
# 'offline'. We'll initialize all drives to being offline.
BLUE=offline
HD1=offline
HD2=offline
HD3=offline

# The home directory
HOMEDIR=/home

# Figure out which drives are plugged in (sets BLUE and HD1-3 vars if needed)
checkDrives

# Synchronize to USB HD1
syncToBlue
syncToHd1
syncToHd2
syncToHd3


