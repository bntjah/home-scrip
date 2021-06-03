#!/bin/bash
# Made to backup pfSense from Proxmox to a TrueNAS Cifs Share
qmid=999
date=$(date +%Y_%m_%d)
ip=
nasfolder=$(mount | grep ${ip} | awk '{print $3}' )
nasbackupfolder=dump
backupfolder=/var/lib/vz/dump
backupmode=snapshot
backupcompression=zstd
keepbackups=1
tmpfile=/tmp/backup.log

# Start Backup
/usr/bin/vzdump ${qmid} --dumpdir ${backupfolder} --mode ${backupmode} --prune-backups keep-last=${keepbackups}  --compress ${backupcompression} >${tmpfile}

# Check if VPN Site to Site is UP
# Ping the NAS and discard output
ping -c 1 $ip > /dev/null 2> /dev/null

# Check the Exit Code
if [ $? -eq 0 ]; then
        # Check if the folder exists and is mounted
        if [[ -d ${nasfolder}/${nasbackupfolder} ]]; then
                        # Get File Backup to Variable
                        backupped=$( cat ${tmpfile} | grep "creating vzdump archive" | awk '{print $5}' | sed "s/'//g")

                        # Check if Backupped Variable is populated
                        if [ ! -z ${backupped+x} ]; then
                                rm -rf ${tmpfile}
                        fi

                        # Copy Backup Files to SMB Share
                        if [ -f ${backupfolder}/${backupped##*/} ]; then
                                cp ${backupfolder}/${backupped##*/} ${nasfolder}/${nasbackupfolder}/
                                cp ${backupfolder}/${backupped//+(*\/|.*)}.log ${nasfolder}/${nasbackupfolder}/
                        fi

                        # Check if file is the same size
                        if [[ $(stat -c%s ${backupfolder}/${backupped##*/}) -eq $(stat -c%s ${nasfolder}/${nasbackupfolder}/${backupped##*/}) ]]; then
                                rm -rf ${backupfolder}/${backupped//+(*\/|.*)}.*
                        fi
                else
                        echo "There is no cifs share mounted from ${ip}"
                fi
        else
                echo "${ip} is unreachable"
fi
