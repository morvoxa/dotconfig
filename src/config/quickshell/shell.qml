import QtQuick
import QtQuick.Layouts
import QtQuick.Effects 
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    
    height: 28 
    color: "transparent"

    property var workspaceList: []
    property string activeAppTitle: "Desktop"

    // ================= MANAJEMEN DATA NIRI WORKSPACE & WINDOWS =================
    Process {
        id: niriWorkspaceProc
        command: ["niri", "msg", "-j", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var workspaces = JSON.parse(this.text);
                    var tempList = [];
                    for (var i = 0; i < workspaces.length; i++) {
                        tempList.push({
                            "name": workspaces[i].name ? workspaces[i].name : workspaces[i].idx.toString(),
                            "isActive": workspaces[i].is_active === true
                        });
                    }
                    root.workspaceList = tempList;
                } catch(e) {}
            }
        }
    }

    Process {
        id: niriWindowProc
        command: ["niri", "msg", "-j", "windows"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var windows = JSON.parse(this.text);
                    var foundActive = false;
                    
                    if (windows && windows.length > 0) {
                        for (var i = 0; i < windows.length; i++) {
                            if (windows[i].is_focused === true || windows[i].focused === true || windows[i].is_active === true) {
                                var rawTitle = windows[i].title ? windows[i].title : (windows[i].app_id ? windows[i].app_id : "Window");
                                root.activeAppTitle = rawTitle.trim();
                                foundActive = true;
                                break;
                            }
                        }
                    }
                    if (!foundActive) {
                        root.activeAppTitle = "Desktop";
                    }
                } catch(e) {
                    root.activeAppTitle = "Desktop";
                }
            }
        }
    }

    Timer {
        interval: 150 
        running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            niriWorkspaceProc.running = false
            niriWorkspaceProc.running = true
            
            niriWindowProc.running = false
            niriWindowProc.running = true

            clockText.text = Qt.formatDateTime(new Date(), "hh:mm")
        }
    }

    // ================= KAPSUL MINIMALIS MELAYANG =================
    MultiEffect {
        source: capsuleContainer
        anchors.fill: capsuleContainer
        shadowEnabled: true
        shadowColor: "#26000000" // Bayangan ambient halus khas UI premium
        shadowBlur: 0.5
        shadowVerticalOffset: 2
        shadowHorizontalOffset: 0
    }

    Rectangle {
        id: capsuleContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2 

        width: masterRow.width + 24
        height: 22
        radius: height / 2 

        color: "#d9111215" // Efek Frosted Glass gelap pekat (90% Opacity)
        border.width: 0    // Tanpa border kaku agar terlihat modern
        border.color: "transparent"

        Behavior on width {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Row {
            id: masterRow
            anchors.centerIn: parent
            spacing: 12 

            // --- [KIRI] Title App ---
            Text {
                id: appText
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    var currentTitle = root.activeAppTitle;
                    if (currentTitle.length > 20) {
                        return currentTitle.substring(0, 20) + "...";
                    } else {
                        return currentTitle;
                    }
                }
                color: "#e5e7eb" 
                font.bold: true
                font.pixelSize: 11
                font.family: "JetBrains Mono"
            }

            // --- SEPARATOR KIRI ---
            Rectangle {
                width: 1
                height: 10
                color: "#ffffff"
                opacity: 0.08 
                anchors.verticalCenter: parent.verticalCenter
            }

            // --- [TENGAH] Workspace Indicators ---
            Row {
                id: workspaceRow
                spacing: 6
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: root.workspaceList

                    Rectangle {
                        width: modelData.isActive ? 16 : 8
                        height: 8
                        radius: height / 2
                        color: modelData.isActive ? "#38bdf8" : "#374151" // Aksen Cyan modern untuk yang aktif

                        Behavior on width {
                            NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name
                            color: "#0f172a" 
                            font.bold: true
                            font.pixelSize: 7
                            visible: modelData.isActive && width > 10
                        }
                    }
                }
            }

            // --- SEPARATOR KANAN ---
            Rectangle {
                width: 1
                height: 10
                color: "#ffffff"
                opacity: 0.08 
                anchors.verticalCenter: parent.verticalCenter
            }

            // --- [KANAN] Jam Digital ---
            Text {
                id: clockText
                anchors.verticalCenter: parent.verticalCenter
                text: "--:--"
                color: "#e5e7eb"
                font.bold: true
                font.pixelSize: 11
                font.family: "JetBrains Mono"
            }
        }
    }
}
