#!/bin/bash

# Declare associative arrays to store menu and orders
declare -A MENU_ITEMS
declare -A MENU_PRICES
declare -A order

# Function to read and display the menu from menu.txt
function display_menu() {
    echo "📋 Welcome to the Restaurant!"
    echo "Here is the menu:"
    echo "---------------------------"

    if [[ ! -f menu.txt ]]; then
        echo "Error: menu.txt file not found!"
        exit 1
    fi

    while IFS=',' read -r number name price; do
        number=$(echo "$number" | xargs)
        name=$(echo "$name" | xargs)
        price=$(echo "$price" | xargs)
        
        MENU_ITEMS["$number"]="$name"
        MENU_PRICES["$number"]="$price"
        
        echo "$number. $name - ₹$price"
    done < menu.txt

    echo "---------------------------"
}

# Function to calculate the total bill
function calculate_total_bill() {
    local total=0
    for item_number in "${!order[@]}"; do
        quantity="${order[$item_number]}"
        price="${MENU_PRICES[$item_number]}"
        total=$(( total + quantity * price ))
    done
    echo "$total"
}

# Function to handle invalid input
function handle_invalid_input() {
    echo "❌ Invalid input! Please enter a valid item number and quantity."
}

# ==== Main Script Starts Here ====

# Display menu
display_menu

# Ask for customer name
read -p "👤 Please enter your name: " customer_name

# Ask for order
echo "🛒 Please enter item number and quantity (e.g., 1 2 3 1 for 2 Burgers and 1 Pizza):"
read -a input_order

# Validate and process order input
for (( i=0; i<${#input_order[@]}; i+=2 )); do
    item_number="${input_order[i]}"
    quantity="${input_order[i+1]}"

    # Check for valid item number and quantity
    if [[ -z "${MENU_ITEMS[$item_number]}" || ! "$quantity" =~ ^[1-9][0-9]*$ ]]; then
        handle_invalid_input
        exit 1
    fi

    # Store in order array
    if [[ -n "${order[$item_number]}" ]]; then
        order[$item_number]=$(( order[$item_number] + quantity ))
    else
        order[$item_number]=$quantity
    fi
done

# Calculate total bill
total_bill=$(calculate_total_bill)

# Display order summary
echo ""
echo "----- Order Summary for $customer_name -----"
for item_number in "${!order[@]}"; do
    item="${MENU_ITEMS[$item_number]}"
    quantity="${order[$item_number]}"
    price="${MENU_PRICES[$item_number]}"
    subtotal=$(( price * quantity ))
    echo "$item x $quantity = ₹$subtotal"
done
echo "--------------------------------------------"
echo "💵 Total Bill: ₹$total_bill"
echo "🙏 Thank you, $customer_name! Please visit again!"
