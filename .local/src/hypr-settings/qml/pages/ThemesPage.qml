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
                text: "Colors & Themes"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Customize desktop theme, color scheme, icons, and typography"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Color Scheme & Style"

            FormSwitchDelegate {
                iconText: "🌙"
                text: "Dark Mode"
                description: "Prefer dark appearance across GTK and Wayland applications"
                checked: themeController.isDarkMode
                isLast: true
                onToggled: (val) => themeController.isDarkMode = val
            }
        }

        FormCard {
            title: "Application Themes & Icons"

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 52
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 12

                    Text { text: "🎨"; font.pixelSize: 16 }
                    Text { text: "GTK Application Theme"; font.pixelSize: 13; font.bold: true; color: "#eff0f1"; Layout.fillWidth: true }

                    ComboBox {
                        id: gtkBox
                        model: themeController.availableGtkThemes
                        Component.onCompleted: {
                            var idx = model.indexOf(themeController.gtkTheme);
                            if (idx >= 0) currentIndex = idx;
                        }
                        onActivated: (idx) => themeController.gtkTheme = model[idx]
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: "#31363b"
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

                    Text { text: "🖼️"; font.pixelSize: 16 }
                    Text { text: "System Icon Theme"; font.pixelSize: 13; font.bold: true; color: "#eff0f1"; Layout.fillWidth: true }

                    ComboBox {
                        id: iconBox
                        model: themeController.availableIconThemes
                        Component.onCompleted: {
                            var idx = model.indexOf(themeController.iconTheme);
                            if (idx >= 0) currentIndex = idx;
                        }
                        onActivated: (idx) => themeController.iconTheme = model[idx]
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: "#31363b"
            }

            FormSliderDelegate {
                iconText: "🔤"
                text: "Text Font Scaling"
                from: 80; to: 150; stepSize: 5
                value: themeController.fontScaling * 100
                unit: "%"
                isLast: true
                onValueMoved: (val) => themeController.fontScaling = val / 100.0
            }
        }
    }
}
