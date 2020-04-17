#!/bin/sh
#  make adjustment
#  read new brightness level
#  set icon relevant to new brightness
#  send notification with icon + level
#  play ding

if [ $# -ne 1 ]; then
    echo "Need 1 argument (briup, bridown)"
    exit 1;
fi
getnewvol () {
    # return a percentage
    RES=`light -G`
    CURBRI=${RES%%.*}
    echo "Current volume $CURBRI"
    if [ $CURBRI -gt 75 ]; then
        ICON=notification-display-brightness-full
    elif [ $CURBRI -gt 50 ]; then
        ICON=notification-display-brightness-high
    elif [ $CURBRI -gt 25 ]; then
        ICON=notification-display-brightness-medium
    elif [ $CURBRI -gt 0 ]; then
	ICON=notification-display-brightness-low
    elif [ $CURBRI -eq 0 ]; then
	ICON=notification-display-brightness-off
    fi

}
if [ $1 = 'briup' ]; then
    echo "Up"
    light -A 12
    MSG='Brightness up'
    getnewvol
elif [ $1 = 'bridown' ]; then
    echo "Down"
    light -U 12
    MSG='Brightness down'
    getnewvol
fi
echo "ICON: $ICON"
echo "MSG: $MSG"
echo "CURVOL: $CURBRI"
notify-send " " -i $ICON -h int:value:$CURBRI -h string:x-canonical-private-synchronous:brightness
paplay /usr/share/sounds/freedesktop/stereo/bell.oga

