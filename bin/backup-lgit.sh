#!/bin/bash

# Script to backup the key data from lgit.ghaznavi.org

DESTDIR=nadim@lightning.ghaznavi.org:/vm-backups/lgit

if [ "$(whoami)" != "root" ]; then
	echo "ERROR: You must be root to run this script, exiting..."
	exit 1
fi

backup_etc(){
	# Backup the /etc directory
	BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-etc.tgz
	echo "Creating a tarball of (/etc)"
	tar czf $BACKUP /etc
	echo "Copying tarball to ($DESTDIR)"
	scp $BACKUP $DESTDIR 
	echo "Deleting local backup ($BACKUP)"
	rm $BACKUP
}

backup_git(){
	# Backup the /git directory
	BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-git.tgz
	echo "Creating a tarball of (/git)"
	tar czf $BACKUP /git 
	echo "Copying tarball to ($DESTDIR)"
	scp $BACKUP $DESTDIR 
	echo "Deleting local backup ($BACKUP)"
	rm $BACKUP
}

#---- Program starts here
for JOB in \
	backup_etc \
	backup_git; do
		echo "===== Starting job ($JOB)..."
		$JOB;
		echo "===== Job ($JOB) done."; echo
done

