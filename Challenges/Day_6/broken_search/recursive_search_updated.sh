#!/bin/bash

# -----------------------------
# Recursive File Search Script
# Bash Blaze Challenge - Day 6c
# -----------------------------

# Check for exactly 2 arguments
if [ $# -ne 2 ]; then
  echo "Usage: ./recursive_search.sh <directory> <target_file>"
  exit 1
fi

search_directory="$1"
target_file="$2"

# Check if directory exists
if [ ! -d "$search_directory" ]; then
  echo "❌ Error: Directory '$search_directory' does not exist."
  exit 1
fi

# Perform the recursive search
found_path=$(find "$search_directory" -type f -name "$target_file" -print -quit)

if [ -n "$found_path" ]; then
  echo "✅ File found at: $(realpath "$found_path")"
  exit 0
else
  echo "🚫 File not found: $target_file"
  exit 1
fi
