#!/bin/bash

# Welcome Message
echo "Welcome to the Interactive File and Directory Explorer!"
echo

# Part 1: Display Files and Directories with Size
echo "Files and Directories in the Current Path:"
echo

# Use 'du -sh *' to list all items with human-readable sizes
du -sh * 2>/dev/null | while read size name; do
    echo "- $name ($size)"
done

echo

# Part 2: Character Counting
while true; do
    read -p "Enter a line of text (Press Enter without text to exit): " input

    if [ -z "$input" ]; then
        echo "Exiting the Interactive Explorer. Goodbye!"
        break
    fi

    echo "Character Count: ${#input}"
    echo
done

