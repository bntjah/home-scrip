#!/bin/bash

## Variables
viomi_ip=127.0.0.1
viomi_token=6a576f6449644c526d79365432644b42
viomi_name=GladOS
influxdb_host=127.0.0.1
influxdb_port=8086
influxdb_db=vacuum

## Actual Script
# Get Status to a File
#/usr/local/bin/miiocli viomivacuum --ip ${viomi_ip} --token ${viomi_token} consumable_status >>/tmp/${viomi_name}.consumables

# Factory Info
Viomi_Factory_Main=360
Viomi_Factory_Side=180
Viomi_Factory_Filter=180
Viomi_Factory_Mop=180

#Variables
Viomi_Main=$( cat /tmp/${viomi_name}.consumables | grep "main:" | cut -d: -f2-3 )
Viomi_Side=$( cat /tmp/${viomi_name}.consumables | grep "side:" | cut -d: -f5-6 )
Viomi_Filter=$( cat /tmp/${viomi_name}.consumables | grep "filter:" | cut -d: -f8-9 )
Viomi_Mop=$( cat /tmp/${viomi_name}.consumables | grep "mop:" | cut -d: -f11-12 )

# Convert Days into Hours
Tmp_Viomi_Main_Days=$( echo ${Viomi_Main} | awk {'print $1'} )
Tmp_Viomi_Main_Hours=$( echo ${Viomi_Main} | awk {'print $3'} | cut -d: -f1 )
Tmp_Viomi_Side_Days=$( echo ${Viomi_Side} | awk {'print $1'} )
Tmp_Viomi_Side_Hours=$( echo ${Viomi_Side} | awk {'print $3'} | cut -d: -f1 )
Tmp_Viomi_Filter_Days=$( echo ${Viomi_Filter} | awk {'print $1'} )
Tmp_Viomi_Filter_Hours=$( echo ${Viomi_Filter} | awk {'print $3'} | cut -d: -f1 )
Tmp_Viomi_Mop_Days=$( echo ${Viomi_Mop} | awk {'print $1'} )
Tmp_Viomi_Mop_Hours=$( echo ${Viomi_Mop} | awk {'print $3'} | cut -d: -f1 )

# Calculations for hours in use
Viomi_Total_Main_Hours=$( echo $((${Tmp_Viomi_Main_Days}*24+${Tmp_Viomi_Main_Hours})) )
Viomi_Total_Side_Hours=$( echo $((${Tmp_Viomi_Side_Days}*24+${Tmp_Viomi_Main_Hours})) )
Viomi_Total_Filter_Hours=$( echo $((${Tmp_Viomi_Filter_Days}*24+${Tmp_Viomi_Filter_Hours})) )
Viomi_Total_Mop_Hours=$( echo $((${Tmp_Viomi_Mop_Days}*24+${Tmp_Viomi_Filter_Hours})) )

# Calculations for hours remaining
Viomi_Remaining_Main=$( echo $((${Viomi_Factory_Main}-${Viomi_Total_Main_Hours})) )
Viomi_Remaining_Side=$( echo $((${Viomi_Factory_Side}-${Viomi_Total_Side_Hours})) )
Viomi_Remaining_Filter=$( echo $((${Viomi_Factory_Filter}-${Viomi_Total_Filter_Hours})) )
Viomi_Remaining_Mop=$( echo $((${Viomi_Factory_Mop}-${Viomi_Total_Mop_Hours})) )


echo Remaining Time for Main Brush: ${Viomi_Remaining_Main} Hours
echo Remaining Time for Side Brush: ${Viomi_Remaining_Side} Hours
echo Remaining Time for Filter: ${Viomi_Remaining_Filter} Hours
echo Remaining Time for Mop: ${Viomi_Remaining_Mop} Hours

## Send Data to influxDB
# Write it to a tmp file
echo "consumables name=\"$viomi_name\",mainbrush=\"$Viomi_Remaining_Main\",sidebrush=\"$Viomi_Remaining_Side\",filter=\"$Viomi_Remaining_Filter\",mop=\"$Viomi_Remaining_Mop\" $timestamp">/tmp/curl_consumables_da>

# Send the file contents to to Influxdb
curl -XPOST "http://$influxdb_host:$influxdb_port/api/v2/write?bucket=$influxdb_db" -d "$(cat /tmp/curl_consumables_data.txt)"

# Cleanup
if [ -f "/tmp/curl_consumables_data.txt" ]; then
        rm -f /tmp/curl_data.txt
fi

if [ -f "/tmp/${viomi_consumables_name}.status" ]; then
        rm -f /tmp/${viomi_name}.consumables
fi
