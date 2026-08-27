import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; left: true }
    margins { top: 40; left: (targetScreen.width / 2) - (implicitWidth / 2) }
    
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

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(new Date(), "dddd, MMMM d, yyyy")
                color: "#7aa2f7"
                font.pixelSize: 15
                font.bold: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3b4261"
            }

            // Days of Week Header Row
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                Repeater {
                    model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                    Item {
                        width: 40; height: 20
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "#565f89"
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }
            }

            // Clean Uniform Grid for Calendar Days
            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 7
                rowSpacing: 6
                columnSpacing: 8

                Repeater {
                    model: 35
                    Rectangle {
                        required property int index
                        width: 40
                        height: 32
                        radius: 6
                        
                        property int firstDayOffset: 6 // Saturday start offset for August 2026
                        property int dayNum: index - firstDayOffset + 1
                        property bool isCurrentMonth: dayNum > 0 && dayNum <= 31
                        property bool isToday: isCurrentMonth && dayNum === new Date().getDate()

                        color: isToday ? "#7aa2f7" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: parent.isCurrentMonth ? parent.dayNum : ""
                            color: parent.isToday ? "#1a1b26" : "#c0caf5"
                            font.pixelSize: 12
                            font.bold: parent.isToday
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3b4261"
            }

            Text {
                text: "Recent Notifications"
                color: "#bb9af7"
                font.pixelSize: 13
                font.bold: true
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
                    height: 45
                    color: "#24283b"
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
