# Meu Arch Linux

Configurações públicas e instalador pós-instalação do meu Arch Linux com Hyprland.

## O que é instalado

- Pacotes oficiais listados em `packages/pacman.txt`.
- Pacotes do AUR listados em `packages/aur.txt`.
- Hyprland, Waybar, Rofi, Kitty, Emacs, Btop, Matugen, GTK e Qt.
- Serviços de rede, Bluetooth, Docker e greetd/tuigreet.

O projeto **não** guarda documentos, históricos, chaves SSH/GPG, tokens, cookies,
credenciais Wi-Fi, configurações de navegadores/Discord/Steam ou outros segredos.
Wallpapers também não estão incluídos, pois sua licença de redistribuição é desconhecida.

## Reinstalação

1. Instale o Arch Linux base com um usuário que tenha acesso a `sudo`.
2. Entre nesse usuário e conecte-se à internet.
3. Execute:

```bash
sudo pacman -S --needed git
git clone URL_DO_REPOSITORIO ~/arch-setup
cd ~/arch-setup
./install.sh
```

O instalador deve ser executado como usuário normal. Configurações existentes são
copiadas para `~/.local/state/arch-setup/backups/` antes da instalação.

> O instalador não particiona nem formata discos. Isso evita apagar o disco errado.

## Atualizar a lista de aplicativos

```bash
./update-lists.sh
git diff
```

Revise sempre o diff antes de publicar.
