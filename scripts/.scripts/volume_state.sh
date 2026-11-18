#!/bin/bash
# Volume status with Nerd Font icons
vol=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    icon="󰝟"
elif [ "$vol" -eq 0 ]; then
    icon=""
elif [ "$vol" -le 33 ]; then
    icon=""
elif [ "$vol" -le 66 ]; then
    icon=""
else
    icon=""
fi

echo "$icon $vol% "
