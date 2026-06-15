# 🌑 Minimalist Black & Red 

A crisp, performance-focused, solid black and crimson accented desktop rice environment running on **Hyprland** using the modern **Lua configuration layer**. Designed for a clean, distraction-free appearance with consistent rounded layout elements and balanced spacing.

---

## 🛠 Featured System Components

* **Window Manager:** [Hyprland (Lua configuration engine)](https://hypr.land/)
* **Status Panel:** [Waybar](https://github.com/Alexays/Waybar) (Custom text-only interface with dynamic connection reporting)
* **Notifications Menu:** [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) (Redesigned solid pitch-black layout with pill buttons)
* **Application Launcher:** [Rofi-Wayland](https://github.com/marvinhacker/rofi-wayland)
* **Terminal Emulator:** Kitty
* **File Manager:** Dolphin

---

## ⌨ Core Keybindings & Shortcuts

The system modifier key is mapped cleanly to the `SUPER` (Windows) key. Key layout rules are configured as follows:

| Key Combination | Action |
| :--- | :--- |
| `SUPER` + `RETURN` | Launch Terminal (`kitty`) |
| `SUPER` + `SHIFT` + `Q` | Close Active Window Target |
| `SUPER` + `D` | Open Rofi Application Launcher Menu |
| `SUPER` + `E` | Open File Manager Launcher (`dolphin`) |
| `SUPER` + `F` | Toggle Window Floating Layout State |
| `SUPER` + `R` | **Hot-Reload Waybar Layout Styles dynamically** |
| `SUPER` + `L` | Lock Session / System Shutdown Menu Utilities |
| `SUPER` + `Left / Right / Up / Down` | Shift Window View Focus |
| `SUPER` + `[1-0]` | Switch Active Desktop Workspace Windows |
| `SUPER` + `SHIFT` + `[1-0]` | Send Selected Window Target to Workspace |

---

## 🚀 Installation & Safe Deployment

### 1. Install Essential Dependencies
Ensure your target package layer includes all base multimedia tools and fonts to handle key binds properly:

```bash
# Example for Fedora workstation setups
sudo dnf install hyprland waybar swaync rofi-wayland kitty dolphin brightnessctl playerctl jetbrains-mono-fonts
