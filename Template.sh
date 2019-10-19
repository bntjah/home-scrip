#!/bin/bash
# This is mainly used to set my Proxmox Templates from default settings
# To something else without to much hassle and then reboot the VM
tpl_def_ip=
tpl_def_cidr=
tpl_def_prim_dns=
tpl_def_sec_dns=
tpl_def_hostname=

#Clear the screen so that all questions are clearly visible
clear

# Questions asked
echo Please Enter the new hostname for this VM
read vmname
echo Setting the new hostname towards $vmname
echo
echo Please Enter the IP you want to use
read ipvm
echo Setting the IP towards ${ipvm}
echo
echo Please Enter the CIDR to use
read subnetvm
echo Setting the CIDR towards ${subnetvm}
echo
echo Define the Primary DNS you want to use for this system
read primdnsvm
echo Setting the Primary DNS towards ${primdnsvm}
echo
echo Define the Secondary DNS you want to use for this system
read secdnsvm
echo Setting the Secondary DNS towards ${secdnsvm}

#Setting Hostname
sudo sed -i 's|${tpl_def_hostname}|'${vmname}'|g' /etc/hosts
sudo hostnamectl set-hostname ${vmname}

#Setting the IP
sudo sed -i 's|${tpl_def_ip}/${tpl_def_cidr}|'${ipvm}/${subnetvm}'|g' /etc/netplan/${tpl_def_netplan}

#Setting the Primary DNS
sudo sed -i 's|[${tpl_def_prim_dns}|'${primdnsvm}'|g' /etc/netplan/${tpl_def_netplan}

#Setting the Secondary DNS
sudo sed -i 's|${tpl_def_sec_dns}]|'${secdnsvm}'|g' /etc/netplan/${tpl_def_netplan}

echo Everything is set and done, rebooting the VM
read -n1 -r -p 'Press any key to reboot...' key
if [ "$?" -eq "0" ]; then
        echo
        sudo reboot
fi
