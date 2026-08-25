import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: topBarRoot
    required property var screen
    required property var rootScope

    anchors.fill: parent

    property string cpuUsage: "--%"
    property string memUsage: "--%"
    property string diskUsage: "--%"
    property string volLevel: "--%"
    property int activeWsId: 1

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            diskProc.running = true;
            volProc.running = true;
        }
    }

    Timer {
        interval: 250
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: wsProc.running = true
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "top -bn1 | awk '/Cpu/ {for(i=1;i<=NF;i++) if($i ~ /id/) print int(100 - $(i-1))}'"]
        stdout: SplitParser { onRead: data => { if (data.trim() !== "") cpuUsage = data.trim() + "%"; } }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | awk '/^Mem:/ {print int($3/$2 * 100)}'"]
        stdout: SplitParser { onRead: data => { if (data.trim() !== "") memUsage = data.trim() + "%"; } }
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "df / --output=pcent | tail -1 | tr -d ' %\\t'"]
        stdout: SplitParser { onRead: data => { if (data.trim() !== "") diskUsage = data.trim() + "%"; } }
    }

    Process {
        id: volProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'"]
        stdout: SplitParser { onRead: data => { if (data.trim() !== "") volLevel = data.trim() + "%"; } }
    }

    Process {
        id: wsProc
        command: ["sh", "-c", "hyprctl activeworkspace -j | jq .id"]
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim());
                if (!isNaN(val)) activeWsId = val;
            }
        }
    }

    Process { id: actionExec }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        RowLayout {
            spacing: 6
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            Repeater {
                model: {
                    let screenIndex = Quickshell.screens.indexOf(screen);
                    return screenIndex === 0 ? [1, 2, 3, 4, 5] : [6, 7, 8, 9, 10];
                }

                delegate: Rectangle {
                    required property var modelData
                    property bool isFocused: (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === modelData) || (activeWsId === modelData)

                    width: isFocused ? 22 : 18
                    height: 20
                    color: wsMouse.containsMouse ? "#3b4261" : (isFocused ? "#7aa2f7" : "#24283b")
                    radius: 4

                    Behavior on width { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: parent.isFocused ? "#1a1b26" : "#c0caf5"
                        font.pixelSize: 11
                        font.bold: true
                    }

                    MouseArea {
                        id: wsMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: actionExec.exec(["hyprctl", "dispatch", "workspace", modelData.toString()])
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            height: 24
            implicitWidth: clockRow.width + 16
            color: clockArea.containsMouse ? "#3b4261" : "#24283b"
            radius: 6

            Behavior on color { ColorAnimation { duration: 150 } }

            RowLayout {
                id: clockRow
                anchors.centerIn: parent
                spacing: 6

                Text {
                    id: clockText
                    color: "#bb9af7"
                    font.pixelSize: 12
                    font.bold: true
                    text: Qt.formatDateTime(new Date(), "MMM d  hh:mm AP")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "MMM d  hh:mm AP")
                    }
                }
            }

            MouseArea {
                id: clockArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: calendarPopup.visible ? calendarPopup.close() : calendarPopup.open()
            }

            Popup {
                id: calendarPopup
                y: parent.height + 6
                x: (parent.width - width) / 2
                width: 240
                height: 220
                padding: 0
                background: Rectangle {
                    color: "#1a1b26"
                    border.color: "#3b4261"
                    border.width: 1
                    radius: 8
                }

                contentItem: Item {
                    anchors.fill: parent
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Qt.formatDateTime(new Date(), "MMMM yyyy")
                            color: "#bb9af7"
                            font.bold: true
                            font.pixelSize: 13
                        }

                        GridLayout {
                            columns: 7
                            columnSpacing: 6
                            rowSpacing: 6
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                                Text {
                                    text: modelData
                                    color: "#565f89"
                                    font.pixelSize: 10
                                    font.bold: true
                                    Layout.preferredWidth: 24
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            Repeater {
                                model: {
                                    let d = new Date();
                                    let year = d.getFullYear();
                                    let month = d.getMonth();
                                    let firstDay = new Date(year, month, 1).getDay();
                                    let totalDays = new Date(year, month + 1, 0).getDate();
                                    let arr = [];
                                    for (let i = 0; i < firstDay; i++) arr.push("");
                                    for (let i = 1; i <= totalDays; i++) arr.push(i.toString());
                                    return arr;
                                }
                                delegate: Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 4
                                    color: (modelData === new Date().getDate().toString()) ? "#7aa2f7" : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        color: (modelData === new Date().getDate().toString()) ? "#1a1b26" : "#c0caf5"
                                        font.pixelSize: 11
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            Rectangle {
                height: 24
                implicitWidth: cpuText.width + 12
                color: cpuArea.containsMouse ? "#3b4261" : "#24283b"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text { id: cpuText; anchors.centerIn: parent; text: "CPU: " + cpuUsage; color: "#7aa2f7"; font.pixelSize: 11; font.bold: true }

                MouseArea {
                    id: cpuArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: actionExec.exec(["alacritty", "-e", "btm"])
                }
            }

            Rectangle {
                height: 24
                implicitWidth: memText.width + 12
                color: memArea.containsMouse ? "#3b4261" : "#24283b"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text { id: memText; anchors.centerIn: parent; text: "MEM: " + memUsage; color: "#bb9af7"; font.pixelSize: 11; font.bold: true }

                MouseArea {
                    id: memArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: actionExec.exec(["alacritty", "-e", "btm"])
                }
            }

            Rectangle {
                height: 24
                implicitWidth: diskText.width + 12
                color: diskArea.containsMouse ? "#3b4261" : "#24283b"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text { id: diskText; anchors.centerIn: parent; text: "DISK: " + diskUsage; color: "#e0af68"; font.pixelSize: 11; font.bold: true }

                MouseArea {
                    id: diskArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: actionExec.exec(["alacritty", "-e", "ncdu"])
                }
            }

            Rectangle {
                height: 24
                implicitWidth: volText.width + 12
                color: volArea.containsMouse ? "#3b4261" : "#24283b"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text { id: volText; anchors.centerIn: parent; text: "VOL: " + volLevel; color: "#7dcfff"; font.pixelSize: 11; font.bold: true }

                MouseArea {
                    id: volArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: actionExec.exec(["pavucontrol"])
                }
            }

            Repeater {
                model: SystemTray.items

                delegate: Rectangle {
                    required property var modelData
                    width: 24
                    height: 24
                    color: trayMouse.containsMouse ? "#3b4261" : "#24283b"
                    radius: 6

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Image {
                        anchors.centerIn: parent
                        width: 14
                        height: 14
                        source: modelData.icon
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: trayMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.RightButton) {
                                modelData.display(parent, mouse.x, mouse.y);
                            } else {
                                modelData.activate();
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: 24
                height: 24
                color: powerArea.containsMouse ? "#3b4261" : "#24283b"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "⏻"
                    color: "#f7768e"
                    font.pixelSize: 13
                }

                MouseArea {
                    id: powerArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: actionExec.exec(["bash", "/home/jacob/.config/rofi/powermenu.sh"])
                }
            }
        }
    }
}
