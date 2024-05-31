#!/bin/sh

HOSTNAME=$(hostname)
ECDBDIR=/opt/lampp/cgi-bin
DBFILE=$ECDBDIR/ecdb/ecdb.db

# Figure out who we are, the target is the other host
if [ "$HOSTNAME" == "lightning.ghaznavi.org" ]; then
	TARGETHOST="pak.ghaznavi.org"
elif [ "$HOSTNAME" == "pak.ghaznavi.org" ]; then 
	TARGETHOST="lightning.ghaznavi.org"
else
	echo "Unsupported host ($HOSTNAME), exiting"
	exit 1
fi

# Check that the TARGETHOST is accessible
ping -c 1 $TARGETHOST > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Target host ($TARGETHOST) not accessible, exiting"
	exit 1
fi

# Copy the DB file to the target host
echo -n "Copying the database file to ($TARGETHOST): "
scp $DBFILE $TARGETHOST:$DBFILE > /dev/null 2>&1
echo "Done"

# Upload any changes to Git
echo -n "Uploading any code changes to Git: "
cd $ECDBDIR
git add ecdb.py ecdb/ecdbdb.py > /dev/null 2>&1
git commit -a -m "sync-ecdb.sh commit" > /dev/null 2>&1
git push > /dev/null 2>&1
echo "Done"

# PUll any Git changes on the target host
echo -n "Pulling Git changes on ($TARGETHOST): "
ssh $TARGETHOST "cd $ECDBDIR; git pull > /dev/null 2>&1"
echo "Done"

# Fix any file permissions on the target host
echo -n "Fixing up file permissions: "
ssh $TARGETHOST chown -R daemon:daemon $ECDBDIR 
echo "Done"

 
