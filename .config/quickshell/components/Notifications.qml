import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; right: true }
    margins { top: 40; right: 140 }
    
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    visible: rootScope.notificationsOpen
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
                text: "Notifications Center"
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
                spacing: 8
                model: NotificationServer.trackedNotifications

                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: 50
                    color: "#24283b"
                    border.color: "#3b4261"
                    border.width: 1
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        Text { text: modelData.summary; color: "#c0caf5"; font.bold: true; font.pixelSize: 11; elide: Text.ElideRight; Layout.fillWidth: true }
                        Text { text: modelData.body; color: "#565f89"; font.pixelSize: 10; elide: Text.ElideRight; Layout.fillWidth: true }
                    }
                }
            }
        }
    }
}
