# =============================================================================
# HyprFrost Qtile Configuration (Wayland)
# Fully matched to Hyprland + Jacob Shell (Tokyo Night Theme)
# =============================================================================

import os
import subprocess
from libqtile import hook, layout
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# ---------------------------------------------
# ---- WAYLAND & NVIDIA OPTIMIZATIONS ---------
# ---------------------------------------------
os.environ["WLR_NO_HARDWARE_CURSORS"] = "1"
os.environ["XCURSOR_SIZE"] = "24"
os.environ["QT_QPA_PLATFORM"] = "wayland;xcb"
os.environ["GDK_BACKEND"] = "wayland,x11,*"

# ----------------------------
# ---- MODIFIER & APPS -------
# ----------------------------
mod = "mod4"  # Super / Windows key
terminal = "kitty"
file_manager = "thunar"
wallpaper_path = os.path.expanduser("~/Pictures/Wallpapers/default.png")

# ----------------------------
# ---- TOKYO NIGHT PALETTE ---
# ----------------------------
colors = {
    "border_active": "#7aa2f7",    # Tokyo Night blue
    "border_inactive": "#3b4261",  # Tokyo Night dark border
    "purple": "#bb9af7",
}

# -----------------------------
# ---- KEYBINDINGS ------------
# -----------------------------
keys = [
    # App Launcher (Super tap via keyd, or Super + Space, Super + R, Super + D)
    Key([], "F24", lazy.spawn("jacob-shell toggle launcher"), desc="Launch App Launcher with Super tap"),
    Key([mod], "space", lazy.spawn("jacob-shell toggle launcher"), desc="Launch App Launcher with Super+Space"),
    Key([mod], "r", lazy.spawn("jacob-shell toggle launcher"), desc="Launch App Launcher with Super+R"),
    Key([mod], "d", lazy.spawn("jacob-shell toggle launcher"), desc="Launch App Launcher with Super+D"),

    # Core Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch Kitty Terminal"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch Thunar File Manager"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch Firefox Browser"),
    Key([mod], "c", lazy.window.kill(), desc="Close focused window"),

    # Window State
    Key([mod], "v", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "Tab", lazy.next_screen(), desc="Focus next monitor"),

    # Tiling Layout Controls
    Key([mod], "j", lazy.layout.toggle_split(), desc="Toggle split"),
    Key([mod, "control"], "space", lazy.next_layout(), desc="Cycle layout"),

    # Focus Movement (Matching Hyprland arrows)
    Key([mod], "Left", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),

    # Shuffle Windows
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Shuffle window left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Shuffle window right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Shuffle window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Shuffle window up"),

    # Resize Windows
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset window sizes"),

    # Jacob Shell Popups & Panels
    Key([mod], "k", lazy.spawn("jacob-shell toggle keybinds"), desc="Toggle Keybinds"),
    Key([mod], "q", lazy.spawn("jacob-shell toggle power"), desc="Toggle Power Menu"),
    Key([mod], "n", lazy.spawn("jacob-shell toggle notifications"), desc="Toggle Notifications"),
    Key([mod], "m", lazy.spawn("jacob-shell toggle media"), desc="Toggle Media"),
    Key([mod, "shift"], "v", lazy.spawn("jacob-shell toggle clipboard"), desc="Toggle Clipboard"),
    Key([mod], "l", lazy.spawn("jacob-shell toggle calendar"), desc="Toggle Calendar"),
    Key([mod], "i", lazy.spawn("jacob-shell toggle controlcenter"), desc="Toggle Control Center"),

    # Volume & Media Keys via jacob-shell IPC
    Key([], "XF86AudioRaiseVolume", lazy.spawn("jacob-shell volume up"), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("jacob-shell volume down"), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn("jacob-shell volume mute"), desc="Mute volume"),
    Key([mod], "equal", lazy.spawn("jacob-shell volume up"), desc="Volume up"),
    Key([mod], "minus", lazy.spawn("jacob-shell volume down"), desc="Volume down"),
    Key([mod], "BackSpace", lazy.spawn("jacob-shell volume mute"), desc="Mute volume"),

    # Screenshots (matching hypr-screenshot)
    Key([], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area"), desc="Snip area"),
    Key(["shift"], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot full"), desc="Full screenshot"),
    Key([mod], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot window"), desc="Window screenshot"),
    Key([mod, "shift"], "s", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area"), desc="Snip area"),

    # Session Management
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload Qtile Configuration"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Logout / Exit Qtile"),
]

# ----------------------------------------
# ---- WORKSPACES / GROUPS (1-10) --------
# ----------------------------------------
# Workspaces 1-5 mapped to Monitor 0 (HDMI-A-1)
# Workspaces 6-10 mapped to Monitor 1 (DP-1)
groups = [Group(str(i), label=str(i)) for i in range(1, 11)]

def go_to_group(name):
    def _inner(qtile_inst):
        idx = int(name)
        target_screen = 0 if idx <= 5 else 1
        if len(qtile_inst.screens) > target_screen:
            qtile_inst.to_screen(target_screen)
        qtile_inst.groups_map[name].toscreen()
    return _inner

for i in groups:
    key_name = "0" if i.name == "10" else i.name
    keys.extend([
        Key([mod], key_name, lazy.function(go_to_group(i.name)), desc=f"Switch to group {i.name}"),
        Key([mod, "shift"], key_name, lazy.window.togroup(i.name, switch_group=False),
            desc=f"Move window to group {i.name}"),
    ])

# ---------------------------------------
# ---- LAYOUTS (MATCHING HYPRLAND) ------
# ---------------------------------------
layout_theme = {
    "border_width": 2,
    "margin": 5,
    "border_focus": colors["border_active"],
    "border_normal": colors["border_inactive"],
}

layouts = [
    layout.Bsp(**layout_theme, border_on_single=True, fair=False),
    layout.Columns(**layout_theme, border_focus_stack=[colors["purple"], colors["border_active"]], border_on_single=True),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
]

# ------------------------------------------------
# ---- SCREENS & BUILT-IN WALLPAPER ENGINE -------
# ------------------------------------------------
# jacob-shell manages top bar and bottom dock as layer-shell surfaces.
# Qtile native wallpaper engine guarantees SDDM never bleeds through!
screens = [
    Screen(
        wallpaper=wallpaper_path if os.path.isfile(wallpaper_path) else None,
        wallpaper_mode="fill",
    ),
    Screen(
        wallpaper=wallpaper_path if os.path.isfile(wallpaper_path) else None,
        wallpaper_mode="fill",
    ),
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
    border_focus=colors["border_active"],
    border_normal=colors["border_inactive"],
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
    import time
    home = os.path.expanduser("~")

    # 1. Update systemd & D-Bus environment with full active session vars
    env_vars = ["WAYLAND_DISPLAY", "DISPLAY", "XDG_CURRENT_DESKTOP", "XDG_SESSION_TYPE"]
    export_args = [f"{v}={os.environ[v]}" for v in env_vars if v in os.environ]
    if export_args:
        subprocess.run(["dbus-update-activation-environment", "--systemd", *export_args], check=False)
        subprocess.run(["systemctl", "--user", "import-environment", *[v for v in env_vars if v in os.environ]], check=False)

    # 2. Keyring & Network Applet
    subprocess.Popen(["gnome-keyring-daemon", "--start", "--components=secrets"])
    subprocess.Popen(["nm-applet"])
    if os.environ.get("WAYLAND_DISPLAY"):
        subprocess.Popen(["wl-paste", "--type", "text", "--watch", "cliphist", "store"])

    # 3. Clean up and launch Jacob Shell reliably with replacement
    subprocess.run(["pkill", "-9", "-f", "jacob-shell"], check=False)
    time.sleep(0.3)
    sock = os.path.join(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"), "jacob-shell.sock")
    if os.path.exists(sock):
        try:
            os.unlink(sock)
        except OSError:
            pass

    jacob_shell = os.path.join(home, ".local/bin/jacob-shell")
    log_dir = os.path.expanduser("~/.local/share/qtile")
    os.makedirs(log_dir, exist_ok=True)
    log_out = open(os.path.join(log_dir, "jacob-shell.log"), "a")
    bin_target = jacob_shell if os.path.exists(jacob_shell) and os.access(jacob_shell, os.X_OK) else "/usr/local/bin/jacob-shell"
    if os.path.exists(bin_target):
        subprocess.Popen([bin_target, "--replace"], stdout=log_out, stderr=log_out)

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
