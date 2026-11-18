#!/bin/bash
# ~/.local/bin/cpu_ram_simple.sh

# Get CPU usage percentage
get_cpu_usage() {
    # Read the first line of /proc/stat
    cpu_line=$(head -n 1 /proc/stat)
    set -- ${cpu_line#cpu }
    
    # Calculate total and idle time
    total_time=0
    for time in "$@"; do
        total_time=$((total_time + time))
    done
    idle_time=$(( $4 + $5 ))
    
    # Return both values
    echo "$total_time $idle_time"
}

# Get initial CPU readings
initial=$(get_cpu_usage)
total_prev=$(echo "$initial" | awk '{print $1}')
idle_prev=$(echo "$initial" | awk '{print $2}')

# Wait a moment
sleep 0.5

# Get current CPU readings
current=$(get_cpu_usage)
total_now=$(echo "$current" | awk '{print $1}')
idle_now=$(echo "$current" | awk '{print $2}')

# Calculate CPU usage percentage
total_delta=$((total_now - total_prev))
idle_delta=$((idle_now - idle_prev))
cpu_usage=$((100 * (total_delta - idle_delta) / total_delta))

# Get RAM usage percentage
mem_total=$(grep -E "MemTotal:" /proc/meminfo | awk '{print $2}')
mem_available=$(grep -E "MemAvailable:" /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_available))
ram_usage=$((mem_used * 100 / mem_total))

# Display the result with minimal icons
echo " $cpu_usage%  $ram_usage%"
