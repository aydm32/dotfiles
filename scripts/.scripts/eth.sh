#!/bin/bash
# ~/.local/bin/ethernet_status.sh

# Check if Ethernet is connected
if ip link show | grep -E "eth[0-9]|enp[0-9]s[0-9]|eno[0-9]" | grep -q "state UP"; then
    echo "󰈁"
else
    echo "󰈂"
fi
