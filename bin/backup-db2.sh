#!/bin/bash

# Target server and directory, where backups go
DESTDIR=nadim@bolt:/export/disk1/backups/db2

# Backup the database (blog2), used by the Blog Wiki running on blog2.ghaznavi.org
DUMPFILE=/tmp/$(date +%Y%m%d-$(hostname)-blog2.sql)
mysqldump -u root -p'@tr3d13z' --databases blog2 > $DUMPFILE
gzip $DUMPFILE > /dev/null 2>&1
scp $DUMPFILE.gz $DESTDIR > /dev/null 2>&1
rm $DUMPFILE.gz

# Backup the /etc directory
BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-etc.tgz
tar czf $BACKUP /etc > /dev/null 2>&1
scp $BACKUP $DESTDIR > /dev/null 2>&1
rm $BACKUP
