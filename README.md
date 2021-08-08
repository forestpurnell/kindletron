# Kindletron

**Kindletron** allows a kindle to act as a low-refresh, highly persistent wireless display or second screen for a wide range of computers and devices. The project is inspired by and borrows code from:

* Max Ogden's [kindleberry](https://maxogden.com/kindleberry-wireless.html)
* [Kindle Weather Display](https://www.galacticstudios.org/kindle-weather-display/)
* Jaap Meijers' [Kindle Clock](https://techcrunch.com/2018/08/06/this-hack-turns-your-old-kindle-into-a-clock/)

To make this work, you need:

* A jailbroken kindle with the [Kindle Unified Application Launcher (KUAL)](https://www.mobileread.com/forums/showthread.php?t=203326) installed. I recommend this kindle be one you plan to use as a dedicated display, and no longer as an eReader. Old, used kindles had for cheap or free are ideal.
* A linux computer for the server, like a Raspberry Pi. Similar procedures could be adapted for Mac OS, Microsoft WSL or any device that can take screenshots and run an http server 

You'll end up with a small, wireless display that:

* looks great during the day and outdoors
* has days or weeks of battery life, depending on refresh rate (ideal for pairing with a solar charger)
* refreshes every minute by default
* can show just about anything except videos (well it can, just with lots of dropped frames)
* content can be changed remotely without any device reconfiguration
* is based on a simple client-server architecture that can be modified to include any number of displays only limited by network and server resource constraints
* reduces e-waste!

## Why?

Using an eReader as a display holds many creative possibilities. A number of projects exist that allow the kindle to be used as a stanalone weather station, for showing a specific type of data, or as a primary monitor. This project aims to make it as easy as possible to use the kindle as a **dynamic, networked display that can also be administered remotely**.

## Limitations

The way Amazon's kindle OS is designed ensures that at this time there is [no surefire way](https://www.mobileread.com/forums/showthread.php?t=288900) to eliminate display artifacts such as the clock and WiFi Symbol from showing through the content delivered by this method. 

A low-tech workaround to this would be to cover up the area of the screen that shows those glitches with an oversized frame.

The use-case I had in mind for this project involved displaying public information, and therefore all data is transmitted unencrypted and remains publicly accessible. For sensitive applications you could set up an SSH tunnel between the kindle and the server.

## Instructions

### Server

1. Install and set up tightVNC server using the instructions [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-18-04). Your screen geometry should match the kindle's (usually 800x600 px). 

2. We will need the programs `scrot`, `imagemagick` and `lighttpd` for the server scripts to work: `sudo apt-get install scrot imagemagick lighttpd`.

3. Edit `screenshotter.sh` to ensure all of the urls match your desired setup. Move `screenshotter.sh` in your .vnc directory of your home folder.

4. Make your ~/.vnc/xstartup file look something like this. I use openbox window manager since it's lightweight, but xfce, gnome, etc will work too:

```
#!/bin/bash
xrdb $HOME/.Xresources
openbox &
~/.vnc/screenshotter.sh
```

5. That's it. Now when you run `sudo systemctl start vncserver@1` a screenshot of any activity in that vnc instance (not your main desktop) will be refreshed and served up by lighttpd every 60 seconds. Now we need to get your kindle to download and display that image.

6. Security note: anyone with access to your server will be able to view the screenshots taken with this set up. Make sure you only use this on a trusted network, configure lighttpd/firewall only to allow connections from your kindle or use USB networking only.

### Client (Kindle)

1. Jailbreak your kindle using the instructions [here](https://www.mobileread.com/forums/showthread.php?t=275881). Install the Kindle Unified Application Launcher (KUAL) using the instructions [here](https://www.mobileread.com/forums/showthread.php?t=225030). 

2. If your kindle does not have Wifi, install and set up the [USB network hack](https://www.mobileread.com/forums/showthread.php?t=225030).

3. Using a USB connection, move the files from the extensions folder in the repository to the extensions folder in your kindle. Edit `bin/kindletron.sh` so that it points at the URL of your server.

4. Move `no-server.png` to the main directory of your kindle.

5. Unmount your kindle. Open KUAL and open the kindletron menu item. Press `start kindletron`. Your desktop should appear within 60 seconds and be refreshed every 60 seconds thereafter. If the connection ever gets lost, an error message will display. The error will clear if the connection is regained.

6. Using a VNC client, connect to your server, e.g. `localhost:5901` and set up what you would like to be displayed on the kindle.

6. To stop kindletron, press and hold the power button and restart the device.

## Possible Modifications

The reason that a VNC server is used is that it allows remote administration of what appears on the kindle screen and also avoids having the kindle be just a mirror of the primary screen. If neither of those features are desired, you could skip the steps involving vnc and just run `screenshotter.sh` from `.xinitrc` or a similar file.

For additional kindles/screens, just add additional tightvnc and x instances :2, :3, etc.

Finally, another reminder that following the instructions above could lead to a **potentially insecure setup**. Make sure you are smart about your firewall rules and who can access the vnc and http servers set up above. Better yet, do all of that and tunnel the VNC and HTTP traffic through SSH.

If you want to use the kindle with wifi on a network that does not have internet access, add a file named `WIFI_NO_NET_PROBE` to the main directory of your kindle.

If used with a kindle that supports touch, the screen will still respond to taps. To disable touch, I recommend integrating something like bartek fabiszewski's [untouchable](https://www.fabiszewski.net/kindle-untouchable/) program.

## Future Work

It would be great to have the kindle to enter client mode on device startup (like the kindle weather display). I could not figure out how to get the kindle's crontab to run the script without causing `wget` to break. 