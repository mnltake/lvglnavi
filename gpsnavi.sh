#!/bin/sh
cd /home/pi/lvglnavi
/usr/bin/lxterminal -e /home/pi/lvglnavi/gpsnavi-server.py &
sleep 10
/usr/bin/lxterminal -e sudo python3 /home/pi/lvglnavi/gpsnavi-client.py