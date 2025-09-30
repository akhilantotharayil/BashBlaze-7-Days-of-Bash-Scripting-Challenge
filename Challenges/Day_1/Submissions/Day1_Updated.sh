#!/bin/bash

# -------------------------------------------
# Day 1: Bash Scripting Challenge
# This script demonstrates basic bash features:
# Comments, Echo, Variables, Built-in variables, and Wildcards
# -------------------------------------------

# Task 1: Comments
# This is a comment. It will not be executed.

# Task 2: Echo
echo "Hello, BashBlaze Challenger! 🔥"
echo "This is Day 1 of the Bash Scripting Challenge."

# Task 3: Variables
name="Akhil The BashBlazer"
day=1
greeting="Welcome to Day $day, $name!"

# Task 4: Using Variables (Addition)
num1=5
num2=7
sum=$((num1 + num2))
echo "The sum of $num1 and $num2 is: $sum"

# Task 5: Built-in Variables
echo "Current script name: $0"        # $0 = script name
echo "Number of arguments passed: $#" # $# = number of args
echo "Current working directory: $PWD" # $PWD = present working directory
echo "User currently logged in: $USER" # $USER = current user

# Task 6: Wildcards
echo "Listing all .py files in this directory:"
ls -la *.py 2>/dev/null || echo "No .py files found."

# End of script
