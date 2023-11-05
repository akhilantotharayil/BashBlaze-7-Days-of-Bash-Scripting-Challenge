#!/bin/bash

#This is for the task 01 of the Day 02

#Part 1: File and Directory Exploration
#Upon execution without any command-line arguments, the script will display a welcome message and list all the files and directories in the current path.

echo "Welcome user the current path $PWD  has following files"

ls

#----------------------------------

#For each file and directory, the script will print its name and size in human-readable format (e.g., KB, MB, GB). This information will be obtained using the ls command with appropriate options.

echo "list of files and directory with available info"

ls -lh

#---------------------------------

#The list of files and directories will be displayed in a loop until the user decides to exit the explorer.

while true
do
    echo "Do you want to exit now ??  No = N, Yes = Y"
    read Exit
    if [[ $Exit ==  Y ]]; then
        echo "Confirmed ??"
	break
    fi
done

#---------------------------



#Part 2: Character Counting

#After displaying the file and directory list, the script will prompt the user to enter a line of text.
#The script will read the user's input until an empty string is entered (i.e., the user presses Enter without any text).

echo "Welcome to File and Directory Explorer!"

    while true; do
        echo "List of files and directories in the current path $PWD :"
        ls -lh

        read -p "Enter 'exit' to quit or press Enter to refresh the list: " input

        if [[ "$input" == "exit" ]]; then
            break
        else
            echo "Invalid input. Please try again."
        fi
    done

#For each line of text entered by the user, the script will count the number of characters in that line.
#The character count for each line entered by the user will be displayed.

while true; do
    read line

    if [ -z "$line" ]; then
        echo "Exiting the character counter."
        break
    fi

    character_count=${#line}
    echo "Number of characters in the line: $character_count"
done
