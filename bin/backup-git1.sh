#!/bin/bash

# Script to backup the key data from git1.ghaznavi.org

DESTDIR=nadim@bolt.ghaznavi.org:/export/disk1/backups/git1

# Backup the /etc directory
BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-etc.tgz
tar czf $BACKUP /etc > /dev/null 2>&1
scp $BACKUP $DESTDIR > /dev/null 2>&1
rm $BACKUP

# Backup the /git directory
BACKUP=/tmp/$(date +%Y%m%d)-$(hostname)-git.tgz
tar czf $BACKUP /etc > /dev/null 2>&1
scp $BACKUP $DESTDIR > /dev/null 2>&1
rm $BACKUP

