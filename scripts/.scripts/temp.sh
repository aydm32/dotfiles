#!/bin/bash
# ~/.local/bin/cpu_temp_color.sh

# Get CPU temperature in Celsius
get_cpu_temp() {
    # Try common temperature sensor paths
    temp_paths="
        /sys/class/thermal/thermal_zone0/temp
        /sys/class/hwmon/hwmon0/temp1_input
        /sys/class/hwmon/hwmon1/temp1_input
        /sys/class/hwmon/hwmon2/temp1_input
        /sys/class/hwmon/hwmon0/temp2_input
    "
    
    for path in $temp_paths; do
        if [ -f "$path" ]; then
            temp=$(cat "$path")
            # Convert millidegrees to degrees if needed
            if [ "$temp" -gt 1000 ]; then
                temp=$((temp / 1000))
            fi
            echo "$temp"
            return
        fi
    done
    
    # If no temperature found, try using sensors command if available
    if command -v sensors >/dev/null 2>&1; then
        temp=$(sensors | grep -E "Package id|Core 0" | grep -oE '+[0-9]+\.[0-9]°C' | head -n1 | tr -d '+°C' | cut -d. -f1)
        if [ -n "$temp" ]; then
            echo "$temp"
            return
        fi
    fi
    
    echo "0"
}

# Get maximum temperature (assuming 100°C as max for percentage calculation)
MAX_TEMP=100

# Get current temperature
temp=$(get_cpu_temp)

# Calculate temperature percentage
temp_percent=$((temp * 100 / MAX_TEMP))

# Choose icon based on temperature
if [ "$temp" -lt 40 ]; then
    icon=""  # Cold
    color=""   # Default color
elif [ "$temp" -lt 55 ]; then
    icon=""  # Cool
    color=""   # Default color
elif [ "$temp" -lt 70 ]; then
    icon=""  # Warm
    color=""   # Default color
elif [ "$temp" -lt 85 ]; then
    icon=""  # Hot
else
    icon=""  # Very hot
fi

    echo "$icon $temp°C "
