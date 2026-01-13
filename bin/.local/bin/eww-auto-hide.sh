#!/bin/bash
# ~/.local/bin/eww-auto-hide.sh

sleep 1
eww open dashboard 2>/dev/null

check_action() {
    # Obtenemos ventanas en el workspace enfocado (jq -r para raw output)
    COUNT=$(swaymsg -t get_tree | jq -r '.. | select(.type? == "workspace" and .focused == true) | (.nodes | length) + (.floating_nodes | length) // 0')

    if [[ "$COUNT" -eq 0 ]]; then
        eww update dash_reveal=true
    else
        eww update dash_reveal=false
    fi
}

check_action
swaymsg -t subscribe '["window", "workspace"]' -m | while read -r event; do
    check_action
done
