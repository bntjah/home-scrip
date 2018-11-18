#!/bin/bash
# Created by Geoffrey "bn_"
# Mainly used to automate downloading
# Of updates that are beeing released
# By Xiaomi.EU through there SourceForge Account
# To my NAS and SeaFile to sync to my phone
# This is just some stuff I wrote to
# facilitate my life and updates on my phone
PHONE_TO_LOOK_FOR=MiMix2S
RSS_DEV_FEED=https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/MIUI-WEEKLY-RELEASES
RSS_STABLE_FEED=https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/MIUI-STABLE-RELEASES
RSS_TO_CHECK=1
RSS_WorkDir=/srv/Scripts
RSS_TMP_File=/tmp/Xiaomi_Sourceforge.rss
RSS_File2DL=$( /bin/cat $RSS_TMP_File )
RSS_FileName=$( /bin/cat $RSS_TMP_File | awk -v FS='/' '{print $10}' )
RSS_NAS_Folder=/mnt/nas/Xiaomi.EU
RSS_UPLOAD_DATE=$( /bin/cat $RSS_TMP_File | awk -v FS='_' '{print $4}' )

# Gets either the DEV or STABLE RSS
if [ $RSS_DEV==1 ]; then
                #DEV RSS
                RSS_TO_PARSE=$RSS_DEV_FEED
                RSS_LOCAL_Folder=$RSS_NAS_Folder/DEV
        else
                #STABLE RSS
                RSS_TO_PARSE=$RSS_STABLE_FEED
                RSS_LOCAL_Folder=$RSS_NAS_Folder/STABLE
fi

#Get the Latest file from RSS in a File For Usage Later on
curl --silent "$RSS_TO_PARSE" | grep -ie $PHONE_TO_LOOK_FOR | grep -o '<link>[^"]*'  | grep -o '[^"]*$' | sed 's#<link>##g' |  sed 's#</link>##g' | head -n 1 >$RSS_TMP_File

RSS_LOCAL_DATE_FOLDER=$RSS_LOCAL_Folder/$PHONE_TO_LOOK_FOR/$RSS_UPLOAD_DATE
RSS_LOCAL_FILE=$RSS_LOCAL_DATE_FOLDER/$RSS_FileName

# The following checks if the folder exists with the date of the release from the rss
if [ ! -d $RSS_LOCAL_DATE_FOLDER ]; then
        mkdir -p $RSS_LOCAL_DATE_FOLDER/
fi

echo "Download"
# The following Checks if the file was already downloaded or not
if [ ! -f $RSS_LOCAL_FILE ]; then
        wget --no-proxy $RSS_File2DL -O $RSS_LOCAL_FILE -q --show-progress
fi
