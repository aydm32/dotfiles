#!/bin/bash
# Advanced Tailscale Auto-Installer for Ubuntu

set -e

# User Configuration
AUTH_KEY="tskey-auth-xxxxxxxxxxxxxxxxx"
CUSTOM_HOSTNAME="" # Set to empty for auto-detection, or specify: "my-custom-name"
TAGS=""            # Optional: --tag=tag:web-server,tag:production

# Auto-detect hostname if not set
if [ -z "$CUSTOM_HOSTNAME" ]; then
	HOSTNAME=$(hostname -s)
else
	HOSTNAME="$CUSTOM_HOSTNAME"
fi

echo "🚀 Installing Tailscale on $HOSTNAME..."

sudo apt update
sudo apt install curl nmap ssh vim

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Build the tailscale up command
UP_CMD="sudo tailscale up --auth-key $AUTH_KEY --hostname=$HOSTNAME"
if [ -n "$TAGS" ]; then
	UP_CMD="$UP_CMD --tags=$TAGS"
fi

# Connect to Tailscale
eval $UP_CMD

# Show status
echo "✅ Tailscale installed and connected!"
echo "📡 Status:"
tailscale status
echo "🌐 Your Tailscale IP: $(tailscale ip -4)"
