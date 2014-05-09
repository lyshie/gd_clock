#!/bin/sh

CLOCK="$(dirname $0)/gd_clock.pl"
COLOR="$(dirname $0)/fill_color.pl"
FONT_NAME="/opt/local/fonts/lyshie/LiHeiPro.ttf"

if [ -z "$1" ]; then
    watch -c -t -n 0.5 "$0 clock"
else
    $CLOCK -n "$FONT_NAME" -p 10 -s "$(date +%F)" | $COLOR
    $CLOCK -n "$FONT_NAME" -p 15 -s "$(date +%T)" | $COLOR
fi
