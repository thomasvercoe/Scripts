#!/bin/bash


# this script works with a file called /etc/udev/rules.d/99-display.rules

# inside this file should be the following line 
#SUBSYSTEM=="drm", ACTION=="change", RUN+="/usr/bin/bash '/home/thomas/scripts/monitor-mouse-lighting.sh'"



# Function to turn off mouse lighting
turn_off_mouse_lighting() {
    polychromatic-cli -o brightness -p 0
}

# Function to turn on mouse lighting
turn_on_mouse_lighting() {
    polychromatic-cli -o brightness -p 100
}

# Initial check of the monitor state
MONITOR_STATE=$(xset -q | grep "Monitor is" | awk '{print $3}')

if [ "$MONITOR_STATE" = "On" ]; then
    turn_on_mouse_lighting
else
    turn_off_mouse_lighting
fi