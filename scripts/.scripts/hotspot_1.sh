#!/bin/bash

if [[ -n "$1" && -n "$2" ]]; then
  # Use provided  SSID and password
  sudo nmcli device wifi hotspot ifname wlp0s20f0u3 ssid "$1" password "$2"
else
  # Fall back to default hotspot
  sudo nmcli device wifi hotspot ifname wlp0s20f0u3 ssid voidlinux password 26062026
fi
