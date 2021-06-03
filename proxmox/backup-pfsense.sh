#!/bin/bash
# Made to backup pfSense from Proxmox to a TrueNAS Cifs Share

qmid=999
date=$(date +%Y_%m_%d)
bntruenas=/mnt/pve/S2S-Backups
backupfolder=/var/lib/vz/dump
backupmode=snapshot
backupcompression=zstd
keepbackups=1
tmpfile=/tmp/backup.log

# Start Backup
/usr/bin/vzdump ${qmid} --dumpdir ${backupfolder} --mode ${backupmode} --prune-backups keep-last=${keepbackups}  --compress ${backupcompression} >${tmpfile}

# Get File Backup to Variable
backupped=$( cat ${tmpfile} | grep "creating vzdump archive" | awk '{print $5}' | sed "s/'//g")
if [ ! -z ${backupped+x} ]; then rm -rf ${tmpfile}; fi

# Copy Backup Files to SMB Share
if [ -f ${backupfolder}/${backupped##*/} ]; then
        cp ${backupfolder}/${backupped##*/} ${bntruenas}/site2site/
fi

# Check if file is the same size
if [[ $(stat -c%s ${backupfolder}/${backupped##*/}) -eq $(stat -c%s $bntruenas/site2site/${backupped##*/}) ]]; then
        rm -rf ${backupfolder}/${backupped##*/}
fi
