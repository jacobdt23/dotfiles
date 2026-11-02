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
                text: "Window Management & Look"
                font.pixelSize: 22
                font.bold: true
                color: "#eff0f1"
            }
            Text {
                text: "Customize Hyprland window gaps, borders, corner rounding, and desktop effects"
                font.pixelSize: 12
                color: "#7f8c8d"
            }
        }

        // Layout & Gaps
        FormCard {
            title: "Layout & Gaps"

            FormSliderDelegate {
                iconText: "📐"
                text: "Inner Gaps"
                from: 0; to: 30; stepSize: 1
                value: hyprlandController.gapsIn
                unit: " px"
                onValueMoved: (val) => hyprlandController.gapsIn = val
            }

            FormSliderDelegate {
                iconText: "📏"
                text: "Outer Screen Gaps"
                from: 0; to: 50; stepSize: 1
                value: hyprlandController.gapsOut
                unit: " px"
                onValueMoved: (val) => hyprlandController.gapsOut = val
            }

            FormSliderDelegate {
                iconText: "🔲"
                text: "Border Width"
                from: 0; to: 8; stepSize: 1
                value: hyprlandController.borderSize
                unit: " px"
                isLast: true
                onValueMoved: (val) => hyprlandController.borderSize = val
            }
        }

        // Corners & Effects
        FormCard {
            title: "Corners & Compositor Effects"

            FormSliderDelegate {
                iconText: "⭕"
                text: "Corner Rounding"
                from: 0; to: 25; stepSize: 1
                value: hyprlandController.rounding
                unit: " px"
                onValueMoved: (val) => hyprlandController.rounding = val
            }

            FormSwitchDelegate {
                iconText: "🌫️"
                text: "Background Blur"
                description: "Render frosted glass blur effect behind transparent windows"
                checked: hyprlandController.blurEnabled
                onToggled: (val) => hyprlandController.blurEnabled = val
            }

            FormSwitchDelegate {
                iconText: "🌑"
                text: "Window Shadows"
                description: "Cast subtle depth shadows under active and floating windows"
                checked: hyprlandController.shadowEnabled
                onToggled: (val) => hyprlandController.shadowEnabled = val
            }

            FormSwitchDelegate {
                iconText: "✨"
                text: "Dynamic Animations"
                description: "Fluid window open, close, and workspace transitions"
                checked: hyprlandController.animationsEnabled
                isLast: true
                onToggled: (val) => hyprlandController.animationsEnabled = val
            }
        }
    }
}
