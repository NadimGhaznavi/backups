#!/bin/bash

# Script to backup key files from the db1 server

# Target server and directory, where backups go
DESTDIR=nadim@bolt:/export/disk1/backups/db1

# Backup the database (blog1), used by the Blog Wiki running on blog1.ghaznavi.org
DUMPFILE=/tmp/$(date +%Y%m%d-$(hostname)-blog1.sql)
mysqldump -u root -p'@tr3d13z' --databases blog1 > $DUMPFILE
gzip $DUMPFILE > /dev/null 2>&1
scp $DUMPFILE.gz $DESTDIR > /dev/null 2>&1
rm $DUMPFILE.gz

# Backup the database (wiki), used by the GCC Wiki running on wiki1.ghaznavi.org
DUMPFILE=/tmp/$(date +%Y%m%d-$(hostname)-wiki.sql)
mysqldump -u root -p'@tr3d13z' --databases wiki > $DUMPFILE
gzip $DUMPFILE > /dev/null 2>&1
scp $DUMPFILE.gz $DESTDIR > /dev/null 2>&1
rm $DUMPFILE.gz

# Backup the /etc directory
BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-etc.tgz
tar czf $BACKUP /etc > /dev/null 2>&1
scp $BACKUP $DESTDIR > /dev/null 2>&1
rm $BACKUP


