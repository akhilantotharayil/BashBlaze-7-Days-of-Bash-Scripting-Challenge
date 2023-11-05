#!/bin/bash

# Check if the directory path is provided as a command-line argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

backup_directory="$1"
backup_folder="backup_$(date +'%Y%m%d_%H%M%S')"

# Create the backup directory if it doesn't exist
mkdir -p "$backup_directory"

# Create the timestamped backup folder and copy files
cp -R "$backup_directory" "$backup_directory/$backup_folder"

# Rotation mechanism: Keep only the last 3 backups
backup_count=$(ls -t "$backup_directory" | grep -c 'backup_')
if [ "$backup_count" -gt 3 ]; then
  ls -t "$backup_directory" | grep 'backup_' | tail -n +4 | xargs -d '\n' rm -rf
fi

