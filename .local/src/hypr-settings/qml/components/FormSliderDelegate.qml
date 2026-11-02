import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    property string iconText: ""
    property string text: ""
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property real value: 50
    property string unit: "%"
    property bool hasMute: false
    property bool isMuted: false
    property bool isLast: false

    signal valueMoved(real newValue)
    signal muteToggled(bool muted)

    Layout.fillWidth: true
    implicitHeight: 52
    color: "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 12

        Text {
            visible: root.iconText !== ""
            text: root.iconText
            font.pixelSize: 16
            Layout.preferredWidth: 24
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: root.text
            font.pixelSize: 13
            font.bold: true
            color: "#eff0f1"
            Layout.preferredWidth: 120
        }

        Slider {
            id: slider
            Layout.fillWidth: true
            from: root.from
            to: root.to
            stepSize: root.stepSize
            value: root.value
            onMoved: root.valueMoved(Math.round(value))
        }

        Text {
            text: Math.round(slider.value) + root.unit
            font.pixelSize: 12
            color: "#7f8c8d"
            Layout.preferredWidth: 45
            horizontalAlignment: Text.AlignRight
        }

        BreezeSwitch {
            visible: root.hasMute
            text: "Mute"
            checked: root.isMuted
            onToggled: (m) => root.muteToggled(m)
        }
    }

    Rectangle {
        visible: !root.isLast
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#31363b"
    }
}
