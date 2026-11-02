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

        // KDE Style Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                spacing: 2
                Text {
                    text: "Bluetooth"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#eff0f1"
                }
                Text {
                    text: "Manage Bluetooth adapters, paired devices, and wireless accessories"
                    font.pixelSize: 12
                    color: "#7f8c8d"
                }
            }

            Item { Layout.fillWidth: true }

            BreezeButton {
                text: bluetoothController.scanning ? "Stop Scanning" : "Scan for Devices"
                primary: !bluetoothController.scanning
                danger: bluetoothController.scanning
                onClicked: {
                    if (bluetoothController.scanning) {
                        bluetoothController.stopScan();
                    } else {
                        bluetoothController.startScan();
                    }
                }
            }
        }

        // Adapter Configuration Card
        FormCard {
            title: "Adapter Configuration"

            FormSwitchDelegate {
                iconText: "📡"
                text: "Enable Bluetooth"
                description: bluetoothController.adapterName + (bluetoothController.enabled ? " • Ready" : " • Offline")
                checked: bluetoothController.enabled
                onToggled: (val) => bluetoothController.togglePower(val)
            }

            FormSwitchDelegate {
                iconText: "👁️"
                text: "Make Discoverable"
                description: "Allow nearby phones, accessories, and PCs to discover this computer"
                checked: bluetoothController.discoverable
                isLast: true
                onToggled: (val) => bluetoothController.toggleDiscoverable(val)
            }
        }

        // Paired Devices Card
        FormCard {
            title: "Paired Devices"

            Text {
                visible: bluetoothController.pairedDevices.length === 0
                text: "No paired Bluetooth devices found"
                color: "#7f8c8d"
                font.pixelSize: 12
                Layout.margins: 8
            }

            Repeater {
                model: bluetoothController.pairedDevices

                FormButtonDelegate {
                    iconText: "🎧"
                    text: modelData.name || "Bluetooth Accessory"
                    description: modelData.mac + (modelData.battery !== "" ? " • 🔋 " + modelData.battery : "")
                    statusText: modelData.connected ? "Connected" : "Disconnected"
                    statusPositive: modelData.connected
                    buttonText: modelData.connected ? "Disconnect" : "Connect"
                    buttonDanger: modelData.connected
                    showSecondaryButton: true
                    secondaryButtonText: "Forget"
                    isLast: index === (bluetoothController.pairedDevices.length - 1)

                    onPrimaryClicked: {
                        if (modelData.connected) {
                            bluetoothController.disconnectDevice(modelData.mac);
                        } else {
                            bluetoothController.connectDevice(modelData.mac);
                        }
                    }

                    onSecondaryClicked: {
                        bluetoothController.removeDevice(modelData.mac);
                    }
                }
            }
        }

        // Available Nearby Devices Card
        FormCard {
            title: "Available Nearby Devices"

            Text {
                visible: bluetoothController.nearbyDevices.length === 0
                text: bluetoothController.scanning ? "Scanning nearby Bluetooth spectrum..." : "Click 'Scan for Devices' to discover nearby headphones, mice, and controllers."
                color: "#7f8c8d"
                font.pixelSize: 12
                Layout.margins: 8
            }

            Repeater {
                model: bluetoothController.nearbyDevices

                FormButtonDelegate {
                    iconText: "✨"
                    text: modelData.name || "Nearby Accessory"
                    description: modelData.mac
                    buttonText: "Pair"
                    isLast: index === (bluetoothController.nearbyDevices.length - 1)

                    onPrimaryClicked: {
                        bluetoothController.pairDevice(modelData.mac);
                    }
                }
            }
        }
    }
}
