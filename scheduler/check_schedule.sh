#!/bin/bash

# Script to manage the display power/state based on time.
# This script must be run by the 'scheduler' container.

# --- Configuration ---
# Define the target times (HH:MM). Overrides via environment variables are supported.
OFF_TIME=${SCHEDULE_OFF_TIME:-"23:00"} # Default: 23:00
ON_TIME=${SCHEDULE_ON_TIME:-"06:30"} # Default: 06:30

# Assuming the primary display output is named 'HDMI-1' or similar connected port.
# You MUST verify the exact output name using 'xrandr' on a working system.
PRIMARY_DISPLAY=${SCHEDULE_PRIMARY_DISPLAY:-"HDMI-1"} # Default: HDMI-1

# --- Display Control Functions (Using xrandr) ---

# Function to turn the display OFF
turn_off_display() {
    echo "[Scheduler] Attempting to turn display OFF on $PRIMARY_DISPLAY..."
    # Disables the specified output
    xrandr --output "$PRIMARY_DISPLAY" --off
    echo "Display command executed."
}

# Function to turn the display ON
turn_on_display() {
    echo "[Scheduler] Attempting to turn display ON on $PRIMARY_DISPLAY..."
    # Re-enables the output, potentially restoring its last configuration
    xrandr --output "$PRIMARY_DISPLAY" --auto --output "$PRIMARY_DISPLAY" --on
    echo "Display command executed."
}

# Function to check the current time and execute actions
check_schedule() {
    # Get the current time in HH:MM format
    CURRENT_TIME=$(date +%H:%M)
    
    echo "--- Checking Schedule ---"
    echo "Current time: $CURRENT_TIME"
    
    # 1. Check if it's time to turn OFF
    # NOTE: If the service running this container handles time zones differently, 
    # you might need to adjust 'date' command usage.
    if [ "$CURRENT_TIME" = "$OFF_TIME" ]; then
        echo "Scheduled turn-off time reached ($OFF_TIME). Executing display off."
        turn_off_display
    # 2. Check if it's time to turn ON
    elif [ "$CURRENT_TIME" = "$ON_TIME" ]; then
        echo "Scheduled turn-on time reached ($ON_TIME). Executing display on."
        turn_on_display
    else
        echo "Current time ($CURRENT_TIME) is outside the scheduled window."
    fi
}

# Execute the check immediately when the script starts
check_schedule
