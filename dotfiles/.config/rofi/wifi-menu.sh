#!/usr/bin/env bash

set -u

theme="$HOME/.config/rofi/wifi-menu.rasi"

if [[ "$(nmcli -t -f WIFI general)" != "enabled" ]]; then
    choice=$(printf '󰤨  Ativar Wi-Fi\n󰜺  Cancelar\n' | rofi -dmenu -no-custom -theme "$theme") || exit 0
    if [[ "$choice" == "󰤨  Ativar Wi-Fi" ]]; then
        nmcli radio wifi on
        notify-send "Wi-Fi" "Wi-Fi ativado"
    fi
    exit 0
fi

declare -A seen

print_networks() {
    local i raw_ssid ssid signal security connected icon status
    local -a ssids signals securities

    mapfile -t ssids < <(nmcli -t -f SSID device wifi list)
    mapfile -t signals < <(nmcli -t -f SIGNAL device wifi list)
    mapfile -t securities < <(nmcli -t -f SECURITY device wifi list)
    connected=$(nmcli -t -f ACTIVE,SSID device wifi list | sed -n 's/^yes://p' | head -n1)

    for i in "${!ssids[@]}"; do
        raw_ssid="${ssids[$i]}"
        [[ -z "$raw_ssid" || -n "${seen[$raw_ssid]:-}" ]] && continue
        seen[$raw_ssid]=1

        ssid=$(printf '%s' "$raw_ssid" | sed 's/\\:/:/g; s/\\\\/\\/g')
        signal="${signals[$i]:-0}"
        security="${securities[$i]:---}"

        if [[ "$raw_ssid" == "$connected" ]]; then
            icon="󰤨"
            status="conectado"
        elif [[ -n "$security" && "$security" != "--" ]]; then
            icon="󰌾"
            status="${signal}%"
        else
            icon="󰤯"
            status="${signal}%"
        fi

        printf '%s  %s  ·  %s\n' "$icon" "$ssid" "$status"
    done
}

build_menu() {
    # Mostra imediatamente os resultados em cache.
    print_networks
    printf '󰖪  Desativar Wi-Fi\n󰜺  Cancelar\n'

    # O Rofi continua aberto enquanto novas redes são adicionadas após a busca.
    nmcli device wifi rescan >/dev/null 2>&1 || true
    print_networks
}

choice=$(build_menu | rofi -dmenu -i -no-custom -theme "$theme") || exit 0

case "$choice" in
    "󰜺  Cancelar"|"")
        exit 0
        ;;
    "󰖪  Desativar Wi-Fi")
        nmcli radio wifi off
        notify-send "Wi-Fi" "Wi-Fi desativado"
        exit 0
        ;;
esac

ssid="${choice#*  }"
ssid="${ssid%  ·  *}"
[[ -z "$ssid" ]] && exit 0

if nmcli device wifi connect "$ssid" >/dev/null 2>&1; then
    notify-send "Wi-Fi" "Conectado a $ssid"
    exit 0
fi

password=$(printf '' | rofi -dmenu -password -theme "$theme" -p "Senha de $ssid" \
    -theme-str 'inputbar { children: [ prompt, entry ]; }') || exit 0
[[ -z "$password" ]] && exit 0

if nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1; then
    notify-send "Wi-Fi" "Conectado a $ssid"
else
    notify-send -u critical "Wi-Fi" "Não foi possível conectar a $ssid"
fi
