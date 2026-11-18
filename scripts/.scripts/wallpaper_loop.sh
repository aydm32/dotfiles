#!/bin/sh
DIR="$HOME/dotfiles/wallpapers"
INTERVAL=600 # seconds

while true; do
  nitrogen --set-zoom-fill --random "$DIR" --save
  sleep "$INTERVAL"
done
