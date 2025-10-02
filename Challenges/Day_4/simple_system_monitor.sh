#!/bin/bash

# ===============================================
# simple_system_monitor.sh
# Description:
#   Lightweight system monitor showing CPU, memory,
#   disk usage, and a specific service status.
# ===============================================

# === Inputs ===
SERVICE="$1"
INTERVAL="$2"

# === Validate inputs ===
if [[ -z "$SERVICE" || -z "$INTERVAL" ]]; then
    echo "Usage: $0 <service_name> <sleep_interval_in_seconds>"
    echo "Example: $0 nginx 5"
    exit 1
fi

if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
    echo "[!] Sleep interval must be a number."
    exit 1
fi

# === Monitoring Loop ===
while true; do
    clear
    echo "=============================="
    echo "   SYSTEM MONITORING STATUS   "
    echo "=============================="

    # CPU usage
    echo "--- CPU Usage ---"
    top -bn1 | grep "Cpu(s)" | \
        awk '{print "User: " $2 "%, System: " $4 "%, Idle: " $8 "%"}'

    # Memory usage
    echo "--- Memory Usage ---"
    free -h | awk '/^Mem/ {print "Used: " $3 ", Free: " $4 ", Total: " $2}'

    # Disk usage
    echo "--- Disk Usage ---"
    df -h --output=source,pcent,size,used,avail | grep -v "Filesystem"

    # Service status
    echo "--- Service Status: $SERVICE ---"
    if systemctl is-active --quiet "$SERVICE"; then
        echo "[✓] $SERVICE is running."
    else
        echo "[✗] $SERVICE is NOT running."
        read -p "Do you want to start $SERVICE? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            sudo systemctl start "$SERVICE"
            if systemctl is-active --quiet "$SERVICE"; then
                echo "[✓] $SERVICE started successfully."
            else
                echo "[!] Failed to start $SERVICE."
            fi
        fi
    fi

    echo
    echo "Sleeping for $INTERVAL seconds. Press Ctrl+C to exit."
    sleep "$INTERVAL"
done
