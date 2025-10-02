#!/bin/bash

# ===============================================
# monitor_docker.sh
# Description:
#   Monitors the Docker daemon (systemd service).
#   If it's not active, restarts it.
# ===============================================

SERVICE="docker"

# Function to check if Docker is running
is_docker_running() {
    systemctl is-active --quiet "$SERVICE"
}

# Main logic
if is_docker_running; then
    echo "$(date): $SERVICE service is running."
else
    echo "$(date): $SERVICE service is NOT running. Attempting to restart..."

    # Restart Docker
    sudo systemctl restart "$SERVICE"

    # Wait a few seconds and check again
    sleep 3

    if is_docker_running; then
        echo "$(date): Successfully restarted $SERVICE service."
    else
        echo "$(date): Failed to restart $SERVICE service!"
        # Optional: send alert or log error
    fi
fi

exit 0
