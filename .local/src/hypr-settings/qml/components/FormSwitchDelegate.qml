import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property string iconText: ""
    property string text: ""
    property string description: ""
    property bool checked: false
    property bool isLast: false
    signal toggled(bool checked)

    Layout.fillWidth: true
    implicitHeight: 48
    color: mouseArea.containsMouse ? "#2f3439" : "transparent"
    radius: 4

    Behavior on color { ColorAnimation { duration: 120 } }

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

        // Plasma 6 style switch
        Rectangle {
            id: track
            width: 40
            height: 22
            radius: 11
            color: root.checked ? "#3daee9" : "#31363b"
            border.color: mouseArea.containsMouse ? "#3daee9" : "#474e54"
            border.width: 1

            Behavior on color { ColorAnimation { duration: 150 } }

            Rectangle {
                id: thumb
                width: 16
                height: 16
                radius: 8
                y: 3
                x: root.checked ? parent.width - width - 3 : 3
                color: "#eff0f1"

                Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
            }
        }
    }

    // Divider line
    Rectangle {
        visible: !root.isLast
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#31363b"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.checked = !root.checked;
            root.toggled(root.checked);
        }
    }
}
