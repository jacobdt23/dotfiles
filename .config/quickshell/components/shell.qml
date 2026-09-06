import Quickshell
import Quickshell.Io
import QtQuick
import "components"

Scope {
    id: root
    
    property bool launcherOpen: false
    property bool powerMenuOpen: false

    function closeAll() {
        launcherOpen = false;
        powerMenuOpen = false;
    }

    IpcHandler {
        target: "drawer"
        function toggle(): void {
            root.launcherOpen = !root.launcherOpen;
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Item {
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
            }
        }
    }
}
