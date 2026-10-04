#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Minimalist Black & Red Hyprland Rice
# Fedora installer
# ============================================================

BOLD="$(tput bold 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
RESET="$(tput sgr0 2>/dev/null || echo '')"

info() {
    echo -e "${BOLD}${GREEN}[*]${RESET} $*"
}

warn() {
    echo -e "${BOLD}${YELLOW}[!]${RESET} $*"
}

error() {
    echo -e "${BOLD}${RED}[ERR]${RESET} $*"
    exit 1
}

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/.config"
WALLPAPER_SOURCE="$DOTFILES_DIR/wallpaper/wallpaper.png"

BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

CONFIG_FOLDERS=(
    "hypr"
    "waybar"
    "swaync"
    "rofi"
    "kitty"
)

# ------------------------------------------------------------
# Header
# ------------------------------------------------------------

echo
echo -e "${BOLD}${GREEN}==============================================${RESET}"
echo -e "${BOLD}${GREEN}   Minimalist Black & Red Rice Installer${RESET}"
echo -e "${BOLD}${GREEN}==============================================${RESET}"
echo

info "Repository: $DOTFILES_DIR"

# ------------------------------------------------------------
# Basic checks
# ------------------------------------------------------------

if [ ! -d "$CONFIG_DIR" ]; then
    error "Could not locate the .config directory in the repository."
fi

if [ ! -f "$WALLPAPER_SOURCE" ]; then
    error "Could not locate wallpaper/wallpaper.png in the repository."
fi

for folder in "${CONFIG_FOLDERS[@]}"; do
    if [ ! -d "$CONFIG_DIR/$folder" ]; then
        error "Missing repository configuration: .config/$folder"
    fi
done

if [ "$(id -u)" -eq 0 ]; then
    error "Do not run this installer as root. Run it as your normal user."
fi

if ! command -v dnf >/dev/null 2>&1; then
    error "DNF was not found. This installer currently supports Fedora."
fi

if ! command -v sudo >/dev/null 2>&1; then
    error "sudo is required."
fi

# ------------------------------------------------------------
# Required system dependencies
# ------------------------------------------------------------

info "Installing required system dependencies..."

sudo dnf install -y \
    dnf-plugins-core \
    fontconfig \
    flatpak \
    curl \
    unzip

# ------------------------------------------------------------
# Backup existing configurations
# ------------------------------------------------------------

mkdir -p "$BACKUP_DIR"

BACKUP_CREATED=0

info "Checking existing configuration..."

for folder in "${CONFIG_FOLDERS[@]}"; do
    TARGET_PATH="$HOME/.config/$folder"

    # -e catches normal files/directories and valid symlinks.
    # -L additionally catches broken symlinks.
    if [ -e "$TARGET_PATH" ] || [ -L "$TARGET_PATH" ]; then

        warn "Existing ~/.config/$folder detected."

        # Determine whether sudo is required to move it.
        if [ -w "$(dirname "$TARGET_PATH")" ] && [ -w "$TARGET_PATH" ]; then
            mv "$TARGET_PATH" "$BACKUP_DIR/$folder"
        else
            warn "~/.config/$folder requires elevated permissions. Using sudo for backup."
            sudo mv "$TARGET_PATH" "$BACKUP_DIR/$folder"
            sudo chown -h "$(id -u):$(id -g)" "$BACKUP_DIR/$folder" 2>/dev/null || true
        fi

        BACKUP_CREATED=1
    fi
done

if [ "$BACKUP_CREATED" -eq 1 ]; then
    info "Existing configurations backed up to:"
    echo "    $BACKUP_DIR"
else
    rmdir "$BACKUP_DIR" 2>/dev/null || true
    info "No existing configurations needed to be backed up."
fi

# ------------------------------------------------------------
# Create configuration symlinks
# ------------------------------------------------------------

info "Creating configuration symlinks..."

mkdir -p "$HOME/.config"

for folder in "${CONFIG_FOLDERS[@]}"; do
    TARGET_PATH="$HOME/.config/$folder"
    REPO_PATH="$CONFIG_DIR/$folder"

    ln -s "$REPO_PATH" "$TARGET_PATH"

    info "Linked ~/.config/$folder -> $REPO_PATH"
done

# ------------------------------------------------------------
# Enable COPRs
# ------------------------------------------------------------

info "Enabling Hyprland COPR..."
sudo dnf copr enable -y nett00n/hyprland

info "Enabling awww COPR..."
sudo dnf copr enable -y ackerman/nexus

# ------------------------------------------------------------
# Install required packages
# ------------------------------------------------------------

info "Installing required packages..."

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
    jetbrains-mono-fonts

# ------------------------------------------------------------
# Install JetBrains Mono Nerd Font
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
    curl -fL "$NERD_FONT_URL" -o "$FONT_ZIP"

    info "Installing JetBrains Mono Nerd Font..."
    unzip -o "$FONT_ZIP" -d "$FONT_DIR" >/dev/null

    rm -f "$FONT_ZIP"

    fc-cache -f "$FONT_DIR"

    info "JetBrains Mono Nerd Font installed."
fi

# ------------------------------------------------------------
# Install wallpaper
# ------------------------------------------------------------

WALLPAPER_DIR="$HOME/Pictures/wallpaper"
WALLPAPER_TARGET="$WALLPAPER_DIR/wallpaper.png"

info "Installing wallpaper..."

mkdir -p "$WALLPAPER_DIR"
cp "$WALLPAPER_SOURCE" "$WALLPAPER_TARGET"

info "Wallpaper installed to:"
echo "    $WALLPAPER_TARGET"

# ------------------------------------------------------------
# Script permissions
# ------------------------------------------------------------

info "Applying execute permissions..."

chmod +x "$CONFIG_DIR/waybar/scripts/launch.sh" 2>/dev/null || true
chmod +x "$CONFIG_DIR/rofi/launchers/type-1/launcher.sh" 2>/dev/null || true

# ------------------------------------------------------------
# Optional audio mixer
# ------------------------------------------------------------

info "Checking for Flatpak audio mixer..."

if command -v flatpak >/dev/null 2>&1; then
    flatpak install -y flathub com.saivert.pwvucontrol || \
        warn "Could not install pwvucontrol. You can install it manually later."
else
    warn "Flatpak is not available. Skipping pwvucontrol."
fi

# ------------------------------------------------------------
# Refresh current Hyprland session
# ------------------------------------------------------------

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && command -v hyprctl >/dev/null 2>&1; then

    info "Hyprland session detected. Reloading configuration..."

    hyprctl reload || \
        warn "Could not reload Hyprland automatically."

    # --------------------------------------------------------
    # Waybar
    # --------------------------------------------------------

    if pgrep -x waybar >/dev/null 2>&1; then
        info "Restarting Waybar..."

        pkill -x waybar || true
        sleep 1

        if [ -x "$CONFIG_DIR/waybar/scripts/launch.sh" ]; then
            "$CONFIG_DIR/waybar/scripts/launch.sh" &
        else
            waybar &
        fi
    fi

    # --------------------------------------------------------
    # SwayNC
    # --------------------------------------------------------

    if pgrep -x swaync >/dev/null 2>&1; then
        info "Restarting SwayNC..."

        pkill -x swaync || true
        sleep 1
        swaync &
    fi

    # --------------------------------------------------------
    # awww
    # --------------------------------------------------------

    if command -v awww-daemon >/dev/null 2>&1; then

        if ! pgrep -x awww-daemon >/dev/null 2>&1; then
            info "Starting awww daemon..."
            awww-daemon >/dev/null 2>&1 &
            sleep 1
        fi

        if command -v awww >/dev/null 2>&1; then
            info "Applying wallpaper..."
            awww img "$WALLPAPER_TARGET" || \
                warn "Could not apply wallpaper automatically."
        fi
    fi

else
    info "No active Hyprland session detected."
    info "Start Hyprland after installation to launch the complete rice."
fi

# ------------------------------------------------------------
# Completion
# ------------------------------------------------------------

echo
echo -e "${BOLD}${GREEN}==============================================${RESET}"
echo -e "${BOLD}${GREEN}✔ Setup complete!${RESET}"
echo -e "${BOLD}${GREEN}==============================================${RESET}"
echo

echo "Installed components:"
echo "  • Hyprland"
echo "  • Waybar"
echo "  • SwayNC"
echo "  • Rofi-Wayland"
echo "  • Kitty"
echo "  • Dolphin"
echo "  • awww"
echo "  • Brightnessctl"
echo "  • Playerctl"
echo "  • JetBrains Mono"
echo "  • JetBrains Mono Nerd Font"
echo "  • pwvucontrol"
echo

echo "Configuration:"
echo "  • Hyprland Lua configuration"
echo "  • Waybar"
echo "  • SwayNC"
echo "  • Rofi"
echo "  • Kitty"
echo

echo "Wallpaper:"
echo "  $WALLPAPER_TARGET"
echo

if [ "$BACKUP_CREATED" -eq 1 ]; then
    echo "Previous configuration backup:"
    echo "  $BACKUP_DIR"
    echo
fi

echo -e "${BOLD}${GREEN}You can now start/restart your Hyprland session.${RESET}"
echo
