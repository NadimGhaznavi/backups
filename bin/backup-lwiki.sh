#!/bin/bash

# Script to backup the key data from lwiki.ghaznavi.org

DESTDIR=nadim@lightning.ghaznavi.org:/vm-backups/lwiki

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

backup_var_www(){
	# Backup the /var/www directory
	BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-var_www.tgz
	echo "Creating a tarball of (/var/www)"
	tar czf $BACKUP /var/www
	echo "Copying tarball to ($DESTDIR)"
	scp $BACKUP $DESTDIR 
	echo "Deleting local backup ($BACKUP)"
	rm $BACKUP
}

backup_lwiki_DB(){
	# Backup the lwiki MariaDB database
	BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-MariaDb-lwiki
	echo "Dumping the lwiki database to file"
	mysqldump -u root -p'Sun123Shine' --databases lwiki > $BACKUP
	echo "Compressing DB backup file ($BACKUP)"
	gzip $BACKUP
	echo "Copying DB backup to ($DESTDIR)"
	scp $BACKUP.gz $DESTDIR 
	echo "Deleting local backup ($BACKUP.gz)"
	rm $BACKUP.gz
}

backup_gccha_DB(){
	# Backup the gccha MariaDB database
	BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-MariaDb-gccha
	echo "Dumping the lwiki database to file"
	mysqldump -u root -p'Sun123Shine' --databases gccha > $BACKUP
	echo "Compressing DB backup file ($BACKUP)"
	gzip $BACKUP
	echo "Copying DB backup to ($DESTDIR)"
	scp $BACKUP.gz $DESTDIR 
	echo "Deleting local backup ($BACKUP.gz)"
	rm $BACKUP.gz
}

#---- Program starts here
for JOB in \
	backup_etc \
	backup_var_www \
	backup_lwiki_DB \
	backup_gccha_DB; do
		echo "===== Starting job ($JOB)..."
		$JOB;
		echo "===== Job ($JOB) done."; echo
done	
