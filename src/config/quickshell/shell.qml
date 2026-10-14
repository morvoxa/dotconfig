import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Hyprland
import QtQuick

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 22
    color: "#ffffff"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 0
        color: "#e0e0e0"
    }

    // --- BAGIAN KIRI ---
    Row {
        anchors {
            left: parent.left
            leftMargin: 4
            verticalCenter: parent.verticalCenter
        }
        spacing: 6

        // 1. Button Launcher (Icon )
        Rectangle {
            width: 24
            height: 18
            radius: 3
            color: launcherMouse.containsMouse ? "#33000000" : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                color: "#11111b"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                font.bold: true
                text: ""
            }

            MouseArea {
                id: launcherMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execDetached(["hyprlauncher"]) 
                }
            }
        }

        // 2. Button Workspace Indicator
        Rectangle {
            width: wsText.implicitWidth + 8
            height: 18
            radius: 3
            color: wsMouse.containsMouse ? "#33000000" : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                id: wsText
                anchors.centerIn: parent
                color: "#11111b"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.bold: true
                
                text: {
                    let focused = Hyprland.focusedWorkspace;
                    if (focused) {
                        return "󰍹 " + focused.name;
                    }
                    return "󰍹 " + "1";
                }
            }

            MouseArea {
                id: wsMouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        // 3. Active Window Title
        Rectangle {
            width: titleText.implicitWidth + 8
            height: 18
            radius: 3
            color: titleMouse.containsMouse ? "#33000000" : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                id: titleText
                anchors.centerIn: parent
                color: "#313244"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.bold: true
                
                text: {
                    let active = ToplevelManager.activeToplevel;
                    if (active && active.title) {
                        return active.title.split(" - ")[0]; 
                    }
                    return "Hyprland";
                }
            }

            MouseArea {
                id: titleMouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }

    // --- BAGIAN TENGAH (CENTER CLOCK) ---
    Row {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: clockText.implicitWidth + 10
            height: 18
            radius: 3
            color: clockMouse.containsMouse ? "#33000000" : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                id: clockText
                anchors.centerIn: parent
                color: "#11111b"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.bold: true
                text: "12:00"

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        let date = new Date();
                        let hours = String(date.getHours()).padStart(2, '0');
                        let minutes = String(date.getMinutes()).padStart(2, '0');
                        clockText.text = hours + ":" + minutes;
                    }
                }
            }

            MouseArea {
                id: clockMouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }

    // --- BAGIAN KANAN ---
    Row {
        anchors {
            right: parent.right
            rightMargin: 4
            verticalCenter: parent.verticalCenter
        }
        spacing: 4

        // Native Systray Items dengan efek tombol
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Repeater {
                model: SystemTray.items

                Item {
                    required property SystemTrayItem modelData

                    implicitWidth: 20
                    implicitHeight: 18
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: 3
                        color: trayItemMouse.containsMouse ? "#33000000" : "transparent"

                        Behavior on color { ColorAnimation { duration: 150 } }

                        Image {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            source: modelData.icon
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    MouseArea {
                        id: trayItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                if (modelData.hasMenu) {
                                    modelData.menu.open();
                                }
                            } else {
                                modelData.activate();
                            }
                        }
                    }
                }
            }
        }

        // Power/Logout Button (Icon 󰗼)
        Rectangle {
            width: 24
            height: 18
            radius: 3
            color: logoutMouse.containsMouse ? "#33000000" : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                color: "#11111b"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 15
                font.bold: true
                text: "󰗼"
            }

            MouseArea {
                id: logoutMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execDetached(["wlogout"]) 
                }
            }
        }
    }
}
