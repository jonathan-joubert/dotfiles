# Dotfiles

A black and crimson accented desktop environment running on **Hyprland**.

---

## What the Installer Does

The `install.sh` script safely automates your environment setup:

* **Automatic Backups:** Detects pre-existing configurations inside `~/.config/` and moves them to a timestamped backup folder.
* **Symbolic Linking:** Generates symlinks from this repository into your local machine environment.
* **Permission Mapping:** Automatically applies executable permissions (`chmod +x`) to application launchers.

---

## System Components

* **Window Manager:** [Hyprland (Lua configuration engine)](https://hypr.land/)
* **Status Panel:** [Waybar](https://github.com/Alexays/Waybar)
* **Notifications Menu:** [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)
* **Application Launcher:** [Rofi-Wayland](https://github.com/marvinhacker/rofi-wayland)
* **Terminal Emulator:** [Kitty](https://sw.kovidgoyal.net/kitty/)

---

## Installation

### 1. Install Dependencies

Ensure your system has the required core utilities, fonts, and application engines installed:

```bash
# Example for Fedora Workstation
sudo dnf install hyprland waybar swaync rofi-wayland kitty dolphin brightnessctl playerctl jetbrains-mono-fonts

# Audio Mixer Panel
flatpak install flathub com.saivert.pwvucontrol
```

### 2. Clone

Execute these commands step-by-step to clone the repository, grant executable permissions, and launch the installer:

```bash
# Clone the repository
git clone https://github.com/jonathan-joubert/dotfiles.git ~/dotfiles

# Navigate into the workspace
cd ~/dotfiles

# Make the installer executable
chmod +x install.sh

# Run the deployment script
./install.sh
```

---

## Desktop Keybindings

The system modifier key is mapped to the SUPER (Windows) key.

| Key Combination                  | Action                                           |
| -------------------------------- | ------------------------------------------------ |
| SUPER + RETURN                   | Launch Terminal (kitty)                          |
| SUPER + SHIFT + Q                | Close Active Window Target                       |
| SUPER + D                        | Open Rofi Application Launcher Menu              |
| SUPER + E                        | Open File Manager Launcher (dolphin)             |
| SUPER + F                        | Toggle Window Floating Layout State              |
| SUPER + R                        | Hot-Reload Waybar Panels and layouts dynamically |
| SUPER + L                        | Lock Session / Run System Shutdown Utilities     |
| SUPER + Left / Right / Up / Down | Shift Focused Window Focus Direction             |
| SUPER + [1-0]                    | Switch Active Desktop Workspace View             |
| SUPER + SHIFT + [1-0]            | Move Active Window Target to Selected Workspace  |

---

## Screenshots
<img width="2560" height="1440" alt="3" src="https://github.com/user-attachments/assets/c3aef272-6125-4ad9-bd13-900c972324a0" />
<img width="2560" height="1440" alt="2" src="https://github.com/user-attachments/assets/ae390890-2913-4e0c-be47-ba0a871a4210" />
<img width="2559" height="1439" alt="1" src="https://github.com/user-attachments/assets/20ddd55f-02af-446d-bcfc-ce9178ce5d44" />
