#!/bin/bash
# Comprobamos si la ventana está activa según el daemon
if eww active-windows | grep -q "dashboard"; then
    eww close dashboard # Si existe, la cerramos
else
    eww open dashboard # Si no existe, la invocamos
fi
