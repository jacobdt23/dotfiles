import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true }
    margins { top: 45 } // Sits right below the 35px top bar + 10px margin
    
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    visible: rootScope.calendarOpen
    color: "transparent"
    implicitWidth: 360
    implicitHeight: 440

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

            // Header Date
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(new Date(), "MMMM yyyy")
                color: "#7aa2f7"
                font.pixelSize: 16
                font.bold: true
            }

            // Simple Calendar Grid / Placeholder or Month View
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                color: "#24283b"
                radius: 8

                // You can drop a standard QtQuick.Controls.DayOfWeekRow / MonthGrid here if desired, 
                // or a clean summary text block:
                Text {
                    anchors.centerIn: parent
                    text: "Calendar View Active\n(Select dates or view schedule here)"
                    color: "#c0caf5"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 13
                }
            }

            Text {
                text: "Recent Notifications"
                color: "#bb9af7"
                font.pixelSize: 14
                font.bold: true
            }

            // Embedded Notification Feed
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
                    color: "#1f2335"
                    radius: 6

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        Text { text: modelData.summary; color: "#c0caf5"; font.bold: true; elide: Text.ElideRight; Layout.fillWidth: true }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.dismiss()
                    }
                }
            }
        }
    }
}
