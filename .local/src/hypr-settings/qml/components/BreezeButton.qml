import QtQuick

Rectangle {
    id: root
    property string text: ""
    property bool primary: false
    property bool danger: false
    signal clicked()

    implicitWidth: textItem.implicitWidth + 24
    implicitHeight: 30
    radius: 4

    color: !root.enabled ? "#25282b" :
           mouseArea.pressed ? (root.danger ? "#b53744" : (root.primary ? "#2c8dbf" : "#25282b")) :
           mouseArea.containsMouse ? (root.danger ? "#e05362" : (root.primary ? "#47b8f2" : "#3b4248")) :
           (root.danger ? "#da4453" : (root.primary ? "#3daee9" : "#31363b"))

    border.color: !root.enabled ? "#31363b" :
                  (root.primary || root.danger) ? "transparent" :
                  (mouseArea.containsMouse ? "#3daee9" : "#474e54")
    border.width: 1

    Text {
        id: textItem
        anchors.centerIn: parent
        text: root.text
        font.pixelSize: 12
        font.bold: root.primary || root.danger
        color: !root.enabled ? "#5d6368" : "#eff0f1"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (root.enabled) root.clicked();
        }
    }
}
