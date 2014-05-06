#!/bin/sh

CLOCK="$(dirname $0)/gd_clock.pl"
FONT_NAME="/opt/local/fonts/lyshie/LiHeiPro.ttf"

if [ -z "$1" ]; then
    watch -t -n 0.5 "$0 clock"
else
    $CLOCK -n "$FONT_NAME" -p 10 -s "$(date +%F)"
    $CLOCK -n "$FONT_NAME" -p 15 -s "$(date +%T)"
fi
