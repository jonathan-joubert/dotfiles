# Dotfiles

A minimalist black and crimson accented desktop environment built around **Hyprland** with a Lua-based configuration.

---

## What the Installer Does

The `install.sh` script automates the complete setup of the desktop environment on **Fedora Workstation**.

It will:

* Verify that the system is running Fedora.
* Verify that the repository contains the required configuration and wallpaper files.
* Safely back up existing configurations from `~/.config/`.
* Create symbolic links from this repository into `~/.config/`.
* Enable the required COPR repositories.
* Install Hyprland and all required system packages.
* Install JetBrains Mono Nerd Font.
* Install and configure `awww` for wallpaper management.
* Copy the repository wallpaper to the user's Pictures directory.
* Apply executable permissions to required launcher scripts.
* Install `pwvucontrol` through Flatpak when Flatpak is available.

No manual package installation is required.

---

## System Components

| Component            | Software                                                                       |
| -------------------- | ------------------------------------------------------------------------------ |
| Window Manager       | [Hyprland](https://hypr.land/)                                                 |
| Configuration        | Hyprland Lua                                                                   |
| Wallpaper Daemon     | awww                                                                           |
| Status Panel         | [Waybar](https://github.com/Alexays/Waybar)                                    |
| Notifications        | [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) |
| Application Launcher | [Rofi-Wayland](https://github.com/marvinhacker/rofi-wayland)                   |
| Terminal Emulator    | [Kitty](https://sw.kovidgoyal.net/kitty/)                                      |
| File Manager         | Dolphin                                                                        |
| Audio Mixer          | pwvucontrol                                                                    |
| Fonts                | JetBrains Mono + JetBrains Mono Nerd Font                                      |

---

## Requirements

The installer is currently designed for:

* Fedora Linux
* A working internet connection
* `sudo` access
* Git

The installer automatically handles the remaining dependencies.

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/jonathan-joubert/dotfiles.git ~/dotfiles
```

### 2. Enter the Repository

```bash
cd ~/dotfiles
```

### 3. Run the Installer

```bash
chmod +x install.sh
./install.sh
```

The installer will automatically install and configure the required components.

### 4. Start Hyprland

Once installation is complete, log out of the current desktop session and select **Hyprland** from the login screen.

---

## Installed Packages

The installer installs the following Fedora packages:

```text
hyprland
hyprland-guiutils
awww
waybar
swaync
rofi-wayland
kitty
dolphin
brightnessctl
playerctl
jetbrains-mono-fonts
curl
unzip
```

It also enables the following COPR repositories:

```text
nett00n/hyprland
ackerman/nexus
```

The `ackerman/nexus` repository provides the `awww` wallpaper daemon package.

---

## Fonts

The installer installs both:

* JetBrains Mono
* JetBrains Mono Nerd Font

The Nerd Font is downloaded automatically and installed locally at:

```text
~/.local/share/fonts/JetBrainsMono
```

The font cache is refreshed automatically after installation.

This ensures that the icons used throughout the rice display correctly on a fresh installation.

---

## Wallpaper

The repository contains the default wallpaper at:

```text
wallpaper/wallpaper.png
```

During installation, it is copied to:

```text
~/Pictures/wallpaper/wallpaper.png
```

The Hyprland Lua configuration starts `awww` and loads the wallpaper from the user's home directory.

This means the configuration does **not** contain a hardcoded username or home directory.

The wallpaper is managed by **awww** rather than `hyprpaper`.

---

## Configuration Structure

The repository mirrors the configuration directories used by the desktop environment:

```text
dotfiles/
├── .config/
│   ├── hypr/
│   ├── kitty/
│   ├── rofi/
│   ├── swaync/
│   └── waybar/
├── wallpaper/
│   └── wallpaper.png
├── install.sh
└── README.md
```

The installer creates symbolic links such as:

```text
~/.config/hypr    -> ~/dotfiles/.config/hypr
~/.config/kitty   -> ~/dotfiles/.config/kitty
~/.config/rofi    -> ~/dotfiles/.config/rofi
~/.config/swaync  -> ~/dotfiles/.config/swaync
~/.config/waybar  -> ~/dotfiles/.config/waybar
```

Changes made inside the repository therefore immediately apply to the live configuration.

---

## Automatic Backups

Before creating configuration symlinks, the installer checks for existing configuration directories.

If an existing configuration is found, it is moved into a timestamped backup directory:

```text
~/.config/dotfiles_backup_YYYYMMDD_HHMMSS
```

For example:

```text
~/.config/dotfiles_backup_20261004_194500
```

This prevents the installer from overwriting an existing configuration.

---

## Audio Controls

If Flatpak is available, the installer attempts to install:

```text
com.saivert.pwvucontrol
```

This provides a graphical PipeWire/PulseAudio volume mixer for controlling applications and audio devices.

If Flatpak is unavailable or the installation fails, the rest of the setup continues.

---

## Desktop Keybindings

The system modifier key is mapped to the **SUPER** key (Windows key).

| Key Combination       | Action                          |
| --------------------- | ------------------------------- |
| `SUPER + RETURN`      | Launch Kitty terminal           |
| `SUPER + SHIFT + Q`   | Close active window             |
| `SUPER + D`           | Open Rofi application launcher  |
| `SUPER + E`           | Open Dolphin file manager       |
| `SUPER + F`           | Toggle floating window          |
| `SUPER + R`           | Reload Waybar                   |
| `SUPER + L`           | Lock/session utilities          |
| `SUPER + Left`        | Move focus left                 |
| `SUPER + Right`       | Move focus right                |
| `SUPER + Up`          | Move focus up                   |
| `SUPER + Down`        | Move focus down                 |
| `SUPER + 1–0`         | Switch workspace                |
| `SUPER + SHIFT + 1–0` | Move active window to workspace |

---

## Wallpaper Management

The desktop uses **awww** to manage wallpapers.

The Hyprland startup configuration launches the wallpaper daemon and loads:

```text
~/Pictures/wallpaper/wallpaper.png
```

To manually change the wallpaper:

```bash
awww img ~/Pictures/wallpaper/wallpaper.png
```

The `awww` daemon must be running before issuing wallpaper commands.

---

## Updating the Rice

Because the configuration directories are symbolic links to the repository, updating the repository automatically updates the configuration.

From the repository:

```bash
cd ~/dotfiles
git pull
```

Then reload Hyprland if necessary.

For example:

```bash
hyprctl reload
```

---

## Repository

GitHub:

https://github.com/jonathan-joubert/dotfiles

---

## Screenshots

<img width="2560" height="1440" alt="3" src="https://github.com/user-attachments/assets/c3aef272-6125-4ad9-bd13-900c9723240d" />

<img width="2560" height="1440" alt="2" src="https://github.com/user-attachments/assets/ae390890-2913-4e0c-be47-ba0a871a4210" />

<img width="2559" height="1439" alt="1" src="https://github.com/user-attachments/assets/20ddd55f-02af-446d-bcfc-ce9178ce5d44" />
