# =============================================================================
# HyprFrost Native Qtile Configuration
# 100% Cross-Compatible, Self-Contained Native Python Desktop
# Matching Exact Jacob Shell Aesthetics (Tokyo Night Glass Floating Bars)
# =============================================================================

import os
import subprocess
from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# ---------------------------------------------
# ---- WAYLAND & ENVIRONMENT OPTIMIZATIONS ----
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
browser = "brave"
wallpaper_path = os.path.expanduser("~/Pictures/Wallpapers/default.png")

# -----------------------------------------------
# ---- TOKYO NIGHT FROSTED PALETTE --------------
# -----------------------------------------------
colors = {
    "bar_bg": "#141622",          # rgba(20, 22, 34) deep glass
    "bg_alt": "#1f2335",          # Slightly lighter pill surface
    "pill_bg": "#1a1b26",         # Standard pill container background
    "pill_border": "#292e42",     # Subtle dark pill border
    "fg": "#c0caf5",              # Primary text
    "fg_dim": "#565f89",          # Dim / muted text
    "blue": "#7aa2f7",            # Tokyo Night blue accent
    "purple": "#bb9af7",          # Purple accent
    "cyan": "#7dcfff",            # Cyan accent
    "green": "#9ece6a",           # Green accent
    "yellow": "#e0af68",          # Yellow
    "red": "#f7768e",             # Red / Warning
    "border_active": "#7aa2f7",
    "border_inactive": "#3b4261",
    "bar_border": "#3b4261",
}

# ----------------------------------------
# ---- WORKSPACES / GROUPS (1-10) --------
# ----------------------------------------
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
    # Application Launcher (Super tap via keyd F24, or Super+Space, Super+R, Super+D)
    Key([], "F24", lazy.spawn("rofi -show drun"), desc="Open Rofi app launcher with Super tap"),
    Key([mod], "space", lazy.spawn("rofi -show drun"), desc="Open Rofi app launcher"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Open Rofi app launcher"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Open Rofi app launcher"),

    # Core Applications (Matching Hyprland shortcuts)
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch Kitty Terminal"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch Thunar File Manager"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch Brave Browser"),
    Key([mod], "c", lazy.window.kill(), desc="Close focused window"),

    # Window State
    Key([mod], "v", lazy.window.toggle_floating(), desc="Toggle floating window"),
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

    # Volume & Media Keys (Universal PipeWire wpctl)
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Mute volume"),
    Key([mod], "equal", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), desc="Volume up"),
    Key([mod], "minus", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc="Volume down"),
    Key([mod], "BackSpace", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Mute volume"),

    # Screenshots (Universal grim + slurp + swappy)
    Key([], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area"), desc="Snip area"),
    Key(["shift"], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot full"), desc="Full screenshot"),
    Key([mod], "Print", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot window"), desc="Window screenshot"),
    Key([mod, "shift"], "s", lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area"), desc="Snip area"),

    # Clipboard & Keybind Help
    Key([mod, "shift"], "v", lazy.spawn("sh -c 'cliphist list | rofi -dmenu | cliphist decode | wl-copy'"), desc="Clipboard history"),
    Key([mod], "k", lazy.spawn("notify-send 'Keybinds' 'Super+Return: Terminal\nSuper+Space: App Launcher\nSuper+E: Files\nSuper+B: Browser\nSuper+C: Close Window\nSuper+Shift+Q: Exit'"), desc="Show keybinds"),

    # Session Management
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload Qtile Configuration"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Logout / Exit Qtile"),
]

# Map Workspaces 1-10 to keys
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
    "margin": 6,
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
# ---- PURE NATIVE BARS & WIDGETS ----------------
# ------------------------------------------------
def build_top_bar(screen_index):
    visible_groups = [str(n) for n in (range(1, 6) if screen_index == 0 else range(6, 11))]

    widgets = [
        # Left Margin Spacer
        widget.Sep(linewidth=0, padding=4),

        # Brand Chip (Exact Jacob Shell styling)
        widget.TextBox(
            text="󰣇 HyprFrost",
            foreground=colors["blue"],
            background=colors["bg_alt"],
            font="JetBrainsMono Nerd Font Bold",
            fontsize=11,
            padding=8,
            mouse_callbacks={"Button1": lazy.spawn("rofi -show drun")},
        ),
        widget.Sep(linewidth=0, padding=6),

        # Workspaces
        widget.GroupBox(
            font="JetBrainsMono Nerd Font Bold",
            fontsize=10,
            margin_y=3,
            margin_x=1,
            padding_y=3,
            padding_x=6,
            borderwidth=1,
            active=colors["blue"],
            inactive=colors["fg_dim"],
            rounded=True,
            highlight_color=[colors["bg_alt"], colors["bg_alt"]],
            highlight_method="block",
            this_current_screen_border=colors["border_active"],
            block_highlight_text_color=colors["bar_bg"],
            visible_groups=visible_groups,
            disable_drag=True,
        ),
        widget.Sep(linewidth=0, padding=6),

        # Active Window Name Pill
        widget.WindowName(
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            foreground=colors["cyan"],
            background=colors["pill_bg"],
            max_chars=38,
            padding=8,
        ),
        widget.Spacer(),

        # Center Clock Pill
        widget.TextBox(
            text="󰥔 ",
            foreground=colors["cyan"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font Bold",
            fontsize=12,
            padding=4,
        ),
        widget.Clock(
            format="%a %b %d  %I:%M %p",
            foreground=colors["cyan"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font Bold",
            fontsize=10,
            padding=6,
        ),
        widget.Sep(linewidth=0, padding=6),

        # Media Chip
        widget.TextBox(
            text="󰎆 Media",
            foreground=colors["purple"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=8,
            mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
        ),
        widget.Spacer(),

        # Right: CPU Pill
        widget.TextBox(text="󰻠", foreground=colors["blue"], background=colors["pill_bg"], font="JetBrainsMono Nerd Font", fontsize=11, padding=4),
        widget.CPU(
            format="{load_percent}%",
            foreground=colors["fg"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=4,
        ),
        widget.Sep(linewidth=0, padding=4),

        # RAM Pill
        widget.TextBox(text="󰍛", foreground=colors["purple"], background=colors["pill_bg"], font="JetBrainsMono Nerd Font", fontsize=11, padding=4),
        widget.Memory(
            format="{MemPercent}%",
            foreground=colors["fg"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=4,
        ),
        widget.Sep(linewidth=0, padding=4),

        # Volume Pill
        widget.TextBox(text="", foreground=colors["green"], background=colors["pill_bg"], font="JetBrainsMono Nerd Font", fontsize=11, padding=4),
        widget.Volume(
            foreground=colors["fg"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=4,
            mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
        ),
        widget.Sep(linewidth=0, padding=4),
    ]

    # System Tray on Primary Screen (StatusNotifier on Wayland, Systray on X11)
    if screen_index == 0:
        try:
            if os.environ.get("WAYLAND_DISPLAY"):
                widgets.extend([
                    widget.StatusNotifier(padding=4),
                    widget.Sep(linewidth=0, padding=4),
                ])
            else:
                widgets.extend([
                    widget.Systray(padding=4),
                    widget.Sep(linewidth=0, padding=4),
                ])
        except Exception:
            pass

    # Power Button Pill
    widgets.extend([
        widget.TextBox(
            text=" ⏻ ",
            foreground=colors["red"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font Bold",
            fontsize=12,
            padding=6,
            mouse_callbacks={"Button1": lazy.shutdown()},
        ),
        widget.Sep(linewidth=0, padding=4),
    ])

    return bar.Bar(
        widgets,
        34,
        background=colors["bar_bg"],
        opacity=0.96,
        margin=[6, 12, 0, 12],
        border_width=[1, 1, 1, 1],
        border_color=colors["bar_border"],
    )


def build_bottom_dock():
    widgets = [
        # Left Margin Spacer
        widget.Sep(linewidth=0, padding=4),

        # Start Button (Exact Jacob Shell styling)
        widget.TextBox(
            text=" 󰣇 Start ",
            foreground=colors["fg"],
            background=colors["bg_alt"],
            font="JetBrainsMono Nerd Font Bold",
            fontsize=11,
            padding=8,
            mouse_callbacks={"Button1": lazy.spawn("rofi -show drun")},
        ),
        widget.Sep(linewidth=0, padding=4),

        # Search Pill Trigger
        widget.TextBox(
            text="󰍏  Search apps...",
            foreground=colors["fg_dim"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=10,
            mouse_callbacks={"Button1": lazy.spawn("rofi -show drun")},
        ),
        widget.Spacer(),

        # Center TaskList (Exact Dock taskbar of open running apps)
        widget.TaskList(
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            foreground=colors["fg"],
            background=colors["bar_bg"],
            border=colors["border_active"],
            selected_border=colors["border_active"],
            unfocused_border=colors["pill_bg"],
            highlight_method="block",
            title_width_method="uniform",
            max_title_width=140,
            padding_x=8,
            padding_y=3,
            margin_y=3,
            rounded=True,
        ),
        widget.Spacer(),

        # Right Dock Utilities: Clipboard
        widget.TextBox(
            text="󰅍 Clipboard",
            foreground=colors["fg"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=8,
            mouse_callbacks={"Button1": lazy.spawn("sh -c 'cliphist list | rofi -dmenu | cliphist decode | wl-copy'")},
        ),
        widget.Sep(linewidth=0, padding=4),

        # Snip
        widget.TextBox(
            text="󰄀 Snip",
            foreground=colors["fg"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=8,
            mouse_callbacks={"Button1": lazy.spawn("/home/jacob/.local/bin/hypr-screenshot area")},
        ),
        widget.Sep(linewidth=0, padding=4),

        # Keys
        widget.TextBox(
            text="󰌌 Keys",
            foreground=colors["fg"],
            background=colors["pill_bg"],
            font="JetBrainsMono Nerd Font",
            fontsize=10,
            padding=8,
            mouse_callbacks={"Button1": lazy.spawn("notify-send 'Shortcuts' 'Super+Return: Kitty\nSuper+Space: App Launcher\nSuper+E: Thunar\nSuper+B: Brave\nSuper+C: Close Window'")},
        ),
        widget.Sep(linewidth=0, padding=4),

        # Layout Pill
        widget.CurrentLayout(
            foreground=colors["purple"],
            background=colors["bg_alt"],
            font="JetBrainsMono Nerd Font Bold",
            fontsize=10,
            padding=8,
        ),
        widget.Sep(linewidth=0, padding=4),
    ]

    return bar.Bar(
        widgets,
        42,
        background=colors["bar_bg"],
        opacity=0.96,
        margin=[0, 12, 6, 12],
        border_width=[1, 1, 1, 1],
        border_color=colors["bar_border"],
    )


# ------------------------------------------------
# ---- SCREENS CONFIGURATION ---------------------
# ------------------------------------------------
screens = [
    Screen(
        top=build_top_bar(0),
        bottom=build_bottom_dock(),
        wallpaper=wallpaper_path if os.path.isfile(wallpaper_path) else None,
        wallpaper_mode="fill",
    ),
    Screen(
        top=build_top_bar(1),
        bottom=build_bottom_dock(),
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
        Match(wm_class="Rofi"),
    ],
)

# ---------------------------
# ---- WAYLAND INPUT RULES --
# ---------------------------
try:
    from libqtile.backend.wayland import InputConfig
    wl_input_rules = {
        "*": InputConfig(natural_scroll=False),
    }
except ImportError:
    wl_input_rules = None

# -------------------
# ---- AUTOSTART ----
# -------------------
@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    if os.path.isfile(script) and os.access(script, os.X_OK):
        subprocess.Popen(["/bin/bash", script], start_new_session=True)

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
