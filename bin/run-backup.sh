#!/bin/bash 

# Interactive menu driven backup program

### Source the backup library
source /opt/backups/lib/lib-backup.sh

### Functions

function CheckDate(){
	echo "Is this the correct date and time: "
	date
	echo -n "[Y,N]: "
	read ANSWER
	if [ "$ANSWER" == "N" -o "$ANSWER" == "n" ]; then
		echo -n "Please enter the correct date and time in the format (MMDDhhmmCCYY): "
		read ANSWER
		date $ANSWER
		CheckDate
	fi
	
}

function SourcesMenu(){
	clear
	echo
	echo "===== Backup Menu =============="
	echo "Please select sources to backup:"
	echo

	# 1. Lwiki wiki       [ ]
	if [ $LWIKI == false ]; then
		echo "  1 - Lwiki wiki                     [   ]"
	else
		echo "  1 - Lwiki wiki                     [ X ]"
	fi

	# 2. /opt directory   [ ]
	if [ $OPTDIR == false ]; then
		echo "  2 - /opt directory                 [   ]"
	else
		echo "  2 - /opt directory                 [ X ]"
	fi

	# 3. /home directory  [ ]
	if [ $HOMEDIR == false ]; then
		echo "  3 - /home directory                [   ]"
	else
		echo "  3 - /home directory                [ X ]"
	fi

	# 4. /git directory  [ ]
	if [ $GITDIR == false ]; then
		echo "  4 - /git directory                 [   ]"
	else
		echo "  4 - /git directory                 [ X ]"
	fi

	# 5. /opt/lampp/cgi-bin directory  [ ]
	if [ $CGIBINDIR == false ]; then
		echo "  5 - /opt/lampp/cgi-bin directory   [   ]"
	else
		echo "  5 - /opt/lampp/cgi-bin directory   [ X ]"
	fi

	# 6. /opt/backups directory  [ ]
	if [ $BACKUPSDIR == false ]; then
		echo "  6 - /opt/backups directory         [   ]"
	else
		echo "  6 - /opt/backups directory         [ X ]"
	fi

	# 7. /opt/utils directory  [ ]
	if [ $UTILSDIR == false ]; then
		echo "  7 - /opt/utils directory           [   ]"
	else
		echo "  7 - /opt/utils directory           [ X ]"
	fi


	# C. Continue to select select backup target...
	echo
	echo "  C - Continue to select backup target"

	# Q. Quit
	echo "  Q - Quit"
	echo

	# Choice [1-3,C,Q]:
	echo -n "Choice [1-4,C,Q]: "

	read CHOICE
	if [ "$CHOICE" == "1" ]; then
		LWIKI=true
	elif [ "$CHOICE" == "2" ]; then
		OPTDIR=true
	elif [ "$CHOICE" == "3" ]; then
		HOMEDIR=true
	elif [ "$CHOICE" == "4" ]; then
		GITDIR=true
	elif [ "$CHOICE" == "5" ]; then
		CGIBINDIR=true
	elif [ "$CHOICE" == "6" ]; then
		BACKUPSDIR=true
	elif [ "$CHOICE" == "7" ]; then
		UTILSDIR=true
	elif [ "$CHOICE" == "C" -o "$CHOICE" == "c" ]; then
		# Make sure something was selected to backup
		if [ $LWIKI == false -a \
			$OPTDIR == false -a \
			$HOMEDIR == false -a \
			$GITDIR == false -a \
			$CGIBINDIR == false -a \
			$BACKUPSDIR == false -a \
			$UTILSDIR == false ]; then
			echo
			echo "   NO SOURCES SELECTED"
			sleep 2
		else
			STATE="select-targets"
		fi
	elif [ "$CHOICE" == "Q" -o "$CHOICE" == "q" ]; then
		STATE=quit
	else
		echo
		echo "   INALID SELECTION"
		sleep 2
	fi
}

function TargetsMenu(){
	clear
	echo
	echo "===== Backup Menu ============================"
	echo "Please select targets where backups should go:"
	echo

	# 1 - Local (/backups) directory [   ]
	if [ $LOCALDIR == online ]; then
		echo "  1 - Local (/backups) directory [   ]"
	else
		echo "  1 - Local (/backups) directory [ X ]"
	fi

	# 2 - USB BLUE drive             [   ]"
	if [ $BLUE == online ]; then
		echo "  2 - USB BLUE drive             [   ]"
	elif [ $BLUE == offline ]; then
		echo "  2 - USB BLUE drive             [n/a]"
	elif [ $BLUE == selected ]; then
		echo "  2 - USB BLUE drive             [ X ]"
	fi

	# 3 - USB HD1 drive
	if [ $HD1 == online ]; then
		echo "  3 - USB HD1 drive              [   ]"
	elif [ $HD1 == offline ]; then
		echo "  3 - USB HD1 drive              [n/a]"
	elif [ $HD1 == selected ]; then
		echo "  3 - USB HD1 drive              [ X ]"
	fi

	# 4 - USB HD2 drive
	if [ $HD2 == online ]; then
		echo "  4 - USB HD2 drive              [   ]"
	elif [ $HD2 == offline ]; then
		echo "  4 - USB HD2 drive              [n/a]"
	elif [ $HD2 == selected ]; then
		echo "  4 - USB HD2 drive              [ X ]"
	fi

	# 5 - USB HD3 drive
	if [ $HD3 == online ]; then
		echo "  5 - USB HD3 drive              [   ]"
	elif [ $HD3 == offline ]; then
		echo "  5 - USB HD3 drive              [n/a]"
	elif [ $HD3 == selected ]; then
		echo "  5 - USB HD3 drive              [ X ]"
	fi

	# 6 - SATA1 drive
	if [ $SATA1 == online ]; then
		echo "  6 - SATA1 drive                [   ]"
	elif [ $SATA1 == offline ]; then
		echo "  6 - SATA1 drive                [n/a]"
	elif [ $sATA1 == selected ]; then
		echo "  6 - SATA1 drive                [ X ]"
	fi

	# 7 - SATA2 drive
	if [ $SATA2 == online ]; then
		echo "  7 - SATA2 drive                [   ]"
	elif [ $SATA2 == offline ]; then
		echo "  7 - SATA2 drive                [n/a]"
	elif [ $SATA2 == selected ]; then
		echo "  7 - SATA2 drive                [ X ]"
	fi
	echo
	echo "  C - Continue to confirm your selection"
	echo "  Q - Quit"

	echo
	echo -n "Choice [1-7]: "
	read CHOICE

	# Localdir
	if [ "$CHOICE" == "1" ]; then
		LOCALDIR=selected

	# Blue
	elif [ "$CHOICE" == "2" ]; then
		if [ $BLUE == offline ]; then
			echo
			echo "   INVALID SELECTION"
			sleep 2
		else
			BLUE=selected
		fi

	# HD1
	elif [ "$CHOICE" == "3" ]; then
		if [ $HD1 == offline ]; then
			echo
			echo "   INVALID SELECTION"
			sleep 2
		else
			HD1=selected
		fi

	# HD2
	elif [ "$CHOICE" == "4" ]; then
		if [ $HD2 == offline ]; then
			echo
			echo "   INVALID SELECTION"
			sleep 2
		else
			HD2=selected
		fi

	# HD3
	elif [ "$CHOICE" == "5" ]; then
		if [ $HD3 == offline ]; then
			echo
			echo "   INVALID SELECTION"
			sleep 2
		else
			HD3=selected
		fi

	# SATA1
	elif [ "$CHOICE" == "6" ]; then
		if [ $SATA1 == offline ]; then
			echo
			echo "   INVALID SELECTION"
			sleep 2
		else
			SATA1=selected
		fi

	# SATA2
	elif [ "$CHOICE" == "7" ]; then
		if [ $SATA2 == offline ]; then
			echo
			echo "   INVALID SELECTION"
			sleep 2
		else
			SATA2=selected
		fi

	# Run backup
	elif [ "$CHOICE" == "C" -o "$CHOICE" == "c" ]; then
		STATE="confirm"

	# Quit
	elif [ "$CHOICE" == "Q" -o "$CHOICE" == "q" ]; then
		STATE="quit"

	# Invalid choice
	else
		echo
		echo "   INVALID SELECTION"
		sleep 2
	fi
}

function ConfirmMenu(){
	clear
	echo
	echo "===== Backup Menu ==================="
	echo "Please confirm the following choices."
	echo
	echo "Backups being performed"
	echo "-----------------------"
	if [ $LWIKI == true ]; then 
		echo "  * LWiki wiki"
	fi
	if [ $OPTDIR == true ]; then
		echo "  * /opt directory"
	fi
	if [ $HOMEDIR == true ]; then
		echo "  * /home directory"
	fi
	if [ $GITDIR == true ]; then
		echo "  * /git directory"
	fi
	if [ $CGIBINDIR == true ]; then
		echo "  * /opt/lampp/cgi-bin directory"
	fi
	if [ $BACKUPSDIR == true ]; then
		echo "  * /opt/backups directory"
	fi
	if [ $UTILSDIR == true ]; then
		echo "  * /opt/utils directory"
	fi
	echo
	echo "Where backups will go"
	echo "-----------------------"
	if [ $LOCALDIR == selected ]; then
		echo "  * $BACKUPDIR"
	fi
	if [ $BLUE == selected ]; then
		echo "  * /mnt/blue$BACKUPDIR"
	fi
	if [ $HD1 == selected ]; then
		echo "  * /mnt/hd1$BACKUPDIR"
	fi
	if [ $HD2 == selected ]; then
		echo "  * /mnt/hd1$BACKUPDIR"
	fi
	if [ $HD3 == selected ]; then
		echo "  * /mnt/hd1$BACKUPDIR"
	fi
	if [ $SATA1 == selected ]; then
		echo "  * /mnt/sata1$BACKUPDIR"
	fi
	if [ $SATA2 == selected ]; then
		echo "  * /mnt/sata2$BACKUPDIR"
	fi

	echo
	echo "  C - Continue to begin performing backps"
	echo "  Q - Quit"
	echo
	echo -n "  Choice [C/Q]: "
	read CHOICE
	if [ $CHOICE == C -o $CHOICE == c ]; then
		STATE="run-backups"
	elif [ $CHOICE == Q -o $CHOICE == q ]; then
		STATE="quit"
		echo "Aborting backups"
	else
		echo
		echo "   INVALID CHOICE"
		sleep 2
	fi
}

# Perform backups with a specific target directory
function RunBackup(){
	BACKUPDIR=$1
	if [ $LWIKI == true ]; then
		BackupDatabase $DBUSER $DBPASS lwiki $BACKUPDIR
		BackupDir /opt/lampp/htdocs/lwiki $BACKUPDIR
		BackupDir /opt/lampp/htdocs/static $BACKUPDIR
	fi
	if [ $OPTDIR == true ]; then
		BackupDir /opt $BACKUPDIR
	fi
	if [ $HOMEDIR == true ]; then
		BackupDir /home $BACKUPDIR
	fi
	if [ $GITDIR == true ]; then
		BackupDir /git $BACKUPDIR
	fi
	if [ $CGIBINDIR == true ]; then
		BackupDir /opt/lampp/cgi-bin $BACKUPDIR
	fi
	if [ $BACKUPSDIR == true ]; then
		BackupDir /opt/backups $BACKUPDIR
	fi
	if [ $UTILSDIR == true ]; then
		BackupDir /opt/utils $BACKUPDIR
	fi
}

function RunBackups(){
	echo "Running Backups..."
	echo
	if [ $LOCALDIR == selected ]; then
		RunBackup /backups/$HOSTNAME
	fi
	if [ $BLUE == selected ]; then
		RunBackup /mnt/blue/backups/$HOSTNAME
	fi
	if [ $HD1 == selected ]; then
		RunBackup /mnt/hd1/backups/$HOSTNAME
	fi
	if [ $HD2 == selected ]; then
		RunBackup /mnt/hd2/backups/$HOSTNAME
	fi
	if [ $HD3 == selected ]; then
		RunBackup /mnt/hd3/backups/$HOSTNAME
	fi
	if [ $SATA1 == selected ]; then
		RunBackup /mnt/sata1/backups/$HOSTNAME
	fi
	if [ $SATA2 == selected ]; then
		RunBackup /mnt/sata2/backups/$HOSTNAME
	fi
	STATE="quit"
}

### Global variables

## Credentials
DBUSER=root
DBPASS=Flip77Zap

## Sources to be backed up
# /home
HOMEDIR=false
# The LWiki wiki:
# - lwiki database
# - /opt/lampp/htdocs directory
# - /opt/lampp/static directory
LWIKI=false
# /opt
OPTDIR=false
# /git
GITDIR=false
# /opt/lampp/cgi-bin
CGIBINDIR=false
# /opt/backups
BACKUPSDIR=false
# /opt/utils
UTILSDIR=false

## Targets where backups go
LOCALDIR=online
BLUE=offline
HD1=offline
HD2=offline
HD3=offline
SATA1=offline
SATA2=offline

## Short (unqualified) name for the machine where this is running
HOSTNAME=$(hostname -s)

# A useful variable
BACKUPDIR=/backups/$HOSTNAME

# The current state of this script
STATE="select-sources"

### Script starts here

# Make sure the date/time is right (lightning needs a new battery...)
CheckDate

# Figure out which USB and/or SATA drives are connected
checkDrives

while [ "$STATE" != "quit" ]; do 
	if [ "$STATE" == "select-sources" ]; then
		SourcesMenu
	elif [ "$STATE" == "select-targets" ]; then
		TargetsMenu
	elif [ "$STATE" == "confirm" ]; then
		ConfirmMenu
	elif [ "$STATE" == "run-backups" ]; then
		RunBackups
	fi
done
