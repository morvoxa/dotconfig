import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
PanelWindow {
    id: barWindow
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 0
        left: 0
        right: 0
    }
    implicitHeight: 28
    property string activeWorkspace: "1"
    Process {
        id: hyprctl
        command: ["hyprctl", "activeworkspace", "-j"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(this.text.trim());
                    if (data && data.id) {
                        barWindow.activeWorkspace = data.id.toString();
                    }
                } catch(e) {}
            }
        }
    }
    Timer {
        interval: 300
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            hyprctl.running = true
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            timeLabel.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
    }
    Rectangle {
        height: 24
        width: contentRow.width + 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: "#141218"
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: height / 2
        bottomRightRadius: height / 2
        border.color: "#79747e"
        border.width: 1
        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 14
            Row {
                spacing: 6
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "󰍹"
                    color: "#938f99"
                    font.pixelSize: 12
                    font.bold: true
                    font.family: "JetBrains Mono Nerd Font"
                }
                Text {
                    text: barWindow.activeWorkspace
                    color: "#d0bcff"
                    font.pixelSize: 11
                    font.bold: true
                    font.family: "JetBrains Mono Nerd Font"
                }
            }
            Rectangle {
                width: 1
                height: 10
                color: "#79747e"
                anchors.verticalCenter: parent.verticalCenter
            }
            Row {
                spacing: 6
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: ""
                    color: "#938f99"
                    font.pixelSize: 12
                    font.bold: true
                    font.family: "JetBrains Mono Nerd Font"
                }
                Text {
                    id: timeLabel
                    color: "#e6e1e5"
                    font.pixelSize: 11
                    font.bold: true
                    font.family: "JetBrains Mono Nerd Font"
                }
            }
        }
    }
}
