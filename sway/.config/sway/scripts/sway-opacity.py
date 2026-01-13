#!/usr/bin/python3
import i3ipc
import sys

# Inicializamos la conexión
try:
    sway = i3ipc.Connection()
except Exception as e:
    print(f"Error al conectar con Sway: {e}")
    sys.exit(1)

def apply_opacity(ipc):
    # Obtenemos solo las ventanas finales (hojas del árbol)
    for window in ipc.get_tree().leaves():
        # Filtramos para actuar solo sobre aplicaciones reales
        if window.app_id or window.window_class:
            if window.focused:
                window.command('opacity 1.0')
                # print(f"[DEBUG] Enfocada: {window.name}") # Opcional para debug
            else:
                window.command('opacity 0.9')
                # print(f"[DEBUG] Inactiva: {window.name}") # Opcional para debug

def on_window_focus(ipc, event):
    apply_opacity(ipc)

print("Daemon de opacidad iniciado (Leaves Mode)...")
# Aplicar al inicio
apply_opacity(sway)

# Escuchar cambios de foco y cierre de ventanas
sway.on('window::focus', on_window_focus)
sway.on('window::close', on_window_focus)

sway.main()
