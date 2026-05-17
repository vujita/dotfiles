#!/bin/bash
CACHE="/tmp/ghostty-window-id"

ACTIVE=$(xdotool getactivewindow 2>/dev/null)
ACTIVE_CLASS=$(xprop -id "$ACTIVE" WM_CLASS 2>/dev/null | grep -oi '"[^"]*"' | tr -d '"' | head -1)

if echo "$ACTIVE_CLASS" | grep -qi "ghostty"; then
    echo "$ACTIVE" > "$CACHE"
    xdotool windowminimize "$ACTIVE"
else
    WINDOW=$(cat "$CACHE" 2>/dev/null)
    if [ -z "$WINDOW" ]; then
        WINDOW=$(xdotool search --class "ghostty" 2>/dev/null | tail -1)
    fi
    if [ -z "$WINDOW" ]; then
        ghostty &
        WINDOW=$(xdotool search --sync --class "ghostty" 2>/dev/null | tail -1)
        wmctrl -ir $(printf '0x%x' "$WINDOW") -b add,maximized_vert,maximized_horz
    else
        xdotool windowmap "$WINDOW" 2>/dev/null
        xdotool windowactivate --sync "$WINDOW"
        xdotool windowraise "$WINDOW"
    fi
fi
