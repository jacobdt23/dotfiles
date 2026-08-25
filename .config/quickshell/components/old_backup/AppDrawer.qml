import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    required property var screen
    required property var rootScope

    screen: screen
    anchors { top: true; bottom: true; left: true; right: true }
    visible: rootScope.drawerOpen
    color: "#cc1a1b26"
    WlrLayershell.layer: WlrLayer.Top

    property string searchQuery: ""

    onVisibleChanged: {
        if (visible) {
            searchField.text = "";
            searchQuery = "";
            searchField.forceActiveFocus();
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: rootScope.drawerOpen = false
    }

    Rectangle {
        anchors.centerIn: parent
        width: 700
        height: 550
        color: "#1a1b26"
        border.color: "#24283b"
        border.width: 1
        radius: 12

        MouseArea {
            anchors.fill: parent
            onClicked: (mouse) => mouse.accepted = true
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 25

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 450
                spacing: 15

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Type to search apps..."
                    color: "#c0caf5"
                    placeholderTextColor: "#565f89"
                    focus: true
                    onTextChanged: searchQuery = text.toLowerCase()
                    background: Rectangle {
                        color: "#24283b"
                        radius: 6
                    }
                }
            }

            GridView {
                id: appGrid
                Layout.preferredWidth: 620
                Layout.preferredHeight: 340
                Layout.alignment: Qt.AlignHCenter
                cellWidth: 124
                cellHeight: 110
                clip: true

                model: DesktopEntries.applications.values.filter(app => 
                    app.name.toLowerCase().includes(searchQuery)
                )

                delegate: Item {
                    width: 114
                    height: 100

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 56
                            height: 56
                            color: appMouse.containsMouse ? "#3b4261" : "#24283b"
                            radius: 14

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Image {
                                anchors.centerIn: parent
                                width: 32
                                height: 32
                                source: modelData.icon ? "image://icon/" + modelData.icon : ""
                                sourceSize.width: 32
                                sourceSize.height: 32
                                visible: status === Image.Ready
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.name ? modelData.name.substring(0, 1) : "?"
                                color: "#7aa2f7"
                                font.pixelSize: 20
                                font.bold: true
                                visible: parent.children[0].status !== Image.Ready
                            }

                            MouseArea {
                                id: appMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    modelData.execute();
                                    rootScope.drawerOpen = false;
                                }
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: 100
                            text: modelData.name
                            color: "#c0caf5"
                            font.pixelSize: 11
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            Button {
                text: "Close Drawer"
                Layout.alignment: Qt.AlignHCenter
                onClicked: rootScope.drawerOpen = false
            }
        }
    }
}
