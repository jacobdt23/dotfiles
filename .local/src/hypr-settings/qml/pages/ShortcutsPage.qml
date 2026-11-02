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
                text: "Shortcuts & Keybindings"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Global Hyprland window manager and application hotkeys"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Configured Hyprland Keybindings"

            Repeater {
                model: hyprlandController.shortcuts

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 46
                    color: "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 12

                        Rectangle {
                            implicitWidth: keyText.implicitWidth + 14
                            implicitHeight: 24
                            radius: 4
                            color: "#1e2022"
                            border.color: "#3daee9"
                            border.width: 1

                            Text {
                                id: keyText
                                anchors.centerIn: parent
                                text: modelData.key
                                font.pixelSize: 11
                                font.bold: true
                                color: "#3daee9"
                            }
                        }

                        Text {
                            text: modelData.action
                            font.pixelSize: 12
                            color: "#eff0f1"
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: "#31363b"
                    }
                }
            }
        }
    }
}
