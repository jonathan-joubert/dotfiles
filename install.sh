#!/usr/bin/env bash

set -euo pipefail

BOLD="$(tput bold 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
RESET="$(tput sgr0 2>/dev/null || echo '')"

info() { echo -e "${BOLD}${GREEN}[*]${RESET} $*"; }
warn() { echo -e "${BOLD}${YELLOW}[!]${RESET} $*"; }
error() { echo -e "${BOLD}${RED}[ERR]${RESET} $*"; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

CONFIG_FOLDERS=("hypr" "waybar" "swaync" "rofi")

info "Starting minimalist black & red rice deployment..."

if [ ! -d "$DOTFILES_DIR/.config" ]; then
    error "Could not locate the .config tracker directory. Please execute inside the repo root directory."
fi


mkdir -p "$BACKUP_DIR"

for folder in "${CONFIG_FOLDERS[@]}"; do
    TARGET_PATH="$HOME/.config/$folder"
   REPO_PATH="$DOTFILES_DIR/.config/$folder"

    if [ -d "$TARGET_PATH" ] || [ -f "$TARGET_PATH" ]; then
        warn "Existing config discovered at ~/.config/$folder. Creating safe system backup..."
        mv "$TARGET_PATH" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$TARGET_PATH")"

    info "Linking module: ~/.config/$folder -> $REPO_PATH"
    ln -s "$REPO_PATH" "$TARGET_PATH"
done

info "Applying execute permissions to system scripts..."
chmod +x "$DOTFILES_DIR/.config/waybar/scripts/launch.sh" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/.config/rofi/launchers/type-1/launcher.sh" 2>/dev/null || true

echo -e "\n${BOLD}${GREEN}✔ Setup complete!${RESET}"
echo -e "${BOLD}Make sure you have the following core system tools installed:${RESET}"
echo -e "  - ${YELLOW}Fedora:${RESET} sudo dnf install hyprland waybar swaync rofi-wayland kitty dolphin brightnessctl playerctl"
echo -e "  - ${YELLOW}Fonts:${RESET} JetBrains Mono Nerd Font"
echo -e "  - ${YELLOW}Audio Panel Mixer:${RESET} flatpak install flathub com.saivert.pwvucontrol"
echo -e "\nReload your environment or run ${BOLD}swaync-client -R${RESET} and ${BOLD}~/.config/waybar/scripts/launch.sh${RESET} to spin up components."
