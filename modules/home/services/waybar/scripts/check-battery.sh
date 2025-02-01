#!/usr/bin/env bash

if [ -d /sys/class/power_supply/BAT0 ]; then
    BAT=/sys/class/power_supply/BAT0
elif [ -d /sys/class/power_supply/BAT1 ]; then
    BAT=/sys/class/power_supply/BAT1
else
    echo "No battery found."
    exit 1
fi

CRIT=''${1:-10}
STAT=$(cat $BAT/status)
PERC=$(cat $BAT/capacity)

if [[ $PERC -le $CRIT ]] && [[ $STAT == "Discharging" ]]; then
    notify-send --urgency=critical --icon=dialog-error "Battery Critical" "Current charge: $PERC%".
fi
