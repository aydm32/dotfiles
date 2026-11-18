#!/bin/sh

# Get date and time
datetime=$(date +'%a %Y-%m-%d %H:%M:%S')

# Get volume percentage (assuming PulseAudio)
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume:/ {print $5}' | tr -d '%')

# Get CPU percentage (average of all cores)
cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Get CPU temperature
temp=$(sensors | grep -E "Package|Core" | head -1 | awk '{print $4}' | tr -d '+°C')

# Get RAM usage
ram=$(free | awk '/Mem:/ {printf "%.1f%%", $3/$2 * 100}')

# Get network speed (requires previous state)
net_stats_file="/tmp/net_stats"
current_rx=$(cat /sys/class/net/$(ip route | awk '/default/ {print $5}')/statistics/rx_bytes)
current_tx=$(cat /sys/class/net/$(ip route | awk '/default/ {print $5}')/statistics/tx_bytes)

if [ -f "$net_stats_file" ]; then
    prev_rx=$(awk '{print $1}' "$net_stats_file")
    prev_tx=$(awk '{print $2}' "$net_stats_file")
    interval=$(awk '{print $3}' "$net_stats_file")
else
    prev_rx=$current_rx
    prev_tx=$current_tx
    interval=1
fi

rx_speed=$(( (current_rx - prev_rx) / interval / 1024 ))
tx_speed=$(( (current_tx - prev_tx) / interval / 1024 ))

# Save current stats for next run
echo "$current_rx $current_tx $interval" > "$net_stats_file"

# Check Ethernet connection
eth_state="Down"
if [ -d /sys/class/net/eth0 ] && [ "$(cat /sys/class/net/eth0/operstate)" = "up" ]; then
    eth_state="Up"
fi

# Format output
echo "🖥 $datetime | 🔊 $volume% | 🧠 $cpu | 🌡 ${temp}C | 💾 $ram | ⬇ ${rx_speed}K ⬆ ${tx_speed}K | 🔌 $eth_state"
