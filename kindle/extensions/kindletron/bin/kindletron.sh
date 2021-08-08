#!/bin/sh
# Prevent the device from sleeping or showing a screensaver
lipc-set-prop -i com.lab126.powerd preventScreenSaver 1
/etc/init.d/framework stop
/etc/init.d/powerd stop
# Check if script is already running
if pidof -x "kindletron.sh" >/dev/null; then
    exit
else
    # Infinite Loop
    while true
    do
        # Download image from server and display if successful
        if wget http://10.10.0.104/shot.png -O /mnt/us/shot.png >/dev/null; then
            # Blank screen
            eips -c
            eips -c
            # Display Image
            eips -g /mnt/us/shot.png
            # Wait 60 seconds before refreshing
            sleep 60
        # if download wasn't successful, show error and try again
        else
            eips -c
            eips -c
            # Display Image
            eips -g /mnt/us/no-server.png
            sleep 60
        fi
    done
fi