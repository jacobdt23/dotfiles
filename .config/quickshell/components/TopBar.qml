import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var targetScreen
    required property var rootScope

    screen: targetScreen
    anchors { top: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Top
    implicitHeight: 35
    exclusiveZone: 35
    color: "#1a1b26"

    property string cpuUsage: "--%"
    property string memUsage: "--%"
    property string diskUsage: "--%"

    Process { id: topBarExec }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            diskProc.running = true;
        }
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

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Workspaces Module
        RowLayout {
            spacing: 6
            Repeater {
                model: {
                    let screenIndex = Quickshell.screens.indexOf(targetScreen);
                    return screenIndex === 0 ? [1, 2, 3, 4, 5] : [6, 7, 8, 9, 10];
                }

                Rectangle {
                    required property var modelData
                    property bool isFocused: (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === modelData)
                    property bool isHovered: wsMouse.containsMouse

                    height: 24
                    width: isFocused ? 28 : 24
                    radius: 6
                    color: isFocused ? "#7aa2f7" : (isHovered ? "#3b4261" : "#24283b")
                    border.color: "#3b4261"
                    border.width: 1

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
                        onClicked: topBarExec.exec(["hyprctl", "dispatch", "workspace", modelData.toString()])
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Clock Module wrapped in a styled box
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            height: 24
            implicitWidth: clockText.width + 20
            radius: 6
            color: clockArea.containsMouse ? "#3b4261" : "#24283b"
            border.color: "#3b4261"
            border.width: 1
            z: 10

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                id: clockText
                anchors.centerIn: parent
                color: "#c0caf5"
                font.bold: true
                font.pixelSize: 11
                text: Qt.formatDateTime(new Date(), "MMM d • hh:mm AP")
                Timer {
                    interval: 1000; running: true; repeat: true
                    onTriggered: parent.text = Qt.formatDateTime(new Date(), "MMM d • hh:mm AP")
                }
            }

            MouseArea {
                id: clockArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    let w = rootScope.calendarOpen;
                    rootScope.closeAll();
                    rootScope.calendarOpen = !w;
                }
            }
        }

        Item { Layout.fillWidth: true }

        // 1. System Tray Items (Placed first on the right)
        RowLayout {
            spacing: 8

            Repeater {
                model: SystemTray.items

                delegate: Rectangle {
                    required property var modelData
                    width: 24; height: 24; radius: 6
                    color: trayMouse.containsMouse ? "#3b4261" : "#24283b"
                    border.color: "#3b4261"; border.width: 1

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Image {
                        anchors.centerIn: parent
                        width: 14; height: 14
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
        }

        // 2. System Stats Modules (CPU, MEM, DISK)
        RowLayout {
            spacing: 8

            Rectangle {
                height: 24; implicitWidth: cpuText.width + 16; radius: 6
                color: cpuArea.containsMouse ? "#3b4261" : "#24283b"
                border.color: "#3b4261"; border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }
                Text { id: cpuText; anchors.centerIn: parent; text: "CPU: " + cpuUsage; color: "#7aa2f7"; font.pixelSize: 11; font.bold: true }
                MouseArea { id: cpuArea; anchors.fill: parent; hoverEnabled: true; onClicked: topBarExec.exec(["alacritty", "-e", "btm"]) }
            }

            Rectangle {
                height: 24; implicitWidth: memText.width + 16; radius: 6
                color: memArea.containsMouse ? "#3b4261" : "#24283b"
                border.color: "#3b4261"; border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }
                Text { id: memText; anchors.centerIn: parent; text: "MEM: " + memUsage; color: "#bb9af7"; font.pixelSize: 11; font.bold: true }
                MouseArea { id: memArea; anchors.fill: parent; hoverEnabled: true; onClicked: topBarExec.exec(["alacritty", "-e", "btm"]) }
            }

            Rectangle {
                height: 24; implicitWidth: diskText.width + 16; radius: 6
                color: diskArea.containsMouse ? "#3b4261" : "#24283b"
                border.color: "#3b4261"; border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }
                Text { id: diskText; anchors.centerIn: parent; text: "DISK: " + diskUsage; color: "#e0af68"; font.pixelSize: 11; font.bold: true }
                MouseArea { id: diskArea; anchors.fill: parent; hoverEnabled: true; onClicked: topBarExec.exec(["alacritty", "-e", "ncdu"]) }
            }
        }

        // 3. Notification Toggle Button
        Rectangle {
            width: 24; height: 24; radius: 6
            color: notifMouse.containsMouse ? "#3b4261" : "#24283b"
            border.color: "#3b4261"; border.width: 1

            Behavior on color { ColorAnimation { duration: 150 } }

            Text { 
                anchors.centerIn: parent; 
                text: "󰂚"; 
                color: "#7aa2f7" 
                font.pixelSize: 11
            }

            MouseArea {
                id: notifMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    let n = rootScope.notificationsOpen;
                    rootScope.closeAll();
                    rootScope.notificationsOpen = !n;
                }
            }
        }

        // 4. Power Menu Button
        Rectangle {
            width: 24; height: 24; radius: 6
            color: powerMouse.containsMouse ? "#3b4261" : "#24283b"
            border.color: "#3b4261"; border.width: 1

            Behavior on color { ColorAnimation { duration: 150 } }

            Text { 
                anchors.centerIn: parent; 
                text: "⏻"; 
                color: "#f7768e" 
                font.pixelSize: 11
            }

            MouseArea {
                id: powerMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    rootScope.closeAll()
                    rootScope.powerMenuOpen = true
                }
            }
        }
    }
}
