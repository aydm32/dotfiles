#!/bin/bash
# ~/.local/bin/net_speed.sh

# Get the active network interface
get_active_interface() {
    # Check for Ethernet first
    eth_interface=$(ip route | grep default | grep -E "dev eth[0-9]|dev enp[0-9]s[0-9]|dev eno[0-9]" | awk '{print $5}' | head -n1)
    
    if [ -n "$eth_interface" ]; then
        echo "$eth_interface"
        return
    fi
    
    # Check for WiFi if no Ethernet
    wifi_interface=$(ip route | grep default | grep -E "dev wlan[0-9]|dev wlp[0-9]s[0-9]" | awk '{print $5}' | head -n1)
    
    if [ -n "$wifi_interface" ]; then
        echo "$wifi_interface"
        return
    fi
    
    # No active interface found
    echo ""
}

# Get current RX/TX values in bytes
get_bytes() {
    interface="$1"
    if [ -z "$interface" ]; then
        echo "0 0"
        return
    fi
    
    # Get RX and TX bytes
    rx=$(cat /sys/class/net/"$interface"/statistics/rx_bytes 2>/dev/null || echo "0")
    tx=$(cat /sys/class/net/"$interface"/statistics/tx_bytes 2>/dev/null || echo "0")
    
    echo "$rx $tx"
}

# Format bytes to human readable format
format_speed() {
    bytes=$1
    if [ "$bytes" -gt 1000000 ]; then
        printf "%.1f Mbps" $(echo "$bytes / 1000000 * 8" | bc -l)
    elif [ "$bytes" -gt 1000 ]; then
        printf "%.1f Kbps" $(echo "$bytes / 1000 * 8" | bc -l)
    else
        printf "%d bps" $((bytes * 8))
    fi
}

# Main script
interface=$(get_active_interface)

if [ -z "$interface" ]; then
    echo ""
    exit 0
fi

# Get initial values
initial=$(get_bytes "$interface")
rx_prev=$(echo "$initial" | awk '{print $1}')
tx_prev=$(echo "$initial" | awk '{print $2}')

# Wait 1 second
sleep 1

# Get new values
current=$(get_bytes "$interface")
rx_now=$(echo "$current" | awk '{print $1}')
tx_now=$(echo "$current" | awk '{print $2}')

# Calculate differences
rx_diff=$((rx_now - rx_prev))
tx_diff=$((tx_now - tx_prev))

# Format the speeds
download_speed=$(format_speed "$rx_diff")
upload_speed=$(format_speed "$tx_diff")

# Determine icon based on interface type
if echo "$interface" | grep -q "eth\|enp\|eno"; then
    icon="󰈁"
else
    icon=""
fi

# Display the result
echo "$icon ↓ $download_speed ↑ $upload_speed"
