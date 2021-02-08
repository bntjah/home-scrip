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
Viomi_Clean_Area=$( cat /tmp/${viomi_name}.status | grep "Clean area:" | awk '{print $3" "$4}' )
Viomi_Current_Map=$( cat /tmp/${viomi_name}.status | grep "Current map ID:" | awk '{print $4}' )
Viomi_Remember_Map=$( cat /tmp/${viomi_name}.status | grep "Remember map:" | awk '{print $3}' )
Viomi_Has_Map=$( cat /tmp/${viomi_name}.status | grep "Has map:" | awk '{print $3}' )
Viomi_New_Map=$( cat /tmp/${viomi_name}.status | grep "Has new map:" | awk '{print $4}' )
Viomi_Amount_Maps=$( cat /tmp/${viomi_name}.status | grep "Number of maps:" | awk '{print $4}' )
Viomi_Light_State=$( cat /tmp/${viomi_name}.status | grep "Light state:" | awk '{print $3}')

# Telgram Send All Found Settings
#/usr/bin/telegram "Status for ${viomi_name}"
#/usr/bin/telegram "Working? ${Viomi_Working_Status}"
#/usr/bin/telegram "Charging: ${Viomi_Charging}"
#/usr/bin/telegram "Battery Percentage: ${Viomi_Battery}"
#/usr/bin/telegram "Box Currently Installed: ${Viomi_Box_Type}"
#/usr/bin/telegram "Profile Currently Selected: ${Viomi_Mode} with FAN Profile: ${Viomi_Fan_Speed}"
#/usr/bin/telegram "Vacuum Edges?: ${Viomi_Vacuum_Edges}"
#/usr/bin/telegram "Water Pump Profile: ${Viomi_Water_Grade}"
#/usr/bin/telegram "Mop in Y pattern?: ${Viomi_Mop_Y}"
#/usr/bin/telegram "Secondary Cleanup?: ${Viomi_Sec_Cleanup}"
#/usr/bin/telegram "Sound Voume: ${Viomi_Sound_Vol}"
#/usr/bin/telegram "Cleaning Time: ${Viomi_Clean_Time} for area of ${Viomi_Clean_Area}"
#/usr/bin/telegram "Current Map ID=${Viomi_Current_Map}"
#/usr/bin/telegram "Has Map?: ${Viomi_Has_Map}"
#/usr/bin/telegram "Will Remember New Maps? ${Viomi_New_Map}"
#/usr/bin/telegram "Amount of Known Maps: ${Viomi_Amount_Maps}"
#/usr/bin/telegram "Light state?: ${Viomi_Light_State}"
