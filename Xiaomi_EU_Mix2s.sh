# RSS Related Variables
PHONE_TO_LOOK_FOR=MiMix2S
RSS_DEV_FEED=https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/MIUI-WEEKLY-RELEASES
RSS_STABLE_FEED=https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/MIUI-STABLE-RELEASES
RSS_TO_CHECK=1
RSS_WorkDir=/srv/Scripts
RSS_TMP_File=/tmp/Xiaomi_Sourceforge.rss
RSS_File2DL=$( /bin/cat ${RSS_TMP_File} )
RSS_FileName=$( /bin/cat ${RSS_TMP_File} | awk -v FS='/' '{print $10}' )
RSS_NAS_Folder=/mnt/nas/Xiaomi.EU
RSS_UPLOAD_DATE=$( /bin/cat ${RSS_TMP_File} | awk -v FS='_' '{print $4}' )

#SeaFile CLI Related Variables
SEAFILE_ENABLED=0
SEAFILE_LIB_ID=
SEAFILE_LIB_Name=
SEAFILE_SYNC_Folder=
SEAFILE_URL=
SEAFILE_USER=
SEAFILE_CUR_AMOUNT=$( ls ${SEAFILE_SYNC_Folder}/${SEAFILE_LIB_Name} | wc -l )

# Gets either the DEV or STABLE RSS
if [ "${RSS_DEV}"=="1" ]; then
                #DEV RSS
                RSS_TO_PARSE=${RSS_DEV_FEED}
                RSS_LOCAL_Folder=${RSS_NAS_Folder}/DEV
        else
                #STABLE RSS
                RSS_TO_PARSE=${RSS_STABLE_FEED}
                RSS_LOCAL_Folder=${RSS_NAS_Folder}/STABLE
fi

#Get the Latest file from RSS in a File For Usage Later on
curl --silent "${RSS_TO_PARSE}" | grep -ie ${PHONE_TO_LOOK_FOR} | grep -o '<link>[^"]*'  | grep -o '[^"]*$' | sed 's#<link>##g' |  sed 's#</link>##g' | head -n 1 >${RSS_TMP_File}

RSS_LOCAL_DATE_FOLDER=${RSS_LOCAL_Folder}/${PHONE_TO_LOOK_FOR}/${RSS_UPLOAD_DATE}
RSS_LOCAL_FILE=${RSS_LOCAL_DATE_FOLDER}/${RSS_FileName}

# The following checks if the folder exists with the date of the release from the rss
if [ ! -d ${RSS_LOCAL_DATE_FOLDER} ]; then
        mkdir -p ${RSS_LOCAL_DATE_FOLDER}/
fi

# The following Checks if the file was already downloaded or not
if [ ! -f ${RSS_LOCAL_FILE} ]; then
        wget --no-proxy ${RSS_File2DL} -O ${RSS_LOCAL_FILE} -q --show-progress
fi

if [ "${SEAFILE_ENABLED}"=="1" ]; then
        # The Following Checks if the total amount of files in the seafile folder is above 3
        # And if necessary deletes the oldest files
        SEAFILE_GT_3=`expr ${SEAFILE_CUR_AMOUNT} - 3`
        if [ "${SEAFILE_GT_3}" -gt "0" ]; then
                ls -tr ${SEAFILE_SYNC_Folder}/${SEAFILE_LIB_Name} | tail -n ${SEAFILE_GT_3} | xargs rm -f
        fi

        # Copy The Latest File to the Sync Folder
        if [ ! -f ${SEAFILE_SYNC_Folder}/${SEAFILE_LIB_NAME}/${RSS_Filename} ]; then
                cp ${RSS_LOCAL_FILE} ${SEAFILE_SYNC_Folder}/${SEAFILE_LIB_NAME}/${RSS_Filename}
        fi

        # Start SEAFile Sync With Server
        /usr/bin/seaf-cli -l "${SEAFILE_LIB_ID}" -s "${SEAFILE_URL}" -d "${SEAFILE_SYNC_Folder}" -u "{$SEAFILE_USER}"
fi
