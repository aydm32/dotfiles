#!/bin/bash
WALL_DIR="$HOME/dotfiles/wallpapers"
STATE_FILE="$HOME/.config/nitrogen/.last_wallpaper"

mapfile -t wallpapers < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

if [ ${#wallpapers[@]} -eq 0 ]; then
  echo "No wallpapers found in $WALL_DIR"
  exit 1
fi

last=$(cat "$STATE_FILE" 2>/dev/null)
next_index=0
for i in "${!wallpapers[@]}"; do
  if [[ "${wallpapers[$i]}" == "$last" ]]; then
    next_index=$(((i + 1) % ${#wallpapers[@]}))
    break
  fi
done

selected="${wallpapers[$next_index]}"
nitrogen --set-zoom-fill "$selected"

echo "$selected" >"$STATE_FILE"
