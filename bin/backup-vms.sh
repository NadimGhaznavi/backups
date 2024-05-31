#!/bin/bash 

function log(){
	MSG=$1
	NOW=$(date +"%Y/%m/%d %H:%M:%S")
	echo $NOW $MSG >> $LOG
}

function isRunning(){
	# Returns "true" if VM is running.
	# otherwise returns "false".
	checkVM=$1
	for runVM in $(virsh list | gawk '{ print $2}' 2> /dev/null); do
		if [ "$runVM" == "$checkVM" ]; then
			echo true
			return 0
		fi
	done
	echo false
	return 1
}

### Script starts here
LOG=/var/log/backup-vms.log

log "Starting to backup VMs"

for VM in $(ls /vms | gawk -F. '{ print $1 }'); do
	WASRUNNING=false
	RUNNING=$(isRunning $VM)
	if [ "$RUNNING" == "true" ]; then
		WASRUNNING=true	
		log "VM ($VM) is running, shutting it down"
		virsh shutdown $VM > /dev/null 2>&1

		# Give the VM 2 minutes to shutdown
		COUNT=0
		while sleep 5; do
			COUNT=$((COUNT+1))
			RUNNING=$(isRunning $VM)
			if [ "$RUNNING" == "false" -a "$WASRUNNING" == "true" ]; then
				log "VM ($VM) shutdown successfully"
				break
			fi

			if [ $COUNT -eq 24 ]; then
				log "Failed to shutdown VM ($VM)"
				break
			fi
		done
	fi

	log "Starting to backup ($VM.qcows2)"
	rsync /vms/$VM.qcows2 /export/disk1/backups/vms/$VM.qcows2
	log "Finished backing up VM ($VM.qcows2)"
	if [ "$WASRUNNING" == "true" ]; then
		log "Starting VM ($VM) back up"
		virsh start $VM > /dev/null 2>&2
	fi
done

log "Finished backing up VMs"
