#!/bin/bash
#

### Global Vars

# DB creds
DBUSER=root
DBPASS=Flip77Zap

### Source backup functions
source $PWD/../lib/lib-backup.sh

### Script starts here
BackupDatabase $DBUSER $DBPASS ecuador
BackupDatabase $DBUSER $DBPASS gccha
BackupDatabase $DBUSER $DBPASS lwiki

BackupDir /opt
BackupDir /home
BackupDir /root
