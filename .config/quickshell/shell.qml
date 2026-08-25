import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "components"

Scope {
    id: root
    property bool launcherOpen: false
    property bool keybindsOpen: false
    property bool powerMenuOpen: false
    property bool notificationsOpen: false
    property bool clipboardOpen: false
    property bool mediaOpen: false
    property bool calendarOpen: false

    property bool osdVisible: false
    property string osdIcon: "󰕾"
    property real osdValue: 50

    Timer {
        id: osdTimer
        interval: 1800
        running: false
        repeat: false
        onTriggered: root.osdVisible = false
    }

    function showOsd(icon: string, val: real): void {
        root.osdIcon = icon;
        root.osdValue = Math.max(0, Math.min(100, val));
        root.osdVisible = true;
        osdTimer.restart();
    }

    function closeAll(): void {
        launcherOpen = false;
        keybindsOpen = false;
        powerMenuOpen = false;
        notificationsOpen = false;
        clipboardOpen = false;
        mediaOpen = false;
        calendarOpen = false;
    }

    Process {
        id: volumeProc
        command: []
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("Volume:")) {
                    let vol = Math.round(parseFloat(data.split(":")[1]) * 100);
                    let icon = data.includes("MUTED") ? "󰝟" : (vol > 50 ? "󰕾" : "󰖀");
                    root.showOsd(icon, vol);
                }
            }
        }
    }

    function adjustVolume(action: string) {
        let cmd = "";
        if (action === "up") {
            cmd = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        } else if (action === "down") {
            cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        } else {
            cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        }
        
        volumeProc.command = ["bash", "-c", cmd + " && wpctl get-volume @DEFAULT_AUDIO_SINK@"];
        volumeProc.running = true;
    }

    IpcHandler { target: "drawer"; function toggle(): void { let w = root.launcherOpen; closeAll(); root.launcherOpen = !w; } }
    IpcHandler { target: "keybinds"; function toggle(): void { let w = root.keybindsOpen; closeAll(); root.keybindsOpen = !w; } }
    IpcHandler { target: "powermenu"; function toggle(): void { let w = root.powerMenuOpen; closeAll(); root.powerMenuOpen = !w; } }
    IpcHandler { target: "notifications"; function toggle(): void { let w = root.notificationsOpen; closeAll(); root.notificationsOpen = !w; } }
    IpcHandler { target: "clipboard"; function toggle(): void { let w = root.clipboardOpen; closeAll(); root.clipboardOpen = !w; } }
    IpcHandler { target: "media"; function toggle(): void { let w = root.mediaOpen; closeAll(); root.mediaOpen = !w; } }
    IpcHandler { target: "calendar"; function toggle(): void { let w = root.calendarOpen; closeAll(); root.calendarOpen = !w; } }
    
    IpcHandler { target: "volume"; function change(action: string): void { root.adjustVolume(action); } }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            Item {
                required property var modelData

                TopBar { targetScreen: modelData; rootScope: root }
                BottomDock { targetScreen: modelData; rootScope: root }
                Launcher { targetScreen: modelData; rootScope: root }
                KeybindsMenu { screen: modelData; rootScope: root }
                PowerMenu { targetScreen: modelData; rootScope: root }
                Notifications { targetScreen: modelData; rootScope: root }
                ClipboardMenu { targetScreen: modelData; rootScope: root }
                MediaMenu { targetScreen: modelData; rootScope: root }
                CalendarDropdown { targetScreen: modelData; rootScope: root }
                Osd { targetScreen: modelData; rootScope: root }
            }
        }
    }
}
