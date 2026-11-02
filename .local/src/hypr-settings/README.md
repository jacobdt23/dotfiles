# hypr-settings

A lightweight, fast, native C and Libadwaita / GTK4 Settings application engineered for Hyprland on Arch Linux.

## Features
- **Bluetooth**: Powered by BlueZ (`bluetoothctl`), full device discovery, scan, connect, disconnect, and pair/unpair.
- **Wi-Fi & Network**: Direct NetworkManager (`nmcli`) integration with SSID scanning, password prompts, and status.
- **Audio**: PipeWire (`wpctl`) volume controls, input/output device toggles, and test sound chiming.
- **Displays**: Hyprland monitor discovery (`hyprctl monitors -j`), resolution, refresh rate, and display scaling.
- **Appearance**: Live Hyprland styling adjustments: inner/outer gaps, border width, corner rounding, blur, shadows, and animations.
- **Input**: Mouse pointer sensitivity, natural scroll, touchpad tap-to-click, and keyboard repeat rates.
- **Power**: Power profiles (`powerprofilesctl`) and battery diagnostics.
- **About / System**: Real-time OS info, kernel version, CPU, GPU, memory, and Hyprland version.

## Building & Installing
```bash
make
make install
```
Installed to `~/.local/bin/hypr-settings` with a symlink to `~/.local/bin/jacob-control-center`.
Shortcut: <kbd>Super</kbd> + <kbd>I</kbd> via `jacob-shell toggle controlcenter`.
