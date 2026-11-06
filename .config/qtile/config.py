# =============================================================================
# HyprFrost Qtile Configuration (Wayland / X11)
# Fully matched to Hyprland + Jacob Shell (Tokyo Night Theme)
# =============================================================================

import os
import subprocess
from libqtile import hook, layout, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# ----------------------------
# ---- MODIFIER & APPS ----
# ----------------------------
mod = "mod4"  # Super / Windows key
terminal = "kitty"
file_manager = "thunar"

# -----------------------------
# ---- KEYBINDINGS (HYPRLAND PARITY) ----
# -----------------------------
keys = [
    # Core Application Binds
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch Kitty Terminal"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch Thunar File Manager"),
    Key([mod], "c", lazy.window.kill(), desc="Close focused window"),
    Key([mod], "d", lazy.spawn("discord"), desc="Launch Discord"),

    # Window State & Tiling
    Key([mod], "v", lazy.window.toggle_floating(), desc="Toggle floating window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "Tab", lazy.next_screen(), desc="Focus next monitor"),

    # Layout Controls
    Key([mod], "j", lazy.layout.toggle_split(), desc="Toggle split mode (Bsp/Columns)"),
    Key([mod, "control"], "space", lazy.next_layout(), desc="Cycle through layouts"),

    # Move Focus (Arrow keys matching Hyprland)
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),

    # Move Focus (Vim keys)
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),

    # Shuffle Windows
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),

    # Resize Windows
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset window sizes"),

    # Jacob Shell Integrations (Option A: Desktop Shell)
    Key([mod], "space", lazy.spawn("jacob-shell toggle launcher"), desc="Toggle App Launcher"),
    Key([mod], "r", lazy.spawn("jacob-shell toggle launcher"), desc="Toggle App Launcher"),
    Key([mod], "k", lazy.spawn("jacob-shell toggle keybinds"), desc="Toggle Keybinds Sheet"),
    Key([mod], "q", lazy.spawn("jacob-shell toggle power"), desc="Toggle Power Menu"),
    Key([mod], "n", lazy.spawn("jacob-shell toggle notifications"), desc="Toggle Notification Center"),
    Key([mod], "m", lazy.spawn("jacob-shell toggle media"), desc="Toggle Media Controls"),
    Key([mod, "shift"], "v", lazy.spawn("jacob-shell toggle clipboard"), desc="Toggle Clipboard History"),
    Key([mod], "l", lazy.spawn("jacob-shell toggle calendar"), desc="Toggle Calendar / Clock"),
    Key([mod], "i", lazy.spawn("jacob-shell toggle controlcenter"), desc="Toggle Control Center"),

    # Volume & Media Keys via jacob-shell IPC
    Key([], "XF86AudioRaiseVolume", lazy.spawn("jacob-shell volume up"), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("jacob-shell volume down"), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn("jacob-shell volume mute"), desc="Mute volume"),
    Key([mod], "equal", lazy.spawn("jacob-shell volume up"), desc="Volume up"),
    Key([mod], "minus", lazy.spawn("jacob-shell volume down"), desc="Volume down"),
    Key([mod], "BackSpace", lazy.spawn("jacob-shell volume mute"), desc="Mute volume"),

    # Screenshot Utility (matching hypr-screenshot)
    Key([], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area"), desc="Snip area"),
    Key(["shift"], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot full"), desc="Full screenshot"),
    Key([mod], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot window"), desc="Window screenshot"),
    Key([mod, "shift"], "s", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area"), desc="Snip area"),

    # Qtile Session Management
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload Qtile Configuration"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown / Exit Qtile"),
]

# ----------------------------------------
# ---- WORKSPACES / GROUPS (1-10) ----
# ----------------------------------------
# Groups 1-5 for HDMI-A-1, Groups 6-10 for DP-1
groups = [Group(str(i), label=str(i)) for i in range(1, 11)]

for i in groups:
    key_name = "0" if i.name == "10" else i.name
    keys.extend([
        Key([mod], key_name, lazy.group[i.name].toscreen(), desc=f"Switch to workspace {i.name}"),
        Key([mod, "shift"], key_name, lazy.window.togroup(i.name, switch_group=False),
            desc=f"Move focused window to workspace {i.name}"),
    ])

# ---------------------------------------
# ---- LAYOUTS & TOKYO NIGHT STYLING ----
# ---------------------------------------
layout_theme = {
    "border_width": 2,
    "margin": 5,
    "border_focus": "#7aa2f7",          # Tokyo Night vibrant blue
    "border_normal": "#3b4261",         # Tokyo Night dark border
}

layouts = [
    layout.Bsp(**layout_theme, border_on_single=True, fair=False),
    layout.Columns(**layout_theme, border_focus_stack=["#bb9af7", "#7aa2f7"], border_on_single=True),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
]

# ------------------------------------------
# ---- SCREENS & OPTION A (JACOB SHELL) ----
# ------------------------------------------
# jacob-shell manages topbar and bottom dock as gtk-layer-shell exclusive surfaces.
screens = [
    Screen(),  # Primary Monitor (HDMI-A-1)
    Screen(),  # Secondary Monitor (DP-1)
]

# ----------------------------
# ---- MOUSE INTERACTIONS ----
# ----------------------------
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# ------------------------
# ---- FLOATING RULES ----
# ------------------------
floating_layout = layout.Floating(
    border_width=2,
    border_focus="#7aa2f7",
    border_normal="#3b4261",
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
        Match(wm_class="swappy"),
        Match(wm_class="hypr-settings"),
        Match(wm_class="hyprland-run"),
        Match(title="Welcome to JacobOS"),
        Match(title="Missing Packages Detected"),
    ],
)

# ---------------------------
# ---- WAYLAND INPUT RULES --
# ---------------------------
try:
    from libqtile.backend.wayland import InputConfig
    wl_input_rules = {
        "type:keyboard": InputConfig(kb_layout="us"),
        "type:touchpad": InputConfig(natural_scroll=False, tap=True),
        "*": InputConfig(natural_scroll=False),
    }
except ImportError:
    wl_input_rules = None

# -------------------
# ---- AUTOSTART ----
# -------------------
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    # Session Environment
    subprocess.Popen(["dbus-update-activation-environment", "--systemd", "WAYLAND_DISPLAY", "XDG_CURRENT_DESKTOP"])
    subprocess.Popen(["gnome-keyring-daemon", "--start", "--components=secrets"])
    subprocess.Popen(["nm-applet"])

    # Polkit Agent
    polkit = "/usr/lib/hyprpolkitagent/hyprpolkitagent"
    if os.path.exists(polkit):
        subprocess.Popen([polkit])

    # Clipboard Daemon
    subprocess.Popen(["wl-paste", "--type", "text", "--watch", "cliphist", "store"])

    # Wallpaper Daemon (awww)
    subprocess.Popen(["awww-daemon"])
    subprocess.Popen(["sh", "-c", "sleep 0.5 && (awww restore || awww img ~/Pictures/Wallpapers/default.png)"])

    # Jacob Shell (Top Bar + Bottom Dock + Notification Daemon + Panels)
    jacob_shell = os.path.join(home, ".local/bin/jacob-shell")
    if os.path.exists(jacob_shell) and os.access(jacob_shell, os.X_OK):
        subprocess.Popen([jacob_shell])
    elif os.path.exists("/usr/local/bin/jacob-shell"):
        subprocess.Popen(["/usr/local/bin/jacob-shell"])

    # Dark Theme Precedence
    subprocess.Popen(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", "prefer-dark"])
    subprocess.Popen(["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", "Tokyonight-Dark"])


# --------------------------
# ---- GENERAL BEHAVIOR ----
# --------------------------
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"
