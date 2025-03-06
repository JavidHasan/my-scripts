#!/bin/bash

# Retrieving the number's password from the database
read -p "Please enter the file name (if you leave it blank, it'll be created automatically): " FILE_NAME

# If the user hasn't entered a name, assign a name automatically to the new file.
if [[ -z "$FILE_NAME" ]]; then
    FILE_NAME="blocked_numbers_$(date +%Y%m%d_%H%M%S)"
fi

# Add .txt to the end (if the user hasn't typed it)
OUTPUT_FILE="${FILE_NAME%.txt}.txt"

# Ask the user to enter numbers
echo "Please enter the numbers to be blocked. (Please compleate with #CTRL+D):"

# Read numbers and write to file
while read -r number; do
    # Ignore empty lines
    if [[ -n "$number" ]]; then
        echo "sip:+99412$number@voip.ims.ultel.az" >> "$OUTPUT_FILE"
    fi
done

echo "New file created: $OUTPUT_FILE"
