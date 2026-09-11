#!/bin/bash

# Set Timezone to America/Los_Angeles for predictable time scheduling
# export TZ="America/Los_Angeles"

# Force Xrandr to target the shared X11 container socket
export DISPLAY=:0

# --- Configuration ---
OFF_TIME=${SCHEDULE_OFF_TIME:-"23:00"} 
ON_TIME=${SCHEDULE_ON_TIME:-"06:30"} 
PRIMARY_DISPLAY=${SCHEDULE_PRIMARY_DISPLAY:-"HDMI-1"} 

# --- Display Control Functions ---
turn_off_display() {
    if [ -z "$DISPLAY" ]; then
        echo "[Scheduler] WARNING: DISPLAY variable not set. Skipping xrandr."
        return 1
    fi
    echo "[Scheduler] Attempting to turn display OFF on $PRIMARY_DISPLAY..."
    xrandr --output "$PRIMARY_DISPLAY" --off
}

turn_on_display() {
    if [ -z "$DISPLAY" ]; then
        echo "[Scheduler] WARNING: DISPLAY variable not set. Skipping xrandr."
        return 1
    fi
    echo "[Scheduler] Attempting to turn display ON on $PRIMARY_DISPLAY..."
    xrandr --output "$PRIMARY_DISPLAY" --auto
}

# --- Scheduling Math Logic ---
check_schedule() {
    # 1. Edge Case Protection: Ensure system clock is updated via NTP.
    # If the system year reports as anything before 2025, the network clock hasn't synced yet.
    CURRENT_YEAR=$(date +%Y)
    if [ "$CURRENT_YEAR" -lt 2025 ]; then
        echo "[Scheduler] Clock looks unsynced ($CURRENT_YEAR). Waiting for NTP synchronization..."
        return 0
    fi

    CURRENT_HOUR=$(date +%H)
    CURRENT_MINUTE=$(date +%M)
    CURRENT_TOTAL_MINUTES=$(( 10#$CURRENT_HOUR * 60 + 10#$CURRENT_MINUTE ))

    time_to_minutes() {
        local time_str=$1
        local h=$(echo "$time_str" | cut -d':' -f1)
        local m=$(echo "$time_str" | cut -d':' -f2)
        echo $(( 10#$h * 60 + 10#$m ))
    }

    OFF_MINUTES=$(time_to_minutes "$OFF_TIME")
    ON_MINUTES=$(time_to_minutes "$ON_TIME")

    echo "--- Checking Schedule ---"
    echo "Current Time: $CURRENT_HOUR:$CURRENT_MINUTE ($CURRENT_TOTAL_MINUTES min)"
    echo "Off Time Scheduled: $OFF_TIME ($OFF_MINUTES min)"
    echo "On Time Scheduled: $ON_TIME ($ON_MINUTES min)"

    # Exact minute match to prevent display-hammering loops
    if (( CURRENT_TOTAL_MINUTES == OFF_MINUTES )); then
        echo "Scheduled turn-off time reached ($OFF_TIME). Executing display off."
        turn_off_display
    elif (( CURRENT_TOTAL_MINUTES == ON_MINUTES )); then
        echo "Scheduled turn-on time reached ($ON_TIME). Executing display on."
        turn_on_display
    else
        echo "No exact time match. Monitoring..."
    fi
}

# Execute the check immediately when the script starts
check_schedule
