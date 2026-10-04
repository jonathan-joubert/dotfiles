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

CONFIG_FOLDERS=("hypr" "waybar" "swaync" "rofi" "kitty")

info "Starting minimalist black & red rice deployment..."

# ------------------------------------------------------------
# CHECKS
# ------------------------------------------------------------

if [ ! -d "$DOTFILES_DIR/.config" ]; then
    error "Could not locate the .config directory. Please execute inside the repo root directory."
fi

if [ ! -f "$DOTFILES_DIR/wallpaper/wallpaper.png" ]; then
    error "Could not locate wallpaper/wallpaper.png in the dotfiles repository."
fi

if ! command -v dnf >/dev/null 2>&1; then
    error "DNF was not found. This installer currently supports Fedora."
fi

# ------------------------------------------------------------
# BACKUP EXISTING CONFIGS
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# ENABLE REQUIRED COPRs
# ------------------------------------------------------------

info "Enabling Hyprland COPR..."
sudo dnf copr enable -y nett00n/hyprland

info "Enabling awww COPR..."
sudo dnf copr enable -y ackerman/nexus

# ------------------------------------------------------------
# INSTALL SYSTEM PACKAGES
# ------------------------------------------------------------

info "Installing required system packages..."

sudo dnf install -y \
    hyprland \
    hyprland-guiutils \
    awww \
    waybar \
    swaync \
    rofi-wayland \
    kitty \
    dolphin \
    brightnessctl \
    playerctl \
    jetbrains-mono-fonts \
    curl \
    unzip	

# ------------------------------------------------------------
# INSTALL JETBRAINS MONO NERD FONT
# ------------------------------------------------------------

FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"

if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    info "JetBrains Mono Nerd Font is already installed."
else
    info "JetBrains Mono Nerd Font not found."

    mkdir -p "$FONT_DIR"

    NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    FONT_ZIP="/tmp/JetBrainsMono.zip"

    info "Downloading JetBrains Mono Nerd Font..."

    curl -L "$NERD_FONT_URL" -o "$FONT_ZIP"

    info "Installing JetBrains Mono Nerd Font..."

    unzip -o "$FONT_ZIP" -d "$FONT_DIR" >/dev/null

    rm -f "$FONT_ZIP"

    fc-cache -f "$FONT_DIR"

    info "JetBrains Mono Nerd Font installed."
fi

# ------------------------------------------------------------
# INSTALL WALLPAPER
# ------------------------------------------------------------

WALLPAPER_SOURCE="$DOTFILES_DIR/wallpaper/wallpaper.png"
WALLPAPER_DIR="$HOME/Pictures/wallpaper"
WALLPAPER_TARGET="$WALLPAPER_DIR/wallpaper.png"

info "Installing wallpaper..."

mkdir -p "$WALLPAPER_DIR"
cp "$WALLPAPER_SOURCE" "$WALLPAPER_TARGET"

info "Wallpaper installed to $WALLPAPER_TARGET"

# ------------------------------------------------------------
# EXECUTE REQUIRED SCRIPTS
# ------------------------------------------------------------

info "Applying execute permissions to system scripts..."

chmod +x "$DOTFILES_DIR/.config/waybar/scripts/launch.sh" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/.config/rofi/launchers/type-1/launcher.sh" 2>/dev/null || true

# ------------------------------------------------------------
# OPTIONAL AUDIO MIXER
# ------------------------------------------------------------

if command -v flatpak >/dev/null 2>&1; then
    info "Installing audio mixer..."

    flatpak install -y flathub com.saivert.pwvucontrol || \
        warn "Could not install pwvucontrol. You can install it manually later."
else
    warn "Flatpak is not installed. Skipping pwvucontrol."
fi

# ------------------------------------------------------------
# COMPLETE
# ------------------------------------------------------------

echo
echo -e "${BOLD}${GREEN}✔ Setup complete!${RESET}"
echo
echo -e "${BOLD}Installed components:${RESET}"
echo -e "  - ${YELLOW}Hyprland${RESET}"
echo -e "  - ${YELLOW}Hyprland GUI Utils${RESET}"
echo -e "  - ${YELLOW}awww wallpaper daemon${RESET}"
echo -e "  - ${YELLOW}Waybar${RESET}"
echo -e "  - ${YELLOW}SwayNC${RESET}"
echo -e "  - ${YELLOW}Rofi-Wayland${RESET}"
echo -e "  - ${YELLOW}Kitty${RESET}"
echo -e "  - ${YELLOW}Dolphin${RESET}"
echo -e "  - ${YELLOW}Brightnessctl${RESET}"
echo -e "  - ${YELLOW}Playerctl${RESET}"
echo -e "  - ${YELLOW}JetBrains Mono${RESET}"
echo -e "  - ${YELLOW}JetBrains Mono Nerd Font${RESET}"
echo -e "  - ${YELLOW}pwvucontrol${RESET}"
echo
echo -e "${BOLD}Wallpaper:${RESET}"
echo -e "  ${WALLPAPER_TARGET}"
echo
echo -e "${BOLD}Configuration backup:${RESET}"
echo -e "  ${BACKUP_DIR}"
echo
echo -e "${BOLD}${GREEN}You can now start Hyprland.${RESET}"
