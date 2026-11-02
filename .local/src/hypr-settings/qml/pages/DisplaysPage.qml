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
                    text: "Display and Monitor"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#eff0f1"
                }
                Text {
                    text: "Configure connected screens, resolution, refresh rates, and display scaling"
                    font.pixelSize: 12
                    color: "#7f8c8d"
                }
            }

            Item { Layout.fillWidth: true }

            BreezeButton {
                text: "Detect Displays"
                onClicked: hyprlandController.refreshMonitors()
            }
        }

        Repeater {
            model: hyprlandController.monitors

            FormCard {
                title: (modelData.description || modelData.model || "Display") + " (" + modelData.name + ")"

                FormValueDelegate {
                    text: "Active Resolution"
                    description: "Hardware display resolution & refresh rate"
                    value: modelData.width + "x" + modelData.height + " @ " + Number(modelData.refreshRate).toFixed(1) + "Hz"
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 52
                    color: "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 12

                        Text {
                            text: "Display Scale Factor"
                            font.pixelSize: 13
                            font.bold: true
                            color: "#eff0f1"
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            id: scaleBox
                            model: ["1.00x (100%)", "1.25x (125%)", "1.50x (150%)", "1.75x (175%)", "2.00x (200%)"]
                            Component.onCompleted: {
                                var s = modelData.scale || 1.0;
                                if (Math.abs(s - 1.25) < 0.05) currentIndex = 1;
                                else if (Math.abs(s - 1.50) < 0.05) currentIndex = 2;
                                else if (Math.abs(s - 1.75) < 0.05) currentIndex = 3;
                                else if (Math.abs(s - 2.00) < 0.05) currentIndex = 4;
                                else currentIndex = 0;
                            }
                        }

                        BreezeButton {
                            text: "Apply Scale"
                            primary: true
                            onClicked: {
                                var vals = [1.0, 1.25, 1.50, 1.75, 2.0];
                                hyprlandController.setMonitorScale(modelData.name, vals[scaleBox.currentIndex]);
                            }
                        }
                    }
                }
            }
        }
    }
}
