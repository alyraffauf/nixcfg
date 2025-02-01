#!/usr/bin/env bash

show() {
    MAKO_MODE=$(makoctl mode)
    if echo "$MAKO_MODE" | grep -q "do-not-disturb"; then
        printf '{"text": "󰂛", "class": "on", "tooltip": "Notifications snoozed."}\n'
    else
        printf '{"text": "󰂚", "class": "off","tooltip": "Notifications enabled."}\n'
    fi
}

toggle() {
    makoctl mode -t do-not-disturb
    pkill -SIGRTMIN+2 .waybar-wrapped
}

[ $# -gt 0 ] && toggle || show
