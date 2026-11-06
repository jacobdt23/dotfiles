# =============================================================================
# HyprFrost Pure Python Qtile Configuration
# 100% Native Python (Zero C/C++ helper daemon dependencies)
# Universal support: Wayland & Xorg
# Tokyo Night Palette: Matches Hyprland aesthetic
# =============================================================================

import os
import subprocess
from libqtile import bar, hook, layout, widget
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
    "bg": "#1a1b26",          # Dark background
    "bg_alt": "#24283b",      # Slightly lighter surface
    "fg": "#c0caf5",          # Default text
    "fg_dim": "#565f89",      # Dim text
    "blue": "#7aa2f7",        # Tokyo Night blue (primary active)
    "purple": "#bb9af7",      # Purple accent
    "cyan": "#7dcfff",        # Cyan accent
    "red": "#f7768e",         # Red / Warning
    "yellow": "#e0af68",      # Yellow
    "green": "#9ece6a",       # Green
    "border_active": "#7aa2f7",
    "border_inactive": "#3b4261",
}

# ----------------------------------------
# ---- WORKSPACES / GROUPS (1-10) --------
# ----------------------------------------
# Screen 0 (HDMI-A-1): Workspaces 1-5
# Screen 1 (DP-1): Workspaces 6-10
groups = [Group(str(i), label=str(i)) for i in range(1, 11)]

def go_to_group(name):
    def _inner(qtile_inst):
        idx = int(name)
        target_screen = 0 if idx <= 5 else 1
        if len(qtile_inst.screens) > target_screen:
            qtile_inst.to_screen(target_screen)
        qtile_inst.groups_map[name].toscreen()
    return _inner

# -----------------------------
# ---- KEYBINDINGS ------------
# -----------------------------
keys = [
    # Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal (Kitty)"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch file manager (Thunar)"),
    Key([mod], "c", lazy.window.kill(), desc="Close focused window"),
    Key([mod], "d", lazy.spawn("discord"), desc="Launch Discord"),
    Key([mod], "space", lazy.spawncmd(), desc="Prompt launcher in topbar"),

    # Window State
    Key([mod], "v", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "Tab", lazy.next_screen(), desc="Switch focus to next monitor"),

    # Tiling & Split Mode
    Key([mod], "j", lazy.layout.toggle_split(), desc="Toggle column split"),
    Key([mod, "control"], "space", lazy.next_layout(), desc="Cycle layouts"),

    # Focus Movement (Matching Hyprland arrows)
    Key([mod], "Left", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),

    # Window Shuffle
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Shuffle window left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Shuffle window right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Shuffle window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Shuffle window up"),

    # Window Resize
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset window sizes"),

    # Audio Controls (wpctl / PipeWire in pure shell execution)
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), desc="Vol +5%"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc="Vol -5%"),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Toggle mute"),
    Key([mod], "equal", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), desc="Vol +5%"),
    Key([mod], "minus", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc="Vol -5%"),
    Key([mod], "BackSpace", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Toggle mute"),

    # Screenshots
    Key([], "Print", lazy.spawn("grim -g \"$(slurp)\" - | swappy -f -"), desc="Area screenshot"),
    Key(["shift"], "Print", lazy.spawn("grim - | swappy -f -"), desc="Full screenshot"),
    Key([mod, "shift"], "s", lazy.spawn("grim -g \"$(slurp)\" - | swappy -f -"), desc="Area screenshot"),

    # Session Control
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload Qtile Configuration"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Exit / Logout of Qtile"),
]

# Map 1-10 to groups
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
    layout.Columns(**layout_theme, border_focus_stack=[colors["purple"], colors["blue"]], border_on_single=True),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
]

# ------------------------------------------------
# ---- PURE PYTHON STATUS BAR WIDGETS ------------
# ------------------------------------------------
def build_top_bar(screen_index):
    # Primary Screen (HDMI-A-1) manages 1-5; Secondary (DP-1) manages 6-10
    visible_groups = [str(n) for n in (range(1, 6) if screen_index == 0 else range(6, 11))]

    widgets = [
        # Distro Logo / Prompt
        widget.TextBox(
            text=" 󰣇 HyprFrost ",
            foreground=colors["blue"],
            background=colors["bg_alt"],
            font="JetBrainsMono Nerd Font",
            fontsize=13,
            padding=8,
        ),
        widget.Sep(linewidth=0, padding=6, background=colors["bg"]),

        # Clickable Workspaces
        widget.GroupBox(
            font="JetBrainsMono Nerd Font",
            fontsize=12,
            margin_y=3,
            margin_x=0,
            padding_y=4,
            padding_x=8,
            borderwidth=2,
            active=colors["blue"],
            inactive=colors["fg_dim"],
            rounded=True,
            highlight_color=[colors["bg_alt"], colors["bg_alt"]],
            highlight_method="block",
            this_current_screen_border=colors["border_active"],
            block_highlight_text_color=colors["blue"],
            visible_groups=visible_groups,
            disable_drag=True,
        ),
        widget.Sep(linewidth=0, padding=10, background=colors["bg"]),

        # Run Command Prompt (Super + Space)
        widget.Prompt(
            font="JetBrainsMono Nerd Font",
            fontsize=12,
            foreground=colors["cyan"],
            cursor_color=colors["cyan"],
            prompt="Run: ",
        ),

        # Active Window Name
        widget.WindowName(
            font="JetBrainsMono Nerd Font",
            fontsize=11,
            foreground=colors["fg"],
            max_chars=40,
            padding=6,
        ),
    ]

    # Additional system widgets on Primary Screen
    if screen_index == 0:
        widgets.extend([
            # CPU
            widget.TextBox(text="󰻠", foreground=colors["blue"], font="JetBrainsMono Nerd Font", fontsize=13),
            widget.CPU(
                format="{load_percent}%",
                foreground=colors["fg"],
                font="JetBrainsMono Nerd Font",
                fontsize=11,
                padding=6,
            ),
            widget.Sep(linewidth=0, padding=8),

            # RAM
            widget.TextBox(text="󰍛", foreground=colors["purple"], font="JetBrainsMono Nerd Font", fontsize=13),
            widget.Memory(
                format="{MemPercent}%",
                foreground=colors["fg"],
                font="JetBrainsMono Nerd Font",
                fontsize=11,
                padding=6,
            ),
            widget.Sep(linewidth=0, padding=8),

            # Volume
            widget.TextBox(text="", foreground=colors["green"], font="JetBrainsMono Nerd Font", fontsize=13),
            widget.Volume(
                foreground=colors["fg"],
                font="JetBrainsMono Nerd Font",
                fontsize=11,
                padding=6,
            ),
            widget.Sep(linewidth=0, padding=8),

            # System Tray
            widget.Systray(padding=6),
            widget.Sep(linewidth=0, padding=8),
        ])

    # Clock & Quick Logout on both screens
    widgets.extend([
        widget.TextBox(text="󰥔", foreground=colors["cyan"], font="JetBrainsMono Nerd Font", fontsize=13),
        widget.Clock(
            format="%a %b %d  %I:%M %p",
            foreground=colors["fg"],
            font="JetBrainsMono Nerd Font",
            fontsize=11,
            padding=6,
        ),
        widget.Sep(linewidth=0, padding=8),
        widget.QuickExit(
            default_text=" 󰐥 ",
            countdown_format="[{}]",
            foreground=colors["red"],
            font="JetBrainsMono Nerd Font",
            fontsize=13,
            padding=6,
        ),
    ])

    return bar.Bar(
        widgets,
        30,
        background=colors["bg"],
        margin=[4, 6, 2, 6],  # Top floating gap
        opacity=0.92,
    )

# ------------------------------------------------
# ---- SCREENS & BUILT-IN WALLPAPER ENGINE -------
# ------------------------------------------------
# Drawing wallpaper directly via Qtile ensures SDDM never bleeds through!
screens = [
    Screen(
        wallpaper=wallpaper_path if os.path.isfile(wallpaper_path) else None,
        wallpaper_mode="fill",
        top=build_top_bar(0),
    ),
    Screen(
        wallpaper=wallpaper_path if os.path.isfile(wallpaper_path) else None,
        wallpaper_mode="fill",
        top=build_top_bar(1),
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
    # Only standard system daemons (no C++ hyprland daemons)
    subprocess.Popen(["nm-applet"])
    subprocess.Popen(["wl-paste", "--type", "text", "--watch", "cliphist", "store"])

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
