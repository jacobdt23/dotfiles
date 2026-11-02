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
                text: "Wallpaper & Background"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Choose desktop background from your ~/Pictures/Wallpapers folder"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Available Wallpapers"

            Text {
                visible: themeController.availableWallpapers.length === 0
                text: "No images found in ~/Pictures/Wallpapers/"
                color: "#7f8c8d"
                font.pixelSize: 12
                Layout.margins: 8
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 12
                columnSpacing: 12

                Repeater {
                    model: themeController.availableWallpapers

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 120
                        radius: 6
                        color: "#1e2022"
                        border.color: mouseArea.containsMouse ? "#3daee9" : "#31363b"
                        border.width: 1
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: "file://" + modelData
                            fillMode: Image.PreserveAspectCrop
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 28
                            color: "#aa1a1b26"

                            Text {
                                anchors.centerIn: parent
                                text: modelData.split('/').pop()
                                font.pixelSize: 11
                                font.bold: true
                                color: "#eff0f1"
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: themeController.setWallpaper(modelData)
                        }
                    }
                }
            }
        }
    }
}
