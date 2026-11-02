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
                    text: "Audio"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#eff0f1"
                }
                Text {
                    text: "Manage PipeWire audio sinks, microphone sources, and volume balance"
                    font.pixelSize: 12
                    color: "#7f8c8d"
                }
            }

            Item { Layout.fillWidth: true }

            BreezeButton {
                text: "Test Chime"
                onClicked: audioController.playTestSound()
            }
        }

        FormCard {
            title: "Playback Devices (Outputs)"

            FormSliderDelegate {
                iconText: "🔊"
                text: "Master Volume"
                from: 0; to: 100; stepSize: 1
                value: audioController.outputVolume
                hasMute: true
                isMuted: audioController.outputMuted
                isLast: true
                onValueMoved: (val) => audioController.outputVolume = val
                onMuteToggled: (m) => audioController.outputMuted = m
            }
        }

        FormCard {
            title: "Recording Devices (Inputs)"

            FormSliderDelegate {
                iconText: "🎙️"
                text: "Microphone Level"
                from: 0; to: 100; stepSize: 1
                value: audioController.inputVolume
                hasMute: true
                isMuted: audioController.inputMuted
                isLast: true
                onValueMoved: (val) => audioController.inputVolume = val
                onMuteToggled: (m) => audioController.inputMuted = m
            }
        }
    }
}
