import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    default property alias content: cardLayout.data
    property string title: ""

    Layout.fillWidth: true
    implicitHeight: mainCol.implicitHeight + 20
    color: "#2a2e32"
    border.color: "#31363b"
    border.width: 1
    radius: 8

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 14
        spacing: 8

        Text {
            visible: root.title !== ""
            text: root.title
            font.pixelSize: 13
            font.bold: true
            color: "#3daee9" // Plasma accent blue for section headers
            Layout.leftMargin: 2
            Layout.bottomMargin: 2
        }

        ColumnLayout {
            id: cardLayout
            Layout.fillWidth: true
            spacing: 0
        }
    }
}
