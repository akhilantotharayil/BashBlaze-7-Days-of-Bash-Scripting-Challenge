#!/bin/bash

#Task 1:Comments
#Very excited to learn  Bash Scripting with TWS Community
: << 'COMMENT1'
Comments are
used to ignore the
code.
COMMENT1

#Task 2:echo
echo "Hello System"

#Task 3:Variables
Name="Akhil"
Aim="Devops"

#Task 4:Using Variables
Num1=10
Num2=50
Sum=$Num1+$Num2
echo "Sum is $Sum"

#Task 5:Using Built-in Variables
echo 'BASH='$BASH
echo 'SHELL='$SHELL
echo 'PWD='$PWD

#Task 6:Wildcards
#Wildcards are special characters used to perform pattern matching when working with files. Your task is to create a bash script that utilizes wildcards to list all the files with a specific extension in a directory.

touch file{1..4}.txt
ls *.txt


