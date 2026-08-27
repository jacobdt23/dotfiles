import Quickshell
import Quickshell.Io
import QtQuick
import "components"

Scope {
    id: root

    property bool launcherOpen: false
    property bool powerMenuOpen: false
    property bool calendarOpen: false
    property bool keybindsOpen: false
    property bool clipboardOpen: false
    property bool notificationsOpen: false
    property bool mediaOpen: false
    property bool osdVisible: false
    property string osdIcon: ""
    property real osdValue: 0

    function closeAll() {
        launcherOpen = false;
        powerMenuOpen = false;
        calendarOpen = false;
        keybindsOpen = false;
        clipboardOpen = false;
        notificationsOpen = false;
        mediaOpen = false;
    }

    IpcHandler {
        target: "drawer"
        function toggle(): void {
            let state = root.launcherOpen;
            root.closeAll();
            root.launcherOpen = !state;
        }
    }

    IpcHandler {
        target: "powermenu"
        function toggle(): void {
            let state = root.powerMenuOpen;
            root.closeAll();
            root.powerMenuOpen = !state;
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property var modelData

            TopBar {
                targetScreen: modelData
                rootScope: root
            }

            BottomDock {
                targetScreen: modelData
                rootScope: root
            }

            Launcher {
                targetScreen: modelData
                rootScope: root
            }

            PowerMenu {
                targetScreen: modelData
                rootScope: root
            }

            CalendarDropdown {
                targetScreen: modelData
                rootScope: root
            }

            ClipboardMenu {
                targetScreen: modelData
                rootScope: root
            }

            KeybindsMenu {
                targetScreen: modelData
                rootScope: root
            }

            Notifications {
                targetScreen: modelData
                rootScope: root
            }

            MediaMenu {
                targetScreen: modelData
                rootScope: root
            }

            Osd {
                targetScreen: modelData
                rootScope: root
            }
        }
    }
}
