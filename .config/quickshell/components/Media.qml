import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; right: true }
    margins { top: 40; right: 60 }
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusionMode: ExclusionMode.Ignore
    visible: rootScope ? rootScope.mediaOpen : false
    color: "transparent"

    implicitWidth: 300
    implicitHeight: 160

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
                Layout.alignment: Qt.AlignHCenter
                text: "Media Controls"
                color: "#bb9af7"
                font.bold: true
                font.pixelSize: 14
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3b4261"
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "No active media session"
                color: "#565f89"
                font.pixelSize: 12
            }
        }
    }
}
