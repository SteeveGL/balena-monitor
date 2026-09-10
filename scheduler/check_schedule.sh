#!/bin/bash

# Script to manage the display power/state based on time.
# This script must be run by the 'scheduler' container.

# --- Configuration ---
# Define the target times (HH:MM)
OFF_TIME="23:00" # Changed to 23:00 (11 PM) based on typical system time zone alignment if 21:00 fails
ON_TIME="06:30"

# Assuming the primary display output is named 'HDMI-1' or similar connected port.
# You MUST verify the exact output name using 'xrandr' on a working system.
PRIMARY_DISPLAY="HDMI-1" 

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
check_schedule, etc.)
turn_off_display() {
    echo "[Scheduler] Turning display OFF..."
    # Example using xrandr to turn off the primary display output
    # Check your screen's connected display names (e.g., eDP-1, HDMI-1)
    # xrandr --output <DISPLAY_NAME> --off
    
    # For testing, we just echo a message:
    echo "Display output command executed (Placeholder for xrandr --output <DISPLAY_NAME> --off)"
    
    # Implement the actual command here
}

# Function to turn the display ON (e.g., restoring the display state)
turn_on_display() {
    echo "[Scheduler] Turning display ON..."
    # Example using xrandr to restore the display output
    # xrandr --output <DISPLAY_NAME> --auto --output <DISPLAY_NAME> --on
    
    # For testing, we just echo a message:
    echo "Display output command executed (Placeholder for xrandr --output <DISPLAY_NAME> --auto --output <DISPLAY_NAME> --on)"
    
    # Implement the actual command here
}

# Function to check the current time and execute actions
check_schedule() {
    # Get the current time in HH:MM format
    CURRENT_TIME=$(date +%H:%M)
    
    echo "--- Checking Schedule ---"
    echo "Current time: $CURRENT_TIME"
    
    # 1. Check if it's time to turn OFF
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

# If you were to use a traditional cron setup, you would just schedule this script
# For the docker-compose loop, the 'command' in docker-compose.yml handles continuous execution.
