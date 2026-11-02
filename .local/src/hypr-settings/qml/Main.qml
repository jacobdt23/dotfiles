import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "components"
import "pages"

ApplicationWindow {
    id: window
    visible: true
    width: 980
    height: 700
    minimumWidth: 840
    minimumHeight: 560
    title: "System Settings"
    color: "#232629"

    property int activeIndex: 0
    property var allPages: [
        // Connectivity
        { name: "Bluetooth", icon: "🎧", section: "CONNECTIVITY", pageName: "BluetoothPage" },
        { name: "Wi-Fi & Connections", icon: "📶", section: "CONNECTIVITY", pageName: "NetworkPage" },

        // Hardware
        { name: "Display and Monitor", icon: "🖥️", section: "HARDWARE", pageName: "DisplaysPage" },
        { name: "Audio", icon: "🔊", section: "HARDWARE", pageName: "AudioPage" },
        { name: "Power Management", icon: "⚡", section: "HARDWARE", pageName: "PowerPage" },

        // Personalization
        { name: "Colors & Themes", icon: "🎨", section: "PERSONALIZATION", pageName: "ThemesPage" },
        { name: "Window Management & Look", icon: "🔲", section: "PERSONALIZATION", pageName: "AppearancePage" },
        { name: "Wallpaper & Background", icon: "🖼️", section: "PERSONALIZATION", pageName: "WallpaperPage" },

        // Workspace & Input
        { name: "Mouse & Touchpad", icon: "🖱️", section: "WORKSPACE & INPUT", pageName: "InputPage" },
        { name: "Shortcuts & Hotkeys", icon: "⌨️", section: "WORKSPACE & INPUT", pageName: "ShortcutsPage" },
        { name: "Default Applications", icon: "🚀", section: "WORKSPACE & INPUT", pageName: "DefaultAppsPage" },

        // System
        { name: "About this System", icon: "ℹ️", section: "SYSTEM", pageName: "AboutPage" }
    ]

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 1. KDE 6 Style Sidebar
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            color: "#1e2022"

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#31363b"
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 4

                // Search Bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.margins: 12
                    implicitHeight: 34
                    color: "#2a2e32"
                    border.color: searchInput.activeFocus ? "#3daee9" : "#31363b"
                    border.width: 1
                    radius: 6

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        Text {
                            text: "🔍"
                            font.pixelSize: 11
                            color: "#7f8c8d"
                        }

                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            color: "#eff0f1"
                            font.pixelSize: 12
                            clip: true

                            Text {
                                anchors.fill: parent
                                text: "Search settings..."
                                color: "#7f8c8d"
                                font.pixelSize: 12
                                visible: !searchInput.text && !searchInput.activeFocus
                            }
                        }
                    }
                }

                // Nav List
                ListView {
                    id: navList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: window.allPages

                    delegate: ColumnLayout {
                        width: navList.width
                        spacing: 2
                        visible: searchInput.text === "" || modelData.name.toLowerCase().indexOf(searchInput.text.toLowerCase()) !== -1

                        // Section header
                        Text {
                            visible: (index === 0 || window.allPages[index - 1].section !== modelData.section) && searchInput.text === ""
                            text: modelData.section
                            font.pixelSize: 10
                            font.bold: true
                            color: "#7f8c8d"
                            Layout.leftMargin: 18
                            Layout.topMargin: index === 0 ? 4 : 12
                            Layout.bottomMargin: 4
                        }

                        // Nav Item
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.leftMargin: 8
                            Layout.rightMargin: 8
                            implicitHeight: 34
                            radius: 5

                            property bool isSelected: window.activeIndex === index
                            color: isSelected ? "#243f54" : (itemMouse.containsMouse ? "#2d3136" : "transparent")

                            Rectangle {
                                visible: parent.isSelected
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 3
                                radius: 1
                                color: "#3daee9"
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 10

                                Text {
                                    text: modelData.icon
                                    font.pixelSize: 13
                                }

                                Text {
                                    text: modelData.name
                                    font.pixelSize: 12
                                    font.bold: parent.parent.isSelected
                                    color: parent.parent.isSelected ? "#3daee9" : "#eff0f1"
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: window.activeIndex = index
                            }
                        }
                    }
                }
            }
        }

        // 2. Main Content & Bottom Bar
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Breadcrumb Header
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 38
                color: "#232629"

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: "#31363b"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 8

                    Text {
                        text: "System Settings"
                        font.pixelSize: 12
                        color: "#7f8c8d"
                    }

                    Text {
                        text: ">"
                        font.pixelSize: 11
                        color: "#474e54"
                    }

                    Text {
                        text: window.allPages[window.activeIndex].section
                        font.pixelSize: 12
                        color: "#7f8c8d"
                    }

                    Text {
                        text: ">"
                        font.pixelSize: 11
                        color: "#474e54"
                    }

                    Text {
                        text: window.allPages[window.activeIndex].name
                        font.pixelSize: 12
                        font.bold: true
                        color: "#eff0f1"
                    }
                }
            }

            // Stack of Modules
            StackLayout {
                id: pageStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: window.activeIndex

                BluetoothPage {}
                NetworkPage {}
                DisplaysPage {}
                AudioPage {}
                PowerPage {}
                ThemesPage {}
                AppearancePage {}
                WallpaperPage {}
                InputPage {}
                ShortcutsPage {}
                DefaultAppsPage {}
                AboutPage {}
            }

            // Bottom Action Bar (KDE Plasma signature)
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 46
                color: "#1e2022"

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: "#31363b"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 12

                    BreezeButton {
                        text: "Defaults"
                        onClicked: hyprlandController.applyDefaults()
                    }

                    Item { Layout.fillWidth: true }

                    BreezeButton {
                        text: "Discard"
                        onClicked: {
                            bluetoothController.refresh();
                            networkController.refresh();
                            audioController.refresh();
                            hyprlandController.refreshMonitors();
                        }
                    }

                    BreezeButton {
                        text: "Apply"
                        primary: true
                        onClicked: {
                            // Instantly applies pending settings
                        }
                    }
                }
            }
        }
    }
}
