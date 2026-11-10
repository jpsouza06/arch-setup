#!/usr/bin/env bash

set -u

theme="$HOME/.config/rofi/powermenu.rasi"

choice=$(printf '  Desligar\n  Reiniciar\n󰜺  Cancelar\n' | rofi -dmenu -no-custom -theme "$theme") || exit 0

case "$choice" in
    "  Desligar")
        action="desligar"
        command=(systemctl poweroff)
        ;;
    "  Reiniciar")
        action="reiniciar"
        command=(systemctl reboot)
        ;;
    *)
        exit 0
        ;;
esac

confirmation=$(printf '󰜺  Não\n  Sim, %s\n' "$action" | rofi -dmenu -no-custom -theme "$theme") || exit 0

if [[ "$confirmation" == "  Sim, $action" ]]; then
    "${command[@]}"
fi
