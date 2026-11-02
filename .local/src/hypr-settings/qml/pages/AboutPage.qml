import QtQuick
import QtQuick.Layouts
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
                text: "About this System"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Hardware specifications, Linux kernel, and desktop environment information"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Operating System & Software"

            FormValueDelegate {
                text: "Operating System"
                description: "Linux Distribution"
                value: systemInfoController.osName
            }

            FormValueDelegate {
                text: "Desktop Environment"
                description: "Wayland Compositor & Shell"
                value: systemInfoController.compositor
            }

            FormValueDelegate {
                text: "Kernel Version"
                description: "Linux system kernel"
                value: systemInfoController.kernelVersion
            }

            FormValueDelegate {
                text: "Settings Framework"
                description: "Native KDE Architecture"
                value: "Qt 6 / QML (Breeze Dark)"
                isLast: true
            }
        }

        FormCard {
            title: "Hardware Specifications"

            FormValueDelegate {
                text: "Processor (CPU)"
                description: "Central Processing Unit"
                value: systemInfoController.cpuModel
            }

            FormValueDelegate {
                text: "Total Memory (RAM)"
                description: "System physical memory"
                value: systemInfoController.totalMemory
            }

            FormValueDelegate {
                text: "Device Hostname"
                description: "Network station name"
                value: systemInfoController.hostname
            }

            FormValueDelegate {
                visible: systemInfoController.hasBattery
                text: "Battery Status"
                description: "Charge level and power source"
                value: systemInfoController.batteryPercent + "% (" + systemInfoController.batteryStatus + ")"
                isLast: true
            }
        }
    }
}
