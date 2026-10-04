# Minimalist Black & Red Hyprland Rice

A minimalist black and red Hyprland desktop configuration for Fedora.

This rice uses a Lua-based Hyprland configuration together with Waybar, SwayNC, Rofi-Wayland, Kitty and `awww`.

The repository is designed to be installed using the included `install.sh` script.

---

## Features

- Hyprland
- Lua-based Hyprland configuration
- Waybar
- SwayNC
- Rofi-Wayland
- Kitty
- Dolphin
- `awww` wallpaper daemon
- JetBrains Mono
- JetBrains Mono Nerd Font
- `pwvucontrol`
- Brightness controls
- Media controls
- Custom Waybar scripts
- Custom Rofi launchers
- Automatic wallpaper installation
- Automatic configuration backups
- Repository-based configuration symlinks

---

## Requirements

This rice is designed for:

- Fedora Linux
- Hyprland
- A Wayland session

The installer enables the following COPRs:

- `nett00n/hyprland`
- `ackerman/nexus`

These provide the Hyprland ecosystem packages and `awww` used by the rice.

---

## Installation

Clone or download this repository:

```bash
git clone <repository-url>
cd dotfiles
````

Make the installer executable:

```bash
chmod +x install.sh
```

Run it as your normal user:

```bash
./install.sh
```

### Do not run the installer as root

Run:

```bash
./install.sh
```

Do **not** run:

```bash
sudo ./install.sh
```

The installer will use `sudo` itself when elevated privileges are required.

---

## What the installer does

The installer performs the following steps:

1. Detects the repository location.
2. Verifies the required configuration directories.
3. Verifies the included wallpaper.
4. Installs required Fedora dependencies.
5. Detects existing configurations.
6. Safely backs up existing configurations.
7. Creates configuration symlinks.
8. Enables the required COPRs.
9. Installs the required system packages.
10. Installs JetBrains Mono Nerd Font if necessary.
11. Copies the wallpaper to the user's Pictures directory.
12. Applies executable permissions to included scripts.
13. Installs `pwvucontrol` through Flatpak.
14. Reloads Hyprland when an active Hyprland session is detected.
15. Refreshes Waybar and SwayNC when they are already running.
16. Starts `awww` and applies the wallpaper when possible.

---

## Configuration Symlinks

The installer creates the following symlinks:

```text
~/.config/hypr    -> repository/.config/hypr
~/.config/waybar  -> repository/.config/waybar
~/.config/swaync  -> repository/.config/swaync
~/.config/rofi    -> repository/.config/rofi
~/.config/kitty   -> repository/.config/kitty
```

This means the live configuration is directly connected to the Git repository.

For example:

```text
~/.config/hypr
        ↓
repository/.config/hypr
```

Changes made to the repository are therefore reflected in the live configuration.

---

## Important: Do Not Move the Repository

Because the configuration directories are symlinks, **do not rename or move the repository after running the installer**.

For example, if the installer creates:

```text
/home/user/Downloads/dotfiles-main/dotfiles-main
```

and the repository is later renamed or moved, the symlinks will point to the old location.

If you need to move the repository, simply run the installer again from its new location.

The installer will back up the existing configuration links and recreate them using the new repository path.

---

## Existing Configuration Backups

The installer does not simply delete an existing configuration.

Before replacing an existing configuration, it creates a timestamped backup:

```text
~/.config/dotfiles_backup_YYYYMMDD_HHMMSS/
```

For example:

```text
~/.config/dotfiles_backup_20261004_203000/
```

Existing configurations such as:

```text
~/.config/hypr
~/.config/waybar
~/.config/swaync
~/.config/rofi
~/.config/kitty
```

are moved into the backup directory before the new symlinks are created.

This allows the previous configuration to be recovered if necessary.

The installer can also handle existing configurations that require elevated permissions.

---

## Wallpaper

The repository contains:

```text
wallpaper/wallpaper.png
```

The installer copies it to:

```text
~/Pictures/wallpaper/wallpaper.png
```

The Hyprland configuration uses `awww` rather than `hyprpaper`.

The wallpaper can also be manually applied with:

```bash
awww img ~/Pictures/wallpaper/wallpaper.png
```

---

## awww

This rice uses [`awww`](https://github.com/awww-rs/awww) for wallpapers.

The Hyprland startup configuration starts the daemon and applies:

```text
~/Pictures/wallpaper/wallpaper.png
```

If `awww-daemon` is already running, the installer will reuse it rather than starting another daemon.

---

## Configuration Structure

```text
.
├── .config/
│   ├── hypr/
│   │   ├── hyprland.lua
│   │   └── ...
│   │
│   ├── kitty/
│   │   ├── kitty.conf
│   │   ├── custom.conf
│   │   └── ...
│   │
│   ├── rofi/
│   │   └── ...
│   │
│   ├── swaync/
│   │   └── ...
│   │
│   └── waybar/
│       ├── config.jsonc
│       ├── style.css
│       └── scripts/
│
├── wallpaper/
│   └── wallpaper.png
│
├── install.sh
└── README.md
```

---

## Hyprland

The Hyprland configuration uses the Lua API provided by modern Hyprland versions.

The main configuration is:

```text
.config/hypr/hyprland.lua
```

The configuration handles:

* Keybinds
* Workspaces
* Window rules
* Animations
* Startup applications
* Wallpaper startup
* Waybar startup
* SwayNC startup
* General Hyprland behavior

---

## Waybar

Waybar configuration is located at:

```text
.config/waybar/
```

The directory contains:

```text
config.jsonc
style.css
colours/
scripts/
```

The included scripts are automatically given executable permissions by the installer.

---

## SwayNC

SwayNC configuration is located at:

```text
.config/swaync/
```

It provides the notification daemon and notification center used by the rice.

---

## Rofi

Rofi-Wayland configuration is located at:

```text
.config/rofi/
```

Custom launcher scripts are included under:

```text
.config/rofi/launchers/
```

---

## Kitty

Kitty configuration is located at:

```text
.config/kitty/
```

The configuration includes the rice's terminal appearance and color configuration.

`custom.conf` is intentionally available as a local override file.

Personal Kitty settings can therefore be placed in:

```text
~/.config/kitty/custom.conf
```

without modifying the main configuration.

---

## Updating the Rice

Because the configuration directories are symlinked to the repository, updating the Git repository updates the source configuration directly.

From the repository:

```bash
git pull
```

Then reload Hyprland:

```bash
hyprctl reload
```

If Waybar or another component does not automatically reload its configuration, restart that component.

For example:

```bash
pkill waybar
waybar &
```

The installer can also be run again if required:

```bash
./install.sh
```

Existing configurations will be backed up before being replaced.

---

## Applying the Wallpaper Manually

```bash
awww img ~/Pictures/wallpaper/wallpaper.png
```

If the daemon is not running:

```bash
awww-daemon &
```

Then:

```bash
awww img ~/Pictures/wallpaper/wallpaper.png
```

---

## Troubleshooting

### Check Hyprland configuration

```bash
hyprctl reload
```

If there is a configuration error, check:

```bash
hyprctl reload
```

for the reported error.

---

### Check configuration symlinks

Run:

```bash
ls -ld ~/.config/hypr
ls -ld ~/.config/waybar
ls -ld ~/.config/swaync
ls -ld ~/.config/rofi
ls -ld ~/.config/kitty
```

Each should point into the repository.

You can also resolve them with:

```bash
readlink -f ~/.config/hypr
readlink -f ~/.config/waybar
readlink -f ~/.config/swaync
readlink -f ~/.config/rofi
readlink -f ~/.config/kitty
```

---

### Check Waybar

Run:

```bash
waybar
```

If Waybar is already running:

```bash
pkill waybar
waybar &
```

---

### Check SwayNC

Run:

```bash
swaync
```

If it is already running:

```bash
pkill swaync
swaync &
```

---

### Check awww

Check whether the daemon is running:

```bash
pgrep -a awww
```

Start it if necessary:

```bash
awww-daemon &
```

Then apply the wallpaper:

```bash
awww img ~/Pictures/wallpaper/wallpaper.png
```

---

### Check the current Hyprland session

```bash
echo "$HYPRLAND_INSTANCE_SIGNATURE"
```

If this returns a value, you are running inside a Hyprland session.

---

## Reinstalling

The installer is safe to run again.

```bash
./install.sh
```

Existing configurations are backed up before the new repository symlinks are created.

This is useful after:

* Moving the repository
* Changing the repository location
* Recovering from broken symlinks
* Reinstalling the rice
* Updating the installation dependencies

---

## Removing the Rice

The installer does not provide an automatic uninstall command because the user's previous configurations may need to be restored selectively.

To remove the repository symlinks manually:

```bash
rm ~/.config/hypr
rm ~/.config/waybar
rm ~/.config/swaync
rm ~/.config/rofi
rm ~/.config/kitty
```

Then restore your previous configuration from the relevant:

```text
~/.config/dotfiles_backup_YYYYMMDD_HHMMSS/
```

backup directory.

---

## Notes

This rice is designed around:

* Fedora
* Hyprland
* Wayland
* AMD/NVIDIA-compatible Wayland applications
* A minimalist black and red aesthetic

The configuration is intended to remain lightweight while providing the functionality expected from a complete daily-driver Hyprland desktop.

Enjoy.
