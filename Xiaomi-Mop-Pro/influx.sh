#!/bin/bash
## Variables
viomi_ip=127.0.0.1
viomi_token=ffffffffffffffffffffffffffffffff
viomi_name=Vacuum

## Actual Script
# Get Status to a File
/usr/local/bin/miiocli viomivacuum --ip ${viomi_ip} --token ${viomi_token} status >/tmp/${viomi_name}.status

# Read out the File
Viomi_Working_Status=$( cat /tmp/${viomi_name}.status | grep Working: | awk '{print $2}' )
Viomi_State=$( cat /tmp/${viomi_name}.status | grep "State:" | awk '{print $2}' | cut -d "." -f2 )
Viomi_Battery_Status=$( cat /tmp/${viomi_name}.status | grep "Battery status:" | awk '{print $3" "$4}' )
Viomi_Battery=$( cat /tmp/${viomi_name}.status | grep "Battery status:" | awk '{print $3" "$4}' )
Viomi_Charging=$( cat /tmp/${viomi_name}.status | grep "Charging:" | awk '{print $2}' )
Viomi_Box_Type=$( cat /tmp/${viomi_name}.status | grep "Box type:" | awk '{print $3}' | cut -d "." -f2 )
Viomi_Fan_Speed=$( cat /tmp/${viomi_name}.status | grep "Fan speed:" | awk '{print $3}' | cut -d "." -f2 )
Viomi_Water_Grade=$( cat /tmp/${viomi_name}.status | grep "Water grade:" | awk '{print $3}' | cut -d "." -f2 )
Viomi_Mode=$( cat /tmp/${viomi_name}.status | grep "Mop mode:" | awk '{print $3}' | cut -d "." -f2 )
Viomi_Mop_installed=$( cat /tmp/${viomi_name}.status | grep "Mop installed:" | awk '{print $3}' )
Viomi_Vacuum_Edges=$( cat /tmp/${viomi_name}.status | grep "Vacuum along the edges:" | awk '{print $5}' | cut -d "." -f2 )
Viomi_Mop_Y=$( cat /tmp/${viomi_name}.status | grep "Mop route pattern:" | awk '{print $4}' | cut -d "." -f2 )
Viomi_Sec_Cleanup=$( cat /tmp/${viomi_name}.status | grep "Secondary Cleanup:" | awk '{print $3}' )
Viomi_Sound_Vol=$( cat /tmp/${viomi_name}.status | grep "Sound Volume:" | awk '{print $3}' )
Viomi_Clean_Time=$( cat /tmp/${viomi_name}.status | grep "Clean time:" | awk '{print $3}' )
Viomi_Clean_Area=$( cat /tmp/${viomi_name}.status | grep "Clean area:" | awk '{print $3}' )
Viomi_Current_Map=$( cat /tmp/${viomi_name}.status | grep "Current map ID:" | awk '{print $4}' )
Viomi_Remember_Map=$( cat /tmp/${viomi_name}.status | grep "Remember map:" | awk '{print $3}' )
Viomi_Has_Map=$( cat /tmp/${viomi_name}.status | grep "Has map:" | awk '{print $3}' )
Viomi_New_Map=$( cat /tmp/${viomi_name}.status | grep "Has new map:" | awk '{print $4}' )
Viomi_Amount_Maps=$( cat /tmp/${viomi_name}.status | grep "Number of maps:" | awk '{print $4}' )
Viomi_Light_State=$( cat /tmp/${viomi_name}.status | grep "Light state:" | awk '{print $3}')
timestamp=$( date +%s%N)
# Convert Secondary Cleaning from 0 to False or 1 to True
if [ "$Viomi_Sec_Cleanup" = "0" ]; then
                Viomi_Sec_Clean="False"
        else
                Viomi_Sec_Clean="True"
fi

if [ "$Viomi_Mop_Y" = "Y" ]; then
                Viomi_Y_Pattern="True"
        else
                Viomi_Y_Pattern="False"
fi


# Write it to a tmp file
echo "vacuum name=\"$viomi_name\",status=\"$Viomi_Working_Status\",charging=\"$Viomi_Charging\",battery=\"$Viomi_Battery\",boxtype=\"$Viomi_Box_Type\",profile=\"$Viomi_Mode\",fanspeed=\"$Viomi_Fan_Speed\",edges=\"$Viomi_Vacuum_Edges\",waterpump=\"$Viomi_Water_Grade\",ypattern=\"$Viomi_Y_Pattern\",seccleanup=\"$Viomi_Sec_Clean\",volume=\"$Viomi_Sound_Vol\",cleantime=\"$Viomi_Clean_Time\",cleanarea=\"$Viomi_Clean_Area\",mapid=\"$Viomi_Current_Map\",hasmap=\"$Viomi_Has_Map\",newmaps=\"$Viomi_New_Map\",knownmaps=\"$Viomi_Amount_Maps\",lightstate=\"$Viomi_Light_State\" $timestamp">/tmp/curl_data.txt

# Send the file contents to to Influxdb
curl -XPOST "http://$influxdb_host:$influxdb_port/api/v2/write?bucket=$influxdb_db" -d "$(cat /tmp/curl_data.txt)"

# Cleanup
if [ -f "/tmp/curl_data.txt" ]; then
        rm -f /tmp/curl_data.txt
fi

if [ -f "/tmp/${viomi_name}.status" ]; then
        rm -f /tmp/${viomi_name}.status
fi
