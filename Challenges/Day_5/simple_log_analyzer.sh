#!/bin/bash

# Check if log file path is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    exit 2
fi

# Variables
DATE=$(date '+%Y-%m-%d %H:%M:%S')
FILENAME=$(basename "$LOG_FILE")
TOTAL_LINES=$(wc -l < "$LOG_FILE")
ERROR_COUNT=$(grep -cE "ERROR|Failed" "$LOG_FILE")

# Get CRITICAL lines with line numbers
CRITICAL_LINES=$(grep -n "CRITICAL" "$LOG_FILE")

# Output file
REPORT="report_$(date +%Y%m%d_%H%M%S).txt"

# Generate report
{
    echo "=== Log Analysis Report ==="
    echo "Date: $DATE"
    echo "Log File: $FILENAME"
    echo "Total Lines: $TOTAL_LINES"
    echo "Total Errors (ERROR/Failed): $ERROR_COUNT"
    echo ""
    echo "=== Critical Events ==="
    if [ -z "$CRITICAL_LINES" ]; then
        echo "No CRITICAL events found."
    else
        echo "$CRITICAL_LINES"
    fi
} > "$REPORT"

echo "Report saved to $REPORT"