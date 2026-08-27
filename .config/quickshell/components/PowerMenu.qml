import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; right: true }
    margins { top: 40; right: 20 }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    color: "#01000000"
    visible: rootScope.powerMenuOpen

    implicitWidth: 220
    implicitHeight: 200

    Process {
        id: powerProc
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: rootScope.powerMenuOpen = false
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        border.color: "#3b4261"
        border.width: 1
        radius: 12

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {}
        }

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
                            powerProc.exec(["sh", "-c", modelData.cmd]);
                        }
                    }
                }
            }
        }
    }
}
