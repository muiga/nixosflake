#!/bin/bash

# Define the file path
KDEGLOBALS="$HOME/.config/kdeglobals"

# Define the color settings
ACTIVE_COLOR="frame=61,174,233"
INACTIVE_COLOR="inactiveFrame=239,240,241"

# Check if the [WM] section exists
if grep -q "\[WM\]" "$KDEGLOBALS"; then
    # If the section exists, just append the colors
    echo "$ACTIVE_COLOR" >> "$KDEGLOBALS"
    echo "$INACTIVE_COLOR" >> "$KDEGLOBALS"
else
    # If the section doesn't exist, create it and then add the colors
    echo -e "\n[WM]" >> "$KDEGLOBALS"
    echo "$ACTIVE_COLOR" >> "$KDEGLOBALS"
    echo "$INACTIVE_COLOR" >> "$KDEGLOBALS"
fi

# Notify the user
echo "Border colors updated in $KDEGLOBALS"
