import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "components"

Scope {
    id: root
    property bool drawerOpen: false

    IpcHandler {
        target: "drawer"
        function toggle(): void {
            root.drawerOpen = !root.drawerOpen;
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Item {
                required property var modelData

                PanelWindow {
                    screen: modelData
                    anchors.top: true
                    anchors.left: true
                    anchors.right: true
                    WlrLayershell.layer: WlrLayer.Top
                    implicitHeight: 35
                    exclusiveZone: 35
                    color: "#1a1b26"

                    TopBarContent {
                        screen: modelData
                        rootScope: root
                    }
                }

                PanelWindow {
                    screen: modelData
                    anchors.bottom: true
                    anchors.left: true
                    anchors.right: true
                    WlrLayershell.layer: WlrLayer.Top
                    implicitHeight: 40
                    exclusiveZone: 40
                    color: "#1a1b26"

                    BottomDockContent {
                        screen: modelData
                        rootScope: root
                    }
                }

                AppDrawer {
                    screen: modelData
                    rootScope: root
                }
            }
        }
    }
}
