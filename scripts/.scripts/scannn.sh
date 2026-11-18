#!/bin/bash
# mystery_host_investigator.sh

TARGET="10.42.0.109"
echo "[*] Investigating mysterious host: $TARGET"

echo "[1] Basic connectivity..."
ping -c 3 $TARGET

echo "[2] ARP discovery..."
arping -c 3 $TARGET 2>/dev/null || sudo arping -c 3 $TARGET

echo "[3] TCP SYN scan..."
sudo nmap -sS -T4 $TARGET

echo "[4] UDP top ports..."
sudo nmap -sU --top-ports 50 $TARGET

echo "[5] OS detection attempts..."
sudo nmap -O -Pn $TARGET

echo "[6] Firewall detection..."
sudo nmap -sA $TARGET

echo "[7] Full port range scan..."
sudo nmap -p- -T4 $TARGET

echo "[+] Investigation complete"
