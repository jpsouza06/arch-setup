#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ $EUID -eq 0 ]]; then
  echo "Execute como usuário normal, não como root." >&2
  exit 1
fi

if [[ ! -r /etc/arch-release ]]; then
  echo "Este instalador foi feito para Arch Linux." >&2
  exit 1
fi

sudo -v

echo "[1/6] Instalando pacotes oficiais..."
mapfile -t pacman_packages < <(grep -Ev '^\s*(#|$)' "$ROOT_DIR/packages/pacman.txt")
sudo pacman -Syu --needed --noconfirm "${pacman_packages[@]}"

if ! command -v yay >/dev/null; then
  echo "[2/6] Instalando yay..."
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$build_dir/yay"
  (cd "$build_dir/yay" && makepkg -si --needed --noconfirm)
else
  echo "[2/6] yay já está instalado."
fi

echo "[3/6] Instalando pacotes do AUR..."
mapfile -t aur_packages < <(grep -Ev '^\s*(#|$)' "$ROOT_DIR/packages/aur.txt")
((${#aur_packages[@]} == 0)) || yay -S --needed --noconfirm "${aur_packages[@]}"

echo "[4/6] Salvando configurações atuais e aplicando dotfiles..."
backup="$HOME/.local/state/arch-setup/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup" "$HOME/.config" "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots"
for item in .bashrc .bash_profile .bash_logout .gtkrc-2.0; do
  [[ ! -e "$HOME/$item" ]] || cp -a "$HOME/$item" "$backup/"
done
for dir in hypr waybar kitty rofi matugen emacs btop Thunar nwg-look xsettingsd gtk-3.0 gtk-4.0 qt5ct qt6ct waypaper; do
  [[ ! -e "$HOME/.config/$dir" ]] || cp -a "$HOME/.config/$dir" "$backup/"
done
cp -a "$ROOT_DIR/dotfiles/." "$HOME/"
chmod +x "$HOME/.config/rofi/"*.sh

echo "[5/6] Configurando greetd e serviços..."
sudo install -Dm644 "$ROOT_DIR/system/greetd.toml" /etc/greetd/config.toml
while IFS= read -r service; do
  [[ -z "$service" || "$service" == \#* ]] || sudo systemctl enable "$service"
done < "$ROOT_DIR/system/services.txt"
sudo usermod -aG docker "$USER"

echo "[6/6] Concluído. Backup anterior: $backup"
echo "Reinicie o computador. O grupo docker será aplicado no próximo login."
