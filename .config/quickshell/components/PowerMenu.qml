import Quickshell
import QtQuick
import QtQuick.Layouts

Window {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    visible: rootScope.powerMenuOpen
    width: 220
    height: 200
    color: "#1a1b26"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.BypassWindowManagerHint

    // Position near top right
    x: targetScreen.width - width - 20
    y: 40

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {}

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Power Menu"
                color: "#7aa2f7"
                font.bold: true
                font.pixelSize: 14
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3b4261"
            }

            Repeater {
                model: [
                    { label: "Lock Screen", cmd: "hyprlock" },
                    { label: "Reboot", cmd: "systemctl reboot" },
                    { label: "Shutdown", cmd: "systemctl poweroff" }
                ]

                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    height: 35
                    color: pMouse.containsMouse ? "#3b4261" : "#24283b"
                    border.color: "#3b4261"
                    border.width: 1
                    radius: 6

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: "#c0caf5"
                        font.pixelSize: 12
                        font.bold: true
                    }

                    MouseArea {
                        id: pMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            rootScope.closeAll();
                            Quickshell.sh(modelData.cmd + " &");
                        }
                    }
                }
            }
        }
    }
}
