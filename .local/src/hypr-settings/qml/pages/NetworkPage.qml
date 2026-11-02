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

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                spacing: 2
                Text {
                    text: "Wi-Fi & Connections"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#eff0f1"
                }
                Text {
                    text: "Configure wireless networking, signal strength, and network authentication"
                    font.pixelSize: 12
                    color: "#7f8c8d"
                }
            }

            Item { Layout.fillWidth: true }

            BreezeButton {
                text: "Rescan Networks"
                onClicked: networkController.scanNetworks()
            }
        }

        FormCard {
            title: "Wireless Controller"

            FormSwitchDelegate {
                iconText: "📶"
                text: "Enable Wi-Fi"
                description: "Status: " + networkController.activeConnection
                checked: networkController.wifiEnabled
                isLast: true
                onToggled: (val) => networkController.toggleWifi(val)
            }
        }

        FormCard {
            title: "Available Wi-Fi Networks"

            Text {
                visible: networkController.networks.length === 0
                text: "Scanning for available wireless networks..."
                color: "#7f8c8d"
                font.pixelSize: 12
                Layout.margins: 8
            }

            Repeater {
                model: networkController.networks

                FormButtonDelegate {
                    iconText: "📡"
                    text: modelData.ssid
                    description: "Signal: " + modelData.bars + " • " + modelData.security
                    statusText: modelData.inUse ? "Connected" : ""
                    statusPositive: true
                    buttonText: modelData.inUse ? "" : "Connect"
                    isLast: index === (networkController.networks.length - 1)

                    onPrimaryClicked: {
                        if (modelData.isSecured) {
                            pwdDialog.targetSsid = modelData.ssid;
                            pwdInput.text = "";
                            pwdDialog.open();
                        } else {
                            networkController.connectNetwork(modelData.ssid, "");
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: pwdDialog
        property string targetSsid: ""
        anchors.centerIn: parent
        modal: true
        title: "Connect to Wi-Fi"
        background: Rectangle {
            color: "#2a2e32"
            border.color: "#31363b"
            radius: 8
        }

        ColumnLayout {
            spacing: 14
            Text {
                text: "Enter WPA/WPA2 security key for '" + pwdDialog.targetSsid + "':"
                color: "#eff0f1"
                font.pixelSize: 13
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 34
                color: "#232629"
                border.color: "#31363b"
                radius: 4

                TextInput {
                    id: pwdInput
                    anchors.fill: parent
                    anchors.margins: 8
                    color: "#eff0f1"
                    echoMode: TextInput.Password
                    font.pixelSize: 13
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 8
                BreezeButton {
                    text: "Cancel"
                    onClicked: pwdDialog.close()
                }
                BreezeButton {
                    text: "Connect"
                    primary: true
                    onClicked: {
                        networkController.connectNetwork(pwdDialog.targetSsid, pwdInput.text);
                        pwdDialog.close();
                    }
                }
            }
        }
    }
}
