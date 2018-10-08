#!/bin/sh
# copy the privkey to a place where we can set the perms to 600 to make ssh happy
cp /mnt/us/extensions/kindleberrypi/etc/id /var/tmp/_id &&
chmod 600 /var/tmp/_id &&
# set orientation to landscape (doesn't work on ktouch)
# lipc-set-prop com.lab126.winmgr orientationLock R
# Run
/mnt/us/extensions/kterm/bin/kterm -o R -k 0 -c 0 -s 8 -e "ssh -o StrictHostKeyChecking=no -i /var/tmp/_id -l pi 172.24.1.1"