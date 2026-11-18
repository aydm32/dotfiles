#!/bin/bash

# Get the clipboard content
url=$(xclip -o -selection clipboard)

yt-dlp -f "bestvideo[height<=1080][protocol^=https]+bestaudio[protocol^=https][language^=en]/bestvideo[height<=1080][protocol^=https]+bestaudio[protocol^=https]" \
  -o '~/Downloads/Videos/%(title)s.%(ext)s' "$url"
