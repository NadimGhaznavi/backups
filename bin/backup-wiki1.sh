#!/bin/bash

BACKUPFILE=/tmp/$(date +%Y%m%d-$(hostname)-var_www_html.tgz)
SRCDIR=/var/www/html
tar czf $BACKUPFILE $SRCDIR > /dev/null 2>&1
scp $BACKUPFILE nadim@bolt:/export/disk1/backups/wiki1 > /dev/null 2>&1
rm $BACKUPFILE

BACKUPFILE=/tmp/$(date +%Y%m%d-$(hostname)-etc.tgz)
SRCDIR=/etc
tar czf $BACKUPFILE $SRCDIR > /dev/null 2>&1
scp $BACKUPFILE nadim@bolt:/export/disk1/backups/wiki1 > /dev/null 2>&1
rm $BACKUPFILE

