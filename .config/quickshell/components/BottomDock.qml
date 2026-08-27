import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Top
    implicitHeight: 40
    exclusiveZone: 40
    color: "#1a1b26"

    Process { id: dockExec }

    RowLayout {
        anchors.centerIn: parent
        spacing: 12

        // App Launcher Button with custom CachyOS image from Downloads
        Rectangle {
            width: 32; height: 32; radius: 6
            color: btn1Mouse.containsMouse ? "#3b4261" : "#24283b"
            Behavior on color { ColorAnimation { duration: 150 } }

            Image {
                anchors.centerIn: parent
                width: 20; height: 20
                source: "file:///home/jacob/Downloads/cachyos-linux.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: btn1Mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    rootScope.closeAll()
                    rootScope.launcherOpen = true
                }
            }
        }

        // Terminal Shortcut
        Rectangle {
            width: 32; height: 32; radius: 6
            color: btn2Mouse.containsMouse ? "#3b4261" : "#24283b"
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: ">_"
                color: "#9ece6a"
                font.pixelSize: 12
                font.bold: true
            }

            MouseArea {
                id: btn2Mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: dockExec.exec(["alacritty"])
            }
        }

        // Browser Shortcut
        Rectangle {
            width: 32; height: 32; radius: 6
            color: btn3Mouse.containsMouse ? "#3b4261" : "#24283b"
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "W"
                color: "#ff9e64"
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                id: btn3Mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: dockExec.exec(["brave"])
            }
        }
    }
}
