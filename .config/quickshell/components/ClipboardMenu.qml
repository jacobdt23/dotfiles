import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; right: true }
    margins { top: 40; right: 100 }
    
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    visible: rootScope.clipboardOpen
    color: "transparent"

    implicitWidth: 320
    implicitHeight: 380

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
                text: "Clipboard History"
                color: "#7aa2f7"
                font.bold: true
                font.pixelSize: 14
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3b4261"
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: 5

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 40
                    color: "#24283b"
                    border.color: "#3b4261"
                    border.width: 1
                    radius: 6

                    Text {
                        anchors.centerIn: parent
                        text: "Clipboard item sample " + (index + 1)
                        color: "#c0caf5"
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}
