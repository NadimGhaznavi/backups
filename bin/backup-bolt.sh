#!/bin/bash

# Script to backup the key bits of the bolt.ghaznavi.org desktop/server.

TARGETDIR=/export/disk1/backups/bolt
LOG=/var/log/backup-bolt.log

echo "Starting backup at $(date)" > $LOG 2> /dev/null

SRCDIR=/etc
BACKUP=etc.tgz
tar czvf $TARGETDIR/$BACKUP $SRCDIR >> $LOG 2> /dev/null

SRCDIR=/opt/prod
BACKUP=opt_prod.tgz
tar czvf $TARGETDIR/$BACKUP $SRCDIR >> $LOG 2> /dev/null
