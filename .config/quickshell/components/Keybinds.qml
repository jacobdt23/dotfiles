import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; left: true }
    margins { top: 40; left: 20 }
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusionMode: ExclusionMode.Ignore
    visible: rootScope ? rootScope.keybindsOpen : false
    color: "transparent"

    implicitWidth: 420
    implicitHeight: 460

    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        border.color: "#3b4261"
        border.width: 1
        radius: 12

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "Keybindings Reference"
                color: "#bb9af7"
                font.bold: true
                font.pixelSize: 14
            }

            Text {
                text: "SUPER + Return: Terminal\nSUPER + D: Discord\nSUPER + Q: Power Menu\nSUPER + K: Keybinds\nSUPER + N: Notifications\nSUPER + M: Media\nSUPER + Space: Launcher"
                color: "#c0caf5"
                font.pixelSize: 12
            }
        }
    }
}
