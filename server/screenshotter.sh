#!/bin/bash
# Server-side script to take a periodic screenshot and save it to a http server documentroot
# Infinite Loop
while true; do
    # Take a screenshot, save over previous and don't make a sound
    scrot -oz /tmp/shot.png
    # Convert to format for kindle. Rotate 180 for alternate orientation. Include -resize if VNC server instance isn't 800x600px. 
    convert /tmp/shot.png -rotate 90 -filter LanczosSharp -colorspace Gray -dither FloydSteinberg -quality 75 -define png:color-type=0 -define png:bit-depth=8 /var/www/html/shot.png
    # Refresh every 60 seconds
    sleep 60
done
