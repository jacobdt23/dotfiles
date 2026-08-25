import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
    required property var screen
    required property var rootScope

    Process { id: actionExec }

    anchors.fill: parent

    RowLayout {
        anchors.centerIn: parent
        spacing: 12

        Rectangle {
            width: 32
            height: 32
            color: btn1Mouse.containsMouse ? "#3b4261" : "#24283b"
            radius: 6

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "C"
                color: "#7aa2f7"
                font.pixelSize: 16
                font.bold: true
            }

            MouseArea {
                id: btn1Mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: rootScope.toggleDrawer()
            }
        }

        Rectangle {
            width: 32
            height: 32
            color: btn2Mouse.containsMouse ? "#3b4261" : "#24283b"
            radius: 6

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
                onClicked: actionExec.exec(["alacritty"])
            }
        }

        Rectangle {
            width: 32
            height: 32
            color: btn3Mouse.containsMouse ? "#3b4261" : "#24283b"
            radius: 6

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
                onClicked: actionExec.exec(["brave"])
            }
        }
    }
}
