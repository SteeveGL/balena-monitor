#!/bin/bash

# Set Timezone to America/Los_Angeles for predictable time scheduling
export TZ="America/Los_Angeles"

# Script to manage the display power/state based on time.
# This script must be run by the 'scheduler' container.

# --------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES (Optional Overrides)
# These variables can be set in the docker-compose.yml file or via the container environment.
#
# - SCHEDULE_OFF_TIME: Time (HH:MM) to turn the display off (Default: 23:00).
# - SCHEDULE_ON_TIME: Time (HH:MM) to turn the display on (Default: 06:30).
# - SCHEDULE_PRIMARY_DISPLAY: The name of the primary display output (e.g., HDMI-1, DP-1). 
#                             MUST be verified using 'xrandr' (Default: HDMI-1).
# --------------------------------------------------------------------------------

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
    if [ -z "$DISPLAY" ]; then
        echo "[Scheduler] WARNING: Cannot turn display OFF. DISPLAY environment variable is not set. Skipping xrandr call."
        return 1
    fi
    echo "[Scheduler] Attempting to turn display OFF on $PRIMARY_DISPLAY..."
    # Disables the specified output
    xrandr --output "$PRIMARY_DISPLAY" --off
    echo "Display command executed."
}

# Function to turn the display ON
turn_on_display() {
    if [ -z "$DISPLAY" ]; then
        echo "[Scheduler] WARNING: Cannot turn display ON. DISPLAY environment variable is not set. Skipping xrandr call."
        return 1
    fi
    echo "[Scheduler] Attempting to turn display ON on $PRIMARY_DISPLAY..."
    # Re-enables the output, potentially restoring its last configuration
    xrandr --output "$PRIMARY_DISPLAY" --auto --output "$PRIMARY_DISPLAY" --on
    echo "Display command executed."
}

# Function to check the current time and execute actions
check_schedule() {
    # Get current time components
    CURRENT_HOUR=$(date +%H)
    CURRENT_MINUTE=$(date +%M)
    CURRENT_TOTAL_MINUTES=$((CURRENT_HOUR * 60 + CURRENT_MINUTE))

    # Helper to convert HH:MM string to minutes past midnight
    time_to_minutes() {
        local time_str=$1
        local h="${time_str:0:2}"
        local m="${time_str:2:2}"
        echo $((h * 60 + m))
    }

    OFF_MINUTES=$(time_to_minutes "$OFF_TIME")
    ON_MINUTES=$(time_to_minutes "$ON_TIME")

    echo "--- Checking Schedule ---"
    echo "Current Time: $CURRENT_HOUR:$CURRENT_MINUTE (Minutes past midnight: $CURRENT_TOTAL_MINUTES)"
    echo "Off Time Scheduled: $OFF_TIME ($OFF_MINUTES min)"
    echo "On Time Scheduled: $ON_TIME ($ON_MINUTES min)"

    # 1. Check if it's time to turn OFF (current time is >= OFF_TIME)
    if (( CURRENT_TOTAL_MINUTES >= OFF_MINUTES )); then
        echo "Scheduled turn-off time reached or passed ($OFF_TIME). Executing display off."
        turn_off_display
    # 2. Check if it's time to turn ON (current time is >= ON_TIME)
    elif [ "$CURRENT_TOTAL_MINUTES" -ge "$ON_MINUTES" ]; then
        echo "Scheduled turn-on time reached or passed ($ON_TIME). Executing display on."
        turn_on_display
    else
        echo "Current time is within the scheduled window."
    fi
}

# Execute the check immediately when the script starts
check_schedule
