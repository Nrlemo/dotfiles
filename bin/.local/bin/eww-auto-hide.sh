#!/bin/bash
# ~/.local/bin/eww-auto-hide.sh

# --- Prevención de múltiples instancias ---
LOCKFILE="/tmp/eww-auto-hide.lock"
if [ -e "$LOCKFILE" ] && kill -0 $(cat "$LOCKFILE") 2>/dev/null; then
    echo "Ya hay una instancia ejecutándose."
    exit 1
fi
echo $$ > "$LOCKFILE"

# --- Asegurar que el daemon viva ---
if ! pgrep -x "eww" > /dev/null; then
    eww daemon &
    sleep 1 # Damos tiempo al daemon para despertar~~
fi

# Abrimos el dashboard una sola vez
eww open dashboard 2>/dev/null

check_action() {
    # Obtenemos el conteo de nodos en el workspace enfocado
    COUNT=$(swaymsg -t get_tree | jq -r '.. | select(.type? == "workspace" and .focused == true) | (.nodes | length) + (.floating_nodes | length) // 0')

    if [[ "$COUNT" -eq 0 ]]; then
        eww update dash_reveal=true
    else
        eww update dash_reveal=false
    fi
}

# Ejecución inicial
check_action

# Suscripción a eventos de Sway
swaymsg -t subscribe '["window", "workspace"]' -m | while read -r event; do
    check_action
done
