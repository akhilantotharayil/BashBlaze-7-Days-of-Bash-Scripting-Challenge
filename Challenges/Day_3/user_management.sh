#!/bin/bash

# Simple User Management Script

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Use sudo."
  exit 1
fi

# Show help menu
show_help() {
  echo "User Management Script"
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  -c, --create      Create a user"
  echo "  -d, --delete      Delete a user"
  echo "  -r, --reset       Reset user password"
  echo "  -l, --list        List all users"
  echo "  -h, --help        Show help"
}

# Create user
create_user() {
  read -p "Enter new username: " username
  if id "$username" &>/dev/null; then
    echo "User '$username' already exists."
    exit 1
  fi
  read -s -p "Enter password: " password
  echo
  useradd "$username"
  echo "$username:$password" | chpasswd
  echo "User '$username' created."
}

# Delete user
delete_user() {
  read -p "Enter username to delete: " username
  if ! id "$username" &>/dev/null; then
    echo "User '$username' does not exist."
    exit 1
  fi
  userdel -r "$username"
  echo "User '$username' deleted."
}

# Reset password
reset_password() {
  read -p "Enter username: " username
  if ! id "$username" &>/dev/null; then
    echo "User '$username' does not exist."
    exit 1
  fi
  read -s -p "Enter new password: " password
  echo
  echo "$username:$password" | chpasswd
  echo "Password for '$username' has been reset."
}

# List users
list_users() {
  echo "Usernames and UIDs:"
  awk -F: '$3 >= 1000 && $1 != "nobody" { print $1, "(UID:", $3 ")" }' /etc/passwd
}

# Handle arguments
case "$1" in
  -c|--create) create_user ;;
  -d|--delete) delete_user ;;
  -r|--reset)  reset_password ;;
  -l|--list)   list_users ;;
  -h|--help|*) show_help ;;
esac
