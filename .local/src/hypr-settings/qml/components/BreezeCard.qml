import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    default property alias content: innerLayout.data
    property string title: ""
    property string subtitle: ""

    color: "#2a2e32"
    border.color: "#31363b"
    border.width: 1
    radius: 6

    implicitHeight: mainCol.implicitHeight + 28
    implicitWidth: 400

    ColumnLayout {
        id: mainCol
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        Text {
            visible: root.title !== ""
            text: root.title
            font.pixelSize: 14
            font.bold: true
            color: "#eff0f1"
        }

        Text {
            visible: root.subtitle !== ""
            text: root.subtitle
            font.pixelSize: 11
            color: "#7f8c8d"
        }

        ColumnLayout {
            id: innerLayout
            Layout.fillWidth: true
            spacing: 8
        }
    }
}
