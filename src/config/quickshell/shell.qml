import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    property string currentTime: ""
    property string networkStatus: "OFF"

    // 1. IPC WORKSPACES & JUDUL JENDELA (Metode Terpusat & Paling Stabil)
    Process {
        id: niriIpc
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        onRunningChanged: if (!running) running = true

        property var list: []
        property var activeId: null
        property string activeTitle: ""

        stdout: SplitParser {
            onRead: (line) => {
                try {
                    const event = JSON.parse(line.trim());
                    const eventType = Object.keys(event)[0];
                    const data = event[eventType];

                    const handlers = {
                        WorkspaceActivated: () => {
                            niriIpc.activeId = data.id;
                        },
                        WorkspacesChanged: () => {
                            niriIpc.list = data.workspaces.sort((a, b) => a.idx - b.idx);
                            const active = niriIpc.list.find(w => w.is_active || w.is_focused);
                            if (active) niriIpc.activeId = active.id;
                        }
                    };

                    if (handlers[eventType]) handlers[eventType]();
                } catch(e) {}
            }
        }
    }

    // 2. KONTROLLER AMBIL JUDUL WINDOW SECARA BERKALA
    Process {
        id: niriFocusedWindow
        command: ["niri", "msg", "-j", "focused-window"]
        running: false

        stdout: SplitParser {
            onRead: (line) => {
                try {
                    const reply = JSON.parse(line.trim());
                    const winData = reply.Ok?.FocusedWindow || reply;
                    niriIpc.activeTitle = winData?.title ?? "";
                } catch(e) {
                    niriIpc.activeTitle = "";
                }
            }
        }
        onRunningChanged: if (!running) running = false
    }

    // 3. KONTROLLER STATUS & TIPE JARINGAN (Versi Refaktor - Anti Broken)
    Process {
        id: checkNetwork
        command: ["sh", "-c", "nmcli -t -f TYPE,NAME connection show --active | head -n1"]
        running: false

        stdout: SplitParser {
            onRead: (line) => {
                const rawData = line.trim();
                if (rawData.length > 0 && rawData.includes(":")) {
                    const separatorIndex = rawData.indexOf(":");
                    const type = rawData.substring(0, separatorIndex);
                    const name = rawData.substring(separatorIndex + 1);

                    if (type === "802-11-wireless") {
                        networkStatus = "WIFI: " + name;
                    } else if (type === "802-3-ethernet" || type.includes("ethernet")) {
                        networkStatus = "LAN: " + name;
                    } else {
                        networkStatus = name;
                    }
                } else {
                    networkStatus = "OFF";
                }
            }
        }
        onRunningChanged: if (!running) running = false
    }

    // 4. TIMER UTAMA (Mengatur Sinkronisasi Jam, Judul Aplikasi, dan Jaringan)
    property int networkTick: 0
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            if (!niriFocusedWindow.running) niriFocusedWindow.running = true;

            const date = new Date();
            currentTime = date.toLocaleTimeString(Qt.locale("id_ID"), "HH:mm:ss");

            networkTick++;
            if (networkTick >= 4) {
                networkTick = 0;
                if (!checkNetwork.running) checkNetwork.running = true;
            }
        }
    }

    // 5. STRUKTUR TAMPILAN PANEL BAR (Tinggi Kunci 16px, Latar Belakang Hitam)
    PanelWindow {
        anchors { top: true; left: true; right: true }
        implicitHeight: 16
        color: "#111111"

        // SISI KIRI: Indikator Workspace & Judul Jendela Aktif
        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Row {
                spacing: 0
                Repeater {
                    model: niriIpc.list.length
                    delegate: Rectangle {
                        property var ws: niriIpc.list[index]
                        property bool isActive: ws.id === niriIpc.activeId

                        width: 14
                        height: 16
                        color: isActive ? "#eb0707" : "#333333"

                        Text {
                            anchors.centerIn: parent
                            text: (ws.idx ?? (index + 1)).toString()
                            color: parent.isActive ? "#ffffff" : "#888888"
                            font { pixelSize: 10; family: "JetBrains Mono"; bold: true }
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: niriIpc.activeTitle
                color: "#eeeeee"
                font { pixelSize: 10; family: "JetBrains Mono"; bold: true }
                renderType: Text.NativeRendering
            }
        }

        // SISI KANAN: Status Jaringan WIFI/LAN & Jam Digital
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: networkStatus !== "OFF" ? "    " + networkStatus : "    OFF"
                color: networkStatus !== "OFF" ? "#a6e3a1" : "#f38ba8"
                font { pixelSize: 10; family: "JetBrains Mono"; bold: true }
                renderType: Text.NativeRendering
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: currentTime
                color: "#ffffff"
                font { pixelSize: 10; family: "JetBrains Mono"; bold: true }
                renderType: Text.NativeRendering
            }
        }
    }
}
