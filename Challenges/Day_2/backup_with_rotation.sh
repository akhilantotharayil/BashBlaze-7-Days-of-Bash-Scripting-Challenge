#!/bin/bash

# ---------------------------------------------
# Simple Backup Script with Time-Based Rotation
# ---------------------------------------------

# 1. Check for directory input
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

TARGET_DIR="$1"

# 2. Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# 3. Set variables
DIR_NAME=$(basename "$TARGET_DIR")
PARENT_DIR=$(dirname "$TARGET_DIR")
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="${DIR_NAME}_backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="$PARENT_DIR/$BACKUP_NAME"

# 4. Create backup
tar -czf "$BACKUP_PATH" -C "$PARENT_DIR" "$DIR_NAME"
echo "Backup created: $BACKUP_PATH"

# 5. Delete backups older than 7 days (change +7 to your preference)
find "$PARENT_DIR" -name "${DIR_NAME}_backup_*.tar.gz" -mtime +7 -exec rm -f {} \; -print