#!/usr/bin/env bash

load_config() {
    CONFIG="$HOME/.config/focus-timer/config.ini"
    afk_limit=$(grep "^afk_limit=" "$CONFIG" | cut -d= -f2)
    poll_rate=$(grep "^poll_rate=" "$CONFIG" | cut -d= -f2)
    target_window=$(grep "^target_window=" "$CONFIG" | cut -d= -f2)
    log_file=$(grep "^log_file=" "$CONFIG" | cut -d= -f2)
}

detect_compositor() {
    if [[ $XDG_CURRENT_DESKTOP == *"KDE"* ]]; then
        compositor="kwin"
    elif [[ $XDG_CURRENT_DESKTOP == *"Hyprland"* ]]; then
        compositor="hyprland"
    elif [[ $XDG_CURRENT_DESKTOP == *"sway"* ]]; then
        compositor="sway"
    else
        compositor="generic"
    fi
}

get_active_window() {
    case "$compositor" in
        kwin)
            win=$(qdbus org.kde.KWin /KWin org.kde.KWin.activeWindow)
            qdbus org.kde.KWin "$win" org.kde.KWin.Window.title 2>/dev/null
            ;;
        hyprland)
            hyprctl activewindow -j | jq -r '.title'
            ;;
        sway)
            swaymsg -t get_tree | jq -r '.. | select(.focused?) | .name'
            ;;
        *)
            echo ""
            ;;
    esac
}

monitor_input() {
    libinput debug-events --device /dev/input/event* 2>/dev/null | \
    while read -r line; do
        last_input=$(date +%s)
    done
}

run_timer() {
    load_config
    detect_compositor

    focused_time=0
    last=$(date +%s)
    last_input=$(date +%s)

    monitor_input &

    while true; do
        now=$(date +%s)
        idle=$((now - last_input))
        win_title=$(get_active_window)

        if [[ "$win_title" == *"$target_window"* && $idle -lt $afk_limit ]]; then
            focused_time=$((focused_time + (now - last)))
        fi

        last=$now
        sleep "$poll_rate"
    done
}
