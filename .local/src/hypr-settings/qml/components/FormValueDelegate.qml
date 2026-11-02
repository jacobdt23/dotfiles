import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property string text: ""
    property string description: ""
    property string value: ""
    property bool isLast: false

    Layout.fillWidth: true
    implicitHeight: 44
    color: "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1

            Text {
                text: root.text
                font.pixelSize: 13
                font.bold: true
                color: "#eff0f1"
            }

            Text {
                visible: root.description !== ""
                text: root.description
                font.pixelSize: 11
                color: "#7f8c8d"
            }
        }

        Text {
            text: root.value
            font.pixelSize: 13
            color: "#3daee9"
            font.bold: true
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
