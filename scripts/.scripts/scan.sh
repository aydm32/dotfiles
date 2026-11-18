#!/bin/bash

ethernet=$(ip route show | grep "kernel" | grep "enp")
ethIP=$(echo "$ethernet" | awk '{print $1}')
ethInt=$(echo "$ethernet" | awk '{print $3}')

wifi=$(ip route show | grep "kernel" | awk '{print $3}' | grep "w")
wifiIP=$(echo "$wifi" | awk '{print $1}')
wifiInt=$(echo "$wifi" | awk '{print $3}')

echo "WiFi IP: $wifiIP"
echo "Ethernet IP: $ethIP"

#nmap -sn $1 > scan_results.txt

# Extract IPs from saved file
#grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' scan_results.txt | sort -u
