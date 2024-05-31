#!/bin/bash 

# Script to promote the code from /home/nadim/git/backups to /opt/dev/backups and -optionally- to /opt/prod/backups

# Some common variables
SRCDIR=/home/nadim/git/backups
DEVDIR=/opt/dev/backups
PRODDIR=/opt/prod/backups

# Check that we're running as root
if [ $(whoami) != 'root' ]; then
	echo "ERROR: You must be root to run this script."
	exit 1
fi

# Check that /opt/dev exists
if [ ! -d /opt/dev ]; then
	echo "Creating DEV root directory (/opt/dev)"
	mkdir /opt/dev
fi

# Check that /opt/prod exists
if [ ! -d /opt/dev ]; then
	echo "Creating PROD root directory (/opt/prod)"
	mkdir /opt/dev
fi

# Check that the source dir exists
if [ ! -d $SRCDIR ]; then
	echo "ERROR: $SRCDIR doesn't exist"
	exit 1
fi

if [ -d $DEVDIR ]; then
	echo "Deleting DEV directory ($DEVDIR) and it's contents"
	rm -rf $DEVDIR
fi

# Actually promote from source to DEV
echo "Promoting from ($SRCDIR) to ($DEVDIR)"
cp -a $SRCDIR $DEVDIR

# Ask if source to PROD should be done
echo -n "Do you want to promote to PROD ($PRODDIR) (y/n): "
# read ANSWER
read ANSWER
if [ "$ANSWER" == "y" -o "$ANSWER" == "Y" ]; then
	# Actually promote from source to PROD
	if [ -d $PRODDIR ]; then
		echo "Deleting PROD directory ($PRODDIR) and it's contents"
		rm -rf $PRODDIR
	fi
	echo "Promoting from ($SRCDIR) to ($PRODDIR)"
	cp -a $SRCDIR $PRODDIR
	chown -R root:root $PRODDIR
fi


