-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_ICON_THEME", "breeze-dark")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Dynamic GPU Vendor Auto-Detection (NVIDIA, AMD, Intel) & VM Detection
local is_vm      = os.execute("systemd-detect-virt --vm >/dev/null 2>&1")
local has_nvidia = os.execute("lsmod 2>/dev/null | grep -q '^nvidia'")
local has_amd    = os.execute("lsmod 2>/dev/null | grep -qE '^(amdgpu|radeon)'")
local has_intel  = os.execute("lsmod 2>/dev/null | grep -qE '^(i915|xe)'")

if has_nvidia == true or has_nvidia == 0 then
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("NVD_BACKEND", "direct")
    hl.env("__GL_MAX_FRAMES_ALLOWED", "1")
    hl.env("GBM_BACKEND", "nvidia-drm")
elseif has_amd == true or has_amd == 0 then
    hl.env("LIBVA_DRIVER_NAME", "radeonsi")
    hl.env("VDPAU_DRIVER", "radeonsi")
elseif has_intel == true or has_intel == 0 then
    hl.env("LIBVA_DRIVER_NAME", "iHD")
end

if is_vm == true or is_vm == 0 then
    hl.env("WLR_NO_HARDWARE_CURSORS", "1")
else
    hl.env("WLR_NO_HARDWARE_CURSORS", "0")
end

hl.env("HYPRLAND_NO_SD_NOTIFY", "1")
