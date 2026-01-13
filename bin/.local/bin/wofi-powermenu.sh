#!/bin/bash

entries="Log Out\nSuspend\nReboot\nShutdown"

selected=$(echo -e $entries | wofi --dmenu --prompt "Sistema" --width 200 --lines 4)

case $selected in
  "Log Out")
    swaymsg exit ;; # Cierra la sesión de Sway
  "Suspend")
    systemctl suspend ;; # Suspende el equipo
  "Reboot")
    systemctl reboot ;; # Reinicia el sistema
  "Shutdown")
    systemctl poweroff ;; # Apaga el equipo
esac
