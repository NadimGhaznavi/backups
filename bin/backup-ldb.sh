#!/bin/bash

# Script to backup key files from the ldb.ghaznavi.org server

# Target server and directory, where backups go
DESTDIR=nadim@lightning.ghaznavi.org:/vm-backups/ldb

if [ "$(whoami)" != "root" ]; then
	echo "ERROR: You must be root to run this script, exiting..."
	exit 1
fi

# Backup the databases used by lwiki.ghaznavi.org
DUMPFILE=/tmp/$(date +%Y%m%d-$(hostname)-lwiki.sql)
echo "Dumping (lwiki) database"
mysqldump -u root -p'@tr3d13z' --databases lwiki > $DUMPFILE
echo "Compressing (lwiki) database dump file"
gzip $DUMPFILE > /dev/null 2>&1
echo "Transferring compressed database dump file to ($DESTDIR)"
scp $DUMPFILE.gz $DESTDIR > /dev/null 2>&1
echo "Deleting temporary database dump file ($DUMPFILE.gz)"
rm $DUMPFILE.gz
echo

DUMPFILE=/tmp/$(date +%Y%m%d-$(hostname)-gccha.sql)
echo "Dumping (gccha) database"
mysqldump -u root -p'@tr3d13z' --databases gccha > $DUMPFILE
echo "Compressing (gccha) database dump file"
gzip $DUMPFILE > /dev/null 2>&1
echo "Transferring compressed database dump file to ($DESTDIR)"
scp $DUMPFILE.gz $DESTDIR > /dev/null 2>&1
echo "Deleting temporary database dump file ($DUMPFILE.gz)"
rm $DUMPFILE.gz
echo

# Backup the /etc directory
echo "Backing up the /etc directory"
BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-etc.tgz
tar czf $BACKUP /etc > /dev/null 2>&1
scp $BACKUP $DESTDIR > /dev/null 2>&1
rm $BACKUP


