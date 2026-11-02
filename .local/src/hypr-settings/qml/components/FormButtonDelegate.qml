import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property string iconText: ""
    property string text: ""
    property string description: ""
    property string statusText: ""
    property bool statusPositive: false
    property string buttonText: ""
    property bool buttonDanger: false
    property bool showSecondaryButton: false
    property string secondaryButtonText: ""
    property bool isLast: false

    signal primaryClicked()
    signal secondaryClicked()

    Layout.fillWidth: true
    implicitHeight: 52
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
            font.pixelSize: 18
            Layout.preferredWidth: 26
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

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

        // Status Badge Pill
        Rectangle {
            visible: root.statusText !== ""
            implicitWidth: statusLabel.implicitWidth + 14
            implicitHeight: 22
            radius: 11
            color: root.statusPositive ? "#27ae60" : "#3b4248"

            Text {
                id: statusLabel
                anchors.centerIn: parent
                text: root.statusText
                font.pixelSize: 10
                font.bold: true
                color: "#ffffff"
            }
        }

        // Primary Action Button
        BreezeButton {
            visible: root.buttonText !== ""
            text: root.buttonText
            danger: root.buttonDanger
            primary: !root.buttonDanger
            onClicked: root.primaryClicked()
        }

        // Secondary Action Button (e.g. Forget/Remove)
        BreezeButton {
            visible: root.showSecondaryButton
            text: root.secondaryButtonText
            onClicked: root.secondaryClicked()
        }
    }

    // Divider
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
    }
}
