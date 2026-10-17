import QtQuick
import QtQuick.Layouts
import QtQuick.Effects 
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray 

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    
    height: 34 
    color: "transparent"

    // Memastikan bar mendapat prioritas lapisan interaksi eksklusif dari compositor Niri
    exclusionMode: ExclusionMode.Exclusive

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
        shadowColor: "#26000000" 
        shadowBlur: 0.5
        shadowVerticalOffset: 2
        shadowHorizontalOffset: 0
    }

    Rectangle {
        id: capsuleContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2 

        width: masterRow.width + 28 
        height: 28 
        radius: height / 2 

        color: "#d9111215" 
        border.width: 0    
        border.color: "transparent"

        Behavior on width {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Row {
            id: masterRow
            anchors.centerIn: parent
            spacing: 14 

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
                font.pixelSize: 12 
                font.family: "JetBrains Mono"
            }

            // --- SEPARATOR ---
            Rectangle {
                width: 1
                height: 12 
                color: "#ffffff"
                opacity: 0.08 
                anchors.verticalCenter: parent.verticalCenter
            }

            // --- [TENGAH] Workspace Indicators ---
            Row {
                id: workspaceRow
                spacing: 8 
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: root.workspaceList

                    Rectangle {
                        width: modelData.isActive ? 22 : 10 
                        height: 10 
                        radius: height / 2
                        color: modelData.isActive ? "#38bdf8" : "#374151" 

                        Behavior on width {
                            NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name
                            color: "#0f172a" 
                            font.bold: true
                            font.pixelSize: 9 
                            visible: modelData.isActive && width > 14
                        }
                    }
                }
            }

            // --- SEPARATOR ---
            Rectangle {
                width: 1
                height: 12 
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
                font.pixelSize: 12 
                font.family: "JetBrains Mono"
            }

            // --- SEPARATOR (Hanya muncul jika ada ikon System Tray) ---
            Rectangle {
                width: 1
                height: 12 
                color: "#ffffff"
                opacity: 0.08 
                anchors.verticalCenter: parent.verticalCenter
                visible: systrayRow.count > 0
            }

            // --- [PALING KANAN] System Tray ---
            Row {
                id: systrayRow
                spacing: 8 
                anchors.verticalCenter: parent.verticalCenter
                property int count: systrayRepeater.count

                Repeater {
                    id: systrayRepeater
                    model: SystemTray.items

                    Item {
                        id: trayItemWrapper
                        width: 16  
                        height: 16 
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Image {
                            anchors.fill: parent
                            source: modelData.icon ? modelData.icon : ""
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            id: trayMouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            
                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) {
                                    // Klik Kiri: Jalankan aktivasi utama aplikasi
                                    modelData.activate();
                                } else if (mouse.button === Qt.RightButton) {
                                    // Klik Kanan: Gunakan engine resmi Quickshell untuk memicu jendela konteks menu
                                    if (modelData.hasMenu && modelData.menu) {
                                        SystemTray.itemOpener.open(modelData.menu, trayMouseArea);
                                    } else {
                                        // Mekanisme cadangan jika aplikasi menggunakan contextMenu X11 lama
                                        modelData.contextMenu();
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
