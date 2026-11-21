import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property var sections: []
  readonly property string home: Quickshell.env("HOME")

  Process {
    id: loader
    command: [root.home + "/.local/bin/conky-keybinds-format", "--json"]
    running: true
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        try {
          var parsed = JSON.parse(text)
          if (Array.isArray(parsed) && parsed.length > 0) {
            root.sections = parsed
          }
        } catch (e) {}
      }
    }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: {
      if (!loader.running) loader.running = true
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "conky-keybinds-bg"
      WlrLayershell.layer: WlrLayer.Bottom
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      mask: Region {}

      Rectangle {
        visible: root.sections.length > 0
        anchors.right: parent.right
        anchors.rightMargin: 22
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -18
        width: 304
        height: Math.min(cardCol.implicitHeight + 28, parent.height - 130)
        radius: 14
        color: "#1a1b26"
        border.width: 1
        border.color: "#7aa2f7"

        Column {
          id: cardCol
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.leftMargin: 16
          anchors.rightMargin: 16
          spacing: 10

          // Header
          Item {
            width: parent.width
            height: 20

            Text {
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: "  KEYBINDINGS"
              color: "#7aa2f7"
              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 12
              font.bold: true
              font.letterSpacing: 1.0
            }

            Text {
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              text: "SUP+SHF+K all"
              color: "#565f89"
              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 10
            }
          }

          Rectangle {
            width: parent.width
            height: 1
            color: "#414868"
          }

          // Sections
          Repeater {
            model: root.sections

            Column {
              required property var modelData
              width: cardCol.width
              spacing: 4

              // Section title with subtle accent dot
              Row {
                spacing: 6
                topPadding: 2
                bottomPadding: 2

                Rectangle {
                  width: 6
                  height: 6
                  radius: 3
                  color: modelData.color || "#7aa2f7"
                  anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                  text: modelData.title || ""
                  color: modelData.color || "#7aa2f7"
                  font.family: "JetBrainsMono Nerd Font"
                  font.pixelSize: 10
                  font.bold: true
                  font.letterSpacing: 1.2
                }
              }

              // Section bindings
              Repeater {
                model: modelData.items || []

                Item {
                  required property var modelData
                  width: cardCol.width
                  height: 20

                  Rectangle {
                    id: keyPill
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: keyLabel.implicitWidth + 12
                    height: 18
                    radius: 4
                    color: "#24283b"
                    border.width: 1
                    border.color: "#414868"

                    Text {
                      id: keyLabel
                      anchors.centerIn: parent
                      text: modelData.key || ""
                      color: "#7dcfff"
                      font.family: "JetBrainsMono Nerd Font"
                      font.pixelSize: 10
                      font.bold: true
                    }
                  }

                  Text {
                    anchors.right: parent.right
                    anchors.left: keyPill.right
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideRight
                    text: modelData.desc || ""
                    color: "#c0caf5"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
