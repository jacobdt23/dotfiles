import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { bottom: true }
    margins { bottom: 60 }
    
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    visible: rootScope.osdVisible
    color: "transparent"

    implicitWidth: 260
    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        border.color: "#3b4261"
        border.width: 1
        radius: 10

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Text {
                text: rootScope.osdIcon
                color: "#7aa2f7"
                font.pixelSize: 18
                font.bold: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 8
                radius: 4
                color: "#24283b"

                Rectangle {
                    width: parent.width * Math.min(1.0, Math.max(0.0, rootScope.osdValue / 100))
                    height: parent.height
                    radius: 4
                    color: rootScope.osdIcon === "󰝟" ? "#f7768e" : "#7aa2f7"

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            Text {
                text: Math.round(rootScope.osdValue) + "%"
                color: "#c0caf5"
                font.pixelSize: 11
                font.bold: true
                Layout.preferredWidth: 32
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
