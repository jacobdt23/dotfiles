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
                text: "Default Applications"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Choose default applications for web browsing, file management, and terminal emulation"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Standard Handlers"

            FormValueDelegate {
                text: "Default Web Browser"
                description: "Used to open URLs and internet links"
                value: defaultAppsController.browser
            }

            FormValueDelegate {
                text: "Default File Manager"
                description: "Used to open folders and directory paths"
                value: defaultAppsController.fileManager
            }

            FormValueDelegate {
                text: "Default Terminal Emulator"
                description: "GPU accelerated command line"
                value: defaultAppsController.terminal
                isLast: true
            }
        }
    }
}
