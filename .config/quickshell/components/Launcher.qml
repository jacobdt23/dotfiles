import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; left: true; right: true; bottom: true }

    color: "transparent"
    visible: rootScope.launcherOpen

    MouseArea {
        anchors.fill: parent
        onClicked: rootScope.launcherOpen = false
    }

    ListModel { id: appModel }
    ListModel { id: filteredModel }

    Process {
        id: appProc
        command: ["sh", "-c", "grep -h '^Name=' /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null | cut -d= -f2- | sort -u"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed !== "") {
                    appModel.append({ appName: trimmed });
                    filteredModel.append({ appName: trimmed });
                }
            }
        }
    }

    function filterApps(query) {
        filteredModel.clear();
        for (let i = 0; i < appModel.count; i++) {
            let item = appModel.get(i);
            if (item.appName.toLowerCase().includes(query.toLowerCase())) {
                filteredModel.append({ appName: item.appName });
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 500
        height: 450
        color: "#1a1b26"
        border.color: "#3b4261"
        border.width: 1
        radius: 12

        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "Application Launcher"
                color: "#7aa2f7"
                font.bold: true
                font.pixelSize: 14
            }

            Rectangle {
                Layout.fillWidth: true
                height: 35
                color: "#24283b"
                border.color: "#3b4261"
                border.width: 1
                radius: 6

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: 8
                    color: "#c0caf5"
                    focus: true
                    verticalAlignment: TextInput.AlignVCenter
                    onTextChanged: filterApps(text)
                }

                Text {
                    anchors.fill: parent
                    anchors.margins: 8
                    verticalAlignment: Text.AlignVCenter
                    text: "Type to search apps..."
                    color: "#565f89"
                    visible: searchInput.text.length === 0
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: filteredModel

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 40
                    color: launcherMouse.containsMouse ? "#3b4261" : "#24283b"
                    border.color: "#3b4261"
                    border.width: 1
                    radius: 6

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        text: appName
                        color: "#c0caf5"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: launcherMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            rootScope.launcherOpen = false;
                            Quickshell.sh("gtk-launch \"" + appName + "\" &");
                        }
                    }
                }
            }
        }
    }
}
