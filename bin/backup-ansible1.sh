#!/bin/bash

BACKUPFILE=/tmp/$(date +%Y%m%d-$(hostname)-ansible.tgz)
TARGET=nadim@bolt:/export/disk1/backups/ansible1

SRCDIR=/ansible
tar czf $BACKUPFILE $SRCDIR > /dev/null 2>&1
scp $BACKUPFILE $TARGET > /dev/null 2>&1
rm $BACKUPFILE

BACKUPFILE=/tmp/$(date +%Y%m%d-$(hostname)-etc.tgz)
SRCDIR=/etc
tar czf $BACKUPFILE $SRCDIR > /dev/null 2>&1
scp $BACKUPFILE $TARGET > /dev/null 2>&1
rm $BACKUPFILE

