#!/bin/sh

CLOCK="./gd_clock.pl"
FONT_NAME="/opt/local/fonts/lyshie/LiHeiPro.ttf"

watch -t -n 1 "$CLOCK $FONT_NAME 10 '%F'; $CLOCK $FONT_NAME 16 '%T'"
