# System Settings (KDE System Settings Clone for Hyprland)

A complete 1-to-1 recreation of **KDE Plasma 6 System Settings** built with **Qt 6, C++, and QML**, engineered specifically for Arch Linux and **Hyprland**.

---

## Complete Category Layout

### 1. CONNECTIVITY
* **Bluetooth** (`BluetoothPage.qml`):
  * Controller power and discoverability toggle.
  * Paired devices list with battery indicators (`🔋 85%`), status pills, disconnect, and forget.
  * Live Bluetooth spectrum scanning and one-click pairing.
* **Wi-Fi & Connections** (`NetworkPage.qml`):
  * Wireless radio toggle (`nmcli`).
  * Active network connection status & IP.
  * Available Wi-Fi networks with signal bars and WPA security dialog.

### 2. HARDWARE
* **Display and Monitor** (`DisplaysPage.qml`):
  * Detects connected displays (`hyprctl monitors`).
  * Resolution, refresh rate, and global scaling factor selector (1.00x, 1.25x, 1.50x, 1.75x, 2.00x).
* **Audio** (`AudioPage.qml`):
  * PipeWire / WirePlumber master volume slider and mute toggle.
  * Microphone input volume slider and mute toggle.
  * Speaker test chime.
* **Power Management** (`PowerPage.qml`):
  * Active energy profile (`powerprofilesctl`): Power Saver, Balanced, Performance.
  * Battery charge level and AC/battery power state.

### 3. PERSONALIZATION & APPEARANCE
* **Colors & Themes** (`ThemesPage.qml`):
  * Dark Mode / Light Mode toggle (`prefer-dark`).
  * GTK application theme selector (`Tokyonight-Dark`, etc.).
  * System icon theme selector (`Papirus-Dark`, `Papirus-Light`, `Adwaita`).
  * Text font scaling factor slider.
* **Window Management & Look** (`AppearancePage.qml`):
  * Inner and outer window gaps (`general:gaps_in`, `gaps_out`).
  * Border thickness (`general:border_size`) and corner rounding (`decoration:rounding`).
  * Background frosted glass blur, window drop shadows, and animations.
* **Wallpaper & Background** (`WallpaperPage.qml`):
  * Visual image grid from `~/Pictures/Wallpapers/`.
  * One-click wallpaper setter via `awww`.

### 4. WORKSPACE & INPUT
* **Mouse & Touchpad** (`InputPage.qml`):
  * Pointer sensitivity slider (`input:sensitivity`).
  * Natural scrolling toggle (`input:touchpad:natural_scroll`).
  * Tap to click toggle (`input:touchpad:tap-to-click`).
  * Keyboard repeat rate slider (`input:repeat_rate`).
* **Shortcuts & Hotkeys** (`ShortcutsPage.qml`):
  * Searchable list of all active Hyprland hotkeys parsed from `~/.config/hypr/modules/binds.lua`.
* **Default Applications** (`DefaultAppsPage.qml`):
  * Default web browser handler (`xdg-settings`).
  * Default file manager handler (`xdg-mime`).
  * Terminal emulator handler.

### 5. SYSTEM
* **About this System** (`AboutPage.qml`):
  * KDE-style hardware specification card (OS, Kernel, Compositor, CPU, RAM, Hostname, Battery).

---

## Shortcuts & Launching

* **Hyprland Shortcut**: <kbd>Super</kbd> + <kbd>I</kbd>
* **Dock**: Click the **Gear** icon on the bottom dock
* **Terminal**: Run `hypr-settings`
