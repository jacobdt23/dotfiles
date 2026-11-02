import QtQuick

Row {
    id: root
    property string text: ""
    property bool checked: false
    signal toggled(bool checked)

    spacing: 10

    Rectangle {
        id: track
        width: 38
        height: 20
        radius: 10
        color: root.checked ? "#3daee9" : "#31363b"
        border.color: mouseArea.containsMouse ? "#3daee9" : "#474e54"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            id: thumb
            width: 14
            height: 14
            radius: 7
            y: 3
            x: root.checked ? parent.width - width - 3 : 3
            color: "#eff0f1"

            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
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

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        font.pixelSize: 13
        color: "#eff0f1"

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.checked = !root.checked;
                root.toggled(root.checked);
            }
        }
    }
}
