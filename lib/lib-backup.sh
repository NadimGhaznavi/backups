##### Global Variables

# Short (unqualified) name for the machine where this is running
HOSTNAME=$(hostname -s)

# A host and date specific label for the backups.
STAMP=$HOSTNAME_$(date +%F)

# Where backups go (default location)
BACKUPDIR=/backups/$HOSTNAME

##### Function Defitions

# Backup a database
function BackupDatabase(){
	# Args
	DBUSER=$1
	DBPASS=$2
	DBNAME=$3
	DEST=$4

	echo "==========================================================="
	echo "Backing up the \"$DBNAME\" database..."

	# Set where backups go, if it wasn't passed in
	if [ "null$DEST" == "null" ]; then
		DEST=$BACKUPDIR
	fi

	# Make sure all args were passed in
	 if [ "null$DBNAME" == "null" ]; then
		echo "BackupDatabase(): Missing args, exiting"
		exit 1
	fi

	# The qualified path to the backup file
	BACKUPFILE=$DEST/${STAMP}_${DBNAME}-database.sql

	mysqldump -u $DBUSER -p$DBPASS $DBNAME --single-transaction --quick \
		--lock-tables=true > $BACKUPFILE
	gzip -f $BACKUPFILE
	ls -l $BACKUPFILE.gz
	ls -lh $BACKUPFILE.gz
	echo "Backup of ($DBNAME) database complete ----------"
}

# Function to backup a directory and it's contents
function BackupDir(){

	# Args
	SRCDIR=$1
	DEST=$2

	echo "==========================================================="
	echo "Backing up the ($SRCDIR) directory..."

	# Set DEST to the default if it wasn't passed in
	if [ "null$DEST" == "null" ]; then
		DEST=$BACKUPDIR
	fi

	# Make sure all args were passed in
	 if [ "null$SRCDIR" == "null" ]; then
		echo "BackupDir(): Missing args, exiting"
		exit 1
	fi

	# Generate a filename based on the directory being backed up
	TARBALL=""
	ORIGIFS=$IFS
	IFS=/
	for aDIR in $SRCDIR; do
		if [ "null$aDIR" != "null" ]; then
			TARBALL=${TARBALL}_${aDIR}
		fi
	done
	IFS=$ORIGIFS
	TARBALL="$DEST/${STAMP}${TARBALL}-directory.tgz"

	# Actually backup the directory
	tar czvf $TARBALL $SRCDIR > /dev/null 2>&1
	ls -l $TARBALL
	ls -lh $TARBALL
	echo "Backup of ($SRCDIR) directory complete ----------"
	echo

}

# Function to Upload backups to the Internet
function BackupToGoDaddy(){
	echo "Uploading backups to the Internet (this may take a while)..."
	ftp -n $FTPHOST <<END_SCRIPT
user $FTPUSER $FTPSECRET
binary
prompt
cd backups 
mput "${BACKUPDIR}/${STAMP}*" 
ls "${STAMP}*"
quit
END_SCRIPT
} #------------------------------------------------------------------------

# Function to copy the backups to the BLUE USB drive if it's connected
function BackupToBlue(){
	echo "Copying local backups to USB BLUE drive..."
	DEVICE=$(df /mnt/blue | tail -1 | gawk '{ print $1 }')
	if [ "$DEVICE" != "/dev/mapper/centos-root" ]; then
		# The drive is mounted
		cp $BACKUPDIR/${STAMP}* $BLUEDIR
		echo
		echo "Backup to USB BLUE drive complete:"
		echo "-----------------------------------------"
		ls -lh $BLUEDIR/${STAMP}*
		echo "-----------------------------------------"
		echo
	else
		echo "USB BLUE drive is not connected, skipping."
	fi
} #------------------------------------------------------------------------

# Function to determine which drives are connected to the laptop
function checkDrives() {
	# The mount points of the 4 drives
	MOUNTPOINTS="blue hd1 hd2 hd3 sata1 sata2"
	for MT in $MOUNTPOINTS; do
		DEVICE=$(df /mnt/$MT | tail -1 | gawk '{ print $1 }')
		if [ "$DEVICE" != "/dev/mapper/centos-root" ]; then
			if [ "$MT" == "blue" ]; then
				BLUE=online
			elif [ "$MT" == "hd1" ]; then
				HD1=online
			elif [ "$MT" == "hd2" ]; then
				HD2=online
			elif [ "$MT" == "hd3" ]; then
				HD3=online
			elif [ "$MT" == "sata1" ]; then
				SATA1=online
			elif [ "$MT" == "sata2" ]; then
				SATA2=online
			fi
		fi
	done
}
