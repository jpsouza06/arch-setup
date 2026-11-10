#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
pacman -Qqen | sort -u > "$ROOT_DIR/packages/pacman.txt"
pacman -Qqem | grep -vE '^(yay|yay-debug)$' | sort -u > "$ROOT_DIR/packages/aur.txt"
echo "Listas de pacotes atualizadas. Revise as alterações antes do commit."
