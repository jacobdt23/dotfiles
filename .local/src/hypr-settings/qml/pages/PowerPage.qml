import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components"

Flickable {
    id: root
    contentHeight: contentCol.implicitHeight + 40
    clip: true

    ColumnLayout {
        id: contentCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 24
        spacing: 18

        ColumnLayout {
            spacing: 2
            Text {
                text: "Power Management"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Optimize battery life, power profiles, and idle screen power saving"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Energy & Performance Profile"

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 52
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 12

                    Text { text: "⚡"; font.pixelSize: 16 }
                    Text { text: "Active Power Profile"; font.pixelSize: 13; font.bold: true; color: "#eff0f1"; Layout.fillWidth: true }

                    ComboBox {
                        model: ["power-saver", "balanced", "performance"]
                        Component.onCompleted: {
                            var idx = model.indexOf(hyprlandController.powerProfile);
                            if (idx >= 0) currentIndex = idx;
                        }
                        onActivated: (idx) => hyprlandController.powerProfile = model[idx]
                    }
                }
            }
        }

        FormCard {
            visible: systemInfoController.hasBattery
            title: "Battery Health & Status"

            FormValueDelegate {
                text: "Current Charge Level"
                description: "Battery capacity percentage"
                value: systemInfoController.batteryPercent + "%"
            }

            FormValueDelegate {
                text: "Power Source"
                description: "Charging or Discharging state"
                value: systemInfoController.batteryStatus
                isLast: true
            }
        }
    }
}
