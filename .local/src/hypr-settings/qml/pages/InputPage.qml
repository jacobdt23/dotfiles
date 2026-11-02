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
                text: "Mouse & Touchpad"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Configure pointer speed, natural scrolling, and touchpad gestures"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        FormCard {
            title: "Pointer Speed & Sensitivity"

            FormSliderDelegate {
                iconText: "🖱️"
                text: "Mouse Sensitivity"
                from: -100; to: 100; stepSize: 5
                value: hyprlandController.mouseSensitivity * 100
                unit: ""
                isLast: true
                onValueMoved: (val) => hyprlandController.mouseSensitivity = val / 100.0
            }
        }

        FormCard {
            title: "Touchpad Behavior"

            FormSwitchDelegate {
                iconText: "📜"
                text: "Natural Scrolling"
                description: "Reverse scroll direction (content follows finger movement)"
                checked: hyprlandController.naturalScroll
                onToggled: (val) => hyprlandController.naturalScroll = val
            }

            FormSwitchDelegate {
                iconText: "👆"
                text: "Tap to Click"
                description: "Single finger tap acts as primary left click"
                checked: hyprlandController.tapToClick
                isLast: true
                onToggled: (val) => hyprlandController.tapToClick = val
            }
        }

        FormCard {
            title: "Keyboard Typing & Repeat Rate"

            FormSliderDelegate {
                iconText: "⌨️"
                text: "Key Repeat Rate"
                from: 10; to: 50; stepSize: 1
                value: hyprlandController.repeatRate
                unit: " cps"
                isLast: true
                onValueMoved: (val) => hyprlandController.repeatRate = val
            }
        }
    }
}
